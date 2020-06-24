/*1. Add a new customer
To store 1
For address use an existing address. The one that has the biggest address_id in 'United States'*/
INSERT INTO customer
	(store_id, first_name, last_name, email, address_id, active, create_date, last_update)
	SELECT 1, 'ALICE', 'SMITH', 'test@domain.com', MAX(address_id), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM address
		INNER JOIN city USING (city_id)
		INNER JOIN country USING (country_id)
		WHERE country = 'United States';

/*2. Add a rental
Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
Select any staff_id from Store 2.*/
INSERT INTO rental
	(rental_date, inventory_id, customer_id, staff_id)
	SELECT CURRENT_TIMESTAMP, MAX(inventory_id), 1, (SELECT MAX(staff_id) FROM staff WHERE store_id = inventory.store_id) FROM inventory
		INNER JOIN film USING (film_id)
		WHERE film.title = 'ACADEMY DINOSAUR'
		AND store_id = 2;		

/*3. Update film year based on the rating
For example if rating is 'G' release date will be '2001'
You can choose the mapping between rating and year.
Write as many statements are needed.*/
UPDATE film 
	SET release_year = (CASE
							WHEN rating = 'PG' THEN 2001
							WHEN rating = 'G' THEN 2002
							WHEN rating = 'NC-17' THEN 2003
							WHEN rating = 'PG-13' THEN 2004
							WHEN rating = 'R' THEN 2005
							ELSE release_year
						END)
	WHERE rating IN ('PG', 'G', 'NC-17', 'PG-13', 'R');
					
/*4. Return a film
Write the necessary statements and queries for the following steps.
Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
Use the id to return the film.*/
UPDATE rental 
	SET return_date = CURRENT_TIMESTAMP
	WHERE rental_id = (SELECT * FROM (SELECT max(rental_id) FROM rental WHERE return_date IS NULL) rental);

/*5. Try to delete a film
Check what happens, describe what to do.
Write all the necessary delete statements to entirely remove the film from the DB.*/
DELETE FROM film_actor
	WHERE film_id = 2;

DELETE FROM film_category
	WHERE film_id = 2;

DELETE FROM rental
	WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = 2);

DELETE FROM inventory
	WHERE film_id = 2;

DELETE FROM film
	WHERE film_id = 2;

/*6. Rent a film
Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
Add a rental entry
Add a payment entry
Use sub-queries for everything, except for the inventory id that can be used directly in the queries.*/
INSERT INTO rental
	(rental_date, inventory_id, customer_id, staff_id, last_update)
	SELECT CURRENT_TIMESTAMP, MAX(inventory_id), MAX(customer.customer_id), MAX(staff.staff_id), CURRENT_TIMESTAMP FROM inventory
		LEFT JOIN rental USING (inventory_id)
		INNER JOIN store USING (store_id)
		INNER JOIN staff ON staff.staff_id = store.manager_staff_id
		INNER JOIN customer ON customer.store_id = store.store_id
		WHERE rental_id IS NULL;
		
INSERT INTO payment
	(customer_id, staff_id, rental_id, amount, payment_date, last_update)
	SELECT customer_id, staff_id, rental_id, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM rental
		WHERE rental_id = (SELECT MAX(rental_id) FROM rental);