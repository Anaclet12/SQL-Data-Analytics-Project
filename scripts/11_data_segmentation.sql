/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/
/*Segment product into cost range and count how
many products fall into each segment*/
SELECT 
cost_range,
COUNT(product_name) product_number
FROM (
	SELECT 
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
	     WHEN cost < 500 THEN '100-500'
		 WHEN cost < 1000 THEN '500-1000'
		 ELSE 'Above 1000'
	END cost_range
	FROM gold.dim_products)
GROUP BY 1
ORDER BY 2 DESC

/*Group customers into three segments based on their spending behavior:
  - VIP: customers with at least 12 months of history and spending more than $5,000
  - Regular: customers with at least 12 months of history and spending $5,000 or less
  - New: customers with a lifespan less than 12 months
  And find the total numbers of customers by each group*/

SELECT
COUNT(*) customer_number,
customer_group
FROM (

	SELECT
	*,
	CASE WHEN (EXTRACT(YEAR FROM lifespan)*12 + EXTRACT(MONTH FROM lifespan)) >= 12 AND total_sales > 5000 THEN 'VIP'
		 WHEN (EXTRACT(YEAR FROM lifespan)*12 + EXTRACT(MONTH FROM lifespan)) >= 12 AND total_sales <= 5000 THEN 'Regular'
		 ELSE 'New'
	END customer_group
	FROM (
		SELECT 
		customer_key,
		b.first_name||' '||b.last_name full_name,
		MIN(order_date) first_order,
		MAX(order_date) last_order,
		AGE(MAX(order_date), MIN(order_date)) lifespan,
		SUM(sales_amount) total_sales
		FROM gold.fact_sales
		LEFT JOIN gold.dim_customers b
		USING (customer_key)
		GROUP BY 1,2)
	ORDER BY total_sales)
GROUP BY 2
ORDER BY 1 DESC
