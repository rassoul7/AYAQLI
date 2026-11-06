"""Ingestion Phase 1 : texte arabe (Uthmani), traductions FR/EN et references audio.

Sources :
- Texte arabe + traductions : api.alquran.cloud (editions quran-uthmani, fr.hamidullah, en.sahih)
- Audio par verset : everyayah.com (URLs statiques, pas d'API a interroger)

Usage : python -m data.ingest_quran
"""

import httpx
from sqlalchemy import select

from app.database import SessionLocal
from app.models import Reciter, Surah, Translation, Verse, VerseAudio

QURAN_API = "https://api.alquran.cloud/v1/quran/{edition}"

TRANSLATION_EDITIONS = {
    "fr": "fr.hamidullah",
    "en": "en.sahih",
}

RECITERS = [
    {"slug": "alafasy", "name": "Mishary Alafasy", "style": "Murattal", "everyayah_dir": "Alafasy_128kbps"},
    {"slug": "abdulbasit", "name": "Abdul Basit", "style": "Murattal", "everyayah_dir": "Abdul_Basit_Murattal_192kbps"},
    {"slug": "ghamdi", "name": "Saad Al-Ghamdi", "style": "Murattal", "everyayah_dir": "Ghamadi_40kbps"},
]

EVERYAYAH_BASE = "https://everyayah.com/data/{dir}/{surah:03d}{ayah:03d}.mp3"


def fetch_edition(client: httpx.Client, edition: str) -> list[dict]:
    resp = client.get(QURAN_API.format(edition=edition), timeout=30)
    resp.raise_for_status()
    return resp.json()["data"]["surahs"]


def ingest():
    db = SessionLocal()
    client = httpx.Client()
    try:
        print("Fetching Arabic Uthmani text...")
        arabic_surahs = fetch_edition(client, "quran-uthmani")

        translations_by_lang: dict[str, list[dict]] = {}
        for lang, edition in TRANSLATION_EDITIONS.items():
            print(f"Fetching translation [{lang}] ({edition})...")
            translations_by_lang[lang] = fetch_edition(client, edition)

        print("Upserting reciters...")
        reciters_by_slug: dict[str, Reciter] = {}
        for r in RECITERS:
            reciter = db.scalar(select(Reciter).where(Reciter.slug == r["slug"]))
            if reciter is None:
                reciter = Reciter(slug=r["slug"], name=r["name"], style=r["style"])
                db.add(reciter)
                db.flush()
            reciters_by_slug[r["slug"]] = reciter

        print("Upserting surahs and verses...")
        global_number = 0
        for s_idx, s_ar in enumerate(arabic_surahs):
            surah = db.scalar(select(Surah).where(Surah.number == s_ar["number"]))
            if surah is None:
                surah = Surah(
                    number=s_ar["number"],
                    name_arabic=s_ar["name"],
                    name_english=s_ar["englishNameTranslation"],
                    name_translit=s_ar["englishName"],
                    revelation_type=s_ar["revelationType"],
                    verses_count=len(s_ar["ayahs"]),
                )
                db.add(surah)
                db.flush()

            for a_idx, a_ar in enumerate(s_ar["ayahs"]):
                global_number += 1
                verse = db.scalar(select(Verse).where(Verse.number_global == a_ar["number"]))
                if verse is None:
                    verse = Verse(
                        surah_id=surah.id,
                        number_in_surah=a_ar["numberInSurah"],
                        number_global=a_ar["number"],
                        text_arabic_uthmani=a_ar["text"],
                        juz=a_ar.get("juz"),
                        page=a_ar.get("page"),
                        hizb_quarter=a_ar.get("hizbQuarter"),
                        sajda=bool(a_ar.get("sajda")),
                    )
                    db.add(verse)
                    db.flush()

                for lang, edition in TRANSLATION_EDITIONS.items():
                    a_tr = translations_by_lang[lang][s_idx]["ayahs"][a_idx]
                    existing = db.scalar(
                        select(Translation).where(
                            Translation.verse_id == verse.id,
                            Translation.language_code == lang,
                            Translation.source == edition,
                        )
                    )
                    if existing is None:
                        db.add(
                            Translation(
                                verse_id=verse.id,
                                language_code=lang,
                                source=edition,
                                text=a_tr["text"],
                            )
                        )

                for r in RECITERS:
                    reciter = reciters_by_slug[r["slug"]]
                    existing_audio = db.scalar(
                        select(VerseAudio).where(
                            VerseAudio.verse_id == verse.id,
                            VerseAudio.reciter_id == reciter.id,
                        )
                    )
                    if existing_audio is None:
                        db.add(
                            VerseAudio(
                                verse_id=verse.id,
                                reciter_id=reciter.id,
                                audio_url=EVERYAYAH_BASE.format(
                                    dir=r["everyayah_dir"], surah=surah.number, ayah=a_ar["numberInSurah"]
                                ),
                            )
                        )

            db.commit()
            print(f"  Surah {surah.number:>3} ({surah.name_translit}) — {len(s_ar['ayahs'])} verses done")

        print(f"Done. {global_number} verses ingested.")
    finally:
        client.close()
        db.close()


if __name__ == "__main__":
    ingest()
