#1. Find the films with less duration, show the title and rating.
SELECT title, rating FROM film
	WHERE length <= ALL (SELECT `length` FROM film);

#2. Write a query that returns the title of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
#UPDATE film SET length = 45 WHERE film_id = 182;
SELECT title FROM film f1
	WHERE `length` < ALL (SELECT `length` FROM film f2
							  WHERE f2.film_id <> f1.film_id);

#3. Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
SELECT DISTINCT customer.*, address.address, payment.amount as `lowest payment amount` FROM customer, payment, address
    WHERE customer.customer_id = payment.customer_id
    AND customer.address_id = address.address_id
    AND payment.amount <= ALL (SELECT amount FROM payment WHERE payment.customer_id = customer.customer_id);
    
SELECT DISTINCT customer.*, address.address, payment.amount as `lowest payment amount` FROM customer, payment, address
    WHERE customer.customer_id = payment.customer_id
    AND customer.address_id = address.address_id
    AND payment.amount = (SELECT MIN(amount) FROM payment WHERE payment.customer_id = customer.customer_id);
    
/*
SELECT DISTINCT customer.*, address.address, (SELECT MIN(amount) FROM payment WHERE payment.customer_id = customer.customer_id) as 'lowest payment amount' FROM customer, payment, address
    WHERE customer.customer_id = payment.customer_id
    AND customer.address_id = address.address_id;

SELECT customer.*, (SELECT MIN(amount) FROM payment WHERE payment.customer_id = customer.customer_id) AS `min amount` FROM customer
    ORDER BY `min amount` ASC;*/
    
#4. Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
 SELECT customer.*, MAX(amount) as `highest payment`, MIN(amount) as `lowest payment` FROM customer, payment 
    WHERE customer.customer_id = payment.customer_id
    GROUP BY customer_id;