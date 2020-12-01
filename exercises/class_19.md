## 1. Create a user data_analyst.

```sql
CREATE USER data_analyst IDENTIFIED BY '✨';
```

## 2. Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.

```sql
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst';
```

## 3. Login with this user and try to create a table. Show the result of that operation.

```sql
CREATE TABLE sakila.test (
  test_id int(10) NOT NULL,
  PRIMARY KEY (test_id)
);
```

`SQL Error [1142] [42000]: CREATE command denied to user 'data_analyst'@'172.17.0.1' for table 'test'`

## 4. Try to update a title of a film. Write the update script.

```sql
UPDATE sakila.film SET title='LOREM IPSUM' WHERE film.film_id = 1;
```

## 5. With root or any admin user revoke the UPDATE permission. Write the command.

```sql
REVOKE UPDATE ON sakila.* FROM 'data_analyst';
```

## 6. Login again with data_analyst and try again the update done in step 4. Show the result.

`SQL Error [1142] [42000]: UPDATE command denied to user 'data_analyst'@'172.17.0.1' for table 'film'`
