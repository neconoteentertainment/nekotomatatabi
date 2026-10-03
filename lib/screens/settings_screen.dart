import 'package:flutter/material.dart';

import '../services/app_repository.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '設定',
      child: AnimatedBuilder(
        animation: repository,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            WashiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    leading: Icon(Icons.palette_outlined),
                    title: Text('色の選択'),
                    subtitle: Text('アプリ全体の配色を切り替えます。'),
                  ),
                  const Divider(height: 1),
                  for (final theme in AppColorTheme.values)
                    RadioListTile<AppColorTheme>(
                      value: theme,
                      groupValue: repository.colorTheme,
                      onChanged: (value) {
                        if (value != null) repository.setColorTheme(value);
                      },
                      title: Text(theme.label),
                      secondary: _ThemePreview(theme: theme),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            WashiCard(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.music_note),
                    title: const Text('BGM'),
                    subtitle: const Text('端末の消音設定とバックグラウンド停止を優先します。'),
                    value: repository.bgmEnabled,
                    onChanged: repository.setBgmEnabled,
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'umibe',
                    groupValue: repository.bgmTrack,
                    onChanged: repository.bgmEnabled
                        ? (value) {
                            if (value != null) repository.setBgmTrack(value);
                          }
                        : null,
                    title: const Text('海辺の朝'),
                    secondary: const Icon(Icons.waves_outlined),
                  ),
                  RadioListTile<String>(
                    value: 'odayaka',
                    groupValue: repository.bgmTrack,
                    onChanged: repository.bgmEnabled
                        ? (value) {
                            if (value != null) repository.setBgmTrack(value);
                          }
                        : null,
                    title: const Text('穏やかな朝'),
                    secondary: const Icon(Icons.wb_twilight_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: AdService.instance.privacyOptionsRequired,
              builder: (context, required, _) {
                if (!required) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: WashiCard(
                    child: ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('広告のプライバシー設定'),
                      subtitle: const Text('広告に関する同意内容を確認・変更します。'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final error =
                            await AdService.instance.showPrivacyOptions();
                        if (error != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message)),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            const WashiCard(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('アプリについて'),
                subtitle: Text('旅の記録・予定・スタンプなどのデータは端末内に保存されます。'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.theme});

  final AppColorTheme theme;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.forTheme(theme);
    return Container(
      width: 42,
      height: 28,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WashiSurface.border),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ColorDot(color: palette.panel),
          const SizedBox(width: 3),
          _ColorDot(color: palette.accent),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
