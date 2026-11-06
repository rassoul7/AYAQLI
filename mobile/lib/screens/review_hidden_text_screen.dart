import 'package:flutter/material.dart';

import '../models/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/concept_chip.dart';
import '../widgets/dashed_card.dart';
import '../widgets/review_completion.dart';

class ReviewHiddenTextScreen extends StatefulWidget {
  const ReviewHiddenTextScreen({super.key});

  @override
  State<ReviewHiddenTextScreen> createState() => _ReviewHiddenTextScreenState();
}

class _ReviewHiddenTextScreenState extends State<ReviewHiddenTextScreen> {
  int _index = 0;
  bool _revealed = false;

  static const _queue = mockReviewQueue;

  void _next() {
    if (_index + 1 >= _queue.length) {
      setState(() => _index = _queue.length); // past-the-end => completion state
    } else {
      setState(() {
        _index++;
        _revealed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final done = _index >= _queue.length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: done ? ReviewCompletion(total: _queue.length) : _buildCard(c),
        ),
      ),
    );
  }

  Widget _buildCard(AppColors c) {
    final verse = _queue[_index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.border)),
                child: Icon(Icons.chevron_left, size: 20, color: c.text),
              ),
            ),
            Text('Texte masqué', style: latinFont(size: 16, weight: FontWeight.w600, color: c.text)),
            Text('${_index + 1}/${_queue.length}', style: latinFont(size: 13, color: c.textMuted)),
          ],
        ),
        const SizedBox(height: 20),
        Center(child: ConceptBadge(label: '${verse.concept} · ${verse.ref}')),
        const SizedBox(height: 28),
        Expanded(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => setState(() => _revealed = true),
              child: _revealed
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: c.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            verse.arabic,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: arabicFont(size: 30, color: c.text, height: 2.1),
                          ),
                          const SizedBox(height: 14),
                          Text(verse.translationFr, style: latinFont(size: 14, color: c.textMuted, height: 1.6)),
                        ],
                      ),
                    )
                  : DashedCard(
                      color: c.border,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.visibility_outlined, size: 26, color: c.textFaint),
                            const SizedBox(height: 12),
                            Text(
                              'Récitez de mémoire, puis touchez pour révéler',
                              textAlign: TextAlign.center,
                              style: latinFont(size: 13, color: c.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _GradeButton(label: 'Encore', enabled: true, onTap: _next)),
            const SizedBox(width: 8),
            Expanded(child: _GradeButton(label: 'Difficile', enabled: true, onTap: _next)),
            const SizedBox(width: 8),
            Expanded(child: _GradeButton(label: 'Bien', enabled: _revealed, onTap: _next)),
            const SizedBox(width: 8),
            Expanded(child: _GradeButton(label: 'Facile', enabled: _revealed, filled: true, onTap: _next)),
          ],
        ),
      ],
    );
  }
}

class _GradeButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool filled;
  final VoidCallback onTap;

  const _GradeButton({required this.label, required this.enabled, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final active = enabled;
    final bg = filled && active ? c.primary : Colors.transparent;
    final border = active ? c.border : c.border.withValues(alpha: 0.4);
    final textColor = filled && active ? c.onPrimary : (active ? c.text : c.textFaint);

    return GestureDetector(
      onTap: active ? onTap : null,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
        child: Text(label, textAlign: TextAlign.center, style: latinFont(size: 11.5, weight: FontWeight.w600, color: textColor)),
      ),
    );
  }
}

