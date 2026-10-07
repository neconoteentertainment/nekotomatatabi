import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/theme/app_theme.dart';

void main() {
  test('5種類の配色は異なる背景色を持つ', () {
    final backgrounds = AppColorTheme.values
        .map((theme) => AppPalette.forTheme(theme).background)
        .toSet();

    expect(backgrounds.length, 5);
  });

  test('設定画面用の季節テーマ順と名称が仕様どおり', () {
    expect(
      AppColorTheme.values.map((theme) => theme.label).toList(),
      [
        'ベーシック(黒)',
        '春(くすみ桜)',
        '夏(深緑)',
        '秋(紅葉色)',
        '冬(象牙色)',
      ],
    );
  });

  test('配色ごとにホーム画面の画像が割り当てられる', () {
    expect(AppColorTheme.classic.heroAssetPath, 'assets/home/hero.jpg');
    expect(AppColorTheme.sakura.heroAssetPath, 'assets/home/hero_spring.jpg');
    expect(AppColorTheme.forest.heroAssetPath, 'assets/home/hero_summer.jpg');
    expect(AppColorTheme.autumn.heroAssetPath, 'assets/home/hero_autumn.jpg');
    expect(AppColorTheme.winter.heroAssetPath, 'assets/home/hero_winter.jpg');
  });

  test('保存値から配色を復元し、不明値は従来色へ戻す', () {
    expect(appColorThemeFromStorage('classic'), AppColorTheme.classic);
    expect(appColorThemeFromStorage('forest'), AppColorTheme.forest);
    expect(appColorThemeFromStorage('sakura'), AppColorTheme.sakura);
    expect(appColorThemeFromStorage('autumn'), AppColorTheme.autumn);
    expect(appColorThemeFromStorage('winter'), AppColorTheme.winter);
    expect(appColorThemeFromStorage('unknown'), AppColorTheme.classic);
    expect(appColorThemeFromStorage(null), AppColorTheme.classic);
  });

  test('明るい季節テーマのホームバッジは明るい前景色を使う', () {
    expect(AppPalette.sakura.homeBadgeForeground, AppPalette.sakura.onAccent);
    expect(AppPalette.winter.homeBadgeForeground, AppPalette.winter.onAccent);
    expect(AppPalette.classic.homeBadgeForeground, AppPalette.classic.accent);
    expect(AppPalette.forest.homeBadgeForeground, AppPalette.forest.accent);
    expect(AppPalette.autumn.homeBadgeForeground, AppPalette.autumn.accent);
  });
}
