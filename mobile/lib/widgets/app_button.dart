import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;

  const PrimaryButton({super.key, required this.label, required this.onPressed, this.height = 50});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? c.primary : c.surfaceAlt,
          foregroundColor: enabled ? c.onPrimary : c.textFaint,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: latinFont(size: 15, weight: FontWeight.w600, color: enabled ? c.onPrimary : c.textFaint)),
      ),
    );
  }
}

class OutlineAppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;

  const OutlineAppButton({super.key, required this.label, required this.onPressed, this.height = 46});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: c.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: latinFont(size: 15, weight: FontWeight.w600, color: c.textMuted)),
      ),
    );
  }
}
