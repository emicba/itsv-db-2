#1. Find all the film titles that are not in the inventory.
SELECT film.title FROM film
	LEFT JOIN inventory USING (film_id)
	WHERE inventory_id IS NULL;

#2. Find all the films that are in the inventory but were never rented.
#Show title and inventory_id.
#This exercise is complicated.
#hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null
SELECT film.title, inventory.inventory_id FROM film
	INNER JOIN inventory USING (film_id)       
	LEFT JOIN rental USING (inventory_id)
	WHERE rental.rental_id IS NULL;
	
#3. Generate a report with:
#    * customer (first, last) name, store id, film title,
#    * when the film was rented and returned for each of these customers
#    * order by store_id, customer last_name
SELECT CONCAT(customer.first_name, ' ', customer.last_name) as name, store.store_id, film.title FROM rental
	INNER JOIN customer USING (customer_id)
	INNER JOIN inventory USING (inventory_id)
	INNER JOIN store ON inventory.store_id = store.store_id
	INNER JOIN film USING (film_id)
	WHERE rental.return_date IS NOT NULL
	ORDER BY store.store_id, customer.last_name;
	
#4. Show sales per store (money of rented films)
#show store's city, country, manager info and total sales (money)
#(optional) Use concat to show city and country and manager first and last name
SELECT store.store_id, SUM(payment.amount) AS `money`, CONCAT(city.city, ', ', country.country) AS `city, country`, CONCAT(staff.first_name, ', ', staff.last_name) AS `manager` FROM payment
	INNER JOIN staff USING (staff_id)
	INNER JOIN store USING (store_id)
	INNER JOIN address ON store.address_id = address.address_id
	INNER JOIN city USING (city_id)
	INNER JOIN country USING (country_id)
	GROUP BY store.store_id, `city, country`, manager;
	
#5. Which actor has appeared in the most films?
SELECT actor.*, COUNT(*) AS `# of films` FROM film_actor
	INNER JOIN actor USING (actor_id)
	GROUP BY actor_id
	HAVING `# of films` = (SELECT MAX(`count`) FROM (SELECT COUNT(*) AS `count` FROM film_actor GROUP BY actor_id) `counted`);