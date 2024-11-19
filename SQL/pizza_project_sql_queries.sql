-- Retrieve the total number of orders placed
SELECT 
    COUNT(DISTINCT order_id) AS 'Total_Orders'
FROM
    pizza_order_details;
    
-- Retrieve the total number of Pizzas Sold
    SELECT 
    sum(quantity) as 'Total Quantity Sold'
FROM
    pizza_order_details;


-- Calculate the Revenue generated from pizza sales
SELECT 
    CAST(SUM(o.quantity * p.price) AS DECIMAL (10 , 2 )) AS Revenue
FROM
    pizza_order_details AS o
        INNER JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id;


-- Identify the highest-priced pizza.
SELECT 
    o.pizza_id AS pizza_name, p.price
FROM
    pizza_order_details AS o
        INNER JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id
ORDER BY price DESC
LIMIT 1;

-- Alternative (using window function)
with cte as (
select pizza_types.name as 'Pizza Name', cast(pizzas.price as decimal(10,2)) as 'Price',
rank() over (order by price desc) as rnk
from pizzas
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
)
select 'Pizza Name', Price from cte where rnk =1;


-- Identify the most common pizza size ordered.
SELECT 
    pizzas.size,
    COUNT(DISTINCT order_id) AS 'No of Orders',
    SUM(quantity) AS 'Total Quantity Ordered'
FROM
    pizza_order_details
        JOIN
    pizzas ON pizzas.pizza_id = pizza_order_details.pizza_id
GROUP BY pizzas.size
ORDER BY COUNT(DISTINCT order_id) DESC;


-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    t.name AS 'Pizza', SUM(o.quantity) AS 'Total Quantity'
FROM
    pizza_order_details AS o
        INNER JOIN
    pizzas ON o.pizza_id = pizzas.pizza_id
        INNER JOIN
    pizza_types AS t ON pizzas.pizza_type_id = t.pizza_type_id
GROUP BY quantity , name
ORDER BY SUM(quantity) DESC
LIMIT 5;


-- Find the total quantity of each pizza category ordered (this will help us to understand the category which customers prefer the most).
SELECT 
    t.category, SUM(o.quantity) AS 'Total Quantity'
FROM
    pizza_order_details AS o
        JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id
        JOIN
    pizza_types AS t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.category
ORDER BY SUM(o.quantity) DESC;


