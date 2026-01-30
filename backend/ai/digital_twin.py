def simulate_accessibility(barriers):
    score = 100

    for b in barriers:
        if b["barrier"] == "uneven_road":
            score -= 25
        elif b["barrier"] == "stairs":
            score -= 50

    score = max(score, 0)

    if score >= 80:
        status = "Accessible"
    elif score >= 40:
        status = "Difficult"
    else:
        status = "Inaccessible"

    return status, score
