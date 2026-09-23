USE atmosync;

-- Revenue by product category
SELECT
    Product_Category,
    SUM(Revenue_INR) AS total_revenue
FROM atmosync_data
GROUP BY Product_Category
ORDER BY total_revenue DESC;


-- Units sold by product category
SELECT
    Product_Category,
    SUM(Units_Sold) AS total_units_sold
FROM atmosync_data
GROUP BY Product_Category
ORDER BY total_units_sold DESC;


-- Demand by product category
SELECT
    Product_Category,
    ROUND(AVG(Demand_Index), 2) AS average_demand
FROM atmosync_data
GROUP BY Product_Category
ORDER BY average_demand DESC;


-- Average selling price and competitor price
SELECT
    Product_Category,
    ROUND(AVG(Avg_Price_INR), 2) AS average_price,
    ROUND(AVG(Competitor_Price_INR), 2) AS competitor_price
FROM atmosync_data
GROUP BY Product_Category
ORDER BY average_price DESC;


-- Categories where our average price is higher than competitor price
SELECT
    Product_Category,
    ROUND(AVG(Avg_Price_INR), 2) AS average_price,
    ROUND(AVG(Competitor_Price_INR), 2) AS competitor_price
FROM atmosync_data
GROUP BY Product_Category
HAVING AVG(Avg_Price_INR) > AVG(Competitor_Price_INR)
ORDER BY average_price DESC;


-- Inventory by product category
SELECT
    Product_Category,
    SUM(Inventory_Units) AS total_inventory,
    ROUND(AVG(Inventory_Units), 2) AS average_inventory
FROM atmosync_data
GROUP BY Product_Category
ORDER BY total_inventory DESC;


-- Potential lost revenue by product category
SELECT
    Product_Category,
    SUM(Potential_Lost_Units) AS potential_lost_units,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY Product_Category
ORDER BY potential_lost_revenue DESC;


-- Stockout rate by product category
SELECT
    Product_Category,
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN LOWER(Stockout_Flag) IN ('yes', 'true', '1')
            THEN 1
            ELSE 0
        END
    ) AS stockout_records,
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
FROM atmosync_data
GROUP BY Product_Category
ORDER BY stockout_rate DESC;