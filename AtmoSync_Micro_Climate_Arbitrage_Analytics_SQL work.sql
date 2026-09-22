use naved;
select * from atmosync_dataset;
Business insight: Identifies the cities generating the highest revenue and demand.
SELECT
    City,
    SUM(Revenue_INR) AS Total_Revenue,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Potential_Lost_Revenue_INR) AS Potential_Lost_Revenue,
    AVG(Demand_Index) AS Avg_Demand_Index,
    AVG(Micro_Climate_Score) AS Avg_Micro_Climate_Score
FROM atmosync_dataset
GROUP BY City
ORDER BY Total_Revenue DESC;

Business insight: Shows which product categories contribute most to potential lost revenue.
SELECT
    Product_Category,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Revenue_INR) AS Total_Revenue,
    AVG(Avg_Price_INR) AS Avg_Price,
    SUM(Potential_Lost_Revenue_INR) AS Potential_Lost_Revenue
FROM atmosync_dataset
GROUP BY Product_Category
ORDER BY Total_Revenue DESC;

Business insight: Shows which product categories contribute most to revenue.
SELECT
    Product_Category,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Revenue_INR) AS Total_Revenue,
    AVG(Avg_Price_INR) AS Avg_Price
FROM atmosync_dataset
GROUP BY Product_Category
ORDER BY Total_Revenue DESC;

Business insight: Quantifies the sales and revenue opportunity lost because of stockouts.
SELECT
    Stockout,
    COUNT(*) AS Records,
    SUM(Potential_Lost_Units) AS Lost_Units,
    SUM(Potential_Lost_Revenue_INR) AS Lost_Revenue
FROM atmosync_dataset
GROUP BY Stockout;

Business insight: Helps identify locations where inventory planning needs improvement.
SELECT
    City,
    SUM(Potential_Lost_Units) AS Potential_Lost_Units,
    SUM(Potential_Lost_Revenue_INR) AS Potential_Lost_Revenue
FROM atmosync_dataset
GROUP BY City
ORDER BY Potential_Lost_Revenue DESC;

Business insight: Shows how different weather conditions are associated with customer demand.
SELECT
    Weather_Condition,
    AVG(Demand_Index) AS Avg_Demand,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Revenue_INR) AS Total_Revenue
FROM atmosync_dataset
GROUP BY Weather_Condition
ORDER BY Avg_Demand DESC;

Business insight: Shows where your pricing is higher or lower than competitors.
SELECT
    CASE
        WHEN Temperature_C < 20 THEN 'Below 20°C'
        WHEN Temperature_C BETWEEN 20 AND 30 THEN '20-30°C'
        WHEN Temperature_C BETWEEN 31 AND 40 THEN '31-40°C'
        ELSE 'Above 40°C'
    END AS Temperature_Range,
    AVG(Demand_Index) AS Avg_Demand,
    SUM(Units_Sold) AS Units_Sold,
    SUM(Revenue_INR) AS Revenue
FROM atmosync_dataset
GROUP BY
    CASE
        WHEN Temperature_C < 20 THEN 'Below 20°C'
        WHEN Temperature_C BETWEEN 20 AND 30 THEN '20-30°C'
        WHEN Temperature_C BETWEEN 31 AND 40 THEN '31-40°C'
        ELSE 'Above 40°C'
    END
ORDER BY Avg_Demand DESC;

Business insight: Shows where your pricing is higher or lower than competitors.
SELECT
    Product_Category,
    AVG(Avg_Price_INR) AS Your_Avg_Price,
    AVG(Competitor_Price_INR) AS Competitor_Avg_Price,
    AVG(Avg_Price_INR - Competitor_Price_INR) AS Price_Difference
FROM atmosync_dataset
GROUP BY Product_Category
ORDER BY Price_Difference DESC;

Business insight: Finds city/zone combinations with stronger micro-climate and demand conditions.
SELECT
    City,
    Zone,
    AVG(Micro_Climate_Score) AS Avg_Micro_Climate_Score,
    AVG(Demand_Index) AS Avg_Demand,
    SUM(Revenue_INR) AS Revenue
FROM atmosync_dataset
GROUP BY City, Zone
ORDER BY Avg_Micro_Climate_Score DESC;

Business insight: Compares business performance across different opportunity segments.
SELECT
    Opportunity_Flag,
    COUNT(*) AS Records,
    SUM(Units_Sold) AS Units_Sold,
    SUM(Revenue_INR) AS Revenue,
    SUM(Potential_Lost_Revenue_INR) AS Potential_Lost_Revenue
FROM atmosync_dataset
GROUP BY Opportunity_Flag
ORDER BY Revenue DESC;