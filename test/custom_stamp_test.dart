import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/models/custom_stamp.dart';

void main() {
  test('登録できる自作スタンプは5枠', () {
    expect(customStampSlotCount, 5);
  });
}
