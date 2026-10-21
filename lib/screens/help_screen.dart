import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _topics = <_HelpTopic>[
    _HelpTopic(
      title: '旅の思い出を記録する',
      subtitle: '観光地の登録と写真撮影',
      icon: Icons.add_location_alt_outlined,
      kind: _HelpKind.record,
    ),
    _HelpTopic(
      title: '旅の思い出を振り返る',
      subtitle: '保存した観光地と写真の確認',
      icon: Icons.photo_library_outlined,
      kind: _HelpKind.review,
    ),
    _HelpTopic(
      title: '旅の予定を立てる',
      subtitle: '予定作成とQR共有',
      icon: Icons.calendar_month_outlined,
      kind: _HelpKind.plan,
    ),
    _HelpTopic(
      title: '旅の手助け',
      subtitle: 'チケット・お気に入り・支出記録',
      icon: Icons.backpack_outlined,
      kind: _HelpKind.assist,
    ),
    _HelpTopic(
      title: 'スタンプ登録',
      subtitle: 'カメラ用スタンプの登録',
      icon: Icons.pets_outlined,
      kind: _HelpKind.stamp,
    ),
    _HelpTopic(
      title: '名産品集め',
      subtitle: 'ポイントとスタンプ獲得',
      icon: Icons.card_giftcard_outlined,
      kind: _HelpKind.items,
    ),
    _HelpTopic(
      title: '設定・アプリ情報',
      subtitle: '背景色と音楽の変更',
      icon: Icons.tune_outlined,
      kind: _HelpKind.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'アプリの使用方法',
      subtitle: 'HOW TO USE',
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _topics.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return MenuCard(
            icon: topic.icon,
            title: topic.title,
            subtitle: topic.subtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => _HelpDetailScreen(topic: topic)),
            ),
          );
        },
      ),
    );
  }
}

class _HelpDetailScreen extends StatelessWidget {
  const _HelpDetailScreen({required this.topic});

  final _HelpTopic topic;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: topic.title,
      subtitle: switch (topic.kind) {
        _HelpKind.record => 'MEMORIES OF JOURNEYS',
        _HelpKind.review => 'CAPTURE YOUR JOURNEY',
        _ => 'HOW TO USE',
      },
      child: switch (topic.kind) {
        _HelpKind.record => const _RecordHelp(),
        _HelpKind.review => const _ReviewHelp(),
        _HelpKind.plan => const _TextAndImageHelp(
            paragraphs: [
              '旅の予定を立て、友達や家族と共有できます。',
              '「新しい予定を作る」ボタンから予定名と日付を設定し、1日のスケジュール下の「予定を追加」ボタンで詳細なスケジュールを設定できます。',
              '「旅の手助け」－「お気に入りのサイト」に登録している情報があれば、予定内にリンクを埋め込むことが可能です。',
              '設定した旅の予定は「QR共有」ボタンを押すことで、QRコードにして他の人と共有できます。',
              '右上のQRボタンを押すことで、他の人の立てた予定を読み込むことができます。',
            ],
            assetPath: 'assets/help/travel_plan.jpg',
          ),
        _HelpKind.assist => const _TextAndImageHelp(
            paragraphs: [
              '「電子チケットの保存」では、スマホ内の写真データを取り込むことができます。バスの予約番号やQRコードなど、スクリーンショットで保存しているデータの保存にご活用ください。',
              '「お気に入りのサイト」は、ホームページなど観光地のWebページを保存できます。iPhoneはSafari、AndroidはChromeなどの共有ボタンから「ねことまた旅」を選び、サイト名と保存先を確認して登録してください。登録情報はQRコードを使って、友達などと共有することも可能です。',
              '「旅の支出記録」では、旅・月ごとで使用した支出記録をつけることができます。',
            ],
            assetPath: 'assets/help/travel_assist.jpg',
          ),
        _HelpKind.stamp => const _TextAndImageHelp(
            paragraphs: [
              'スタンプを登録し、「旅の思い出を記録する」のカメラ機能で使うことができます。',
              'ペットの猫や犬、好きなキャラクターの写真を生成AIなどを使って背景を透過にしたうえで登録してください。',
            ],
            assetPath: 'assets/help/stamp_editor.jpg',
          ),
        _HelpKind.items => const _TextAndImageHelp(
            paragraphs: [
              '「旅の思い出を記録する」で登録した観光地の数に応じてポイントが付与されます。',
              'ポイントが貯まることで、カメラ機能で使えるスタンプを獲得できます。',
              'スタンプは各都道府県の名産品になっているので、たくさん集めて、その土地をめぐる楽しみにしてください。',
            ],
            assetPath: 'assets/help/local_items.jpg',
          ),
        _HelpKind.settings => const _TextAndImageHelp(
            paragraphs: [
              'アプリの背景色、音楽を変更できます。',
              '春夏秋冬や気分に合わせて変更してください。',
            ],
            assetPath: 'assets/help/settings.jpg',
          ),
        null => const _ComingSoonHelp(),
      },
    );
  }
}

