import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/models/travel_plan.dart';

void main() {
  test('従来の予定データはWebサイト未設定として読み込める', () {
    final item = TravelPlanItem.fromJson({
      'time': '09:30',
      'title': '朝市',
      'memo': '海鮮丼',
    });

    expect(item.siteTitle, isEmpty);
    expect(item.siteUrl, isEmpty);
    expect(item.sitePrefecture, isEmpty);
    expect(item.hasSite, isFalse);
  });

  test('予定項目のWebサイト情報をJSONで往復できる', () {
    const original = TravelPlanItem(
      time: '12:00',
      title: '猫カフェ',
      memo: '予約済み',
      siteTitle: '猫カフェ公式サイト',
      siteUrl: 'https://example.com/cat',
      sitePrefecture: '東京都',
    );

    final restored = TravelPlanItem.fromJson(original.toJson());
    expect(restored.siteTitle, original.siteTitle);
    expect(restored.siteUrl, original.siteUrl);
    expect(restored.sitePrefecture, original.sitePrefecture);
    expect(restored.hasSite, isTrue);
  });

  test('QR共有後も予定項目のWebサイト情報を保持する', () {
    final original = TravelPlan(
      id: 'plan-1',
      title: '東京旅行',
      date: DateTime(2026, 10, 7),
      items: const [
        TravelPlanItem(
          time: '15:00',
          title: '美術館',
          siteTitle: '美術館公式サイト',
          siteUrl: 'https://example.com/museum',
          sitePrefecture: '東京都',
        ),
      ],
    );

    final restored = TravelPlan.fromShareText(original.toShareText());
    expect(restored, isNotNull);
    expect(restored!.items.single.siteTitle, '美術館公式サイト');
    expect(restored.items.single.siteUrl, 'https://example.com/museum');
    expect(restored.items.single.sitePrefecture, '東京都');
  });
}
