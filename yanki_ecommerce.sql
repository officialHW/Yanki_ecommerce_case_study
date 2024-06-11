-- the ERD could always stand as a map to run a query
-- Window Functions:
-- 1. Calculate the total sales amount for each order along with the individual product sales.(basicaly calculate the sum of each order)
SELECT 
	o.Order_ID,
	p.Product_ID,
	p.Price,
	o.Quantity,
	o.Total_Price,
-- below is calculating the sum
	SUM(p.Price * o.Quantity) OVER (PARTITION BY o.Order_ID) AS total_sale_amount
--we represent o as orders
From
	yanki.orders o
JOIN
	yanki.products p ON o.Product_ID = p.Product_ID;

-- 2. Calculate the running total price for each order (calculating the total price of each order)
SELECT
	Order_ID,
	Product_ID,
	Quantity,
	Total_Price,
	sum(Total_price) over (ORDER by Order_ID) as running_total_price
FROM
	yanki.orders

-- 3. Rank products by their price within each category.
SELECT
	Product_ID,
	Product_Name,
	Brand,
	Category,
	Price,
	RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS price_rank_by_category
from
	yanki.products


-- Ranking:
-- 1. Rank customers by the total amount they have spent (what i need from the erd here is the some attributes from order table and customers tables)
SELECT
	c.Customer_ID,
	c.Customer_Name,
	sum(Total_price) as total_spent,
	rank() over(order by sum(Total_price) desc) as customer_rank
FROM
	yanki.customers c
JOIN
	yanki.orders o ON c.Customer_ID = o.Customer_ID
Group by
	c.Customer_ID,
	c.Customer_Name;

-- 2. Rank products by their total sales amount.
select
	p.Product_ID,
	p.Product_Name,
	sum(o.Quantity) as total_quantity_sold,
	sum(o.Total_Price) as total_sales_amount,
	rank() over(order by sum(o.Total_Price) desc) as product_rank
from
	yanki.products p
join
	yanki.orders o on p.Product_ID = o.Product_ID
Group by
	p.Product_ID,
	p.Product_Name;

-- 3. Rank orders by their total price.
select
	Order_ID,
	Total_Price,
	Rank() over (order by Total_Price desc) as order_rank
from
	yanki.orders;

--CASE FUNCTION
--Case:
-- 1. Categorize the orders based on the total price
SELECT
	Order_ID,
	Total_Price,
	CASE
		WHEN Total_Price >= 1000 Then 'HIGH'
		WHEN Total_Price >= 500 and Total_Price < 1000 then 'MEDIUM'
		ELSE 'LOW'
	END AS Price_Category
From
	yanki.orders;

-- 2. Classify customers by the number of orders they made
select
	c.Customer_ID,
	c.Customer_Name,
	count(o.Order_ID) as num_orders,
	case
		when count(o.Order_ID) >= 10 then 'FREQUENT'
		WHEN count(o.Order_ID) >= 5 THEN 'REGULAR'
		ELSE 'OCCASIONAL'
	END AS Order_Frequency
from
	yanki.customers c
Join
	yanki.orders o on c.Customer_ID = o.Customer_ID
GROUP by
	c.Customer_ID,
	c.Customer_Name;

-- 3. Classify products by their prices.
select
	Product_ID,
	Product_Name,
	Price,
	case
		when Price >= 500 then 'EXPENSIVE'
		WHEN Price >= 100 and Price < 500 then 'MODERATE'
		ELSE 'AFFORDABLE'
	END AS prcie_category
from
	yanki.products;

-- JOIN FUNCTION
-- Inner Join:
-- Retrieve customer details along with the products they ordered.
select
	c.Customer_ID,
	c.Customer_Name,
	c.Email,
	c.Phone_Number,
	O.Order_ID,
	p.Product_ID,
	p.Product_Name,
	p.Brand,
	p.Price,
	o.Quantity,
	o.Total_price
from
	yanki.customers c
inner join
	yanki.orders o on c.Customer_ID = o.Customer_ID
inner join
	yanki.products p on o.Product_ID = p.Product_ID;

-- 2. Retrieve order details along with payment information (we want order details that have payment information)
select
	o.Order_ID,
	pm.Payment_Method,
	pm.Transaction_Status
from
	yanki.orders o
inner join
	yanki.payment_method pm on o.Order_ID = pm.Order_ID;

--Left Join:
-- 1. Retrieve all customers along with their orders, even if they haven't placed any orders
select
	c.Customer_ID,
	c.Customer_Name,
	c.Email,
	c.Phone_Number,
	o.Order_ID,
	o.Product_ID,
	o.Quantity,
	o.Total_Price
from
	yanki.customers c
left join
	yanki.orders o on c.Customer_ID = o.Customer_ID;

-- 2. Retrieve all orders along with product details, even if there are no corresponding products
select
	o.Order_ID,
	o.Customer_ID,
	p.Product_ID,
	p.Product_Name,
	p.Price,
	o.Quantity,
	o.Total_Price
FROM
	yanki.orders o
left join
	yanki.products p on o.Product_ID = p.Product_ID;

-- Right Join:
-- 1. Retrieve all orders along with payment information, even if there are no corresponding payment records.
select
	o.Order_ID,
	pm.Payment_Method,
	pm.Transaction_Status
from
	yanki.orders o
right join
	yanki.payment_method pm on o.Order_ID = pm.Order_ID;

-- 2. Retrieve all products along with the orders, even if there are no corresponding orders
select
	p.Product_ID,
	p.Product_Name,
	o.Order_ID,
	o.Quantity,
	o.Total_Price
from
	yanki.products p
right join
	yanki.orders o on p.Product_ID = o.Product_ID;


--Outer Join:
-- 1. Retrieve all customers along with their orders, including customers who have not placed any orders, and orders without corresponding customers
select
	c.Customer_ID,
	c.Customer_Name,
	c.Email,
	c.Phone_Number,
	O.Order_ID,
	o.Product_ID,
	O.Quantity,
	o.Total_Price
from
	yanki.customers c
full outer join
	yanki.orders o on c.Customer_ID = o.Customer_ID;

-- 2. Retrieve all orders along with payment information, including orders without corresponding payment records and payment records without corresponding orders
select
	o.Order_ID,
	pm.Payment_Method,
	pm.Transaction_Status
from
	yanki.orders o
full outer join
	yanki.payment_method pm on pm.Order_ID = o.Order_ID;