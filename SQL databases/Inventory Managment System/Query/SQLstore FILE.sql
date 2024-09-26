--creating a database
CREATE DATABASE analytics_project; 

--using the database
USE analytics_project; 

--objectives of case study

/* 1. Production Performance Analysis
Goal- Identify top-performing products based on total sales and profit.
 2.  Store Performance Analysis
Goal- Analyse sales performance for each store, including total revenue and profit margin.
 3. Complex Monthly Sales Trend Analysis:
 Goal- Examine monthly sales trends, considering the rolling 3-month average and identifying months with significant growth or decline.
 4. Cumulative Distribution of Profit Margin:
 Goal- Calculate the cumulative distribution of profit margin for each product category, consider where products are having profit.
  5. Store Inventory Turnover Analysis:
  Goal: Analyze the efficiency of inventory turnover for each store by calculating the Inventory Turnover Ratio. */

--Retreiving all the tables using SELECT command
SELECT * FROM dbo.data_dictionary;--this table is defining or describing the data which will not been considered to evaluate.


SELECT * FROM dbo.calendar;

SELECT * FROM dbo.inventory;

SELECT * FROM dbo.products;

SELECT * FROM dbo.sales;

SELECT * FROM dbo.stores;

--checking the data type of the each table 
SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'stores';

SELECT * FROM stores;
/*RELATIONSHIP DRAWING
1.Store_ID(tinyint),
Store_name(nvarchar),
Store_City(nvarchar),
Store_Location(nvarchar),
Store_open_date(date)             
summary:-stores  (no missing values in each column)

2.Sale_ID(int),
ConvertedDate(Date),
Store_ID(int),
Product_ID(int),
units(int)
summary:-sales   (no missing values in each column)

3.Product_ID(tinyint),
Product_Name(nvarchar),
Product_Category(nvarchar),
Product_Cost(money),
Product_Price(money)
summary:-products (no missing values in each column)

4.Store_ID(tinyint),
Product_ID(tinyint),
Stock_On_Hand(tinyint)
summary:-inventory (no missing values in each column)

5.Date(date)
summary:-calendar  (no missing values in each column) */

--inventory and products columns are ok

UPDATE sales

--updating sales table varchar to int,Date to DATETIME
ALTER TABLE sales
ALTER COLUMN Sale_ID INT;

ALTER TABLE sales
ALTER COLUMN Store_ID INT;

ALTER TABLE sales
ALTER COLUMN Product_ID INT;

ALTER TABLE sales
ALTER COLUMN Units INT;

--updating datatype for store table:-
ALTER TABLE stores
ALTER COLUMN  Store_ID INT;

--updating datatype for products table:-
ALTER TABLE products
ALTER COLUMN  Product_ID INT;

--updating datatype for inventory table:-
ALTER TABLE inventory
ALTER COLUMN  Store_ID INT;

ALTER TABLE inventory
ALTER COLUMN  Product_ID INT;

ALTER TABLE inventory
ALTER COLUMN  Stock_On_Hand INT;


--Adding a new column to the table
ALTER TABLE sales 
ADD ConvertedDate DATE;

--Updating the new column with the converted date values in the format 
--"DD-MM-YYYY" to "YYYY-MM-DD"(105)
UPDATE sales
SET REF_Date = CONVERT(DATE, TRY_CONVERT(DATE, REF_Date, 105), 23) 
WHERE REF_Date IS NULL;

--"MM-DD-YYYY" to "YYYY-MM-DD"(110)
UPDATE sales
SET REF_Date = CONVERT(DATE, TRY_CONVERT(DATE, REF_Date, 110), 23)
WHERE REF_Date IS NULL;

--dropping date column
ALTER TABLE sales
DROP column Date;

--Adding constraints to the columns
-- store table

SELECT * FROM stores;

ALTER TABLE stores 
ALTER COLUMN Store_Name NVARCHAR(100) NOT NULL;

ALTER TABLE stores
ALTER COLUMN Store_City NVARCHAR(100) NOT NULL;

ALTER TABLE stores 
ALTER COLUMN Store_Location VARCHAR(100) NOT NULL;

ALTER TABLE stores 
ALTER COLUMN Store_open_date DATE NOT NULL;

