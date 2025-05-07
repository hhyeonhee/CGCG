==========================================
1장 배경
Mysql> SELECT name
     FROM corporation
     WHERE corp_id = 27;

SELECT t.txn_id, t.txn_type_cd, t.txn_date, t.amount
FROM individual i
  INNER JOIN account a ON i.cust_id = a.cust_id
  INNER JOIN product p ON p.product_cd = a.product_cd
  INNER JOIN transaction t ON t.account_id = a.account_id
WHERE i.fname = 'George' AND i.lname = 'Blake'
  AND p.name = 'checking account';

==========================================
2장 데이터베이스 생성과 데이터 추가
mysql -u root -p; 

mysql> show databases;

mysql> use sakila;

mysql -u root -p sakila;

mysql> SELECT now();

mysql> SELECT now()
          FROM dual;

mysql> SHOW CHARACTER SET;

mysql> CREATE TABLE person
      (person_id SMALLINT UNSIGNED,
       fname VARCHAR(20),
       lname VARCHAR(20),
       eye_color ENUM('BR','BL','GR'),
       birth_date DATE,
       street VARCHAR(30),
       city VARCHAR(20),
       state VARCHAR(20),
       country VARCHAR(20),
       postal_code VARCHAR(20),
       CONSTRAINT pk_person PRIMARY KEY (person_id)
      );

mysql>  CREATE TABLE favorite_food
      (person_id SMALLINT UNSIGNED,
      food VARCHAR(20),
      CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
      CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id)
      REFERENCES person (person_id)
      );
mysql> desc favorite_food;

mysql> DESC person;

mysql> INSERT INTO person
       (person_id, fname, lname, eye_color, birth_date)
     VALUES (null, 'William','Turner', 'BR', '1972-05-27');

mysql> SELECT person_id, fname, lname, birth_date
     FROM person;

mysql> SELECT person_id, fname, lname, birth_date
     FROM person
     WHERE person_id = 1;

mysql> SELECT person_id, fname, lname, birth_date
     FROM person
     WHERE lname = 'Turner';

mysql> INSERT INTO favorite_food (person_id, food)
     VALUES (1, 'pizza');

mysql> INSERT INTO favorite_food (person_id, food)
     VALUES (1, 'cookies');

mysql> INSERT INTO favorite_food (person_id, food)
     VALUES (1, 'nachos');

mysql> SELECT food
     FROM favorite_food
     WHERE person_id = 1
     ORDER BY food;

mysql> INSERT INTO person
     (person_id, fname, lname, eye_color, birth_date,
     street, city, state, country, postal_code)
     VALUES (null, 'Susan','Smith', 'BL', '1975-11-02',
      '23 Maple St.', 'Arlington', 'VA', 'USA', '20220');

mysql> SELECT person_id, fname, lname, birth_date
     FROM person;

Mysql> SELECT * FROM favorite_food;

mysql> UPDATE person
     SET street = '1225 Tremont St.',
       city = 'Boston',
       state = 'MA',
       country = 'USA',
       postal_code = '02138'
     WHERE person_id = 1;

mysql> DELETE FROM person
     WHERE person_id = 2;

mysql> INSERT INTO person
      (person_id, fname, lname, eye_color, birth_date)
     VALUES (1, 'Charles','Fulton', 'GR', '1968-01-15');

mysql> INSERT INTO favorite_food (person_id, food)
     VALUES (999, 'lasagna');

mysql> UPDATE person
     SET eye_color = 'ZZ'
     WHERE person_id = 1;

mysql> UPDATE person
     SET birth_date = 'DEC-21-1980'
     WHERE person_id = 1;

mysql> UPDATE person
     SET birth_date = str_to_date('DEC-21-1980' , '%b-%d-%Y')
     WHERE person_id = 1;


mysql> show tables;

mysql> DROP TABLE favorite_food;

mysql> DROP TABLE person;

mysql> desc customer;

==========================================
3장 쿼리 입문
mysql> SELECT first_name, last_name
     FROM customer
     WHERE last_name = 'ZIEGLER';

mysql> SELECT *
     FROM category;

mysql> SELECT *
     FROM language;

mysql> SELECT language_id, name, last_update
     FROM language;

mysql> SELECT name
     FROM language;

mysql> SELECT language_id,
       'COMMON' language_usage,
       language_id * 3.1415927 lang_pi_value,
       upper(name) language_name
     FROM language;

mysql> SELECT version(),
       user(),
       database();

mysql> SELECT language_id,
       'COMMON' language_usage,
       language_id * 3.1415927 lang_pi_value,
       upper(name) language_name
     FROM language;

mysql> SELECT language_id,
       'COMMON' AS language_usage,
       language_id * 3.1415927 AS lang_pi_value,
       upper(name) AS language_name
     FROM language;

mysql> SELECT actor_id FROM film_actor ORDER BY actor_id;

mysql> SELECT DISTINCT actor_id FROM film_actor ORDER BY actor_id;

mysql> SELECT concat(cust.last_name, ', ', cust.first_name) full_name
     FROM
      (SELECT first_name, last_name, email
       FROM customer
       WHERE first_name = 'JESSIE'
      ) cust;

mysql> CREATE TEMPORARY TABLE actors_j
      (actor_id smallint(5),
       first_name varchar(45),
       last_name varchar(45)
      );

mysql> INSERT INTO actors_j
     SELECT actor_id, first_name, last_name
     FROM actor
     WHERE last_name LIKE 'J%';

mysql> SELECT * FROM actors_j;

mysql> CREATE VIEW cust_vw AS
     SELECT customer_id, first_name, last_name, active
     FROM customer;

mysql> SELECT first_name, last_name
     FROM cust_vw
     WHERE active = 0;

mysql> SELECT customer.first_name, customer.last_name,
       time(rental.rental_date) rental_time
     FROM customer
       INNER JOIN rental
       ON customer.customer_id = rental.customer_id
     WHERE date(rental.rental_date) = '2005-06-14';

mysql> SELECT title
     FROM film
     WHERE rating = 'G' AND rental_duration >= 7;

mysql> SELECT title
     FROM film
     WHERE rating = 'G' OR rental_duration >= 7;

mysql> SELECT title, rating, rental_duration
     FROM film
     WHERE (rating = 'G' AND rental_duration >= 7)
       OR (rating = 'PG-13' AND rental_duration < 4);

mysql> SELECT c.first_name, c.last_name, count(*)
     FROM customer c
       INNER JOIN rental r
       ON c.customer_id = r.customer_id
     GROUP BY c.first_name, c.last_name
     HAVING count(*) >= 40;

mysql> SELECT c.first_name, c.last_name,
       time(r.rental_date) rental_time
     FROM customer c
       INNER JOIN rental r
       ON c.customer_id = r.customer_id
     WHERE date(r.rental_date) = '2005-06-14';

mysql> SELECT c.first_name, c.last_name,
       time(r.rental_date) rental_time
     FROM customer c
       INNER JOIN rental r
       ON c.customer_id = r.customer_id
     WHERE date(r.rental_date) = '2005-06-14'
     ORDER BY c.last_name;

mysql> SELECT c.first_name, c.last_name,
       time(r.rental_date) rental_time
     FROM customer c
       INNER JOIN rental r
       ON c.customer_id = r.customer_id
     WHERE date(r.rental_date) = '2005-06-14'
     ORDER BY c.last_name, c.first_name;

mysql> SELECT c.first_name, c.last_name,
       time(r.rental_date) rental_time
     FROM customer c
       INNER JOIN rental r
       ON c.customer_id = r.customer_id
     WHERE date(r.rental_date) = '2005-06-14'
     ORDER BY time(r.rental_date) desc;

mysql> SELECT c.first_name, c.last_name,
       time(r.rental_date) rental_time
     FROM customer c
       INNER JOIN rental r
       ON c.customer_id = r.customer_id
     WHERE date(r.rental_date) = '2005-06-14'
     ORDER BY 3 desc;

mysql> SELECT c.email, r.return_date
     FROM customer c
       INNER JOIN rental <1>
       ON c.customer_id = <2>
     WHERE date(r.rental_date) = '2005-06-14'
     ORDER BY <3> <4>;

========================================== 
4장 필터링
mysql> SELECT c.email
     FROM customer c
       INNER JOIN rental r
       ON c.customer_id = r.customer_id
     WHERE date(r.rental_date) = '2005-06-14';

mysql> SELECT c.email
     FROM customer c
       INNER JOIN rental r
       ON c.customer_id = r.customer_id
     WHERE date(r.rental_date) <> '2005-06-14';

mysql> SELECT customer_id, rental_date
     FROM rental
     WHERE rental_date < '2005-05-25';

mysql> SELECT customer_id, rental_date
     FROM rental
     WHERE rental_date <= '2005-06-16'
       AND rental_date >= '2005-06-14';

mysql> SELECT customer_id, rental_date
     FROM rental
     WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';

mysql> SELECT customer_id, rental_date
     FROM rental
     WHERE rental_date BETWEEN '2005-06-16' AND '2005-06-14';

SELECT customer_id, rental_date
     FROM rental
     WHERE rental_date >= '2005-06-16' 
       AND rental_date <= '2005-06-14'

mysql> SELECT customer_id, payment_date, amount
     FROM payment
     WHERE amount BETWEEN 10.0 AND 11.99;

