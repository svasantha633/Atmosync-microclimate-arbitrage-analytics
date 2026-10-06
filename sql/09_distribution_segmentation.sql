-- Distribution, segmentation, and advanced filtering queries

-- 1. Demand sensitivity across temperature buckets
SELECT 
    CASE 
        WHEN Temperature_C < 15.0 THEN '1. Mild Cold (< 15°C)'
        WHEN Temperature_C BETWEEN 15.0 AND 24.99 THEN '2. Moderate (15-25°C)'
        WHEN Temperature_C BETWEEN 25.0 AND 34.99 THEN '3. Warm (25-35°C)'
        WHEN Temperature_C BETWEEN 35.0 AND 39.99 THEN '4. Hot (35-40°C)'
        ELSE '5. Extreme Heat (>= 40°C)'
    END AS temp_bucket,
    COUNT(*) AS total_records,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Units_Sold), 2) AS avg_units_sold,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY temp_bucket
ORDER BY temp_bucket;

-- 2. Pricing opportunity segmentation using CASE WHEN
SELECT 
    CASE 
        WHEN Avg_Price_INR > Competitor_Price_INR THEN 'Premium Priced'
        WHEN Avg_Price_INR < Competitor_Price_INR THEN 'Underpriced'
        ELSE 'Equal Price'
    END AS price_segment,
    COUNT(*) AS total_records,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY price_segment
ORDER BY total_revenue_inr DESC;

-- 3. Advanced filtering: High stockout risk zones (stockout rate >= 13.5%)
SELECT 
    City,
    Zone,
    COUNT(*) AS total_observations,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_count,
    ROUND(SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stockout_rate_pct,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr
FROM atmosync_data
GROUP BY City, Zone
HAVING stockout_rate_pct >= 13.5
ORDER BY total_lost_revenue_inr DESC;
