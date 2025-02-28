-- Understanding the data by looking at the contents of each table.
SELECT *
FROM categories; -- The categories table contains 2 columns and 11 types of categories; the data is already clean.

SELECT *
FROM cities; -- There are 96 city names, but only 1 type of CountryId, which is 32. Some zip codes are less than 5 digits, what should be done with these?

SELECT *
FROM countries -- There are 206 country names, all of which are unique with no duplicates.
ORDER BY countrycode;

SELECT *
FROM customers; -- There are 98,759 records. Are there any duplicates? Let's check.
WITH customer_dup AS(
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY firstname, middleinitial, lastname, cityid, address ORDER BY cityid) AS row_num
    FROM customers 
)
SELECT *
FROM customer_dup
WHERE row_num > 1; -- Without including the address, there are 38 duplicate values. When all columns are included, there are no duplicate values.

SELECT *
FROM employees
ORDER BY firstname; -- There are 23 unique records with no duplicates.

WITH product_dup AS(
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY productname ORDER BY productid) AS row_num
    FROM products
)
SELECT *
FROM product_dup;
WHERE row_num > 1; -- There are 452 unique product names with no duplicates.

SELECT *
FROM sales; -- There are 6,758,125 records.
WITH sales_dup AS(
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY salespersonid, customerid, productid, quantity, salesdate, transactionnumber ORDER BY productid) AS row_num
    FROM sales
)
SELECT *
FROM sales_dup
WHERE row_num > 1; -- Found 16 duplicates if transactionnumber is not included.

-- Identify empty or null values in the dataset using Dynamic SQL.
DO
$$
DECLARE
    r RECORD;
    tbl_name TEXT := 'categories'; -- Replace this table with other tables to check null values.
BEGIN
    DROP TABLE IF EXISTS null_counts;
    CREATE TEMP TABLE null_counts (column_name TEXT, null_count INT);
    FOR r IN 
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = tbl_name 
    LOOP
        EXECUTE format('INSERT INTO null_counts SELECT %L AS column_name, COUNT(*) AS null_count FROM %I WHERE %I IS NULL', r.column_name, tbl_name, r.column_name);
    END LOOP;
END;
$$;
SELECT * FROM null_counts;
-- In the sales table, only the salesdate column has 67,526 null values; all other values are unique.
-- Tables categories, countries, cities, customers, employees, and products all have full unique values without any null values.

-- Since there are 67,526 null values in the sales table under the salesdate column, let’s check their contents.
SELECT 
    EXTRACT(YEAR FROM salesdate) AS year,
    EXTRACT(MONTH FROM salesdate) AS month
FROM sales
GROUP BY 1, 2
ORDER BY 1, 2; -- It is identified that salesdate contains months and years ranging from January to May 2018.

UPDATE sales
SET salesdate = '2025-01-01'
WHERE salesdate IS NULL; -- Instead of deleting data, null values in salesdate are replaced with the year 2025.

-- Update values of totalprice.
UPDATE sales s
SET totalprice = s.quantity * p.price
FROM products p
WHERE s.productId = p.productId; -- Update totalprice from its original value (0) to the actual calculated value (s.quantity * p.price).
