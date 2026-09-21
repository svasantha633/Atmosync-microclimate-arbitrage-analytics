-- Basic KPI summary metrics

-- 1. High-level sales and revenue KPIs
SELECT 
    COUNT(*) AS total_observations,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr,
    ROUND(SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stockout_rate_pct
FROM atmosync_data;

-- 2. Average pricing, demand index, and micro-climate score
SELECT 
    ROUND(AVG(Avg_Price_INR), 2) AS avg_selling_price_inr,
    ROUND(AVG(Competitor_Price_INR), 2) AS avg_competitor_price_inr,
    ROUND(AVG(Avg_Price_INR - Competitor_Price_INR), 2) AS avg_price_premium_inr,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_micro_climate_score
FROM atmosync_data;

-- 3. City-level KPI summary
SELECT 
    City,
    COUNT(*) AS records,
    SUM(Units_Sold) AS city_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS city_revenue_inr,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS city_lost_revenue_inr,
    ROUND(AVG(Avg_Price_INR), 2) AS city_avg_price
FROM atmosync_data
GROUP BY City
ORDER BY city_revenue_inr DESC;
