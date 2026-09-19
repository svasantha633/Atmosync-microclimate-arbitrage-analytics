-- ====================================================================
-- Script: 02_kpi_analysis.sql
-- Purpose: Executive KPIs, revenue metrics, stockout impact, 
--          competitor price index, and micro-climate indicators.
-- Dataset: AtmoSync Micro-Climate Arbitrage Analytics (Cleaned)
-- ====================================================================

-- Query 1: High-Level Executive Key Performance Indicators (KPIs)
SELECT 
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR) * 100.0 / NULLIF(SUM(Revenue_INR) + SUM(Potential_Lost_Revenue_INR), 0), 2) AS lost_revenue_pct,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_instances,
    ROUND(SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stockout_rate_pct,
    ROUND(AVG(Avg_Price_INR), 2) AS overall_avg_price_inr,
    ROUND(AVG(Competitor_Price_INR), 2) AS overall_avg_competitor_price_inr,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_micro_climate_score,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data;

-- Query 2: Pricing Arbitrage KPI & Competitor Price Ratio by City
SELECT 
    City,
    ROUND(AVG(Avg_Price_INR), 2) AS avg_our_price_inr,
    ROUND(AVG(Competitor_Price_INR), 2) AS avg_competitor_price_inr,
    ROUND(AVG(Avg_Price_INR - Competitor_Price_INR), 2) AS price_premium_inr,
    ROUND(AVG(Avg_Price_INR / NULLIF(Competitor_Price_INR, 0)), 3) AS price_index_ratio,
    SUM(CASE WHEN Avg_Price_INR > Competitor_Price_INR THEN 1 ELSE 0 END) AS premium_priced_instances,
    ROUND(SUM(CASE WHEN Avg_Price_INR > Competitor_Price_INR THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS premium_priced_pct
FROM atmosync_data
GROUP BY City
ORDER BY price_index_ratio DESC;

-- Query 3: Stockout Revenue Loss and Inventory Health KPI by City
SELECT 
    City,
    COUNT(*) AS total_observations,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_events,
    ROUND(SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stockout_rate_pct,
    SUM(Inventory_Units) AS total_inventory_units,
    SUM(Units_Sold) AS total_units_sold,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS lost_revenue_inr
FROM atmosync_data
GROUP BY City
ORDER BY lost_revenue_inr DESC;

-- Query 4: Performance KPIs by Opportunity Flag Segment
SELECT 
    Opportunity_Flag,
    COUNT(*) AS record_count,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Revenue_INR), 2) AS avg_revenue_per_observation,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_micro_climate_score,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_count
FROM atmosync_data
GROUP BY Opportunity_Flag
ORDER BY total_revenue_inr DESC;

-- Query 5: Environmental & Micro-Climate Risk Threshold KPIs
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN Temperature_C >= 35.0 THEN 1 ELSE 0 END) AS extreme_heat_days,
    ROUND(SUM(CASE WHEN Temperature_C >= 35.0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS extreme_heat_pct,
    SUM(CASE WHEN Rainfall_mm > 0 THEN 1 ELSE 0 END) AS rainy_days,
    ROUND(SUM(CASE WHEN Rainfall_mm > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS rainy_days_pct,
    SUM(CASE WHEN AQI > 200 THEN 1 ELSE 0 END) AS poor_air_quality_days,
    ROUND(SUM(CASE WHEN AQI > 200 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS poor_aqi_pct
FROM atmosync_data;
