# Grocery Sales Data Analysis: A Complete Documentation

This project involves analyzing sales data to extract actionable insights. The dataset includes information about categories, countries, cities, customers, employees, products, and sales transactions. Below, you'll find the end-to-end process: from setting up the database to conducting data analysis and summarizing insights.

---

## **1. Database Schema Setup**

The initial step is designing an efficient and integrated table structure. The database consists of several main entities:
- **The `categories` table**: Contains information about product categories.
- **The `countries` and `cities` tables**: Map geographical regions (countries and cities) where customers and employees are located.
- **The `customers` table**: Stores customer data such as names, addresses, and cities.
- **The `employees` table**: Contains employee data, including personal information and hire dates.
- **The `products` table**: Holds product details such as price, category, and additional attributes.
- **The `sales` table**: Stores sales transaction details, including products, customers, and the employees managing the sales.

This grocery sales dataset was obtained from Kaggle and can be accessed here: [Grocery Sales Dataset on Kaggle](https://www.kaggle.com/datasets/andrexibiza/grocery-sales-dataset).

Example of the code :
```sql
CREATE TABLE categories (
    CategoryId INT PRIMARY KEY,
    CategoryName VARCHAR(45) NOT NULL
);
```

  
## **2. Data Import**

After the table structure is ready, data is imported from CSV files using the `COPY` command. Here are some examples:

- Importing category data:
  ```sql
  COPY categories 
  FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/categories.csv' 
  DELIMITER ','
  CSV HEADER;
  ```
- Other data, including `customers`, `employees`, `products`, and `sales`, is imported in a similar manner.

This step ensures all raw data is available in the tables for further processing.

## **3. Data Cleaning**

**Steps performed:**
1. **Check for duplicates**:
   ```sql
   WITH sales_dup AS (
       SELECT 
           *,
           ROW_NUMBER() OVER (PARTITION BY salespersonid, customerid, productid, quantity, salesdate, transactionnumber ORDER BY transactionnumber) AS row_num
       FROM sales
   )
   SELECT * 
   FROM sales_dup
   WHERE row_num > 1;
   ```

2. **Handle missing values**:
   - Checked for `NULL` values column by column:
     ```sql
     SELECT * 
     FROM sales 
     WHERE salesdate IS NULL;
     ```
   - For a more efficient method:
     - Loop through all columns programmatically (dynamic SQL).


## **4. Analysis**

### **4.1. Total Sales by Category**
A `WITH` query was used to calculate total sales by category:

```sql
WITH cat_sales AS (
    SELECT 
        p.productname AS category,
        c.categoryname,
        SUM(s.totalprice) AS total_sales 
    FROM sales AS s
    LEFT JOIN products AS p
        ON s.productid = p.productid
    LEFT JOIN categories AS c
        ON p.categoryid = c.categoryid
    GROUP BY 1, 2
)
SELECT category, SUM(total_sales) AS total_sales
FROM cat_sales
GROUP BY category
ORDER BY total_sales DESC;
```

### **4.2. Employee Contribution to Sales**
Analyze sales contribution by employees:

```sql
SELECT 
    s.salespersonid,
    e.firstname || ' ' || e.lastname AS fullname,
    SUM(s.totalprice) AS total_sales
FROM sales AS s
FULL JOIN employees AS e
    ON s.salespersonid = e.employeeid
GROUP BY s.salespersonid, fullname
ORDER BY total_sales DESC;
```

---

## **5. Insights & Storytelling**

### **Key Findings**:
1. **High-performing Categories**:
   - Certain product categories contribute the majority of sales. These should be a focus for future promotions.

2. **Top Sales Employees**:
   - Employee contributions reveal top performers who consistently drive sales.

3. **Sales Trends**:
   - Seasonal spikes in sales highlight potential for targeted campaigns.

4. **Data Gaps**:
   - Missing `salesdate` in records (67,526 entries) reflects issues in tracking during certain transactions.
