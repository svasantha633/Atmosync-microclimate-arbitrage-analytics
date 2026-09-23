USE atmosync;

-- Total revenue
SELECT
    SUM(Revenue_INR) AS total_revenue
FROM atmosync_data;


-- Total units sold
SELECT
    SUM(Units_Sold) AS total_units_sold
FROM atmosync_data;


-- Average demand
SELECT
    ROUND(AVG(Demand_Index), 2) AS average_demand
FROM atmosync_data;


-- Total potential lost revenue
SELECT
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data;


-- Total potential lost units
SELECT
    SUM(Potential_Lost_Units) AS potential_lost_units
FROM atmosync_data;


-- Total inventory
SELECT
    SUM(Inventory_Units) AS total_inventory
FROM atmosync_data;


-- Stockout records
SELECT
    SUM(
        CASE
            WHEN LOWER(Stockout_Flag) IN ('yes', 'true', '1')
            THEN 1
            ELSE 0
        END
    ) AS stockout_records
FROM atmosync_data;


-- Stockout rate
SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN LOWER(Stockout_Flag) IN ('yes', 'true', '1')
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS stockout_rate
FROM atmosync_data;


-- Revenue and units by city
SELECT
    City,
    SUM(Units_Sold) AS units_sold,
    SUM(Revenue_INR) AS revenue
FROM atmosync_data
GROUP BY City
ORDER BY revenue DESC;


-- Revenue and demand by product category
SELECT
    Product_Category,
    SUM(Revenue_INR) AS revenue,
    SUM(Units_Sold) AS units_sold,
    ROUND(AVG(Demand_Index), 2) AS average_demand
FROM atmosync_data
GROUP BY Product_Category
ORDER BY revenue DESC;


-- Cities with high demand
SELECT
    City,
    ROUND(AVG(Demand_Index), 2) AS average_demand
FROM atmosync_data
GROUP BY City
HAVING AVG(Demand_Index) >= 70
ORDER BY average_demand DESC;


-- Cities with high potential lost revenue
SELECT
    City,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY City
ORDER BY potential_lost_revenue DESC;