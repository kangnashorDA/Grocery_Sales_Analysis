-- Data Exploration (Exploratory Data Analysis - EDA) in PostgreSQL:
SELECT
    *
FROM sales;

-- Data Distribution
SELECT 
    salesdate::date, -- Since the salesdate format is a timestamp, it cannot be grouped directly, so it is cast to the date format.
    COUNT(*) AS sales_count 
FROM sales
GROUP BY salesdate::date
ORDER BY salesdate DESC; -- The last data entry is found to be on 2018-05-09 (the data is incomplete for the end of the month).

-- Descriptive Analysis
SELECT 
    ROUND(AVG(totalprice), 2) AS avg_sales,
    MIN(totalprice) AS min_sales,
    MAX(totalprice) AS max_sales,
    ROUND(STDDEV(totalprice), 2) AS stddev_sales
FROM sales; -- It is impossible for the minimum price to be 0, so there must be an issue with productid since the quantity is not 0.

SELECT
    productid,
    COUNT(*) AS countproduct
FROM sales
GROUP BY productid
HAVING SUM(totalprice) < 1; -- Found that productid 165, 278, and 405 have values of 0.

SELECT *
FROM products
WHERE productid IN (165, 278, 405); -- These products indeed have a price of 0, meaning they are OUTLIERS.

-- Aggregation Analysis
-- Analyze sales volume based on SALESPERSON, PRODUCTID, CATEGORY, and SALESDATE.
SELECT 
    s.salespersonid,
    e.firstname || ' ' || e.middleinitial || ' ' || e.lastname AS fullname,
    SUM(s.totalprice) AS total_sales 
FROM sales AS s
LEFT JOIN employees AS e
    ON s.salespersonid = e.employeeid
GROUP BY 1,2
ORDER BY 3 DESC; -- The top-performing salesperson is 21 - Devon D Brewer, while the lowest-performing is 17 - Seth D Franco.

SELECT 
    s.productid,
    p.productname,
    c.categoryname,
    SUM(s.totalprice) AS total_sales 
FROM sales AS s
LEFT JOIN products AS p
    ON p.productid = s.productid
LEFT JOIN categories AS c
    ON p.categoryid = c.categoryid
GROUP BY 1,2,3
ORDER BY 4 DESC; -- The best-selling product is Bread - Calabrase Baguette in the Dairy category.

WITH cat_sales AS(
    SELECT 
        s.productid,
        p.productname,
        c.categoryname AS category,
        SUM(s.totalprice) AS total_sales 
    FROM sales AS s
    LEFT JOIN products AS p
        ON p.productid = s.productid
    LEFT JOIN categories AS c
        ON p.categoryid = c.categoryid
    GROUP BY 1,2,3
)
SELECT 
    category,
    SUM(total_sales) AS total_sales
FROM cat_sales
GROUP BY 1
ORDER BY total_sales DESC; -- The most popular category is Confections, while the least popular is Shell Fish.

SELECT 
    EXTRACT(YEAR FROM salesdate) AS year,
    EXTRACT(MONTH FROM salesdate) AS month,
    SUM(totalprice) AS total_sales
FROM sales
GROUP BY 1,2
ORDER BY YEAR; -- In the fifth month (May), the data is incomplete (ending on 2018-05-09), resulting in a significant drop.
