from pathlib import Path
import pandas as pd

# Project root
base_path = Path(__file__).resolve().parent.parent

# Load cleaned data
input_file = base_path / "data" / "cleaned" / "clean_data.csv"

df = pd.read_csv(input_file)

print("Dataset shape:", df.shape)

print("\nColumn names:")
print(df.columns.tolist())

print("\nFirst 5 rows:")
print(df.head())

print("\nBasic statistics:")
print(df.describe())

print("\nRevenue by city:")
city_revenue = (
    df.groupby("City")["Revenue_INR"]
    .sum()
    .sort_values(ascending=False)
)

print(city_revenue)

print("\nUnits sold by city:")
city_units = (
    df.groupby("City")["Units_Sold"]
    .sum()
    .sort_values(ascending=False)
)

print(city_units)

print("\nRevenue by product category:")
category_revenue = (
    df.groupby("Product_Category")["Revenue_INR"]
    .sum()
    .sort_values(ascending=False)
)

print(category_revenue)

print("\nUnits sold by product category:")
category_units = (
    df.groupby("Product_Category")["Units_Sold"]
    .sum()
    .sort_values(ascending=False)
)

print(category_units)

# Revenue by weather condition

print("\nRevenue by weather condition:")

weather_revenue = (
    df.groupby("Weather_Condition")["Revenue_INR"]
    .sum()
    .sort_values(ascending=False)
)

print(weather_revenue)


# Units sold by weather condition

print("\nUnits sold by weather condition:")

weather_units = (
    df.groupby("Weather_Condition")["Units_Sold"]
    .sum()
    .sort_values(ascending=False)
)

print(weather_units)


# Revenue by zone

print("\nRevenue by zone:")

zone_revenue = (
    df.groupby("Zone")["Revenue_INR"]
    .sum()
    .sort_values(ascending=False)
)

print(zone_revenue)


# Units sold by zone

print("\nUnits sold by zone:")

zone_units = (
    df.groupby("Zone")["Units_Sold"]
    .sum()
    .sort_values(ascending=False)
)

print(zone_units)


# Climate correlation analysis

print("\nClimate correlation:")

climate_columns = [
    "Temperature_C",
    "Humidity_%",
    "Rainfall_mm",
    "Wind_Speed_kmph",
    "AQI",
    "Units_Sold",
    "Revenue_INR",
    "Demand_Index",
    "Micro_Climate_Score"
]

correlation = df[climate_columns].corr()

print(correlation.round(2))


# Opportunity flag analysis

print("\nOpportunity flag analysis:")

opportunity_summary = (
    df.groupby("Opportunity_Flag")
    .agg(
        Revenue_INR=("Revenue_INR", "sum"),
        Units_Sold=("Units_Sold", "sum"),
        Average_Demand=("Demand_Index", "mean"),
        Average_MicroClimate_Score=("Micro_Climate_Score", "mean")
    )
)

print(opportunity_summary)


# Potential lost revenue by city

print("\nPotential lost revenue by city:")

lost_revenue = (
    df.groupby("City")["Potential_Lost_Revenue_INR"]
    .sum()
    .sort_values(ascending=False)
)

print(lost_revenue)


# Stockout analysis

print("\nStockout analysis:")

stockout_analysis = (
    df.groupby("City")
    .agg(
        Stockout_Units=("Stockout", "sum"),
        Potential_Lost_Units=("Potential_Lost_Units", "sum"),
        Potential_Lost_Revenue=("Potential_Lost_Revenue_INR", "sum")
    )
    .sort_values("Potential_Lost_Revenue", ascending=False)
)

print(stockout_analysis)


# Product and climate analysis

print("\nProduct and climate analysis:")

product_climate = (
    df.groupby("Product_Category")
    .agg(
        Revenue_INR=("Revenue_INR", "sum"),
        Units_Sold=("Units_Sold", "sum"),
        Avg_Temperature=("Temperature_C", "mean"),
        Avg_Humidity=("Humidity_%", "mean"),
        Avg_Rainfall=("Rainfall_mm", "mean"),
        Avg_Demand=("Demand_Index", "mean"),
        Avg_MicroClimate_Score=("Micro_Climate_Score", "mean")
    )
    .sort_values("Revenue_INR", ascending=False)
)

print(product_climate)


# Top city-product combinations

print("\nTop city-product combinations:")

city_product = (
    df.groupby(["City", "Product_Category"])
    .agg(
        Revenue_INR=("Revenue_INR", "sum"),
        Units_Sold=("Units_Sold", "sum"),
        Demand_Index=("Demand_Index", "mean"),
        Micro_Climate_Score=("Micro_Climate_Score", "mean")
    )
    .sort_values("Revenue_INR", ascending=False)
)

print(city_product.head(20))


# Overall project summary

print("\nOverall project summary:")

total_revenue = df["Revenue_INR"].sum()
total_units = df["Units_Sold"].sum()
total_lost_revenue = df["Potential_Lost_Revenue_INR"].sum()
average_demand = df["Demand_Index"].mean()

print("Total revenue:", round(total_revenue, 2))
print("Total units sold:", total_units)
print("Potential lost revenue:", round(total_lost_revenue, 2))
print("Average demand index:", round(average_demand, 2))


print("\nAnalysis completed successfully.")