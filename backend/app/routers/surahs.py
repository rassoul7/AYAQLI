from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Surah, Verse
from app.schemas import SurahOut, VerseOut

router = APIRouter(prefix="/surahs", tags=["surahs"])


@router.get("", response_model=list[SurahOut])
def list_surahs(db: Session = Depends(get_db)):
    return db.scalars(select(Surah).order_by(Surah.number)).all()


@router.get("/{number}", response_model=SurahOut)
def get_surah(number: int, db: Session = Depends(get_db)):
    surah = db.scalar(select(Surah).where(Surah.number == number))
    if surah is None:
        raise HTTPException(status_code=404, detail="Surah not found")
    return surah


@router.get("/{number}/verses", response_model=list[VerseOut])
def list_surah_verses(number: int, db: Session = Depends(get_db)):
    surah = db.scalar(select(Surah).where(Surah.number == number))
    if surah is None:
        raise HTTPException(status_code=404, detail="Surah not found")
    return db.scalars(
        select(Verse).where(Verse.surah_id == surah.id).order_by(Verse.number_in_surah)
    ).all()
