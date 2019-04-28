-- 1A;
USE sakila;
SELECT * FROM actor;
SELECT first_name, last_name FROM actor;
-- 1B;
ALTER TABLE actor ADD Actor_Name VARCHAR(50);
SET SQL_SAFE_UPDATES = 0;
UPDATE actor SET Actor_Name = CONCAT(first_name,' ', last_name);
-- 1C;
SELECT * FROM actor;
SET SQL_SAFE_UPDATES = 1;

-- 2A;
SELECT * FROM actor
WHERE first_name = 'JOE';

-- 2B;
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- 2C;
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2D;
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh','China');

-- 3A;
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE actor ADD description BLOB;
-- UPDATE actor SET Actor_Name = CONCAT(first_name,' ', last_name);

-- 3B;
ALTER TABLE actor
DROP description;

ALTER TABLE actor
DROP combined;

-- 4A;
SELECT last_name, COUNT(*) AS 'COUNT'
FROM actor
GROUP BY last_name;

-- 4B;
SELECT last_name, COUNT(*) AS 'COUNT'
FROM actor
GROUP BY last_name 
HAVING COUNT> 2;

-- 4C;
UPDATE actor
SET first_name ='HARPO'
WHERE first_name='GROUCHO' AND last_name = 'WILLIAMS';
-- SELECT first_name FROM actor;
-- 4D;
UPDATE actor 
SET first_name= 'GROUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';

-- 5A;
DESCRIBE sakila.address;

-- 6A;
SELECT staff.first_name, staff.last_name
FROM staff
LEFT JOIN address
ON staff.address_id = address.address_id;

-- 6B;
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS 'TOTAL'
FROM staff LEFT JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY staff.first_name, staff.last_name;

-- 6C;
SELECT film.title, COUNT(film_actor.actor_id) AS 'TOTAL'
FROM film INNER JOIN film_actor 
ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6D;
SELECT title, COUNT(inventory_id)
FROM film 
INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible";

SELECT last_name, first_name, SUM(amount)
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY last_name;
-- 7A;
SELECT * FROM film
WHERE (title LIKE '%K%' OR title LIKE '%Q%')
AND language_id=(SELECT language_id FROM language where name='English');

-- 7B;
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
Select actor_id
FROM film_actor
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));
-- 7C
SELECT cus.first_name, cus.last_name, cus.email 
FROM customer cus
JOIN address a 
ON (cus.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';

-- 7D;
SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));

-- 7E;
SELECT film.title, COUNT(rental_id) AS 'Times Rented'
FROM rental 
JOIN inventory 
ON (rental.inventory_id = inventory.inventory_id)
JOIN film 
ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY `Times Rented` DESC;

-- 7F;
SELECT store.store_id, SUM(amount) AS 'Revenue'
FROM payment 
JOIN rental 
ON (payment.rental_id = rental.rental_id)
JOIN inventory 
ON (inventory.inventory_id = rental.inventory_id)
JOIN store 
ON (store.store_id = inventory.store_id)
GROUP BY store.store_id;

-- 7G
SELECT store.store_id, city.city, country.country 
FROM store 
JOIN address 
ON (store.address_id = address.address_id)
JOIN city 
ON (city.city_id = address.city_id)
JOIN country
ON (country.country_id = city.country_id);

-- 7H;
SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Gross' 
FROM category 
JOIN film_category 
ON (category.category_id=film_category.category_id)
JOIN inventory 
ON (film_category.film_id=inventory.film_id)
JOIN rental 
ON (inventory.inventory_id=rental.inventory_id)
JOIN payment 
ON (rental.rental_id=payment.rental_id)
GROUP BY category.name ORDER BY Gross  LIMIT 5;

-- 8A;
CREATE VIEW genre_revenue AS
SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Gross' 
FROM category 
JOIN film_category
ON (category.category_id=film_category.category_id)
JOIN inventory
ON (film_category.film_id=inventory.film_id)
JOIN rental 
ON (inventory.inventory_id=rental.inventory_id)
JOIN payment 
ON (rental.rental_id=payment.rental_id)
GROUP BY category.name ORDER BY Gross  LIMIT 5;

-- 8B;
SELECT * FROM genre_revenue;

-- 8C;
DROP VIEW genre_revenue;






