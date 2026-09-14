import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';
import 'history_screen.dart';
import 'item_screen.dart';
import 'record_screen.dart';
import 'stamp_editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.repository});
  final AppRepository repository;

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ねことまた旅',
      child: AnimatedBuilder(
        animation: repository,
        builder: (context, _) {
          if (!repository.ready) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('猫と一緒に、旅の思い出を。', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('訪問 ${repository.memories.length}か所・${repository.points}P'),
                ]),
              ),
              const SizedBox(height: 14),
              MenuCard(icon: Icons.add_location_alt, title: '旅の思い出を記録する', subtitle: 'GPSで観光地を探して訪問を保存', onTap: () => _push(context, RecordScreen(repository: repository))),
              MenuCard(icon: Icons.photo_library_outlined, title: '過去の思い出を振り返る', subtitle: '日本地図・ピン・写真から振り返る', onTap: () => _push(context, HistoryScreen(repository: repository))),
              MenuCard(icon: Icons.pets, title: 'スタンプエディット', subtitle: '自分の猫などの透過画像を4個まで保存', onTap: () => _push(context, StampEditorScreen(repository: repository))),
              MenuCard(icon: Icons.card_giftcard, title: 'ご当地アイテムを確認', subtitle: '訪問ポイントでアイテムを解放', onTap: () => _push(context, ItemScreen(repository: repository))),
              MenuCard(icon: Icons.help_outline, title: 'アプリの使用方法', onTap: () => showDialog<void>(context: context, builder: (_) => const _HelpDialog())),
              MenuCard(icon: Icons.public, title: '制作者のHP', subtitle: 'URLは lib/app_config.dart で変更できます', onTap: () async {
                final uri = Uri.parse('https://example.com');
                if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('HPを開けませんでした。URL設定を確認してください。')));
                }
              }),
            ],
          );
        },
      ),
    );
  }
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog();
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('使い方'),
    content: const SingleChildScrollView(child: Text(
      '1. 「旅の思い出を記録する」で現在地を取得します。\n'
      '2. 周辺候補から訪問した場所を登録します。\n'
      '3. 「写真を撮る」で猫スタンプを重ねて撮影できます。\n'
      '4. スタンプは「スタンプエディット」で4個まで登録できます。\n'
      '5. 「過去の思い出を振り返る」で地図・都道府県・写真を確認できます。',
    )),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('閉じる'))],
  );
}
