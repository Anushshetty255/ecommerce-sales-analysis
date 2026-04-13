----------------------------------------------------------------------------------------
Table Creation
--------------------------------------------------------------------------------------
CREATE TABLE sales_data (
    order_date DATE,
    product_name TEXT,
    category TEXT,
    region TEXT,
    quantity INT,
    sales NUMERIC,
    profit NUMERIC
);
------------------------------------------------------------------------------------
#Group by
------------------------------------------------------------------------------------
SELECT 
    category,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY category;

-----------------------------------------------------------------------------------------
#order by
----------------------------------------------------------------------------------------
SELECT * 
FROM sales_data
ORDER BY sales DESC;

----------------------------------------------------------------------------------------
Using view
-----------------------------------------------------------------------------------------
CREATE VIEW sales_clean AS SELECT TO_DATE(order_date,'YYYY-MM-DD') AS order_date, product_name, category,region,CAST(quantity AS INT)AS 
Quantity, CAST(sales AS NUMERIC) AS sales, Cast(profit AS NUMERIC) AS profit FROM sales_data;

DELETE FROM sales_data WHERE Order_date='Order Date';
SELECT *from sales_data LIMIT 5;

---------------------------------------------------------------------------------------
# CATEGORY PERFORMANCE
---------------------------------------------------------------------------------------
SELECT
	category,
		SUM(sales)As Total_sales,
       SUM(profit) As total_profit,
	   Round(SUM(profit)/SUM(sales)*100,2) AS
	   profit_margin FROM sales_clean
	   GROUP BY category
	   ORDER BY total_sales DESC;

SELECT 
	category,
		COUNT(*) AS total_orders,
		SUM(quantity) AS total_units FROM sales_clean
		GROUP BY category;
-------------------------------------------------------------------------------------
# region performance
-------------------------------------------------------------------------------------
SELECT
	region,
		SUM(sales)As Total_sales,
       	SUM(profit) As total_profit,
	   	Round(SUM(profit)/SUM(sales)*100,2) AS
	   	profit_margin FROM sales_clean
	   	GROUP BY region
	   	ORDER BY total_sales DESC;

"conclusion: West region earns highest profit and also profit margin"

---------------------------------------------------------------------------------------
#Monthly Trend
---------------------------------------------------------------------------------------
SELECT
		DATE_TRUNC('month',order_date) AS month,
		SUM(sales) AS monthly_sales
		FROM sales_clean
		GROUP BY month
		ORDER BY month;

"Conclusion: sales fluctaute month to month"
-------------------------------------------------------------------------------------------
# TOP PRODUCT 
-----------------------------------------------------------------------------------------------
SELECT
	category,
	product_name,
	SUM(sales) AS total_sales,
	rank() OVER (PARTITION BY category
	ORDER BY sum(sales) DESC) AS rank
	FROM sales_clean
	GROUP BY category, Product_name;


"Conclusion: Monitor top sold accessory and camera in electronic "
----------------------------------------------------------------------------------------
#Month over month
----------------------------------------------------------------------------------------

SELECT 
    month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY month) AS prev_month,
    ROUND(
        (monthly_sales - LAG(monthly_sales) OVER (ORDER BY month)) 
        / LAG(monthly_sales) OVER (ORDER BY month) * 100, 2
    ) AS growth_pct
FROM (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM sales_clean
    GROUP BY month
) t;

#2
SELECT 
    month,
    monthly_sales,
    LAG(monthly_sales, 12) OVER (ORDER BY month) AS prev_year_sales,
    
    ROUND(
        (monthly_sales - LAG(monthly_sales, 12) OVER (ORDER BY month)) 
        * 100.0 /
        LAG(monthly_sales, 12) OVER (ORDER BY month),
    2) AS yoy_growth
FROM (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM sales_clean
    GROUP BY month
) t;

"Conclusion : Data shows inconsistent up and down movement of monthly sales"
-------------------------------------------------------------------------------
Window function
--------------------------------------------------------------------------------
SELECT 
		Product_name,
		SUM(sales) AS total_sales,
		Rank() OVER (ORDER BY SUM(sales)DESC) AS rank FROM sales_clean 
		Group BY product_name;

" Conclusion: Camera is the top sold product followed and monitor and printer"