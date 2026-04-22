import 'package:flutter/material.dart';
import '../utils/profix_colors.dart';
import '../utils/profix_theme.dart';

class ThemedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const ThemedContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? ProfixTheme.getSurfaceColor(isDark),
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          // تحسين الظل هنا ليكون أنعم في الـ Light Mode
          boxShadow: boxShadow ?? (isDark ? [] : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), // ظل خفيف جداً
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ]),
        ),
        child: child,
      ),
    );
  }
}

class ThemedSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const ThemedSection({
    super.key,
    required this.title,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14, // صغرنا الخط شوية لشكل أرق
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: isDark ? ProfixColors.gray2 : ProfixColors.mutedText,
              ),
            ),
          ),
          ThemedContainer(
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class ThemedDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;

  const ThemedDivider({
    super.key,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Divider(
      height: 1,
      thickness: 0.8, // خط أنحف
      indent: indent ?? 50,
      endIndent: endIndent ?? 15,
      color: ProfixTheme.getBorderColor(isDark).withValues(alpha: 0.5),
    );
  }
}