ALTER TABLE stores
ALTER COLUMN Store_ID INT NOT NULL;

ALTER TABLE stores 
ADD CONSTRAINT PK_Store_ID PRIMARY KEY (Store_ID);

ALTER TABLE stores 
ADD CONSTRAINT UQ_Store_name UNIQUE (Store_name);

/* providing constraints in single column
  ALTER TABLE stores 
  ALTER COLUMN Store_Name NVARCHAR(100) NOT NULL,
  ALTER COLUMN Store_City NVARCHAR(100) NOT NULL,
  ALTER COLUMN Store_Location VARCHAR(100) NOT NULL,
  ALTER COLUMN Store_open_date DATE NOT NULL,
  ALTER COLUMN Store_ID INT NOT NULL,
  ADD CONSTRAINT PK_Store_ID PRIMARY KEY (Store_ID),
  ADD CONSTRAINT UQ_Store_name UNIQUE (Store_name);
*/

-- sales table,add all the respective keys and constraints to improve data consistency and accuracy.

SELECT * FROM sales;

ALTER TABLE sales 
ALTER COLUMN ConvertedDate DATE NOT NULL;

ALTER TABLE sales 
ALTER COLUMN Store_ID INT NOT NULL;

ALTER TABLE sales 
ALTER COLUMN Product_ID INT NOT NULL;

ALTER TABLE sales 
ALTER COLUMN units INT NOT NULL;

ALTER TABLE sales 
ALTER COLUMN Sale_ID INT NOT NULL;

ALTER TABLE sales 
ADD CONSTRAINT PK_Sale_ID PRIMARY KEY (Sale_ID);

ALTER TABLE sales 
ADD CONSTRAINT FK_Sales_Store_ID FOREIGN KEY (Store_ID) REFERENCES stores(Store_ID);

ALTER TABLE sales 
ADD CONSTRAINT FK_Sales_Product_ID FOREIGN KEY (Product_ID) REFERENCES products(Product_ID);

/*ALTER TABLE sales
  ALTER COLUMN ConvertedDate DATE NOT NULL,
  ALTER COLUMN Store_ID INT NOT NULL,
  ALTER COLUMN Product_ID INT NOT NULL,
  ALTER COLUMN units INT NOT NULL,
  ALTER COLUMN Sale_ID INT NOT NULL,
  ADD CONSTRAINT PK_Sale_ID PRIMARY KEY (Sale_ID),
  ADD CONSTRAINT FK_Sales_Store_ID FOREIGN KEY (Store_ID) REFERENCES stores(Store_ID),
  ADD CONSTRAINT FK_Sales_Product_ID FOREIGN KEY (Product_ID) REFERENCES products(Product_ID);
*/

-- products table,add all the respective keys and constraints to improve data consistency and accuracy.

select * from products

ALTER TABLE products 
ALTER COLUMN Product_Name NVARCHAR(100) NOT NULL;

ALTER TABLE products 
ALTER COLUMN Product_Category NVARCHAR(100) NOT NULL;

ALTER TABLE products 
ALTER COLUMN Product_Cost money NOT NULL;

ALTER TABLE products 
ALTER COLUMN Product_Price money NOT NULL;

ALTER TABLE products 
ALTER COLUMN Product_ID INT NOT NULL;

ALTER TABLE products 
ADD CONSTRAINT PK_Product_ID PRIMARY KEY (Product_ID);

ALTER TABLE products 
ADD CONSTRAINT UQ_Product_Name UNIQUE (Product_Name);

/*ALTER TABLE products
  ALTER COLUMN Product_Name NVARCHAR(100) NOT NULL,
  ALTER COLUMN Product_Category NVARCHAR(100) NOT NULL,
  ALTER COLUMN Product_Cost money NOT NULL,
  ALTER COLUMN Product_Price money NOT NULL,
  ALTER COLUMN Product_ID INT NOT NULL,
  ADD CONSTRAINT PK_Product_ID PRIMARY KEY (Product_ID),
  ADD CONSTRAINT UQ_Product_Name UNIQUE (Product_Name);
*/

-- inventory table,add all the respective keys and constraints to improve data consistency and accuracy.

SELECT * FROM inventory;

