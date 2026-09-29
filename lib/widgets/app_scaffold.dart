import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'washi_surface.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions,
  });

  static const gold = Color(0xFFE6C28D);
  static const background = Color(0xFF171412);
  static const panel = Color(0xFF26211E);

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: gold,
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
    return WashiCard(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: AppScaffold.gold.withValues(alpha: .12),
          child: Icon(icon, color: AppScaffold.gold),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: WashiSurface.ink)),
        subtitle: subtitle == null ? null : Text(subtitle!, style: const TextStyle(color: WashiSurface.mutedInk)),
        trailing: const Icon(Icons.chevron_right, color: AppScaffold.gold),
        onTap: onTap,
      ),
    );
  }
}
