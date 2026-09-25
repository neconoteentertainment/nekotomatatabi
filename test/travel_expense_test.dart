import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/models/travel_expense.dart';

void main() {
  test('旅の支出をJSONへ保存して復元できる', () {
    final original = TravelExpense(
      id: 'expense-1',
      amount: 24800,
      category: '食事',
      date: DateTime(2026, 9, 25),
      memo: '夕食',
      tripName: '名古屋旅行',
    );

    final restored = TravelExpense.fromJson(original.toJson());

    expect(restored.id, original.id);
    expect(restored.amount, 24800);
    expect(restored.category, '食事');
    expect(restored.date, DateTime(2026, 9, 25));
    expect(restored.memo, '夕食');
    expect(restored.tripName, '名古屋旅行');
  });
}
