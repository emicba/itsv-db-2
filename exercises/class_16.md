```sql
CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);
```

## 1. Insert a new employee to , but with an null email. Explain what happens.

```sql
INSERT INTO sakila.employees
(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES(11, 'Smith', 'Alice', '1', NULL, '1', 1, 'SDEII');
```

### _Throws an error because email cannot be null._

## 2. Run the first the query

```sql
UPDATE employees SET employeeNumber = employeeNumber - 20
```

## What did happen? Explain. Then run this other:

```sql
UPDATE employees SET employeeNumber = employeeNumber + 20
```

### _Updates all employees rows adding or subtracting 20 on employeeNumber column._

## 3. Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.

```sql
ALTER TABLE employees ADD COLUMN  age int;

CREATE TRIGGER before_insert_employee_ages
BEFORE INSERT
ON employees FOR EACH ROW
BEGIN
  IF NOT NEW.AGE BETWEEN 17 AND 70 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'SQL Error: Employee\'s can have age between 17 and 70.';
  END IF;
END;
```

## 4. Describe the _referential integrity_ between tables film, actor and film_actor in sakila db.

### _film and actor have a many to many relationship, film can have one or more actors and vice versa. film_actor is the intersection table._

## 5. Create a new column called **lastUpdate** to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. **Bonus**: add a column **lastUpdateUser** and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL and change this table).

```sql
ALTER TABLE employees ADD COLUMN lastUpdate timestamp NULL DEFAULT NULL;
ALTER TABLE employees ADD COLUMN lastUpdateUser varchar(32);

CREATE TRIGGER insert_employee_last_update
BEFORE INSERT
ON employees FOR EACH ROW
BEGIN
  SET NEW.lastUpdate = CURRENT_TIMESTAMP();
END;

CREATE TRIGGER update_employee_last_update
BEFORE UPDATE
ON employees FOR EACH ROW
BEGIN
  SET NEW.lastUpdate = CURRENT_TIMESTAMP();
END;

CREATE TRIGGER insert_employee_last_update_user
BEFORE INSERT
ON employees FOR EACH ROW
BEGIN
  SET NEW.lastUpdateUser = USER();
END;

CREATE TRIGGER update_employee_last_update_user
BEFORE UPDATE
ON employees FOR EACH ROW
BEGIN
  SET NEW.lastUpdateUser = USER();
END;
```

## 6. Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.

```sql
CREATE DEFINER=`root`@`localhost` TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END
```

### _Inserts a row on film_text containing the film_id, title and description of the inserted row on film._

```sql
CREATE DEFINER=`root`@`localhost` TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END
```

### _Checks if the updated rows has a new title, description or film_id, if true then updates a row on film_text matching film_id._

```sql
CREATE DEFINER=`root`@`localhost` TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END
```

### _Deletes a row on film_text when a row was deleted on film matching film_id_
