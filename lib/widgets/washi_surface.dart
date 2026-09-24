import 'package:flutter/material.dart';

class WashiSurface extends StatelessWidget {
  const WashiSurface({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = 18,
    this.clipBehavior = Clip.antiAlias,
  });

  static const ink = Color(0xFF2E241D);
  static const mutedInk = Color(0xB32E241D);
  static const border = Color(0xFF8B6845);

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final themed = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        surface: const Color(0xFFFFF8EC),
        onSurface: ink,
        onSurfaceVariant: mutedInk,
      ),
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
      iconTheme: base.iconTheme.copyWith(color: ink),
      listTileTheme: base.listTileTheme.copyWith(
        textColor: ink,
        iconColor: ink,
        titleTextStyle: base.textTheme.titleMedium?.copyWith(color: ink),
        subtitleTextStyle: base.textTheme.bodyMedium?.copyWith(color: mutedInk),
      ),
      dividerColor: border.withValues(alpha: .28),
    );
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        image: const DecorationImage(
          image: AssetImage('assets/home/kabegami.png'),
          fit: BoxFit.cover,
          opacity: .9,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border.withValues(alpha: .72)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      clipBehavior: clipBehavior,
      child: Theme(
        data: themed,
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: ink),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}

class WashiCard extends StatelessWidget {
  const WashiCard({
    super.key,
    required this.child,
    this.clipBehavior = Clip.none,
    this.margin = const EdgeInsets.all(4),
  });

  final Widget child;
  final Clip clipBehavior;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) => WashiSurface(
        margin: margin,
        clipBehavior: clipBehavior == Clip.none ? Clip.antiAlias : clipBehavior,
        child: child,
      );
}
