import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/theme/app_theme.dart';

void main() {
  test('3種類の配色は異なる背景色を持つ', () {
    final backgrounds = AppColorTheme.values
        .map((theme) => AppPalette.forTheme(theme).background)
        .toSet();

    expect(backgrounds.length, 3);
  });

  test('保存値から配色を復元し、不明値は従来色へ戻す', () {
    expect(appColorThemeFromStorage('classic'), AppColorTheme.classic);
    expect(appColorThemeFromStorage('forest'), AppColorTheme.forest);
    expect(appColorThemeFromStorage('sakura'), AppColorTheme.sakura);
    expect(appColorThemeFromStorage('unknown'), AppColorTheme.classic);
    expect(appColorThemeFromStorage(null), AppColorTheme.classic);
  });
}
