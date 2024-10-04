# Project Title: Inventory and Sales Performance Analysis

## Summary
This project involves analyzing sales and inventory data across multiple stores to derive insights into product performance, store efficiency, and sales trends.

### Project Goals
1. **Production Performance Analysis**: Identify top-performing products based on total sales and profit.
2. **Store Performance Analysis**: Analyze sales performance for each store, including total revenue and profit margin.
3. **Complex Monthly Sales Trend Analysis**: Examine monthly sales trends, considering rolling averages and identifying months with significant growth or decline.
4. **Cumulative Distribution of Profit Margin**: Calculate the cumulative distribution of profit margins for each product category, focusing on profitable products.
5. **Store Inventory Turnover Analysis**: Analyze the efficiency of inventory turnover for each store by calculating the Inventory Turnover Ratio in percentage.

### Data Structure
- **Stores**: 
    - `Store_ID` (tinyint)
    - `Store_name` (nvarchar)
    - `Store_City` (nvarchar)
    - `Store_Location` (nvarchar)
    - `Store_open_date` (date)
  
- **Sales**: 
    - `Sale_ID` (int)
    - `REF_DATE` (date)
    - `Store_ID` (int)
    - `Product_ID` (int)
    - `units` (int)

- **Products**: 
    - `Product_ID` (tinyint)
    - `Product_Name` (nvarchar)
    - `Product_Category` (nvarchar)
    - `Product_Cost` (money)
    - `Product_Price` (money)

- **Inventory**: 
    - `Store_ID` (tinyint)
    - `Product_ID` (tinyint)
    - `Stock_On_Hand` (tinyint)

- **Calendar**: 
    - `REF_Date` (date)

### Analysis Methods
- **COGS Calculation**: Total cost of goods sold calculated from sales data.
- **Inventory Turnover Ratio**: Calculated as COGS divided by average inventory stock.
- **Efficiency Percentage**: Expressed as a percentage to show inventory turnover efficiency relative to maximum turnover observed.

### Installation
Instructions for installing and running the project (if applicable).

### Usage
Instructions for using the project (if applicable).

### License
Specify the license under which the project is distributed (if applicable).
