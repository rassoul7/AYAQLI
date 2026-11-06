/// Demo data for screens not yet backed by real endpoints (concepts/tags,
/// SRS progress, reciter roster). Verse text/translations elsewhere in the
/// app always come from the real backend — see services/api_client.dart.
class Reciter {
  final String slug;
  final String name;
  const Reciter(this.slug, this.name);
}

const mockReciters = [
  Reciter('alafasy', 'Alafasy'),
  Reciter('abdulbasit', 'Abdul Basit'),
  Reciter('ghamdi', 'Al-Ghamdi'),
];

const mockConcepts = ['patience', 'justice', 'mariage', 'miséricorde', 'décret'];

class MockVerse {
  final String id;
  final String surahName;
  final String ref; // "2:286"
  final String arabic;
  final String translationFr;
  final String translationEn;
  final String concept;
  /// Index of the word (split on spaces) blanked out in fill-in-the-blank mode.
  final int blankWordIndex;
  final List<String> blankOptions;

  const MockVerse({
    required this.id,
    required this.surahName,
    required this.ref,
    required this.arabic,
    required this.translationFr,
    required this.translationEn,
    required this.concept,
    required this.blankWordIndex,
    required this.blankOptions,
  });

  List<String> get arabicWords => arabic.split(' ');
  String get blankWord => arabicWords[blankWordIndex];
}

const mockReviewQueue = [
  MockVerse(
    id: '2:286',
    surahName: 'Al-Baqarah',
    ref: '2:286',
    arabic: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
    translationFr: "Allah n'impose à aucune âme une charge supérieure à sa capacité.",
    translationEn: 'Allah does not charge a soul except [with that within] its capacity.',
    concept: 'patience',
    blankWordIndex: 1,
    blankOptions: ['يُكَلِّفُ', 'يَرْزُقُ', 'يَغْفِرُ'],
  ),
  MockVerse(
    id: '94:5',
    surahName: 'Ash-Sharh',
    ref: '94:5',
    arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
    translationFr: "Certes, avec la difficulté il y a une facilité.",
    translationEn: 'For indeed, with hardship [will be] ease.',
    concept: 'patience',
    blankWordIndex: 2,
    blankOptions: ['يُسْرًا', 'صَبْرًا', 'أَجْرًا'],
  ),
  MockVerse(
    id: '16:90',
    surahName: 'An-Nahl',
    ref: '16:90',
    arabic: 'إِنَّ اللَّهَ يَأْمُرُ بِالْعَدْلِ وَالْإِحْسَانِ',
    translationFr: "Certes, Allah commande l'équité et la bienfaisance.",
    translationEn: 'Indeed, Allah orders justice and good conduct.',
    concept: 'justice',
    blankWordIndex: 3,
    blankOptions: ['بِالْعَدْلِ', 'بِالصَّبْرِ', 'بِالْحَقِّ'],
  ),
];

class LearningStats {
  static const streakDays = 12;
  static const versesMastered = 23;
  static const nextSessionConcept = 'Patience';
  static const nextSessionVerseCount = 3;
  static const inProgress = [
    ('Patience', 0.62),
    ('Justice', 0.34),
  ];
}
