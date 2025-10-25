create database Retail;
use Retail;
Alter table `sql - retail sales analysis_utf` rename to Retail_Data;
SELECT 
    *
FROM
    Retail_Data;

SELECT 
    *
FROM
    Retail_Data
WHERE
    transaction_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR gender IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;

-- How many sales we have?
SELECT 
    COUNT(*) AS Total_Sales
FROM
    Retail_Data;

-- How many uniuque customers we have?
SELECT 
    COUNT(DISTINCT customer_id) AS Unique_Customer
FROM
    Retail_Data;

SELECT DISTINCT
    category
FROM
    Retail_Data;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    Retail_Data
WHERE
    sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT 
    *
FROM
    Retail_Data
WHERE
    category = 'Clothing'
        AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
        AND quantity > 3;
    
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS Total_Sales
FROM
    Retail_Data
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 2) AS average_age
FROM
    Retail_Data
WHERE
    category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    Retail_Data
WHERE
    total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(transaction_id)
FROM
    Retail_Data
GROUP BY gender , category
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    DATE_FORMAT(sale_date, '%Y') as year,
    DATE_FORMAT(sale_date, '%M') as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY DATE_FORMAT(sale_date, '%Y') ORDER BY AVG(total_sale) DESC) as rn
FROM Retail_Data
GROUP BY 1, 2
) as t1
WHERE rn = 1 ORDER BY 1, 3 DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale) AS Total_Sales
FROM
    Retail_Data
GROUP BY customer_id
ORDER BY Total_Sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS No_Of_Customers
FROM
    Retail_Data
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN date_format(sale_time,'%H') < 12 THEN 'Morning'
        WHEN date_format(sale_time,'%H') BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM Retail_Data
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;