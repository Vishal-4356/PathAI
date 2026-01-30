from fastapi import APIRouter, UploadFile, File, Form
import uuid
import shutil
import os

router = APIRouter()

UPLOAD_DIR = "images"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("/upload")
async def upload_image(
    file: UploadFile = File(...),
    lat: float = Form(...),
    lon: float = Form(...)
):
    filename = f"{uuid.uuid4()}.jpg"
    filepath = os.path.join(UPLOAD_DIR, filename)

    with open(filepath, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    return {
        "message": "Image uploaded successfully",
        "image_path": filepath,
        "latitude": lat,
        "longitude": lon
    }
