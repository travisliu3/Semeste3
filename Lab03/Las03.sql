SELECT prod_no, prod_name, qoh
FROM products
WHERE qoh > (SELECT qoh
            FROM products
            WHERE prod_name = 'Sun Shelter-8')
ORDER BY qoh DESC;

SELECT last_name, salary
FROM employees
WHERE salary = (SELECT MIN(salary)
                FROM employees)
ORDER BY last_name;
                
SELECT prod_no, prod_name, prod_type, prod_sell
FROM products p1
WHERE prod_sell IN (SELECT MAX(prod_sell)
                    FROM products p2
                    WHERE p1.prod_type = p2.prod_type
                    GROUP BY prod_type)
ORDER BY prod_type;
                    
SELECT prod_line, prod_sell
FROM products
WHERE prod_sell IN (SELECT MAX(prod_sell)
                    FROM products);
                    
SELECT prod_name, prod_sell
FROM products
WHERE (UPPER(prod_type) = UPPER('sport wear')) AND
    (prod_sell < ANY (SELECT MIN(prod_sell)
                FROM products
                GROUP BY prod_type))
ORDER BY prod_sell DESC, prod_name;

SELECT prod_no, prod_name, prod_type
FROM products
WHERE prod_type = (SELECT prod_type
                    FROM products
                    WHERE prod_sell = (SELECT MAX(prod_sell)
                                        FROM products));
                                        
SELECT TO_CHAR( CURRENT_DATE + 1, 'Month  DD"th of year" YYYY' )
FROM dual;

SELECT city, country_id, NVL(state_province, 'State Missing')
FROM locations
WHERE (SUBSTR(city, 0, 1) = LOWER('s')) AND
(LENGTH(city) >= 8);