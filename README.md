# Multi-Store Retail Performance Analysis

## Project Overview

This project analyzes Walmart retail sales across three Texas stores and two product departments from May 2014 to May 2016. The goal was to compare store and department performance, identify major revenue drivers, and present the findings through an interactive Power BI dashboard.

The analysis focused on total revenue, units sold, average selling price, monthly revenue trends, and performance differences across stores and departments.

## Business Problem

Retail decision-makers need a clear way to compare sales performance across stores and product departments. Without a consolidated report, it can be difficult to identify which stores generate the most revenue, which departments drive overall performance, and how sales change over time.

## Tools Used

- MySQL Workbench
- Microsoft Excel
- Power Query
- Power BI Desktop

## Dashboard Preview

### Executive Overview

![Executive Overview](<07 Dashboard Images/01 Executive Overview.png>)

### Store and Department Performance

![Store and Department Performance](<07 Dashboard Images/02 Store and Department Performance.png>)

## Key Findings

- Total revenue reached approximately **$7.44 million**.
- Approximately **2.14 million units** were sold.
- The overall average selling price was **$3.48 per unit**.
- **TX_3** generated the highest revenue at approximately **$2.63 million**.
- The **Household** department generated approximately **$5.89 million** in revenue.
- The **Foods** department generated approximately **$1.55 million** in revenue.
- Household revenue was approximately **3.8 times higher** than Foods revenue.
- Household had a higher average selling price across all three stores.
- May 2014 and May 2016 contain partial-month data.

## Business Recommendations

- Maintain strong inventory availability for the Household department because it generates the majority of total revenue.
- Review the sales practices and product mix at TX_3 to identify strategies that could improve performance at TX_1 and TX_2.
- Investigate opportunities to increase Foods revenue through pricing, promotions, or product assortment changes.
- Continue monitoring average selling price by store and department.
- Consider the partial reporting periods when evaluating monthly revenue trends.

## Project Structure

- **01 Raw Data:** Original source data
- **02 SQL:** SQL scripts used for querying and analysis
- **03 Clean Data:** Prepared data used for reporting
- **04 Excel Validation:** Excel files used to validate totals
- **05 Power BI:** Final Power BI report
- **06 Documentation:** Complete project documentation in Word and PDF formats
- **07 Dashboard Images:** Dashboard screenshots

## Dashboard Pages

### Executive Overview

Provides a high-level summary of total revenue, units sold, average selling price, monthly revenue trends, and revenue comparisons by store and department.

### Store and Department Performance

Provides a detailed comparison of revenue, units sold, and average selling price across the three Texas stores and two departments.