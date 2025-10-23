/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
-- Find the total sales
SELECT SUM(sales_amount) total_sales
FROM gold.fact_sales

--Finf how many items are sold
SELECT SUM(quantity) total_quantity
FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) avg_price
FROM gold.fact_sales

-- Find the total number of orders
SELECT COUNT(DISTINCT order_number) total_orders
FROM gold.fact_sales

-- Find the total number of products
SELECT COUNT(DISTINCT product_name) total_products 
FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(customer_id) total_customers FROM gold.dim_customers

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) FROM gold.fact_sales

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' measure_name, SUM(sales_amount) measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' measure_name, SUM(quantity) measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' measure_name, AVG(price) measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders' measure_name, COUNT(DISTINCT order_number) measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_products' measure_name, COUNT(DISTINCT product_name) measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total_customers' measure_name, COUNT(customer_id) measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total Customers with Orders' measure_name, COUNT(DISTINCT customer_key) measure_values FROM gold.fact_sales