mysql> SELECT last_name, first_name
     FROM customer
     WHERE last_name BETWEEN 'FA' AND 'FR';

mysql> SELECT last_name, first_name
     FROM customer
     WHERE last_name BETWEEN 'FA' AND 'FRB';

mysql> SELECT title, rating
     FROM film
     WHERE rating = 'G' OR rating = 'PG';

mysql> SELECT title, rating
     FROM film
     WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');

mysql> SELECT last_name, first_name
     FROM customer
     WHERE left(last_name, 1) = 'Q';

mysql> SELECT last_name, first_name
     FROM customer
     WHERE last_name LIKE '_A_T%S';

mysql> SELECT last_name, first_name
     FROM customer
     WHERE last_name LIKE 'Q%' OR last_name LIKE 'Y%';

mysql> SELECT last_name, first_name
     FROM customer
     WHERE last_name REGEXP '^[QY]';

mysql> SELECT rental_id, customer_id
     FROM rental
     WHERE return_date IS NULL;

mysql> SELECT rental_id, customer_id
     FROM rental
     WHERE return_date = NULL;

mysql> SELECT rental_id, customer_id, return_date
     FROM rental
     WHERE return_date IS NOT NULL;

mysql> SELECT rental_id, customer_id, return_date
     FROM rental
     WHERE return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

mysql> SELECT rental_id, customer_id, return_date
     FROM rental
     WHERE return_date IS NULL
       OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

========================================== 
5장 다중 테이블 쿼리
mysql> desc customer;

mysql> desc address;

mysql> SELECT c.first_name, c.last_name, a.address
     FROM customer c JOIN address a;

mysql> SELECT c.first_name, c.last_name, a.address
     FROM customer c JOIN address a
       ON c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
FROM customer c INNER JOIN address a
  USING (address_id);

mysql> SELECT c.first_name, c.last_name, a.address
     FROM customer c, address a
     WHERE c.address_id = a.address_id;

mysql> SELECT c.first_name, c.last_name, a.address
     FROM customer c, address a
     WHERE c.address_id = a.address_id
       AND a.postal_code = 52137;

mysql> SELECT c.first_name, c.last_name, a.address
     FROM customer c INNER JOIN address a
       ON c.address_id = a.address_id
     WHERE a.postal_code = 52137;

mysql> desc address;

mysql> desc city;

mysql> SELECT c.first_name, c.last_name, ct.city
     FROM customer c
       INNER JOIN address a
       ON c.address_id = a.address_id
       INNER JOIN city ct
       ON a.city_id = ct.city_id;

mysql> SELECT c.first_name, c.last_name, addr.address, addr.city
     FROM customer c
       INNER JOIN
        (SELECT a.address_id, a.address, ct.city
         FROM address a
           INNER JOIN city ct
           ON a.city_id = ct.city_id
         WHERE a.district = 'California'
        ) addr
       ON c.address_id = addr.address_id;

mysql> SELECT a.address_id, a.address, ct.city
     FROM address a
       INNER JOIN city ct
       ON a.city_id = ct.city_id
     WHERE a.district = 'California';

mysql> SELECT f.title
     FROM film f
       INNER JOIN film_actor fa
       ON f.film_id = fa.film_id
       INNER JOIN actor a
       ON fa.actor_id = a.actor_id
     WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
         OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'));

mysql> SELECT f.title
      FROM film f
        INNER JOIN film_actor fa1
        ON f.film_id = fa1.film_id
        INNER JOIN actor a1
        ON fa1.actor_id = a1.actor_id
        INNER JOIN film_actor fa2
        ON f.film_id = fa2.film_id
        INNER JOIN actor a2
        ON fa2.actor_id = a2.actor_id
     WHERE (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
       AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH');

mysql> desc film;

mysql> SELECT f.title, f_prnt.title prequel
     FROM film f
       INNER JOIN film f_prnt
       ON f_prnt.film_id = f.prequel_film_id
     WHERE f.prequel_film_id IS NOT NULL;

mysql> SELECT c.first_name, c.last_name, a.address, ct.city
     FROM customer c
       INNER JOIN address <1>
       ON c.address_id = a.address_id
       INNER JOIN city ct
       ON a.city_id = <2>
     WHERE a.district = 'California';

========================================== 
6장 집합 연산자
mysql> desc customer;

mysql> desc city;

mysql> SELECT 1 num, 'abc' str
     UNION
     SELECT 9 num, 'xyz' str;

mysql> SELECT 'CUST' typ, c.first_name, c.last_name
     FROM customer c
     UNION ALL
     SELECT 'ACTR' typ, a.first_name, a.last_name
     FROM actor a;

mysql> SELECT 'ACTR' typ, a.first_name, a.last_name
     FROM actor a
     UNION ALL
     SELECT 'ACTR' typ, a.first_name, a.last_name
     FROM actor a;

mysql> SELECT c.first_name, c.last_name
     FROM customer c
     WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
     UNION ALL
     SELECT a.first_name, a.last_name
     FROM actor a
     WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

mysql> SELECT c.first_name, c.last_name
     FROM customer c
     WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
     UNION
     SELECT a.first_name, a.last_name
     FROM actor a
     WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'D%' AND c.last_name LIKE 'T%'
INTERSECT
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'D%' AND a.last_name LIKE 'T%';

SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
INTERSECT
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
EXCEPT
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

mysql> SELECT a.first_name fname, a.last_name lname
     FROM actor a
     WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
     UNION ALL
     SELECT c.first_name, c.last_name
     FROM customer c
     WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
     ORDER BY lname, fname;

mysql> SELECT a.first_name fname, a.last_name lname
     FROM actor a
     WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
     UNION ALL
     SELECT c.first_name, c.last_name
     FROM customer c
     WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
     ORDER BY last_name, first_name;

mysql> SELECT a.first_name, a.last_name
     FROM actor a
     WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
     UNION ALL
     SELECT a.first_name, a.last_name
     FROM actor a
     WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
     UNION
     SELECT c.first_name, c.last_name
     FROM customer c
     WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

mysql> SELECT a.first_name, a.last_name
     FROM actor a
     WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
     UNION
     SELECT a.first_name, a.last_name
     FROM actor a
     WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
     UNION ALL
     SELECT c.first_name, c.last_name
     FROM customer c
     WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION
(SELECT a.first_name, a.last_name
 FROM actor a
 WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
 UNION ALL
 SELECT c.first_name, c.last_name
 FROM customer c
 WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
)

==========================================
7장 데이터 생성, 조작과 변환
CREATE TABLE string_tbl
 (char_fld CHAR(30),
  vchar_fld VARCHAR(30),
  text_fld TEXT
 );

mysql> INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
     VALUES ('This is char data',
       'This is varchar data',
       'This is text data');

mysql> UPDATE string_tbl
     SET vchar_fld = 'This is a piece of extremely long varchar data';

mysql> SELECT @@session.sql_mode;

mysql> SET sql_mode='ansi';

mysql> SELECT @@session.sql_mode;

mysql> SHOW WARNINGS;

mysql> SELECT vchar_fld
     FROM string_tbl;

UPDATE string_tbl
SET text_fld = 'This string doesn't work';

mysql> UPDATE string_tbl
     SET text_fld = 'This string didn''t work, but it does now';

mysql> SELECT text_fld
     FROM string_tbl;

mysql> SELECT quote(text_fld)
     FROM string_tbl;

mysql> SELECT 'abcdefg', CHAR(97,98,99,100,101,102,103);

mysql> SELECT CHAR(128,129,130,131,132,133,134,135,136,137);

mysql> SELECT CHAR(138,139,140,141,142,143,144,145,146,147);

mysql> SELECT CHAR(148,149,150,151,152,153,154,155,156,157);

mysql> SELECT CHAR(158,159,160,161,162,163,164,165);

mysql> SELECT CONCAT('danke sch', CHAR(148), 'n');

mysql> SELECT ASCII('ö');

mysql> DELETE FROM string_tbl;

mysql> INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
     VALUES ('This string is 28 characters',
       'This string is 28 characters',
       'This string is 28 characters');

mysql> SELECT LENGTH(char_fld) char_length,
       LENGTH(vchar_fld) varchar_length,
       LENGTH(text_fld) text_length
     FROM string_tbl;

mysql> SELECT POSITION('characters' IN vchar_fld)
     FROM string_tbl;

mysql> SELECT LOCATE('is', vchar_fld, 5)
     FROM string_tbl;

mysql> DELETE FROM string_tbl;

mysql> INSERT INTO string_tbl(vchar_fld)
     VALUES ('abcd'),
            ('xyz'),
            ('QRSTUV'),
            ('qrstuv'),
            ('12345');

mysql> SELECT vchar_fld
     FROM string_tbl
     ORDER BY vchar_fld;

mysql> SELECT STRCMP('12345','12345') 12345_12345,
       STRCMP('abcd','xyz') abcd_xyz,
       STRCMP('abcd','QRSTUV') abcd_QRSTUV,
       STRCMP('qrstuv','QRSTUV') qrstuv_QRSTUV,
       STRCMP('12345','xyz') 12345_xyz,
       STRCMP('xyz','qrstuv') xyz_qrstuv;

mysql> SELECT name, name LIKE '%y' ends_in_y
     FROM category;

mysql> SELECT name, name REGEXP 'y$' ends_in_y
     FROM category;

mysql> DELETE FROM string_tbl;

mysql> INSERT INTO string_tbl (text_fld)
     VALUES ('This string was 29 characters');

mysql> UPDATE string_tbl
     SET text_fld = CONCAT(text_fld, ', but now it is longer');

mysql> SELECT text_fld
     FROM string_tbl;

mysql> SELECT concat(first_name, ' ', last_name,
       ' has been a customer since ', date(create_date)) cust_narrative
     FROM customer;

mysql> SELECT INSERT('goodbye world', 9, 0, 'cruel ') string;

mysql> SELECT INSERT('goodbye world', 1, 7, 'hello') string;

mysql> SELECT SUBSTRING('goodbye cruel world', 9, 5);

mysql> SELECT (37 * 59) / (78 - (8 * 6));

mysql> SELECT MOD(10,4);

mysql> SELECT MOD(22.75, 5);

mysql> SELECT POW(2,8);

mysql> SELECT POW(2,10) kilobyte, POW(2,20) megabyte,
       POW(2,30) gigabyte, POW(2,40) terabyte;

mysql> SELECT CEIL(72.445), FLOOR(72.445);

mysql> SELECT CEIL(72.000000001), FLOOR(72.999999999);

mysql> SELECT ROUND(72.49999), ROUND(72.5), ROUND(72.50001);

mysql> SELECT ROUND(72.0909, 1), ROUND(72.0909, 2), ROUND(72.0909, 3);

mysql> SELECT TRUNCATE(72.0909, 1), TRUNCATE(72.0909, 2),
       TRUNCATE(72.0909, 3);

mysql> SELECT ROUND(17, −1), TRUNCATE(17, −1);


mysql> SELECT account_id, SIGN(balance), ABS(balance)
     FROM account;

mysql> SELECT @@global.time_zone, @@session.time_zone;

mysql> SET time_zone = 'Europe/Zurich';

mysql> SELECT @@global.time_zone, @@session.time_zone;

mysql> SELECT CAST('2019-09-17 15:30:00' AS DATETIME);

mysql> SELECT CAST('2019-09-17' AS DATE) date_field,
       CAST('108:17:57' AS TIME) time_field;

mysql> SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP();

mysql> SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY);

