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

