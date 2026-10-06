-- ====================================================================
-- Script: 03_trend_analysis.sql
-- Purpose: Time-series analysis, monthly revenue trends, MoM growth,
--          day-of-week patterns, temperature threshold analysis, 
--          and moving averages.
-- Dataset: AtmoSync Micro-Climate Arbitrage Analytics (Cleaned)
-- ====================================================================

-- Query 1: Monthly Revenue Trend and Month-over-Month (MoM) Revenue Growth Rate
WITH MonthlySummary AS (
    SELECT 
        strftime('%Y-%m', Date) AS month_year,
        COUNT(DISTINCT Date) AS active_days,
        SUM(Units_Sold) AS monthly_units_sold,
        ROUND(SUM(Revenue_INR), 2) AS monthly_revenue_inr,
        ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS monthly_lost_revenue_inr,
        ROUND(AVG(Temperature_C), 2) AS avg_monthly_temp,
        ROUND(AVG(Micro_Climate_Score), 2) AS avg_monthly_micro_climate
    FROM atmosync_data
    GROUP BY strftime('%Y-%m', Date)
)
SELECT 
    month_year,
    active_days,
    monthly_units_sold,
    monthly_revenue_inr,
    monthly_lost_revenue_inr,
    avg_monthly_temp,
    avg_monthly_micro_climate,
    LAG(monthly_revenue_inr) OVER (ORDER BY month_year) AS prev_month_revenue_inr,
    ROUND(
        (monthly_revenue_inr - LAG(monthly_revenue_inr) OVER (ORDER BY month_year)) * 100.0 / 
        NULLIF(LAG(monthly_revenue_inr) OVER (ORDER BY month_year), 0), 
        2
    ) AS mom_revenue_growth_pct
FROM MonthlySummary
ORDER BY month_year;

-- Query 2: Day-of-Week Sales Performance & Demand Index Breakdown
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
    COUNT(*) AS record_count,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Units_Sold), 2) AS avg_units_per_day,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index,
    ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr
FROM atmosync_data
GROUP BY strftime('%w', Date)
ORDER BY total_revenue_inr DESC;

-- Query 3: Demand Sensitivity Across Temperature Buckets
SELECT 
    CASE 
        WHEN Temperature_C < 15.0 THEN '1. Mild Cold (< 15°C)'
        WHEN Temperature_C BETWEEN 15.0 AND 24.99 THEN '2. Moderate (15-25°C)'
        WHEN Temperature_C BETWEEN 25.0 AND 34.99 THEN '3. Warm (25-35°C)'
        WHEN Temperature_C BETWEEN 35.0 AND 39.99 THEN '4. Hot (35-40°C)'
        ELSE '5. Extreme Heat (>= 40°C)'
    END AS temp_bucket,
    COUNT(*) AS record_count,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Units_Sold), 2) AS avg_units_sold,
    ROUND(AVG(Demand_Index), 2) AS avg_demand_index,
    ROUND(AVG(Micro_Climate_Score), 2) AS avg_micro_climate_score
FROM atmosync_data
GROUP BY temp_bucket
ORDER BY temp_bucket;

-- Query 4: 7-Day Moving Average of Daily Total Revenue and Units Sold
WITH DailyTotals AS (
    SELECT 
        Date,
        SUM(Units_Sold) AS daily_units_sold,
        SUM(Revenue_INR) AS daily_revenue_inr,
        AVG(Temperature_C) AS daily_avg_temp
    FROM atmosync_data
    GROUP BY Date
)
SELECT 
    Date,
    daily_units_sold,
    ROUND(daily_revenue_inr, 2) AS daily_revenue_inr,
    ROUND(AVG(daily_revenue_inr) OVER (
        ORDER BY Date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_7day_avg_revenue_inr,
    ROUND(AVG(daily_units_sold) OVER (
        ORDER BY Date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_7day_avg_units
FROM DailyTotals
ORDER BY Date
LIMIT 25;

-- Query 5: Monthly Revenue Breakdown by Weather Condition
SELECT 
    strftime('%Y-%m', Date) AS month_year,
    Weather_Condition,
    COUNT(*) AS condition_occurrences,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
    ROUND(AVG(Revenue_INR), 2) AS avg_revenue_per_day
FROM atmosync_data
GROUP BY strftime('%Y-%m', Date), Weather_Condition
ORDER BY month_year, total_revenue_inr DESC;