mysql> SELECT LAST_DAY('2019-09-17');

mysql> SELECT DAYNAME('2019-09-18');

mysql> SELECT EXTRACT(YEAR FROM '2019-09-18 22:19:05');

mysql> SELECT DATEDIFF('2019-09-03', '2019-06-21');

mysql> SELECT DATEDIFF('2019-09-03 23:59:59', '2019-06-21 00:00:01');

mysql> SELECT DATEDIFF('2019-06-21', '2019-09-03');

mysql> SELECT CAST('1456328' AS SIGNED INTEGER);

mysql> SELECT CAST('999ABC111' AS UNSIGNED INTEGER);

mysql> show warnings;


========================================== 
8장 그룹화와 집계
mysql> SELECT customer_id FROM rental;

mysql> SELECT customer_id
     FROM rental
     GROUP BY customer_id;

mysql> SELECT customer_id, count(*)
     FROM rental
     GROUP BY customer_id;

mysql> SELECT customer_id, count(*)
     FROM rental
     GROUP BY customer_id
     ORDER BY 2 DESC;

 mysql> SELECT customer_id, count(*)
     FROM rental
     WHERE count(*) >= 40
     GROUP BY customer_id;

mysql> SELECT customer_id, count(*)
     FROM rental
     GROUP BY customer_id
     HAVING count(*) >= 40;

mysql> SELECT MAX(amount) max_amt,
       MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) tot_amt,
       COUNT(*) num_payments
     FROM payment;

mysql> SELECT customer_id,
       MAX(amount) max_amt,
       MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) tot_amt,
       COUNT(*) num_payments
     FROM payment
     GROUP BY customer_id;

mysql> SELECT COUNT(customer_id) num_rows,
       COUNT(DISTINCT customer_id) num_customers
     FROM payment;

mysql> SELECT MAX(datediff(return_date,rental_date))
     FROM rental;

mysql> CREATE TABLE number_tbl
      (val SMALLINT);

mysql> INSERT INTO number_tbl VALUES (1);

mysql> INSERT INTO number_tbl VALUES (3);

mysql> INSERT INTO number_tbl VALUES (5);

mysql> SELECT COUNT(*) num_rows,
       COUNT(val) num_vals,
       SUM(val) total,
       MAX(val) max_val,
       AVG(val) avg_val
     FROM number_tbl;

mysql> INSERT INTO number_tbl VALUES (NULL);

mysql> SELECT COUNT(*) num_rows,
       COUNT(val) num_vals,
       SUM(val) total,
       MAX(val) max_val,
       AVG(val) avg_val
     FROM number_tbl;

mysql> SELECT actor_id, count(*)
     FROM film_actor
     GROUP BY actor_id;

mysql> SELECT fa.actor_id, f.rating, count(*)
     FROM film_actor fa
       INNER JOIN film f
       ON fa.film_id = f.film_id
     GROUP BY fa.actor_id, f.rating
     ORDER BY 1,2;

mysql> SELECT extract(YEAR FROM rental_date) year,
       COUNT(*) how_many
     FROM rental
     GROUP BY extract(YEAR FROM rental_date);

mysql> SELECT fa.actor_id, f.rating, count(*)
     FROM film_actor fa
       INNER JOIN film f
       ON fa.film_id = f.film_id
     GROUP BY fa.actor_id, f.rating WITH ROLLUP
     ORDER BY 1,2;

mysql> SELECT fa.actor_id, f.rating, count(*)
     FROM film_actor fa
       INNER JOIN film f
       ON fa.film_id = f.film_id
     WHERE f.rating IN ('G','PG')
     GROUP BY fa.actor_id, f.rating
     HAVING count(*) > 9;

mysql> SELECT fa.actor_id, f.rating, count(*)
     FROM film_actor fa
       INNER JOIN film f
       ON fa.film_id = f.film_id
     WHERE f.rating IN ('G','PG')
       AND count(*) > 9
     GROUP BY fa.actor_id, f.rating;

==========================================
9장 서브쿼리
 mysql> SELECT customer_id, first_name, last_name
     FROM customer
     WHERE customer_id = (SELECT MAX(customer_id) FROM customer);

mysql> SELECT MAX(customer_id) FROM customer;

mysql> SELECT customer_id, first_name, last_name
     FROM customer
     WHERE customer_id = 599;

mysql> SELECT city_id, city
     FROM city
     WHERE country_id <> 
      (SELECT country_id FROM country WHERE country = 'India');

mysql> SELECT city_id, city
     FROM city
     WHERE country_id <> 
      (SELECT country_id FROM country WHERE country <> 'India');

mysql> SELECT country_id FROM country WHERE country <> 'India';

mysql> SELECT country_id
     FROM country
     WHERE country IN ('Canada','Mexico');

mysql> SELECT country_id
     FROM country
     WHERE country = 'Canada' OR country = 'Mexico';

mysql> SELECT city_id, city
     FROM city
     WHERE country_id IN
      (SELECT country_id
       FROM country
       WHERE country IN ('Canada','Mexico'));

mysql> SELECT city_id, city
     FROM city
     WHERE country_id NOT IN
      (SELECT country_id
       FROM country
       WHERE country IN ('Canada','Mexico'));

mysql> SELECT first_name, last_name
     FROM customer
     WHERE customer_id <> ALL
      (SELECT customer_id
       FROM payment
       WHERE amount = 0);

SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN
 (SELECT customer_id
  FROM payment
  WHERE amount = 0)
mysql> SELECT first_name, last_name
     FROM customer
     WHERE customer_id NOT IN (122, 452, NULL);

mysql> SELECT customer_id, count(*)
     FROM rental
     GROUP BY customer_id
     HAVING count(*) > ALL
      (SELECT count(*)
       FROM rental r
         INNER JOIN customer c
         ON r.customer_id = c.customer_id
         INNER JOIN address a
         ON c.address_id = a.address_id
         INNER JOIN city ct
         ON a.city_id = ct.city_id
         INNER JOIN country co
         ON ct.country_id = co.country_id
       WHERE co.country IN ('United States','Mexico','Canada')
       GROUP BY r.customer_id
       );

mysql> SELECT customer_id, sum(amount)
     FROM payment
     GROUP BY customer_id
     HAVING sum(amount) > ANY
      (SELECT sum(p.amount)
       FROM payment p
         INNER JOIN customer c
         ON p.customer_id = c.customer_id
         INNER JOIN address a
         ON c.address_id = a.address_id
         INNER JOIN city ct
         ON a.city_id = ct.city_id
         INNER JOIN country co
         ON ct.country_id = co.country_id
       WHERE co.country IN ('Bolivia','Paraguay','Chile')
       GROUP BY co.country
      );

mysql> SELECT fa.actor_id, fa.film_id
     FROM film_actor fa
     WHERE fa.actor_id IN
      (SELECT actor_id FROM actor WHERE last_name = 'MONROE')
       AND fa.film_id IN
      (SELECT film_id FROM film WHERE rating = 'PG');

