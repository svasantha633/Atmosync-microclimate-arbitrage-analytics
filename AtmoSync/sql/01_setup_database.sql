-- AtmoSync SQL Analysis
-- Business-focused analysis of cleaned micro-climate sales data

CREATE DATABASE IF NOT EXISTS atmosync;

USE atmosync;

DROP TABLE IF EXISTS atmosync_data;

CREATE TABLE atmosync_data (
    `Date` DATE,
    City VARCHAR(50),
    Zone VARCHAR(50),
    Product_Category VARCHAR(50),
    Temperature_C DECIMAL(6,2),
    `Humidity_%` DECIMAL(6,2),
    Rainfall_mm DECIMAL(8,2),
    Wind_Speed_kmph DECIMAL(8,2),
    AQI INT,
    Weather_Condition VARCHAR(30),
    Units_Sold INT,
    Avg_Price_INR DECIMAL(12,2),
    Competitor_Price_INR DECIMAL(12,2),
    Revenue_INR DECIMAL(15,2),
    Inventory_Units INT,
    Stockout_Flag VARCHAR(10),
    Potential_Lost_Units INT,
    Potential_Lost_Revenue_INR DECIMAL(15,2),
    Demand_Index DECIMAL(8,4),
    Micro_Climate_Score DECIMAL(8,2),
    Opportunity_Flag VARCHAR(20)
);