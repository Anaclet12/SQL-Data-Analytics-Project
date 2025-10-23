/*
===============================================================================
Date Exploration
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), AGE()
===============================================================================
*/
-- Find the date of the 1st and last order
SELECT 
MIN(order_date) first_order_date,
Max(order_date) last_order_date,
(MAX(order_date) - MIN(order_date))/30 order_range_months --Calculate months of sales available
FROM gold.fact_sales

--Find the youngest and the oldest customer
SELECT
MIN(birthdate) oldest_birthdate,
EXTRACT(YEAR FROM AGE(clock_timestamp(), MIN(birthdate))) oldest_age,
Max(birthdate) youngest_birthdate,
EXTRACT(YEAR FROM AGE(clock_timestamp(), Max(birthdate))) youngest_age
FROM gold.dim_customers
