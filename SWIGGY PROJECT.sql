CREATE DATABASE swiggy;
USE swiggy;

CREATE TABLE items(
id INT,
order_id BIGINT,	
name VARCHAR(100),
is_veg INT,
PRIMARY KEY (id)
);

CREATE TABLE orders(
id INT,
order_id BIGINT,
order_total	INT,
restaurant_name	VARCHAR(50),
order_time DATETIME,
rain_mode INT,
on_time INT,
FOREIGN KEY (id) REFERENCES items (id)
);

# Total number of items
SELECT count(distinct name) FROM items;

# Distribution of veg and non veg items
SELECT is_veg,count(name) as veg_items FROM items group by is_veg;

# How many items contain the word chiken
SELECT * FROM items where name like '%Chicken%';
SELECT count(*) FROM items where name like '%Chicken%';

# How many paratha items
SELECT * FROM items where name like '%Paratha%';

# What was the average number of items per order
SELECT AVG(item_count) AS avgitemsperorder
FROM (
    SELECT order_id, COUNT(name) AS item_count
    FROM items
    GROUP BY order_id
) AS subquery;

# How many time each item was ordered 
SELECT name,count(*) FROM items
group by name
order by count(*) desc;

# What are the different values of rain mode
SELECT distinct rain_mode FROM orders;

# How many distinct restaurant we have ordered
SELECT count(distinct restaurant_name) FROM orders;

# Restaurant with most orders
SELECT restaurant_name,count(*) FROM orders 
group by restaurant_name
order by count(*) desc;

# Orders placed per month and year
SELECT DATE_FORMAT(order_time, '%Y-%m') AS formatted_order_time, COUNT(DISTINCT order_id) AS order_count
FROM orders
GROUP BY formatted_order_time
ORDER BY order_count DESC;

SELECT max(order_time) FROM orders;

# Orders placed per month and year
SELECT DATE_FORMAT(order_time, '%Y-%m') AS formatted_order_time, COUNT(DISTINCT order_id) AS order_count
FROM orders
GROUP BY formatted_order_time
ORDER BY order_count DESC;

SELECT max(order_time) FROM orders;

# Revenue made by month
SELECT DATE_FORMAT(order_time, '%Y-%m') AS formatted_order_time, SUM(order_total) AS totalrevenue 
FROM orders
GROUP BY formatted_order_time
ORDER BY totalrevenue DESC;

# Average Order value
 SELECT sum(order_total)/count(distinct order_id) as aov FROM orders;

# Year on year Change in revenue using lag function and ranking the highest year
WITH final AS (
    SELECT DATE_FORMAT(order_time,'%Y') AS yearorder, SUM(order_total) AS revenue
    FROM orders
    GROUP BY yearorder
)
select yearorder,revenue,lag(revenue) over (order by yearorder) as previousrevenue from
final;

# Restaurant with highest revenue ranking
with final as (
SELECT DATE_FORMAT(order_time,'%Y') as yearorder,sum(order_total) as revenue
FROM orders
group by  yearorder
)
SELECT yearorder,revenue,
rank() over (order by revenue desc) as ranking from final;

with final as (
SELECT restaurant_name,sum(order_total) as revenue
FROM orders 
group by  restaurant_name)
select restaurant_name,revenue,
rank() over (order by revenue desc) as ranking from final
order by revenue desc;

# Join order and item tables and find product combos using self join
SELECT a.name,a.is_veg,b.restaurant_name,b.order_id,b.order_time FROM items a
join orders  b
on a.order_id=b.order_id;

SELECT a.order_id,a.name,b.name as name2,concat(a.name,"-",b.name) FROM items a
join items b
on a.order_id=b.order_id
where a.name!=b.name
and a.name<b.name;

