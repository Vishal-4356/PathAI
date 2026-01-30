from fastapi import APIRouter, UploadFile, File, Form
from ai.ai_model import detect_barriers
from ai.digital_twin import simulate_accessibility
from database.memory_store import add_record

router = APIRouter()

@router.post("/analyze")
async def analyze_image(
    file: UploadFile = File(...),
    lat: float = Form(...),
    lon: float = Form(...)
):
    # 1. AI barrier detection
    barriers = detect_barriers(file.filename)

    # 2. Digital twin scoring
    status, score = simulate_accessibility(barriers)

    # 3. ML risk (derived, always present)
    if score >= 80:
        ml_risk = 0
    elif score >= 40:
        ml_risk = 1
    else:
        ml_risk = 2

    # 4. Store for heatmap & reports
    record = {
        "lat": lat,
        "lon": lon,
        "status": status,
        "score": score,
        "ml_risk": ml_risk,
        "barriers": barriers
    }
    add_record(record)

    # 5. Return response
    return {
        "accessibility_status": status,
        "accessibility_score": score,
        "detected_barriers": barriers,
        "ml_risk_level": ml_risk
    }
