"""
AtmoSync Data Cleaning & Standardization Script
===============================================
This script performs end-to-end data cleaning, deduplication, formula validation,
out-of-bounds clipping, and formatting for the AtmoSync Micro-Climate Arbitrage Analytics dataset.
"""

import os
import pandas as pd
import numpy as np

def clean_atmosync_data(input_path: str, output_excel_path: str, output_csv_path: str):
    print(f"Loading input file: {input_path}")
    if not os.path.exists(input_path):
        raise FileNotFoundError(f"Input file not found: {input_path}")
        
    xl = pd.ExcelFile(input_path)
    raw_df = pd.read_excel(xl, sheet_name='AtmoSync_Data')
    data_dict = pd.read_excel(xl, sheet_name='Data_Dictionary')
    
    print(f"Raw dataset shape: {raw_df.shape}")
    
    df = raw_df.copy()
    
    # 1. Clean String Columns (strip whitespace)
    str_cols = ['City', 'Zone', 'Product_Category', 'Weather_Condition', 'Stockout', 'Opportunity_Flag']
    for col in str_cols:
        df[col] = df[col].astype(str).str.strip()
        
    # 2. Key Deduplication on (Date, City, Zone, Product_Category)
    key_cols = ['Date', 'City', 'Zone', 'Product_Category']
    initial_rows = len(df)
    df = df.drop_duplicates(subset=key_cols, keep='first')
    deduped_rows = len(df)
    print(f"Deduplication removed {initial_rows - deduped_rows} redundant/duplicate key records. New shape: {df.shape}")
    
    # 3. Handle Out-of-Bounds Micro_Climate_Score (Clip negative scores to 0.0, max 100.0)
    neg_score_count = (df['Micro_Climate_Score'] < 0).sum()
    if neg_score_count > 0:
        print(f"Clipping {neg_score_count} negative Micro_Climate_Score values to 0.0")
        df['Micro_Climate_Score'] = df['Micro_Climate_Score'].clip(lower=0.0, upper=100.0)
        
    # 4. Enforce Data Types
    int_cols = ['AQI', 'Units_Sold', 'Inventory_Units', 'Potential_Lost_Units']
    for col in int_cols:
        df[col] = df[col].round().astype(int)
        
    df['Date'] = pd.to_datetime(df['Date']).dt.date
    
    # 5. Formula Recalculation & Business Rule Validation
    # 5.1 Revenue recalculation
    df['Revenue_INR'] = (df['Units_Sold'] * df['Avg_Price_INR']).round(2)
    
    # 5.2 Potential Lost Revenue recalculation
    df['Potential_Lost_Revenue_INR'] = (df['Potential_Lost_Units'] * df['Avg_Price_INR']).round(2)
    
    # 5.3 Stockout Status Validation
    df['Stockout'] = np.where(df['Potential_Lost_Units'] > 0, 'Yes', 'No')
    
    # 5.4 Demand Index recalculation (Units_Sold / Category Mean Units Sold)
    cat_means = df.groupby('Product_Category')['Units_Sold'].transform('mean')
    df['Demand_Index'] = (df['Units_Sold'] / cat_means).round(2)
    
    # 5.5 Opportunity Flag Re-evaluation
    # High Opportunity: Demand_Index >= 1.25 AND Micro_Climate_Score >= 59.0 AND Stockout == 'No'
    # Moderate Opportunity: Demand_Index >= 1.05 AND NOT High Opportunity
    # Normal: Demand_Index < 1.05
    is_high = (df['Demand_Index'] >= 1.25) & (df['Micro_Climate_Score'] >= 59.0) & (df['Stockout'] == 'No')
    is_mod = (df['Demand_Index'] >= 1.05) & (~is_high)
    
    df['Opportunity_Flag'] = np.select(
        [is_high, is_mod],
        ['High Opportunity', 'Moderate Opportunity'],
        default='Normal'
    )
    
    # 6. Precision Rounding for Floating Point Columns
    float_cols = ['Temperature_C', 'Humidity_%', 'Rainfall_mm', 'Wind_Speed_kmph', 
                  'Avg_Price_INR', 'Competitor_Price_INR', 'Revenue_INR', 
                  'Potential_Lost_Revenue_INR', 'Demand_Index', 'Micro_Climate_Score']
    for col in float_cols:
        df[col] = df[col].round(2)
        
    # 7. Sort Chronologically & Geographically
    df = df.sort_values(by=['Date', 'City', 'Zone', 'Product_Category']).reset_index(drop=True)
    
    # 8. Save Cleaned Excel and CSV Files
    print(f"Saving cleaned Excel file to: {output_excel_path}")
    with pd.ExcelWriter(output_excel_path, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='AtmoSync_Data', index=False)
        data_dict.to_excel(writer, sheet_name='Data_Dictionary', index=False)
        
    print(f"Saving cleaned CSV file to: {output_csv_path}")
    df.to_csv(output_csv_path, index=False)
    
    print("\nData cleaning completed successfully!")
    print(f"Cleaned dataset contains {len(df)} records across {len(df.columns)} columns.")

if __name__ == "__main__":
    input_file = r"c:\Users\RIMSHA\OneDrive\Desktop\INFO.PRO\AtmoSync_Micro_Climate_Arbitrage_Analytics_10000.xlsx"
    output_excel = r"c:\Users\RIMSHA\OneDrive\Desktop\INFO.PRO\AtmoSync_Micro_Climate_Arbitrage_Analytics_Cleaned.xlsx"
    output_csv = r"c:\Users\RIMSHA\OneDrive\Desktop\INFO.PRO\AtmoSync_Micro_Climate_Arbitrage_Analytics_Cleaned.csv"
    
    clean_atmosync_data(input_file, output_excel, output_csv)