mysql> SELECT actor_id, film_id
     FROM film_actor
     WHERE (actor_id, film_id) IN
      (SELECT a.actor_id, f.film_id
       FROM actor a
          CROSS JOIN film f
       WHERE a.last_name = 'MONROE'
       AND f.rating = 'PG');

mysql> SELECT c.first_name, c.last_name
     FROM customer c
     WHERE 20 =
      (SELECT count(*) FROM rental r
       WHERE r.customer_id = c.customer_id);

mysql> SELECT c.first_name, c.last_name
     FROM customer c
     WHERE
      (SELECT sum(p.amount) FROM payment p
       WHERE p.customer_id = c.customer_id)
       BETWEEN 180 AND 240;

mysql> SELECT c.first_name, c.last_name
     FROM customer c
     WHERE EXISTS
      (SELECT 1 FROM rental r
       WHERE r.customer_id = c.customer_id
         AND date(r.rental_date) < '2005-05-25');

mysql> SELECT c.first_name, c.last_name
     FROM customer c
     WHERE EXISTS
      (SELECT r.rental_date, r.customer_id, 'ABCD' str, 2 * 3 / 7 nmbr
       FROM rental r
       WHERE r.customer_id = c.customer_id
         AND date(r.rental_date) < '2005-05-25');

mysql> SELECT a.first_name, a.last_name
     FROM actor a
     WHERE NOT EXISTS
      (SELECT 1
       FROM film_actor fa
         INNER JOIN film f ON f.film_id = fa.film_id
       WHERE fa.actor_id = a.actor_id
         AND f.rating = 'R');

mysql> SELECT c.first_name, c.last_name, 
       pymnt.num_rentals, pymnt.tot_payments
     FROM customer c
       INNER JOIN
        (SELECT customer_id, 
           count(*) num_rentals, sum(amount) tot_payments
         FROM payment
         GROUP BY customer_id
        ) pymnt
       ON c.customer_id = pymnt.customer_id;

mysql> SELECT customer_id, count(*) num_rentals, sum(amount) tot_payments
     FROM payment
     GROUP BY customer_id;

mysql> SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
     UNION ALL
     SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
     UNION ALL
     SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;

mysql> SELECT pymnt_grps.name, count(*) num_customers
     FROM
      (SELECT customer_id,
         count(*) num_rentals, sum(amount) tot_payments
       FROM payment
       GROUP BY customer_id
      ) pymnt
       INNER JOIN
      (SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
       UNION ALL
       SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
       UNION ALL
       SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit
      ) pymnt_grps
       ON pymnt.tot_payments
         BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
     GROUP BY pymnt_grps.name;

mysql> SELECT c.first_name, c.last_name, ct.city,
       sum(p.amount) tot_payments, count(*) tot_rentals
     FROM payment p
       INNER JOIN customer c
       ON p.customer_id = c.customer_id
       INNER JOIN address a
       ON c.address_id = a.address_id
       INNER JOIN city ct
       ON a.city_id = ct.city_id
     GROUP BY c.first_name, c.last_name, ct.city;

mysql> SELECT customer_id,
       count(*) tot_rentals, sum(amount) tot_payments
     FROM payment
     GROUP BY customer_id;

mysql> SELECT c.first_name, c.last_name,
       ct.city,
       pymnt.tot_payments, pymnt.tot_rentals
     FROM
      (SELECT customer_id,
         count(*) tot_rentals, sum(amount) tot_payments
       FROM payment
       GROUP BY customer_id
      ) pymnt
       INNER JOIN customer c
       ON pymnt.customer_id = c.customer_id
       INNER JOIN address a
       ON c.address_id = a.address_id
       INNER JOIN city ct
       ON a.city_id = ct.city_id;

mysql> WITH actors_s AS
      (SELECT actor_id, first_name, last_name
       FROM actor
       WHERE last_name LIKE 'S%'
      ),
      actors_s_pg AS
      (SELECT s.actor_id, s.first_name, s.last_name,
         f.film_id, f.title
       FROM actors_s s
         INNER JOIN film_actor fa
         ON s.actor_id = fa.actor_id
         INNER JOIN film f
         ON f.film_id = fa.film_id
       WHERE f.rating = 'PG'
      ),
      actors_s_pg_revenue AS
      (SELECT spg.first_name, spg.last_name, p.amount
       FROM actors_s_pg spg
         INNER JOIN inventory i
         ON i.film_id = spg.film_id
         INNER JOIN rental r
         ON i.inventory_id = r.inventory_id
         INNER JOIN payment p
         ON r.rental_id = p.rental_id
      ) -- end of With clause
     SELECT spg_rev.first_name, spg_rev.last_name,
       sum(spg_rev.amount) tot_revenue
     FROM actors_s_pg_revenue spg_rev
     GROUP BY spg_rev.first_name, spg_rev.last_name
     ORDER BY 3 desc;

mysql> SELECT
      (SELECT c.first_name FROM customer c
       WHERE c.customer_id = p.customer_id
      ) first_name,
      (SELECT c.last_name FROM customer c
       WHERE c.customer_id = p.customer_id
      ) last_name,
      (SELECT ct.city
       FROM customer c
       INNER JOIN address a
         ON c.address_id = a.address_id
       INNER JOIN city ct
         ON a.city_id = ct.city_id
       WHERE c.customer_id = p.customer_id
      ) city,
       sum(p.amount) tot_payments,
       count(*) tot_rentals
     FROM payment p
     GROUP BY p.customer_id;

mysql> SELECT a.actor_id, a.first_name, a.last_name
     FROM actor a
     ORDER BY
      (SELECT count(*) FROM film_actor fa
       WHERE fa.actor_id = a.actor_id) DESC;

==========================================
10장 조인 심화
mysql> SELECT f.film_id, f.title, count(*) num_copies
 FROM film f
   INNER JOIN inventory i
   ON f.film_id = i.film_id
 GROUP BY f.film_id, f.title;

mysql> SELECT f.film_id, f.title, count(i.inventory_id) num_copies
 FROM film f
   LEFT OUTER JOIN inventory i
   ON f.film_id = i.film_id
 GROUP BY f.film_id, f.title;

mysql> SELECT f.film_id, f.title, i.inventory_id
 FROM film f
   INNER JOIN inventory i
   ON f.film_id = i.film_id
 WHERE f.film_id BETWEEN 13 AND 15;

mysql> SELECT f.film_id, f.title, i.inventory_id
 FROM film f
   LEFT OUTER JOIN inventory i
   ON f.film_id = i.film_id
 WHERE f.film_id BETWEEN 13 AND 15;

mysql> SELECT f.film_id, f.title, i.inventory_id
 FROM inventory i
   RIGHT OUTER JOIN film f
   ON f.film_id = i.film_id
 WHERE f.film_id BETWEEN 13 AND 15;

mysql> SELECT f.film_id, f.title, i.inventory_id, r.rental_date
 FROM film f
   LEFT OUTER JOIN inventory i
   ON f.film_id = i.film_id
   LEFT OUTER JOIN rental r
   ON i.inventory_id = r.inventory_id
 WHERE f.film_id BETWEEN 13 AND 15;

mysql> SELECT c.name category_name, l.name language_name
 FROM category c
   CROSS JOIN language l;

mysql> SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
 UNION ALL
 SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
 UNION ALL
 SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;

mysql> SELECT ones.num + tens.num + hundreds.num
 FROM
 (SELECT 0 num UNION ALL
 SELECT 1 num UNION ALL
 SELECT 2 num UNION ALL
 SELECT 3 num UNION ALL
 SELECT 4 num UNION ALL
 SELECT 5 num UNION ALL
 SELECT 6 num UNION ALL
 SELECT 7 num UNION ALL
 SELECT 8 num UNION ALL
 SELECT 9 num) ones
 CROSS JOIN
 (SELECT 0 num UNION ALL
 SELECT 10 num UNION ALL
 SELECT 20 num UNION ALL
 SELECT 30 num UNION ALL
 SELECT 40 num UNION ALL
 SELECT 50 num UNION ALL
 SELECT 60 num UNION ALL
 SELECT 70 num UNION ALL
 SELECT 80 num UNION ALL
 SELECT 90 num) tens
 CROSS JOIN
 (SELECT 0 num UNION ALL
 SELECT 100 num UNION ALL
 SELECT 200 num UNION ALL
 SELECT 300 num) hundreds;

