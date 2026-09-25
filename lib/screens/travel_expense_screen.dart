import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/travel_expense.dart';
import '../models/travel_plan.dart';
import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';

String _yen(int value) {
  final digits = value.abs().toString();
  final parts = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    parts.add(digits.substring((end - 3).clamp(0, end).toInt(), end));
  }
  return '${value < 0 ? '-' : ''}${parts.reversed.join(',')}円';
}

String _dateText(DateTime date) =>
    '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';

Future<TravelExpense?> showExpenseEditorDialog(
  BuildContext context, {
  TravelExpense? original,
  int? initialAmount,
  String initialMemo = '',
  List<TravelPlan> plans = const [],
}) async {
  final amount = TextEditingController(
    text: (original?.amount ?? initialAmount)?.toString() ?? '',
  );
  final trip = TextEditingController(text: original?.tripName ?? '');
  final memo = TextEditingController(text: original?.memo ?? initialMemo);
  final planTitles = plans
      .map((plan) => plan.title.trim())
      .where((title) => title.isNotEmpty)
      .toSet()
      .toList();
  var category = original?.category ?? expenseCategories.first;
  var date = original?.date ?? DateTime.now();

  final result = await showDialog<TravelExpense>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setLocalState) => AlertDialog(
        title: Text(original == null ? '支出を登録' : '支出を編集'),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amount,
                  autofocus: original == null && initialAmount == null,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '金額',
                    suffixText: '円',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'カテゴリ'),
                  items: [
                    for (final value in expenseCategories)
                      DropdownMenuItem(value: value, child: Text(value)),
                  ],
                  onChanged: (value) {
                    if (value != null) setLocalState(() => category = value);
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (selected != null) setLocalState(() => date = selected);
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text('日付  ${_dateText(date)}'),
                ),
                const SizedBox(height: 12),
                if (planTitles.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    value: planTitles.contains(trip.text) ? trip.text : null,
                    decoration: const InputDecoration(labelText: '登録済みの旅の予定から選択'),
                    items: [
                      for (final title in planTitles)
                        DropdownMenuItem(value: title, child: Text(title)),
                    ],
                    onChanged: (value) {
                      if (value != null) trip.text = value;
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: trip,
                  decoration: const InputDecoration(
                    labelText: '旅の名前（任意）',
                    hintText: '例：名古屋日帰り旅行',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: memo,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'メモ（任意）'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(amount.text);
              if (value == null || value <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('金額を1円以上で入力してください。')),
                );
                return;
              }
              Navigator.pop(
                dialogContext,
                TravelExpense(
                  id: original?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
                  amount: value,
                  category: category,
                  date: date,
                  memo: memo.text.trim(),
                  tripName: trip.text.trim(),
                ),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    ),
  );
  amount.dispose();
  trip.dispose();
  memo.dispose();
  return result;
}

class TravelExpenseScreen extends StatefulWidget {
  const TravelExpenseScreen({super.key, required this.repository});
  final AppRepository repository;

  @override
  State<TravelExpenseScreen> createState() => _TravelExpenseScreenState();
}

class _TravelExpenseScreenState extends State<TravelExpenseScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> _edit([TravelExpense? original]) async {
    final expense = await showExpenseEditorDialog(
      context,
      original: original,
      plans: widget.repository.travelPlans,
    );
    if (expense != null) await widget.repository.saveTravelExpense(expense);
  }

  Future<void> _delete(TravelExpense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('支出を削除'),
        content: Text('${_dateText(expense.date)}の${_yen(expense.amount)}を削除しますか？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('削除')),
        ],
      ),
    );
    if (confirmed == true) await widget.repository.deleteTravelExpense(expense.id);
  }

  void _moveMonth(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '旅の支出記録',
      actions: [
        IconButton(
          onPressed: () => _edit(),
          tooltip: '支出を追加',
          icon: const Icon(Icons.add),
        ),
      ],
      child: AnimatedBuilder(
        animation: widget.repository,
        builder: (context, _) {
          final all = widget.repository.travelExpenses;
          final monthItems = all
              .where((e) => e.date.year == _month.year && e.date.month == _month.month)
              .toList();
          final total = monthItems.fold<int>(0, (sum, e) => sum + e.amount);
          final categoryTotals = <String, int>{};
          for (final expense in monthItems) {
            categoryTotals[expense.category] =
                (categoryTotals[expense.category] ?? 0) + expense.amount;
          }
          final tripGroups = <String, List<TravelExpense>>{};
          for (final expense in all) {
            final name = expense.tripName.isEmpty ? '未分類' : expense.tripName;
            tripGroups.putIfAbsent(name, () => []).add(expense);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              WashiCard(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      IconButton(onPressed: () => _moveMonth(-1), icon: const Icon(Icons.chevron_left)),
                      Expanded(
                        child: Text(
                          '${_month.year}年 ${_month.month}月',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(onPressed: () => _moveMonth(1), icon: const Icon(Icons.chevron_right)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              WashiCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('月の合計', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        _yen(total),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 24),
                      if (categoryTotals.isEmpty)
                        const Text('この月の支出はまだありません。'),
                      for (final category in expenseCategories)
                        if (categoryTotals.containsKey(category))
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                Expanded(child: Text(category)),
                                Text(
                                  _yen(categoryTotals[category]!),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text('この月の支出', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  FilledButton.icon(
                    onPressed: () => _edit(),
                    icon: const Icon(Icons.add),
                    label: const Text('追加'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (monthItems.isEmpty)
                const WashiCard(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text('右上の＋または「追加」から支出を登録できます。'),
                  ),
                ),
              for (final expense in monthItems)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: WashiCard(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(expense.category.substring(0, 1))),
                      title: Text(
                        _yen(expense.amount),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text([
                        _dateText(expense.date),
                        expense.category,
                        if (expense.tripName.isNotEmpty) expense.tripName,
                        if (expense.memo.isNotEmpty) expense.memo,
                      ].join('  ・  ')),
                      isThreeLine: expense.memo.isNotEmpty,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) => value == 'edit' ? _edit(expense) : _delete(expense),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('編集')),
                          PopupMenuItem(value: 'delete', child: Text('削除')),
                        ],
                      ),
                    ),
                  ),
                ),
              if (tripGroups.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('旅ごとの合計', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                for (final entry in tripGroups.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: WashiCard(
                      child: ExpansionTile(
                        leading: const Icon(Icons.luggage_outlined),
                        title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${entry.value.length}件'),
                        trailing: Text(
                          _yen(entry.value.fold<int>(0, (sum, e) => sum + e.amount)),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: [
                          for (final expense in entry.value)
                            ListTile(
                              dense: true,
                              title: Text('${_dateText(expense.date)}  ${expense.category}'),
                              subtitle: expense.memo.isEmpty ? null : Text(expense.memo),
                              trailing: Text(_yen(expense.amount)),
                              onTap: () => _edit(expense),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
