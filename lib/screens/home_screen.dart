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
              return LayoutBuilder(
                builder: (context, constraints) {
                  final height = constraints.maxHeight;
                  final compact = height < 720;
                  final heroFlex = compact ? 27 : 31;
                  final menuFlex = compact ? 29 : 32;
                  return Column(
                    children: [
                      Expanded(flex: heroFlex, child: const _HeroImage()),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, compact ? 6 : 10, 16, 0),
                        child: _VisitBar(
                          visits: repository.uniqueVisitCount,
                          compact: compact,
                        ),
                      ),
                      SizedBox(height: compact ? 6 : 10),
                      Expanded(
                        flex: menuFlex,
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
                                  image: 'assets/home/card_stamp.png',
                                  imageAlignment: Alignment.center,
                                  icon: Icons.pets,
                                  title: 'スタンプ\nエディット',
                                  subtitle: 'お気に入りの猫画像を\n4個まで登録',
                                  onTap: () => _push(StampEditorScreen(repository: repository)),
                                ),
                                _HomeCardData(
                                  image: 'assets/home/card_local.png',
                                  imageAlignment: Alignment.center,
                                  icon: Icons.card_giftcard_outlined,
                                  title: 'ご当地アイテム\nを確認',
                                  subtitle: '旅先で集めたポイントで\nご当地アイテムを解放',
                                  onTap: () => _push(ItemScreen(repository: repository)),
                                ),
                                _HomeCardData(
                                  image: 'assets/home/card_settings.png',
                                  imageAlignment: Alignment.center,
                                  icon: Icons.tune,
                                  title: '設定',
                                  subtitle: 'アプリの情報や\n各種設定を確認',
                                  onTap: () => _push(SettingsScreen(repository: repository)),
                                ),
                              ],
                            ),
                            _MenuPage(
                              cards: [
                                _HomeFeatureCard(
                                  data: _HomeCardData(
                                    image: 'assets/home/card_help.png',
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
                                    image: 'assets/home/card_hp.png',
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
                      SizedBox(height: compact ? 6 : 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: compact ? 50 : 62,
                          child: const _AdBanner(),
                        ),
                      ),
                      SizedBox(height: compact ? 5 : 8),
                      SizedBox(
                        height: compact ? 42 : 48,
                        child: _PageIndicator(
                          page: _page,
                          onPrevious: _page == 0 ? null : () => _movePage(-1),
                          onNext: _page == 2 ? null : () => _movePage(1),
                        ),
                      ),
                      SizedBox(height: compact ? 4 : 10),
                    ],
                  );
                },
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
    return SizedBox.expand(
      child: Image.asset(
        'assets/home/hero.jpg',
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class _VisitBar extends StatelessWidget {
  const _VisitBar({required this.visits, required this.compact});
  final int visits;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 48 : 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: _HomeScreenState._panel,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _HomeScreenState._gold.withOpacity(.9)),
      ),
      child: Row(
        children: [
          Icon(Icons.pets, color: _HomeScreenState._gold, size: compact ? 23 : 27),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '今までに訪れた観光地  $visits 箇所',
              style: TextStyle(color: Colors.white, fontSize: compact ? 14 : 17, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
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
    this.imageAlignment = Alignment.center,
    this.badge,
  });
  final String image;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Alignment imageAlignment;
  final String? badge;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 235;
        final imageHeight = compact ? 58.0 : 84.0;
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
                      height: imageHeight,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(data.image, fit: BoxFit.cover, alignment: data.imageAlignment),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0xCC171412)],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Transform.translate(
                              offset: Offset(0, compact ? 13 : 16),
                              child: Container(
                                width: compact ? 42 : 50,
                                height: compact ? 42 : 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xF038302A),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _HomeScreenState._gold),
                                ),
                                child: Icon(data.icon, color: _HomeScreenState._gold, size: compact ? 22 : 26),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 18 : 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 13 : 15,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 3 : 6),
                    if (!compact)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          data.subtitle,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withOpacity(.84), fontSize: 10.5, height: 1.3),
                        ),
                      ),
                    const Spacer(),
                    Container(
                      width: compact ? 30 : 36,
                      height: compact ? 30 : 36,
                      margin: EdgeInsets.only(bottom: compact ? 7 : 10),
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
      },
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
      child: const Center(child: Icon(Icons.pets, color: Colors.white24, size: 36)),
    );
  }
}

class _AdBanner extends StatelessWidget {
  const _AdBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox.expand(
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
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        icon: Icon(icon),
        color: onPressed == null ? Colors.white24 : _HomeScreenState._gold,
        style: IconButton.styleFrom(
          side: BorderSide(color: onPressed == null ? Colors.white12 : _HomeScreenState._gold.withOpacity(.8)),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 42, height: 1, color: Colors.white24),
        const SizedBox(width: 10),
        button(Icons.chevron_left, onPrevious),
        const SizedBox(width: 10),
        Text('${page + 1} / 3', style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(width: 10),
        button(Icons.chevron_right, onNext),
        const SizedBox(width: 10),
        Container(width: 42, height: 1, color: Colors.white24),
      ],
    );
  }
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog();
  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF241F1C),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _HomeScreenState._gold.withOpacity(.55)),
        ),
        title: const Text('アプリの使用方法', style: TextStyle(color: Colors.white)),
        content: const SingleChildScrollView(
          child: Text(
            '1. 「旅の思い出を記録する」で現在地を取得します。\n\n'
            '2. 周辺候補から訪問した場所を登録します。\n\n'
            '3. 「写真を撮る」で猫スタンプや文字を複数重ねて撮影できます。\n\n'
            '4. スタンプは「スタンプエディット」で4個まで登録できます。\n\n'
            '5. 「旅の予定」で1日のスケジュールを作成し、QRコードで共有できます。\n\n'
            '6. 「旅の思い出を振り返る」で一覧・都道府県・年月から確認できます。',
            style: TextStyle(color: Colors.white70, height: 1.55),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる', style: TextStyle(color: _HomeScreenState._gold)),
          ),
        ],
      );
}
