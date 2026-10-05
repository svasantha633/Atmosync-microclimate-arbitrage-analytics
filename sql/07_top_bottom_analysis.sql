-- Top and bottom ranking queries

-- 1. Top 5 micro-zones by total revenue
SELECT 
    City,
    Zone,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_climate_score
FROM atmosync_data
GROUP BY City, Zone
ORDER BY total_revenue_inr DESC
LIMIT 5;

-- 2. Bottom 5 micro-zones by total revenue
SELECT 
    City,
    Zone,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_climate_score
FROM atmosync_data
GROUP BY City, Zone
ORDER BY total_revenue_inr ASC
LIMIT 5;

-- 3. Top 5 micro-zones by lost revenue (stockout vulnerability)
SELECT 
    City,
    Zone,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_events,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr
FROM atmosync_data
GROUP BY City, Zone
ORDER BY total_lost_revenue_inr DESC
LIMIT 5;