mysql> SELECT DATE_ADD('2020-01-01',
   INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
 FROM
  (SELECT 0 num UNION ALL
   SELECT 1 num UNION ALL
   SELECT 2 num UNION ALL
   SELECT 3 num UNION ALL
   SELECT 4 num UNION ALL
   SELECT 5 num UNION ALL
   SELECT 6 num UNION ALL
   SELECT 7 num UNION ALL
   SELECT 8 num UNION ALL
   SELECT 9 num) ones
   CROSS JOIN
  (SELECT 0 num UNION ALL
   SELECT 10 num UNION ALL
   SELECT 20 num UNION ALL
   SELECT 30 num UNION ALL
   SELECT 40 num UNION ALL
   SELECT 50 num UNION ALL
   SELECT 60 num UNION ALL
   SELECT 70 num UNION ALL
   SELECT 80 num UNION ALL
   SELECT 90 num) tens
   CROSS JOIN
  (SELECT 0 num UNION ALL
   SELECT 100 num UNION ALL
   SELECT 200 num UNION ALL
   SELECT 300 num) hundreds
 WHERE DATE_ADD('2020-01-01',
   INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2021-01-01'
 ORDER BY 1;

mysql> SELECT days.dt, COUNT(r.rental_id) num_rentals
 FROM rental r
   RIGHT OUTER JOIN
  (SELECT DATE_ADD('2005-01-01',
     INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
   FROM
    (SELECT 0 num UNION ALL
     SELECT 1 num UNION ALL
     SELECT 2 num UNION ALL
     SELECT 3 num UNION ALL
     SELECT 4 num UNION ALL
     SELECT 5 num UNION ALL
     SELECT 6 num UNION ALL
     SELECT 7 num UNION ALL
     SELECT 8 num UNION ALL
     SELECT 9 num) ones
     CROSS JOIN
    (SELECT 0 num UNION ALL
     SELECT 10 num UNION ALL
     SELECT 20 num UNION ALL
     SELECT 30 num UNION ALL
     SELECT 40 num UNION ALL
     SELECT 50 num UNION ALL
     SELECT 60 num UNION ALL
     SELECT 70 num UNION ALL
     SELECT 80 num UNION ALL
     SELECT 90 num) tens
     CROSS JOIN
    (SELECT 0 num UNION ALL
     SELECT 100 num UNION ALL
     SELECT 200 num UNION ALL
     SELECT 300 num) hundreds
   WHERE DATE_ADD('2005-01-01',
     INTERVAL (ones.num + tens.num + hundreds.num) DAY) 
       < '2006-01-01'
  ) days
   ON days.dt = date(r.rental_date)
 GROUP BY days.dt
 ORDER BY 1;

mysql> SELECT c.first_name, c.last_name, date(r.rental_date)
 FROM customer c
   NATURAL JOIN rental r;

mysql> SELECT cust.first_name, cust.last_name, date(r.rental_date)
 FROM
  (SELECT customer_id, first_name, last_name
   FROM customer
  ) cust
   NATURAL JOIN rental r;
            Customer:

==========================================
11장 조건식
mysql> SELECT first_name, last_name,
   CASE
     WHEN active = 1 THEN 'ACTIVE'
     ELSE 'INACTIVE'
   END activity_type
 FROM customer;

mysql> SELECT c.first_name, c.last_name,
   CASE
     WHEN active = 0 THEN 0
     ELSE
      (SELECT count(*) FROM rental r
       WHERE r.customer_id = c.customer_id)
   END num_rentals
 FROM customer c;

mysql> SELECT monthname(rental_date) rental_month,
   count(*) num_rentals
 FROM rental
 WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01'
 GROUP BY monthname(rental_date);

mysql> SELECT
   SUM(CASE WHEN monthname(rental_date) = 'May' THEN 1
         ELSE 0 END) May_rentals,
   SUM(CASE WHEN monthname(rental_date) = 'June' THEN 1
         ELSE 0 END) June_rentals,
   SUM(CASE WHEN monthname(rental_date) = 'July' THEN 1
         ELSE 0 END) July_rentals
 FROM rental
 WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01';

mysql> SELECT a.first_name, a.last_name,
   CASE
     WHEN EXISTS (SELECT 1 FROM film_actor fa
                    INNER JOIN film f ON fa.film_id = f.film_id
                  WHERE fa.actor_id = a.actor_id
                    AND f.rating = 'G') THEN 'Y'
     ELSE 'N'
   END g_actor,
   CASE
     WHEN EXISTS (SELECT 1 FROM film_actor fa
                    INNER JOIN film f ON fa.film_id = f.film_id
                  WHERE fa.actor_id = a.actor_id
                    AND f.rating = 'PG') THEN 'Y'
     ELSE 'N'
   END pg_actor,
   CASE
     WHEN EXISTS (SELECT 1 FROM film_actor fa
                    INNER JOIN film f ON fa.film_id = f.film_id
                  WHERE fa.actor_id = a.actor_id
                    AND f.rating = 'NC-17') THEN 'Y'
     ELSE 'N'
   END nc17_actor
 FROM actor a
 WHERE a.last_name LIKE 'S%' OR a.first_name LIKE 'S%';

mysql> SELECT f.title,
   CASE (SELECT count(*) FROM inventory i 
         WHERE i.film_id = f.film_id)
     WHEN 0 THEN 'Out Of Stock'
     WHEN 1 THEN 'Scarce'
     WHEN 2 THEN 'Scarce'
     WHEN 3 THEN 'Available'
     WHEN 4 THEN 'Available'
     ELSE 'Common'
   END film_availability
 FROM film f
 ;

mysql> SELECT 100 / 0;

mysql> SELECT c.first_name, c.last_name,
   sum(p.amount) tot_payment_amt,
   count(p.amount) num_payments,
   sum(p.amount) /
     CASE WHEN count(p.amount) = 0 THEN 1
       ELSE count(p.amount)
     END avg_payment
 FROM customer c
   LEFT OUTER JOIN payment p
   ON c.customer_id = p.customer_id
 GROUP BY c.first_name, c.last_name;

mysql> SELECT (7 * 5) / ((3 + 14) * null);

mysql> SELECT rating, count(*)
 FROM film
 GROUP BY rating;

==========================================
12장 트랜잭션
mysql> show table status like 'customer' \G;

==========================================
13장 인덱스와 제약조건
mysql> SELECT first_name, last_name
 FROM customer
 WHERE last_name LIKE 'Y%';

mysql> ALTER TABLE customer
 ADD INDEX idx_email (email);

mysql> SHOW INDEX FROM customer \G;

mysql> ALTER TABLE customer
 DROP INDEX idx_email;

mysql> ALTER TABLE customer
 ADD UNIQUE idx_email (email);

mysql> INSERT INTO customer
  (store_id, first_name, last_name, email, address_id, active)
 VALUES
  (1,'ALAN','KAHN', 'ALAN.KAHN@sakilacustomer.org', 394, 1);

mysql> ALTER TABLE customer
 ADD INDEX idx_full_name (last_name, first_name);

mysql> SELECT customer_id, first_name, last_name
 FROM customer
 WHERE first_name LIKE 'S%' AND last_name LIKE 'P%';

mysql> EXPLAIN
 SELECT customer_id, first_name, last_name
 FROM customer 
 WHERE first_name LIKE 'S%' AND last_name LIKE 'P%' \G;

mysql> SELECT c.first_name, c.last_name, c.address_id, a.address
 FROM customer c
   INNER JOIN address a
   ON c.address_id = a.address_id
 WHERE a.address_id = 123;

mysql> DELETE FROM address WHERE address_id = 123;

mysql> UPDATE address
 SET address_id = 9999
 WHERE address_id = 123;

mysql> SELECT c.first_name, c.last_name, c.address_id, a.address
 FROM customer c
   INNER JOIN address a
   ON c.address_id = a.address_id
 WHERE a.address_id = 9999;

==========================================
14장 뷰 
mysql> SELECT first_name, last_name, email
 FROM customer_vw;

mysql>describe customer_vw;

mysql> SELECT first_name, count(*), min(last_name), max(last_name)
 FROM customer_vw
 WHERE first_name LIKE 'J%'
 GROUP BY first_name
 HAVING count(*) > 1
 ORDER BY 1;

mysql> SELECT cv.first_name, cv.last_name, p.amount
 FROM customer_vw cv
   INNER JOIN payment p
   ON cv.customer_id = p.customer_id
 WHERE p.amount >= 11;

mysql> UPDATE customer_vw
 SET last_name = 'SMITH-ALLEN'
 WHERE customer_id = 1;

mysql> SELECT first_name, last_name, email
 FROM customer
 WHERE customer_id = 1;

mysql> UPDATE customer_vw
 SET email = 'MARY.SMITH-ALLEN@sakilacustomer.org'
 WHERE customer_id = 1;

mysql> INSERT INTO customer_vw
  (customer_id,
   first_name,
   last_name)
 VALUES (99999,'ROBERT','SIMPSON');

mysql> UPDATE customer_details
 SET last_name = 'SMITH-ALLEN', active = 0
 WHERE customer_id = 1;

mysql> UPDATE customer_details
 SET address = '999 Mockingbird Lane'
 WHERE customer_id = 1;

mysql> UPDATE customer_details
 SET last_name = 'SMITH-ALLEN',
   active = 0,
   address = '999 Mockingbird Lane'
 WHERE customer_id = 1;

mysql> INSERT INTO customer_details
  (customer_id, store_id, first_name, last_name,
   address_id, active, create_date)
 VALUES (9998, 1, 'BRIAN', 'SALAZAR', 5, 1, now());

mysql> INSERT INTO customer_details
  (customer_id, store_id, first_name, last_name,
   address_id, active, create_date, address)
 VALUES (9999, 2, 'THOMAS', 'BISHOP', 7, 1, now(),
  '999 Mockingbird Lane');

SELECT title, category_name, first_name, last_name
FROM film_ctgry_actor
WHERE last_name = 'FAWCETT'; 

==========================================
15장 메타데이터
mysql> SELECT table_name, table_type
 FROM information_schema.tables
 WHERE table_schema = 'sakila'
 ORDER BY 1;

mysql> SELECT table_name, table_type
 FROM information_schema.tables
 WHERE table_schema = 'sakila'
   AND table_type = 'BASE TABLE'
 ORDER BY 1;

mysql> SELECT table_name, is_updatable
 FROM information_schema.views
 WHERE table_schema = 'sakila'
 ORDER BY 1;

mysql> SELECT column_name, data_type, 
   character_maximum_length char_max_len,
   numeric_precision num_prcsn, numeric_scale num_scale
 FROM information_schema.columns
 WHERE table_schema = 'sakila' AND table_name = 'film'
 ORDER BY ordinal_position;

mysql> SELECT index_name, non_unique, seq_in_index, column_name
 FROM information_schema.statistics
 WHERE table_schema = 'sakila' AND table_name = 'rental'
 ORDER BY 1, 3;

mysql> SELECT constraint_name, table_name, constraint_type
 FROM information_schema.table_constraints
 WHERE table_schema = 'sakila'
 ORDER BY 3,1;

mysql> SELECT 'CREATE TABLE category (' create_table_statement
 UNION ALL
 SELECT cols.txt
 FROM
  (SELECT concat('  ',column_name, ' ', column_type,
    CASE
      WHEN is_nullable = 'NO' THEN ' not null'
      ELSE ''
    END,
    CASE
      WHEN extra IS NOT NULL AND extra LIKE 'DEFAULT_GENERATED%'
       THEN concat(' DEFAULT ',column_default,substr(extra,18))
      WHEN extra IS NOT NULL THEN concat(' ', extra)
      ELSE ''
    END,
    ',') txt
   FROM information_schema.columns
   WHERE table_schema = 'sakila' AND table_name = 'category'
   ORDER BY ordinal_position
  ) cols
 UNION ALL
 SELECT ')';

mysql> SELECT 'CREATE TABLE category (' create_table_statement
 UNION ALL
 SELECT cols.txt
 FROM
  (SELECT concat('  ',column_name, ' ', column_type,
    CASE
      WHEN is_nullable = 'NO' THEN ' not null'
      ELSE ''
    END,
    CASE
      WHEN extra IS NOT NULL AND extra LIKE 'DEFAULT_GENERATED%'
        THEN concat(' DEFAULT ',column_default,substr(extra,18))
      WHEN extra IS NOT NULL THEN concat(' ', extra)
      ELSE ''
    END,
    ',') txt
   FROM information_schema.columns
   WHERE table_schema = 'sakila' AND table_name = 'category'
   ORDER BY ordinal_position
  ) cols
 UNION ALL
 SELECT concat('  constraint primary key (')
 FROM information_schema.table_constraints
 WHERE table_schema = 'sakila' AND table_name = 'category'
   AND constraint_type = 'PRIMARY KEY'
 UNION ALL
 SELECT cols.txt
 FROM
  (SELECT concat(CASE WHEN ordinal_position > 1 THEN '   ,'
     ELSE '    ' END, column_name) txt
   FROM information_schema.key_column_usage
   WHERE table_schema = 'sakila' AND table_name = 'category'
     AND constraint_name = 'PRIMARY'
   ORDER BY ordinal_position
  ) cols
 UNION ALL
 SELECT '  )'
 UNION ALL
 SELECT ')';

mysql> CREATE TABLE category2 (
   category_id tinyint(3) unsigned not null auto_increment,
   name varchar(25) not null ,
   last_update timestamp not null DEFAULT CURRENT_TIMESTAMP 
     on update CURRENT_TIMESTAMP,
   constraint primary key (
     category_id
   )
 );

mysql> SELECT tbl.table_name,
  (SELECT count(*) FROM information_schema.columns clm
   WHERE clm.table_schema = tbl.table_schema
     AND clm.table_name = tbl.table_name) num_columns,
  (SELECT count(*) FROM information_schema.statistics sta
   WHERE sta.table_schema = tbl.table_schema
     AND sta.table_name = tbl.table_name) num_indexes,
  (SELECT count(*) FROM information_schema.table_constraints tc
   WHERE tc.table_schema = tbl.table_schema
     AND tc.table_name = tbl.table_name
     AND tc.constraint_type = 'PRIMARY KEY') num_primary_keys
 FROM information_schema.tables tbl
 WHERE tbl.table_schema = 'sakila' AND tbl.table_type = 'BASE TABLE'
 ORDER BY 1;

mysql> SET @qry = 'SELECT customer_id, first_name, last_name FROM customer';

mysql> PREPARE dynsql1 FROM @qry;

mysql> EXECUTE dynsql1;

mysql> DEALLOCATE PREPARE dynsql1;

mysql> SET @qry = 'SELECT customer_id, first_name, last_name 
  FROM customer WHERE customer_id = ?';

mysql> PREPARE dynsql2 FROM @qry;

mysql> SET @custid = 9;

mysql> EXECUTE dynsql2 USING @custid;

mysql> SET @custid = 145;

mysql> EXECUTE dynsql2 USING @custid;

mysql> DEALLOCATE PREPARE dynsql2;

mysql> SELECT concat('SELECT ',
   concat_ws(',', cols.col1, cols.col2, cols.col3, cols.col4,
     cols.col5, cols.col6, cols.col7, cols.col8, cols.col9),
   ' FROM customer WHERE customer_id = ?')
 INTO @qry
 FROM
  (SELECT
     max(CASE WHEN ordinal_position = 1 THEN column_name
       ELSE NULL END) col1,
     max(CASE WHEN ordinal_position = 2 THEN column_name
       ELSE NULL END) col2,
     max(CASE WHEN ordinal_position = 3 THEN column_name
       ELSE NULL END) col3,
     max(CASE WHEN ordinal_position = 4 THEN column_name
       ELSE NULL END) col4,
     max(CASE WHEN ordinal_position = 5 THEN column_name
       ELSE NULL END) col5,
     max(CASE WHEN ordinal_position = 6 THEN column_name
       ELSE NULL END) col6,
     max(CASE WHEN ordinal_position = 7 THEN column_name
       ELSE NULL END) col7,
     max(CASE WHEN ordinal_position = 8 THEN column_name
       ELSE NULL END) col8,
     max(CASE WHEN ordinal_position = 9 THEN column_name
       ELSE NULL END) col9
   FROM information_schema.columns
   WHERE table_schema = 'sakila' AND table_name = 'customer'
   GROUP BY table_name
  ) cols;

mysql> SELECT @qry;

mysql> PREPARE dynsql3 FROM @qry;

mysql> SET @custid = 45;

mysql> EXECUTE dynsql3 USING @custid;

mysql> DEALLOCATE PREPARE dynsql3;

==========================================
16장 분석 함수
mysql> SELECT quarter(payment_date) quarter,
   monthname(payment_date) month_nm,
   sum(amount) monthly_sales
 FROM payment
 WHERE year(payment_date) = 2005
 GROUP BY quarter(payment_date), monthname(payment_date);

mysql> SELECT quarter(payment_date) quarter,
   monthname(payment_date) month_nm,
   sum(amount) monthly_sales,
   max(sum(amount))
     over () max_overall_sales,
   max(sum(amount))
     over (partition by quarter(payment_date)) max_qrtr_sales
 FROM payment
 WHERE year(payment_date) = 2005
 GROUP BY quarter(payment_date), monthname(payment_date);

mysql> SELECT quarter(payment_date) quarter,
   monthname(payment_date) month_nm,
   sum(amount) monthly_sales,
   rank() over (order by sum(amount) desc) sales_rank
 FROM payment
 WHERE year(payment_date) = 2005
 GROUP BY quarter(payment_date), monthname(payment_date)
 ORDER BY 1, month(payment_date);

mysql> SELECT quarter(payment_date) quarter,
   monthname(payment_date) month_nm,
   sum(amount) monthly_sales,
   rank() over (partition by quarter(payment_date)
     order by sum(amount) desc) qtr_sales_rank
 FROM payment
 WHERE year(payment_date) = 2005
 GROUP BY quarter(payment_date), monthname(payment_date)
 ORDER BY 1, month(payment_date);

mysql> SELECT customer_id, count(*) num_rentals
 FROM rental
 GROUP BY customer_id 
 ORDER BY 2 desc;

mysql> SELECT customer_id, count(*) num_rentals,
   row_number() over (order by count(*) desc) row_number_rnk,
   rank() over (order by count(*) desc) rank_rnk,
   dense_rank() over (order by count(*) desc) dense_rank_rnk
 FROM rental
 GROUP BY customer_id
 ORDER BY 2 desc;

mysql> SELECT customer_id,
   monthname(rental_date) rental_month,
   count(*) num_rentals
 FROM rental
 GROUP BY customer_id, monthname(rental_date)
 ORDER BY 2, 3 desc;

mysql> SELECT customer_id,
   monthname(rental_date) rental_month,
   count(*) num_rentals,
   rank() over (partition by monthname(rental_date)
     order by count(*) desc) rank_rnk
 FROM rental
 GROUP BY customer_id, monthname(rental_date)
 ORDER BY 2, 3 desc;

mysql> SELECT monthname(payment_date) payment_month,
   amount,
   sum(amount) 
     over (partition by monthname(payment_date)) monthly_total,
   sum(amount) over () grand_total
 FROM payment
 WHERE amount >= 10
 ORDER BY 1;

mysql> SELECT monthname(payment_date) payment_month,
   sum(amount) month_total,
   round(sum(amount) / sum(sum(amount)) over ()
     * 100, 2) pct_of_total
 FROM payment
 GROUP BY monthname(payment_date);

mysql> SELECT monthname(payment_date) payment_month,
   sum(amount) month_total,
   CASE sum(amount)
     WHEN max(sum(amount)) over () THEN 'Highest'
     WHEN min(sum(amount)) over () THEN 'Lowest'
     ELSE 'Middle'
   END descriptor
 FROM payment
 GROUP BY monthname(payment_date);

mysql> SELECT yearweek(payment_date) payment_week,
   sum(amount) week_total,
   sum(sum(amount))
     over (order by yearweek(payment_date)
       rows unbounded preceding) rolling_sum
 FROM payment
 GROUP BY yearweek(payment_date)
 ORDER BY 1;

mysql> SELECT yearweek(payment_date) payment_week,
   sum(amount) week_total,
   avg(sum(amount))
     over (order by yearweek(payment_date)
       rows between 1 preceding and 1 following) rolling_3wk_avg
 FROM payment
 GROUP BY yearweek(payment_date)
 ORDER BY 1;

mysql> SELECT date(payment_date), sum(amount),
   avg(sum(amount)) over (order by date(payment_date)
     range between interval 3 day preceding
       and interval 3 day following) 7_day_avg
 FROM payment
 WHERE payment_date BETWEEN '2005-07-01' AND '2005-09-01'
 GROUP BY date(payment_date)
 ORDER BY 1;

mysql> SELECT yearweek(payment_date) payment_week,
   sum(amount) week_total,
   lag(sum(amount), 1)
     over (order by yearweek(payment_date)) prev_wk_tot,
   lead(sum(amount), 1)
     over (order by yearweek(payment_date)) next_wk_tot
 FROM payment
 GROUP BY yearweek(payment_date)
 ORDER BY 1;

mysql> SELECT yearweek(payment_date) payment_week,
   sum(amount) week_total,
   round((sum(amount) - lag(sum(amount), 1)
     over (order by yearweek(payment_date)))
     / lag(sum(amount), 1)
       over (order by yearweek(payment_date))
     * 100, 1) pct_diff
 FROM payment
 GROUP BY yearweek(payment_date)
 ORDER BY 1;

mysql> SELECT f.title,
   group_concat(a.last_name order by a.last_name 
     separator ', ') actors
 FROM actor a
   INNER JOIN film_actor fa
   ON a.actor_id = fa.actor_id
   INNER JOIN film f
   ON fa.film_id = f.film_id
 GROUP BY f.title
 HAVING count(*) = 3;

==========================================
17장 대용량 데이터베이스 작업
mysql> CREATE TABLE sales
  (sale_id INT NOT NULL,
   cust_id INT NOT NULL,
   store_id INT NOT NULL,
   sale_date DATE NOT NULL,
   amount DECIMAL(9,2)
  )
 PARTITION BY RANGE (yearweek(sale_date))
  (PARTITION s1 VALUES LESS THAN (202002),
   PARTITION s2 VALUES LESS THAN (202003),
   PARTITION s3 VALUES LESS THAN (202004),
   PARTITION s4 VALUES LESS THAN (202005),
   PARTITION s5 VALUES LESS THAN (202006),
   PARTITION s999 VALUES LESS THAN (MAXVALUE)
  );

mysql> SELECT partition_name, partition_method, partition_expression
 FROM information_schema.partitions
 WHERE table_name = 'sales'
 ORDER BY partition_ordinal_position;

mysql> SELECT partition_name, partition_method, partition_expression
 FROM information_schema.partitions
 WHERE table_name = 'sales'
 ORDER BY partition_ordinal_position;

mysql> INSERT INTO sales
 VALUES
  (1, 1, 1, '2020-01-18', 2765.15),
  (2, 3, 4, '2020-02-07', 5322.08);

mysql> SELECT concat('# of rows in S1 = ', count(*)) partition_rowcount
 FROM sales PARTITION (s1) UNION ALL
 SELECT concat('# of rows in S2 = ', count(*)) partition_rowcount
 FROM sales PARTITION (s2) UNION ALL
 SELECT concat('# of rows in S3 = ', count(*)) partition_rowcount
 FROM sales PARTITION (s3) UNION ALL
 SELECT concat('# of rows in S4 = ', count(*)) partition_rowcount
 FROM sales PARTITION (s4) UNION ALL
 SELECT concat('# of rows in S5 = ', count(*)) partition_rowcount
 FROM sales PARTITION (s5) UNION ALL
 SELECT concat('# of rows in S6 = ', count(*)) partition_rowcount
 FROM sales PARTITION (s6) UNION ALL
 SELECT concat('# of rows in S7 = ', count(*)) partition_rowcount
 FROM sales PARTITION (s7) UNION ALL
 SELECT concat('# of rows in S999 = ', count(*)) partition_rowcount
 FROM sales PARTITION (s999);

mysql> CREATE TABLE sales
  (sale_id INT NOT NULL,
   cust_id INT NOT NULL,
   store_id INT NOT NULL,
   sale_date DATE NOT NULL,
   geo_region_cd VARCHAR(6) NOT NULL,
   amount DECIMAL(9,2)
  )
 PARTITION BY LIST COLUMNS (geo_region_cd)
  (PARTITION NORTHAMERICA VALUES IN ('US_NE','US_SE','US_MW',
                                     'US_NW','US_SW','CAN','MEX'),
   PARTITION EUROPE VALUES IN ('EUR_E','EUR_W'),
   PARTITION ASIA VALUES IN ('CHN','JPN','IND')
  );

mysql> INSERT INTO sales
 VALUES
  (1, 1, 1, '2020-01-18', 'US_NE', 2765.15),
  (2, 3, 4, '2020-02-07', 'CAN', 5322.08),
  (3, 6, 27, '2020-03-11', 'KOR', 4267.12);

mysql> ALTER TABLE sales REORGANIZE PARTITION ASIA INTO
  (PARTITION ASIA VALUES IN ('CHN','JPN','IND', 'KOR'));

mysql> SELECT partition_name, partition_expression,
   partition_description
 FROM information_schema.partitions
 WHERE table_name = 'sales'
 ORDER BY partition_ordinal_position;

mysql> INSERT INTO sales
 VALUES
  (1, 1, 1, '2020-01-18', 'US_NE', 2765.15),
  (2, 3, 4, '2020-02-07', 'CAN', 5322.08),
  (3, 6, 27, '2020-03-11', 'KOR', 4267.12);

mysql> CREATE TABLE sales
  (sale_id INT NOT NULL,
   cust_id INT NOT NULL,
   store_id INT NOT NULL,
   sale_date DATE NOT NULL,
   amount DECIMAL(9,2)
  )
 PARTITION BY HASH (cust_id)
   PARTITIONS 4
    (PARTITION H1,
     PARTITION H2,
     PARTITION H3,
     PARTITION H4
    );

mysql> INSERT INTO sales
 VALUES
  (1, 1, 1, '2020-01-18', 1.1), (2, 3, 4, '2020-02-07', 1.2),
  (3, 17, 5, '2020-01-19', 1.3), (4, 23, 2, '2020-02-08', 1.4),
  (5, 56, 1, '2020-01-20', 1.6), (6, 77, 5, '2020-02-09', 1.7),
  (7, 122, 4, '2020-01-21', 1.8), (8, 153, 1, '2020-02-10', 1.9),
  (9, 179, 5, '2020-01-22', 2.0), (10, 244, 2, '2020-02-11', 2.1),
  (11, 263, 1, '2020-01-23', 2.2), (12, 312, 4, '2020-02-12', 2.3),
  (13, 346, 2, '2020-01-24', 2.4), (14, 389, 3, '2020-02-13', 2.5),
  (15, 472, 1, '2020-01-25', 2.6), (16, 502, 1, '2020-02-14', 2.7);

mysql> SELECT concat('# of rows in H1 = ', count(*)) partition_rowcount
 FROM sales PARTITION (h1) UNION ALL
 SELECT concat('# of rows in H2 = ', count(*)) partition_rowcount
 FROM sales PARTITION (h2) UNION ALL
 SELECT concat('# of rows in H3 = ', count(*)) partition_rowcount
 FROM sales PARTITION (h3) UNION ALL
 SELECT concat('# of rows in H4 = ', count(*)) partition_rowcount
 FROM sales PARTITION (h4);

mysql> CREATE TABLE sales
  (sale_id INT NOT NULL,
   cust_id INT NOT NULL,
   store_id INT NOT NULL,
   sale_date DATE NOT NULL,
   amount DECIMAL(9,2)
  )
 PARTITION BY RANGE (yearweek(sale_date))
 SUBPARTITION BY HASH (cust_id)
  (PARTITION s1 VALUES LESS THAN (202002)
     (SUBPARTITION s1_h1,
      SUBPARTITION s1_h2,
      SUBPARTITION s1_h3,
      SUBPARTITION s1_h4),
   PARTITION s2 VALUES LESS THAN (202003)
     (SUBPARTITION s2_h1,
      SUBPARTITION s2_h2,
      SUBPARTITION s2_h3,
      SUBPARTITION s2_h4),
   PARTITION s3 VALUES LESS THAN (202004)
     (SUBPARTITION s3_h1,
      SUBPARTITION s3_h2,
      SUBPARTITION s3_h3,
      SUBPARTITION s3_h4),
   PARTITION s4 VALUES LESS THAN (202005)
     (SUBPARTITION s4_h1,
      SUBPARTITION s4_h2,
      SUBPARTITION s4_h3,
      SUBPARTITION s4_h4),
   PARTITION s5 VALUES LESS THAN (202006)
     (SUBPARTITION s5_h1,
      SUBPARTITION s5_h2,
      SUBPARTITION s5_h3,
      SUBPARTITION s5_h4),
   PARTITION s999 VALUES LESS THAN (MAXVALUE)
     (SUBPARTITION s999_h1,
      SUBPARTITION s999_h2,
      SUBPARTITION s999_h3,
      SUBPARTITION s999_h4)
  );

mysql> INSERT INTO sales
 VALUES
  (1, 1, 1, '2020-01-18', 1.1), (2, 3, 4, '2020-02-07', 1.2),
  (3, 17, 5, '2020-01-19', 1.3), (4, 23, 2, '2020-02-08', 1.4),
  (5, 56, 1, '2020-01-20', 1.6), (6, 77, 5, '2020-02-09', 1.7),
  (7, 122, 4, '2020-01-21', 1.8), (8, 153, 1, '2020-02-10', 1.9),
  (9, 179, 5, '2020-01-22', 2.0), (10, 244, 2, '2020-02-11', 2.1),
  (11, 263, 1, '2020-01-23', 2.2), (12, 312, 4, '2020-02-12', 2.3),
  (13, 346, 2, '2020-01-24', 2.4), (14, 389, 3, '2020-02-13', 2.5),
  (15, 472, 1, '2020-01-25', 2.6), (16, 502, 1, '2020-02-14', 2.7);

mysql> SELECT *
 FROM sales PARTITION (s3);

mysql> SELECT *
 FROM sales PARTITION (s3_h3);

==========================================
18장 SQL과 빅데이터
apache drill> SELECT file_name, is_directory, is_file, permission
. . . . . . > FROM information_schema.`files`
. . . . . . > WHERE schema_name = 'dfs.data';

apache drill> SELECT * FROM dfs.data.`attack-trace.pcap`
. . . . . . > WHERE 1=2;

apache drill> SELECT src_ip, dst_port,
. . . . . . >   count(*) AS packet_count
. . . . . . > FROM dfs.data.`attack-trace.pcap`
. . . . . . > GROUP BY src_ip, dst_port;

apache drill> SELECT trunc(extract(second from `timestamp`)) as packet_time,
. . . . . . >   count(*) AS num_packets,
. . . . . . >   sum(packet_length) AS tot_volume
. . . . . . > FROM dfs.data.`attack-trace.pcap`
. . . . . . > GROUP BY trunc(extract(second from `timestamp`));

apache drill (information_schema)> use mysql.sakila;

apache drill (mysql.sakila)> show tables;

apache drill (mysql.sakila)> SELECT a.address_id, a.address, ct.city
. . . . . . . . . . . . . )> FROM address a
. . . . . . . . . . . . . )>   INNER JOIN city ct
. . . . . . . . . . . . . )>   ON a.city_id = ct.city_id
. . . . . . . . . . . . . )> WHERE a.district = 'California';

