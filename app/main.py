from fastapi import FastAPI

from .database import Base, engine
from .routers import tasks

app = FastAPI(title="Tasks API", version="1.0.0")


@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)


app.include_router(tasks.router)
