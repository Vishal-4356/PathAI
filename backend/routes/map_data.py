from fastapi import APIRouter
from database.memory_store import get_records

router = APIRouter()

@router.get("/heatmap")
def heatmap():
    heatmap = []

    for r in get_records():
        intensity = 1
        if r["status"] == "Difficult":
            intensity = 3
        elif r["status"] == "Inaccessible":
            intensity = 5

        heatmap.append({
            "lat": r["lat"],
            "lon": r["lon"],
            "intensity": intensity
        })

    return {"heatmap": heatmap}
