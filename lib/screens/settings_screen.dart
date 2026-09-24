import 'package:flutter/material.dart';

import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';

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
            Card(
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
            const Card(
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
