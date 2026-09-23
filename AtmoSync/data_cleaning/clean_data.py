
import pandas as pd
from pathlib import Path


# File locations
base_path = Path(__file__).resolve().parent.parent
input_file = base_path / "data" / "raw" / "AtmoSync_Micro_Climate_Arbitrage_Analytics_10000.xlsx"
output_folder = base_path / "data" / "cleaned"

output_folder.mkdir(exist_ok=True)


# Read the raw data
df = pd.read_excel(input_file, sheet_name="AtmoSync_Data")

print("Original shape:", df.shape)


# Clean column names
df.columns = df.columns.str.strip()


# Convert date column
df["Date"] = pd.to_datetime(df["Date"], errors="coerce")


# Clean text columns
text_columns = [
    "City",
    "Zone",
    "Product_Category",
    "Weather_Condition",
    "Stockout",
    "Opportunity_Flag"
]

for column in text_columns:
    df[column] = df[column].astype("string").str.strip()


# Convert numeric columns
numeric_columns = [
    "Temperature_C",
    "Humidity_%",
    "Rainfall_mm",
    "Wind_Speed_kmph",
    "AQI",
    "Units_Sold",
    "Avg_Price_INR",
    "Competitor_Price_INR",
    "Revenue_INR",
    "Inventory_Units",
    "Potential_Lost_Units",
    "Potential_Lost_Revenue_INR",
    "Demand_Index",
    "Micro_Climate_Score"
]

for column in numeric_columns:
    df[column] = pd.to_numeric(df[column], errors="coerce")


# Check missing values
missing_values = df.isna().sum()

if missing_values.sum() > 0:
    print("\nMissing values:")
    print(missing_values[missing_values > 0])
else:
    print("No missing values found.")


# Remove duplicate rows
duplicates = df.duplicated().sum()

if duplicates > 0:
    df = df.drop_duplicates()
    print("Duplicates removed:", duplicates)
else:
    print("No duplicate rows found.")


# Check a few important data rules
invalid_humidity = ((df["Humidity_%"] < 0) | (df["Humidity_%"] > 100)).sum()
negative_sales = (df["Units_Sold"] < 0).sum()
negative_revenue = (df["Revenue_INR"] < 0).sum()

print("\nData quality checks:")
print("Invalid humidity values:", invalid_humidity)
print("Negative units sold:", negative_sales)
print("Negative revenue:", negative_revenue)


# Sort the data
df = df.sort_values(
    ["Date", "City", "Zone", "Product_Category"]
).reset_index(drop=True)


# Save cleaned data
output_file = output_folder / "clean_data.csv"
df.to_csv(output_file, index=False)

print("\nCleaned shape:", df.shape)
print("Clean data saved to:", output_file)