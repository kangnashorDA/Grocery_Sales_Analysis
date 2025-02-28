CREATE TABLE categories (
    CategoryId INT PRIMARY KEY,
    CategoryName VARCHAR(45) NOT NULL
);

CREATE TABLE countries (
    CountryId INT PRIMARY KEY,
    CountryName VARCHAR(45) NOT NULL,
	CountryCode VARCHAR(2)
);

CREATE TABLE cities (
    CityId INT PRIMARY KEY,
    CityName VARCHAR(45) NOT NULL,
    Zipcode DECIMAL(5,0),
	CountryId INT,
    FOREIGN KEY (CountryId) REFERENCES countries(CountryId)
);

CREATE TABLE customers (
    CustomerId INT PRIMARY KEY,
    FirstName VARCHAR(45) NOT NULL,
	MiddleInitial VARCHAR(1),
	LastName VARCHAR(45),
	CityId INT,
	Address VARCHAR(90),
    FOREIGN KEY (CityId) REFERENCES cities(CityId)
);

CREATE TABLE employees (
    EmployeeId INT PRIMARY KEY,
	FirstName VARCHAR(45) NOT NULL,
	MiddleInitial VARCHAR(5),
	LastName VARCHAR(45),
	BirthDate DATE,
	Gender VARCHAR(10),
	CityID INT,
	HireDate DATE,
	FOREIGN KEY (CityId) REFERENCES cities(CityId)
);

CREATE TABLE products (
    ProductId INT PRIMARY KEY,
    ProductName VARCHAR(45) NOT NULL,
    Price DECIMAL(4,0) NOT NULL,
	CategoryId INT,
	Class VARCHAR(15),
	ModifyDate DATE,
	Resistant VARCHAR(15),
	IsAllergic VARCHAR,
	VitalityDays DECIMAL(3,0)
	FOREIGN KEY (CategoryId) REFERENCES caategories(CategoryId)
);

CREATE TABLE sales (
    SalesId INT PRIMARY KEY,
	SalesPersonID INT,
    CustomerId INT,
	ProductId INT,
    Quantity INT,
    Discount DECIMAL(10,0),
    TotalPrice DECIMAL(10,0) NOT NULL,
    SalesDate TIMESTAMP,
	TransactionNumber VARCHAR(25) NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES products(ProductId),
    FOREIGN KEY (CustomerId) REFERENCES customers(CustomerId),
    FOREIGN KEY (SalesPersonId) REFERENCES employees(EmployeeId)
);



-- Import data into categories table
COPY categories 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/categories.csv' 
DELIMITER ','
CSV HEADER;

-- Import data into countries table
COPY countries 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/countries.csv' 
DELIMITER ','
CSV HEADER;

-- Import data into cities table
COPY cities 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/cities.csv' 
DELIMITER ','
CSV HEADER;

-- Import data into customers table with specified columns
COPY customers
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/customers.csv' 
DELIMITER ',' 
CSV HEADER;


-- Import data into employees table
COPY employees 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/employees.csv' 
DELIMITER ','
CSV HEADER;

-- Import data into products table
COPY products 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/products.csv' 
DELIMITER ','
CSV HEADER;

ALTER TABLE sales
ALTER COLUMN price TYPE DECIMAL(10,2);

-- Import data from sales split file table
COPY sales 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/sales_batch_1.csv' 
DELIMITER ','
CSV HEADER;
COPY sales 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/sales_batch_2.csv' 
DELIMITER ','
CSV HEADER;COPY sales 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/sales_batch_3.csv' 
DELIMITER ','
CSV HEADER;
COPY sales 
FROM 'D:/Data Analyst/Portfolio_Workbooks/Grocery_Sales_Database/sales_batch_4.csv' 
DELIMITER ','
CSV HEADER;