import 'package:flutter/material.dart';

import '../models/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'review_fill_blank_screen.dart';
import 'review_hidden_text_screen.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Apprentissage', style: latinFont(size: 22, weight: FontWeight.w700, color: c.text)),
                const ThemeToggleButton(),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _StatCard(value: '${LearningStats.streakDays}', label: 'jours de série')),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(value: '${LearningStats.versesMastered}', label: 'versets maîtrisés')),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: c.primarySoft, borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PROCHAINE SESSION', style: latinFont(size: 13, weight: FontWeight.w600, color: c.primary)),
                  const SizedBox(height: 6),
                  Text(
                    '${LearningStats.nextSessionConcept} · ${LearningStats.nextSessionVerseCount} versets à réviser',
                    style: latinFont(size: 15, color: c.text),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: 'Commencer la révision',
                    height: 44,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReviewHiddenTextScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _ModeShortcut(
                    icon: Icons.visibility_off_outlined,
                    label: 'Texte masqué',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReviewHiddenTextScreen())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModeShortcut(
                    icon: Icons.abc,
                    label: 'Trou à compléter',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReviewFillBlankScreen())),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('EN COURS', style: monoFont(size: 11, weight: FontWeight.w600, color: c.textFaint, letterSpacing: 0.8)),
            const SizedBox(height: 10),
            for (final (title, pct) in LearningStats.inProgress) _ProgressRow(title: title, pct: pct),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: latinFont(size: 24, weight: FontWeight.w700, color: c.primary)),
          const SizedBox(height: 2),
          Text(label, style: latinFont(size: 12, color: c.textMuted)),
        ],
      ),
    );
  }
}

class _ModeShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ModeShortcut({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: c.border)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: c.text),
            const SizedBox(height: 4),
            Text(label, style: latinFont(size: 12, weight: FontWeight.w600, color: c.text)),
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String title;
  final double pct;
  const _ProgressRow({required this.title, required this.pct});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: c.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: latinFont(size: 13.5, weight: FontWeight.w600, color: c.text)),
              Text('${(pct * 100).round()}%', style: latinFont(size: 12, color: c.textMuted)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: c.border,
              valueColor: AlwaysStoppedAnimation(c.primary),
            ),
          ),
        ],
      ),
    );
  }
}
