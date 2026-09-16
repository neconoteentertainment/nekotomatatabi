import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_repository.dart';
import 'history_screen.dart';
import 'item_screen.dart';
import 'record_screen.dart';
import 'settings_screen.dart';
import 'stamp_editor_screen.dart';
import 'travel_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});
  final AppRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _gold = Color(0xFFE6C28D);
  static const _panel = Color(0xE6221C18);
  static const _background = Color(0xFF171412);

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
    await _pages.animateToPage(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = widget.repository;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, _) {
            if (!repository.ready) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const _HeroImage(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _VisitBar(
                    visits: repository.memories.length,
                    points: repository.points,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 286,
                  child: PageView(
                    controller: _pages,
                    onPageChanged: (value) => setState(() => _page = value),
                    children: [
                      _MenuPage.cards(
                        cards: [
                          _HomeCardData(
                            image: 'assets/home/card_record.jpg',
                            icon: Icons.location_on_outlined,
                            title: '旅の思い出を\n記録する',
                            subtitle: 'GPSで観光地を探して\n訪問を保存',
                            onTap: () => _push(RecordScreen(repository: repository)),
                          ),
                          _HomeCardData(
                            image: 'assets/home/card_history.jpg',
                            icon: Icons.photo_library_outlined,
                            title: '旅の思い出を\n振り返る',
                            subtitle: '日本地図・年月・写真\nから振り返る',
                            onTap: () => _push(HistoryScreen(repository: repository)),
                          ),
                          _HomeCardData(
                            image: 'assets/home/card_plan.jpg',
                            icon: Icons.calendar_month_outlined,
                            title: '旅の予定',
                            subtitle: '1日のスケジュール作成\nQR共有',
                            onTap: () => _push(TravelPlanScreen(repository: repository)),
                          ),
                        ],
                      ),
                      _MenuPage.cards(
                        cards: [
                          _HomeCardData(
                            image: 'assets/home/card_history.jpg',
                            icon: Icons.pets,
                            title: 'スタンプ\nエディット',
                            subtitle: '自分の猫などの画像を\n4個まで保存',
                            onTap: () => _push(StampEditorScreen(repository: repository)),
                          ),
                          _HomeCardData(
                            image: 'assets/home/card_record.jpg',
                            icon: Icons.card_giftcard_outlined,
                            title: 'ご当地アイテム\nを確認',
                            subtitle: '訪問ポイントで\nアイテムを解放',
                            onTap: () => _push(ItemScreen(repository: repository)),
                          ),
                          _HomeCardData(
                            image: 'assets/home/card_plan.jpg',
                            icon: Icons.settings_outlined,
                            title: '設定',
                            subtitle: 'アプリの設定・情報を\n確認',
                            onTap: () => _push(const SettingsScreen()),
                          ),
                        ],
                      ),
                      _MenuPage(
                        cards: [
                          _HomeFeatureCard(
                            data: _HomeCardData(
                              image: 'assets/home/card_history.jpg',
                              icon: Icons.help_outline,
                              title: 'アプリの\n使用方法',
                              subtitle: 'ねことまた旅の\n使い方を見る',
                              onTap: () => showDialog<void>(
                                context: context,
                                builder: (_) => const _HelpDialog(),
                              ),
                            ),
                          ),
                          _HomeFeatureCard(
                            data: _HomeCardData(
                              image: 'assets/home/card_record.jpg',
                              icon: Icons.public,
                              title: '制作者のHP',
                              subtitle: '最新情報を\n確認する',
                              onTap: () async {
                                final uri = Uri.parse('https://example.com');
                                if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('HPを開けませんでした。URL設定を確認してください。')),
                                  );
                                }
                              },
                            ),
                          ),
                          const _EmptyHomeCard(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _AdBanner(),
                ),
                const SizedBox(height: 12),
                _PageIndicator(
                  page: _page,
                  onPrevious: _page == 0 ? null : () => _movePage(-1),
                  onNext: _page == 2 ? null : () => _movePage(1),
                ),
                const SizedBox(height: 28),
              ],
            );
          },
        ),
      ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 941 / 610,
      child: Image.asset(
        'assets/home/hero.jpg',
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class _VisitBar extends StatelessWidget {
  const _VisitBar({required this.visits, required this.points});
  final int visits;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: _HomeScreenState._panel,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _HomeScreenState._gold.withOpacity(.9)),
      ),
      child: Row(
        children: [
          const Icon(Icons.pets, color: _HomeScreenState._gold, size: 27),
          const SizedBox(width: 12),
          Text(
            '訪問 $visits か所',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          Container(width: 1, height: 28, color: Colors.white24),
          const SizedBox(width: 18),
          const Icon(Icons.map_outlined, color: _HomeScreenState._gold),
          const SizedBox(width: 10),
          Text(
            '${points}P',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _HomeCardData {
  const _HomeCardData({
    required this.image,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String image;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _MenuPage extends StatelessWidget {
  const _MenuPage({required this.cards});
  final List<Widget> cards;

  _MenuPage.cards({required List<_HomeCardData> cards})
      : cards = cards.map((card) => _HomeFeatureCard(data: card)).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            Expanded(child: cards[i]),
            if (i != cards.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _HomeFeatureCard extends StatelessWidget {
  const _HomeFeatureCard({required this.data});
  final _HomeCardData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: data.onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xE625211E),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _HomeScreenState._gold.withOpacity(.62)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: [
                SizedBox(
                  height: 92,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(data.image, fit: BoxFit.cover),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xAA171412)],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.translate(
                          offset: const Offset(0, 17),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xE638302A),
                              shape: BoxShape.circle,
                              border: Border.all(color: _HomeScreenState._gold),
                            ),
                            child: Icon(data.icon, color: _HomeScreenState._gold, size: 27),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.86),
                      fontSize: 11.5,
                      height: 1.35,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _HomeScreenState._gold.withOpacity(.8)),
                  ),
                  child: const Icon(Icons.chevron_right, color: _HomeScreenState._gold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyHomeCard extends StatelessWidget {
  const _EmptyHomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x7A251F1B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _HomeScreenState._gold.withOpacity(.3)),
      ),
      child: const Center(
        child: Icon(Icons.pets, color: Colors.white24, size: 36),
      ),
    );
  }
}

class _AdBanner extends StatelessWidget {
  const _AdBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 873 / 168,
        child: Image.asset('assets/home/ad_banner.jpg', fit: BoxFit.cover),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.page, required this.onPrevious, required this.onNext});
  final int page;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    Widget button(IconData icon, VoidCallback? onPressed) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: onPressed == null ? Colors.white24 : _HomeScreenState._gold,
        style: IconButton.styleFrom(
          side: BorderSide(
            color: onPressed == null ? Colors.white12 : _HomeScreenState._gold.withOpacity(.8),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 58, height: 1, color: Colors.white24),
        const SizedBox(width: 14),
        button(Icons.chevron_left, onPrevious),
        const SizedBox(width: 14),
        Text(
          '${page + 1} / 3',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(width: 14),
        button(Icons.chevron_right, onNext),
        const SizedBox(width: 14),
        Container(width: 58, height: 1, color: Colors.white24),
      ],
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
            '6. 「旅の思い出を振り返る」で一覧・都道府県・年月から確認できます。',
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('閉じる'))],
      );
}