apache drill (mysql.sakila)> SELECT fa.actor_id, f.rating, 
. . . . . . . . . . . . . )>   count(*) num_films
. . . . . . . . . . . . . )> FROM film_actor fa
. . . . . . . . . . . . . )>   INNER JOIN film f
. . . . . . . . . . . . . )>   ON fa.film_id = f.film_id
. . . . . . . . . . . . . )> WHERE f.rating IN ('G','PG')
. . . . . . . . . . . . . )> GROUP BY fa.actor_id, f.rating
. . . . . . . . . . . . . )> HAVING count(*) > 9;

apache drill (mysql.sakila)> SELECT customer_id, count(*) num_rentals,
. . . . . . . . . . . . . )>   row_number() 
. . . . . . . . . . . . . )>     over (order by count(*) desc) 
. . . . . . . . . . . . . )>       row_number_rnk,
. . . . . . . . . . . . . )>   rank() 
. . . . . . . . . . . . . )>     over (order by count(*) desc) rank_rnk,
. . . . . . . . . . . . . )>   dense_rank() 
. . . . . . . . . . . . . )>     over (order by count(*) desc)
. . . . . . . . . . . . . )>       dense_rank_rnk
. . . . . . . . . . . . . )> FROM rental
. . . . . . . . . . . . . )> GROUP BY customer_id
. . . . . . . . . . . . . )> ORDER BY 2 desc;

