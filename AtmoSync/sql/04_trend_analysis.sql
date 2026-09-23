USE atmosync;

-- Monthly revenue
SELECT
    YEAR(`Date`) AS year,
    MONTH(`Date`) AS month,
    SUM(Revenue_INR) AS total_revenue
FROM atmosync_data
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY year, month;


-- Monthly units sold
SELECT
    YEAR(`Date`) AS year,
    MONTH(`Date`) AS month,
    SUM(Units_Sold) AS total_units_sold
FROM atmosync_data
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY year, month;


-- Monthly average demand
SELECT
    YEAR(`Date`) AS year,
    MONTH(`Date`) AS month,
    ROUND(AVG(Demand_Index), 2) AS average_demand
FROM atmosync_data
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY year, month;


-- Monthly potential lost revenue
SELECT
    YEAR(`Date`) AS year,
    MONTH(`Date`) AS month,
    SUM(Potential_Lost_Revenue_INR) AS potential_lost_revenue
FROM atmosync_data
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY year, month;


-- Revenue by year
SELECT
    YEAR(`Date`) AS year,
    SUM(Revenue_INR) AS total_revenue
FROM atmosync_data
GROUP BY YEAR(`Date`)
ORDER BY year;


-- Units sold by year
SELECT
    YEAR(`Date`) AS year,
    SUM(Units_Sold) AS total_units_sold
FROM atmosync_data
GROUP BY YEAR(`Date`)
ORDER BY year;