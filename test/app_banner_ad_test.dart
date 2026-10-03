import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/widgets/app_banner_ad.dart';

void main() {
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('広告の読み込み前から表示領域の高さを確保する', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(bottomNavigationBar: AppBannerAd()),
      ),
    );

    expect(tester.getSize(find.byType(AppBannerAd)).height, 68);
  });

  testWidgets('広告の読み込み前でもページ本体を操作できる', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () => taps++,
              child: const Text('操作確認'),
            ),
          ),
          bottomNavigationBar: const AppBannerAd(),
        ),
      ),
    );

    await tester.tap(find.text('操作確認'));
    expect(taps, 1);
    expect(find.text('操作確認'), findsOneWidget);
  });
}
