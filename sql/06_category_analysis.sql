-- Category-level sales, revenue, pricing, and stockout analysis

-- 1. Product category revenue share, volume, and average price comparison
SELECT 
    Product_Category,
    COUNT(*) AS total_records,
    SUM(Units_Sold) AS category_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS category_revenue_inr,
    ROUND(SUM(Revenue_INR) * 100.0 / (SELECT SUM(Revenue_INR) FROM atmosync_data), 2) AS revenue_share_pct,
    ROUND(AVG(Avg_Price_INR), 2) AS avg_selling_price_inr,
    ROUND(AVG(Competitor_Price_INR), 2) AS avg_competitor_price_inr,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY Product_Category
ORDER BY category_revenue_inr DESC;

-- 2. Category demand and units sold by weather condition
SELECT 
    Product_Category,
    Weather_Condition,
    COUNT(*) AS record_count,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Units_Sold), 2) AS avg_units_per_observation
FROM atmosync_data
GROUP BY Product_Category, Weather_Condition
ORDER BY Product_Category, total_revenue_inr DESC;

-- 3. Stockout revenue loss breakdown by product category
SELECT 
    Product_Category,
    COUNT(*) AS total_records,
    SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) AS stockout_count,
    ROUND(SUM(CASE WHEN Stockout = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stockout_rate_pct,
    SUM(Potential_Lost_Units) AS total_lost_units,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS category_lost_revenue_inr,
    ROUND(SUM(Potential_Lost_Revenue_INR) * 100.0 / (SELECT SUM(Potential_Lost_Revenue_INR) FROM atmosync_data), 2) AS share_of_lost_revenue_pct
FROM atmosync_data
GROUP BY Product_Category
ORDER BY category_lost_revenue_inr DESC;
