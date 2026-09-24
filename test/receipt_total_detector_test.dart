import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/services/receipt_total_detector.dart';

ReceiptOcrLine line(String text, double left, double top, double right) =>
    ReceiptOcrLine(text: text, left: left, top: top, right: right, bottom: top + 20);

void main() {
  test('合計と同じ行の通貨付き金額を優先する', () {
    final result = ReceiptTotalDetector.detect([
      line('小計 ¥1,000', 10, 10, 200),
      line('消費税 ¥100', 10, 40, 200),
      line('税込合計 ¥1,100', 10, 70, 240),
      line('お預り ¥5,000', 10, 100, 220),
    ]);
    expect(result, 1100);
  });

  test('合計の右側に分離認識された金額を採用する', () {
    final result = ReceiptTotalDetector.detect([
      line('お支払合計', 10, 50, 100),
      line('￥2,480', 150, 50, 230),
    ]);
    expect(result, 2480);
  });

  test('合計キーワードがない場合は最大数値を自動確定しない', () {
    final result = ReceiptTotalDetector.detect([
      line('2026/09/24 15:30', 10, 10, 220),
      line('TEL 03-1234-5678', 10, 40, 220),
      line('¥9,999', 10, 70, 100),
    ]);
    expect(result, isNull);
  });
}
