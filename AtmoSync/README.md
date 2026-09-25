AtmoSync Micro-Climate Arbitrage Analytics

Project Overview

AtmoSync is a data analytics project that studies the relationship between micro-climate conditions, customer demand, sales, inventory and competitor pricing.

The goal of the project is to identify areas where weather and climate conditions can be used to improve inventory planning, reduce stockouts and identify potential revenue opportunities.

The project uses a dataset containing 10,000 sales and micro-climate records across multiple cities and product categories.

---

Objectives

- Analyze sales and revenue performance across cities and product categories.
- Understand how temperature and weather conditions affect demand.
- Analyze inventory levels and stockout patterns.
- Identify potential lost units and lost revenue.
- Compare selling prices with competitor prices.
- Identify potential business opportunities using demand and climate information.
- Generate useful insights that can support inventory and business decisions.

---

Dataset

The dataset contains information related to:

- Date
- City
- Zone
- Product Category
- Temperature
- Humidity
- Rainfall
- Wind Speed
- AQI
- Weather Condition
- Units Sold
- Average Selling Price
- Competitor Price
- Revenue
- Inventory
- Stockout Flag
- Potential Lost Units
- Potential Lost Revenue
- Demand Index
- Micro-Climate Score
- Opportunity Flag

The cleaned dataset contains 10,000 records and 21 columns.

---

Tools Used

- Python – Data cleaning and exploratory analysis
- Pandas – Data manipulation and analysis
- SQL – Business and KPI analysis
- MySQL – Database analysis
- Excel – Initial dataset
- Git & GitHub – Version control and project collaboration
- VS Code – Development environment

---

Project Workflow

1. Data Cleaning

The raw Excel dataset was cleaned using Python and Pandas.

The cleaning process included:

- Checking missing values
- Checking duplicate records
- Validating numerical values
- Checking invalid humidity values
- Checking negative sales and revenue values
- Saving the cleaned dataset as CSV

The cleaned file is stored in:

data/cleaned/clean_data.csv

---

2. Exploratory Data Analysis

Exploratory analysis was performed using Python to understand:

- Revenue by city
- Revenue by product category
- Units sold
- Weather conditions
- Demand patterns
- Inventory levels
- Potential lost revenue
- Micro-climate conditions
- Opportunity indicators

The analysis script is available in:

analysis/exploratory_analysis.py

---

3. SQL Analysis

SQL was used to perform business-focused analysis on the cleaned dataset.

The SQL analysis is divided into separate files:

sql/
├── 01_setup_database.sql
├── 02_data_overview.sql
├── 03_kpi_analysis.sql
├── 04_trend_analysis.sql
├── 05_category_analysis.sql
├── 06_climate_analysis.sql
└── 07_opportunity_analysis.sql

The analysis covers:

- Dataset overview
- Key performance indicators
- Revenue and sales trends
- Product category performance
- Climate and weather analysis
- Inventory and stockout analysis
- Potential arbitrage opportunities

---

Key Insights

Demand and Temperature

Demand increases as temperature increases.

The analysis shows that hot conditions have higher average units sold and higher demand compared with colder conditions.

This suggests that temperature can be used as an additional signal for inventory planning.

Product Performance

Cold Drinks and Ice Cream are among the strongest revenue-generating categories in the dataset.

These categories are also important when analyzing potential lost revenue caused by stockouts.

Stockout Risk

Stockouts represent a significant business opportunity because unavailable inventory can result in unfulfilled demand and potential lost revenue.

The analysis therefore focuses on identifying cities and product categories where stockout-related losses are higher.

Climate and Demand

Temperature has a positive relationship with demand, while rainfall and humidity show negative relationships in the dataset.

These relationships can be useful when developing demand forecasting and inventory planning strategies.

Opportunity Analysis

The Opportunity Flag, Demand Index and Micro-Climate Score can be combined to identify locations and product combinations that may require additional attention.

---

Business Recommendations

Based on the analysis:

1. Use weather and temperature conditions as additional inputs for demand forecasting.
2. Increase inventory planning for high-demand periods, particularly during hotter conditions.
3. Monitor Cold Drinks and Ice Cream closely because of their strong sales performance.
4. Identify locations with repeated stockouts and improve inventory availability.
5. Use competitor pricing together with demand and inventory information when making pricing decisions.
6. Prioritize high-opportunity city and product combinations for further analysis.

---

Project Structure

AtmoSync/
│
├── analysis/
│   └── exploratory_analysis.py
│
├── data/
│   ├── raw/
│   │   └── AtmoSync_Micro_Climate_Arbitrage_Analytics_10000.xlsx
│   │
│   └── cleaned/
│       └── clean_data.csv
│
├── data_cleaning/
│   └── clean_data.py
│
├── insights/
│   └── insights_report.md
│
├── sql/
│   ├── 01_setup_database.sql
│   ├── 02_data_overview.sql
│   ├── 03_kpi_analysis.sql
│   ├── 04_trend_analysis.sql
│   ├── 05_category_analysis.sql
│   ├── 06_climate_analysis.sql
│   └── 07_opportunity_analysis.sql
│
└── README.md

---

Conclusion

AtmoSync demonstrates how sales, inventory, pricing and micro-climate data can be combined to support business analysis.

The project moves from raw data cleaning and exploratory analysis to structured SQL analysis and business insights.

The final objective is to use these findings to support better inventory allocation, demand forecasting and identification of potential revenue opportunities.