from fastapi import FastAPI

from app.routers import search, surahs, verses

app = FastAPI(title="Ayaqli API", version="0.1.0")

app.include_router(surahs.router)
app.include_router(verses.router)
app.include_router(search.router)


@app.get("/health")
def health():
    return {"status": "ok"}
