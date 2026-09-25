import 'package:flutter/material.dart';

import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';
import 'travel_expense_screen.dart';

enum _Rounding { up, down }

class _BillItem {
  _BillItem({required this.name, required this.amount, required this.people});
  String name;
  int amount;
  Set<int> people;
}

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key, this.repository});
  final AppRepository? repository;

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final _totalController = TextEditingController();
  final _people = <TextEditingController>[
    TextEditingController(text: 'Aさん'),
    TextEditingController(text: 'Bさん'),
    TextEditingController(text: 'Cさん'),
  ];
  final _items = <_BillItem>[];
  _Rounding _rounding = _Rounding.up;

  @override
  void dispose() {
    _totalController.dispose();
    for (final controller in _people) {
      controller.dispose();
    }
    super.dispose();
  }

  int get _total => int.tryParse(_totalController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  String _personName(int index) {
    final name = _people[index].text.trim();
    return name.isEmpty ? '${index + 1}人目' : name;
  }

  int _divide(int amount, int count) {
    if (count <= 0) return 0;
    final value = amount / count;
    return _rounding == _Rounding.up ? value.ceil() : value.floor();
  }

  void _addPerson() {
    if (_people.length >= 20) return;
    setState(() => _people.add(TextEditingController(text: '${_people.length + 1}人目')));
  }

  void _removePerson(int index) {
    if (_people.length <= 1) return;
    setState(() {
      _people.removeAt(index).dispose();
      for (final item in _items) {
        item.people = item.people
            .where((person) => person != index)
            .map((person) => person > index ? person - 1 : person)
            .toSet();
      }
    });
  }

  Future<void> _addItem() async {
    final name = TextEditingController();
    final amount = TextEditingController();
    final result = await showDialog<_BillItem>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('商品を追加'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: '商品名')),
            const SizedBox(height: 10),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '金額（円）'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(amount.text.replaceAll(',', ''));
              if (name.text.trim().isEmpty || value == null || value <= 0) return;
              Navigator.pop(
                context,
                _BillItem(name: name.text.trim(), amount: value, people: <int>{}),
              );
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
    if (result != null && mounted) setState(() => _items.add(result));
  }

  List<int> _itemTotals() {
    final totals = List<int>.filled(_people.length, 0);
    for (final item in _items) {
      if (item.people.isEmpty) continue;
      final share = _divide(item.amount, item.people.length);
      for (final person in item.people) {
        if (person < totals.length) totals[person] += share;
      }
    }
    return totals;
  }

  Future<void> _registerExpense(int amount, String memo) async {
    final repository = widget.repository;
    if (repository == null || amount <= 0) return;
    final expense = await showExpenseEditorDialog(
      context,
      initialAmount: amount,
      initialMemo: memo,
      plans: repository.travelPlans,
    );
    if (expense == null) return;
    await repository.saveTravelExpense(expense);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('自分の支出として登録しました。')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final equalShare = _divide(_total, _people.length);
    final itemTotals = _itemTotals();
    return AppScaffold(
      title: '割り勘計算',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          WashiCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('1. 合計金額を入力', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _totalController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: '合計金額',
                      suffixText: '円',
                    ),
                  ),
                ],
              ),
            ),
          ),
          WashiCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('2. 人数を選ぶ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      IconButton(onPressed: _addPerson, tooltip: '人を追加', icon: const Icon(Icons.person_add_alt)),
                    ],
                  ),
                  for (var i = 0; i < _people.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _people[i],
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: '${i + 1}人目',
                          suffixIcon: _people.length == 1
                              ? null
                              : IconButton(onPressed: () => _removePerson(i), icon: const Icon(Icons.remove_circle_outline)),
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  SegmentedButton<_Rounding>(
                    segments: const [
                      ButtonSegment(value: _Rounding.up, label: Text('切り上げ')),
                      ButtonSegment(value: _Rounding.down, label: Text('切り捨て')),
                    ],
                    selected: {_rounding},
                    onSelectionChanged: (value) => setState(() => _rounding = value.first),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '均等割り: 1人 ${equalShare.toString()}円',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (_total > 0)
                    Text(
                      '合計との差: ${(equalShare * _people.length - _total).toString()}円',
                      textAlign: TextAlign.center,
                    ),
                  if (_total > 0 && widget.repository != null) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _registerExpense(
                        equalShare,
                        '割り勘（${_people.length}人）',
                      ),
                      icon: const Icon(Icons.savings_outlined),
                      label: Text('自分の支出 ${equalShare}円を登録'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          WashiCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('3. 商品ごとに分ける（任意）', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      IconButton(onPressed: _addItem, tooltip: '商品を追加', icon: const Icon(Icons.add_circle_outline)),
                    ],
                  ),
                  const Text('支払う人にチェックを付けると、その商品の金額を選択した人だけで割ります。'),
                  const SizedBox(height: 10),
                  if (_items.isEmpty) const Text('商品はまだありません。＋ボタンから追加できます。'),
                  for (var itemIndex = 0; itemIndex < _items.length; itemIndex++) ...[
                    const Divider(),
                    Row(
                      children: [
                        Expanded(child: Text('${_items[itemIndex].name}  ${_items[itemIndex].amount}円', style: const TextStyle(fontWeight: FontWeight.bold))),
                        IconButton(
                          onPressed: () => setState(() => _items.removeAt(itemIndex)),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (var person = 0; person < _people.length; person++)
                          FilterChip(
                            label: Text(_personName(person)),
                            selected: _items[itemIndex].people.contains(person),
                            onSelected: (selected) => setState(() {
                              if (selected) {
                                _items[itemIndex].people.add(person);
                              } else {
                                _items[itemIndex].people.remove(person);
                              }
                            }),
                          ),
                      ],
                    ),
                  ],
                  if (_items.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('商品別の支払額', style: TextStyle(fontWeight: FontWeight.bold)),
                    for (var i = 0; i < _people.length; i++)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.person_outline),
                        title: Text(_personName(i)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${itemTotals[i]}円', style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (itemTotals[i] > 0 && widget.repository != null)
                              IconButton(
                                tooltip: 'この金額を自分の支出へ登録',
                                onPressed: () => _registerExpense(
                                  itemTotals[i],
                                  '割り勘（${_personName(i)}）',
                                ),
                                icon: const Icon(Icons.savings_outlined),
                              ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
