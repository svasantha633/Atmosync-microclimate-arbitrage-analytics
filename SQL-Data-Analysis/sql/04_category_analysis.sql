-- ====================================================================
-- Script: 04_category_analysis.sql
-- Purpose: Category performance, revenue share of wallet, weather sensitivity,
--          pricing arbitrage, and stockout vulnerability by product category.
-- Dataset: AtmoSync Micro-Climate Arbitrage Analytics (Cleaned)
-- ====================================================================

-- Query 1: Category Revenue Share, Total Volume, and Average Pricing Summary
SELECT 
    Product_Category,
    COUNT(*) AS total_observations,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(SUM(Revenue_INR) * 100.0 / (SELECT SUM(Revenue_INR) FROM atmosync_data), 2) AS revenue_share_pct,
    ROUND(AVG(Avg_Price_INR), 2) AS avg_selling_price_inr,
    ROUND(AVG(Competitor_Price_INR), 2) AS avg_competitor_price_inr,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY Product_Category
ORDER BY total_revenue_inr DESC;

-- Query 2: Category Demand & Units Sold Across Weather Conditions
SELECT 
    Product_Category,
    Weather_Condition,
    COUNT(*) AS record_count,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Units_Sold), 2) AS avg_units_per_day,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY Product_Category, Weather_Condition
ORDER BY Product_Category, total_revenue_inr DESC;

-- Query 3: Stockout Vulnerability & Revenue Opportunity Loss by Category
SELECT 
    Product_Category,
    COUNT(*) AS total_observations,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_count,
    ROUND(SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stockout_rate_pct,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr,
    ROUND(SUM(Potential_Lost_Revenue_INR) * 100.0 / (SELECT SUM(Potential_Lost_Revenue_INR) FROM atmosync_data), 2) AS share_of_lost_revenue_pct
FROM atmosync_data
GROUP BY Product_Category
ORDER BY total_lost_revenue_inr DESC;

-- Query 4: Category Pricing Premium vs Competitor & Profitability Potential
SELECT 
    Product_Category,
    ROUND(AVG(Avg_Price_INR), 2) AS our_avg_price,
    ROUND(AVG(Competitor_Price_INR), 2) AS competitor_avg_price,
    ROUND(AVG(Avg_Price_INR - Competitor_Price_INR), 2) AS price_premium_inr,
    ROUND(AVG(Avg_Price_INR / NULLIF(Competitor_Price_INR, 0)), 3) AS price_ratio,
    SUM(CASE WHEN Avg_Price_INR > Competitor_Price_INR THEN 1 ELSE 0 END) AS premium_instances,
    ROUND(SUM(CASE WHEN Avg_Price_INR > Competitor_Price_INR THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS premium_pct
FROM atmosync_data
GROUP BY Product_Category
ORDER BY price_premium_inr DESC;

-- Query 5: Cross-City Category Matrix (Top Category per City)
SELECT 
    City,
    Product_Category,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY City, Product_Category
ORDER BY City, total_revenue_inr DESC;
