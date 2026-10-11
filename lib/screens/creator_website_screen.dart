import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';

class CreatorWebsiteScreen extends StatelessWidget {
  const CreatorWebsiteScreen({super.key});

  static final Uri _xUrl = Uri.parse('https://x.com/neconote_ent');
  static final Uri _appStoreUrl = Uri.parse(
    'https://apps.apple.com/jp/developer/mikinori-shimizu/id6802202898',
  );

  Future<void> _openUrl(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ページを開けませんでした。通信環境をご確認ください。')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppScaffold(
      title: '制作者のHP',
      subtitle: "CREATOR'S WEBSITE",
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          WashiSurface(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Xアカウントで今後の開発アプリを載せていきますので、\nフォローいただけると嬉しいです。',
              style: TextStyle(height: 1.6),
            ),
          ),
          const SizedBox(height: 12),
          _CreatorLinkCard(
            icon: Icons.alternate_email,
            title: 'Xアカウント',
            subtitle: '@neconote_ent',
            onTap: () => _openUrl(context, _xUrl),
          ),
          const SizedBox(height: 8),
          _CreatorLinkCard(
            icon: Icons.phone_iphone,
            title: 'App Store',
            subtitle: '公開中のアプリを見る',
            onTap: () => _openUrl(context, _appStoreUrl),
          ),
          const SizedBox(height: 8),
          WashiCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: palette.accent.withValues(alpha: .10),
                child: Icon(Icons.android, color: palette.accent.withValues(alpha: .55)),
              ),
              title: const Text('Google Play'),
              subtitle: const Text('開発中'),
              trailing: const Icon(Icons.lock_outline),
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatorLinkCard extends StatelessWidget {
  const _CreatorLinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return WashiCard(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: palette.accent.withValues(alpha: .12),
          child: Icon(icon, color: palette.accent),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.open_in_new, color: palette.accent),
        onTap: onTap,
      ),
    );
  }
}
