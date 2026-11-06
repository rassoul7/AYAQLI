# Ayaqli — backend

API FastAPI + PostgreSQL/pgvector. Phase 1 (socle de données) : texte arabe Uthmani, traductions FR/EN, références audio (Alafasy, Abdul Basit, Al-Ghamdi).

## Démarrage

```bash
cp .env.example .env          # ajuster si besoin (ports 5432/8000 déjà pris sur cette machine -> 5433/8001)
docker compose up -d db       # Postgres + pgvector, exposé sur localhost:5433

python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

alembic upgrade head           # applique le schéma
python -m data.ingest_quran    # ingère texte + traductions + audio (~1-2 min)

uvicorn app.main:app --reload --port 8001
```

## Endpoints

- `GET /health`
- `GET /surahs` — liste des 114 sourates
- `GET /surahs/{number}/verses` — versets d'une sourate avec traductions
- `GET /verses/{surah_number}/{verse_number}`
- `GET /search?q=...&lang=fr` — recherche par mot-clé sur les traductions + concepts/tags

## Notes

- `verse_embeddings` (pgvector, dim 1536) est en place pour la recherche sémantique (Phase 3) mais pas encore alimenté.
- `concepts` / `concept_verses` sont créés mais vides — à peupler en Phase 2 (tags thématiques).
- Comptes utilisateur + SRS (`users`, `review_progress`) : schéma prêt, logique à implémenter en Phase 5.
