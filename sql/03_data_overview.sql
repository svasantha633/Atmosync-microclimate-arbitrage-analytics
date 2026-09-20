-- Basic data overview and row profiling queries

-- 1. Total row count and distinct date/location counts
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Date) AS total_days,
    COUNT(DISTINCT City) AS total_cities,
    COUNT(DISTINCT Zone) AS total_zones,
    COUNT(DISTINCT Product_Category) AS total_categories
FROM atmosync_data;

-- 2. Range check for numeric weather and price columns
SELECT 
    MIN(Temperature_C) AS min_temp,
    MAX(Temperature_C) AS max_temp,
    ROUND(AVG(Temperature_C), 2) AS avg_temp,
    MIN(Avg_Price_INR) AS min_price,
    MAX(Avg_Price_INR) AS max_price,
    ROUND(AVG(Avg_Price_INR), 2) AS avg_price
FROM atmosync_data;

-- 3. Record count distribution by city
SELECT 
    City,
    COUNT(*) AS total_records,
    COUNT(DISTINCT Zone) AS total_zones
FROM atmosync_data
GROUP BY City
ORDER BY total_records DESC;
