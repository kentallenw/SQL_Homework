USE sakila;

# 1a. Display the first and last names of all actors from the table `actor`.

SELECT FIRST_NAME, LAST_NAME
FROM ACTOR;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT concat(FIRST_NAME, ' ' ,LAST_NAME) AS "Actor Name"
FROM ACTOR;

# * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
# What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters `GEN`:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, 
# in that order:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY first_name, last_name;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so 
# create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type 
#`BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD description BLOB;

# * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
# Delete the `description` column.
ALTER TABLE actor
DROP description;

# * 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(actor_id)
FROM actor
GROUP BY last_name;

# * 4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors
SELECT last_name, COUNT(actor_id)
AS total_last
FROM actor
GROUP BY last_name
HAVING total_last >=2

# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as 
# `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor
SET first_name = 'Harpo'
WHERE actor_id = '172';

# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` 
# was the correct name after all! In a single query, if the first name of the actor is currently 
# `HARPO`, change it to `GROUCHO`.
UPDATE actor
SET first_name = 'Groucho'
WHERE first_name = 'Harpo';

# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SELECT * FROM address;

# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
# Use the tables `staff` and `address`:
SELECT staff.first_name, staff.last_name, address.address
FROM  address
INNER JOIN staff ON
address.address_id=staff.address_id;


# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
# Use tables `staff` and `payment`.
SELECT staff.first_name, staff.last_name,  SUM(payment.amount) AS 'Total Amount'
FROM payment 
JOIN staff 
ON payment.staff_id = staff.staff_id
WHERE payment_date like '2005-08%'
GROUP BY  payment.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` 
# and `film`. Use inner join.
SELECT film.title, film_actor.actor_id
FROM film
INNER JOIN film_actor ON
film_actor.film_id=film.film_id;
# GROUP BY actor_id;

# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, (SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id ) AS 'Number of Copies'
FROM film
WHERE title = 'Hunchback Impossible';

# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each 
# customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, sum(p.amount) AS 'Total Amount Paid'
FROM payment AS p
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY  p.customer_id
ORDER BY c.last_name;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
# films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the 
# titles of movies starting with the letters `K` and `Q` whose language is English.

SELECT film.title, language.name
FROM film
INNER JOIN language ON
film.language_id = language.language_id
WHERE film.title LIKE 'Q%'
OR film.title LIKE 'A%'
AND language.name = 'English';

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select * 
from film
where title = 'Alone Trip';

select * from film_actor;

select * from actor;

select first_name, last_name
from actor
where actor_id in
( 
  select actor_id
  from film_actor
  where film_id in
  (
    select film_id 
    from film
    where title = 'Alone Trip'
  )
);

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email 
# addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address ON
customer.address_id=address.address_id
INNER JOIN city ON
address.city_id=city.city_id
WHERE country_id = 20;

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a 
# promotion. Identify all movies categorized as _family_ films.

SELECT film.film_id, film.title, category.name
FROM film
INNER JOIN film_category ON
film.film_id=film_category.film_id
INNER JOIN category ON
film_category.category_id=category.category_id
WHERE name = 'Family';


# 7e. Display the most frequently rented movies in descending order.
SELECT film.title, rental.rental_id
FROM film
INNER JOIN inventory ON
film.film_id=inventory.film_id
INNER JOIN rental ON
inventory.inventory_id=rental.inventory_id;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT staff.store_id, sum(payment.amount) AS 'Total Amount Paid'
FROM staff
INNER JOIN payment
ON staff.staff_id = payment.staff_id
INNER JOIN store
ON staff.store_id = store.store_id
GROUP BY store.store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id;

# 7h. List the top five genres in gross revenue in descending order. (**Hint**: you 
# may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, sum(payment.amount) AS 'Total Amount Paid'
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment 
ON rental.rental_id = payment.rental_id
GROUP BY category.name;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five 
#genres by gross revenue. Use the solution from the problem above to create a view. If you haven't 
# solved 7h, you can substitute another query to create a view.

SELECT category.name, sum(payment.amount) AS 'Total Amount Paid'
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment 
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY sum(payment.amount) DESC LIMIT 5;

# 8b. How would you display the view that you created in 8a?
SELECT category.name AS 'Top Genre', sum(payment.amount) AS 'Total Amount Paid by Top 5 Rank Genre'
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment 
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY sum(payment.amount) DESC LIMIT 5;

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DELETE FROM top_five_genres;






