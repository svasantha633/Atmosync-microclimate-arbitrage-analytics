-- ====================================================================
-- Script: 06_insights_queries.sql
-- Purpose: Specific business question queries driving key actionable 
--          insights for executive strategy and micro-climate arbitrage.
-- Dataset: AtmoSync Micro-Climate Arbitrage Analytics (Cleaned)
-- ====================================================================

-- Query 1: Insight #1 - Top 5 Micro-Zones Accountable for Maximum Stockout Revenue Loss
SELECT 
    City,
    Zone,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_events,
    ROUND(SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stockout_rate_pct,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr,
    ROUND(SUM(Potential_Lost_Revenue_INR) * 100.0 / (SELECT SUM(Potential_Lost_Revenue_INR) FROM atmosync_data), 2) AS pct_of_all_lost_revenue
FROM atmosync_data
GROUP BY City, Zone
ORDER BY total_lost_revenue_inr DESC
LIMIT 5;

-- Query 2: Insight #2 - Micro-Climate Arbitrage Opportunity (High Demand + Underpriced Products)
SELECT 
    Product_Category,
    COUNT(*) AS underpriced_high_demand_instances,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS captured_revenue_inr,
    ROUND(AVG(Competitor_Price_INR - Avg_Price_INR), 2) AS avg_price_headroom_inr,
    ROUND(SUM(Units_Sold * (Competitor_Price_INR - Avg_Price_INR)), 2) AS estimated_additional_revenue_opportunity_inr
FROM atmosync_data
WHERE Micro_Climate_Score >= 65.0 
  AND Avg_Price_INR < Competitor_Price_INR
GROUP BY Product_Category
ORDER BY estimated_additional_revenue_opportunity_inr DESC;

-- Query 3: Insight #3 - Weather Sensitivity & Revenue Volatility Factor
SELECT 
    Weather_Condition,
    COUNT(*) AS total_days_recorded,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Revenue_INR), 2) AS avg_daily_revenue_per_zone,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_micro_climate_score
FROM atmosync_data
GROUP BY Weather_Condition
ORDER BY avg_daily_revenue_per_zone DESC;

-- Query 4: Insight #4 - Stockout Penalty vs Price Category Analysis
SELECT 
    Product_Category,
    ROUND(AVG(Avg_Price_INR), 2) AS avg_unit_price_inr,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr,
    ROUND(SUM(Potential_Lost_Revenue_INR) * 100.0 / (SELECT SUM(Potential_Lost_Revenue_INR) FROM atmosync_data), 2) AS share_of_lost_revenue_pct
FROM atmosync_data
GROUP BY Product_Category
ORDER BY total_lost_revenue_inr DESC;

-- Query 5: Insight #5 - High Heat Wave Peak Season (May-June) Arbitrage Performance
SELECT 
    City,
    SUM(Units_Sold) AS peak_season_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS peak_season_revenue_inr,
    ROUND(AVG(Demand_Index), 2) AS peak_season_demand_index,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS peak_season_lost_revenue_inr
FROM atmosync_data
WHERE strftime('%m', Date) IN ('04', '05', '06')
GROUP BY City
ORDER BY peak_season_revenue_inr DESC;
