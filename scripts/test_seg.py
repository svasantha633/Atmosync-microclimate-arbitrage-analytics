import sqlite3
import pandas as pd

conn = sqlite3.connect("data/atmosync.db")
with open("sql/09_distribution_segmentation.sql", "r") as f:
    sql = f.read()

for q in [q for q in sql.split(";") if q.strip()]:
    print(pd.read_sql_query(q, conn).head(10))
    print("-" * 50)
conn.close()
