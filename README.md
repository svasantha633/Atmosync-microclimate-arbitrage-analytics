# AtmoSync Micro-Climate Data Analysis

SQL data analysis on micro-climate demand and sales data across 5 NCR cities (Delhi, Gurugram, Noida, Ghaziabad, Faridabad).

## Dataset Overview
- **Source**: `data cleaning/clean_data.csv`
- **Records**: 8,127 clean daily micro-zone observations
- **Timeframe**: Jan 1, 2026 – Aug 31, 2026

## Project Structure
```
├── data/
│   ├── atmosync.db                     # SQLite database file
│   └── clean_data.csv                  # Cleaned dataset
├── sql/
│   ├── 02_create_tables.sql            # Table DDL and indexes
│   ├── 03_data_overview.sql            # Data profiling queries
│   ├── 04_data_quality.sql             # Data validation queries
│   ├── 05_basic_kpis.sql               # Executive KPI queries
│   ├── 06_category_analysis.sql        # Product category queries
│   ├── 07_top_bottom_analysis.sql     # Top & bottom ranking queries
│   ├── 08_time_trend_analysis.sql     # Time-series trend queries
│   ├── 09_distribution_segmentation.sql # Distribution & CASE WHEN queries
│   ├── 10_subqueries_and_ctes.sql      # Subquery & CTE queries
│   ├── 11_window_functions_and_anomalies.sql # Window functions & anomaly queries
│   └── 12_insights_queries.sql         # Final business insight queries
├── insights/
│   └── insights_report.md              # Detailed Insights Report
├── scripts/
│   └── import_data.py                  # Python database import script
└── README.md
```

## Key Findings Summary
- **Total Generated Revenue**: ₹40.33 Crore across 5,475,303 units sold.
- **Stockout Revenue Loss**: ₹33.20 Lakhs lost across 44,102 unfulfilled units (13.77% stockout rate).
- **Pricing Headroom**: ₹34.19 Lakhs upside in underpriced high-demand scenarios.
- **Top Category**: Ice Cream contributed ₹11.25 Crore (27.9% share of wallet).

## How to Run
1. Run Python import script:
   `python scripts/import_data.py`
2. Execute SQL scripts against `data/atmosync.db`.