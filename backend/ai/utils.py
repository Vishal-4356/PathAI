def normalize_confidence(confidence: float) -> float:
    return round(min(max(confidence, 0.0), 1.0), 2)
