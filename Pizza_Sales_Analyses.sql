
/*
SQL PROJECT- PIZZA SALES DATA ANALYSIS
*/

create database Pizza_Sales_Analyses;
use Pizza_Sales_Analyses;
select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

create table orders
( order_id int not null,
order_date date not null,
order_time time not null,
primary key (order_id)
);


/*
Basic
*/
/*
Q1) Retrieve the total number of orders placed.
*/
select count(order_id) AS Total_No_Of_Order from orders;

/*
Q2) Calculate the total revenue generated from pizza sales.
*/
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            0) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

/*
Q3) Identify the highest-priced pizza.
*/
SELECT 
    pizza_types.name, (pizzas.price) AS Total_Price
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY Total_Price DESC
LIMIT 1;

/*
Q4) Identify the most common pizza size ordered.
*/
SELECT 
    pizzas.size,
    (COUNT(order_details.order_details_id)) AS Total_Size
FROM
    pizzas
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY Total_Size DESC
LIMIT 1;

/*
Q5) List the top 5 most ordered pizza types along with their quantities.
*/
SELECT 
    pizza_types.name,
    (SUM(order_details.quantity)) AS Quantity_Ordered
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY Quantity_Ordered DESC
LIMIT 5;

/*
Intermediate
*/
/*
Q6) Join the necessary tables to find the 
total quantity of each pizza category ordered.
*/
SELECT 
    (SUM(order_details.quantity)) AS Total_Pizza_Category,
    pizza_types.category
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category
order by Total_Pizza_Category desc;


/*
Q7) Determine the distribution of orders by hour of the day.
*/
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS count_order
FROM
    orders
GROUP BY hour;

/*
Q8) Join relevant tables to find the category-wise 
distribution of pizzas.
*/
select category, count(name) as Name_count
from pizza_types
group by category;

/*
Q9) Group the orders by date and calculate the average number of pizzas ordered per day.
*/
SELECT 
    ROUND(AVG(Quantity_Ordered), 0) AS Avg_quantity
FROM
    (SELECT 
        (orders.order_date) AS Order_day,
            SUM(order_details.quantity) AS Quantity_Ordered
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY Order_day) AS Order_Quantity;
    
/*
Q10) Determine the top 3 most ordered pizza types based on revenue.
*/    
SELECT 
    pizza_types.name,
    ROUND(SUM(pizzas.price * order_details.quantity),
            0) AS Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3;
