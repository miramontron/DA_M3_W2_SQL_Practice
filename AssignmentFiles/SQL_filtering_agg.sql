-- ==================================
-- FILTERS & AGGREGATION
-- ==================================

USE coffeeshop_db;


-- Q1) Compute total items per order.
--     Return (order_id, total_items) from order_items.
SELECT order_id, SUM(quantity) AS total_items FROM order_items GROUP BY order_id;

-- Q2) Compute total items per order for PAID orders only.
--     Return (order_id, total_items). Hint: order_id IN (SELECT ... FROM orders WHERE status='paid').
SELECT order_id, SUM(quantity) AS total_items FROM order_items 
WHERE order_id IN (
	SELECT order_id FROM orders WHERE status='paid') 
GROUP BY order_id;

-- Q3) How many orders were placed per day (all statuses)?
--     Return (order_date, orders_count) from orders.
SELECT DATE(order_datetime) AS order_date, COUNT(order_datetime) AS orders_count FROM orders GROUP BY order_date;

-- Q4) What is the average number of items per PAID order?
--     Use a subquery or CTE over order_items filtered by order_id IN (...).
SELECT AVG(total_items) AS avg_items_per_order 
FROM (
	SELECT order_id, SUM(quantity) AS total_items 
    FROM order_items 
    WHERE order_id IN (
		SELECT order_id FROM orders WHERE status='paid') 
GROUP BY order_id) AS order_totals;

-- Q5) Which products (by product_id) have sold the most units overall across all stores?
--     Return (product_id, total_units), sorted desc.
SELECT product_id, SUM(quantity) AS total_units FROM order_items GROUP BY product_id ORDER BY total_units DESC;

-- Q6) Among PAID orders only, which product_ids have the most units sold?
--     Return (product_id, total_units_paid), sorted desc.
--     Hint: order_id IN (SELECT order_id FROM orders WHERE status='paid').
SELECT product_id, SUM(quantity) AS total_units_paid FROM order_items 
WHERE order_id IN (
	SELECT order_id FROM orders WHERE status = 'paid') 
GROUP BY product_id 
ORDER BY total_units_paid DESC;

-- Q7) For each store, how many UNIQUE customers have placed a PAID order?
--     Return (store_id, unique_customers) using only the orders table.
SELECT store_id, COUNT(DISTINCT customer_id) AS unique_customers FROM orders 
WHERE status = 'paid' 
GROUP BY store_id;

-- Q8) Which day of week has the highest number of PAID orders?
--     Return (day_name, orders_count). Hint: DAYNAME(order_datetime). Return ties if any.
SELECT DAYNAME(order_datetime) AS day_name, COUNT(order_id) AS order_count FROM orders 
WHERE status = 'paid' 
GROUP BY day_name 
ORDER BY order_count DESC LIMIT 1;

-- Q9) Show the calendar days whose total orders (any status) exceed 3.
--     Use HAVING. Return (order_date, orders_count).
SELECT DATE(order_datetime) AS order_date, COUNT(order_id) AS orders_count FROM orders GROUP BY order_date HAVING orders_count > 3;

-- Q10) Per store, list payment_method and the number of PAID orders.
--      Return (store_id, payment_method, paid_orders_count).
SELECT store_id, payment_method, COUNT(*) AS paid_orders_count FROM orders 
WHERE status = 'paid' 
GROUP BY store_id, payment_method 
ORDER BY store_id;

-- Q11) Among PAID orders, what percent used 'app' as the payment_method?
--      Return a single row with pct_app_paid_orders (0–100) .
SELECT COUNT(*) * 100 / (SELECT COUNT(*) FROM orders WHERE status = 'paid') AS pct_app_paid_orders FROM orders 
WHERE status = 'paid' AND payment_method = 'app';

-- Q12) Busiest hour: for PAID orders, show (hour_of_day, orders_count) sorted desc.
SELECT HOUR(order_datetime) AS hour_of_day, COUNT(*) AS orders_count FROM orders 
WHERE status = 'paid' 
GROUP BY hour_of_day 
ORDER BY orders_count DESC;


-- ================
