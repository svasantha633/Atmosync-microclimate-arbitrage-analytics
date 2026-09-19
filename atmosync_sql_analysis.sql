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

-- ============================================
-- NEW ATmosync SQL Analysis Queries
-- ============================================


-- 10. Find the top 10 cities by total units sold

SELECT
    city,
    SUM(units_sold) AS total_units_sold
FROM atmosync_data
GROUP BY city
ORDER BY total_units_sold DESC
LIMIT 10;


-- 11. Compare selling price with competitor price

SELECT
    product_category,
    ROUND(AVG(avg_price_inr), 2) AS avg_selling_price,
    ROUND(AVG(competitor_price_inr), 2) AS avg_competitor_price
FROM atmosync_data
GROUP BY product_category
ORDER BY avg_selling_price DESC;


-- 12. Find products/categories where our average price
-- is higher than the competitor price

SELECT
    product_category,
    ROUND(AVG(avg_price_inr), 2) AS avg_selling_price,
    ROUND(AVG(competitor_price_inr), 2) AS avg_competitor_price
FROM atmosync_data
GROUP BY product_category
HAVING AVG(avg_price_inr) > AVG(competitor_price_inr)
ORDER BY avg_selling_price DESC;


-- 13. Find cities with the highest potential lost revenue

SELECT
    city,
    SUM(potential_lost_revenue_inr) AS potential_lost_revenue
FROM atmosync_data
GROUP BY city
ORDER BY potential_lost_revenue DESC
LIMIT 10;


-- 14. Analyze demand based on weather condition

SELECT
    weather_condition,
    ROUND(AVG(demand_index), 2) AS avg_demand_index,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    SUM(revenue_inr) AS total_revenue
FROM atmosync_data
GROUP BY weather_condition
ORDER BY avg_demand_index DESC;


-- 15. Find high-demand records with low inventory

SELECT
    city,
    product_category,
    demand_index,
    inventory_units,
    units_sold,
    revenue_inr
FROM atmosync_data
WHERE demand_index >= 80
  AND inventory_units <= 100
ORDER BY demand_index DESC;


-- 16. Find locations with high micro-climate risk

SELECT
    city,
    zone,
    ROUND(AVG(micro_climate_score), 2) AS avg_micro_climate_score,
    ROUND(AVG(temperature_c), 2) AS avg_temperature,
    ROUND(AVG(humidity_pct), 2) AS avg_humidity
FROM atmosync_data
GROUP BY city, zone
HAVING AVG(micro_climate_score) >= 70
ORDER BY avg_micro_climate_score DESC;


-- 17. Identify potential arbitrage opportunities

SELECT
    city,
    product_category,
    ROUND(AVG(avg_price_inr), 2) AS avg_price,
    ROUND(AVG(competitor_price_inr), 2) AS competitor_price,
    ROUND(AVG(avg_price_inr - competitor_price_inr), 2) AS price_difference,
    ROUND(AVG(demand_index), 2) AS avg_demand
FROM atmosync_data
GROUP BY city, product_category
HAVING AVG(demand_index) >= 70
   AND AVG(avg_price_inr) < AVG(competitor_price_inr)
ORDER BY price_difference ASC;

-- 18. Monthly revenue trend

SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(revenue_inr) AS total_revenue
FROM atmosync_data
GROUP BY month
ORDER BY month;


-- 19. Monthly units sold trend

SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(units_sold) AS total_units_sold
FROM atmosync_data
GROUP BY month
ORDER BY month;


-- 20. Find cities with high demand and high revenue

SELECT
    city,
    ROUND(AVG(demand_index), 2) AS avg_demand_index,
    SUM(revenue_inr) AS total_revenue
FROM atmosync_data
GROUP BY city
HAVING AVG(demand_index) >= 70
ORDER BY total_revenue DESC;


-- 21. Analyze stockout rate by product category

SELECT
    product_category,
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN LOWER(stockout) IN ('yes', 'true', '1')
            THEN 1
            ELSE 0
        END
    ) AS stockout_records,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN LOWER(stockout) IN ('yes', 'true', '1')
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS stockout_rate_pct
FROM atmosync_data
GROUP BY product_category
ORDER BY stockout_rate_pct DESC;


-- 22. Find the highest revenue opportunities

SELECT
    city,
    product_category,
    opportunity_flag,
    SUM(revenue_inr) AS total_revenue,
    SUM(potential_lost_revenue_inr) AS potential_lost_revenue,
    ROUND(AVG(demand_index), 2) AS avg_demand_index,
    ROUND(AVG(micro_climate_score), 2) AS avg_micro_climate_score
FROM atmosync_data
GROUP BY city, product_category, opportunity_flag
ORDER BY potential_lost_revenue DESC
LIMIT 20;

-- 23. Average revenue by weather condition

SELECT
    weather_condition,
    ROUND(AVG(revenue_inr), 2) AS avg_revenue
FROM atmosync_data
GROUP BY weather_condition
ORDER BY avg_revenue DESC;


-- 24. Find cities with high demand but low inventory

SELECT
    city,
    ROUND(AVG(demand_index), 2) AS avg_demand_index,
    ROUND(AVG(inventory_units), 2) AS avg_inventory
FROM atmosync_data
GROUP BY city
HAVING AVG(demand_index) >= 70
   AND AVG(inventory_units) <= 150
ORDER BY avg_demand_index DESC;


-- 25. Analyze revenue by opportunity flag

SELECT
    opportunity_flag,
    COUNT(*) AS total_records,
    ROUND(AVG(demand_index), 2) AS avg_demand_index,
    SUM(revenue_inr) AS total_revenue,
    SUM(potential_lost_revenue_inr) AS potential_lost_revenue
FROM atmosync_data
GROUP BY opportunity_flag
ORDER BY total_revenue DESC;

-- 26. Average micro-climate score by weather condition

SELECT
    weather_condition,
    ROUND(AVG(micro_climate_score), 2) AS avg_micro_climate_score
FROM atmosync_data
GROUP BY weather_condition
ORDER BY avg_micro_climate_score DESC;

-- 27. Average rainfall by city

SELECT
    city,
    ROUND(AVG(rainfall_mm), 2) AS avg_rainfall_mm
FROM atmosync_data
GROUP BY city
ORDER BY avg_rainfall_mm DESC;

-- 28. Average AQI by city

SELECT
    city,
    ROUND(AVG(aqi), 2) AS avg_aqi
FROM atmosync_data
GROUP BY city
ORDER BY avg_aqi DESC;

-- 29. Identify high-demand, high-revenue opportunities with climate risk

SELECT
    city,
    product_category,
    ROUND(AVG(demand_index), 2) AS avg_demand_index,
    ROUND(AVG(micro_climate_score), 2) AS avg_micro_climate_score,
    SUM(revenue_inr) AS total_revenue,
    SUM(potential_lost_revenue_inr) AS potential_lost_revenue
FROM atmosync_data
GROUP BY city, product_category
HAVING AVG(demand_index) >= 70
   AND AVG(micro_climate_score) >= 60
ORDER BY potential_lost_revenue DESC;