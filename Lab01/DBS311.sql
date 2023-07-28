SELECT employee_id, first_name||' '||last_name AS "Full Name", hire_date
FROM employees
WHERE hire_date BETWEEN '16-06-01' AND '16-12-31'
ORDER BY hire_date DESC, last_name;

SELECT sysdate + 7 AS "Next Week"
FROM DUAL;

SELECT prod_no, prod_name, prod_sell, ROUND(prod_sell+(prod_sell*5/100))
FROM products
WHERE prod_no BETWEEN 50000 AND 60500
AND (UPPER(SUBSTR(prod_name,0,1)) = 'M'
OR UPPER(SUBSTR(prod_name,0,1)) = 'G'
OR UPPER(SUBSTR(prod_name,0,2)) = 'PR');

SELECT job_id, first_name||' '||last_name
FROM employees
WHERE UPPER(job_id) = UPPER('SA_REP')
AND UPPER(first_name) = UPPER('Dave')
AND UPPER(last_name) = UPPER('Mustain');

SELECT last_name||', '||first_name || ' is employed as a ' || job_id
FROM employees
WHERE manager_id = 124 OR manager_id = 125 OR manager_id = 126;

SELECT last_name, hire_date,
TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 12), 'TUESDAY'),'fmDAY, Month "the" Ddspth "of", YYYY') as "REVIEW DAY"
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') > 2018;

SELECT last_name, hire_date,
trunc((sysdate - hire_date)/365, 1)
FROM employees
ORDER BY trunc((sysdate - hire_date)/365, 1);