CREATE TABLE atmosync_data (
    date DATE,
    city VARCHAR(100),
    zone VARCHAR(100),
    product_category VARCHAR(100),
    temperature_c NUMERIC,
    humidity_pct NUMERIC,
    rainfall_mm NUMERIC,
    wind_speed_kmph NUMERIC,
    aqi INTEGER,
    weather_condition VARCHAR(100),
    units_sold INTEGER,
    avg_price_inr NUMERIC,
    competitor_price_inr NUMERIC,
    revenue_inr NUMERIC,
    inventory_units INTEGER,
    stockout VARCHAR(10),
    potential_lost_units INTEGER,
    potential_lost_revenue_inr NUMERIC,
    demand_index NUMERIC,
    micro_climate_score NUMERIC,
    opportunity_flag VARCHAR(50)
);
select * from atmosync_data limit 5;



-- AtmoSync Micro-Climate Arbitrage Analytics
-- SQL Analysis



-- 1. Check total number of records
SELECT COUNT(*) AS total_records
FROM atmosync_data;


-- 2. Revenue by product category
SELECT
    product_category,
    SUM(revenue_inr) AS total_revenue
FROM atmosync_data
GROUP BY product_category
ORDER BY total_revenue DESC;


-- 3. Revenue by city
SELECT
    city,
    SUM(revenue_inr) AS total_revenue
FROM atmosync_data
GROUP BY city
ORDER BY total_revenue DESC;


-- 4. Average temperature and demand by city
SELECT
    city,
    ROUND(AVG(temperature_c), 2) AS avg_temperature,
    ROUND(AVG(demand_index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY city
ORDER BY avg_demand_index DESC;


-- 5. Impact of temperature on units sold
SELECT
    CASE
        WHEN temperature_c < 20 THEN 'Cold'
        WHEN temperature_c BETWEEN 20 AND 30 THEN 'Moderate'
        ELSE 'Hot'
    END AS temperature_group,
    ROUND(AVG(units_sold), 2) AS avg_units_sold
FROM atmosync_data
GROUP BY temperature_group
ORDER BY avg_units_sold DESC;


-- 6. Stockout analysis by city
SELECT
    city,
    SUM(stockout) AS total_stockouts,
    SUM(potential_lost_units) AS potential_lost_units,
    SUM(potential_lost_revenue_inr) AS potential_lost_revenue
FROM atmosync_data
GROUP BY city
ORDER BY potential_lost_revenue DESC;


-- 7. Opportunity flag analysis
SELECT
    opportunity_flag,
    COUNT(*) AS total_records,
    ROUND(AVG(micro_climate_score), 2) AS avg_micro_climate_score,
    ROUND(AVG(demand_index), 2) AS avg_demand_index,
    SUM(revenue_inr) AS total_revenue
FROM atmosync_data
GROUP BY opportunity_flag
ORDER BY total_revenue DESC;


-- 8. Product categories with high potential revenue loss
SELECT
    product_category,
    SUM(potential_lost_units) AS lost_units,
    SUM(potential_lost_revenue_inr) AS potential_lost_revenue
FROM atmosync_data
GROUP BY product_category
ORDER BY potential_lost_revenue DESC;


-- 9. Micro-climate score and revenue relationship
SELECT
    CASE
        WHEN micro_climate_score < 40 THEN 'Low'
        WHEN micro_climate_score BETWEEN 40 AND 70 THEN 'Medium'
        ELSE 'High'
    END AS climate_score_group,
    ROUND(AVG(demand_index), 2) AS avg_demand_index,
    SUM(revenue_inr) AS total_revenue
FROM atmosync_data
GROUP BY climate_score_group
ORDER BY total_revenue DESC;