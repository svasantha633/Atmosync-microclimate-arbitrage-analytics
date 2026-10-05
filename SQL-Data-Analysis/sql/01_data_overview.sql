-- ====================================================================
-- Script: 01_data_overview.sql
-- Purpose: Schema discovery, dataset structure, NULL checks, 
--          summary statistics, and categorical distributions.
-- Dataset: AtmoSync Micro-Climate Arbitrage Analytics (Cleaned)
-- ====================================================================

-- Query 1: Total Row Count and Unique Dimension Counts
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT Date) AS total_observation_days,
    COUNT(DISTINCT City) AS total_cities,
    COUNT(DISTINCT Zone) AS total_zones,
    COUNT(DISTINCT Product_Category) AS total_categories,
    COUNT(DISTINCT Weather_Condition) AS total_weather_conditions
FROM atmosync_data;

-- Query 2: Null and Missing Value Audit Across Key Attributes
SELECT 
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN Zone IS NULL THEN 1 ELSE 0 END) AS null_zone,
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS null_product_category,
    SUM(CASE WHEN Temperature_C IS NULL THEN 1 ELSE 0 END) AS null_temp,
    SUM(CASE WHEN Revenue_INR IS NULL THEN 1 ELSE 0 END) AS null_revenue,
    SUM(CASE WHEN Micro_Climate_Score IS NULL THEN 1 ELSE 0 END) AS null_micro_climate_score
FROM atmosync_data;

-- Query 3: Range and Distribution Summary Statistics for Numerical Attributes
SELECT 
    'Temperature_C' AS metric, MIN(Temperature_C) AS min_val, MAX(Temperature_C) AS max_val, ROUND(AVG(Temperature_C), 2) AS avg_val FROM atmosync_data
UNION ALL
SELECT 
    'Humidity_Pct', MIN(Humidity_Pct), MAX(Humidity_Pct), ROUND(AVG(Humidity_Pct), 2) FROM atmosync_data
UNION ALL
SELECT 
    'Rainfall_mm', MIN(Rainfall_mm), MAX(Rainfall_mm), ROUND(AVG(Rainfall_mm), 2) FROM atmosync_data
UNION ALL
SELECT 
    'AQI', MIN(AQI), MAX(AQI), ROUND(AVG(AQI), 2) FROM atmosync_data
UNION ALL
SELECT 
    'Units_Sold', MIN(Units_Sold), MAX(Units_Sold), ROUND(AVG(Units_Sold), 2) FROM atmosync_data
UNION ALL
SELECT 
    'Avg_Price_INR', MIN(Avg_Price_INR), MAX(Avg_Price_INR), ROUND(AVG(Avg_Price_INR), 2) FROM atmosync_data
UNION ALL
SELECT 
    'Revenue_INR', MIN(Revenue_INR), MAX(Revenue_INR), ROUND(AVG(Revenue_INR), 2) FROM atmosync_data
UNION ALL
SELECT 
    'Micro_Climate_Score', MIN(Micro_Climate_Score), MAX(Micro_Climate_Score), ROUND(AVG(Micro_Climate_Score), 2) FROM atmosync_data;

-- Query 4: Distribution of Records by City and Micro-Zone
SELECT 
    City,
    COUNT(DISTINCT Zone) AS zone_count,
    COUNT(*) AS record_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM atmosync_data), 2) AS pct_share
FROM atmosync_data
GROUP BY City
ORDER BY record_count DESC;

-- Query 5: Distribution of Records by Opportunity Flag
SELECT 
    Opportunity_Flag,
    COUNT(*) AS record_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM atmosync_data), 2) AS percentage_share
FROM atmosync_data
GROUP BY Opportunity_Flag
ORDER BY record_count DESC;
