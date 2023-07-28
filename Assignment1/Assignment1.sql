SELECT c.cust_no, cname, address1, city, o.order_no, p.prod_name, concat('$',SUM(p.prod_sell)) AS "$ Sales"
FROM customers c JOIN orders o on o.cust_no = c.cust_no JOIN orderlines ol ON ol.order_no = o.order_no JOIN products p ON p.prod_no = ol.prod_no JOIN countries cr ON cr.country_id = c.country_cd
WHERE (UPPER(cr.country_name) = UPPER('United States Of America') AND substr(c.city, 0, 1) = 'L') OR
    ((UPPER(c.country_cd) = UPPER('AU') AND substr(c.city, 0, 1) = 'P'))
GROUP BY c.cust_no, cname, address1, city, o.order_no, p.prod_name
ORDER BY cust_no DESC;

SELECT DISTINCT(o.order_no), c.cust_no, cname, address1, city
FROM customers c JOIN orders o ON c.cust_no = o.cust_no JOIN orderlines ol ON ol.order_no = o.order_no JOIN products p ON p.prod_no = ol.prod_no
WHERE (p.prod_no = 40300 OR p.prod_no = 40500 OR p.prod_no = 50200 OR p.prod_no = 60201 OR p.prod_no = 60101 OR p.prod_no = 60104 OR p.prod_no = 60103)
    AND INSTR(UPPER(cname), UPPER('Out')) > 0
ORDER BY o.order_no;

SELECT cust_no, cname, country_cd
FROM customers
WHERE UPPER(country_cd) = UPPER('US') AND cust_no > 1120;

SELECT order_dt, COUNT(order_dt)
FROM orders
WHERE SUBSTR(order_dt, 8, 11) = '2019' OR SUBSTR(order_dt, 8, 11) = '2020' OR SUBSTR(order_dt, 8, 11) = '2021'
GROUP BY order_dt;

SELECT c.cust_no, cname, address1, city, o.order_no, COUNT(price)
FROM customers c JOIN orders o ON c.cust_no = o.cust_no JOIN orderlines ol ON ol.order_no = o.order_no
WHERE SUBSTR(UPPER(city), 0, 2) = UPPER('to')
GROUP BY c.cust_no, cname, address1, city, o.order_no
ORDER BY COUNT(price) DESC;

SELECT c.cust_no, cname, address1, city, country_name
FROM customers c JOIN countries cr ON c.country_cd = cr.country_id JOIN orders o ON o.cust_no = c.cust_no
WHERE (UPPER(country_name) = UPPER('Mexico') OR UPPER(country_name) = UPPER('Germany') OR
    UPPER(country_name) = UPPER('Canada') OR UPPER(country_name) = UPPER('Belgium') OR
    UPPER(country_name) = UPPER('Spain') OR UPPER(country_name) = UPPER('Austria')) AND
    SUBSTR(order_dt, 8, 11) = '2019';

SELECT d.department_id, job_id, MIN(salary)
FROM departments d JOIN employees e ON e.department_id = d.department_id
WHERE (salary BETWEEN 5000 AND 15000) AND INSTR(UPPER(job_id), UPPER('rep')) = 0 AND
    UPPER(department_name) != UPPER('IT') AND e.department_id != 110
GROUP BY d.department_id, job_id
ORDER BY d.department_id, job_id;

SELECT cust_no, cname
FROM customers
WHERE cust_no NOT IN (SELECT cust_no
                        FROM orders);

SELECT cust_no, cname, country_name
FROM customers c JOIN countries co ON c.country_cd = co.country_id
WHERE (SUBSTR(UPPER(cname), 0,1) = UPPER('A') OR SUBSTR(UPPER(cname), 0,1) = UPPER('B') OR SUBSTR(UPPER(cname), 0,1) = UPPER('C')) AND
    country_name IN (SELECT country_name
                    FROM customers c JOIN countries co ON c.country_cd = co.country_id
                    WHERE SUBSTR(UPPER(cname), 0, 3) = UPPER('OUT'));

SELECT e.last_name, e2.last_name
FROM employees e RIGHT JOIN employees e2 ON e.employee_id = e2.manager_id;

SELECT e.last_name, COUNT(e2.last_name)
FROM employees e RIGHT JOIN employees e2 ON e.employee_id = e2.manager_id
GROUP BY e.last_name
HAVING COUNT(e2.last_name) > 2
ORDER BY COUNT(e2.last_name) DESC;

SELECT e.first_name, e.last_name,salary, 'C', SUM(((price * qty)-(price * qty*disc_perc/100)) * commission_pct)
FROM employees e JOIN orders o ON o.rep_no = e.employee_id JOIN orderlines ol ON ol.order_no = o.order_no
WHERE salary <ALL (SELECT highest_sal
            FROM job_grades
            WHERE grade = 'C') AND salary >ALL (SELECT lowest_sal
                                                FROM job_grades
                                                WHERE grade = 'C')
GROUP BY  e.first_name, e.last_name, salary
HAVING SUM(((price * qty)-(price * qty*disc_perc/100)) * commission_pct) > 20000
ORDER BY salary;