import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/screens/split_bill_screen.dart';

void main() {
  testWidgets('割り勘画面は3人で均等計算できる', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplitBillScreen()),
    );

    expect(find.text('割り勘計算'), findsOneWidget);
    expect(find.text('Aさん'), findsOneWidget);
    expect(find.text('Bさん'), findsOneWidget);
    expect(find.text('Cさん'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '4860');
    await tester.pump();

    expect(find.text('均等割り: 1人 1620円'), findsOneWidget);
  });
}
