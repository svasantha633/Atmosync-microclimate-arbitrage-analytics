import sqlite3
import pandas as pd
import os

# Load cleaned csv into SQLite database
db_path = "data/atmosync.db"
csv_path = "data cleaning/clean_data.csv"

os.makedirs("data", exist_ok=True)

conn = sqlite3.connect(db_path)
df = pd.read_csv(csv_path)

# Standardize column name
df = df.rename(columns={'Humidity_%': 'Humidity_Pct'})

# Run table creation SQL script
with open("sql/02_create_tables.sql", "r") as f:
    conn.executescript(f.read())

# Insert rows into database
df.to_sql("atmosync_data", conn, if_exists="append", index=False)

print(f"Imported {len(df)} rows into atmosync.db")
conn.close()
