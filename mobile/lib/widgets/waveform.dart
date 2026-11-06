import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Animated waveform visualization for the audio player. Real per-verse
/// amplitude data isn't available from the audio source (everyayah.com
/// serves plain mp3s, no waveform metadata), so bar heights are generated
/// deterministically from the verse id — visual only, matching the
/// Figma-inspired direction chosen for the player.
class Waveform extends StatelessWidget {
  final String seed;
  final double progress; // 0..1
  final bool isPlaying;
  final int barCount;

  const Waveform({
    super.key,
    required this.seed,
    required this.progress,
    required this.isPlaying,
    this.barCount = 40,
  });

  List<double> _bars() {
    final rnd = Random(seed.hashCode);
    return List.generate(barCount, (i) {
      final base = 0.25 + rnd.nextDouble() * 0.75;
      return base;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bars = _bars();
    return SizedBox(
      height: 32,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final playedBars = (bars.length * progress).round();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < bars.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 32 * bars[i],
                      decoration: BoxDecoration(
                        color: i < playedBars ? c.primary : c.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
