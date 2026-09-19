# 📊 AtmoSync Micro-Climate Arbitrage: End-to-End SQL Data Analysis

> **Data Analyst Portfolio Project** | Advanced SQL Analysis, Micro-Climate Demand Indexing, Pricing Arbitrage & Inventory Optimization.

---

## 📌 Project Overview

This project delivers a comprehensive, SQL-driven analysis of the cleaned **AtmoSync Micro-Climate Arbitrage Analytics** dataset. The objective is to evaluate how hyper-local micro-climate variations (temperature, humidity, rainfall, AQI, micro-climate score) drive consumer demand across 5 fast-moving product categories in 20 micro-zones across the National Capital Region (NCR - Delhi, Gurugram, Noida, Ghaziabad, Faridabad).

By writing advanced SQL queries utilizing **Window Functions (`RANK`, `DENSE_RANK`, `LAG`, `SUM OVER`)**, **Common Table Expressions (CTEs)**, **CASE WHEN multi-condition segmentations**, and **aggregate analytics**, this project uncovers actionable insights on pricing arbitrage, stockout revenue penalties, and seasonal heatwave demand spikes.

---

## 📂 Project Structure

```
SQL-Data-Analysis/
│
├── data/
│   └── clean_data.csv                    # Cleaned source dataset (8,127 records)
│
├── sql/
│   ├── 01_data_overview.sql               # Schema discovery, null audits, distributions
│   ├── 02_kpi_analysis.sql                # Executive KPIs, stockouts, price index
│   ├── 03_trend_analysis.sql              # Time series, MoM growth, temperature trends
│   ├── 04_category_analysis.sql           # Category share of wallet & weather matrix
│   ├── 05_advanced_analysis.sql           # CTEs, Window functions, Arbitrage matrix
│   └── 06_insights_queries.sql            # Specific business question queries
│
├── insights/
│   └── insights_report.md                 # Detailed Business & Insights Report
│
├── README.md                              # Main portfolio documentation
└── requirements.txt                       # Dependencies for reproduction
```

---

## 🛠️ Tools & Technologies Used

- **Language**: SQL (SQLite Compatible Standard SQL)
- **Database Engine**: SQLite 3 / Python embedded SQL runner
- **Data Manipulation**: Python 3.12, Pandas (for automated verification)
- **Version Control**: Git & GitHub (`Tahseen_Parvej` branch)

---

## 📊 Executive Key Performance Indicators (KPIs)

| KPI Metric | Value | Description |
| :--- | :--- | :--- |
| **Total Cleaned Observations** | `8,127` | Daily micro-zone product observations |
| **Total Revenue Generated** | **₹40,33,00,135.57** | Gross sales (Jan 1 to Aug 31, 2026) |
| **Total Lost Revenue (Stockouts)** | **₹33,20,620.38** | Unfulfilled revenue due to stockouts |
| **Total Units Sold** | `5,475,303` | Total product volume sold |
| **Total Unfulfilled Lost Units** | `44,102` | Demand lost during stockout events |
| **Overall Stockout Rate** | `13.77%` | 1,119 stockout events out of 8,127 records |
| **Average Unit Selling Price** | `₹73.78` | vs. Competitor Avg Price of ₹71.81 |
| **Average Competitor Price Index** | `1.027` | Premium pricing in ~62.7% of instances |
| **Pricing Headroom Opportunity** | **₹34,19,528.76** | Upside from matching competitor pricing in high-demand events |

---

## 💡 Top 5 Key Empirical Insights

1. **May-June Heatwave Peak**: May 2026 was the top revenue month (**₹6.68 Crore**), driving +17.97% MoM growth when average temperatures reached 35.86°C.
2. **Stockout Loss Concentration**: Ice Cream (25.6%) and Cold Drinks (24.6%) account for **50.2% of all lost revenue** (₹16.67 Lakhs lost combined).
3. **Micro-Zone Vulnerability**: Sector 150 (Noida), South Delhi (Delhi), and Cyber City (Gurugram) represent the highest stockout risk zones.
4. **Rainfall Volatility**: Rainy days cause a **50.2% drop in daily revenue per zone** compared to Hot & Sunny days.
5. **Weekend Surge**: Sunday and Saturday sales are **12.6% higher** than weekday averages.

---

## 🚀 How to Reproduce the Analysis

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/svasantha633/Atmosync-microclimate-arbitrage-analytics.git
   cd Atmosync-microclimate-arbitrage-analytics
   ```

2. **Run Python SQL Verification Script**:
   ```bash
   python -c "import pandas, sqlite3; print('Environment ready!')"
   ```

3. **Execute SQL Files Against SQLite**:
   ```bash
   python scratch/execute_sql.py SQL-Data-Analysis/sql/01_data_overview.sql
   python scratch/execute_sql.py SQL-Data-Analysis/sql/02_kpi_analysis.sql
   python scratch/execute_sql.py SQL-Data-Analysis/sql/03_trend_analysis.sql
   python scratch/execute_sql.py SQL-Data-Analysis/sql/04_category_analysis.sql
   python scratch/execute_sql.py SQL-Data-Analysis/sql/05_advanced_analysis.sql
   python scratch/execute_sql.py SQL-Data-Analysis/sql/06_insights_queries.sql
   ```

---

## 📌 Data Assumptions & Limitations

- **Source Scope**: Analysis strictly uses the cleaned dataset `clean_data.csv` (8,127 records).
- **Date Range**: January 1, 2026 to August 31, 2026 (243 observation days).
- **Pricing**: `Avg_Price_INR` and `Competitor_Price_INR` are treated as daily zone category averages.
