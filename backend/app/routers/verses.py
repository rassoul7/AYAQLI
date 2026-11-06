from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Verse
from app.schemas import VerseOut

router = APIRouter(prefix="/verses", tags=["verses"])


@router.get("/{surah_number}/{verse_number}", response_model=VerseOut)
def get_verse(surah_number: int, verse_number: int, db: Session = Depends(get_db)):
    verse = db.scalar(
        select(Verse).join(Verse.surah).where(
            Verse.surah.has(number=surah_number),
            Verse.number_in_surah == verse_number,
        )
    )
    if verse is None:
        raise HTTPException(status_code=404, detail="Verse not found")
    return verse
