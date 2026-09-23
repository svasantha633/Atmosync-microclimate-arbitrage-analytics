USE atmosync;

-- Demand by temperature range
SELECT
    CASE
        WHEN Temperature_C < 20 THEN 'Cold'
        WHEN Temperature_C BETWEEN 20 AND 30 THEN 'Moderate'
        ELSE 'Hot'
    END AS temperature_group,
    ROUND(AVG(Demand_Index), 2) AS average_demand,
    ROUND(AVG(Units_Sold), 2) AS average_units_sold,
    SUM(Revenue_INR) AS total_revenue
FROM atmosync_data
GROUP BY temperature_group
ORDER BY average_demand DESC;


-- Demand by weather condition
SELECT
    Weather_Condition,
    ROUND(AVG(Demand_Index), 2) AS average_demand,
    ROUND(AVG(Units_Sold), 2) AS average_units_sold,
    SUM(Revenue_INR) AS total_revenue
FROM atmosync_data
GROUP BY Weather_Condition
ORDER BY average_demand DESC;


-- Average micro-climate score by weather condition
SELECT
    Weather_Condition,
    ROUND(AVG(Micro_Climate_Score), 2) AS average_climate_score
FROM atmosync_data
GROUP BY Weather_Condition
ORDER BY average_climate_score DESC;


-- Average temperature and demand by city
SELECT
    City,
    ROUND(AVG(Temperature_C), 2) AS average_temperature,
    ROUND(AVG(Demand_Index), 2) AS average_demand
FROM atmosync_data
GROUP BY City
ORDER BY average_demand DESC;


-- Average rainfall by city
SELECT
    City,
    ROUND(AVG(Rainfall_mm), 2) AS average_rainfall
FROM atmosync_data
GROUP BY City
ORDER BY average_rainfall DESC;


-- Average AQI by city
SELECT
    City,
    ROUND(AVG(AQI), 2) AS average_aqi
FROM atmosync_data
GROUP BY City
ORDER BY average_aqi DESC;


-- Average humidity by city
SELECT
    City,
    ROUND(AVG(`Humidity_%`), 2) AS average_humidity
FROM atmosync_data
GROUP BY City
ORDER BY average_humidity DESC;


-- Climate score by city and zone
SELECT
    City,
    Zone,
    ROUND(AVG(Micro_Climate_Score), 2) AS average_climate_score,
    ROUND(AVG(Temperature_C), 2) AS average_temperature,
    ROUND(AVG(`Humidity_%`), 2) AS average_humidity
FROM atmosync_data
GROUP BY City, Zone
ORDER BY average_climate_score DESC;


-- High climate risk locations
SELECT
    City,
    Zone,
    ROUND(AVG(Micro_Climate_Score), 2) AS average_climate_score
FROM atmosync_data
GROUP BY City, Zone
HAVING AVG(Micro_Climate_Score) >= 70
ORDER BY average_climate_score DESC;


-- Climate conditions and potential lost revenue
SELECT
    Weather_Condition,
    SUM(Potential_Lost_Units) AS potential_lost_units,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY Weather_Condition
ORDER BY potential_lost_revenue DESC;