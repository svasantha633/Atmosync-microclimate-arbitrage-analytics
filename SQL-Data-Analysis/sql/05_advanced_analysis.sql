-- ====================================================================
-- Script: 05_advanced_analysis.sql
-- Purpose: Advanced SQL analysis using CTEs, Window Functions 
--          (RANK, DENSE_RANK, LAG, SUM OVER), Arbitrage Segmentation,
--          and Stockout Risk Clustering.
-- Dataset: AtmoSync Micro-Climate Arbitrage Analytics (Cleaned)
-- ====================================================================

-- Query 1: Micro-Zone Performance Ranking Within Each City (DENSE_RANK)
WITH ZonePerformance AS (
    SELECT 
        City,
        Zone,
        COUNT(*) AS total_observations,
        SUM(Units_Sold) AS total_units_sold,
        ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
        ROUND(AVG(Micro_Climate_Score), 2) AS avg_micro_climate_score,
        ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS lost_revenue_inr
    FROM atmosync_data
    GROUP BY City, Zone
)
SELECT 
    City,
    Zone,
    total_revenue_inr,
    total_units_sold,
    lost_revenue_inr,
    avg_micro_climate_score,
    DENSE_RANK() OVER (PARTITION BY City ORDER BY total_revenue_inr DESC) AS revenue_rank_in_city,
    DENSE_RANK() OVER (PARTITION BY City ORDER BY lost_revenue_inr DESC) AS stockout_risk_rank_in_city
FROM ZonePerformance
ORDER BY City, revenue_rank_in_city;

-- Query 2: Cumulative Revenue Contribution by Month and Product Category (Running Total)
WITH MonthlyCategoryRevenue AS (
    SELECT 
        Product_Category,
        strftime('%Y-%m', Date) AS month_year,
        ROUND(SUM(Revenue_INR), 2) AS monthly_revenue_inr
    FROM atmosync_data
    GROUP BY Product_Category, strftime('%Y-%m', Date)
)
SELECT 
    Product_Category,
    month_year,
    monthly_revenue_inr,
    ROUND(SUM(monthly_revenue_inr) OVER (
        PARTITION BY Product_Category 
        ORDER BY month_year 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS cumulative_running_revenue_inr
FROM MonthlyCategoryRevenue
ORDER BY Product_Category, month_year;

-- Query 3: Multi-Condition Micro-Climate Arbitrage Matrix (CASE WHEN Segmentation)
WITH ArbitrageSegmentation AS (
    SELECT 
        Date,
        City,
        Zone,
        Product_Category,
        Micro_Climate_Score,
        Demand_Index,
        Avg_Price_INR,
        Competitor_Price_INR,
        (Avg_Price_INR - Competitor_Price_INR) AS price_diff,
        Revenue_INR,
        Stockout,
        Potential_Lost_Revenue_INR,
        CASE 
            WHEN Micro_Climate_Score >= 65.0 AND Avg_Price_INR <= Competitor_Price_INR THEN 'Q1: High Climate Demand / Underpriced (Prime Premium Target)'
            WHEN Micro_Climate_Score >= 65.0 AND Avg_Price_INR > Competitor_Price_INR THEN 'Q2: High Climate Demand / Premium Priced (Optimal Capture)'
            WHEN Micro_Climate_Score < 50.0 AND Avg_Price_INR > Competitor_Price_INR THEN 'Q3: Low Demand / Overpriced (Price Reduction Risk)'
            ELSE 'Q4: Balanced / Normal Operations'
        END AS arbitrage_segment
    FROM atmosync_data
)
SELECT 
    arbitrage_segment,
    COUNT(*) AS record_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM atmosync_data), 2) AS segment_pct,
    SUM(Units_Sold_Placeholder.Units_Sold) AS total_units_sold,
    ROUND(SUM(a.Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(a.Demand_Index), 2) AS avg_demand_index,
    ROUND(SUM(a.Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr
FROM ArbitrageSegmentation a
JOIN atmosync_data Units_Sold_Placeholder ON a.Date = Units_Sold_Placeholder.Date 
     AND a.Zone = Units_Sold_Placeholder.Zone 
     AND a.Product_Category = Units_Sold_Placeholder.Product_Category
GROUP BY arbitrage_segment
ORDER BY total_revenue_inr DESC;

-- Query 4: Daily Demand Velocity & Lagged Demand Trend per Category (LAG Window Function)
WITH DailyCategoryDemand AS (
    SELECT 
        Date,
        Product_Category,
        SUM(Units_Sold) AS daily_units_sold,
        ROUND(AVG(Micro_Climate_Score), 2) AS avg_climate_score
    FROM atmosync_data
    GROUP BY Date, Product_Category
)
SELECT 
    Date,
    Product_Category,
    daily_units_sold,
    avg_climate_score,
    LAG(daily_units_sold, 1) OVER (PARTITION BY Product_Category ORDER BY Date) AS prev_day_units_sold,
    LAG(daily_units_sold, 7) OVER (PARTITION BY Product_Category ORDER BY Date) AS prev_week_same_day_units,
    ROUND(
        (daily_units_sold - LAG(daily_units_sold, 1) OVER (PARTITION BY Product_Category ORDER BY Date)) * 100.0 /
        NULLIF(LAG(daily_units_sold, 1) OVER (PARTITION BY Product_Category ORDER BY Date), 0), 2
    ) AS daily_growth_pct
FROM DailyCategoryDemand
ORDER BY Product_Category, Date
LIMIT 30;

-- Query 5: Identification of High Stockout Risk Micro-Zones (Subquery & HAVING Filter)
SELECT 
    City,
    Zone,
    COUNT(*) AS total_observations,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_count,
    ROUND(SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stockout_rate_pct,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr,
    ROUND(AVG(Inventory_Units), 2) AS avg_inventory_level
FROM atmosync_data
GROUP BY City, Zone
HAVING stockout_rate_pct >= 13.5
ORDER BY total_lost_revenue_inr DESC;
