Select job_id AS "Liu", COUNT(*)
FROM employees
GROUP BY job_id
ORDER BY job_id;

SELECT cname, NVL(COUNT(o.cust_no), 0)
FROM customers c FULL OUTER JOIN orders o on c.cust_no = o.cust_no
GROUP BY cname
HAVING UPPER(SUBSTR(cname, 0, 1)) = UPPER('E') OR
UPPER(SUBSTR(cname, 0, 1)) = UPPER('A') OR
UPPER(SUBSTR(cname, 0, 1)) = UPPER('D')
ORDER BY COUNT(o.cust_no) DESC;

SELECT	TRUNC(AVG(salary), 2), MIN(salary), MAX(salary), MAX(salary) - MIN(salary)
FROM employees;

SELECT cname, address1, city, SUM(price * qty)
FROM customers c JOIN
orders o on c.cust_no = o.cust_no JOIN
ORDERLINES n on o.order_no = n.order_no
GROUP BY cname, address1, city
HAVING SUM(price * qty) > 70000
ORDER BY SUM(price * qty);

SELECT c.cust_no, cname, address1, SUM(price * qty), COUNT(o.cust_no)
FROM customers c JOIN
orders o on c.cust_no = o.cust_no JOIN
ORDERLINES n on o.order_no = n.order_no
GROUP BY c.cust_no, cname, address1, city
ORDER BY COUNT(o.cust_no);

SELECT c.cust_no, cname, address1, SUM(price * qty), COUNT(o.cust_no)
FROM customers c LEFT JOIN
orders o on c.cust_no = o.cust_no LEFT JOIN
ORDERLINES n on o.order_no = n.order_no
WHERE cname LIKE '%D%'
GROUP BY c.cust_no, cname, address1, city
ORDER BY SUM(price * qty);