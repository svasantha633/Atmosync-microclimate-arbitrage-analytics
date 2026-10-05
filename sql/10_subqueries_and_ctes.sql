-- Subqueries and Common Table Expressions (CTEs)

-- 1. Subquery: Micro-zones with average demand index above the overall network average
SELECT 
    City,
    Zone,
    COUNT(*) AS total_observations,
    ROUND(AVG(Demand_Index), 2) AS zone_avg_demand,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr
FROM atmosync_data
GROUP BY City, Zone
HAVING AVG(Demand_Index) > (SELECT AVG(Demand_Index) FROM atmosync_data)
ORDER BY zone_avg_demand DESC;

-- 2. CTE: Multi-step micro-climate arbitrage matrix (demand vs pricing)
WITH ClimatePriceMatrix AS (
    SELECT 
        Date,
        City,
        Zone,
        Product_Category,
        Micro_Climate_Score,
        Demand_Index,
        Avg_Price_INR,
        Competitor_Price_INR,
        Revenue_INR,
        Potential_Lost_Revenue_INR,
        CASE 
            WHEN Micro_Climate_Score >= 65.0 AND Avg_Price_INR <= Competitor_Price_INR THEN 'Q1: High Demand / Underpriced'
            WHEN Micro_Climate_Score >= 65.0 AND Avg_Price_INR > Competitor_Price_INR THEN 'Q2: High Demand / Premium Priced'
            WHEN Micro_Climate_Score < 50.0 AND Avg_Price_INR > Competitor_Price_INR THEN 'Q3: Low Demand / Overpriced'
            ELSE 'Q4: Normal Operations'
        END AS arbitrage_segment
    FROM atmosync_data
)
SELECT 
    arbitrage_segment,
    COUNT(*) AS observation_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM atmosync_data), 2) AS segment_pct,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr
FROM ClimatePriceMatrix
GROUP BY arbitrage_segment
ORDER BY total_revenue_inr DESC;

-- 3. CTE: Category pricing headroom upside in underpriced high-demand scenarios
WITH UnderpricedHighDemand AS (
    SELECT 
        Product_Category,
        Units_Sold,
        Avg_Price_INR,
        Competitor_Price_INR,
        (Competitor_Price_INR - Avg_Price_INR) AS price_diff,
        Revenue_INR
    FROM atmosync_data
    WHERE Micro_Climate_Score >= 65.0 
      AND Avg_Price_INR < Competitor_Price_INR
)
SELECT 
    Product_Category,
    COUNT(*) AS underpriced_high_demand_days,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS captured_revenue_inr,
    ROUND(AVG(price_diff), 2) AS avg_price_headroom_inr,
    ROUND(SUM(Units_Sold * price_diff), 2) AS estimated_additional_revenue_upside_inr
FROM UnderpricedHighDemand
GROUP BY Product_Category
ORDER BY estimated_additional_revenue_upside_inr DESC;
