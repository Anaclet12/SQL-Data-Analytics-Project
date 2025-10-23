/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: EXTRACT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
-- Find the key metrics over year
SELECT
EXTRACT(YEAR FROM order_date) order_year,
MIN(order_date) first_order_date,
Max(order_date) last_order_date,
AGE(MAX(order_date), MIN(order_date)) period,
TO_CHAR(SUM(sales_amount), 'FM999,999,999') total_sales,
TO_CHAR(SUM(quantity), '9,999,999') total_quantities,
TO_CHAR(ROUND(AVG(price)), '9,999,999') avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1

-- Find the key metrics over month
SELECT
EXTRACT(YEAR FROM order_date) order_year,
EXTRACT(MONTH FROM order_date) order_month,
--MIN(order_date) first_order_date,
--Max(order_date) last_order_date,
AGE(MAX(order_date), MIN(order_date)) period,
TO_CHAR(SUM(sales_amount), 'FM999,999,999') total_sales,
TO_CHAR(SUM(quantity), '9,999,999') total_quantities,
TO_CHAR(ROUND(AVG(price)), '9,999,999') avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1,2
ORDER BY 1,2