apache drill (mongo.sakila)> SELECT Rating, Actors
. . . . . . . . . . . . . )> FROM films
. . . . . . . . . . . . . )> WHERE Rating IN ('G','PG');

apache drill (mongo.sakila)> SELECT f.Rating, flatten(Actors) actor_list
. . . . . . . . . . . . . )>   FROM films f
. . . . . . . . . . . . . )>   WHERE f.Rating IN ('G','PG');

apache drill (mongo.sakila)> SELECT g_pg_films.Rating,
. . . . . . . . . . . . . )>   g_pg_films.actor_list.`First name` first_name,
. . . . . . . . . . . . . )>   g_pg_films.actor_list.`Last name` last_name,
. . . . . . . . . . . . . )>   count(*) num_films
. . . . . . . . . . . . . )> FROM
. . . . . . . . . . . . . )>  (SELECT f.Rating, flatten(Actors) actor_list
. . . . . . . . . . . . . )>   FROM films f
. . . . . . . . . . . . . )>   WHERE f.Rating IN ('G','PG')
. . . . . . . . . . . . . )>  ) g_pg_films
. . . . . . . . . . . . . )> GROUP BY g_pg_films.Rating,
. . . . . . . . . . . . . )>   g_pg_films.actor_list.`First name`,
. . . . . . . . . . . . . )>   g_pg_films.actor_list.`Last name`
. . . . . . . . . . . . . )> HAVING count(*) > 9;

