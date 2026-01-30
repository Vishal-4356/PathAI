import sqlite3

DB_NAME = "accessibility.db"

def get_connection():
    conn = sqlite3.connect(DB_NAME)
    return conn