-- Determine the distribution of orders by hour of the day (at which time the orders are maximum (for inventory management and resource allocation).
SELECT 
    HOUR(time) AS 'Hour of the day',
    COUNT(DISTINCT order_id) AS 'No of Orders'
FROM
    orders
GROUP BY HOUR(time)
ORDER BY COUNT(DISTINCT order_id) DESC;

SELECT 
    HOUR(time) AS 'Hour of the day',
    COUNT(order_details_id) AS 'No of Orders'
FROM
    pizza_order_details AS d
        JOIN
    pizza_orders AS p ON d.order_id = p.order_id
GROUP BY HOUR(time)
ORDER BY COUNT(order_details_id) DESC;


-- Find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(DISTINCT pizza_type_id) AS 'No of pizzas'
FROM
    pizza_types
GROUP BY category
ORDER BY COUNT(DISTINCT pizza_type_id);

-- Total No of Pizzas in each category 
SELECT 
    category, COUNT(category) AS 'No of Pizzas'
FROM
    pizzas AS p
        JOIN
    pizza_types AS t ON p.pizza_type_id = t.pizza_type_id
GROUP BY category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.
with cte as(
SELECT 
    o.date, SUM(p.quantity) AS 'Total'
FROM
    pizza_order_details AS p join orders as o on p.order_id=o.order_id group by o.date) 
SELECT 
    ROUND(AVG(`Total`)) AS 'Daily AVG Quantity'
FROM
    cte;

-- alternate using subquery
SELECT 
    AVG(`Total Pizza Ordered`) AS 'Daily AVG Quantity'
FROM
    (SELECT 
        o.date, SUM(p.quantity) AS 'Total Pizza Ordered'
    FROM
        pizza_order_details AS p
    JOIN orders AS o ON p.order_id = o.order_id
    GROUP BY o.date) AS pizzas_ordered;


-- Determine the top 5 most ordered pizzas based on revenue
SELECT DISTINCT
    t.name,
    COUNT(o.quantity) AS 'Quantity',
    SUM(o.quantity * p.price) AS 'Revenue'
FROM
    pizza_order_details AS o
        JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id
        JOIN
    pizza_types AS t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.name
ORDER BY 3 DESC
LIMIT 5;

-- The most ordered pizza types based on revenue
SELECT DISTINCT
    o.pizza_id as 'Pizza Type',
    COUNT(o.quantity) AS 'Quantity',
    ROUND(SUM(o.quantity * p.price)) AS 'Revenue'
FROM
    pizza_order_details AS o
        JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id
GROUP BY o.pizza_id
ORDER BY 3 DESC;

-- Total No of Pizza Types
SELECT 
    COUNT(pizza_id) AS 'Pizza Type'
FROM
    pizzas;

-- Determine the top 3 most ordered pizza sizes based on revenue
SELECT DISTINCT
    p.size,
    COUNT(o.quantity) AS 'Quantity',
    ROUND(SUM(o.quantity * p.price)) AS 'Revenue'
FROM
    pizza_order_details AS o
        JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY 3 DESC;


-- Calculate the percentage contribution of each pizza by pizza name to total revenue (to understand % of contribution of each pizza in the total revenue)
SELECT DISTINCT
    t.name,
    COUNT(o.quantity) AS 'Quantity',
    CONCAT(ROUND((SUM(o.quantity * p.price) / 817860.05 * 100),
                    1),
            '%') AS 'contribution to Revenue'
FROM
    pizza_order_details AS o
        JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id
        JOIN
    pizza_types AS t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.name
ORDER BY 3 DESC;


-- Analyse the cumulative revenue generated over day.
with cte as (
SELECT 
    date AS 'Date',
    CAST(SUM(quantity * price) AS DECIMAL (10 , 2 )) AS Revenue
FROM
    pizza_order_details
        JOIN
    orders ON pizza_order_details.order_id = orders.order_id
        JOIN
    pizzas ON pizzas.pizza_id = pizza_order_details.pizza_id
GROUP BY date
)
select Date, Revenue, sum(Revenue) over (order by date) as 'Cumulative Sum'
from cte 
group by date, Revenue;

-- Determine the top 3 most ordered pizzas based on revenue for each pizza category.
with cte as (
SELECT 
    t.name,
    t.category,
    ROUND(SUM(o.quantity * p.price), 2) AS 'Revenue'
FROM
    pizza_order_details AS o
        JOIN
    pizzas AS p ON o.pizza_id = p.pizza_id
        JOIN
    pizza_types AS t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.name , t.category)
,cte1 as(
select category, name, `Revenue`, rank() 
over(partition by category order by `Revenue` desc)
as rnk from cte)
SELECT 
    category, name, `Revenue`
FROM
    cte1
WHERE
    rnk IN (1 , 2, 3)
ORDER BY category , `Revenue` DESC;


-- Monthly Sales
SELECT 
    MONTHNAME(date2) AS 'Month',
    SUM(p.quantity) AS 'Quantity',
    ROUND(SUM(p.quantity * price), 2) AS 'Sales'
FROM
    pizza_orders AS o
        inner JOIN
    pizza_order_details AS p ON o.order_id = p.order_id
        inner JOIN
    pizzas ON p.pizza_id = pizzas.pizza_id
GROUP BY 1;


-- Month on Month % Change
WITH cte AS (
    SELECT 
        MONTHNAME(date2) AS `Month`,
        SUM(p.quantity) AS `Quantity`,
        ROUND(SUM(p.quantity * price), 2) AS `Sales`,
        LEAD(ROUND(SUM(p.quantity * price), 2), 1) OVER () AS `nxSales`
    FROM 
        pizza_orders AS o
    JOIN 
        pizza_order_details AS p 
        ON o.order_id = p.order_id
    JOIN 
        pizzas 
        ON p.pizza_id = pizzas.pizza_id
    GROUP BY 
        MONTHNAME(date2))
SELECT 
    `Month`,
    `Quantity`,
    `Sales`,
    COALESCE(
        LAG(
            CAST(
                ((nxSales - Sales) / Sales * 100) AS DECIMAL(5, 2)
            )) OVER(), 
            0
        ) AS `Monthly Change %`
FROM cte;


-- Week on Week Change 
with cte as(
SELECT 
    WEEKOFYEAR(date2) AS 'Weeks',
    SUM(quantity) AS 'Quantity',
    ROUND(SUM(quantity * price), 2) AS 'Sales', 
lead(round(sum(quantity*price),2))
over(order by weekofyear(date2))
as 'nxweek' from pizza_orders as o
join pizza_order_details as p
on p.order_id=o.order_id join pizzas
on p.pizza_id=pizzas.pizza_id group by 1)
SELECT Weeks, Quantity, Sales,
coalesce(lag(cast(((nxweek-Sales)/Sales*100) as
decimal(4,2))) over(), 0) as 'Weekly Change %'
from cte group by Weeks;


-- top 3 positive and negative weeks
with cte as(
SELECT 
    WEEKOFYEAR(date2) AS 'Weeks',
    SUM(quantity) AS 'Quantity',
    ROUND(SUM(quantity * price), 2) AS 'Sales', 
lead(round(sum(quantity*price),2))
over(order by weekofyear(date2)) as 'nxweek'
from pizza_orders as o join pizza_order_details as p 
on p.order_id=o.order_id join pizzas on p.pizza_id=pizzas.pizza_id
group by 1),
cte1 as(
select lead(Weeks) over() as 'Weeks', lead(Quantity)
over() as 'Quantity', lead(Sales) over() as 'Sales',
((nxweek-Sales)/Sales*100) as 'Weekly Change %', 
rank() over(order by ((nxweek-Sales)/Sales*100) desc) as rnk
from cte)
(select Weeks, Quantity, Sales, `Weekly Change %` 
from cte1 where rnk in (49,50,51) or rnk in (1,2,3)
order by 4 desc);


-- best seller pizza for each month (July has 90 pizzas only out of 91)
with cte as(
SELECT 
    d.pizza_id,
    t.name AS 'Name',
    p.size AS 'Size',
    SUM(quantity) AS 'Total Quantity',
    MONTHNAME(date2) AS 'Month'
FROM
    pizza_order_details AS d
        JOIN
    pizza_orders AS o ON d.order_id = o.order_id
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id
        JOIN
    pizza_types AS t ON p.pizza_type_id = t.pizza_type_id
GROUP BY 1 , 2 , 3 , 5
ORDER BY 5 , 4 DESC),
cte1 as(
select *, row_number() over(partition by month order by 'total quantity')
as 'Pizza_Rank' from cte)
(SELECT 
    `Name`, `Size`, `Total Quantity`, `Month`, Pizza_Rank
FROM
    cte1
WHERE
    Pizza_Rank IN (1 , 2, 3, 4, 5)
ORDER BY 5, 3 DESC);

-- Total pizzas in each sizes
SELECT 
    size, COUNT(size) AS 'No of Pizzas'
FROM
    pizzas
GROUP BY 1;

-- avg, min, max pizza prices 
SELECT 
    CAST(AVG(price) AS DECIMAL (4 , 2 )) AS 'AVG Price',
    MIN(price) AS 'MIN Price',
    MAX(price) AS 'MAX Price'
FROM
    pizza_order_details AS d
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id;

-- Top 5 Most Ordered Pizzas
SELECT 
    t.name AS 'Name',
    p.size AS 'Size',
    SUM(quantity) AS 'Total Quantity'
FROM
    pizza_order_details AS d
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id
        JOIN
    pizza_types AS t ON t.pizza_type_id = p.pizza_type_id
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 5;

-- Sales by Pizzas Price
SELECT 
    price 'Price', SUM(quantity) 'Total Quantity'
FROM
    pizza_order_details AS d
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id
GROUP BY price
ORDER BY 2 DESC;

-- Pizza Price Segmentation (Quantity)
SELECT 
    price 'Prices',
    SUM(quantity) 'Total Quantity',
    CASE
        WHEN price >= 9.75 AND price <= 16.3 THEN 'Low Price'
        WHEN price >= 16.4 AND price <= 22.85 THEN 'medium Price'
        WHEN price >= 22.86 AND price <= 29.4 THEN 'High Price'
        ELSE 'Very High'
    END AS 'Price Range'
FROM
    pizza_order_details AS d
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC;

-- Pizza Price Segmentation (Revenue)
SELECT 
    price 'Prices',
    SUM(quantity) 'Total Quantity',
    CAST(SUM(quantity * price) AS DECIMAL (10 , 2 )) AS 'Revenue',
    CASE
        WHEN price >= 9.75 AND price <= 16.3 THEN 'Low Price'
        WHEN price >= 16.4 AND price <= 22.85 THEN 'medium Price'
        WHEN price >= 22.86 AND price <= 29.4 THEN 'High Price'
        ELSE 'Very High'
    END AS 'Price Range'
FROM
    pizza_order_details AS d
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 3 DESC;

-- Day of the Week Analysis
with cte as(
SELECT COUNT(d.order_details_id) 'Total Orders', WEEKDAY(date2) AS 'week',
case
	when weekday(date2) = 0 then 'Monday'
	when weekday(date2) = 1 then 'Tuesday'
	when weekday(date2) = 2 then 'Wednesday'
	when weekday(date2) = 3 then 'Thursday'
	when weekday(date2) = 4 then 'Friday'
	when weekday(date2) = 5 then 'Saturday'
	when weekday(date2) = 6 then 'Sunday'
end as "weekday"
from
	pizza_orders as o
		join
	pizza_order_details as d on o.order_id=d.order_id
group by 2,3
order by 1 desc)
SELECT 
    `Total Orders`, `Weekday`
FROM
    cte;

-- Peak Sales Periods (Time of Day)
SELECT 
    COUNT(order_details_id) AS 'No of Orders',
    CASE
        WHEN HOUR(time) BETWEEN 9 AND 11 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(time) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS 'Period of Day'
FROM
    pizza_order_details AS d
        JOIN
    pizza_orders AS p ON d.order_id = p.order_id
GROUP BY 2
ORDER BY 1 DESC;


-- create temporary table for Daily Revenue
create temporary table daily_rev as
SELECT 
    date AS 'Date',
    CAST(SUM(quantity * price) AS DECIMAL (10 , 2 )) AS Revenue
FROM
    pizza_order_details
        JOIN
    orders ON pizza_order_details.order_id = orders.order_id
        JOIN
    pizzas ON pizzas.pizza_id = pizza_order_details.pizza_id
GROUP BY date;

-- Retrive The Dates Where Revenue is More Than $3000 from Temporary Table daily_rev
SELECT 
    *
FROM
    daily_rev
WHERE
    Revenue > 3000
ORDER BY revenue desc;

drop table daily_rev;

-- Pizza Sales Summary by Price Range
SELECT
    price 'Prices',
    SUM(quantity) 'Total Quantity',
    CAST(SUM(quantity * price) AS DECIMAL (10 , 2 )) AS 'Revenue',
    CASE
        WHEN price >= 9 AND price < 16 THEN 'Low Price'
        WHEN price >= 16 AND price < 20 THEN 'medium Price'
        WHEN price >= 20 AND price < 26 THEN 'High Price'
        ELSE 'Very High'
    END AS 'Price Range'
FROM
    pizza_order_details AS d
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 3 DESC;

-- Pizza Price Compare by Quantity Sold
SELECT 
    price 'Prices',
    SUM(quantity) 'Total Quantity',
    CAST(SUM(quantity * price) AS DECIMAL (10 , 2 )) AS 'Revenue',
    CASE
        WHEN SUM(quantity) between 0 and 2222 THEN 'Low '
        WHEN SUM(quantity) between 2223 and 4444 THEN 'medium '
        WHEN SUM(quantity) between 4445 and 6666 THEN 'High '
        ELSE 'very High'
    END AS 'Quantity Sold'
FROM
    pizza_order_details AS d
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 3 DESC;

-- count of pizzas in each price 
select price, count(pizza_id) from pizzas group by price order by 2 desc;

-- find median price by join pizzas and pizza_order_details
SET @row_number := 0;
SET @total_rows := (SELECT COUNT(*) FROM pizza_order_details AS d 
                    JOIN pizzas AS p ON d.pizza_id = p.pizza_id);

SELECT price AS median_price
FROM (
    SELECT price
    FROM (
        SELECT @row_number := @row_number + 1 AS 'row_number', price
        FROM pizza_order_details AS d
        JOIN pizzas AS p ON d.pizza_id = p.pizza_id
        ORDER BY price
    ) AS ordered_prices
    WHERE `row_number` IN (FLOOR(@total_rows / 2) + 1, CEIL(@total_rows / 2) + 1)
) AS median_prices;

-- avg price by joining two tables 
select avg(price) from pizza_order_details as d join pizzas as p on d.pizza_id=p.pizza_id;
-- avg price in pizzas table 
select avg(price) from pizzas;

-- price median value in pizzas table only 
SET @row_number := 0;
SET @total_rows := (SELECT COUNT(*) FROM pizzas);

SELECT price AS median_price
FROM (
    SELECT price
    FROM (
        SELECT @row_number := @row_number + 1 AS 'row_number', price
        FROM pizzas
        ORDER BY price
    ) AS ordered_prices
    WHERE `row_number` IN (FLOOR(@total_rows / 2) + 1, CEIL(@total_rows / 2) + 1)
) AS median_prices;


-- joining the median with avg,min,max 
SET @row_number := 0;
SET @total_rows := (SELECT COUNT(*) FROM pizza_order_details AS d 
                    JOIN pizzas AS p ON d.pizza_id = p.pizza_id);
with cte as(
SELECT 
    CAST(AVG(price) AS DECIMAL (4 , 2 )) AS 'AVG Price',
    MIN(price) AS 'MIN Price',
    MAX(price) AS 'MAX Price'
FROM
    pizza_order_details AS d
        JOIN
    pizzas AS p ON d.pizza_id = p.pizza_id),
cte1 as(
SELECT price AS 'Median Price'
FROM (
    SELECT price
    FROM (
        SELECT @row_number := @row_number + 1 AS 'row_number', price
        FROM pizza_order_details AS d
        JOIN pizzas AS p ON d.pizza_id = p.pizza_id
        ORDER BY price
    ) AS ordered_prices
    WHERE `row_number` IN (FLOOR(@total_rows / 2) + 1, CEIL(@total_rows / 2) + 1)
) AS median_prices)
(select `MIN Price`, `AVG price`, `Median Price`, `MAX Price` from cte, cte1);

with cte as (
select d.pizza_id, p.price, row_number() over(order by price) as 'rnk' from pizza_order_details as d join pizzas as p on d.pizza_id=p.pizza_id 
 order by price
)
select * from cte where rnk in (24327,24328);


-- create stored procedure to search Pizzas details
delimiter $$    
CREATE PROCEDURE pizza_details(IN p_type_ids CHAR(100))
BEGIN
    SET @sql_query = CONCAT('
        SELECT 
            t.pizza_type_id,
            t.name,
            t.category,
            t.ingredients,
            p.size,
            p.price
        FROM pizza_types AS t
        JOIN pizzas AS p ON t.pizza_type_id = p.pizza_type_id
        WHERE t.pizza_type_id IN (', p_type_ids, ')');
    
    -- Execute the dynamically constructed query
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
delimiter ;

-- type pizza_type_id in () for result
CALL pizza_details("'bbq_ckn', 'big_meat'");

-- drop stored procedure 
drop procedure if exists pizza_details;