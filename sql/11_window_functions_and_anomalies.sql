-- Window functions, running totals, and anomaly detection queries

-- 1. Window Function: Rank micro-zones within each city by total revenue using DENSE_RANK()
WITH ZoneRevenue AS (
    SELECT 
        City,
        Zone,
        SUM(Units_Sold) AS total_units_sold,
        ROUND(SUM(Revenue_INR), 2) AS total_revenue_inr,
        ROUND(SUM(Potential_Lost_Revenue_INR), 2) AS total_lost_revenue_inr
    FROM atmosync_data
    GROUP BY City, Zone
)
SELECT 
    City,
    Zone,
    total_revenue_inr,
    total_units_sold,
    total_lost_revenue_inr,
    DENSE_RANK() OVER (PARTITION BY City ORDER BY total_revenue_inr DESC) AS revenue_rank_in_city,
    DENSE_RANK() OVER (PARTITION BY City ORDER BY total_lost_revenue_inr DESC) AS stockout_loss_rank_in_city
FROM ZoneRevenue
ORDER BY City, revenue_rank_in_city;

-- 2. Window Function: Monthly cumulative running total of revenue by product category
WITH MonthlyCategoryRev AS (
    SELECT 
        Product_Category,
        strftime('%Y-%m', Date) AS month_year,
        ROUND(SUM(Revenue_INR), 2) AS monthly_revenue_inr
    FROM atmosync_data
    GROUP BY Product_Category, strftime('%Y-%m', Date)
)
SELECT 
    Product_Category,
    month_year,
    monthly_revenue_inr,
    ROUND(SUM(monthly_revenue_inr) OVER (
        PARTITION BY Product_Category 
        ORDER BY month_year 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS cumulative_running_revenue_inr
FROM MonthlyCategoryRev
ORDER BY Product_Category, month_year;

-- 3. Anomaly Detection: Days with extreme temperature (> 40°C) and heavy rainfall (> 20mm)
SELECT 
    Date,
    City,
    Zone,
    Product_Category,
    Temperature_C,
    Rainfall_mm,
    Weather_Condition,
    Units_Sold,
    Demand_Index,
    Micro_Climate_Score
FROM atmosync_data
WHERE Temperature_C >= 40.0 OR Rainfall_mm >= 20.0
ORDER BY Temperature_C DESC, Rainfall_mm DESC
LIMIT 20;
