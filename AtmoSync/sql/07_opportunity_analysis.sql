USE atmosync;

-- High demand with low inventory
SELECT
    City,
    Product_Category,
    ROUND(AVG(Demand_Index), 2) AS average_demand,
    ROUND(AVG(Inventory_Units), 2) AS average_inventory,
    SUM(Potential_Lost_Units) AS potential_lost_units,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY City, Product_Category
HAVING AVG(Demand_Index) >= 70
   AND AVG(Inventory_Units) <= 150
ORDER BY potential_lost_revenue DESC;


-- Potential arbitrage opportunities
SELECT
    City,
    Product_Category,
    ROUND(AVG(Avg_Price_INR), 2) AS average_price,
    ROUND(AVG(Competitor_Price_INR), 2) AS competitor_price,
    ROUND(AVG(Competitor_Price_INR - Avg_Price_INR), 2) AS price_gap,
    ROUND(AVG(Demand_Index), 2) AS average_demand
FROM atmosync_data
GROUP BY City, Product_Category
HAVING AVG(Demand_Index) >= 70
   AND AVG(Avg_Price_INR) < AVG(Competitor_Price_INR)
ORDER BY price_gap DESC;


-- Opportunity flag summary
SELECT
    Opportunity_Flag,
    COUNT(*) AS records,
    ROUND(AVG(Demand_Index), 2) AS average_demand,
    ROUND(AVG(Micro_Climate_Score), 2) AS average_climate_score,
    SUM(Revenue_INR) AS total_revenue,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY Opportunity_Flag
ORDER BY potential_lost_revenue DESC;


-- Top city and product opportunities
SELECT
    City,
    Product_Category,
    SUM(Revenue_INR) AS total_revenue,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue,
    ROUND(AVG(Demand_Index), 2) AS average_demand,
    ROUND(AVG(Micro_Climate_Score), 2) AS average_climate_score
FROM atmosync_data
GROUP BY City, Product_Category
ORDER BY potential_lost_revenue DESC
LIMIT 20;


-- High demand and high climate risk
SELECT
    City,
    Product_Category,
    ROUND(AVG(Demand_Index), 2) AS average_demand,
    ROUND(AVG(Micro_Climate_Score), 2) AS average_climate_score,
    SUM(Revenue_INR) AS total_revenue,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY City, Product_Category
HAVING AVG(Demand_Index) >= 70
   AND AVG(Micro_Climate_Score) >= 60
ORDER BY potential_lost_revenue DESC;


-- City level demand and inventory risk
SELECT
    City,
    ROUND(AVG(Demand_Index), 2) AS average_demand,
    ROUND(AVG(Inventory_Units), 2) AS average_inventory,
    SUM(Units_Sold) AS total_units_sold,
    SUM(Revenue_INR) AS total_revenue,
    SUM(Potential_Lost_Units) AS potential_lost_units,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY City
HAVING AVG(Demand_Index) >= 60
ORDER BY potential_lost_revenue DESC;


-- Product categories with the highest potential loss
SELECT
    Product_Category,
    SUM(Potential_Lost_Units) AS potential_lost_units,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY Product_Category
ORDER BY potential_lost_revenue DESC;


-- Opportunity analysis by city
SELECT
    City,
    Opportunity_Flag,
    COUNT(*) AS records,
    ROUND(AVG(Demand_Index), 2) AS average_demand,
    SUM(Revenue_INR) AS total_revenue,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY City, Opportunity_Flag
ORDER BY City, potential_lost_revenue DESC;