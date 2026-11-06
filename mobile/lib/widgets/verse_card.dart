import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/verse.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'concept_chip.dart';

class VerseCard extends StatelessWidget {
  final Verse verse;
  final Translation? highlightedTranslation;
  final String? concept;
  final VoidCallback onTap;

  const VerseCard({
    super.key,
    required this.verse,
    required this.onTap,
    this.highlightedTranslation,
    this.concept,
  });

  String get _verseId => '${verse.surah.number}:${verse.numberInSurah}';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    final translation = highlightedTranslation ?? (verse.translations.isEmpty ? null : verse.translations.first);
    final isThisPlaying = app.playingVerseId == _verseId && app.isPlaying;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${verse.surah.nameTranslit ?? verse.surah.nameEnglish} · ${verse.surah.number}:${verse.numberInSurah}',
                    style: latinFont(size: 12, weight: FontWeight.w600, color: c.textMuted),
                  ),
                ),
                if (concept != null) ConceptBadge(label: concept!),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              verse.textArabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: arabicFont(size: 24, color: c.text, height: 1.9),
            ),
            if (translation != null) ...[
              const SizedBox(height: 10),
              Text(translation.text, style: latinFont(size: 13.5, color: c.textMuted, height: 1.6)),
            ],
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  if (app.playingVerseId == _verseId) {
                    app.togglePlayPause();
                  } else {
                    app.startPlayback(
                      verseId: _verseId,
                      label: '${verse.surah.nameTranslit ?? verse.surah.nameEnglish} ${verse.surah.number}:${verse.numberInSurah}',
                      concept: concept,
                      onOpenDetail: onTap,
                    );
                  }
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
                  child: Icon(isThisPlaying ? Icons.pause : Icons.play_arrow, size: 18, color: c.onPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
