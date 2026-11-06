from fastapi import APIRouter, Depends, Query
from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Concept, ConceptVerse, Translation, Verse
from app.schemas import SearchResult

router = APIRouter(prefix="/search", tags=["search"])


@router.get("", response_model=list[SearchResult])
def keyword_search(
    q: str = Query(..., min_length=2),
    lang: str = Query("fr", min_length=2, max_length=8),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    """Recherche par mot-cle exact sur les traductions (langue donnee) et sur les concepts/tags associes."""
    pattern = f"%{q}%"

    concept_verse_ids = db.scalars(
        select(ConceptVerse.verse_id)
        .join(Concept)
        .where(Concept.language_code == lang, Concept.name.ilike(pattern))
    ).all()

    matches = db.execute(
        select(Verse, Translation)
        .join(Translation, Translation.verse_id == Verse.id)
        .where(
            Translation.language_code == lang,
            or_(Translation.text.ilike(pattern), Verse.id.in_(concept_verse_ids)),
        )
        .limit(limit)
    ).all()

    return [SearchResult(verse=verse, matched_translation=translation) for verse, translation in matches]
