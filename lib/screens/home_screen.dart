import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';
import 'history_screen.dart';
import 'item_screen.dart';
import 'record_screen.dart';
import 'stamp_editor_screen.dart';
import 'settings_screen.dart';
import 'travel_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});
  final AppRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pages = PageController();
  int _page = 0;

  void _push(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _movePage(int delta) async {
    final target = (_page + delta).clamp(0, 2).toInt();
    if (target == _page) return;
    await _pages.animateToPage(target, duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
  }

  Widget _menuPage(List<Widget> children) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(children: children),
      );

  @override
  Widget build(BuildContext context) {
    final repository = widget.repository;
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
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pets),
                    const SizedBox(width: 10),
                    Text('訪問 ${repository.memories.length}か所'),
                    const Spacer(),
                    Text('${repository.points}P', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 318,
                child: PageView(
                  controller: _pages,
                  onPageChanged: (value) => setState(() => _page = value),
                  children: [
                    _menuPage([
                      MenuCard(icon: Icons.add_location_alt, title: '旅の思い出を記録する', subtitle: 'GPSで観光地を探して訪問を保存', onTap: () => _push(RecordScreen(repository: repository))),
                      MenuCard(icon: Icons.photo_library_outlined, title: '旅の思い出を振り返る', subtitle: '日本地図・ピン・写真から振り返る', onTap: () => _push(HistoryScreen(repository: repository))),
                      MenuCard(icon: Icons.route, title: '旅の予定', subtitle: '1日のスケジュール作成・QR共有', onTap: () => _push(TravelPlanScreen(repository: repository))),
                    ]),
                    _menuPage([
                      MenuCard(icon: Icons.pets, title: 'スタンプエディット', subtitle: '自分の猫などの透過画像を4個まで保存', onTap: () => _push(StampEditorScreen(repository: repository))),
                      MenuCard(icon: Icons.card_giftcard, title: 'ご当地アイテムを確認', subtitle: '訪問ポイントでアイテムを解放', onTap: () => _push(ItemScreen(repository: repository))),
                      MenuCard(icon: Icons.settings_outlined, title: '設定', subtitle: 'アプリの設定・情報を確認', onTap: () => _push(const SettingsScreen())),
                    ]),
                    _menuPage([
                      MenuCard(icon: Icons.help_outline, title: 'アプリの使用方法', onTap: () => showDialog<void>(context: context, builder: (_) => const _HelpDialog())),
                      MenuCard(
                        icon: Icons.public,
                        title: '制作者のHP',
                        subtitle: '公開時にURLを設定してください',
                        onTap: () async {
                          final uri = Uri.parse('https://example.com');
                          if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('HPを開けませんでした。URL設定を確認してください。')));
                          }
                        },
                      ),
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(onPressed: _page == 0 ? null : () => _movePage(-1), icon: const Icon(Icons.chevron_left)),
                  const SizedBox(width: 12),
                  Text('${_page + 1} / 3'),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(onPressed: _page == 2 ? null : () => _movePage(1), icon: const Icon(Icons.chevron_right)),
                ],
              ),
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
        content: const SingleChildScrollView(
          child: Text(
            '1. 「旅の思い出を記録する」で現在地を取得します。\n'
            '2. 周辺候補から訪問した場所を登録します。\n'
            '3. 「写真を撮る」で猫スタンプや文字を複数重ねて撮影できます。\n'
            '4. スタンプは「スタンプエディット」で4個まで登録できます。\n'
            '5. 「旅の予定」で1日のスケジュールを作成し、QRコードで共有できます。\n'
            '6. 「旅の思い出を振り返る」で地図・都道府県・写真を確認できます。',
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('閉じる'))],
      );
}
