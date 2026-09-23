USE atmosync;

-- Total records
SELECT COUNT(*) AS total_records
FROM atmosync_data;

-- Total cities
SELECT COUNT(DISTINCT City) AS total_cities
FROM atmosync_data;

-- Cities in the dataset
SELECT DISTINCT City
FROM atmosync_data
ORDER BY City;

-- Product categories
SELECT DISTINCT Product_Category
FROM atmosync_data
ORDER BY Product_Category;

-- Date range
SELECT
    MIN(`Date`) AS start_date,
    MAX(`Date`) AS end_date
FROM atmosync_data;

-- Total units and revenue
SELECT
    SUM(Units_Sold) AS total_units_sold,
    SUM(Revenue_INR) AS total_revenue
FROM atmosync_data;

-- Average demand and climate score
SELECT
    ROUND(AVG(Demand_Index), 2) AS avg_demand,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_climate_score
FROM atmosync_data;

-- Inventory and potential loss
SELECT
    SUM(Inventory_Units) AS total_inventory,
    SUM(Potential_Lost_Units) AS lost_units,
    SUM(Potential_Lost_Revenue_INR) AS lost_revenue
FROM atmosync_data;

-- Records by city
SELECT
    City,
    COUNT(*) AS records
FROM atmosync_data
GROUP BY City
ORDER BY records DESC;

-- Revenue by city
SELECT
    City,
    SUM(Revenue_INR) AS total_revenue
FROM atmosync_data
GROUP BY City
ORDER BY total_revenue DESC;

-- Records by product category
SELECT
    Product_Category,
    COUNT(*) AS records
FROM atmosync_data
GROUP BY Product_Category
ORDER BY records DESC;

-- Weather conditions
SELECT
    Weather_Condition,
    COUNT(*) AS records
FROM atmosync_data
GROUP BY Weather_Condition
ORDER BY records DESC;

-- Opportunity flags
SELECT
    Opportunity_Flag,
    COUNT(*) AS records
FROM atmosync_data
GROUP BY Opportunity_Flag
ORDER BY records DESC;