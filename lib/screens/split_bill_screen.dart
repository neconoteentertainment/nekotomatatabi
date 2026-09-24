import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../services/receipt_total_detector.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';

enum _Rounding { up, down }

class _BillItem {
  _BillItem({required this.name, required this.amount, required this.people});
  String name;
  int amount;
  Set<int> people;
}

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final _picker = ImagePicker();
  final _totalController = TextEditingController();
  final _people = <TextEditingController>[
    TextEditingController(text: 'Aさん'),
    TextEditingController(text: 'Bさん'),
    TextEditingController(text: 'Cさん'),
  ];
  final _items = <_BillItem>[];
  _Rounding _rounding = _Rounding.up;
  bool _recognizing = false;
  File? _receipt;

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

  Future<void> _selectReceipt(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 95);
    if (picked == null) return;
    setState(() {
      _receipt = File(picked.path);
      _recognizing = true;
    });

    try {
      if (!Platform.isAndroid && !Platform.isIOS) {
        throw UnsupportedError('文字認識はAndroid・iPhoneで利用できます。金額は手動入力してください。');
      }
      final recognizer = TextRecognizer(script: TextRecognitionScript.japanese);
      try {
        final result = await recognizer.processImage(InputImage.fromFilePath(picked.path));
        final recognizedLines = [
          for (final block in result.blocks)
            for (final line in block.lines) line,
        ];
        final amount = ReceiptTotalDetector.detect([
          for (final line in recognizedLines)
            ReceiptOcrLine(
              text: line.text,
              left: line.boundingBox.left,
              top: line.boundingBox.top,
              right: line.boundingBox.right,
              bottom: line.boundingBox.bottom,
            ),
        ]);
        final candidates = _findItems([
          for (final line in recognizedLines) line.text,
        ]);
        if (!mounted) return;
        setState(() {
          if (amount != null) _totalController.text = amount.toString();
          if (_items.isEmpty) _items.addAll(candidates);
        });
        if (amount == null) _message('合計金額を特定できませんでした。金額を手動で入力してください。');
      } finally {
        await recognizer.close();
      }
    } catch (e) {
      _message(e.toString().replaceFirst('Unsupported operation: ', ''));
    } finally {
      if (mounted) setState(() => _recognizing = false);
    }
  }

  List<int> _amountsIn(String line) {
    final values = <int>[];
    for (final match in RegExp(r'(?:¥|￥)?\s*([0-9][0-9,]{0,8})\s*(?:円)?').allMatches(line)) {
      final raw = match.group(1)?.replaceAll(',', '');
      final value = int.tryParse(raw ?? '');
      if (value != null && value > 0 && value < 100000000) values.add(value);
    }
    return values;
  }

  List<_BillItem> _findItems(List<String> lines) {
    final items = <_BillItem>[];
    for (final line in lines) {
      final normalized = line.replaceAll(' ', '').toLowerCase();
      if (normalized.contains('合計') || normalized.contains('total') || normalized.contains('お預') || normalized.contains('釣')) continue;
      final amounts = _amountsIn(line);
      if (amounts.isEmpty) continue;
      final amount = amounts.last;
      final name = line.replaceAll(RegExp(r'(?:¥|￥)?\s*[0-9][0-9,]{0,8}\s*(?:円)?'), '').trim();
      if (name.isEmpty) continue;
      items.add(_BillItem(name: name, amount: amount, people: <int>{}));
      if (items.length >= 30) break;
    }
    return items;
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
                  const Text('1. レシートを読み取る', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _recognizing ? null : () => _selectReceipt(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('撮影'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _recognizing ? null : () => _selectReceipt(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('画像を選ぶ'),
                        ),
                      ),
                    ],
                  ),
                  if (_recognizing) const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  if (_receipt != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_receipt!, height: 160, fit: BoxFit.cover),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: _totalController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: '合計金額（認識ミスの場合は修正）',
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
                  if (_items.isEmpty) const Text('商品はまだありません。レシート読取または＋ボタンから追加できます。'),
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
                        trailing: Text('${itemTotals[i]}円', style: const TextStyle(fontWeight: FontWeight.bold)),
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
