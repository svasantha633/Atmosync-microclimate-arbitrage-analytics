-- Table setup with data types and basic constraints
DROP TABLE IF EXISTS atmosync_data;

CREATE TABLE atmosync_data (
    Date TEXT NOT NULL,
    City TEXT NOT NULL,
    Zone TEXT NOT NULL,
    Product_Category TEXT NOT NULL,
    Temperature_C REAL NOT NULL,
    Humidity_Pct REAL NOT NULL,
    Rainfall_mm REAL NOT NULL,
    Wind_Speed_kmph REAL NOT NULL,
    AQI INTEGER NOT NULL,
    Weather_Condition TEXT NOT NULL,
    Units_Sold INTEGER NOT NULL,
    Avg_Price_INR REAL NOT NULL,
    Competitor_Price_INR REAL NOT NULL,
    Revenue_INR REAL NOT NULL,
    Inventory_Units INTEGER NOT NULL,
    Stockout TEXT NOT NULL CHECK (Stockout IN ('Yes', 'No')),
    Potential_Lost_Units INTEGER NOT NULL,
    Potential_Lost_Revenue_INR REAL NOT NULL,
    Demand_Index REAL NOT NULL,
    Micro_Climate_Score REAL NOT NULL,
    Opportunity_Flag TEXT NOT NULL CHECK (Opportunity_Flag IN ('Normal', 'Moderate Opportunity', 'High Opportunity'))
);

-- Indexes to speed up common queries
CREATE INDEX idx_date ON atmosync_data(Date);
CREATE INDEX idx_location ON atmosync_data(City, Zone);
CREATE INDEX idx_category ON atmosync_data(Product_Category);