apache drill (mongo.sakila)> SELECT first_name, last_name,
. . . . . . . . . . . . . )>   sum(cast(cust_payments.payment_data.Amount
. . . . . . . . . . . . . )>         as decimal(4,2))) tot_payments
. . . . . . . . . . . . . )> FROM
. . . . . . . . . . . . . )>  (SELECT cust_data.first_name,
. . . . . . . . . . . . . )>     cust_data.last_name,
. . . . . . . . . . . . . )>     f.Rating,
. . . . . . . . . . . . . )>     flatten(cust_data.rental_data.Payments)
. . . . . . . . . . . . . )>       payment_data
. . . . . . . . . . . . . )>   FROM films f
. . . . . . . . . . . . . )>     INNER JOIN
. . . . . . . . . . . . . )>    (SELECT c.`First Name` first_name,
. . . . . . . . . . . . . )>       c.`Last Name` last_name,
. . . . . . . . . . . . . )>       flatten(c.Rentals) rental_data
. . . . . . . . . . . . . )>     FROM customers c
. . . . . . . . . . . . . )>    ) cust_data
. . . . . . . . . . . . . )>     ON f._id = cust_data.rental_data.filmID
. . . . . . . . . . . . . )>   WHERE f.Rating IN ('G','PG')
. . . . . . . . . . . . . )>  ) cust_payments
. . . . . . . . . . . . . )> GROUP BY first_name, last_name
. . . . . . . . . . . . . )> HAVING
. . . . . . . . . . . . . )>   sum(cast(cust_payments.payment_data.Amount
. . . . . . . . . . . . . )>         as decimal(4,2))) > 80;

apache drill (mongo.sakila)> SELECT first_name, last_name,
. . . . . . . . . . . . . )>   sum(cast(cust_payments.payment_data.Amount
. . . . . . . . . . . . . )>         as decimal(4,2))) tot_payments
. . . . . . . . . . . . . )> FROM
. . . . . . . . . . . . . )>  (SELECT cust_data.first_name,
. . . . . . . . . . . . . )>     cust_data.last_name,
. . . . . . . . . . . . . )>     f.Rating,
. . . . . . . . . . . . . )>     flatten(cust_data.rental_data.Payments)
. . . . . . . . . . . . . )>       payment_data
. . . . . . . . . . . . . )>   FROM mysql.sakila.film f
. . . . . . . . . . . . . )>     INNER JOIN
. . . . . . . . . . . . . )>    (SELECT c.`First Name` first_name,
. . . . . . . . . . . . . )>       c.`Last Name` last_name,
. . . . . . . . . . . . . )>       flatten(c.Rentals) rental_data
. . . . . . . . . . . . . )>     FROM mongo.sakila.customers c
. . . . . . . . . . . . . )>    ) cust_data
. . . . . . . . . . . . . )>     ON f.film_id =
. . . . . . . . . . . . . )>       cast(cust_data.rental_data.filmID as integer)
. . . . . . . . . . . . . )>   WHERE f.rating IN ('G','PG')
. . . . . . . . . . . . . )>  ) cust_payments
. . . . . . . . . . . . . )> GROUP BY first_name, last_name
. . . . . . . . . . . . . )> HAVING
. . . . . . . . . . . . . )>   sum(cast(cust_payments.payment_data.Amount
. . . . . . . . . . . . . )>         as decimal(4,2))) > 80;

