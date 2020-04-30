#1. List all the actors that share the last name. Show them in order
SELECT * FROM actor a1 
	WHERE EXISTS (SELECT first_name, last_name  FROM actor a2 
				      WHERE a1.last_name = a2.last_name 
					  AND a1.actor_id <> a2.actor_id) 
	ORDER BY last_name;
	
#2. Find actors that don't work in any film
SELECT * FROM actor WHERE actor_id NOT IN (SELECT DISTINCT actor_id FROM film_actor);

#3. Find customers that rented only one film
SELECT * FROM customer
	WHERE (SELECT count(*) FROM rental WHERE rental.customer_id = customer.customer_id) = 1;

#4. Find customers that rented more than one film
SELECT * FROM customer
	WHERE (SELECT count(*) FROM rental WHERE rental.customer_id = customer.customer_id) > 1;

#5. List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'			     
SELECT * FROM actor
    WHERE actor_id IN (SELECT actor_id FROM film_actor
                           WHERE film_id IN (SELECT film_id FROM film
                                                 WHERE title IN ('BETRAYED REAR', 'CATCH AMISTAD')));
					   					        
#6. List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
SELECT * from actor
	WHERE actor_id IN (SELECT actor_id FROM film_actor
					       WHERE film_id = (SELECT film_id FROM film WHERE title = 'BETRAYED REAR')
	AND actor_id NOT IN (SELECT actor_id FROM film_actor
					         WHERE film_id = (SELECT film_id FROM film WHERE title = 'CATCH AMISTAD')));
					     
#7. List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'					     
SELECT * from actor
	WHERE actor_id IN (SELECT actor_id FROM film_actor
					       WHERE film_id = (SELECT film_id FROM film WHERE title = 'BETRAYED REAR')
	AND actor_id IN (SELECT actor_id FROM film_actor
					     WHERE film_id = (SELECT film_id FROM film WHERE title = 'CATCH AMISTAD')));
					      
#8. List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
SELECT * FROM actor
	WHERE actor_id NOT IN (SELECT actor_id FROM film_actor
							   WHERE film_id = (SELECT film_id FROM film WHERE title = 'BETRAYED REAR'))
	AND actor_id NOT IN (SELECT actor_id FROM film_actor
							 WHERE film_id = (SELECT film_id FROM film WHERE title = 'CATCH AMISTAD'));