ALTER TABLE inventory 
ALTER COLUMN Stock_On_Hand INT NOT NULL;

ALTER TABLE inventory 
ADD CONSTRAINT FK_Inventory_Sale_ID FOREIGN KEY (Store_ID) REFERENCES stores(Store_ID);

ALTER TABLE inventory 
ADD CONSTRAINT FK_Inventory_Product_ID FOREIGN KEY (Product_ID) REFERENCES products(Product_ID);

/*ALTER TABLE inventory
  ALTER COLUMN Stock_On_Hand INT NOT NULL,
  ADD CONSTRAINT FK_Inventory_Sale_ID FOREIGN KEY (Store_ID) REFERENCES stores(Store_ID),
  ADD CONSTRAINT FK_Inventory_Product_ID FOREIGN KEY (Product_ID) REFERENCES products(Product_ID);
*/

-- calendar table,add all the respective keys and constraints to improve data consistency and accuracy.

SELECT * FROM calendar;

ALTER TABLE calendar 
ADD CONSTRAINT PK_Date PRIMARY KEY (Date);

ALTER TABLE sales
ADD CONSTRAINT FK_Calendar FOREIGN KEY (REF_DATE) REFERENCES calendar(REF_DATE);

/*ALTER TABLE sales
  ADD CONSTRAINT PK_Date PRIMARY KEY (Date)
  ADD CONSTRAINT FK_Calendar FOREIGN KEY (REF_DATE) REFERENCES calendar(REF_DATE);
*/

--s-->stores,sa-->sales,p-->products,i-->inventory,c-->calender

--top sales by store(which store sold more products)

SELECT s.Store_name, SUM(sa.units) AS Total_Units_Sold
FROM sales sa
JOIN stores s ON sa.Store_ID = s.Store_ID
GROUP BY s.Store_name
ORDER BY Total_Units_Sold DESC;

--top selling products(what are all the top selling products)

SELECT p.Product_Name, SUM(sa.units) AS Total_Units_Sold
FROM sales sa
JOIN products p ON sa.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Units_Sold DESC;

