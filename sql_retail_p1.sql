CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 15

SELECT * FROM retail_sales
WHERE TRANSACTIONS_ID IS NULL

SELECT * FROM retail_sales
WHERE SALE_DATE IS NULL

-- CHECKING FOR NULL VALES

SELECT * FROM retail_sales
WHERE
	TRANSACTIONS_ID IS NULL
	OR
	SALE_DATE IS NULL
	OR
	sale_time IS NULL
	OR
    customer_id IS NULL
	OR
    gender IS NULL
	OR
    AGE IS NULL
	OR
    category IS NULL
	OR
    quantity IS NULL
	OR
    price_per_unit IS NULL
	OR
    cogs IS NULL
	OR
    total_sale IS NULL;
	
-- REMOVIMG NULL VALUSE 

DELETE FROM RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR
	SALE_DATE IS NULL
	OR
	sale_time IS NULL
	OR
    customer_id IS NULL
	OR
    gender IS NULL
	OR
    AGE IS NULL
	OR
    category IS NULL
	OR
    quantity IS NULL
	OR
    price_per_unit IS NULL
	OR
    cogs IS NULL
	OR
    total_sale IS NULL;

SELECT COUNT(*) FROM RETAIL_SALES

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE 

SELECT COUNT(*) AS TOTAL_SALES FROM RETAIL_SALES

-- HOW MANY UNIQUE CUSTOMERS WE HAVE 

SELECT COUNT(DISTINCT(CUSTOMER_ID)) AS NO_UNIQUE_CUSTOMERS FROM RETAIL_SALES

SELECT DISTINCT(CATEGORY)  FROM RETAIL_SALES
 
-- DATA ANALYSIS 

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM RETAIL_SALES
WHERE SALE_DATE='2022-11-05'

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM RETAIL_SALES
WHERE CATEGORY= 'Clothing' AND QUANTITY >=4 AND SALE_DATE >= '2022-11-01' AND  SALE_DATE < '2022-12-01'

SELECT * FROM RETAIL_SALES
WHERE CATEGORY= 'Clothing' AND QUANTITY >=4 AND SALE_DATE BETWEEN '2022-11-01' AND  '2022-11-30'

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT  CATEGORY, SUM(TOTAL_SALE) AS TOTAL_SALE, COUNT(*) AS TOTAL_ORDER FROM RETAIL_SALES
GROUP BY CATEGORY;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT ROUND(AVG(AGE),2) AS AGE FROM RETAIL_SALES
WHERE CATEGORY='Beauty'

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM RETAIL_SALES
WHERE TOTAL_SALE > 1000

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT CATEGORY,GENDER,COUNT(transactions_id) AS NO_OF_TRANSACTION FROM RETAIL_SALES
GROUP BY CATEGORY,GENDER
ORDER BY CATEGORY

-- OR 

SELECT category,gender,COUNT(*) as total_trans FROM retail_sales
GROUP BY category,gender
ORDER BY 2

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT YEAR, MONTH, avg_sale FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
	AVG(TOTAL_SALE) AS AVG_SALE,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(total_SALE) DESC) AS RANK
FROM RETAIL_SALES
GROUP BY 1,2
) AS T1
WHERE RANK = 1

--8. Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT CUSTOMER_ID, SUM(TOTAL_SALE) AS TOTAL_SALES FROM RETAIL_SALES
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT CATEGORY, COUNT(DISTINCT(CUSTOMER_ID)) AS NO_OF_CUSTOMER FROM RETAIL_SALES
GROUP BY CATEGORY

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH HOURLY_SALE 
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM SALE_TIME) <12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN ' AFTERNOON'
		ELSE 'EVENING'
	END  AS SHIFT
FROM RETAIL_SALES
)
SELECT SHIFT, COUNT(*) AS TOTAL_ORDERS FROM HOURLY_SALE
GROUP BY SHIFT

