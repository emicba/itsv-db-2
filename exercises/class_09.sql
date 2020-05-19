#1. Get the amount of cities per country in the database. Sort them by country, country_id.
SELECT country.country, COUNT(*) AS `# of cities` FROM city
    INNER JOIN country ON city.country_id = country.country_id
    GROUP BY country.country_id 
    ORDER BY country.country, country.country_id;

#2. Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest.
SELECT country.country, COUNT(*) AS `# of cities` FROM city
    INNER JOIN country ON city.country_id = country.country_id
    GROUP BY country.country_id
    HAVING COUNT(*) > 10
    ORDER BY COUNT(*) DESC;
    
#3. Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films. Show the ones who spent more money first.
SELECT first_name, last_name, address, COUNT(*) AS `# of films rented`, (SELECT SUM(amount) FROM payment WHERE payment.customer_id = customer.customer_id) AS `Total money spent`
    FROM customer, address, rental 
    WHERE customer.address_id = address.address_id
    AND customer.customer_id = rental.customer_id
    GROUP BY rental.customer_id
    ORDER BY `Total money spent` DESC;

#4. Which film categories have the larger film duration (comparing average)? Order by average in descending order.
SELECT category.name, AVG(`length`) as `Average` FROM film, film_category, category 
    WHERE film.film_id = film_category.film_id
    AND film_category.category_id = category.category_id
    GROUP BY film_category.category_id
    HAVING AVG(`length`) > (SELECT AVG(`length`) FROM film)
    ORDER BY `Average` DESC;