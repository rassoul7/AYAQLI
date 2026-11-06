import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mock_data.dart';
import '../models/verse.dart';
import '../services/api_client.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/concept_chip.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/waveform.dart';

class VerseDetailScreen extends StatefulWidget {
  final Verse verse;
  final String? concept;

  const VerseDetailScreen({super.key, required this.verse, this.concept});

  @override
  State<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends State<VerseDetailScreen> {
  final _apiClient = ApiClient();
  late Verse _verse;
  List<Verse>? _surahVerses;
  Timer? _wordTimer;

  String get _verseId => '${_verse.surah.number}:${_verse.numberInSurah}';

  @override
  void initState() {
    super.initState();
    _verse = widget.verse;
    _loadSurahVerses();
    _ensurePlaying();
    _startWordTimerIfNeeded();
  }

  Future<void> _loadSurahVerses() async {
    try {
      final verses = await _apiClient.getSurahVerses(_verse.surah.number);
      if (mounted) setState(() => _surahVerses = verses);
    } catch (_) {
      // Prev/Next simply stays disabled if this fails — not fatal for reading/listening.
    }
  }

  void _ensurePlaying() {
    final app = context.read<AppState>();
    if (app.playingVerseId != _verseId) {
      app.startPlayback(
        verseId: _verseId,
        label: '${_verse.surah.nameTranslit ?? _verse.surah.nameEnglish} ${_verse.surah.number}:${_verse.numberInSurah}',
        concept: widget.concept,
        onOpenDetail: () {},
      );
    } else {
      app.onOpenPlayingVerseDetail = () {};
    }
  }

  void _startWordTimerIfNeeded() {
    _wordTimer?.cancel();
    final wordCount = _verse.textArabic.split(' ').length;
    _wordTimer = Timer.periodic(const Duration(milliseconds: 650), (_) {
      if (!mounted) return;
      final app = context.read<AppState>();
      if (app.playingVerseId != _verseId || !app.isPlaying) return;
      final next = app.activeWordIndex + 1;
      if (next >= wordCount) {
        if (app.loop) {
          app.setActiveWordIndex(0);
        } else {
          app.togglePlayPause();
        }
      } else {
        app.setActiveWordIndex(next);
      }
    });
  }

  void _goToVerse(Verse v) {
    setState(() => _verse = v);
    final app = context.read<AppState>();
    app.startPlayback(
      verseId: _verseId,
      label: '${v.surah.nameTranslit ?? v.surah.nameEnglish} ${v.surah.number}:${v.numberInSurah}',
      concept: widget.concept,
      onOpenDetail: () {},
    );
    _startWordTimerIfNeeded();
  }

  void _prev() {
    final list = _surahVerses;
    if (list == null) return;
    final i = list.indexWhere((v) => v.numberInSurah == _verse.numberInSurah);
    if (i < 0) return;
    _goToVerse(list[(i - 1 + list.length) % list.length]);
  }

  void _next() {
    final list = _surahVerses;
    if (list == null) return;
    final i = list.indexWhere((v) => v.numberInSurah == _verse.numberInSurah);
    if (i < 0) return;
    _goToVerse(list[(i + 1) % list.length]);
  }

  @override
  void dispose() {
    _wordTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    final words = _verse.textArabic.split(' ');
    final translation = _verse.translations.isEmpty ? null : _verse.translations.first;
    final wordCount = words.length;
    final progress = wordCount <= 1 ? 0.0 : app.activeWordIndex / (wordCount - 1);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
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
                  Text(
                    '${_verse.surah.nameTranslit ?? _verse.surah.nameEnglish} · ${_verse.surah.number}:${_verse.numberInSurah}',
                    style: latinFont(size: 14, weight: FontWeight.w600, color: c.text),
                  ),
                  const ThemeToggleButton(),
                ],
              ),
              const SizedBox(height: 20),
              if (widget.concept != null) Center(child: ConceptBadge(label: widget.concept!)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
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
                                text: '${words[i]} ',
                                style: arabicFont(size: 34, color: c.text, height: 2.15).copyWith(
                                  backgroundColor: i == app.activeWordIndex && app.playingVerseId == _verseId
                                      ? c.primarySoft
                                      : null,
                                  color: i == app.activeWordIndex && app.playingVerseId == _verseId ? c.primary : c.text,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (translation != null) ...[
                        const SizedBox(height: 20),
                        Text(translation.text, style: latinFont(size: 15, color: c.textMuted, height: 1.75)),
                      ],
                      const SizedBox(height: 20),
                      Text('RÉCITATEUR', style: monoFont(size: 11, weight: FontWeight.w600, color: c.textFaint, letterSpacing: 0.8)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 32,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: mockReciters.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final r = mockReciters[i];
                            return ConceptChip(
                              label: r.name,
                              active: app.favoriteReciter == r.slug,
                              onTap: () => app.setFavoriteReciter(r.slug),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: c.border),
                ),
                child: Column(
                  children: [
                    Waveform(seed: _verseId, progress: progress, isPlaying: app.isPlaying),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: app.toggleLoop,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: app.loop ? c.primarySoft : Colors.transparent,
                              border: Border.all(color: app.loop ? Colors.transparent : c.border),
                            ),
                            child: Icon(Icons.repeat, size: 18, color: app.loop ? c.primary : c.text),
                          ),
                        ),
                        GestureDetector(
                          onTap: _prev,
                          child: Icon(Icons.skip_previous, size: 26, color: _surahVerses == null ? c.textFaint : c.text),
                        ),
                        GestureDetector(
                          onTap: app.togglePlayPause,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
                            child: Icon(app.isPlaying ? Icons.pause : Icons.play_arrow, size: 30, color: c.onPrimary),
                          ),
                        ),
                        GestureDetector(
                          onTap: _next,
                          child: Icon(Icons.skip_next, size: 26, color: _surahVerses == null ? c.textFaint : c.text),
                        ),
                        GestureDetector(
                          onTap: app.cycleSpeed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: c.border)),
                            child: Text(app.speed.label, style: latinFont(size: 12, weight: FontWeight.w600, color: c.text)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
