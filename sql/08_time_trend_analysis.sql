-- Time-based trends and seasonal analysis

-- 1. Monthly revenue and sales volume trend
SELECT 
    strftime('%Y-%m', Date) AS month_year,
    COUNT(DISTINCT Date) AS observation_days,
    SUM(Units_Sold) AS monthly_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS monthly_revenue_inr,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS monthly_lost_revenue_inr,
    ROUND(AVG(Temperature_C), 2) AS avg_temp,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_climate_score
FROM atmosync_data
GROUP BY strftime('%Y-%m', Date)
ORDER BY month_year;

-- 2. Day of week sales performance and demand pattern
SELECT 
    CASE strftime('%w', Date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS total_observations,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Units_Sold), 2) AS avg_units_per_day,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index
FROM atmosync_data
GROUP BY strftime('%w', Date)
ORDER BY total_revenue_inr DESC;

-- 3. Monthly revenue breakdown by weather condition
SELECT 
    strftime('%Y-%m', Date) AS month_year,
    Weather_Condition,
    COUNT(*) AS condition_days,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr
FROM atmosync_data
GROUP BY strftime('%Y-%m', Date), Weather_Condition
ORDER BY month_year, total_revenue_inr DESC;
