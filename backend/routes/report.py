from fastapi import APIRouter
from database.memory_store import get_records

router = APIRouter()

@router.get("/report")
def report():
    return {
        "total_records": len(get_records()),
        "records": get_records()
    }
