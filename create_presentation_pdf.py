import os
from fpdf import FPDF

class PresentationPDF(FPDF):
    def header(self):
        if self.page_no() > 1:
            self.set_font("Helvetica", "B", 9)
            self.set_text_color(100, 100, 100)
            self.cell(0, 10, "AtmoSync Analytics - Team Mid-Week Progress Review", border=0, align="L")
            self.cell(0, 10, f"Page {self.page_no()}", border=0, align="R")
            self.ln(12)
            self.set_draw_color(220, 220, 220)
            self.line(10, 22, 287, 22)
            self.ln(2)

    def footer(self):
        if self.page_no() > 1:
            self.set_y(-15)
            self.set_font("Helvetica", "I", 8)
            self.set_text_color(150, 150, 150)
            self.cell(0, 10, "Confidential - Team Project Mid-Review Presentation | Branch: Tahseen_Parvej", align="C")

def generate_pdf():
    pdf = PresentationPDF(orientation="L", unit="mm", format="A4")
    pdf.set_auto_page_break(auto=True, margin=15)

    # ---------------- PAGE 1: TITLE SLIDE ----------------
    pdf.add_page()
    pdf.set_fill_color(26, 54, 93) # Deep Blue
    pdf.rect(0, 0, 297, 210, 'F')

    pdf.set_y(50)
    pdf.set_font("Helvetica", "B", 28)
    pdf.set_text_color(255, 255, 255)
    pdf.cell(0, 15, "AtmoSync Micro-Climate Analytics", align="C", new_x="LMARGIN", new_y="NEXT")

    pdf.set_font("Helvetica", "B", 18)
    pdf.set_text_color(226, 232, 240)
    pdf.cell(0, 12, "Team Mid-Week Progress Review Presentation", align="C", new_x="LMARGIN", new_y="NEXT")

    pdf.set_y(100)
    pdf.set_font("Helvetica", "", 12)
    pdf.set_text_color(203, 213, 225)
    pdf.cell(0, 8, "Repository: svasantha633/Atmosync-microclimate-arbitrage-analytics", align="C", new_x="LMARGIN", new_y="NEXT")
    pdf.cell(0, 8, "Branch Analyzed: Tahseen_Parvej", align="C", new_x="LMARGIN", new_y="NEXT")
    pdf.cell(0, 8, "Date: September / October 2026", align="C", new_x="LMARGIN", new_y="NEXT")

    pdf.set_y(155)
    pdf.set_font("Helvetica", "I", 11)
    pdf.set_text_color(148, 163, 184)
    pdf.cell(0, 8, "Presented by: Tahseen Parvej (Data Analyst & SQL Engineer)", align="C", new_x="LMARGIN", new_y="NEXT")

    # ---------------- PAGE 2: TEAM STRUCTURE ----------------
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 18)
    pdf.set_text_color(26, 54, 93)
    pdf.cell(0, 10, "Slide 1: Team Structure & Work Distribution Overview", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(4)

    pdf.set_font("Helvetica", "", 10)
    pdf.set_text_color(50, 50, 50)
    pdf.multi_cell(0, 6, "Below is the exact work distribution across all 4 team members audited directly from our Git commit history across all branches:")
    pdf.ln(6)

    # Table Header
    pdf.set_fill_color(43, 108, 176)
    pdf.set_text_color(255, 255, 255)
    pdf.set_font("Helvetica", "B", 10)
    pdf.cell(45, 9, "Team Member", border=1, align="C", fill=True)
    pdf.cell(50, 9, "Primary Role", border=1, align="C", fill=True)
    pdf.cell(45, 9, "GitHub Branch", border=1, align="C", fill=True)
    pdf.cell(137, 9, "Main Work Deliverables", border=1, align="C", fill=True, new_x="LMARGIN", new_y="NEXT")

    # Table Rows
    pdf.set_font("Helvetica", "", 9)
    pdf.set_text_color(40, 40, 40)
    
    rows = [
        ("Vasantha S", "Team Lead & Power BI Lead", "Vasantha.-S", "12 Daily Power BI (.pbix) Commit Iterations & Dashboard Visuals"),
        ("Tahseen Parvej", "Data Analyst & SQL Engineer", "Tahseen_Parvej", "Data Cleaning Pipeline, SQLite DB, 11 SQL Files, Insights Report & README"),
        ("Lavanesh Sivakumar", "SQL & Exploratory Analyst", "Lavanesh-S", "Exploratory Python Scripts & Custom Weather SQL Analysis Queries"),
        ("Naved Khan", "Data Ingestion", "main", "Dataset Procurement & Raw File Upload (10,000 records)")
    ]

    for i, row in enumerate(rows):
        fill = (i % 2 == 1)
        pdf.set_fill_color(240, 244, 248) if fill else pdf.set_fill_color(255, 255, 255)
        pdf.cell(45, 10, row[0], border=1, fill=True)
        pdf.cell(50, 10, row[1], border=1, fill=True)
        pdf.cell(45, 10, row[2], border=1, fill=True)
        pdf.cell(137, 10, row[3], border=1, fill=True, new_x="LMARGIN", new_y="NEXT")

    # ---------------- PAGE 3: VASANTHA WORK ----------------
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 18)
    pdf.set_text_color(26, 54, 93)
    pdf.cell(0, 10, "Slide 2: Vasantha S - Team Leader & Power BI Lead", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(4)

    pdf.set_font("Helvetica", "B", 11)
    pdf.set_text_color(43, 108, 176)
    pdf.cell(0, 8, "Branch: Vasantha.-S | Tool: Microsoft Power BI Desktop (.pbix)", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(2)

    pdf.set_font("Helvetica", "", 10)
    pdf.set_text_color(50, 50, 50)
    pdf.multi_cell(0, 6, "Vasantha initialized the repository and built progressive Power BI dashboard iterations across 12 commits:")
    pdf.ln(4)

    # Table Header for Power BI Work
    pdf.set_fill_color(43, 108, 176)
    pdf.set_text_color(255, 255, 255)
    pdf.set_font("Helvetica", "B", 9)
    pdf.cell(30, 8, "Date", border=1, align="C", fill=True)
    pdf.cell(60, 8, "File Name (.pbix)", border=1, align="C", fill=True)
    pdf.cell(187, 8, "Visuals & Features Built", border=1, align="C", fill=True, new_x="LMARGIN", new_y="NEXT")

    pbi_rows = [
        ("Sep 14", "Atmosync _day 2.pbix", "Executive KPI Cards (Total Revenue, Units Sold)"),
        ("Sep 15", "Atmosync _day 3 commit.pbix", "Temperature Analysis Chart & Dashboard Title"),
        ("Sep 16", "Atmosync _day 4.pbix", "Humidity Analysis Visuals"),
        ("Sep 17", "Atmosync _day 5.pbix", "Rainfall Impact Analysis Chart"),
        ("Sep 18", "Atmosync _day 6.pbix", "AQI Analysis Chart & Icon Assets"),
        ("Sep 19", "Atmosync _day 7.pbix", "Weather Condition vs Revenue Comparison Chart"),
        ("Sep 20-21", "Atmosync _day 8 & 9.pbix", "Revenue by Product Category Donut/Bar Chart"),
        ("Sep 22", "Atmosync _day 10.pbix", "Revenue by Zone Analysis & Title Styling"),
        ("Sep 23", "Atmosync _day 11.pbix", "Units Sold by Product Category Breakdown"),
        ("Sep 24", "Atmosync _day 12.pbix", "Temperature vs Revenue Trend Chart"),
        ("Sep 25", "Atmosync _day 13.pbix (Latest)", "Units Sold by City Comparison Chart")
    ]

    pdf.set_font("Helvetica", "", 8.5)
    pdf.set_text_color(40, 40, 40)
    for i, r in enumerate(pbi_rows):
        fill = (i % 2 == 1)
        pdf.set_fill_color(245, 247, 250) if fill else pdf.set_fill_color(255, 255, 255)
        pdf.cell(30, 7, r[0], border=1, fill=True)
        pdf.cell(60, 7, r[1], border=1, fill=True)
        pdf.cell(187, 7, r[2], border=1, fill=True, new_x="LMARGIN", new_y="NEXT")

    # ---------------- PAGE 4: TAHSEEN WORK ----------------
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 18)
    pdf.set_text_color(26, 54, 93)
    pdf.cell(0, 10, "Slide 3: Tahseen Parvej - Data Analyst & SQL Engineer", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(4)

    pdf.set_font("Helvetica", "B", 11)
    pdf.set_text_color(43, 108, 176)
    pdf.cell(0, 8, "Branch: Tahseen_Parvej | Tools: Python 3.12, SQLite 3, Advanced SQL, Markdown", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(2)

    bullets = [
        ("Module 1: Data Cleaning Pipeline (clean_data.py)", "Processed 10,000 raw rows to 8,127 clean records. Removed 1,873 duplicate key entries across (Date, City, Zone, Category). Fixed negative climate scores and recalculated revenue formulas."),
        ("Module 2: Database Architecture (import_data.py)", "Designed SQLite database schema (atmosync.db) with index performance optimizations on Date, City, Zone, and Category fields."),
        ("Module 3: Advanced SQL Analytics Pipeline", "Created 11 modular SQL files (02_create_tables.sql to 12_insights_queries.sql) utilizing Window Functions (DENSE_RANK, SUM OVER), CTEs (WITH clauses), CASE WHEN segmentations, and anomaly checks."),
        ("Module 4: Insights Report & README Documentation", "Authored insights/insights_report.md (discovering Rs. 40.33 Cr revenue, Rs. 33.20 Lakhs stockout leakage, Rs. 34.19 Lakhs pricing headroom) and interactive README.md with Mermaid pipeline diagram.")
    ]

    pdf.set_font("Helvetica", "", 9.5)
    pdf.set_text_color(40, 40, 40)
    for title, desc in bullets:
        pdf.set_font("Helvetica", "B", 10)
        pdf.set_text_color(43, 108, 176)
        pdf.cell(0, 6, f"- {title}", new_x="LMARGIN", new_y="NEXT")
        pdf.set_font("Helvetica", "", 9)
        pdf.set_text_color(60, 60, 60)
        pdf.multi_cell(0, 5, desc)
        pdf.ln(2)

    # ---------------- PAGE 5: LAVANESH & NAVED WORK ----------------
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 18)
    pdf.set_text_color(26, 54, 93)
    pdf.cell(0, 10, "Slide 4: Lavanesh Sivakumar & Naved Khan Contributions", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(6)

    # Lavanesh Card
    pdf.set_fill_color(240, 244, 248)
    pdf.rect(10, 35, 277, 65, 'F')
    pdf.set_y(40)
    pdf.set_x(15)
    pdf.set_font("Helvetica", "B", 12)
    pdf.set_text_color(43, 108, 176)
    pdf.cell(0, 8, "Lavanesh Sivakumar - SQL & Exploratory Analyst (Branch: Lavanesh-S)", new_x="LMARGIN", new_y="NEXT")
    
    pdf.set_font("Helvetica", "", 9.5)
    pdf.set_text_color(50, 50, 50)
    pdf.set_x(15)
    pdf.multi_cell(267, 5.5, "- Built Python exploratory data analysis script (AtmoSync/analysis/exploratory_analysis.py).\n- Wrote custom SQL query file (atmosync_sql_analysis.sql) with daily additions covering city-level humidity, rainfall, AQI, and business metrics.\n- Added modular SQL scripts under AtmoSync/sql/ and contributed to AtmoSync/insights/insights_report.md and AtmoSync/README.md.")

    # Naved Card
    pdf.set_fill_color(245, 247, 250)
    pdf.rect(10, 110, 277, 45, 'F')
    pdf.set_y(115)
    pdf.set_x(15)
    pdf.set_font("Helvetica", "B", 12)
    pdf.set_text_color(43, 108, 176)
    pdf.cell(0, 8, "Naved Khan - Data Procurement (Branch: main)", new_x="LMARGIN", new_y="NEXT")
    
    pdf.set_font("Helvetica", "", 9.5)
    pdf.set_text_color(50, 50, 50)
    pdf.set_x(15)
    pdf.multi_cell(267, 5.5, "- Procured and uploaded initial raw dataset file AtmoSync_Micro_Climate_Arbitrage_Analytics_10000.xlsx (10,000 raw records) to the team repository on Sep 12, 2026.")

    # ---------------- PAGE 6: KEY FINDINGS ----------------
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 18)
    pdf.set_text_color(26, 54, 93)
    pdf.cell(0, 10, "Slide 5: Key Business Insights & Empirical Findings", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(4)

    # 4 Metric Cards
    kpis = [
        ("Total Revenue Generated", "Rs. 40,33,00,135.57", "Across 5,475,303 units sold"),
        ("Total Lost Revenue", "Rs. 33,20,620.38", "44,102 units lost to stockouts"),
        ("Pricing Headroom Upside", "Rs. 34,19,528.76", "Uncaptured pricing headroom"),
        ("Peak Heatwave Month", "May 2026 (Rs. 6.68 Cr)", "+17.97% MoM growth at 35.86 C")
    ]

    card_w = 64
    card_h = 30
    for idx, (title, val, desc) in enumerate(kpis):
        col = idx % 4
        x = 10 + col * (card_w + 5)
        y = 35
        pdf.set_fill_color(235, 248, 255)
        pdf.rect(x, y, card_w, card_h, 'DF')
        pdf.set_xy(x + 2, y + 3)
        pdf.set_font("Helvetica", "B", 8.5)
        pdf.set_text_color(43, 108, 176)
        pdf.cell(card_w - 4, 5, title, align="C", new_x="LMARGIN", new_y="NEXT")
        pdf.set_xy(x + 2, y + 10)
        pdf.set_font("Helvetica", "B", 11)
        pdf.set_text_color(26, 54, 93)
        pdf.cell(card_w - 4, 7, val, align="C", new_x="LMARGIN", new_y="NEXT")
        pdf.set_xy(x + 2, y + 19)
        pdf.set_font("Helvetica", "", 7.5)
        pdf.set_text_color(100, 100, 100)
        pdf.cell(card_w - 4, 5, desc, align="C", new_x="LMARGIN", new_y="NEXT")

    pdf.set_y(75)
    pdf.set_font("Helvetica", "B", 11)
    pdf.set_text_color(26, 54, 93)
    pdf.cell(0, 8, "Major Data Analyst Insights:", new_x="LMARGIN", new_y="NEXT")

    insights = [
        "1. Stockout Penalty Concentration: Ice Cream (25.6%) and Cold Drinks (24.6%) account for 50.2% of all lost revenue (Rs. 16.67 Lakhs lost combined).",
        "2. High Stockout Vulnerability Zones: Sector 150 (Noida), South Delhi, and Cyber City (Gurugram) represent top stockout risk zones.",
        "3. Weather Sensitivity Volatility: Rainy days cause a 50.2% drop in daily revenue per zone compared to Hot & Sunny days.",
        "4. Weekend Demand Surge: Sunday and Saturday sales average 734 and 724 units/day (12.6% higher than weekday averages)."
    ]

    pdf.set_font("Helvetica", "", 9.5)
    pdf.set_text_color(50, 50, 50)
    for ins in insights:
        pdf.multi_cell(0, 6, f"- {ins}")
        pdf.ln(1)

    # ---------------- PAGE 7: SPEAKING SCRIPT ----------------
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 18)
    pdf.set_text_color(26, 54, 93)
    pdf.cell(0, 10, "Slide 6: Mid-Review Speaking Script & Conclusion", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(4)

    pdf.set_fill_color(248, 250, 252)
    pdf.rect(10, 35, 277, 140, 'F')
    pdf.set_y(40)
    pdf.set_x(15)
    pdf.set_font("Helvetica", "B", 11)
    pdf.set_text_color(43, 108, 176)
    pdf.cell(0, 8, "Mid-Review Presentation Script (Tahseen Parvej):", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(2)

    script_text = (
        "\"Good morning/afternoon Everyone. Here is our team's Mid-Week Progress Review for the AtmoSync Micro-Climate Arbitrage Analytics project.\n\n"
        "Our team leader Vasantha has been leading the Power BI Dashboard development on branch Vasantha.-S, completing 12 iterations of .pbix files that cover KPI cards, weather trend visuals, category donuts, and city-level sales breakdowns.\n\n"
        "On my side, as the Data Analyst & SQL Engineer on branch Tahseen_Parvej, I built the data cleaning pipeline in Python, removing 1,873 duplicate rows and fixing score anomalies. I then engineered the SQLite database architecture and built an 11-module SQL analytical pipeline using CTEs and Window Functions, documenting our key findings (Rs. 40.33 Cr revenue and Rs. 33.20 Lakhs stockout leakage) in insights_report.md and an interactive README.md.\n\n"
        "Lavanesh worked on branch Lavanesh-S, performing exploratory Python analysis and authoring custom SQL scripts for weather and humidity metrics. Naved managed the initial raw dataset procurement and upload.\n\n"
        "All our individual contributions are updated on our respective GitHub branches and ready for integration into the main branch. Thank you!\""
    )

    pdf.set_font("Helvetica", "", 9.5)
    pdf.set_text_color(40, 40, 40)
    pdf.set_x(15)
    pdf.multi_cell(267, 5.5, script_text)

    output_path = r"c:\Users\RIMSHA\OneDrive\Desktop\INFO.PRO\Team_Mid_Week_Progress_Review.pdf"
    pdf.output(output_path)
    print(f"PDF generated successfully at {output_path}")

if __name__ == "__main__":
    generate_pdf()
