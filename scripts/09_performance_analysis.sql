/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
SELECT 
order_year,
product_name,
current_sales,
pr_sales,
yoy_sales,
CASE WHEN yoy_sales < 0 THEN 'Decrease'
	 WHEN yoy_sales > 0 THEN 'Increase'
	 ELSE 'No change'
END sls_trend,
prd_avg_sls_per_year,
avg_change,
CASE WHEN avg_change < 0 THEN 'Bellow Avg'
	 WHEN avg_change > 0 THEN 'Above Avg'
	 ELSE 'Avg'
END sls_vs_avg
FROM
(SELECT 
order_year,
product_name,
current_sales,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) pr_sales,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) yoy_sales,
AVG(current_sales) OVER(PARTITION BY product_name) prd_avg_sls_per_year,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) avg_change
FROM (
	SELECT 
	EXTRACT(YEAR FROM order_date) order_year,
	product_name,
	SUM(sales_amount) current_sales
	FROM gold.fact_sales
	LEFT JOIN gold.dim_products
	USING (product_key)
	WHERE order_date IS NOT NULL
	GROUP BY 1,2
	))

