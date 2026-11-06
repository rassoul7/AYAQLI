from datetime import date, datetime

from pgvector.sqlalchemy import Vector
from sqlalchemy import (
    Boolean,
    Date,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class Surah(Base):
    __tablename__ = "surahs"

    id: Mapped[int] = mapped_column(primary_key=True)
    number: Mapped[int] = mapped_column(Integer, unique=True, nullable=False)
    name_arabic: Mapped[str] = mapped_column(String, nullable=False)
    name_english: Mapped[str] = mapped_column(String, nullable=False)
    name_translit: Mapped[str | None] = mapped_column(String)
    revelation_type: Mapped[str | None] = mapped_column(String)
    verses_count: Mapped[int] = mapped_column(Integer, nullable=False)

    verses: Mapped[list["Verse"]] = relationship(back_populates="surah", order_by="Verse.number_in_surah")


class Verse(Base):
    __tablename__ = "verses"
    __table_args__ = (UniqueConstraint("surah_id", "number_in_surah", name="uq_verse_surah_number"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    surah_id: Mapped[int] = mapped_column(ForeignKey("surahs.id"), nullable=False)
    number_in_surah: Mapped[int] = mapped_column(Integer, nullable=False)
    number_global: Mapped[int] = mapped_column(Integer, unique=True, nullable=False)
    text_arabic_uthmani: Mapped[str] = mapped_column(Text, nullable=False)
    text_translit: Mapped[str | None] = mapped_column(Text)
    juz: Mapped[int | None] = mapped_column(Integer)
    page: Mapped[int | None] = mapped_column(Integer)
    hizb_quarter: Mapped[int | None] = mapped_column(Integer)
    sajda: Mapped[bool] = mapped_column(Boolean, default=False)

    surah: Mapped["Surah"] = relationship(back_populates="verses")
    translations: Mapped[list["Translation"]] = relationship(back_populates="verse")
    audio_files: Mapped[list["VerseAudio"]] = relationship(back_populates="verse")
    embeddings: Mapped[list["VerseEmbedding"]] = relationship(back_populates="verse")
    concept_links: Mapped[list["ConceptVerse"]] = relationship(back_populates="verse")


class Translation(Base):
    """Traduction du verset dans une langue et selon une source donnee (ex: fr/hamidullah)."""

    __tablename__ = "translations"
    __table_args__ = (UniqueConstraint("verse_id", "language_code", "source", name="uq_translation_verse_lang_source"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    verse_id: Mapped[int] = mapped_column(ForeignKey("verses.id"), nullable=False)
    language_code: Mapped[str] = mapped_column(String(8), nullable=False)
    source: Mapped[str] = mapped_column(String(64), nullable=False)
    text: Mapped[str] = mapped_column(Text, nullable=False)

    verse: Mapped["Verse"] = relationship(back_populates="translations")


class VerseEmbedding(Base):
    """Embedding vectoriel d'un verset (sur sa traduction) pour la recherche semantique (Phase 3)."""

    __tablename__ = "verse_embeddings"
    __table_args__ = (UniqueConstraint("verse_id", "language_code", "model", name="uq_embedding_verse_lang_model"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    verse_id: Mapped[int] = mapped_column(ForeignKey("verses.id"), nullable=False)
    language_code: Mapped[str] = mapped_column(String(8), nullable=False)
    model: Mapped[str] = mapped_column(String(64), nullable=False)
    embedding: Mapped[list[float]] = mapped_column(Vector(1536))

    verse: Mapped["Verse"] = relationship(back_populates="embeddings")


class Reciter(Base):
    __tablename__ = "reciters"

    id: Mapped[int] = mapped_column(primary_key=True)
    slug: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String, nullable=False)
    style: Mapped[str | None] = mapped_column(String)

    audio_files: Mapped[list["VerseAudio"]] = relationship(back_populates="reciter")


class VerseAudio(Base):
    __tablename__ = "verse_audio"
    __table_args__ = (UniqueConstraint("verse_id", "reciter_id", name="uq_audio_verse_reciter"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    verse_id: Mapped[int] = mapped_column(ForeignKey("verses.id"), nullable=False)
    reciter_id: Mapped[int] = mapped_column(ForeignKey("reciters.id"), nullable=False)
    audio_url: Mapped[str] = mapped_column(String, nullable=False)
    duration_seconds: Mapped[float | None] = mapped_column(Float)

    verse: Mapped["Verse"] = relationship(back_populates="audio_files")
    reciter: Mapped["Reciter"] = relationship(back_populates="audio_files")


class Concept(Base):
    __tablename__ = "concepts"

    id: Mapped[int] = mapped_column(primary_key=True)
    slug: Mapped[str] = mapped_column(String(128), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String, nullable=False)
    language_code: Mapped[str] = mapped_column(String(8), nullable=False, default="fr")

    verse_links: Mapped[list["ConceptVerse"]] = relationship(back_populates="concept")


class ConceptVerse(Base):
    __tablename__ = "concept_verses"
    __table_args__ = (UniqueConstraint("concept_id", "verse_id", name="uq_concept_verse"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    concept_id: Mapped[int] = mapped_column(ForeignKey("concepts.id"), nullable=False)
    verse_id: Mapped[int] = mapped_column(ForeignKey("verses.id"), nullable=False)

    concept: Mapped["Concept"] = relationship(back_populates="verse_links")
    verse: Mapped["Verse"] = relationship(back_populates="concept_links")


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String, unique=True, nullable=False)
    oauth_provider: Mapped[str | None] = mapped_column(String(32))
    oauth_subject: Mapped[str | None] = mapped_column(String)
    preferred_reciter_id: Mapped[int | None] = mapped_column(ForeignKey("reciters.id"))
    preferred_translation_lang: Mapped[str] = mapped_column(String(8), default="fr")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    review_progress: Mapped[list["ReviewProgress"]] = relationship(back_populates="user")


class ReviewProgress(Base):
    """Progression de memorisation/revision (SRS) d'un verset pour un utilisateur."""

    __tablename__ = "review_progress"
    __table_args__ = (UniqueConstraint("user_id", "verse_id", name="uq_progress_user_verse"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False)
    verse_id: Mapped[int] = mapped_column(ForeignKey("verses.id"), nullable=False)
    ease_factor: Mapped[float] = mapped_column(Float, default=2.5)
    interval_days: Mapped[int] = mapped_column(Integer, default=0)
    repetitions: Mapped[int] = mapped_column(Integer, default=0)
    mastery_level: Mapped[int] = mapped_column(Integer, default=0)
    last_reviewed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    next_review_date: Mapped[date | None] = mapped_column(Date)

    user: Mapped["User"] = relationship(back_populates="review_progress")
    verse: Mapped["Verse"] = relationship()