class _TextAndImageHelp extends StatelessWidget {
  const _TextAndImageHelp({required this.paragraphs, required this.assetPath});

  final List<String> paragraphs;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        WashiCard(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < paragraphs.length; index++) ...[
                  Text(paragraphs[index], style: const TextStyle(height: 1.65)),
                  if (index < paragraphs.length - 1) const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _InstructionScreenshot(assetPath),
      ],
    );
  }
}

class _RecordHelp extends StatelessWidget {
  const _RecordHelp();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        WashiCard(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle('① 観光地を記録する'),
                SizedBox(height: 10),
                Text(
                  '「現在地から周辺を探す」で周辺の観光地情報を取得します。'
                  '表示されない場合は、手入力もできます。',
                  style: TextStyle(height: 1.65),
                ),
                SizedBox(height: 22),
                Divider(height: 1),
                SizedBox(height: 22),
                _SectionTitle('② 写真を撮る'),
                SizedBox(height: 10),
                Text(
                  '最新の訪問地に①で選んだ観光地が表示されたら、'
                  '「写真を撮る」で旅の思い出を記録してください。\n\n'
                  'カメラでは、「スタンプ登録」で登録したスタンプを使用できます。',
                  style: TextStyle(height: 1.65),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14),
        _InstructionScreenshot('assets/help/record_memories.jpg'),
      ],
    );
  }
}

class _ReviewHelp extends StatelessWidget {
  const _ReviewHelp();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        WashiCard(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              '「旅の思い出を記録する」で登録した観光地や写真を振り返ることができます。\n\n'
              '「一覧」ではすべての記録から、「日本地図」では記録した都道府県から、'
              '「年月」では記録した年月から旅の思い出を探せます。\n\n'
              'スマホから写真を取り込んだり、写真をスマホに保存したりできます。'
              '友達や家族など、いろいろな人と共有してください。',
              style: TextStyle(height: 1.65),
            ),
          ),
        ),
        SizedBox(height: 14),
        _InstructionScreenshot('assets/help/review_memories.jpg'),
      ],
    );
  }
}

class _ComingSoonHelp extends StatelessWidget {
  const _ComingSoonHelp();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        WashiCard(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.hourglass_empty, size: 42),
                SizedBox(height: 14),
                Text(
                  '説明は現在準備中です。\n今後のアップデートで追加予定です。',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.6, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class _InstructionScreenshot extends StatelessWidget {
  const _InstructionScreenshot(this.assetPath);

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return WashiSurface(
      padding: const EdgeInsets.all(8),
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: .87,
          child: Image.asset(assetPath, width: double.infinity, fit: BoxFit.fitWidth),
        ),
      ),
    );
  }
}

enum _HelpKind { record, review, plan, assist, stamp, items, settings }

class _HelpTopic {
  const _HelpTopic({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.kind,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final _HelpKind? kind;
}
