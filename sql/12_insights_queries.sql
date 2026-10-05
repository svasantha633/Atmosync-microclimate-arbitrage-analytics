-- Final business insights and strategic decision queries

-- 1. Top 5 micro-zones with highest stockout revenue loss
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

-- 2. Category stockout penalty vs average pricing
SELECT 
    Product_Category,
    ROUND(AVG(Avg_Price_INR), 2) AS avg_unit_price_inr,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr,
    ROUND(SUM(Potential_Lost_Revenue_INR) * 100.0 / (SELECT SUM(Potential_Lost_Revenue_INR) FROM atmosync_data), 2) AS share_of_lost_revenue_pct
FROM atmosync_data
GROUP BY Product_Category
ORDER BY total_lost_revenue_inr DESC;

-- 3. Peak heatwave season (May-June) performance by city
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
