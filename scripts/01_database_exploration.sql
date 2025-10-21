/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Retrieve the list of all tables or views in Gold schema
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold'
  AND TABLE_TYPE IN ('BASE TABLE', 'VIEW');

-- Retrieve the list of all columns in sales table
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'gold'  -- schema name
  AND table_name = 'fact_sales';  -- table name

-- Retrieve the list of all columns in customers table
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'gold'  
  AND table_name = 'dim_customers';  

-- Retrieve the list of all columns in products table
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'gold'  
  AND table_name = 'dim_products';  
