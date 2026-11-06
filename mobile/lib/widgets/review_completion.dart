import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class ReviewCompletion extends StatelessWidget {
  final int total;
  const ReviewCompletion({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: c.primarySoft, shape: BoxShape.circle),
            child: Icon(Icons.check, size: 28, color: c.primary),
          ),
          const SizedBox(height: 16),
          Text('Session terminée', style: latinFont(size: 18, weight: FontWeight.w700, color: c.text)),
          const SizedBox(height: 6),
          Text('$total versets révisés', style: latinFont(size: 13.5, color: c.textMuted)),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: c.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: Text('Retour au tableau de bord', style: latinFont(size: 14, weight: FontWeight.w600, color: c.text)),
          ),
        ],
      ),
    );
  }
}
