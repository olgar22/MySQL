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