-- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- --
# Creating DataBase for zomato.
use zomato_db;
-- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- --
# Q1>  What are the top 10 restaurants by total sales amount?

Select restaurants.name,  sum(orders.sales_amount) AS total_sales from orders
JOIN 
	restaurants ON orders.r_id = restaurants.id
where orders.sales_amount Is Not Null
Group By restaurants.name
order by total_sales Desc
Limit 10;
-- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- --

# Q2 > What is the average rating and total rating count for restaurants in the top 20 cities?

select restaurants.city, concat(round(avg(rating),2) ,'/5') as avg_rating,  sum(rating_count) as total_rating_count from restaurants
Inner JOIN
	(select restaurants.city, count(city) as Total_restaurants from restaurants
Group By restaurants.city
order by total_restaurants DESC Limit 20) as top_cities    ON restaurants.city = top_cities.city
Group By restaurants.city ;
-- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- --

# Q3> What are the monthly order trends based on order volume over time?

Select 
year(orders.order_date) as order_year, month(orders.order_date) as order_month,
count(*) as Total_Orders 
From orders
where orders.order_date is not null
Group By year(orders.order_date), month(orders.order_date)
Order By year(orders.order_date),month(orders.order_date);

-- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- --
    
# 4 > What are the top 5 most popular cuisines by order volume?

select menu.cuisine, count(*) as order_count from orders 
Inner Join restaurants ON orders.r_id = restaurants.id
Inner Join menu ON restaurants.id= menu.restaurant_id
Group By menu.cuisine
order by order_count desc
Limit 5;

-- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- --

# 5 > What is the distribution of vegetarian vs non-vegetarian items ordered?

select food.veg_or_non_veg, count(*) as total_count from orders
inner join restaurants ON orders.r_id = restaurants.id
inner join menu ON restaurants.id = menu.restaurant_id
inner join food ON menu.food_id = food.f_id
where food.veg_or_non_veg is not null
Group By food.veg_or_non_veg
order by total_count DESC;

-- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- --

# Q6> What are the top 20 cities by the number of restaurants?
    
select restaurants.city,  count(restaurants.id) as restaurants_count from restaurants
Group By restaurants.city
Order By restaurants_count DESC
Limit 20;
-- -- -- ----------------------------------------------------------------------------------------------

# Q7 > How do different user demographics correlate with average order value?
SELECT
    users.gender,
    ROUND(AVG(orders.amount), 2) AS average_order_value
FROM orders
JOIN users
    ON orders.user_id = users.user_id
WHERE orders.amount IS NOT NULL
GROUP BY users.gender;
-- ---------------------------------------------------------------------------------------------------
-- Note: amount column is empty so instead, let's reframe this Question.
# Q8> Who are the top 15 highest-spending users?
-- Now QUE: “Who are the most active users by number of orders?”
select user_id, count(*) as no_of_orders from orders
where user_id is not null
group by user_id
order by no_of_orders DESC
Limit 15;

-- --------------------------------------------------------------------------------
# Q9> What are the top 15 cuisines with the highest average menu prices?
select menu.cuisine as cuisine_names, round(avg(menu.price),2) as avg_menu_price from menu
where menu.price is not null
Group By menu.cuisine
order by avg_menu_price DESC
limit 15;

-- ---------------------------------------------------------------------------------------
# Q10> Which restaurants offer the most diverse menu, based on the number of unique cuisines and dishes available?

select restaurants.name as restaurant_name, 
count(Distinct menu.food_id) as total_food, 
count(distinct menu.cuisine) as total_cuisine
from menu
	JOIN restaurants ON menu.restaurant_id = restaurants.id
	Group By restaurants.id, restaurants.name
	order by total_food desc ,  total_cuisine desc;
    
-- ----------------------------------------------------------------------------

# Q11> What are the most ordered food items across all restaurants?

select food.item, 
count(*) as order_count from orders
Join restaurants ON orders.r_id = restaurants.id
Join menu ON restaurants.id = menu.restaurant_id
Join food ON menu.food_id = food.f_id
Group By food.item
Order By order_count DESC;

-- -----------------------------------------------------------------

# Q12 > How does spending behavior differ between genders?
SELECT
    users.gender,
    COUNT(*) AS total_orders
FROM orders
JOIN users
    ON orders.user_id = users.user_id
WHERE users.gender IS NOT NULL
GROUP BY users.gender
ORDER BY total_orders DESC;

-- ----------------- ----------------------------------------------------------------

# Q13 > On which days of the week do restaurants experience peak order volumes?
select  dayname(orders.order_date), count(*) as total_orders from orders
group by dayname(orders.order_date)
order by total_orders desc;
-- ----------- ----------------- ------------------ -------------------

# Q 14 > How does order frequency vary across different income groups?
SELECT
CASE
WHEN users.income < 300000 THEN 'Low Income'
WHEN users.income BETWEEN 300000 AND 700000 THEN 'Medium Income'
ELSE 'High Income'  END AS income_group,
    COUNT(*) AS total_orders
FROM orders
JOIN users ON orders.user_id = users.user_id
WHERE users.income IS NOT NULL
GROUP BY income_group
ORDER BY total_orders DESC;

-- ------ -- ----------- ----------------- ------------------ -------------------
													# ThankYou!


















