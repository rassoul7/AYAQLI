from pydantic import BaseModel, ConfigDict


class TranslationOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    language_code: str
    source: str
    text: str


class SurahOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    number: int
    name_arabic: str
    name_english: str
    name_translit: str | None
    revelation_type: str | None
    verses_count: int


class VerseOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    number_in_surah: int
    number_global: int
    text_arabic_uthmani: str
    juz: int | None
    page: int | None
    surah: SurahOut
    translations: list[TranslationOut] = []


class SearchResult(BaseModel):
    verse: VerseOut
    matched_translation: TranslationOut | None = None