--inventory status((which product stock is left more in the inventory)
SELECT p.Product_Name, i.Stock_On_Hand
FROM inventory i
JOIN products p ON i.Product_ID = p.Product_ID
ORDER BY i.Stock_On_Hand DESC;

--sales overtime(Sales happend from start to end,with total units sold)
SELECT c.REF_DATE, SUM(sa.units) AS Total_Units_Sold
FROM sales sa
JOIN calendar c ON sa.REF_DATE =c.REF_DATE
GROUP BY c.REF_DATE
ORDER BY c.REF_DATE;

--store sales performance
SELECT s.Store_name, SUM(sa.units * p.Product_Price) AS Total_Sales
FROM sales sa
JOIN stores s ON sa.Store_ID = s.Store_ID
JOIN products p ON sa.Product_ID = p.Product_ID
GROUP BY s.Store_name
ORDER BY Total_Sales DESC;

--Analysis-1

--PRODUCTION PERFORMANCE ANALYSIS
--Identify top-performing products based on total sales and profit.
SELECT p.Product_ID, p.Product_Name, SUM(s.units * p.Product_Price) AS Total_Sales,SUM(s.units * (p.Product_Price - p.Product_Cost)) AS Total_Profit
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Total_Profit DESC, Total_Sales DESC;

--Analysis -2

--STORE PERFORMANCE ANALYSIS
--Analyse sales performance for each store, including total revenue and profit margin.
SELECT st.Store_ID, st.Store_name, SUM(s.units * p.Product_Price) AS Total_Revenue,SUM(s.units * (p.Product_Price - p.Product_Cost)) AS Total_Profit,
(SUM(s.units * (p.Product_Price - p.Product_Cost)) / SUM(s.units * p.Product_Price)) * 100 AS Profit_Margin
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
JOIN stores st ON s.Store_ID = st.Store_ID
GROUP BY st.Store_ID, st.Store_name
ORDER BY Total_Revenue DESC;

--Analysis -3

--COMPLEX MONTHLY TREND ANALYSIS
--Examine monthly sales trends, considering the rolling 3-month average and identifying months with significant growth or decline.

-- Create an index on REF_DATE in the sales table
CREATE INDEX idx_sales_ref_date ON sales(REF_DATE);

-- Create an index on Product_ID in the sales table
CREATE INDEX idx_sales_product_id ON sales(Product_ID);

-- Create an index on Product_ID in the products table
CREATE INDEX idx_products_product_id ON products(Product_ID);

--Query
SELECT FORMAT(s.REF_DATE, 'yyyy-MM') AS Month,SUM(s.units * p.Product_Price) AS Total_Revenue,
AVG(SUM(s.units * p.Product_Price)) OVER (ORDER BY FORMAT(s.REF_DATE, 'yyyy-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Three_Month_Avg,
    CASE 
        WHEN SUM(s.units * p.Product_Price) > AVG(SUM(s.units * p.Product_Price)) OVER (ORDER BY FORMAT(s.REF_DATE, 'yyyy-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) * 1.1 THEN 'Significant Growth'
        WHEN SUM(s.units * p.Product_Price) < AVG(SUM(s.units * p.Product_Price)) OVER (ORDER BY FORMAT(s.REF_DATE, 'yyyy-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) * 0.9 THEN 'Significant Decline'
        ELSE 'Stable'
    END AS Performance
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY FORMAT(s.REF_DATE, 'yyyy-MM')
ORDER BY Month;


--Analysis -4

--Cumilative Distribution Of Profit Margin
--Calculate the cumulative distribution of profit margin for each product category, consider where products are having profit.

-- Create an index on Product_Category to improve partitioning and sorting
CREATE INDEX idx_products_category ON products(Product_Category);

-- Create a composite index on Product_Price and Product_Cost to optimize filtering and calculations
CREATE INDEX idx_products_price_cost ON products(Product_Price, Product_Cost);

--Query
SELECT
    p.Product_Category,
    p.Product_Name,
    ((p.Product_Price - p.Product_Cost) / p.Product_Price) * 100 AS Profit_Margin,
    SUM(((p.Product_Price - p.Product_Cost) / p.Product_Price) * 100) 
        OVER (PARTITION BY p.Product_Category ORDER BY ((p.Product_Price - p.Product_Cost) / p.Product_Price) * 100 ASC) AS Cumulative_Profit_Margin
FROM products p
WHERE p.Product_Price > p.Product_Cost -- Only include profitable products
ORDER BY p.Product_Category,Cumulative_Profit_Margin;

--Analysis -5
--Store Inventory Turnover Analysis
--Analyze the efficiency of inventory turnover for each store by calculating the Inventory Turnover Ratio.

-- Index on Store_ID in Sales to optimize grouping and joining
CREATE INDEX idx_sales_store_id ON Sales(Store_ID);

-- Index on Product_ID in Sales and Products to optimize joins
CREATE INDEX idx_sales_product_ids ON Sales(Product_ID);
CREATE INDEX idx_products_product_ids ON Products(Product_ID);

-- Index on Store_ID in inventory to optimize grouping and joining
CREATE INDEX idx_inventory_store_id ON inventory(Store_ID);

-- Index on Product_Cost in Products to optimize COGS calculation
CREATE INDEX idx_products_product_cost ON Products(Product_Cost);

--query

SELECT s.Store_ID,SUM(s.units * p.Product_Cost) AS COGS,AVG(i.Stock_On_Hand) AS Avg_Inventory,    --COGS-->Cost Of Goods Sold
    CASE 
        WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL -- To handle division by zero
        ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
    END AS Inventory_Turnover_Ratio,
    -- Calculate Max_Turnover_Ratio across all stores
    MAX(CASE 
        WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
        ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
    END) OVER () AS Max_Turnover_Ratio,
    -- Calculate efficiency percentage based on Max_Turnover_Ratio
    CASE 
        WHEN MAX(CASE 
                    WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
                    ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
                 END) OVER () IS NULL
            OR MAX(CASE 
                    WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
                    ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
                 END) OVER () = 0 THEN NULL
        ELSE (CASE 
                WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
                ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
             END / MAX(CASE 
                            WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
                            ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
                         END) OVER ()) * 100
    END AS Inventory_Turnover_Efficiency_Percentage
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
JOIN inventory i ON s.Store_ID = i.Store_ID
GROUP BY s.Store_ID
ORDER BY s.Store_ID;
