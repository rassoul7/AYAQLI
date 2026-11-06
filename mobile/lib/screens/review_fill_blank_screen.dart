import 'package:flutter/material.dart';

import '../models/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/concept_chip.dart';
import '../widgets/review_completion.dart';

class ReviewFillBlankScreen extends StatefulWidget {
  const ReviewFillBlankScreen({super.key});

  @override
  State<ReviewFillBlankScreen> createState() => _ReviewFillBlankScreenState();
}

class _ReviewFillBlankScreenState extends State<ReviewFillBlankScreen> {
  int _index = 0;
  String? _selected;

  static const _queue = mockReviewQueue;

  void _select(String option) {
    if (_selected != null) return;
    setState(() => _selected = option);
  }

  void _next() {
    if (_index + 1 >= _queue.length) {
      setState(() => _index = _queue.length);
    } else {
      setState(() {
        _index++;
        _selected = null;
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
    final words = verse.arabicWords;

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
            Text('Trou à compléter', style: latinFont(size: 16, weight: FontWeight.w600, color: c.text)),
            Text('${_index + 1}/${_queue.length}', style: latinFont(size: 13, color: c.textMuted)),
          ],
        ),
        const SizedBox(height: 20),
        Center(child: ConceptBadge(label: '${verse.concept} · ${verse.ref}')),
        const SizedBox(height: 28),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: c.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: [
                        for (var i = 0; i < words.length; i++)
                          TextSpan(
                            text: i == verse.blankWordIndex ? (_selected != null ? '${words[i]} ' : '____ ') : '${words[i]} ',
                            style: arabicFont(size: 27, color: c.text, height: 2).copyWith(
                              color: i == verse.blankWordIndex && _selected != null ? c.primary : c.text,
                              decoration: i == verse.blankWordIndex && _selected != null ? TextDecoration.underline : null,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    verse.translationFr.replaceFirst(RegExp(r'\w+'), '___'),
                    style: latinFont(size: 14, color: c.textMuted, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final option in verse.blankOptions) ...[
          _OptionButton(
            label: option,
            state: _selected == null
                ? _OptionState.neutral
                : option == verse.blankWord
                    ? _OptionState.correct
                    : option == _selected
                        ? _OptionState.wrong
                        : _OptionState.neutral,
            onTap: () => _select(option),
          ),
          const SizedBox(height: 8),
        ],
        if (_selected != null) ...[
          const SizedBox(height: 8),
          PrimaryButton(label: 'Suivant', onPressed: _next, height: 46),
        ],
      ],
    );
  }
}

enum _OptionState { neutral, correct, wrong }

class _OptionButton extends StatelessWidget {
  final String label;
  final _OptionState state;
  final VoidCallback onTap;

  const _OptionButton({required this.label, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Color bg = Colors.transparent;
    Color border = c.border;
    Color text = c.text;

    switch (state) {
      case _OptionState.neutral:
        break;
      case _OptionState.correct:
        bg = c.primarySoft;
        border = c.primary;
        text = c.primary;
        break;
      case _OptionState.wrong:
        bg = c.wrongAnswer.withValues(alpha: 0.12);
        border = c.wrongAnswer;
        text = c.wrongAnswer;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border, width: 1.5)),
        child: Text(label, style: arabicFont(size: 15, weight: FontWeight.w600, color: text)),
      ),
    );
  }
}
