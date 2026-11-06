import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Small-caps monospace chip for concept/tag labels (Figma-inspired accent
/// layered on top of the Claude design system's pill shape).
class ConceptChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const ConceptChip({super.key, required this.label, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? c.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? c.primary : c.border),
        ),
        child: Text(
          label.toUpperCase(),
          style: monoFont(
            size: 11,
            weight: FontWeight.w600,
            letterSpacing: 0.6,
            color: active ? c.onPrimary : c.textMuted,
          ),
        ),
      ),
    );
  }
}

/// Small pill badge (non-interactive) used on verse cards / headers.
class ConceptBadge extends StatelessWidget {
  final String label;
  const ConceptBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.primarySoft, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label.toUpperCase(),
        style: monoFont(size: 10.5, weight: FontWeight.w600, letterSpacing: 0.5, color: c.primary),
      ),
    );
  }
}
