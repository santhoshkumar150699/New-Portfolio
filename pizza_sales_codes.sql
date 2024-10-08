create database pizza;
use  pizza;
select * from orders;
select * from pizza_types;
select * from order_details;
select * from pizzas;

/*
Basic:
Retrieve the total number of orders placed.
Calculate the total revenue generated from pizza sales.
Identify the highest-priced pizza.
Identify the most common pizza size ordered.
List the top 5 most ordered pizza types along with their quantities.

*/

-- 1. Retrieve the total number of orders placed.
select count(order_id) from orders where order_id is not null;

-- 2.Calculate the total revenue generated from pizza sales.
select sum(price) from pizzas;
select round(sum(o.quantity*p.price),2) as total_revenve_pizzasales from order_details as o join pizzas as p on o.pizza_id = p.pizza_id;

-- 3.Identify the highest-priced pizza.
select sum(price)from pizzas group by 1 order by 1 desc limit 1;

-- 4.Identify the most common pizza size ordered.
select count(o.order_id) as common_pizza_size_ordered,p.size from order_details as o join pizzas as p on o.pizza_id = p.pizza_id group by 2 order by 1 desc limit 1;

-- 5. List the top 5 most ordered pizza types along with their quantities.

select sum(o.quantity) as most_quantity,p.pizza_type_id from order_details as o join pizzas as p on o.pizza_id = p.pizza_id group by 2 order by 1 desc limit 5 ;


/* 
Advanced:
Calculate the percentage contribution of each pizza type to total revenue.
Analyze the cumulative revenue generated over time.
Determine the top 3 most ordered pizza types based on revenue for each pizza category.
*/

-- 1.Calculate the percentage contribution of each pizza type to total revenue.

select (sum(o.order_id*p.price) / 
(select round(sum(o.quantity*p.price),2) as total_revenve_pizzasales 
from order_details as o join pizzas as p on o.pizza_id = p.pizza_id) * 100) as contribution
, pid.category 
from 
pizza_types as pid
 join
 pizzas as p 
 on 
 pid.pizza_type_id = p.pizza_type_id 
join
order_details as o 
on o.pizza_id = p.pizza_id group by 2;

ALTER TABLE orders CHANGE COLUMN date order_date date;
ALTER TABLE orders CHANGE COLUMN time order_time time;


-- 2.Analyze the cumulative revenue generated over time.

select order_date,
sum(rev) over (order by order_date desc) as cumulative
from
(select od.order_date,
sum(o.quantity*p.price) as rev
from
order_details as o 
join
pizzas as p
on
o.pizza_id = p.pizza_id
join
orders as od 
on 
od.order_id = o.order_id
group by 1) as sub;

-- 3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

with cte as (select rev,category,pizza_type_id ,rank() over (partition by category order by rev desc) as rk
from( select  round(sum(p.price*o.quantity),2) as rev ,pid.category,p.pizza_type_id
from 
pizza_types as pid
 join
 pizzas as p 
 on 
 pid.pizza_type_id = p.pizza_type_id 
join
order_details as o 
on o.pizza_id = p.pizza_id
group by 2,3  order by 1 desc) as sub )

select * from cte  where rk <= 3;

/*
Join the necessary tables to find the total quantity of each pizza category ordered.
Determine the distribution of orders by hour of the day.
Join relevant tables to find the category-wise distribution of pizzas.
Group the orders by date and calculate the average number of pizzas ordered per day.
Determine the top 3 most ordered pizza types based on revenue.

*/

-- 1. Join the necessary tables to find the total quantity of each pizza category ordered.

select sum(o.quantity),pid.category
from 
pizza_types as pid
 join
 pizzas as p 
 on 
 pid.pizza_type_id = p.pizza_type_id 
join
order_details as o 
on o.pizza_id = p.pizza_id
group by 2;

-- 2.Determine the distribution of orders by hour of the day.

select count(o.order_id) as total_pizaa,hour(order_time) as delivey_hours from
 orders as o
 join 
 order_details as od 
 on 
 o.order_id =od.order_id
 group by hour(order_time) ;
 
 -- 3. Join relevant tables to find the category-wise distribution of pizzas.
 select pt.category , count(name) as distribution_pizzas  from 
 pizza_types as pt
 join 
 pizzas as p on 
 pt.pizza_type_id = p.pizza_type_id
 group by 1;
 
 -- 4. Group the orders by date and calculate the average number of pizzas ordered per day.
with cte as (select sum(od.quantity) as total_order ,o.order_date
from orders as o 
join 
order_details as od 
on o.order_id = od.order_id 
group by 2)

select round(avg(total_order),2) average_pizza_order_perday from cte ;

-- 5. Determine the top 3 most ordered pizza types based on revenue.

select sum(od.quantity*p.price) , pt.name from
order_details as od 
join
pizzas as p on od.pizza_id  = p.pizza_id 
join 
pizza_types as pt 
on
pt.pizza_type_id =p.pizza_type_id
group by 2 order by 1 desc limit 3;