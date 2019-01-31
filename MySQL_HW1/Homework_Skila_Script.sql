-- Homework 01/2019
show databases;
use sakila;
-- 1a. Display the first and last names of all actors from the table actor.
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select * from actor;
describe actor;
select first_name, last_name from actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * from actor
WHERE last_name LIKE '%GEN%'
	OR first_name LIKE '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * from actor
WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select * from country;
select country_id, country 	from 	country 	where country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column
-- in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it
-- and VARCHAR are significant).
ALTER TABLE actor ADD column description BLOB;
select * from actor;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor  DROP column description;
SELECT * FROM actor;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
	last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least
-- two actors
SELECT 
	last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
SELECT* FROM actor WHERE last_name = 'WILLIAMS';
UPDATE actor
SET 
    first_name = 'HARPO'
WHERE
    last_name = 'WILLIAMS' 
    AND first_name = 'GROUCHO';
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In 
-- a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET 
    first_name = 'GRAUCHO'
WHERE
    last_name = 'WILLIAMS' 
    AND first_name = 'HARPO';
SELECT* FROM actor WHERE last_name = 'WILLIAMS';
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
use sakila;
DESCRIBE address;
SHOW CREATE TABLE address;
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    staff
        LEFT JOIN
    address ON staff.address_id = address.address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT * FROM payment;
SELECT * from payment LEFT JOIN staff ON payment.staff_id = staff.staff_id where staff.staff_id = 2;
SELECT 
	SUM(payment.amount), payment.staff_id
		FROM payment
			LEFT JOIN
	staff ON payment.staff_id = staff.staff_id 
    WHERE payment.payment_date like '%2005-08%'
    GROUP BY payment.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id)
		FROM film_actor
		INNER JOIN film ON film_actor.film_id = film.film_id
        GROUP BY film_actor.film_id;
 -- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title, COUNT(film.title)
		FROM film
		WHERE film.title='Hunchback Impossible';
        
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
use sakila;
select customer.last_name, customer.first_name, sum(payment.amount) as 'Total Payment'
	from  payment
    inner join customer on customer.customer_id = payment.customer_id
        group by payment.customer_id
        order by customer.last_name    ;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select film.title from film
where film.title like'K%' or film.title like 'Q%' 
and film.language_id in
(select  language_id from language
where name = "English");
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select last_name, first_name
	from actor
    where actor_id IN
(SELECT actor_id
    FROM film_actor
    WHERE film_id IN
(SELECT film_id
     FROM film
     WHERE title = 'Alone Trip'
   ) );
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select first_name, last_name, email from customer where address_id in
(select distinct address_id from address where city_id in
(select distinct city_id from city where country_id in
(select distinct country_id from country where country = 'Canada')) )  ;
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title from film where film_id in
(select film_id from film_category where category_id in
(select category_id  from category where name ='Family'));
-- 7e. Display the most frequently rented movies in descending order.
select film.title as 'Title' , count(rental.rental_date) as 'Count' from rental, inventory, film
where rental.inventory_id = inventory.inventory_id and inventory.film_id = film.film_id
group by film.film_id
order by Count desc ;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
select sum(amount), inventory.store_id from inventory, rental, payment
where inventory.inventory_id =rental.inventory_id and rental.customer_id = payment.customer_id  
group by inventory.store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country 
	from store, city, country, address
    where store.address_id = address.address_id 
    and address.city_id = city.city_id
    and city.country_id = country.country_id;
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables:
--  category, film_category, inventory, payment, and rental.)
select sum(payment.amount) as 'Amount', category.name 
	from category, film_category, inventory, payment, rental
	where category.category_id = film_category.category_id 
	and film_category.film_id = inventory.film_id
	and inventory.inventory_id = rental.inventory_id
	and rental.rental_id = payment.rental_id
	group by category.category_id
	order by Amount desc
	limit 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW V_top_five_genres AS 
	select sum(payment.amount) as 'Amount', category.name 
		from category, film_category, inventory, payment, rental
		where category.category_id = film_category.category_id 
		and film_category.film_id = inventory.film_id
		and inventory.inventory_id = rental.inventory_id
		and rental.rental_id = payment.rental_id
		group by category.category_id
		order by Amount desc
		limit 5;
-- 8b. How would you display the view that you created in 8a?
select * from V_top_five_genres;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view V_top_five_genres;