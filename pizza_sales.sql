---KPI’s
--Total_Revenue: 
SELECT SUM(total_price) as total_revenue
FROM pizza_sales.dbo.pizza_sales;


--Average_Order_Value:
SELECT (SUM(total_price) / COUNT(distinct order_id)) as average_order_value
FROM dbo.pizza_sales;


--Total_Pizzas_Sold
SELECT SUM(quantity) as total_pizzas_sold
from dbo.pizza_sales;


--Total_orders
SELECT COUNT(distinct order_id) as total_no_of_orders 
FROM dbo.pizza_sales;


--Average_pizza_per_order
SELECT (sum(quantity) / round(count(distinct order_id), 2)) as average_pizzas_per_order
FROM dbo.pizza_sales;


--Daily Trend for Total Orders
SELECT DATENAME(DW, order_date) as order_day, COUNT(distinct order_id) as total_no_of_orders 
FROM dbo.pizza_sales
GROUP BY DATENAME(DW, order_date);


-- Monthly Trend for orders
SELECT DATENAME(MONTH ,order_date) as order_month , COUNT(distinct order_id) as total_no_of_orders 
FROM dbo.pizza_sales
GROUP BY DATENAME(MONTH, order_date);


-- Percentage of sales by Pizza Category
SELECT pizza_category, sum(total_price) as total_revenue, (SUM(total_price)*100 / ( SELECT SUM(total_price)  FROM dbo.pizza_sales)) as PCT
FROM dbo.pizza_sales
GROUP BY pizza_category;


-- Percentage sales by Pizza Size
SELECT pizza_size, cast(sum(total_price) as decimal(10,2)) as total_revenue, 
cast(SUM(total_price)*100 / ( SELECT SUM(total_price) FROM pizza_sales.dbo.pizza_sales) as decimal(10,2)) as PCT
FROM pizza_sales.dbo.pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;


-- Total Pizza Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as total_pizzas_sold
FROM pizza_sales.dbo.pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category;


-- Top 5 Pizzas by Revenue 
SELECT TOP 5 pizza_name, sum(total_price) as total_revenue
FROM pizza_sales.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC;


-- Bottom 5 Pizzas by Revenue 
SELECT TOP 5 pizza_name, sum(total_price) as total_revenue
FROM pizza_sales.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue ASC;


-- Top 5 Pizzas by Quality 
SELECT TOP 5 pizza_name, sum(quantity) as total_pizzas
FROM pizza_sales.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_pizzas DESC;


-- Bottom 5 Pizzas by Quality 
SELECT TOP 5 pizza_name, sum(quantity) as total_pizzas
FROM pizza_sales.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_pizzas;


-- Top 5 Pizzas by Total Orders
SELECT TOP 5 pizza_name, COUNT(distinct order_id) as total_orders
FROM pizza_sales.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC;


-- Bottom 5 Pizzas by Total Order 
SELECT TOP 5 pizza_name, COUNT(distinct order_id) as total_orders
FROM pizza_sales.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC;