import sqlite3
import pandas as pd

conn = sqlite3.connect("data/atmosync.db")
with open("sql/08_time_trend_analysis.sql", "r") as f:
    sql = f.read()

queries = [q for q in sql.split(";") if q.strip()]
for q in queries:
    df = pd.read_sql_query(q, conn)
    print(df.head(10))
    print("-" * 50)
conn.close()
