import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../content/app_information.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';

enum AppInformationTopic { privacy, terms, contact, licenses }

extension AppInformationTopicLabel on AppInformationTopic {
  String get title => switch (this) {
        AppInformationTopic.privacy => 'プライバシーポリシー',
        AppInformationTopic.terms => '利用規約',
        AppInformationTopic.contact => 'お問い合わせ',
        AppInformationTopic.licenses => 'ライセンス・著作権表示',
      };

  IconData get icon => switch (this) {
        AppInformationTopic.privacy => Icons.privacy_tip_outlined,
        AppInformationTopic.terms => Icons.description_outlined,
        AppInformationTopic.contact => Icons.mail_outline,
        AppInformationTopic.licenses => Icons.copyright_outlined,
      };
}

class AppInformationScreen extends StatelessWidget {
  const AppInformationScreen({super.key, required this.topic});

  final AppInformationTopic topic;

  Future<void> _openLink(BuildContext context, Uri uri) async {
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } catch (_) {
      // 外部アプリがない端末でも説明画面を引き続き利用できるようにする。
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(uri.scheme == 'mailto'
            ? 'メールアプリを開けませんでした。メールアドレスをコピーしてご利用ください。'
            : 'ページを開けませんでした。通信環境をご確認ください。'),
      ),
    );
  }

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(
      const ClipboardData(text: AppInformation.contactEmail),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('メールアドレスをコピーしました。')),
    );
  }

  Widget _link(BuildContext context, String title, String address) {
    return ListTile(
      title: Text(title),
      subtitle: Text(address),
      trailing: const Icon(Icons.open_in_new, size: 20),
      onTap: () => _openLink(context, Uri.parse(address)),
    );
  }

  Widget _section(AppInformationSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: WashiSurface(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.heading,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(section.body, style: const TextStyle(height: 1.7)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = switch (topic) {
      AppInformationTopic.privacy => AppInformation.privacySections,
      AppInformationTopic.terms => AppInformation.termsSections,
      AppInformationTopic.licenses => AppInformation.licenseSections,
      AppInformationTopic.contact => const <AppInformationSection>[],
    };
    return AppScaffold(
      title: topic.title,
      fitTitle: true,
      subtitle: 'APP INFORMATION',
      showAd: false,
      child: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (topic != AppInformationTopic.contact)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text('最終更新日：${AppInformation.updatedAt}'),
              ),
            for (final section in sections) _section(section),
            if (topic == AppInformationTopic.privacy)
              WashiCard(
                child: Column(
                  children: [
                    _link(context, 'Google プライバシーポリシー',
                        'https://policies.google.com/privacy?hl=ja'),
                    _link(context, 'Googleによるアプリ・サイトの情報利用',
                        'https://policies.google.com/technologies/partner-sites?hl=ja'),
                    _link(context, 'OpenStreetMapのプライバシーポリシー',
                        'https://osmfoundation.org/wiki/Privacy_Policy'),
                    _link(context, 'Private.coffee（Overpass）のサービス情報',
                        'https://overpass.private.coffee/'),
                    _link(context, 'Overpass APIのサービス情報',
                        'https://overpass-api.de/'),
                    _link(context, '日本のOverpass APIのサービス情報',
                        'https://overpass.osm.jp/'),
                  ],
                ),
              ),
            if (topic == AppInformationTopic.contact) ...[
              _section(const AppInformationSection(
                'メールでのお問い合わせ',
                '不具合のご報告、ご意見、個人情報の取り扱いに関するご相談は、下記メールアドレスへご連絡ください。\n\n'
                '不具合の場合は、アプリのバージョン、端末の機種、OSのバージョン、発生した画面と操作内容を添えていただけると調査しやすくなります。予約番号や第三者の個人情報などは、必要な部分以外を伏せてください。',
              )),
              WashiSurface(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('お問い合わせ先',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text(AppInformation.contactEmail,
                        style: TextStyle(height: 1.6)),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      icon: const Icon(Icons.mail_outline),
                      label: const Text('メールを作成'),
                      onPressed: () => _openLink(
                        context,
                        Uri(
                          scheme: 'mailto',
                          path: AppInformation.contactEmail,
                          query: 'subject=${Uri.encodeComponent('ねことまた旅 お問い合わせ')}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: WashiSurface.ink,
                        side: const BorderSide(color: WashiSurface.border),
                      ),
                      icon: const Icon(Icons.copy_outlined),
                      label: const Text('メールアドレスをコピー'),
                      onPressed: () => _copyEmail(context),
                    ),
                    const SizedBox(height: 12),
                    const Text('アプリバージョン：${AppInformation.version}'),
                  ],
                ),
              ),
            ],
            if (topic == AppInformationTopic.licenses) ...[
              WashiCard(
                child: _link(context, 'OpenStreetMap 著作権・ライセンス',
                    'https://www.openstreetmap.org/copyright'),
              ),
              const SizedBox(height: 8),
              WashiCard(
                child: ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: const Text('ライブラリのライセンス'),
                  subtitle: const Text('オープンソースの著作権表示・ライセンス本文'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LicensePage(
                        applicationName: 'ねことまた旅',
                        applicationVersion: AppInformation.version,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
