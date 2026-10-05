import sqlite3
import pandas as pd
import time

conn = sqlite3.connect("data/atmosync.db")

start_time = time.time()
df = pd.read_sql_query("SELECT City, Zone, SUM(Revenue_INR) AS rev FROM atmosync_data GROUP BY City, Zone", conn)
execution_time = (time.time() - start_time) * 1000

print(f"Benchmark Query Executed in {execution_time:.2f} ms")
print(f"Returned {len(df)} rows.")
conn.close()
