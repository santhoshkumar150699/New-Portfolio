# Pizza Sales Project

## Overview
The "Pizza Sales" project is designed to manage and analyze pizza sales data. It includes database schemas for Pizza_types, pizzas, orders, order_details, and inventory.

## Setup

1. **Install a Database System**:
   - Download and install [MySQL](https://dev.mysql.com/downloads/) or [PostgreSQL](https://www.postgresql.org/download/).

2. **Set Up the Database**:
   - Create a new database and execute the `schema.sql` script to create the required tables:
     ```bash
     mysql -u username -p database_name < schema.sql
     ```

3. **Insert Sample Data**:
   - Use the `queries.sql` script to insert sample data and test queries:
     ```bash
     mysql -u username -p database_name < queries.sql
     ```

## Files

- `schema.sql`: SQL script to create the database schema.
- `queries.sql`: SQL script containing sample data and queries.

## Queries

Basic:
Retrieve the total number of orders placed.
Calculate the total revenue generated from pizza sales.
Identify the highest-priced pizza.
Identify the most common pizza size ordered.
List the top 5 most ordered pizza types along with their quantities.


Intermediate:
Join the necessary tables to find the total quantity of each pizza category ordered.
Determine the distribution of orders by hour of the day.
Join relevant tables to find the category-wise distribution of pizzas.
Group the orders by date and calculate the average number of pizzas ordered per day.
Determine the top 3 most ordered pizza types based on revenue.

Advanced:
Calculate the percentage contribution of each pizza type to total revenue.
Analyze the cumulative revenue generated over time.
Determine the top 3 most ordered pizza types based on revenue for each pizza category.





