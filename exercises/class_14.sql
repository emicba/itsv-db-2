/* 1.
Write a query that gets all the customers that live in Argentina.
Show the first and last name in one column, the address and the city.*/
SELECT CONCAT_WS(' ', first_name, last_name) as 'full_name', address.address, city.city FROM customer
	INNER JOIN address USING (address_id)
	INNER JOIN city USING (city_id)
	INNER JOIN country USING (country_id)
	WHERE country = 'Argentina';

/* 2.
Write a query that shows the film title, language and rating.
Rating shall be shown as the full text described here:
https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case. */
SELECT title, `language`.name, 
CASE
	WHEN rating = 'PG' THEN '(Parental Guidance Suggested) � Some material may not be suitable for children'
	WHEN rating = 'G' THEN '(General Audiences) � All ages admitted'
	WHEN rating = 'NC-17' THEN ' (Adults Only) � No one 17 and under admitted'
	WHEN rating = 'PG-13' THEN '(Parents Strongly Cautioned) � Some material may be inappropriate for children under 13'
	WHEN rating = 'R' THEN '(Restricted) � Under 17 requires accompanying parent or adult guardian'
END AS `rating`
FROM film
INNER JOIN `language` USING (language_id);

/* 3.
Write a search query that shows all the films (title and release year) an actor was part of.
Assume the actor comes from a text box introduced by hand from a web page.
Make sure to "adjust" the input text to try to find the films as effectively as you think is possible. */
SELECT title, release_year, CONCAT_WS(' ', first_name, last_name) AS `full_name` FROM film
	INNER JOIN film_actor USING (film_id)
	INNER JOIN actor USING (actor_id)
	WHERE actor_id IN (SELECT actor_id FROM actor WHERE CONCAT_WS(' ', first_name, last_name) REGEXP UPPER('^(penelope guiness)'));

/* 4.
Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not.
There should be returned column with two possible values 'Yes' and 'No'. */
SELECT film.title, CONCAT_WS(' ', customer.first_name, customer.last_name) AS `full_name`,
CASE WHEN return_date IS NOT NULL THEN 'Yes' ELSE 'No' END AS `returned` FROM rental
	INNER JOIN customer USING (customer_id)
	INNER JOIN inventory USING (inventory_id)
	INNER JOIN film USING (film_id)
	WHERE MONTH(rental_date) IN (5, 6);

SELECT film.title, CONCAT_WS(' ', customer.first_name, customer.last_name) AS `full_name`,
CASE WHEN ISNULL(rental_date) THEN 'No' ELSE 'Yes' END AS `returned` FROM rental
	INNER JOIN customer USING (customer_id)
	INNER JOIN inventory USING (inventory_id)
	INNER JOIN film USING (film_id)
	WHERE MONTH(rental_date) IN (5, 6);
	
/* 5.
Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB. 

Example: Show the creation date of customers */
SELECT CAST(create_date AS DATE), create_date FROM customer;

/* 6.
Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do, 
which ones are not in MySql and write usage examples. 

NVL() available on Oracle. Returns true if the expression is null, otherwise returns false.
ISNULL() is available on SQL Server. Returns the expression if isn't null, otherwise the alternative.

IFNULL(expression, alternative) returns the alternative value if the expression is null.
Example: 
SELECT title, description, language_id, IFNULL(original_language_id, language_id) AS `original_language_id` FROM film;

COALESCE(...list) returns the first value that isn't null in a list.
Example:
SELECT COALESCE(NULL, 1, 'HI THERE'); will return 1 */