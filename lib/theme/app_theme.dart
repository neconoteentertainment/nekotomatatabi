import 'package:flutter/material.dart';

enum AppColorTheme { classic, sakura, forest, autumn, winter }

extension AppColorThemeInfo on AppColorTheme {
  String get storageKey => switch (this) {
        AppColorTheme.classic => 'classic',
        AppColorTheme.sakura => 'sakura',
        AppColorTheme.forest => 'forest',
        AppColorTheme.autumn => 'autumn',
        AppColorTheme.winter => 'winter',
      };

  String get label => switch (this) {
        AppColorTheme.classic => 'ベーシック(黒)',
        AppColorTheme.sakura => '春(くすみ桜)',
        AppColorTheme.forest => '夏(深緑)',
        AppColorTheme.autumn => '秋(紅葉色)',
        AppColorTheme.winter => '冬(象牙色)',
      };
}

AppColorTheme appColorThemeFromStorage(String? value) => switch (value) {
      'forest' => AppColorTheme.forest,
      'sakura' => AppColorTheme.sakura,
      'autumn' => AppColorTheme.autumn,
      'winter' => AppColorTheme.winter,
      _ => AppColorTheme.classic,
    };

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.backgroundAlt,
    required this.panel,
    required this.accent,
    required this.onBackground,
    required this.onPanel,
    required this.onAccent,
    required this.brightness,
  });

  final Color background;
  final Color backgroundAlt;
  final Color panel;
  final Color accent;
  final Color onBackground;
  final Color onPanel;
  final Color onAccent;
  final Brightness brightness;

  static const classic = AppPalette(
    background: Color(0xFF171412),
    backgroundAlt: Color(0xFF201B18),
    panel: Color(0xFF26211E),
    accent: Color(0xFFE6C28D),
    onBackground: Color(0xFFF8F3ED),
    onPanel: Color(0xFFF8F3ED),
    onAccent: Color(0xFF241C17),
    brightness: Brightness.dark,
  );

  static const forest = AppPalette(
    background: Color(0xFF1E2B24),
    backgroundAlt: Color(0xFF26382E),
    panel: Color(0xFF2D4035),
    accent: Color(0xFFD8BE88),
    onBackground: Color(0xFFF5F0E5),
    onPanel: Color(0xFFF5F0E5),
    onAccent: Color(0xFF203027),
    brightness: Brightness.dark,
  );

  static const sakura = AppPalette(
    background: Color(0xFFD8B4B0),
    backgroundAlt: Color(0xFFC99DA2),
    panel: Color(0xFFE8CECB),
    accent: Color(0xFF7A4653),
    onBackground: Color(0xFF35242A),
    onPanel: Color(0xFF35242A),
    onAccent: Color(0xFFFFF8F7),
    brightness: Brightness.light,
  );

  static const autumn = AppPalette(
    background: Color(0xFF58252B),
    backgroundAlt: Color(0xFF6B3035),
    panel: Color(0xFF743A3D),
    accent: Color(0xFFE1B06A),
    onBackground: Color(0xFFFFF4E8),
    onPanel: Color(0xFFFFF4E8),
    onAccent: Color(0xFF352017),
    brightness: Brightness.dark,
  );

  static const winter = AppPalette(
    background: Color(0xFFE8E0D2),
    backgroundAlt: Color(0xFFD9D0C1),
    panel: Color(0xFFF7F1E7),
    accent: Color(0xFF607486),
    onBackground: Color(0xFF302C29),
    onPanel: Color(0xFF302C29),
    onAccent: Color(0xFFFFFBF4),
    brightness: Brightness.light,
  );

  static AppPalette forTheme(AppColorTheme theme) => switch (theme) {
        AppColorTheme.classic => classic,
        AppColorTheme.sakura => sakura,
        AppColorTheme.forest => forest,
        AppColorTheme.autumn => autumn,
        AppColorTheme.winter => winter,
      };

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? classic;

  @override
  AppPalette copyWith({
    Color? background,
    Color? backgroundAlt,
    Color? panel,
    Color? accent,
    Color? onBackground,
    Color? onPanel,
    Color? onAccent,
    Brightness? brightness,
  }) {
    return AppPalette(
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      panel: panel ?? this.panel,
      accent: accent ?? this.accent,
      onBackground: onBackground ?? this.onBackground,
      onPanel: onPanel ?? this.onPanel,
      onAccent: onAccent ?? this.onAccent,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  AppPalette lerp(covariant AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      backgroundAlt: Color.lerp(backgroundAlt, other.backgroundAlt, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onPanel: Color.lerp(onPanel, other.onPanel, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      brightness: t < .5 ? brightness : other.brightness,
    );
  }
}

ThemeData buildAppTheme(AppColorTheme colorTheme) {
  final palette = AppPalette.forTheme(colorTheme);
  final scheme = ColorScheme.fromSeed(
    seedColor: palette.accent,
    brightness: palette.brightness,
  ).copyWith(
    primary: palette.accent,
    onPrimary: palette.onAccent,
    surface: palette.panel,
    onSurface: palette.onPanel,
  );
  final base = ThemeData(colorScheme: scheme, useMaterial3: true);
  final textTheme = base.textTheme.apply(
    bodyColor: palette.onBackground,
    displayColor: palette.onBackground,
  );

  return base.copyWith(
    extensions: [palette],
    scaffoldBackgroundColor: palette.background,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: palette.background,
      foregroundColor: palette.onBackground,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: palette.panel,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: palette.accent.withValues(alpha: .38)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: palette.panel,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: palette.accent.withValues(alpha: .45)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: palette.accent.withValues(alpha: .45)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: palette.accent, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: palette.accent),
    ),
  );
}
