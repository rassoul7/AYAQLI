class Surah {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String? nameTranslit;

  Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    this.nameTranslit,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json['number'] as int,
        nameArabic: json['name_arabic'] as String,
        nameEnglish: json['name_english'] as String,
        nameTranslit: json['name_translit'] as String?,
      );
}

class Translation {
  final String languageCode;
  final String source;
  final String text;

  Translation({required this.languageCode, required this.source, required this.text});

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        languageCode: json['language_code'] as String,
        source: json['source'] as String,
        text: json['text'] as String,
      );
}

class Verse {
  final int numberInSurah;
  final int numberGlobal;
  final String textArabic;
  final Surah surah;
  final List<Translation> translations;

  Verse({
    required this.numberInSurah,
    required this.numberGlobal,
    required this.textArabic,
    required this.surah,
    required this.translations,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        numberInSurah: json['number_in_surah'] as int,
        numberGlobal: json['number_global'] as int,
        textArabic: json['text_arabic_uthmani'] as String,
        surah: Surah.fromJson(json['surah'] as Map<String, dynamic>),
        translations: (json['translations'] as List<dynamic>? ?? [])
            .map((t) => Translation.fromJson(t as Map<String, dynamic>))
            .toList(),
      );

  String? translationFor(String languageCode) {
    for (final t in translations) {
      if (t.languageCode == languageCode) return t.text;
    }
    return null;
  }
}

class SearchResult {
  final Verse verse;
  final Translation? matchedTranslation;

  SearchResult({required this.verse, this.matchedTranslation});

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        verse: Verse.fromJson(json['verse'] as Map<String, dynamic>),
        matchedTranslation: json['matched_translation'] == null
            ? null
            : Translation.fromJson(json['matched_translation'] as Map<String, dynamic>),
      );
}
