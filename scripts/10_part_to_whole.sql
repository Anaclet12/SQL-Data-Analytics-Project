/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Sales by category
SELECT
b.category,
SUM(sales_amount) total_sales,
ROUND(SUM(sales_amount)::numeric/(SELECT SUM(sales_amount)::numeric FROM gold.fact_sales)*100, 2)||''||'%' 
FROM gold.fact_sales
LEFT JOIN gold.dim_products b
USING(product_key)
GROUP BY 1
ORDER BY 2 DESC

-- Find the year sales on the overall
SELECT
EXTRACT(YEAR FROM order_date) order_year,
ROUND(SUM(sales_amount)::numeric/(SELECT SUM(sales_amount)::numeric FROM gold.fact_sales)*100, 2)||''||'%' sales_percent
FROM gold.fact_sales
WHERE EXTRACT(YEAR FROM order_date) IS NOT NULL
GROUP BY 1
ORDER BY sales_percent DESC

-- Find the top 5 products on the overall in term of sales amount
SELECT
b.product_name,
b.category,
b.subcategory,
ROUND(SUM(sales_amount)::numeric/(SELECT SUM(sales_amount)::numeric FROM gold.fact_sales)*100, 3)||''||'%' sales_percent
FROM gold.fact_sales
JOIN gold.dim_products b
USING(product_key)
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 5

-- Find the top 3 products in term of sales amount on each category
SELECT *
FROM (
	SELECT
	category,
	subcategory,
	product_name,
	sales_percent,
	ROW_NUMBER() OVER(PARTITION BY category ORDER BY sales_percent DESC) ord_num
	FROM (
		SELECT
		b.product_name,
		b.category,
		b.subcategory,
		ROUND(SUM(sales_amount)::numeric/(SELECT SUM(sales_amount)::numeric FROM gold.fact_sales)*100, 3)||''||'%' sales_percent
		FROM gold.fact_sales
		JOIN gold.dim_products b
		USING(product_key)
		GROUP BY 1,2,3
		ORDER BY 4 DESC))
WHERE ord_num <= 3


-- Find the 5 lowest products on the overall in term of sales amount
SELECT *
FROM (
	SELECT
	category,
	subcategory,
	product_name,
	sales_percent,
	ROW_NUMBER() OVER(PARTITION BY category ORDER BY sales_percent) ord_num
	FROM (
		SELECT
		b.product_name,
		b.category,
		b.subcategory,
		ROUND(SUM(sales_amount)::numeric/(SELECT SUM(sales_amount)::numeric FROM gold.fact_sales)*100, 3)||''||'%' sales_percent
		FROM gold.fact_sales
		JOIN gold.dim_products b
		USING(product_key)
		GROUP BY 1,2,3
		ORDER BY 4 DESC))
WHERE ord_num <= 5

-- Find the top 5 customers on the overall in term of sales amount
SELECT
b.first_name||' '||b.last_name full_name,
SUM(sales_amount) total_sales,
ROUND(SUM(sales_amount)::numeric/(SELECT SUM(sales_amount)::numeric FROM gold.fact_sales)*100, 3)||''||'%' sales_percent
FROM gold.fact_sales
JOIN gold.dim_customers b
USING(customer_key)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Find the top 5 customers in term of sales amount per country
SELECT * 
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY country ORDER BY sales_percent DESC) ord_num
	FROM (
		SELECT
		b.country,
		b.first_name||' '||b.last_name full_name,
		SUM(sales_amount) total_sales,
		ROUND(SUM(sales_amount)::numeric/(SELECT SUM(sales_amount)::numeric FROM gold.fact_sales)*100, 3)||''||'%' sales_percent
		FROM gold.fact_sales
		JOIN gold.dim_customers b
		USING(customer_key)
		WHERE country <> 'n/a'
		GROUP BY 1,2
		ORDER BY 4 DESC))
WHERE ord_num <= 5

