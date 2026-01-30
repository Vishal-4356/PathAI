from database.db import get_connection

def create_tables():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS barriers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            barrier_type TEXT,
            confidence REAL,
            latitude REAL,
            longitude REAL
        )
    """)

    conn.commit()
    conn.close()
