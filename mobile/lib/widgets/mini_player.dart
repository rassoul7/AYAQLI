import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Fixed bar shown above the tab bar when a verse is playing. Tapping the
/// bar (not the play button) opens that verse's Detail screen.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    if (app.playingVerseId == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: app.onOpenPlayingVerseDetail,
      child: Container(
        height: 56,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: c.primarySoft, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.graphic_eq, size: 18, color: c.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    app.playingVerseLabel ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: latinFont(size: 13, weight: FontWeight.w600, color: c.text),
                  ),
                  if (app.playingConcept != null)
                    Text(
                      app.playingConcept!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: latinFont(size: 11, color: c.textMuted),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: app.togglePlayPause,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
                child: Icon(app.isPlaying ? Icons.pause : Icons.play_arrow, size: 18, color: c.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
