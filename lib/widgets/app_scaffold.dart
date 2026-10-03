import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'app_banner_ad.dart';
import 'washi_surface.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions,
    this.showAd = true,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final bool showAd;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: palette.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          backgroundColor: palette.background,
          foregroundColor: palette.onBackground,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: palette.onBackground,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: palette.accent,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.1,
                  ),
                ),
              ],
            ],
          ),
          actions: actions,
        ),
        body: SafeArea(child: child),
        bottomNavigationBar: showAd ? const AppBannerAd() : null,
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({super.key, required this.icon, required this.title, this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return WashiCard(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: palette.accent.withValues(alpha: .12),
          child: Icon(icon, color: palette.accent),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: WashiSurface.ink)),
        subtitle: subtitle == null ? null : Text(subtitle!, style: const TextStyle(color: WashiSurface.mutedInk)),
        trailing: Icon(Icons.chevron_right, color: palette.accent),
        onTap: onTap,
      ),
    );
  }
}
