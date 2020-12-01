## 1. Create two or three queries using address table in sakila db:

- include postal_code in where (try with in/not it operator)
- eventually join the table with city/country tables.
- measure execution time.
- Then create an index for postal_code on address table.
- measure execution time again and compare with the previous ones.
- Explain the results

```sql
SELECT postal_code FROM address
WHERE address.postal_code IN (
  SELECT postal_code FROM address
  INNER JOIN city USING (city_id)
  INNER JOIN country USING (country_id)
  WHERE country.country = 'Argentina');
```

_Execution time: 5ms_

```sql
SELECT postal_code FROM address
WHERE address.postal_code NOT IN (
  SELECT postal_code FROM address
  INNER JOIN city USING (city_id)
  INNER JOIN country USING (country_id)
  WHERE country.country = 'United States');
```

_Execution time: 11ms_

```sql
CREATE INDEX postal_code ON address (postal_code);
```

### _Execution time were reduced, indexes speed up queries :sparkles:_

## 2. Run queries using actor table, searching for first and last name columns independently. Explain the \* differences and why is that happening?

```sql
SELECT actor.first_name, COUNT(*) FROM film
INNER JOIN film_actor USING (film_id)
INNER JOIN actor USING (actor_id)
WHERE actor.first_name LIKE 'B%'
GROUP BY actor.first_name;

SELECT actor.last_name, COUNT(*) FROM film
INNER JOIN film_actor USING (film_id)
INNER JOIN actor USING (actor_id)
WHERE actor.last_name LIKE 'B%'
GROUP BY actor.last_name;
```

### _The second query is faster because actor has a B-tree index on last_name_

## 3. Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.

```sql
SELECT description FROM film WHERE description LIKE '%dog%';

ALTER TABLE film_text ADD FULLTEXT (description);

SELECT description FROM film_text WHERE MATCH(description) AGAINST('dog');
```

### _Queries using FULLTEXT index are faster than LIKE operator._
