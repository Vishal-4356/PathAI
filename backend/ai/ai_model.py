import random

def detect_barriers(_):
    """
    Lightweight simulated perception logic.
    This avoids filename dependency.
    """

    scenarios = [
        [],  # Accessible
        [{"barrier": "uneven_road"}],  # Difficult
        [{"barrier": "stairs"}],  # Inaccessible
    ]

    return random.choice(scenarios)
