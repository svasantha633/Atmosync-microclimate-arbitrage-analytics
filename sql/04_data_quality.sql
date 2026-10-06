-- Data quality validation and sanity checks

-- 1. NULL value audit across main columns
SELECT 
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS null_dates,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_cities,
    SUM(CASE WHEN Zone IS NULL THEN 1 ELSE 0 END) AS null_zones,
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS null_categories,
    SUM(CASE WHEN Revenue_INR IS NULL THEN 1 ELSE 0 END) AS null_revenue
FROM atmosync_data;

-- 2. Duplicate key check on (Date, City, Zone, Product_Category)
SELECT 
    Date, City, Zone, Product_Category, COUNT(*) AS duplicate_count
FROM atmosync_data
GROUP BY Date, City, Zone, Product_Category
HAVING COUNT(*) > 1;

-- 3. Validation for out-of-bounds or unexpected numeric values
SELECT 
    SUM(CASE WHEN Temperature_C < 0 OR Temperature_C > 60 THEN 1 ELSE 0 END) AS invalid_temp_count,
    SUM(CASE WHEN Micro_Climate_Score < 0 OR Micro_Climate_Score > 100 THEN 1 ELSE 0 END) AS invalid_score_count,
    SUM(CASE WHEN Units_Sold < 0 THEN 1 ELSE 0 END) AS negative_units_count,
    SUM(CASE WHEN Revenue_INR < 0 THEN 1 ELSE 0 END) AS negative_revenue_count
FROM atmosync_data;
