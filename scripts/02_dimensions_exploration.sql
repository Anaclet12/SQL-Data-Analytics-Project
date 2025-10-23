/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
-- Explore all countries our customers come from
SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY 1
/*They come from 6 countries*/

-- Explore all categories
SELECT DISTINCT category, SUBCATEGORY, product_name
FROM gold.dim_products
ORDER BY 1
/*288 products in 36 subcategies grouped 4 categories*/
