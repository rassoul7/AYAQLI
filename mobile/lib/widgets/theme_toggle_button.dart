import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => app.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.border)),
        child: Icon(isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined, size: 18, color: c.text),
      ),
    );
  }
}

/// Generic circular icon button matching the handoff's 36-38px circle style.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final bool tinted;

  const CircleIconButton({super.key, required this.icon, this.onTap, this.size = 36, this.tinted = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tinted ? c.primarySoft : Colors.transparent,
          border: Border.all(color: tinted ? Colors.transparent : c.border),
        ),
        child: Icon(icon, size: size * 0.5, color: tinted ? c.primary : c.text),
      ),
    );
  }
}
