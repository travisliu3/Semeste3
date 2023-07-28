-- ***********************
-- Name: Nivedita Sharma
-- ID: 138647201
-- Date: 14 November, 2022
-- Purpose: Lab 6 DBS311
-- ***********************

-- Q1
CREATE OR REPLACE PROCEDURE cal_salarydbs311_233zee14(emp_id IN NUMBER)
AS
t_years NUMBER;
f_name VARCHAR2(30 BYTE);
l_name VARCHAR2(30 BYTE);
salary NUMBER(10,2) := 10000;
BEGIN
SELECT first_name , last_name , round(months_between(TO_DATE(sysdate), TO_DATE(hire_date))/12,1)
INTO f_name , l_name , t_years
FROM employees
WHERE emp_id = employee_ID;
FOR i IN 1..t_years
LOOP
salary := salary * 1.05;
END LOOP;
DBMS_OUTPUT.PUT_LINE('First Name: '|| f_name);
DBMS_OUTPUT.PUT_LINE('Last Name: '|| l_name);
DBMS_OUTPUT.PUT_LINE ('Salary: '|| salary);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE(emp_id || 'does not exist');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error!');
END cal_salarydbs311_233zee14;
/

BEGIN
  cal_salarydbs311_233zee14(&EmployeeID);
END;
/


-- Q2
CREATE OR REPLACE PROCEDURE city_department (cityName IN VARCHAR2) AS
BEGIN
    DECLARE
        d_dep departments%rowtype;
        CURSOR d_depat IS
            SELECT d.department_id, department_name,manager_id,d.location_id
            FROM departments d JOIN locations l ON d.location_id = l.location_id
            WHERE UPPER(l.city) = UPPER(cityName);
        BEGIN
            OPEN d_depat;
            LOOP
                FETCH d_depat INTO d_dep;
                EXIT WHEN d_depat%notfound;
                DBMS_OUTPUT.PUT_LINE ('Department_id: ' || d_dep.department_id);
                DBMS_OUTPUT.PUT_LINE ('Department_name: ' || d_dep.department_name);
            END LOOP;
            CLOSE d_depat;
        END;
END city_department;
/

BEGIN
  city_department('&cityName');
END;
/


-- Q3
CREATE OR REPLACE PROCEDURE emp_wo_heddbs311_223zee31 AS
        lname   VARCHAR2(20 BYTE);
        emp_id  NUMBER;
        depat_name  VARCHAR2(30 BYTE);
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Employee #		Last Name		Department Name');
            FOR x IN 31 .. 105 LOOP
                SELECT employee_id, last_name, department_name
                INTO emp_id, lname, depat_name
                FROM employees JOIN departments USING (department_id)
                WHERE x = employee_id;
                IF depat_name = null THEN 
                    DBMS_OUTPUT.PUT_LINE(emp_id || '    	     	' || lname || '	    	no department name');
                ELSE
                    DBMS_OUTPUT.PUT_LINE(emp_id || '    		    ' || lname || '	    	' || depat_name);
                END IF;
            END LOOP;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('END of File!!!');
END emp_wo_heddbs311_223zee31;
/

BEGIN
  emp_wo_heddbs311_223zee31();
END;
/