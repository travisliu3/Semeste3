SELECT country_name
FROM countries
WHERE country_name LIKE '%g%';

SELECT city
FROM locations
MINUS
SELECT city
FROM customers;


SELECT prod_type, COUNT(prod_type)
FROM products
WHERE prod_type = 'Sleeping Bags'
GROUP BY prod_type
UNION
SELECT prod_type, COUNT(prod_type)
FROM products
WHERE prod_type = 'Tents'
GROUP BY prod_type
UNION
SELECT prod_type, COUNT(prod_type)
FROM products
WHERE prod_type = 'Sunblock'
GROUP BY prod_type;


SELECT employee_id, job_id
FROM employees
UNION
SELECT employee_id, job_id
FROM job_history;