-- Query performance optimization, indexing strategies, and execution benchmarks

-- 1. Create covering indexes for high-frequency analytical joins and group-by filters
CREATE INDEX IF NOT EXISTS idx_temp_weather ON atmosync_data(Temperature_C, Weather_Condition);
CREATE INDEX IF NOT EXISTS idx_stockout_lost_rev ON atmosync_data(Stockout, Potential_Lost_Revenue_INR);
CREATE INDEX IF NOT EXISTS idx_price_arbitrage ON atmosync_data(Micro_Climate_Score, Avg_Price_INR, Competitor_Price_INR);

-- 2. Performance Query: High-speed summary of micro-climate score vs revenue
SELECT 
    CASE 
        WHEN Micro_Climate_Score >= 70.0 THEN 'High Micro-Climate (>= 70)'
        WHEN Micro_Climate_Score BETWEEN 50.0 AND 69.99 THEN 'Moderate Micro-Climate (50-70)'
        ELSE 'Low Micro-Climate (< 50)'
    END AS climate_tier,
    COUNT(*) AS total_records,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY climate_tier
ORDER BY total_revenue_inr DESC;
