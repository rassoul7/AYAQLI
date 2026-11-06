# Ayaqli

Quran reading and search app: Arabic text (Uthmani script), French and English translations, and audio references
for several reciters.

## Structure
- `mobile/`: Flutter app (Android, iOS, desktop).
- `backend/`: FastAPI API with PostgreSQL. See `backend/README.md`.
- `cahier-des-charges-app-coran.md`: product specification (French).

## Status
- Done: data foundation (114 surahs, verses, translations, audio references), keyword search on translations.
- Planned: thematic concepts, semantic search (pgvector schema in place, embeddings not yet loaded), user accounts
  and spaced-repetition learning.

## Run locally
```bash
docker compose up -d db
cd backend && cp .env.example .env
python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
alembic upgrade head && python -m data.ingest_quran
uvicorn app.main:app --reload --port 8001
```
