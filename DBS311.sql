Rem Creation Script for Oracle courses by ron tarr
Rem
rem  made up of 2 parts NAME  "demobld10g.sql" - Drops and then Creates SIX tables for DEMO schema 
Rem  needed for SQL Notes material in Version 11 onward
Rem  This set is a SUBSET of tables and data in the Human Resources or HR schema
Rem
Rem  Added reps from CMC to employees table in 2021
Rem
Rem  Added other SQL from CMC covering ORDERS, PRODUCTS, ORDERLINES, CUSTOMERS
Rem  Later added Rep numbers to customers
Rem
Rem    This PART of script will drop all SEQUENCES and TABLES related to DEMO schema
Rem    If this is the first time running, these DROPS will cause errors as no such sequence exists
Rem
Rem  This script new for 2022-1 for dbs211 and dbs311


SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 200  
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 200 
SET ECHO OFF

PAUSE There will be errors for first time loading as you do not have the tables we are dropping
/* 
NOTE: The first time through there will be errors for the beginning as no sequences or tables exist
to be able to drop
*/
DROP SEQUENCE locations_seq;
DROP SEQUENCE departments_seq;
DROP SEQUENCE employees_seq;

DROP TABLE countries CASCADE CONSTRAINTS;
DROP TABLE locations CASCADE CONSTRAINTS;
DROP TABLE departments CASCADE CONSTRAINTS;
DROP TABLE employees   CASCADE CONSTRAINTS;
DROP TABLE job_grades;
DROP TABLE job_history;

/* This should be the end of the errors */

Rem
Rem      This PART of the script creates SIX tables, populates data, adds associated constraints
Rem      and indexes for the DEMO user.
Rem

REM ********************************************************************
REM Create the COUNTRIES table to hold country information for customers
REM and company locations. 
REM LOCATIONS have a foreign key to this table.

Prompt ******  Creating COUNTRIES table ....

CREATE TABLE countries 
    ( country_id      CHAR(2) 
       CONSTRAINT  country_id_nn NOT NULL 
    , country_name    VARCHAR2(30) 
    , region_id       NUMBER 
    , CONSTRAINT     country_c_id_pk 
        	     PRIMARY KEY (country_id) 
    ) 
    ORGANIZATION INDEX; 


REM ********************************************************************
REM Create the LOCATIONS table to hold address information for company departments.
REM DEPARTMENTS has a foreign key to this table.

Prompt ******  Creating LOCATIONS table ....

CREATE TABLE locations
    ( location_id    NUMBER(4)
    , street_address VARCHAR2(40)
    , postal_code    VARCHAR2(12)
    , city       VARCHAR2(30)
	CONSTRAINT     loc_city_nn  NOT NULL
    , state_province VARCHAR2(25)
    , country_id     CHAR(2)
    ) ;

CREATE UNIQUE INDEX loc_id_pk
ON locations (location_id) ;

ALTER TABLE locations
ADD ( CONSTRAINT loc_id_pk
       		 PRIMARY KEY (location_id)
        ) ;

Rem 	Useful for any subsequent addition of rows to locations table
Rem 	Starts with 3300

CREATE SEQUENCE locations_seq
 START WITH     3300
 INCREMENT BY   100
 MAXVALUE       9900
 NOCACHE
 NOCYCLE;


REM ********************************************************************
REM Create the DEPARTMENTS table to hold company department information.
REM EMPLOYEES  has a foreign key to this table.

Prompt ******  Creating DEPARTMENTS table ....

CREATE TABLE departments
    ( department_id    NUMBER(4)
    , department_name  VARCHAR2(30)
	CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       NUMBER(6)
    , location_id      NUMBER(4)
    ) ;

CREATE UNIQUE INDEX dept_id_pk
ON departments (department_id) ;

ALTER TABLE departments
ADD ( CONSTRAINT dept_id_pk
       		 PRIMARY KEY (department_id)
         ) ;

Rem 	Useful for any subsequent addition of rows to departments table
Rem 	Starts with 280 

CREATE SEQUENCE departments_seq
 START WITH     280
 INCREMENT BY   10
 MAXVALUE       9990
 NOCACHE
 NOCYCLE;


REM ********************************************************************
REM Create the EMPLOYEES table to hold the employee personnel 
REM information for the company.
REM EMPLOYEES has a self referencing foreign key to this table.

Prompt ******  Creating EMPLOYEES table ....

CREATE TABLE employees
    ( employee_id    NUMBER(6)
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25)
	 CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR2(25)
	CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE
	CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR2(10)
	CONSTRAINT     emp_job_nn  NOT NULL
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6)
    , department_id  NUMBER(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;

CREATE UNIQUE INDEX emp_emp_id_pk
ON employees (employee_id) ;


ALTER TABLE employees
ADD ( CONSTRAINT     emp_emp_id_pk
                     PRIMARY KEY (employee_id)
    , CONSTRAINT     emp_dept_fk
                     FOREIGN KEY (department_id)
                      REFERENCES departments
    , CONSTRAINT     emp_manager_fk
                     FOREIGN KEY (manager_id)
                      REFERENCES employees
    ) ;

ALTER TABLE departments
ADD ( CONSTRAINT dept_mgr_fk
      		 FOREIGN KEY (manager_id)
      		  REFERENCES employees (employee_id)
    ) ;


Rem 	Useful for any subsequent addition of rows to employees table
Rem 	Starts with 207 


CREATE SEQUENCE employees_seq
 START WITH     207
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;


REM ********************************************************************
REM Create the JOB_GRADES table that will show different SALARY GRADES 
REM depending on employee's SALARY RANGE

Prompt ******  Creating JOB_GRADES table ....

CREATE TABLE job_grades (
grade 		CHAR(1),
lowest_sal 	NUMBER(8,2) NOT NULL,
highest_sal	NUMBER(8,2) NOT NULL
);

ALTER TABLE job_grades
ADD CONSTRAINT jobgrades_grade_pk PRIMARY KEY (grade);


rem This PART of script will populate script for the DEMO account
rem
rem NOTES There is a circular foreign key reference between 
rem       EMPLOYEES and DEPARTMENTS. That is why we disable
rem       the FK constraints here
rem

SET VERIFY OFF

REM ***************************insert data into the COUNTRIES table

Prompt ******  Populating COUNTRIES table ....

INSERT INTO countries VALUES 
        ( 'IT'
        , 'Italy'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'JP'
        , 'Japan'
	, 3 
        );

INSERT INTO countries VALUES 
        ( 'US'
        , 'United States of America'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CA'
        , 'Canada'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CN'
        , 'China'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'IN'
        , 'India'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'AU'
        , 'Australia'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'ZW'
        , 'Zimbabwe'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'SG'
        , 'Singapore'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'UK'
        , 'United Kingdom'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'FR'
        , 'France'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'DE'
        , 'Germany'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'ZM'
        , 'Zambia'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'EG'
        , 'Egypt'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'BR'
        , 'Brazil'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CH'
        , 'Switzerland'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'NL'
        , 'Netherlands'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'MX'
        , 'Mexico'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'KW'
        , 'Kuwait'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'IL'
        , 'Israel'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'DK'
        , 'Denmark'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'HK'
        , 'HongKong'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'NG'
        , 'Nigeria'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'AR'
        , 'Argentina'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'BE'
        , 'Belgium'
        , 1 
        );


REM ***************************insert data into the LOCATIONS table

Prompt ******  Populating LOCATIONS table ....

INSERT INTO locations VALUES 
        ( 1000 
        , '1297 Via Cola di Rie'
        , '00989'
        , 'Roma'
        , NULL
        , 'IT'
        );

INSERT INTO locations VALUES 
        ( 1100 
        , '93091 Calle della Testa'
        , '10934'
        , 'Venice'
        , NULL
        , 'IT'
        );

INSERT INTO locations VALUES 
        ( 1200 
        , '2017 Shinjuku-ku'
        , '1689'
        , 'Tokyo'
        , 'Tokyo Prefecture'
        , 'JP'
        );

INSERT INTO locations VALUES 
        ( 1300 
        , '9450 Kamiya-cho'
        , '6823'
        , 'Hiroshima'
        , NULL
        , 'JP'
        );

INSERT INTO locations VALUES 
        ( 1400 
        , '2014 Jabberwocky Rd'
        , '26192'
        , 'Southlake'
        , 'Texas'
        , 'US'
        );

INSERT INTO locations VALUES 
        ( 1500 
        , '2011 Interiors Blvd'
        , '99236'
        , 'south San Francisco'
        , 'California'
        , 'US'
        );

INSERT INTO locations VALUES 
        ( 1600 
        , '2007 Zagora St'
        , '50090'
        , 'South Brunswick'
        , 'New Jersey'
        , 'US'
        );

INSERT INTO locations VALUES 
        ( 1700 
        , '2004 Charade Rd'
        , '98199'
        , 'Seattle'
        , 'Washington'
        , 'US'
        );

INSERT INTO locations VALUES 
        ( 1800 
        , '147 Spadina Ave'
        , 'M5V 2L7'
        , 'Toronto'
        , 'Ontario'
        , 'CA'
        );

INSERT INTO locations VALUES 
        ( 1900 
        , '6092 Boxwood St'
        , 'YSW 9T2'
        , 'Whitehorse'
        , 'Yukon'
        , 'CA'
        );

INSERT INTO locations VALUES 
        ( 2000 
        , '40-5-12 Laogianggen'
        , '190518'
        , 'Beijing'
        , NULL
        , 'CN'
        );

INSERT INTO locations VALUES 
        ( 2100 
        , '1298 Vileparle (E)'
        , '490231'
        , 'Bombay'
        , 'Maharashtra'
        , 'IN'
        );

INSERT INTO locations VALUES 
        ( 2200 
        , '12-98 Victoria Street'
        , '2901'
        , 'Sydney'
        , 'New South Wales'
        , 'AU'
        );

INSERT INTO locations VALUES 
        ( 2300 
        , '198 Clementi North'
        , '540198'
        , 'Singapore'
        , NULL
        , 'SG'
        );

INSERT INTO locations VALUES 
        ( 2400 
        , '8204 Arthur St'
        , NULL
        , 'London'
        , NULL
        , 'UK'
        );

INSERT INTO locations VALUES 
        ( 2500 
        , 'Magdalen Centre, The Oxford Science Park'
        , 'OX9 9ZB'
        , 'Oxford'
        , 'Oxford'
        , 'UK'
        );

INSERT INTO locations VALUES 
        ( 2600 
        , '9702 Chester Road'
        , '09629850293'
        , 'Stretford'
        , 'Manchester'
        , 'UK'
        );

INSERT INTO locations VALUES 
        ( 2700 
        , 'Schwanthalerstr. 7031'
        , '80925'
        , 'Munich'
        , 'Bavaria'
        , 'DE'
        );

INSERT INTO locations VALUES 
        ( 2800 
        , 'Rua Frei Caneca 1360 '
        , '01307-002'
        , 'Sao Paulo'
        , 'Sao Paulo'
        , 'BR'
        );

INSERT INTO locations VALUES 
        ( 2900 
        , '20 Rue des Corps-Saints'
        , '1730'
        , 'Geneva'
        , 'Geneve'
        , 'CH'
        );

INSERT INTO locations VALUES 
        ( 3000 
        , 'Murtenstrasse 921'
        , '3095'
        , 'Bern'
        , 'BE'
        , 'CH'
        );

INSERT INTO locations VALUES 
        ( 3100 
        , 'Pieter Breughelstraat 837'
        , '3029SK'
        , 'Utrecht'
        , 'Utrecht'
        , 'NL'
        );

INSERT INTO locations VALUES 
        ( 3200 
        , 'Mariano Escobedo 9991'
        , '11932'
        , 'Mexico City'
        , 'Distrito Federal,'
        , 'MX'
        );


REM ****************************insert data into the DEPARTMENTS table

Prompt ******  Populating DEPARTMENTS table ....

REM disable integrity constraint to EMPLOYEES to load data

ALTER TABLE departments 
  DISABLE CONSTRAINT dept_mgr_fk;

INSERT INTO departments VALUES 
        ( 10
        , 'Admin'   
        , 200
        , 1700
        );

INSERT INTO departments VALUES 
        ( 20
        , 'Marketing'
        , 201
        , 1800
        );
                                
INSERT INTO departments VALUES 
        ( 50
        , 'Shipping'
        , 124
        , 1500
        );
                
INSERT INTO departments VALUES 
        ( 60 
        , 'IT'
        , 103
        , 1400
        );
                              
INSERT INTO departments VALUES 
        ( 80 
        , 'Sales'
        , 149
        , 2500
        );
                
INSERT INTO departments VALUES 
        ( 90 
        , 'Executive'
        , 100
        , 1700
        );
               
INSERT INTO departments VALUES 
        ( 110 
        , 'Accounting'
        , 205
        , 1700
        );

INSERT INTO departments VALUES 
        ( 190 
        , 'Contracting'
        , NULL
        , 1700
        );
INSERT INTO departments VALUES 
	( 200
	, 'Actuarial'
	, 149
	,1700
	);
REM ***************************insert data into the EMPLOYEES table

Prompt ******  Populating EMPLOYEES table ....

INSERT INTO employees VALUES 
        ( 100
        , 'Steven'
        , 'King'
        , 'SKING'
        , '515.123.4567'
        , TO_DATE('17-JUN-1987', 'dd-MON-yyyy')
        , 'PRES' 
        , 28000
        , NULL
        , NULL
        , 90
        );

INSERT INTO employees VALUES 
        ( 101
        , 'Neena'
        , 'Kochhar'
        , 'NKOCHHAR'
        , '515.123.4568'
        , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
        , 'AD_VP'
        , 18000
        , NULL
        , 100
        , 90
        );

INSERT INTO employees VALUES 
        ( 102
        , 'Lex'
        , 'De Haan'
        , 'LDEHAAN'
        , '515.123.4569'
        , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO employees VALUES 
        ( 103
        , 'Alexander'
        , 'Hunold'
        , 'AHUNOLD'
        , '590.423.4567'
        , TO_DATE('03-JAN-1990', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 9000
        , NULL
        , 102
        , 60
        );

INSERT INTO employees VALUES 
        ( 104
        , 'Bruce'
        , 'Ernst'
        , 'BERNST'
        , '590.423.4568'
        , TO_DATE('21-MAY-1991', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 8000
        , NULL
        , 103
        , 60
        );

INSERT INTO employees VALUES 
        ( 107
        , 'Diana'
        , 'Lorentz'
        , 'DLORENTZ'
        , '590.423.5567'
        , TO_DATE('07-FEB-1999', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 5200
        , NULL
        , 103
        , 60
        );

INSERT INTO employees VALUES 
        ( 124
        , 'Kevin'
        , 'Mourgos'
        , 'KMOURGOS'
        , '650.123.5234'
        , TO_DATE('16-NOV-1999', 'dd-MON-yyyy')
        , 'ST_MAN'
        , 6800
        , NULL
        , 100
        , 50
        );

INSERT INTO employees VALUES 
        ( 141
        , 'Trenna'
        , 'Rajs'
        , 'TRAJS'
        , '650.121.8009'
        , TO_DATE('17-OCT-1995', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 3500
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 142
        , 'Curtis'
        , 'Davies'
        , 'CDAVIES'
        , '650.121.2994'
        , TO_DATE('29-JAN-1997', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 3400
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 143
        , 'Randall'
        , 'Matos'
        , 'RMATOS'
        , '650.121.2874'
        , TO_DATE('15-MAR-1998', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 2900
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 144
        , 'Peter'
        , 'Vargas'
        , 'PVARGAS'
        , '650.121.2004'
        , TO_DATE('09-JUL-1998', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 2900
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 149
        , 'Elena'
        , 'Zlotkey'
        , 'EZLOTKEY'
        , '011.44.1344.429018'
        , TO_DATE('29-JAN-2000', 'dd-MON-yyyy')
        , 'SA_MAN'
        , 12500
        , .2
        , 100
        , 80
        );

INSERT INTO employees VALUES 
        ( 174
        , 'Ellen'
        , 'Abel'
        , 'EABEL'
        , '011.44.1644.429267'
        , TO_DATE('11-MAY-1996', 'dd-MON-yyyy')
        , 'SA_REP'
        , 11000
        , .30
        , 149
        , 80
        );

INSERT INTO employees VALUES 
        ( 176
        , 'Jonathon'
        , 'Vargas'
        , 'JVARGAS'
        , '011.44.1644.429265'
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , 'SA_REP'
        , 8600
        , .20
        , 149
        , 80
        );

INSERT INTO employees VALUES 
        ( 178
        , 'Kimberely'
        , 'Grants'
        , 'KGRANTS'
        , '011.44.1644.429263'
        , TO_DATE('24-MAY-1999', 'dd-MON-yyyy')
        , 'SA_REP'
        , 8000
        , .15
        , 149
        , NULL
        );

INSERT INTO employees VALUES 
        ( 180
        , 'Spence'
        , 'de Man'
        , 'SDEMAN'
        , '011.44.1644.420172'
        , TO_DATE('08-MAY-2017', 'dd-MON-yyyy')
        , 'SA_REP'
        , 7000
        , .15
        , 149
        , NULL
        );

INSERT INTO employees VALUES 
        ( 200
        , 'Jennifer'
        , 'Whalen'
        , 'JWHALEN'
        , '515.123.4444'
        , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
        , 'AD_ASST'
        , 4500
        , NULL
        , 101
        , 10
        );

INSERT INTO employees VALUES 
        ( 201
        , 'Michael'
        , 'Hartstein'
        , 'MHARTSTE'
        , '515.123.5555'
        , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
        , 'MK_MAN'
        , 13000
        , NULL
        , 100
        , 20
        );

INSERT INTO employees VALUES 
        ( 202
        , 'Pat'
        , 'Fay'
        , 'PFAY'
        , '603.123.6666'
        , TO_DATE('17-AUG-1997', 'dd-MON-yyyy')
        , 'MK_REP'
        , 7000
        , NULL
        , 201
        , 20
        );

INSERT INTO employees VALUES 
        ( 205
        , 'Shelley'
        , 'Higgins'
        , 'SHIGGINS'
        , '515.123.8080'
        , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
        , 'AC_MGR'
        , 12000
        , NULL
        , 101
        , 110
        );

INSERT INTO employees VALUES 
        ( 206
        , 'William'
        , 'Gietz'
        , 'WGIETZ'
        , '515.123.8181'
        , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
        , 'AC_ACCOUNT'
        , 8300
        , NULL
        , 205
        , 110
        );


REM ********************************
REM ********************************
REM reps from CMC added
REM *******************************

REM add these sales reps 20183

REM ***************************************
INSERT INTO employees VALUES 
(1
,'Bjorn'
, 'Flerjian'
,'BFLERJIAN'
, '414.111.4567'
, TO_DATE('11-JAN-2011', 'dd-MON-yyyy')
,'AC_REP'
, 12000
, NULL
, 149
, 10
);
INSERT INTO employees VALUES 
 (3
, 'Gus'
 ,'Grolin'
,'GGROLIN'
, '429.311.4567'
, TO_DATE('23-MAR-2019', 'dd-MON-yyyy')
,'SA_REP'
, 10500
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(4
, 'Bill'
,'Smertal'
,'BSMERTAL'
, '404.311.4567'
, TO_DATE('24-MAR-2014', 'dd-MON-yyyy')
,'SA_REP'
, 9300
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(5
,'Dave'
,'Mustain'
,'DMUSTAIN'
, '405.511.4567'
, TO_DATE('25-MAY-2021', 'dd-MON-yyyy')
,'SA_REP'
, 9600
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(6
,'Henry'
,'Harvey'
,'HHARVEY'
, '406.616.4567'
, TO_DATE('06-June-2018', 'dd-MON-yyyy')
,'SA_REP'
, 7000
, .25
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(7
,'Henri'
,'LeDuc'
,'HLEDUC'
, '427.711.4567'
, TO_DATE('27-JUL-2016', 'dd-MON-yyyy')
,'SA_REP'
, 7000
, .25
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(8
,'Conrad'
,'Bergsteige'
,'CBERGSTEIGE'
, '429.881.4567'
, TO_DATE('08-AUG-2016', 'dd-MON-yyyy')
,'SA_REP'
, 8000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(9
,'Kurt'
,'Gruber'
,'KGRUBER'
, '429.309.9032'
, TO_DATE('29-SEP-2019', 'dd-MON-yyyy')
,'SA_REP'
, 9000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(11
,'Miguel'
,'Sanchez'
, 'MSANCHEZ'
, '429.311.4511'
, TO_DATE('11-OCT-2017', 'dd-MON-yyyy')
,'SA_REP'
, 10500
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(12
,'Dan'
,'Chancevente'
,'DCHANCE'
, '429.312.4567'
, TO_DATE('12-MAR-2007', 'dd-MON-yyyy')
,'SA_REP'
, 12000
, .15
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(14
,'Greg'
,'Torson'
,'GTORSON'
, '429.311.4567'
, TO_DATE('14-FEB-2014', 'dd-MON-yyyy')
,'SA_REP'
, 7000
, .20
, 149
, 80
);


INSERT INTO EMPLOYEES VALUES
(15
,'Chris'
,'Cornel'
,'CCORNEL'
, '415.315.4567'
, TO_DATE('15-MAR-2021', 'dd-MON-yyyy')
,'SA_REP'
, 12500
, .15
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(16
,'Bil'
, 'Gibbons'
,'BGIBBONS'
, '429.311.4567'
, TO_DATE('23-MAR-2019', 'dd-MON-yyyy')
,'SA_REP'
, 11500
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(17
,'Russ'
,'Pallomine'
,'RPALLOMINE'
, '429.317.4567'
, TO_DATE('27-JUL-2017', 'dd-MON-yyyy')
,'SA_REP'
, 5000
, .20
, 149
, 80
);

INSERT INTO EMPLOYEES VALUES
(18
,'Lyn'
,'Jacobs'
,'LJACOBS'
, '429.317.4567'
, TO_DATE('18-APR-2019', 'dd-MON-yyyy')
,'SA_REP'
, 10000
, .20
, 149
, 80
);

INSERT INTO EMPLOYEES VALUES
(19
,'Sally'
,'Strandherst'
,'SSTRANDHERST'
, '519.319.4567'
, TO_DATE('19-JUL-2018', 'dd-MON-yyyy')
,'SA_REP'
, 4500
, .25
, 149
, 80
);

INSERT INTO EMPLOYEES VALUES
(21
,'Thomas'
,'Brigade'
,'TBRIGADE'
, '429.317.4567'
, TO_DATE('21-SEP-2019', 'dd-MON-yyyy')
,'SA_REP'
, 5750
, .25
, 149
, 80
);

INSERT INTO EMPLOYEES VALUES
(22
,'Jane'
,'Litrand'
,'JLITRAND'
, '429.317.4567'
, TO_DATE('22-OCT-2021', 'dd-MON-yyyy')
,'SA_REP'
, 9000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(23
,'Tony'
,'Armarillo'
,'TARMARILLO'
, '429.323.2323'
, TO_DATE('23-NOV-2021', 'dd-MON-yyyy')
,'SA_REP'
, 7500
, .20
, 149
, 80
);

INSERT INTO EMPLOYEES VALUES
(24
,'Matt'
,'Mot'
,'MMOT'
, '429.317.4567'
, TO_DATE('24-DEC-2018', 'dd-MON-yyyy')
,'SA_REP'
, 20000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(25
,'Gilles'
,'Turcotte'
,'GTURCOTTE'
, '429.317.4567'
, TO_DATE('25-JAN-2011', 'dd-MON-yyyy')
,'SA_REP'
, 10000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(26
,'Francoise'
,'LeBlanc'
,'FRLEBLANC'
, '429.317.4567'
, TO_DATE('18-APR-2019', 'dd-MON-yyyy')
,'SA_REP'
, 3700
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(27
,'Carlos'
,'Rodriguez'
,'CRODRIGUEZ'
, '429.317.4567'
, TO_DATE('27-APR-2021', 'dd-MON-yyyy')
,'SA_REP'
, 11000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(28
,'Malcom'
,'Young'
,'MYOUNG'
, '429.317.4567'
, TO_DATE('28-APR-2001', 'dd-MON-yyyy')
,'SA_REP'
, 9000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(29
,'Charles'
,'Loo Nam'
,'CLOONAM'
, '429.317.4567'
, TO_DATE('29-APR-2019', 'dd-MON-yyyy')
,'SA_REP'
, 5500
, .20
, 149
, 80
);

INSERT INTO EMPLOYEES VALUES
(30
,'Lee'
,'Chan'
,'LCHAN'
, '429.317.4567'
, TO_DATE('30-JUN-2016', 'dd-MON-yyyy')
,'SA_REP'
, 7000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(33
,'Torey'
,'Wandiko'
,'TWANDIKO'
, '429.317.4567'
, TO_DATE('18-APR-2017', 'dd-MON-yyyy')
,'SA_REP'
, 6700
, .20
, 149
, 80
);

INSERT INTO EMPLOYEES VALUES
(34
,'Kaley'
,'Gregson'
,'KGREGSON'
, '429.317.4567'
, TO_DATE('18-APR-2017', 'dd-MON-yyyy')
,'SA_REP'
,8800
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(35
,'Hari'
,'Krain'
,'HKRAIN'
, '429.317.4567'
, TO_DATE('05-APR-2021', 'dd-MON-yyyy')
,'SA_REP'
, 8700
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(36
,'Ingrid'
,'Termede'
,'ITERMEDE'
, '429.336.4536'
, TO_DATE('01-DEC-2014', 'dd-MON-yyyy')
,'SA_REP'
, 11000
, .15
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(31
,'Lee'
,'Chan'
,'LCHAN2'
, '429.317.4568'
, TO_DATE('30-JUN-2017', 'dd-MON-yyyy')
,'SA_REP'
, 7500
, .20
, 149
, 80
);

INSERT INTO EMPLOYEES VALUES
(39,
'Lisa'
,'Testorok'
,'LTESTOROK'
, '429.317.4567'
, TO_DATE('03-MAR-2019', 'dd-MON-yyyy')
,'SA_REP'
, 11000
, .15
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(40
,'Marthe'
,'Whiteduck'
,'MWHITEDUCK'
, '429.317.4540'
, TO_DATE('10-APR-2014', 'dd-MON-yyyy')
,'SA_REP'
, 9000
, .20
, 149
, 80
);
INSERT INTO EMPLOYEES VALUES
(41
,'Inigo'
,'Montoya'
,'IMONTAYA'
, '429.317.4541'
, TO_DATE('11-FEB-2019', 'dd-MON-yyyy')
,'SA_REP'
, 5000
, .30
, 149
, 80
);


COMMIT;





REM ***************************insert data into the JOB_GRADES table

Prompt ******  Populating JOB_GRADES table ....

INSERT INTO job_grades VALUES 
	('A'
	,1000
	,4999
	);

INSERT INTO job_grades VALUES 
	('B'
	,5000
	,5999
	);

INSERT INTO job_grades VALUES 
	('C'
	,6000
	,9999
	);

INSERT INTO job_grades VALUES 
	('D'
	,10000
	,15999
	);

INSERT INTO job_grades VALUES 
	('E'
	,16000
	,24999
	);

INSERT INTO job_grades VALUES 
	('F'
	,25000
	,50000
	);
INSERT INTO job_grades VALUES 
	('G'
	,50000
	,100000
	);


COMMIT;

REM enable integrity constraint to DEPARTMENTS

ALTER TABLE departments 
  ENABLE CONSTRAINT dept_mgr_fk;


REM  Creating table JOB_HISTORY and populating data

Prompt ******  Creating JOB_HISTORY table ....

CREATE TABLE job_history
    ( employee_id   NUMBER(6)
	 CONSTRAINT    jhist_employee_nn  NOT NULL
    , start_date    DATE
	CONSTRAINT    jhist_start_date_nn  NOT NULL
    , end_date      DATE
	CONSTRAINT    jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR2(10)
	CONSTRAINT    jhist_job_nn  NOT NULL
    , department_id NUMBER(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    ) ;

CREATE UNIQUE INDEX jhist_emp_id_st_date_pk 
ON job_history (employee_id, start_date) ;

ALTER TABLE job_history
ADD ( CONSTRAINT jhist_emp_id_st_date_pk
      PRIMARY KEY (employee_id, start_date)
      , CONSTRAINT     jhist_dept_fk
                     FOREIGN KEY (department_id)
                     REFERENCES departments
    ) ;

Prompt ******  Populating JOB_HISTORY table ....


INSERT INTO job_history
VALUES (102
       , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
       , TO_DATE('24-JUL-1998', 'dd-MON-yyyy')
       , 'IT_PROG'
       , 60);

INSERT INTO job_history
VALUES (101
       , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
       , TO_DATE('27-OCT-1993', 'dd-MON-yyyy')
       , 'AC_ACCOUNT'
       , 110);

INSERT INTO job_history
VALUES (101
       , TO_DATE('28-OCT-1993', 'dd-MON-yyyy')
       , TO_DATE('15-MAR-1997', 'dd-MON-yyyy')
       , 'AC_MGR'
       , 110);

INSERT INTO job_history
VALUES (201
       , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
       , TO_DATE('19-DEC-1999', 'dd-MON-yyyy')
       , 'MK_REP'
       , 20);

INSERT INTO job_history
VALUES  (114
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 50
        );

INSERT INTO job_history
VALUES  (122
        , TO_DATE('01-JAN-1999', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 50
        );

INSERT INTO job_history
VALUES  (200
        , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
        , TO_DATE('17-JUN-1993', 'dd-MON-yyyy')
        , 'AD_ASST'
        , 90
        );

INSERT INTO job_history
VALUES  (176
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1998', 'dd-MON-yyyy')
        , 'SA_REP'
        , 80
        );

INSERT INTO job_history
VALUES  (176
        , TO_DATE('01-JAN-1999', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'SA_MAN'
        , 80
        );

INSERT INTO job_history
VALUES  (200
        , TO_DATE('01-JUL-1994', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1998', 'dd-MON-yyyy')
        , 'AC_ACCOUNT'
        , 90
        );

COMMIT;

Rem
Rem    This PART will create indexes for DEMO schema
Rem

CREATE INDEX emp_department_ix
       ON employees (department_id);

CREATE INDEX emp_job_ix
       ON employees (job_id);

CREATE INDEX emp_manager_ix
       ON employees (manager_id);

CREATE INDEX emp_name_ix
       ON employees (last_name, first_name);

CREATE INDEX dept_location_ix
       ON departments (location_id);

CREATE INDEX loc_city_ix
       ON locations (city);

CREATE INDEX loc_state_province_ix	
       ON locations (state_province);

CREATE INDEX loc_country_ix
       ON locations (country_id);

Rem
Rem    This PART will create comments for DEMO schema
Rem

REM *********************************************

COMMENT ON TABLE countries
IS 'country table. Contains 25 rows. References with locations table.';

COMMENT ON COLUMN countries.country_id
IS 'Primary key of countries table.';

COMMENT ON COLUMN countries.country_name
IS 'Country name';

COMMENT ON COLUMN countries.region_id
IS 'Region ID for the country'; 

REM *********************************************

COMMENT ON TABLE locations
IS 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';

COMMENT ON COLUMN locations.location_id
IS 'Primary key of locations table';

COMMENT ON COLUMN locations.street_address
IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';

COMMENT ON COLUMN locations.postal_code
IS 'Postal code of the location of an office, warehouse, or production site 
of a company. ';

COMMENT ON COLUMN locations.city
IS 'A not null column that shows city where an office, warehouse, or 
production site of a company is located. ';

COMMENT ON COLUMN locations.state_province
IS 'State or Province where an office, warehouse, or production site of a 
company is located.';

COMMENT ON COLUMN locations.country_id
IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';


REM *********************************************

COMMENT ON TABLE departments
IS 'Departments table that shows details of departments where employees 
work. Contains 27 rows; references with locations, employees, and job_history tables.';

COMMENT ON COLUMN departments.department_id
IS 'Primary key column of departments table.';

COMMENT ON COLUMN departments.department_name
IS 'A not null column that shows name of a department. Administration, 
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
Relations, Sales, Finance, and Accounting. ';

COMMENT ON COLUMN departments.manager_id
IS 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';

COMMENT ON COLUMN departments.location_id
IS 'Location id where a department is located. Foreign key to location_id column of locations table.';


REM *********************************************

COMMENT ON TABLE employees
IS 'employees table. Contains 107 rows. References with departments, 
jobs, job_history tables. Contains a self reference.';

COMMENT ON COLUMN employees.employee_id
IS 'Primary key of employees table.';

COMMENT ON COLUMN employees.first_name
IS 'First name of the employee. A not null column.';

COMMENT ON COLUMN employees.last_name
IS 'Last name of the employee. A not null column.';

COMMENT ON COLUMN employees.email
IS 'Email id of the employee';

COMMENT ON COLUMN employees.phone_number
IS 'Phone number of the employee; includes country code and area code';

COMMENT ON COLUMN employees.hire_date
IS 'Date when the employee started on this job. A not null column.';

COMMENT ON COLUMN employees.job_id
IS 'Current job of the employee; foreign key to job_id column of the 
jobs table. A not null column.';

COMMENT ON COLUMN employees.salary
IS 'Monthly salary of the employee. Must be greater 
than zero (enforced by constraint emp_salary_min)';

COMMENT ON COLUMN employees.commission_pct
IS 'Commission percentage of the employee; Only employees in sales 
department elgible for commission percentage';

COMMENT ON COLUMN employees.manager_id
IS 'Manager id of the employee; has same domain as manager_id in 
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';

COMMENT ON COLUMN employees.department_id
IS 'Department id where employee works; foreign key to department_id 
column of the departments table';


REM ******************************************************
REM the extra tables from CMC
REM ******************************************************
REM ******************************************************
REM ******************************************************
REM ******************************************************

-- Files to use for 2022
-- need also demo
-- First drop all tables related to CMC
Drop table customers; -- 150 customers
Drop table orders; --270 orders
Drop table orderlines; -- 1225 orderlines
-- Drop table reps; -- 33 � was added to employees
Drop table suppliers; -- 2 never do any more to this table
Drop table products; -- 35 products � need to add more later

-- create tables needed

create table Customers (
cust_no		integer	PRIMARY KEY,
cname		varchar2(30),
status		char(1),
cust_type	varchar2(20),
country_cd 	char(2),
branch_cd	char(4),
address1	varchar2(35),
address2	varchar2(35),
city		varchar2(20),
prov_state	varchar2(20),
post_zip	varchar2(15),
phone_no	varchar2(20),
fax_no		varchar2(20),
contact		varchar2(25),
sales_rep       number (6,0)
);   

CREATE TABLE ORDERS (
ORDER_NO		INTEGER,
REP_NO		INTEGER,
CUST_NO		INTEGER,
ORDER_DT		CHAR(11),
STATUS		CHAR(1),
CHANNEL		VARCHAR2(15)
);   

CREATE TABLE ORDERLINES (
ORDER_NO		INTEGER,
LINE_NO		INTEGER,
PROD_NO		INTEGER,
PRICE		DECIMAL(5,2),
QTY		INTEGER,
DISC_PERC	DECIMAL(5,2)
);   

CREATE TABLE PRODUCTS (
PROD_NO	INTEGER,
PROD_LINE	VARCHAR2(20),
PROD_TYPE	VARCHAR2(20),
PROD_NAME	VARCHAR2(30),
PROD_COST	DECIMAL(5,2),
PROD_SELL	DECIMAL(5,2),
STATUS		CHAR(1),
PICTURE		VARCHAR2(10),
SALES_2016	DECIMAL(9,2),  -- old style to be dropped
SALES_2015	DECIMAL(9,2),
SALES_2014	DECIMAL(9,2),
SALES_2013	DECIMAL(9,2),
SID			INTEGER -- suppler id
);   

REM ******************************
Rem also removed all INSERT Reps - now part of employees
Rem 
Rem  CREATE TABLE REPS (
Rem  REP_NO		INTEGER,
Rem  REP_NAME		VARCHAR2(25),
Rem  QUOTA_2016	DECIMAL(9,2),
Rem  QUOTA_2015	DECIMAL(9,2),
Rem  QUOTA_2014	DECIMAL(9,2),
Rem  QUOTA_2013	DECIMAL(9,2)
Rem  );   	
Rem **************************************
	
CREATE TABLE SUPPLIERS (
SUP_NO		INTEGER,
SUP_NAME		VARCHAR2(40),
STREET		VARCHAR2(40),
CITY		VARCHAR2(25),
POST_ZIP		VARCHAR2(20),
REP_NAME		VARCHAR2(50),
PHONE		VARCHAR2(21),
TERMS		VARCHAR2(20)
);   

Rem ***************************************************
Rem ***************************************************
Rem ***************************************************
Rem ***************************************************
-- insert the data into the tables created


Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1001,'Go Outlet Montreal','A','Go Outlet','CA','MTL ','500 Place d''Armes','Suite 1061','Montreal','Quebec','H2Y 2W2','5142780993','5142789000','Martine Vachon',149);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1002,'Ultra Sports 5','A','Mass Marketer','US','BOS ','40770 Duke Drive','Suite 201','Boston','Massachusetts','01803-5235','6174450917','6172330762','Martha Burke',174);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1003,'Vacation Central 5','A','Mass Marketer','CA','VAN ','10166 Alberi Street','Suite 1505','Burnaby','British Columbia','V6E 3Z3','6046820446','6046823005','Jeffrey Vales',176);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1004,'Mountain Madness 5','A','Mass Marketer','US','SFR ','405 Stateside Gardens','Main Floor','San Francisco','California','90288-1277','4153851634','4153851275','Janet Harrison',178);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1005,'GO Outlet Boston','A','GO Outlet','US','BOS ','4053 Old Creek Road','12th Floor','Boston','Massachusetts','01803-6540','6175552345','6175553453','Donald Taylor',180);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1006,'Bergsteiger G.m.b.H.','A','Independent','DE','FRNK','L0yoner Strasse 14',null,'Frankfurt',null,'60386','49696666802','49696661061','Wolfgang Steinhammer',1);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1007,'Backwoods Equipment(Rom)','A','Independent','AU','ROM ','1020 Pacific Highway','Suite 118','Sydney','NSW','2255','6124778899','6124331542','Jake Jenkins',3);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1008,'Botanechi K.K.','A','Independent','JP','TOKY','60F Green Life Building','2-21-12 Sasazuka','Tokyo',null,'151','81353900600','81353115403','Shujimo Yamataki',4);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1009,'GO Outlet Kista AB','A','GO Outlet','SE','STOC','V0illagatan 45 II',null,'Stockholm',null,'114 57','468663442','468666775','Kirsten Johannsson',5);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1010,'Andes Camping Supplies 6','A','Camping Chain','CA','VAN ','1011 West Lane Pkwy','Ground Floor','Kelowna','British Columbia','V1V 1R1','6047732121','6041111212','Frank Bretton',6);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1011,'GO Outlet Singapore','A','GO Outlet','SG','SING','7050-D Chai Chee Rd #07','Chai Chee Industrial Pa','Singapore',null,'1646','654442988','654441866','Da Nguyen',7);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1012,'Act''N''Up Fitness 5','A','Mass Marketer','US','NY  ','5055 Mt. Lincoln Lane','7th Floor','Martinsville','Michigan','48116-6632','3137763322','3136678899','Lucy Tilson',8);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1013,'New Wave Wilderness 6','A','Camping Chain','CA','TOR ','4031 Yonge Street','Penthouse','Toronto','Ontario','M2M 4K8','4167433321','4162219761','Sherry Rowland',9);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1014,'Wally Mart 5','A','Mass Marketer','US','NY  ','6075 East 52nd St','Suite 2809','New York','New York','08092-5673','2125554522','2125557432','Greg Lightner',11);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1015,'Desert Duds and Tees 8','A','Camping Chain','US','SFR ','6072 Parkview Blvd','Suite 101','Anaheim','California','94080-3354','5102347700','5102307762','Sandra Hatley',12);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1016,'Over the Top Cycles 4','A','Mass Marketer','SE','STOC','I0safjordsgatan 30c',null,'Kista',null,'164 40','468753311','4687525992','Jan Nordstrom',14);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1017,'Rock Steady','A','Independent','US','DEN ','4064 Clear Water Avenue','Suite 102','Boulder','Colorado','80745-5565','3036216454','3036940112','Jane Peters',15);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1018,'Clear Valley Waters 5','A','Mass Marketer','US','SEA ','1061 Industrial Park Dr','8th Floor','Bellevue','Washington','98004-1637','2066465549','2065416632','Greg McCory',16);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1019,'Supremax Montagna 5','A','Camping Chain','ES','MADR','C0alle Castellana, 141','Planta 20','Madrid',null,'28020','3415560401','3415563458','Carlos Remirez',17);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1020,'Pro Form Supplies 5','A','Camping Chain','US','SFR ','10200 Coastal Parkway','Suite 4500','San Francisco','California','90288-1607','4153334131','4152229000','Kate Segal',18);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1021,'Up and Up Co. 5','A','Sports Chain','US','NY  ','4043 Eagleson Ave','28th Floor','New York','New York','08094-3698','2128885342','2126673231','Elizabeth Terry',19);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1022,'Kay Mart 5','A','Mass Marketer','HK','HKG ','1081 Johnston Road','1104 Tai Yau Bldg','Wanchai',null,null,'8528363239','8525916743','Pham Lau',21);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1023,'GO Outlet Sydney','A','GO Outlet','AU','MEL ','302 Angora Road',null,'Syndey','NSW','2043','6102774556','61027734411','Jake Cartel',22);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1024,'Laperier Sportifs 5','A','Sports Chain','CA','MTL ','403, rue Montagne','Suite 402','Sept-Iles','Quebec','G4R 4B5','4185567231','4186656600','Guy Lamoureux',23);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1025,'Fresh Air Co 5','A','Camping Chain','UK','MAN ','203 Market Cross',null,'Chichester','West Sussex','HA12 1AB','44733786628','44733785213','Adrian Welsh',24);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1026,'GO Outlet London','A','GO Outlet','UK','LON ','30 Smallmeadow Ln',null,'Bracknell','Berkshire',null,'44344486886','44344662486','Tanya Forsythe',25);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1027,'Hill Street Sports 5','A','Sports Chain','US','NY  ','60 Walgate Street','19th Floor','New York','New York','67439','9125467890','9125464151','Katherine McCourt',26);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1028,'Fredies Sport Whse 5','A','Sports Chain','US','DAL ','504 Cedar Hill Drive','4th Floor','Dallas','Texas','54378','7590917263','7590916478','Betty Rally',27);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1029,'GO Outlet Chicago','A','GO Outlet','US','CHG ','405 East Lane','1st Floor','Chicago','Illinois','54332-2340','5729825330','5729826483','Fred Smythe',28);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1030,'Juan''s Sports 3','A','Sports Chain','MX','MEX ','405 Col Atahualpa',null,'Monterey',null,'3053','52836667177','52836667111','Juan Desmadona',29);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1031,'GO Outlet Ottawa','A','GO Outlet','CA','TOR ','1023 Main St','Suite 1060','Ottawa','Ontario','K1F 2R2','6134510294','6135534698','Harold Townsend',30);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1032,'Supras Camping Suplies 2','A','Camping Chain','US','SEA ','400 Interstate N. Park','Suite 1060','Seattle','Washington','30339-5014','4049510294','4049561698','Andrea Sweeney',149);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1033,'Supras Camping Suplies 3','A','Camping Chain','CA','MTL ','6060 Blvd Elizabeth II','Suite 2200','Montreal','Quebec','H8Y 2R5','5145533321','5145533322','Gilles Rapier',174);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1034,'Supras Camping Suplies 4','A','Camping Chain','US','MIA ','400 Interstate N. Park','Suite 1060','Miami','Florida','30339-5017','4049510294','4049561698','Helen Perkins',176);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1035,'Ultra Sports 1','A','Sports Chain','ES','MADR','A0venida C. Colombo, 45','Suite 201','Barcelona',null,'38045','343563434','343563444','Manuela Garcia',178);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1036,'Ultra Sports 2','A','Sports Chain','HK','HKG ','10812 Prince of Wales R','1180 Won Tai Bldg','Hong Kong',null,null,'8528363448','8528363446','John Lee',180);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1037,'Ultra Sports 3','A','Sports Chain','DE','FRNK','H0eideweg 18',null,'Frankfurt',null,'60433','49695617754','49695617755','Helmut Scharf',1);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1038,'Ultra Sports 4','A','Sports Chain','US','DAL ','40770 Duke Drive','Suite 201','Dallas','Texas','45040-9014','5133980202','5133983125','Krista Highwater',3);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1039,'Vacation Central 1','A','Mass Marketer','AU','MEL ','20415 Queen''s Ave',null,'Melbourne','VIC','2088','61029824422','61029824411','Dave Smythe',4);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1040,'Vacation Central 2','A','Mass Marketer','BE','BNL ','A0v. Liopold II 123',null,'Antwerpen',null,'1450','323251042','323209262','Pierre Smears',5);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1041,'Vacation Central 3','A','Mass Marketer','FR','PAR ','801, rue Isabelle',null,'Paris',null,'92080','33146886540','33146886542','Jeanne Martin',6);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1042,'Vacation Central 4','A','Mass Marketer','CA','VAN ','802 Docklands Street','Suite 1500','Vancouver','British Columbia','V6E 3Z3','6046820446','6046823005','Jerry Krantz',7);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1043,'Mountain Madness 1','A','Mass Marketer','US','CHG ','405 Lakeside','Suite 1409','St. Louis','Missouri','78654','8167600263','8166705672','Sandra Tourangeau',8);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1044,'Mountain Madness 2','A','Mass Marketer','US','CHG ','4015 MacClaren','3rd Floor','Chicago','Illinois','79634','4678936746','4678937876','Gerry Touch',9);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1045,'Mountain Madness 3','A','Mass Marketer','US','CHG ','6078 Richmond','2nd Floor','Detroit','Michigan','78659','6578095467','6578094861','Jack Vino',11);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1046,'Mountain Madness 4','A','Mass Marketer','US','CHG ','607 Metcalfe','8th Floor','Aurora','Illinois','12675','7934527689','7934527810','Rick Walters',12);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1047,'Expert Fitness','A','Independent','US','NY  ','1060 Chapel','6th Floor','Albany','New York','65445','5675552345','2345553453','Michelle Wong',14);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1048,'Supras Camping Supplies 5','A','Camping Chain','CA','TOR ','807 Florence','Suite 202','Toronto','Ontario','M5S 1A1','4165552345','4165553453','Walter Baker',15);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1049,'Supras Camping Supplies 1','A','Camping Chain','US','NY  ','40311 Riverside Drive','6th Floor','Buffalo','New York','65445','5675552345','2345553453','Laurie Michaels',16);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1050,'Supras Camping Supplies 6','A','Camping Chain','CA','MTL ','1060, rue Moureaux','Suite 410','Quebec City','Quebec','G1B 3L5','4185558891','4185558865','Phillip Marchaud',17);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1051,'Sportwaren G.m.b.H. 1','A','Sports Chain','DE','FRNK','S0chwanseeplatz 13',null,'Munich',null,'81549','49898823456','49898823455','Gerhard Steiner',149);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1052,'Sportwaren G.m.b.H. 2','A','Sports Chain','DE','FRNK','S0chwabentor 35',null,'Hamburg',null,'22529','49406666802','49406661061','Renate Brunner',174);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1053,'Sportwaren G.m.b.H. 3','A','Sports Chain','DE','FRNK','P0astoratsgasse 7',null,'Bonn',null,'53121','49228931139','49228932239','Peter Pfolz',176);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1054,'Supras Camping Supplies 8','A','Camping Chain','DE','FRNK','L0innestrasse 32',null,'Frankfurt',null,'60385','49698026666','4969802677','Sibylle Maier',178);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1055,'OutBack Pty 1','A','Mass Marketer','AU','MEL ','1020 Pacific Highway','Suite 118','Sydney','NSW','2244','6124375433','6124375123','Alice Walter',180);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1056,'OutBack Pty 2','A','Mass Marketer','AU','MEL ','2013 South Quay','Suite 81, Level III','Brisbane','QLD','4000','6172381065','6172371063','Lawrence Jenkins',1);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1057,'OutBack Pty 3','A','Mass Marketer','AU','MEL ','2050 St. Georges Terrac','10th Floor','Perth','WA','6000','6193217890','6192344432','John Sinden',3);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1058,'OutBack Pty 4','A','Mass Marketer','AU','MEL ','1018-120 Pacific Highwa',null,'Sydney',null,'2244','6124375388','6124375266','Walter Rice',4);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1059,'Botanechi K.K. 1','A','Independent','JP','TOKY','60F Green Life Building','2-21-12 Sasazuka','Sapporo',null,'182','811153912300','811153912200','Shujimo Yamataki',5);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1060,'Jackos Enviro Shop','A','Independent','AU','MEL ','40400 Kildairne Rd','3rd Floor','Brisbane','QLD','4000','61722108653','6172671052','Donald Ward',6);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1061,'Outdoor Central Ltd','A','Independent','CA','MTL ','N0owlan Drive','Suite 706','Moncton','New Brunswick','E1A 2A7','5065558844','5065553344','Marie Turcotte',7);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1062,'123 Fitness PTE Ltd','A','Independent','SG','SING','4082-E Yom Lan Rd',null,'Singapore',null,'1648','654442900','653396789','Henry Chee',8);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1063,'Tregoran AB 1','A','Camping Chain','SE','STOC','F0inlandsgatan 20',null,'Stockholm',null,'114 57','468722599','468722688','Ingmar Rolafsson',9);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1064,'Tregoran AB 2','A','Camping Chain','SE','STOC','E0klundsgatan 18',null,'Goteburg',null,null,'4631754666','46317543321','Sven Hallstrom',11);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1065,'Trees to Seas Ltd','A','Independent','UK','LON ','108 Knights Cross Garde','Peyton House','London',null,'NS5 8BT','44718886543','44718895543','Robert Gordon',12);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1066,'Wilderness Wonderment Ltd','A','Independent','BE','BNL ','B0lvd Charleroi 225',null,'Brussels',null,'1032','3222510088','3222510047','Martine Choutier',14);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1067,'Andes Camping Supplies 1','A','Camping Chain','CA','TOR ','10117 Franklin Blvd','Ground Floor','Winnipeg','Manitoba','R2C 0M5','2044539061','2042840130','Mark Myers',15);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1068,'Andes Camping Supplies 2','A','Camping Chain','CA','VAN ','10200 Sierra Vista Driv','Suite 600','Calgary','Alberta','T3H 2T7','4037759080','4037777090','Ron Winter',16);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1069,'Andes Camping Supplies 3','A','Camping Chain','CA','VAN ','108 Thompson Rd','1st Floor','Kamploops','British Columbia','V2C 6P8','6043328761','6043328070','Jack Marshall',17);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1070,'Andes Camping Supplies 4','A','Camping Chain','CA','VAN ','104 Rosehill Cr','2nd Floor','Victoria','British Columbia','V8Z 5N2','6046543321','6046546543','Frank Smith',18);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1071,'Lookout Below Ltd','A','Independent','US','LA  ','6093 Hebert Street','4B2','San Diego','California','16469','1235551234','1235556542','Mark Caron',19);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1072,'Advanced Climbing Ltd','A','Independent','US','DAL ','1000 Southvale','33rd Floor','Denver','Colorado','16462','1235551234','1235556542','Wilma Turner',21);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1073,'GO Outlet Irving','A','GO Outlet','US','DAL ','10917 St. Laurent Blvd.','Suite 709','Irving','Texas','16463','1235551234','1235556542','Dan Turpin',22);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1074,'GO Outlet Seattle','A','GO Outlet','US','SEA ','405 Wakefield Drive','8th Floor','Seattle','Washington','16464','1235451234','1235456542','Robert Snow',23);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1075,'Act''N''Up Fitness 1','A','Sports Chain','US','SFR ','5055 Mt. Lincoln Lane','6th Floor','Oakland','California','76389-9084','6232955929','6232598769','Lucille Teale',24);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1076,'Act''N''Up Fitness 2','A','Sports Chain','US','CHG ','5055 Lincoln Street','Suite 606','Moline','Illinois','78659','7865439807','7865437087','Bob Simpson',25);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1077,'Act''N''Up Fitness 3','A','Sports Chain','US','CHG ','4048 Crestview','1st Floor','Lancaster','Missouri','67548','5807524178','5807524897','Scott Simms',26);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1078,'Act''N''Up Fitness 4','A','Sports Chain','US','CHG ','8028 Lawnsberry','2nd Floor','Bloomington','Indiana','67548','2184748790','2184744011','Dennis Page',27);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1079,'Desert Duds and Tees 1','A','Camping Chain','US','CHG ','208 Louis Road','Suite 101','Battle Creek','Michigan','67459','4908593406','4908596781','Edwina Palmer',28);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1080,'Desert Duds and Tees 2','A','Camping Chain','US','DAL ','1026 Hawthorne','3rd Floor','Austin','Texas','18274','8192937465','8192936781','Anne Paquette',29);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1081,'Desert Duds and Tees 3','A','Camping Chain','US','DAL ','40968 Anderson Road','Suite 512','Forth Worth','Texas','13131-4387','6697286539','6697288206','Mark Parent',30);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1082,'Desert Duds and Tees 4','A','Camping Chain','US','CHG ','7075 Cummings','4th Floor','Altoona','Pennsylvania','89327','7446433190','7446434717','Morrie Paul',149);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1083,'Over the Top Cycles 1','A','Mass Marketer','MX','MEX ','109 Plaza Federale',null,'Puerto Vallarta',null,'7076','523226697654','523226667654','Carlos Montera',174);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1084,'Over the Top Cycles 2','A','Mass Marketer','US','CHG ','2025 Othello','Suite 442','Chicago','Illinois','72375','2267634827','2267638709','Jan Singleman',176);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1085,'Over the Top Cycles 3 AB','A','Mass Marketer','SE','STOC','N0ilsgatan 85',null,'Stockholm',null,'114 55','468722777','468722992','Mats Svenson',178);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1086,'All season camping goods','A','Independent','US','NY  ','108 Majestic Court','5th Floor','New York','New York','23775','7723332074','77233330209','Janet Singles',180);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1087,'Rock Steady 1','A','Camping Chain','US','CHG ','1043 Pebble Lane','Suite 523','Springfield','Missouri','74752','1165172925','1165171078','Craig Amesbury',1);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1088,'Rock Steady 2','A','Camping Chain','US','CHG ','5011 Bayview Dr.','6th Floor','Toledo','Ohio','24849','2384842916','2384842675','Ed Anderson',3);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1089,'Rock Steady 3','A','Camping Chain','UK','LON ','106 Thomas Street',null,'Milford Haven','Wales','WZ9 3HT','44228551688','44228551672','Humphrey Willoughby',4);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1090,'Rock Steady 4','A','Camping Chain','BE','BNL ','R0ue Peppermans 43',null,'Brussels',null,'1048','322260032','3222510020','Francine Roulier',5);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1091,'Clear Valley Waters 1','A','Mass Marketer','CA','MTL ','801 Townsend Ave','Main Floor','Sydney','Nova Scotia','B1N 2W2','9023356321','9023356565','Bob Harvey',6);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1092,'Clear Valley Waters 2','A','Mass Marketer','CA','MTL ','102 Centennial Ave','Penthouse','Halifax','Nova Scotia','B3M 4C6','9027221231','9027221221','Elise Leblanc',7);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1093,'Clear Valley Waters 3','A','Mass Marketer','CA','TOR ','90002 Bloor St E','8th Floor','Toronto','Ontario','M8T 2D5','4163399200','4163399231','Sally White',8);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1094,'Clear Valley Waters 4','A','Mass Marketer','CA','MTL ','206 Treadwell Drive','Suite 706','St. John','New Brunswick','E2J 7T4','5064412321','5064412300','Monique Lemieux',9);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1095,'Supremax Montagna 1','A','Camping Chain','ES','MADR','C0alle Mar�a, 53',null,'Sevilla',null,'32045','3455604011','3455604220','Juan Ramirez',11);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1096,'Supremax Montagna 2','A','Camping Chain','ES','MADR','A0venida Aragona, 230',null,'Zaragoza',null,'60780','3476907908','3476907900','Carla Almirez',12);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1097,'Supremax Montagna 3','A','Camping Chain','ES','MADR','P0laza Sanctos, 12',null,'Barcelona',null,'38025','3437213289','3437213288','Carlos Rodriguez',14);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1098,'GO Outlet Madrid','A','GO Outlet','ES','MADR','108, ruelle Bouvier',null,'Paris',null,'93070','33168945220','33168945660','Florence Martin',15);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1099,'Pro Form Supplies 1','A','Camping Chain','US','LA  ','607 Ridgefield','9th Floor','Santa Monica','California','94520','8242175757','8242178365','Katherine Segal',16);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1100,'Pro Form Supplies 2','A','Camping Chain','US','LA  ','804 Gowrie','Suite 803','Pasadena','California','46211','1717174104','1717176723','Kevin Saunders',17);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1101,'Pro Form Supplies 3','A','Camping Chain','US','LA  ','9052 Winnington','9th Floor','Santa Monica','California','20698','9768920698','9768920678','Ellen Armstrong',18);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1102,'Pro Form Supplies 4','A','Camping Chain','US','SFR ','1048 Joffrey','Suite 908','San Diego','California','99198','7754231027','7754231028','Bill Beneck',19);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1103,'Up and Up Co. 1','A','Sports Chain','US','NY  ','20781 Richmond Road','10th Floor','Atlantic City','New Jersey','85469','6087627848','6087627876','H. Byers',21);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1104,'Up and Up Co. 2','A','Sports Chain','US','CHG ','60 Honey Gables','Ground Floor','New Brunswick','New Jersey','16591','3317558975','3317557863','Robert Caldwell',22);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1105,'Up and Up Co. 3','A','Sports Chain','US','NY  ','50 Hobart','Top Floor','Queens','New York','78225','2852083735','2852080663','Nigel Campbell',23);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1106,'Up and Up Co. 4','A','Sports Chain','US','NY  ','10195 Newmarket','Suite 102','Baltimore','Maryland','70847','5156718514','5156715200','Jane Cartenson',24);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1107,'New Wave Wilderness 1','A','Camping Chain','US','NY  ','4031 Young Street','1st Floor','New Rochelle','New York','67382','7595140285','7595140675','Tracey Chartrand',25);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1108,'New Wave Wilderness 2','A','Camping Chain','CA','TOR ','20 Main Street','2nd Floor','Hamilton','Ontario','L8P 6T4','9058656722','9058650043','Rick Miller',26);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1109,'GO Outlet Miami','A','GO Outlet','US','MIA ','4031 Young Street','3rd Floor','Miami','Florida','78564','1235551234','1235590675','Tracey Chartrand',27);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1110,'New Wave Wilderness 4','A','Camping Chain','US','MIA ','2038 Montreal Street','4th Floor','Sarasota','Florida','36171','7868905643','7869048696','Charles Tracy',28);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1111,'Wally Mart 1','A','Mass Marketer','UK','MAN ','302 O''Callaghan Street',null,'Galway',null,null,'35391912408','35391912500','Greg Leary',29);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1112,'Wally Mart 2','A','Mass Marketer','UK','MAN ','10 Jeremy Lane',null,'Cork',null,null,'35321535616','35321535600','Sydney Stewart',30);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1113,'Wally Mart 3','A','Mass Marketer','BE','BNL ','P0lace du Moulin 46',null,'Brussels',null,'1130','323976244','323976242','Claude Lafleur',149);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1114,'Wally Mart 4','A','Mass Marketer','US','NY  ','5033 Falwyn','Suite 1003','Huntington','New York','98765','1235554522','1235557432','Fabian Dapple',174);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1115,'Kay Mart 1','A','Mass Marketer','US','BOS ','B0oston Towers','181 Johnson Rd.','Boston','Massachusetts','90549','1472210647','1472210695','Prat Lau',176);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1116,'Kay Mart 2','A','Mass Marketer','CA','TOR ','101 Patrick Street','4th Floor','Trenton','Ontario','K8V 4B2','6137023318','6137023311','Susan Armstrong',178);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1117,'Kay Mart 3','A','Mass Marketer','CA','TOR ','105 Western Ave','Suite 203','Guelph','Ontario','N1G 2W5','5193314545','5193315555','Bill Follett',180);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1118,'Kay Mart 4','A','Mass Marketer','CA','MTL ','203, rue Larochelle','Suite 6','Shawville','Quebec','J0X 2Y0','8197727712','8197727777','Jean Moureux',1);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1119,'GO Outlet Frankfurt','A','GO Outlet','DE','FRNK','W0eimarerstrasse 35',null,'Frankfurt',null,'60529','49691117171','49691116161','Karin Liebnitz',3);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1120,'GO Outlet London','A','GO Outlet','UK','LON ','607 Grosvenor Square',null,'London',null,'NE2 87B','44717324421','44717322222','Sybil Collins',4);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1121,'GO Outlet Manchester','A','GO Outlet','UK','MAN ','302 Glasgow St',null,'Manchester',null,'MW8 35S','44619832222','44619831111','Matthew Newly',5);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1122,'GO Outlet New York','A','GO Outlet','US','NY  ','10179 Lees Avenue','6th Floor','New York','New York','21162','3964717233','3964713254','Robert Davies',6);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1123,'Laperier Sportifs 1','A','Sports Chain','CA','MTL ','4053, rue Conseil','Suite 404','Sherbrooke','Quebec','J1E 3Y6','8194464532','8194464433','Patrick Beauvais',7);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1124,'Laperier Sportifs 2','A','Sports Chain','CA','MTL ','102, rue Marquis','Suite 1212','Granby','Quebec','J2G 5R6','8193399765','8193399797','Georges Saint-Germain',8);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1125,'Laperier Sportifs 3','A','Sports Chain','CA','MTL ','203, rue Centre','Suite 450','Aylmer','Quebec','J9H 5P9','8197316266','8197316261','Carole Claudel',9);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1126,'Laperier Sportifs 4','A','Sports Chain','CA','MTL ','408, rue Leduc','Suite 301','Hull','Quebec','J8Y 3Z5','8194424848','8194438686','Serge Champoux',11);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1127,'Fresh Air Co 1','A','Camping Chain','UK','MAN ','108 Cliff St',null,'Brighton',null,'SS9 54W','447662234324','447662234433','Hillary Thomas',12);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1128,'Fresh Air Co 2','A','Camping Chain','UK','LON ','10 Castle Rd',null,'Coventry',null,'95409','442036515131','442036513151','Francis Miller',14);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1129,'Fresh Air Co 3','A','Camping Chain','UK','LON ','303 Manor Way',null,'Bristol',null,'40198','442724124242','442724123333','Walter Taylor',15);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1130,'Fresh Air Lte 4','A','Camping Chain','FR','PAR ','108, rue St-Denis',null,'Paris',null,'94080','33188656543','33188656555','France Albert',16);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1131,'GO Outlet Washington','A','GO Outlet','US','SEA ','30 Smallmeadow Ln','Suite 1245','Seattle','Washington','19304','5997382176','5997386787','Tanya Forrester',17);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1132,'Excellence en Montagne','A','Independent','CA','MTL ','108, rue Rousseau','Suite 1632','Montreal','Quebec','H2T 2J6','5147799763','5147777693','Yves Fortin',18);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1133,'Back woods up front Ltd.','A','Independent','CA','TOR ','3031 Murdock Ave','Suite 11','Timmins','Ontario','P4T 2J9','7056623121','7056623133','Walter Reilly',19);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1134,'Breathe Free ltd','A','Independent','UK','MAN ','606 King St',null,'Manchester',null,'75630','44612234421','44612234422','Paul Murphy',21);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1135,'Hill Street Sports 1','A','Sports Chain','US','DEN ','10209 NotreDame','7th Floor','Boulder','Colorado','42981','9146637245','9146637287','Martin Faucher',22);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1136,'Hill Street Sports 2','A','Sports Chain','US','DEN ','10233 Wellington','9th Floor','Colorado Springs','Colorado','82662','2373382662','2373382452','Erwin Fast',23);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1137,'Hill Street Sports 3','A','Sports Chain','US','MIA ','101 Kilborn','Suite 607','Raleigh','North Carolina','56263','5107976060','5107971017','Cathy Gagnon',24);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1138,'Hill Street Sports 4','A','Sports Chain','US','MIA ','8024 Dundee','23rd Floor','Charlotte','North Carolina','20706','8005316711','8005312727','Peter Gaw',25);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1139,'Fredies Sport Whse 1','A','Sports Chain','US','LA  ','1043 Heatherington','Ground Floor','Sacramento','California','69087','4983064153','4983064553','Mark Haines',26);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1140,'Fredies Sport Whse 2','A','Sports Chain','US','SFR ','20659 Wentworth','Suite 734','San Bernardino','California','67755','9717282458','9717280675','Robin Harper',27);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1141,'Fredies Sport Whse 3','A','Sports Chain','US','DAL ','6070 Rivercrest','18th Floor','San Antonio','Texas','47765','4315162229','4315176589','Barbara Haydon',28);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1142,'Fredies Sport Whse 4','A','Sports Chain','US','DAL ','103 Amesbrooke','Suite 890','Beaumont','Texas','89456','5147494451','5147467861','Andrew Katz',29);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1143,'Florida Sun Sports 1','A','Sports Chain','US','MIA ','1034 Westport','Suite 906','Jacksonville','Florida','86490-4863','6565021623','6565025587','Mary Labonte',30);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1144,'Florida Sun Sports 2','A','Sports Chain','US','MIA ','6014 Bathgate','Suite 1011','Tampa','Florida','54332-2383','8252312044','8252319460','Pete Marwick',149);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1145,'Florida Sun Sports 3','A','Sports Chain','US','MIA ','202 Blasswell','Top Floor','Key Largo','Florida','54833','5926142004','5926147916','Dan MacDonald',174);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1146,'Florida Sun Sports 4','A','Sports Chain','US','MIA ','406 Robin Way','Basement','Loxahatche','Florida','54382-2396','8247521981','8247521890','Scott Miller',176);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1147,'Juan''s Sports 1','A','Sports Chain','MX','MEX ','405 Calle Tulum',null,'Cancun',null,'9089','52988878321','52988872222','Miguel Aluna',178);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1148,'Juan''s Sports 2','A','Sports Chain','MX','MEX ','1064 Av Pacifico',null,'Guadalajara',null,'8048','5234436848','5234436888','Carlos De La Fuente',180);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1149,'GO Outlet Denver','A','GO Outlet','US','DEN ','601 Cathcart','Mail Stop 4B','Denver','Colorado','25643','8768906478','8067935670','John Desmon',1);
Insert into CUSTOMERS (CUST_NO,CNAME,STATUS,CUST_TYPE,COUNTRY_CD,BRANCH_CD,ADDRESS1,ADDRESS2,CITY,PROV_STATE,POST_ZIP,PHONE_NO,FAX_NO,CONTACT,SALES_REP) values (1150,'GO Outlet Dallas','A','GO Outlet','US','DAL ','2075 Sparks Road','Main Floor','Dallas','Texas','24362','8367456133','8367456833','Juan Desmadona',3);
Update customers
Set address1 = substr(address1, 1,1)||replace(substr ((select user from dual),-1,1), substr(address1,1,1))||
substr(address1, 3,50);
select * from customers;
select * from employees;
Rem *****************************************************************************

INSERT INTO ORDERS VALUES (1,1,1085,'27-Jan-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (2,27,1148,'31-Jan-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (3,27,1030,'07-Feb-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (4,16,1038,'07-Feb-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (5,39,1093,'17-Feb-2019','C','Telephone Sales');
INSERT INTO ORDERS VALUES (6,9,1119,'17-Feb-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (7,35,1008,'24-Feb-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (8,18,1128,'27-Feb-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (9,19,1127,'27-Feb-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (10,1,1009,'02-Mar-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (11,30,1036,'04-Mar-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (12,21,1089,'12-Mar-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (13,7,1092,'14-Mar-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (15,19,1121,'15-Mar-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (16,22,1045,'22-Mar-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (17,15,1074,'23-Mar-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (18,28,1056,'25-Mar-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (19,39,1093,'29-Mar-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (20,26,1130,'03-Apr-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (22,25,1130,'04-Apr-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (24,7,1001,'07-Apr-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (25,9,1037,'07-Apr-2019', 'O' ,'Internet Orders');
INSERT INTO ORDERS VALUES (26,23,1102,'10-Apr-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (27,25,1098,'11-Apr-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (28,5,1102,'12-Apr-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (29,18,1120,'13-Apr-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (30,34,1055,'14-Apr-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (31,7,1024,'16-Apr-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (32,1,1063,'20-Apr-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (33,26,1041,'30-Apr-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (34,30,1036,'01-May-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (35,18,1026,'02-May-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (36,19,1112,'02-May-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (37,36,1071,'03-May-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (38,29,1062,'07-May-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (39,41,1095,'12-May-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (41,27,1030,'22-May-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (42,34,1057,'05-Jun-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (43,25,1130,'25-Jun-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (44,22,1078,'30-Jun-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (45,16,1073,'01-Jul-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (46,26,1130,'03-Jul-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (47,11,1097,'04-Jul-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (48,9,1054,'06-Jul-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (49,21,1120,'09-Jul-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (50,39,1108,'16-Jul-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (51,27,1030,'19-Jul-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (52,30,1022,'19-Jul-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (53,29,1062,'27-Jul-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (54,39,1048,'28-Jul-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (55,12,1135,'30-Jul-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (56,9,1051,'31-Jul-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (57,5,1102,'05-Aug-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (58,29,1062,'08-Aug-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (59,8,1040,'10-Aug-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (60,1,1009,'11-Aug-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (61,21,1120,'13-Aug-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (62,26,1130,'15-Aug-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (63,7,1118,'16-Aug-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (64,33,1058,'18-Aug-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (65,33,1039,'20-Aug-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (66,1,1063,'20-Aug-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (67,7,1001,'26-Aug-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (68,39,1093,'31-Aug-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (69,12,1136,'02-Sep-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (70,12,1136,'03-Sep-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (71,3,1145,'19-Sep-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (72,29,1062,'22-Sep-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (73,5,1015,'23-Sep-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (74,1,1064,'24-Sep-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (75,33,1055,'28-Sep-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (76,36,1101,'13-Oct-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (77,27,1083,'16-Oct-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (78,11,1019,'17-Oct-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (79,5,1102,'21-Oct-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (100,3,1144,'21-Oct-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (101,18,1129,'24-Oct-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (102,8,1066,'24-Oct-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (104,28,1056,'25-Oct-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (105,24,1107,'26-Oct-2019', 'C' ,'Mail Sales');
INSERT INTO ORDERS VALUES (106,7,1092,'01-Nov-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (107,18,1120,'10-Nov-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (108,39,1108,'11-Nov-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (109,35,1008,'16-Nov-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (110,33,1055,'20-Nov-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (111,34,1007,'23-Nov-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (113,25,1041,'24-Nov-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (114,15,1131,'25-Nov-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (115,23,1004,'02-Dec-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (116,4,1043,'08-Dec-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (117,19,1111,'10-Dec-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (118,8,1090,'16-Dec-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (119,39,1108,'16-Dec-2019','C','Internet Orders');
INSERT INTO ORDERS VALUES (120,26,1130,'23-Dec-2019', 'C' ,'Telephone Sales');
INSERT INTO ORDERS VALUES (122,21,1065,'05-Jan-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (123,40,1042,'07-Jan-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (124,9,1037,'08-Jan-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (125,21,1129,'10-Jan-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (126,23,1102,'15-Jan-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (127,26,1041,'16-Jan-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (128,22,1045,'18-Jan-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (129,26,1041,'23-Jan-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (130,5,1015,'26-Jan-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (131,4,1077,'27-Jan-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (132,14,1005,'02-Feb-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (133,5,1075,'10-Feb-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (134,19,1025,'12-Feb-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (135,19,1127,'13-Feb-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (136,9,1054,'13-Feb-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (137,1,1009,'17-Feb-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (138,28,1056,'18-Feb-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (139,9,1051,'22-Feb-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (140,4,1076,'23-Feb-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (141,28,1056,'26-Feb-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (143,16,1028,'02-Mar-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (144,39,1048,'11-Mar-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (145,39,1048,'11-Mar-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (146,24,1106,'12-Mar-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (147,21,1128,'12-Mar-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (148,23,1015,'16-Mar-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (149,39,1048,'17-Mar-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (151,7,1132,'20-Mar-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (152,3,1138,'22-Mar-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (153,14,1005,'22-Mar-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (154,19,1111,'22-Mar-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (155,41,1035,'26-Mar-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (156,3,1137,'29-Mar-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (157,40,1069,'30-Mar-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (158,25,1098,'01-Apr-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (159,12,1149,'05-Apr-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (160,34,1039,'06-Apr-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (161,34,1057,'16-Apr-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (162,1,1063,'20-Apr-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (163,25,1098,'21-Apr-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (164,8,1066,'21-Apr-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (165,16,1072,'23-Apr-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (166,8,1090,'24-Apr-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (167,16,1081,'25-Apr-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (168,6,1106,'26-Apr-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (169,1,1085,'01-May-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (170,18,1065,'06-May-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (171,15,1032,'12-May-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (172,8,1113,'12-May-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (173,23,1075,'25-May-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (174,21,1129,'03-Jun-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (175,35,1059,'08-Jun-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (176,7,1033,'10-Jun-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (179,14,1002,'12-Jun-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (180,40,1067,'18-Jun-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (181,22,1044,'21-Jun-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (182,6,1105,'23-Jun-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (183,27,1147,'24-Jun-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (184,3,1109,'25-Jun-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (185,22,1104,'26-Jun-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (186,11,1096,'03-Jul-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (187,5,1020,'03-Jul-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (188,3,1144,'07-Jul-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (189,18,1128,'08-Jul-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (190,11,1019,'08-Jul-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (191,34,1058,'08-Jul-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (192,5,1020,'13-Jul-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (193,16,1080,'15-Jul-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (194,36,1139,'19-Jul-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (195,28,1056,'20-Jul-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (196,5,1004,'20-Jul-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (197,9,1052,'23-Jul-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (199,40,1069,'27-Jul-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (200,29,1011,'30-Jul-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (201,1,1085,'01-Aug-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (202,18,1128,'05-Aug-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (203,9,1054,'05-Aug-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (204,24,1106,'13-Aug-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (205,11,1095,'17-Aug-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (206,4,1087,'20-Aug-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (207,6,1012,'30-Aug-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (208,36,1071,'03-Sep-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (209,9,1053,'16-Sep-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (210,25,1041,'17-Sep-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (211,9,1037,'21-Sep-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (212,15,1018,'22-Sep-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (213,40,1067,'24-Sep-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (214,11,1097,'28-Sep-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (215,9,1006,'28-Sep-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (216,28,1056,'10-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (217,9,1053,'10-Oct-2020','C','Mail Sales');
INSERT INTO ORDERS VALUES (218,24,1122,'10-Oct-2020','C','Telephone Sales');
INSERT INTO ORDERS VALUES (220,40,1042,'11-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (222,8,1066,'12-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (223,8,1066,'12-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (224,8,1066,'19-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (225,11,1095,'20-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (226,11,1095,'21-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (227,11,1095,'23-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (228,1,1085,'23-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (231,9,1119,'29-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (233,28,1056,'30-Oct-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (234,28,1056,'01-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (235,30,1022,'09-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (236,30,1022,'09-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (238,30,1036,'10-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (239,30,1036,'20-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (240,30,1022,'20-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (241,30,1022,'24-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (243,35,1008,'26-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (244,35,1008,'26-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (245,35,1008,'28-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (246,35,1008,'29-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (247,35,1008,'29-Nov-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (249,29,1011,'01-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (250,29,1011,'01-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (251,29,1011,'02-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (252,29,1011,'02-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (254,7,1092,'02-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (255,7,1092,'03-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (256,14,1005,'05-Dec-2020','C','Internet Orders');
Update customers
Set address1 = substr(address1, 1,1)
||replace(substr ((select user from dual),-1,1), substr(address1,2,1))||
substr(address1, 2,50);
INSERT INTO ORDERS VALUES (258,16,1038,'09-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (259,16,1038,'10-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (261,22,1045,'11-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (262,27,1148,'20-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (264,27,1148,'24-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (265,27,1148,'25-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (267,27,1148,'27-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (268,24,1107,'31-Dec-2020','C','Internet Orders');
INSERT INTO ORDERS VALUES (270,25,1041,'17-Jan-2021','C','Internet Orders');
INSERT INTO ORDERS VALUES (271,9,1037,'21-Jan-2021','C','Telephone Sales');
INSERT INTO ORDERS VALUES (272,15,1018,'22-Jan-2021','C','Internet Orders');
INSERT INTO ORDERS VALUES (273,40,1067,'24-Jan-2021','C','Telephone Sales');
INSERT INTO ORDERS VALUES (274,11,1097,'28-Jan-2021','C','Internet Orders');
INSERT INTO ORDERS VALUES (275,9,1006,'28-Jan-2021','C','Telephone Sales');
INSERT INTO ORDERS VALUES (276,28,1056,'10-Feb-2021','C','Internet Orders');
INSERT INTO ORDERS VALUES (277,9,1053,'10-Feb-2021','C','Mail Sales');
INSERT INTO ORDERS VALUES (278,24,1122,'10-Feb-2021','C','Telephone Sales');
INSERT INTO ORDERS VALUES (279,40,1042,'11-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (280,8,1066,'12-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (283,8,1066,'12-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (284,8,1066,'19-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (285,11,1095,'20-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (286,11,1095,'21-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (287,11,1095,'23-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (288,1,1085,'23-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (291,9,1119,'28-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (293,28,1056,'28-Feb-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (294,28,1056,'01-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (295,30,1022,'09-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (296,30,1022,'09-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (298,30,1036,'10-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (299,30,1036,'20-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (300,30,1022,'20-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (301,30,1022,'24-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (303,35,1008,'26-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (304,35,1008,'26-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (305,35,1008,'28-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (306,35,1008,'29-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (307,35,1008,'29-Mar-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (309,29,1011,'01-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (310,29,1011,'01-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (311,29,1011,'02-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (312,29,1011,'02-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (314,7,1092,'02-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (315,7,1092,'03-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (316,14,1005,'05-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (318,16,1038,'09-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (319,16,1038,'10-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (321,22,1045,'11-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (322,27,1148,'20-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (324,27,1148,'24-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (325,27,1148,'25-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (327,27,1148,'27-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (328,24,1107,'30-Apr-2021','O','Internet Orders');
INSERT INTO ORDERS VALUES (329,9,1053,'01-May-2021','O','Mail Sales');

INSERT INTO ORDERLINES VALUES(1,1,60401,9.00,617,21.00);
INSERT INTO ORDERLINES VALUES(1,2,60400,6.00,247,7.00);
INSERT INTO ORDERLINES VALUES(2,1,60101,12.00,124,14.00);
INSERT INTO ORDERLINES VALUES(2,2,60400,6.00,315,13.00);
INSERT INTO ORDERLINES VALUES(2,3,50101,32.00,32,21.00);
INSERT INTO ORDERLINES VALUES(2,4,40101,518.00,2,1.00);
INSERT INTO ORDERLINES VALUES(2,5,40100,165.00,34,1.00);
INSERT INTO ORDERLINES VALUES(2,6,40302,18.00,1,20.00);
INSERT INTO ORDERLINES VALUES(3,1,60400,6.00,504,11.00);
INSERT INTO ORDERLINES VALUES(3,2,60301,11.00,374,4.00);
INSERT INTO ORDERLINES VALUES(3,3,50203,8.00,32,6.00);
INSERT INTO ORDERLINES VALUES(3,4,40103,615.00,7,8.00);
INSERT INTO ORDERLINES VALUES(3,5,40202,84.00,1,10.00);
INSERT INTO ORDERLINES VALUES(3,6,40100,165.00,18,16.00);
INSERT INTO ORDERLINES VALUES(3,7,40102,555.00,3,1.00);
INSERT INTO ORDERLINES VALUES(4,1,60202,30.00,98,3.00);
INSERT INTO ORDERLINES VALUES(4,2,60100,9.00,49,7.00);
INSERT INTO ORDERLINES VALUES(4,3,50101,32.00,64,17.00);
INSERT INTO ORDERLINES VALUES(4,4,40202,84.00,25,11.00);
INSERT INTO ORDERLINES VALUES(4,5,40101,518.00,2,12.00);
INSERT INTO ORDERLINES VALUES(4,6,60501,270.00,30,1.00);
INSERT INTO ORDERLINES VALUES(4,7,60500,165.00,30,1.00);
INSERT INTO ORDERLINES VALUES(4,8,40103,615.00,30,1.00);
INSERT INTO ORDERLINES VALUES(4,9,50101,32.00,200,1.00);
INSERT INTO ORDERLINES VALUES(5,1,60400,6.00,188,11.00);
INSERT INTO ORDERLINES VALUES(5,2,60100,9.00,24,9.00);
INSERT INTO ORDERLINES VALUES(5,3,50202,8.00,32,22.00);
INSERT INTO ORDERLINES VALUES(5,5,40102,555.00,4,24.00);
INSERT INTO ORDERLINES VALUES(6,1,60102,39.00,36,3.00);
INSERT INTO ORDERLINES VALUES(6,2,60402,9.00,188,25.00);
INSERT INTO ORDERLINES VALUES(6,3,50101,32.00,48,20.00);
INSERT INTO ORDERLINES VALUES(6,4,40101,518.00,2,17.00);
INSERT INTO ORDERLINES VALUES(6,5,40200,120.00,7,9.00);
INSERT INTO ORDERLINES VALUES(6,6,40403,21.00,37,14.00);
INSERT INTO ORDERLINES VALUES(7,1,60402,9.00,252,25.00);
INSERT INTO ORDERLINES VALUES(7,2,60301,11.00,321,23.00);
INSERT INTO ORDERLINES VALUES(7,3,50101,32.00,80,3.00);
INSERT INTO ORDERLINES VALUES(7,4,40100,165.00,1,9.00);
INSERT INTO ORDERLINES VALUES(7,5,40102,555.00,1,5.00);
INSERT INTO ORDERLINES VALUES(7,6,40101,518.00,1,1.00);
INSERT INTO ORDERLINES VALUES(8,1,60501,270.00,14,13.00);
INSERT INTO ORDERLINES VALUES(8,2,60302,6.00,504,18.00);
INSERT INTO ORDERLINES VALUES(8,3,50201,10.00,80,16.00);
INSERT INTO ORDERLINES VALUES(8,4,40102,555.00,8,24.00);
INSERT INTO ORDERLINES VALUES(8,6,40402,54.00,42,12.00);
INSERT INTO ORDERLINES VALUES(9,1,60301,11.00,427,9.00);
INSERT INTO ORDERLINES VALUES(9,2,60500,165.00,24,23.00);
INSERT INTO ORDERLINES VALUES(9,3,50203,8.00,64,17.00);
INSERT INTO ORDERLINES VALUES(9,4,40402,54.00,32,21.00);
INSERT INTO ORDERLINES VALUES(9,5,40401,111.00,3,23.00);
INSERT INTO ORDERLINES VALUES(9,6,40200,120.00,16,14.00);
INSERT INTO ORDERLINES VALUES(10,1,60102,39.00,36,25.00);
INSERT INTO ORDERLINES VALUES(10,2,60401,9.00,378,2.00);
INSERT INTO ORDERLINES VALUES(10,3,50102,56.00,48,14.00);
INSERT INTO ORDERLINES VALUES(10,4,40300,14.00,7,18.00);
INSERT INTO ORDERLINES VALUES(10,5,40103,615.00,3,22.00);
INSERT INTO ORDERLINES VALUES(10,6,40101,518.00,1,16.00);
INSERT INTO ORDERLINES VALUES(11,1,60301,11.00,266,6.00);
INSERT INTO ORDERLINES VALUES(11,2,60100,9.00,49,4.00);
INSERT INTO ORDERLINES VALUES(11,3,50102,56.00,80,23.00);
INSERT INTO ORDERLINES VALUES(11,4,40302,18.00,4,17.00);
INSERT INTO ORDERLINES VALUES(11,5,40401,111.00,28,17.00);
INSERT INTO ORDERLINES VALUES(11,6,40403,21.00,37,21.00);
INSERT INTO ORDERLINES VALUES(12,1,60300,9.00,124,5.00);
INSERT INTO ORDERLINES VALUES(12,2,60202,30.00,62,25.00);
INSERT INTO ORDERLINES VALUES(12,3,50102,56.00,80,13.00);
INSERT INTO ORDERLINES VALUES(12,4,40300,14.00,30,19.00);
INSERT INTO ORDERLINES VALUES(12,5,40200,120.00,22,7.00);
INSERT INTO ORDERLINES VALUES(12,6,40201,129.00,1,24.00);
INSERT INTO ORDERLINES VALUES(13,1,60101,12.00,87,11.00);
INSERT INTO ORDERLINES VALUES(13,2,60200,6.00,74,1.00);
INSERT INTO ORDERLINES VALUES(13,3,50102,56.00,48,15.00);
INSERT INTO ORDERLINES VALUES(13,4,40301,131.00,4,4.00);
INSERT INTO ORDERLINES VALUES(13,5,40102,555.00,8,13.00);
INSERT INTO ORDERLINES VALUES(13,6,40300,14.00,1,24.00);
INSERT INTO ORDERLINES VALUES(15,1,60200,6.00,36,5.00);
INSERT INTO ORDERLINES VALUES(15,2,50203,8.00,64,5.00);
INSERT INTO ORDERLINES VALUES(15,3,40303,24.00,32,5.00);
INSERT INTO ORDERLINES VALUES(15,4,40302,18.00,7,5.00);
INSERT INTO ORDERLINES VALUES(15,5,40102,555.00,10,5.00);
INSERT INTO ORDERLINES VALUES(15,6,40101,518.00,10,5.00);
INSERT INTO ORDERLINES VALUES(15,7,40103,615.00,10,5.00);
INSERT INTO ORDERLINES VALUES(15,8,40100,165.00,10,5.00);
INSERT INTO ORDERLINES VALUES(15,9,40102,555.00,10,5.00);
INSERT INTO ORDERLINES VALUES(16,1,60402,9.00,188,19.00);
INSERT INTO ORDERLINES VALUES(16,2,60401,9.00,62,20.00);
INSERT INTO ORDERLINES VALUES(16,3,50100,28.00,80,16.00);
INSERT INTO ORDERLINES VALUES(16,4,40101,518.00,8,4.00);
INSERT INTO ORDERLINES VALUES(16,5,40201,129.00,13,10.00);
INSERT INTO ORDERLINES VALUES(16,6,40302,18.00,36,22.00);
INSERT INTO ORDERLINES VALUES(17,1,60400,6.00,378,18.00);
INSERT INTO ORDERLINES VALUES(17,2,60500,165.00,1,3.00);
INSERT INTO ORDERLINES VALUES(17,3,50201,10.00,16,16.00);
INSERT INTO ORDERLINES VALUES(17,4,40100,165.00,34,10.00);
INSERT INTO ORDERLINES VALUES(17,5,40101,518.00,4,20.00);
INSERT INTO ORDERLINES VALUES(17,6,40402,54.00,62,13.00);
INSERT INTO ORDERLINES VALUES(17,7,40102,555.00,10,1.00);
INSERT INTO ORDERLINES VALUES(17,8,40101,518.00,10,1.00);
INSERT INTO ORDERLINES VALUES(18,1,60202,30.00,36,17.00);
INSERT INTO ORDERLINES VALUES(18,2,60402,9.00,124,16.00);
INSERT INTO ORDERLINES VALUES(18,3,50100,28.00,16,12.00);
INSERT INTO ORDERLINES VALUES(18,4,40300,14.00,7,17.00);
INSERT INTO ORDERLINES VALUES(18,5,40401,111.00,22,8.00);
INSERT INTO ORDERLINES VALUES(18,6,40102,555.00,7,2.00);
INSERT INTO ORDERLINES VALUES(19,1,60400,6.00,62,20.00);
INSERT INTO ORDERLINES VALUES(19,2,60201,12.00,49,20.00);
INSERT INTO ORDERLINES VALUES(19,3,50201,10.00,32,25.00);
INSERT INTO ORDERLINES VALUES(19,4,40303,24.00,25,12.00);
INSERT INTO ORDERLINES VALUES(19,5,40102,555.00,3,5.00);
INSERT INTO ORDERLINES VALUES(19,6,40202,84.00,19,5.00);
INSERT INTO ORDERLINES VALUES(20,1,60400,6.00,442,19.00);
INSERT INTO ORDERLINES VALUES(20,2,60201,12.00,49,12.00);
INSERT INTO ORDERLINES VALUES(20,3,50101,32.00,48,12.00);
INSERT INTO ORDERLINES VALUES(20,4,40401,111.00,3,16.00);
INSERT INTO ORDERLINES VALUES(20,5,40403,21.00,37,21.00);
INSERT INTO ORDERLINES VALUES(20,6,40202,84.00,1,20.00);
INSERT INTO ORDERLINES VALUES(22,1,60500,165.00,11,2.00);
INSERT INTO ORDERLINES VALUES(22,2,60102,39.00,49,25.00);
INSERT INTO ORDERLINES VALUES(22,3,50101,32.00,64,1.00);
INSERT INTO ORDERLINES VALUES(22,4,40200,120.00,7,9.00);
INSERT INTO ORDERLINES VALUES(22,5,40102,555.00,8,3.00);
INSERT INTO ORDERLINES VALUES(22,6,40403,21.00,52,15.00);
INSERT INTO ORDERLINES VALUES(24,1,60301,11.00,159,16.00);
INSERT INTO ORDERLINES VALUES(24,2,60200,6.00,11,12.00);
INSERT INTO ORDERLINES VALUES(24,3,50100,28.00,16,14.00);
INSERT INTO ORDERLINES VALUES(24,4,40101,518.00,2,17.00);
INSERT INTO ORDERLINES VALUES(24,5,40401,111.00,37,21.00);
INSERT INTO ORDERLINES VALUES(24,6,40402,54.00,62,1.00);
INSERT INTO ORDERLINES VALUES(25,1,60401,9.00,631,1.00);
INSERT INTO ORDERLINES VALUES(25,2,60202,30.00,87,18.00);
INSERT INTO ORDERLINES VALUES(25,3,50201,10.00,64,1.00);
INSERT INTO ORDERLINES VALUES(25,4,40303,24.00,15,15.00);
INSERT INTO ORDERLINES VALUES(25,5,40403,21.00,16,9.00);
INSERT INTO ORDERLINES VALUES(25,6,40400,65.00,22,16.00);
INSERT INTO ORDERLINES VALUES(26,1,60200,6.00,62,11.00);
INSERT INTO ORDERLINES VALUES(26,2,60302,6.00,453,4.00);
INSERT INTO ORDERLINES VALUES(26,3,50100,28.00,48,22.00);
INSERT INTO ORDERLINES VALUES(26,4,40102,555.00,10,23.00);
INSERT INTO ORDERLINES VALUES(26,5,40400,65.00,16,7.00);
INSERT INTO ORDERLINES VALUES(27,1,60500,165.00,24,3.00);
INSERT INTO ORDERLINES VALUES(27,2,60100,9.00,124,13.00);
INSERT INTO ORDERLINES VALUES(27,3,50101,32.00,48,21.00);
INSERT INTO ORDERLINES VALUES(27,4,40200,120.00,22,8.00);
INSERT INTO ORDERLINES VALUES(27,5,40102,555.00,8,7.00);
INSERT INTO ORDERLINES VALUES(27,6,40301,131.00,3,23.00);
INSERT INTO ORDERLINES VALUES(28,1,60102,39.00,124,3.00);
INSERT INTO ORDERLINES VALUES(28,2,60402,9.00,442,15.00);
INSERT INTO ORDERLINES VALUES(28,3,50101,32.00,80,1.00);
INSERT INTO ORDERLINES VALUES(28,4,40100,165.00,15,7.00);
INSERT INTO ORDERLINES VALUES(28,5,40302,18.00,3,23.00);
INSERT INTO ORDERLINES VALUES(28,6,40201,129.00,25,17.00);
INSERT INTO ORDERLINES VALUES(28,8,40102,555.00,15,1.00);
INSERT INTO ORDERLINES VALUES(28,9,40101,518.00,10,1.00);
INSERT INTO ORDERLINES VALUES(29,1,60100,9.00,62,1.00);
INSERT INTO ORDERLINES VALUES(29,2,60302,6.00,301,2.00);
INSERT INTO ORDERLINES VALUES(29,3,50202,8.00,80,22.00);
INSERT INTO ORDERLINES VALUES(29,4,40402,54.00,28,14.00);
INSERT INTO ORDERLINES VALUES(29,5,40201,129.00,16,5.00);
INSERT INTO ORDERLINES VALUES(30,1,60101,12.00,36,9.00);
INSERT INTO ORDERLINES VALUES(30,2,60501,270.00,31,12.00);
INSERT INTO ORDERLINES VALUES(30,3,50101,32.00,48,9.00);
INSERT INTO ORDERLINES VALUES(30,4,40303,24.00,22,19.00);
INSERT INTO ORDERLINES VALUES(30,5,40300,14.00,16,20.00);
INSERT INTO ORDERLINES VALUES(31,1,60200,6.00,87,12.00);
INSERT INTO ORDERLINES VALUES(31,2,60401,9.00,315,21.00);
INSERT INTO ORDERLINES VALUES(31,3,50102,56.00,80,1.00);
INSERT INTO ORDERLINES VALUES(31,4,40402,54.00,7,23.00);
INSERT INTO ORDERLINES VALUES(31,5,40100,165.00,1,19.00);
INSERT INTO ORDERLINES VALUES(31,6,40102,555.00,3,5.00);
INSERT INTO ORDERLINES VALUES(32,1,60200,6.00,36,18.00);
INSERT INTO ORDERLINES VALUES(32,2,60102,39.00,24,1.00);
INSERT INTO ORDERLINES VALUES(32,3,50100,28.00,32,11.00);
INSERT INTO ORDERLINES VALUES(32,4,40100,165.00,34,19.00);
INSERT INTO ORDERLINES VALUES(32,5,40102,555.00,10,24.00);
INSERT INTO ORDERLINES VALUES(32,6,40103,615.00,4,3.00);
INSERT INTO ORDERLINES VALUES(33,1,60102,39.00,62,3.00);
INSERT INTO ORDERLINES VALUES(33,2,60500,165.00,24,20.00);
INSERT INTO ORDERLINES VALUES(33,3,50202,8.00,32,4.00);
INSERT INTO ORDERLINES VALUES(33,4,40403,21.00,62,18.00);
INSERT INTO ORDERLINES VALUES(33,5,40301,131.00,3,17.00);
INSERT INTO ORDERLINES VALUES(33,6,40302,18.00,7,25.00);
INSERT INTO ORDERLINES VALUES(34,1,60302,6.00,150,10.00);
INSERT INTO ORDERLINES VALUES(34,2,60501,270.00,31,8.00);
INSERT INTO ORDERLINES VALUES(34,3,50203,8.00,48,20.00);
INSERT INTO ORDERLINES VALUES(34,4,40402,54.00,42,4.00);
INSERT INTO ORDERLINES VALUES(34,5,40201,129.00,8,21.00);
INSERT INTO ORDERLINES VALUES(34,6,40100,165.00,18,23.00);
INSERT INTO ORDERLINES VALUES(35,1,60302,6.00,301,16.00);
INSERT INTO ORDERLINES VALUES(35,2,60400,6.00,315,2.00);
INSERT INTO ORDERLINES VALUES(35,3,50101,32.00,16,17.00);
INSERT INTO ORDERLINES VALUES(35,4,40400,65.00,73,20.00);
INSERT INTO ORDERLINES VALUES(35,5,40300,14.00,16,8.00);
INSERT INTO ORDERLINES VALUES(35,6,40101,518.00,2,4.00);
INSERT INTO ORDERLINES VALUES(36,1,60201,12.00,62,8.00);
INSERT INTO ORDERLINES VALUES(36,2,60300,9.00,378,14.00);
INSERT INTO ORDERLINES VALUES(36,3,50101,32.00,80,22.00);
INSERT INTO ORDERLINES VALUES(36,4,40202,84.00,22,5.00);
INSERT INTO ORDERLINES VALUES(36,5,40400,65.00,32,25.00);
INSERT INTO ORDERLINES VALUES(36,6,40101,518.00,8,4.00);
INSERT INTO ORDERLINES VALUES(37,1,60202,30.00,36,11.00);
INSERT INTO ORDERLINES VALUES(37,2,60501,270.00,14,20.00);
INSERT INTO ORDERLINES VALUES(37,3,50100,28.00,32,18.00);
INSERT INTO ORDERLINES VALUES(37,4,40402,54.00,62,15.00);
INSERT INTO ORDERLINES VALUES(37,5,40201,129.00,1,5.00);
INSERT INTO ORDERLINES VALUES(37,6,40302,18.00,4,21.00);
INSERT INTO ORDERLINES VALUES(38,1,60400,6.00,378,21.00);
INSERT INTO ORDERLINES VALUES(38,2,60401,9.00,442,8.00);
INSERT INTO ORDERLINES VALUES(38,3,50100,28.00,16,12.00);
INSERT INTO ORDERLINES VALUES(38,4,40202,84.00,16,25.00);
INSERT INTO ORDERLINES VALUES(38,5,40302,18.00,4,8.00);
INSERT INTO ORDERLINES VALUES(38,6,40100,165.00,34,6.00);
INSERT INTO ORDERLINES VALUES(39,1,60501,270.00,14,7.00);
INSERT INTO ORDERLINES VALUES(39,2,60500,165.00,24,21.00);
INSERT INTO ORDERLINES VALUES(39,3,50202,8.00,48,22.00);
INSERT INTO ORDERLINES VALUES(39,4,40200,120.00,13,22.00);
INSERT INTO ORDERLINES VALUES(39,5,40103,615.00,10,1.00);
INSERT INTO ORDERLINES VALUES(39,6,40201,129.00,3,9.00);
INSERT INTO ORDERLINES VALUES(41,1,60101,12.00,62,2.00);
INSERT INTO ORDERLINES VALUES(41,2,60100,9.00,11,18.00);
INSERT INTO ORDERLINES VALUES(41,3,50203,8.00,64,1.00);
INSERT INTO ORDERLINES VALUES(41,4,40402,54.00,13,11.00);
INSERT INTO ORDERLINES VALUES(41,5,40301,131.00,3,6.00);
INSERT INTO ORDERLINES VALUES(41,6,40102,555.00,1,6.00);
INSERT INTO ORDERLINES VALUES(42,1,60100,9.00,98,11.00);
INSERT INTO ORDERLINES VALUES(42,2,60102,39.00,11,10.00);
INSERT INTO ORDERLINES VALUES(42,3,50101,32.00,48,11.00);
INSERT INTO ORDERLINES VALUES(42,4,40400,65.00,42,7.00);
INSERT INTO ORDERLINES VALUES(42,5,40403,21.00,62,19.00);
INSERT INTO ORDERLINES VALUES(42,6,40200,120.00,19,4.00);
INSERT INTO ORDERLINES VALUES(43,1,60102,39.00,24,3.00);
INSERT INTO ORDERLINES VALUES(43,2,60301,11.00,427,14.00);
INSERT INTO ORDERLINES VALUES(43,3,50202,8.00,16,11.00);
INSERT INTO ORDERLINES VALUES(43,4,40401,111.00,13,13.00);
INSERT INTO ORDERLINES VALUES(43,5,40202,84.00,7,19.00);
INSERT INTO ORDERLINES VALUES(43,6,40100,165.00,15,7.00);
INSERT INTO ORDERLINES VALUES(44,1,60200,6.00,11,1.00);
INSERT INTO ORDERLINES VALUES(44,2,60402,9.00,188,2.00);
INSERT INTO ORDERLINES VALUES(44,3,50202,8.00,16,7.00);
INSERT INTO ORDERLINES VALUES(44,4,40102,555.00,4,15.00);
INSERT INTO ORDERLINES VALUES(44,5,40401,111.00,66,13.00);
INSERT INTO ORDERLINES VALUES(44,6,40302,18.00,3,22.00);
INSERT INTO ORDERLINES VALUES(45,1,60100,9.00,11,1.00);
INSERT INTO ORDERLINES VALUES(45,2,60401,9.00,124,11.00);
INSERT INTO ORDERLINES VALUES(45,3,50201,10.00,48,18.00);
INSERT INTO ORDERLINES VALUES(45,4,40202,84.00,13,24.00);
INSERT INTO ORDERLINES VALUES(45,5,40400,65.00,42,16.00);
INSERT INTO ORDERLINES VALUES(45,6,40402,54.00,3,12.00);
INSERT INTO ORDERLINES VALUES(46,1,60201,12.00,36,18.00);
INSERT INTO ORDERLINES VALUES(46,2,60102,39.00,62,20.00);
INSERT INTO ORDERLINES VALUES(46,3,50102,56.00,16,24.00);
INSERT INTO ORDERLINES VALUES(46,4,40101,518.00,7,15.00);
INSERT INTO ORDERLINES VALUES(46,5,40301,131.00,4,12.00);
INSERT INTO ORDERLINES VALUES(46,6,40200,120.00,13,8.00);
INSERT INTO ORDERLINES VALUES(47,1,60401,9.00,252,18.00);
INSERT INTO ORDERLINES VALUES(47,2,60102,39.00,36,11.00);
INSERT INTO ORDERLINES VALUES(47,3,50202,8.00,48,18.00);
INSERT INTO ORDERLINES VALUES(47,4,40401,111.00,28,25.00);
INSERT INTO ORDERLINES VALUES(47,5,40103,615.00,1,5.00);
INSERT INTO ORDERLINES VALUES(47,6,40201,129.00,3,24.00);
INSERT INTO ORDERLINES VALUES(48,1,60201,12.00,111,9.00);
INSERT INTO ORDERLINES VALUES(48,2,60401,9.00,568,5.00);
INSERT INTO ORDERLINES VALUES(48,3,50101,32.00,16,17.00);
INSERT INTO ORDERLINES VALUES(48,4,40400,65.00,62,19.00);
INSERT INTO ORDERLINES VALUES(48,5,40100,165.00,40,1.00);
INSERT INTO ORDERLINES VALUES(48,6,40101,518.00,1,10.00);
INSERT INTO ORDERLINES VALUES(49,1,60300,9.00,62,24.00);
INSERT INTO ORDERLINES VALUES(49,2,60501,270.00,14,11.00);
INSERT INTO ORDERLINES VALUES(49,3,50201,10.00,32,10.00);
INSERT INTO ORDERLINES VALUES(49,4,40402,54.00,28,21.00);
INSERT INTO ORDERLINES VALUES(49,5,40301,131.00,2,18.00);
INSERT INTO ORDERLINES VALUES(49,6,40300,14.00,1,20.00);
INSERT INTO ORDERLINES VALUES(50,1,60100,9.00,74,21.00);
INSERT INTO ORDERLINES VALUES(50,2,60500,165.00,24,16.00);
INSERT INTO ORDERLINES VALUES(50,3,50201,10.00,80,3.00);
INSERT INTO ORDERLINES VALUES(50,4,40201,129.00,7,8.00);
INSERT INTO ORDERLINES VALUES(50,5,40303,24.00,25,5.00);
INSERT INTO ORDERLINES VALUES(50,6,40402,54.00,37,20.00);
INSERT INTO ORDERLINES VALUES(51,1,60501,270.00,14,3.00);
INSERT INTO ORDERLINES VALUES(51,2,60100,9.00,124,18.00);
INSERT INTO ORDERLINES VALUES(51,3,50100,28.00,64,4.00);
INSERT INTO ORDERLINES VALUES(51,4,40403,21.00,48,12.00);
INSERT INTO ORDERLINES VALUES(51,5,40201,129.00,4,10.00);
INSERT INTO ORDERLINES VALUES(51,6,40102,555.00,4,25.00);
INSERT INTO ORDERLINES VALUES(52,1,60302,6.00,301,22.00);
INSERT INTO ORDERLINES VALUES(52,2,60201,12.00,62,14.00);
INSERT INTO ORDERLINES VALUES(52,3,50201,10.00,80,1.00);
INSERT INTO ORDERLINES VALUES(52,4,40201,129.00,13,8.00);
INSERT INTO ORDERLINES VALUES(52,5,40400,65.00,52,9.00);
INSERT INTO ORDERLINES VALUES(52,6,40202,84.00,16,15.00);
INSERT INTO ORDERLINES VALUES(53,1,60100,9.00,87,1.00);
INSERT INTO ORDERLINES VALUES(53,2,60400,6.00,124,2.00);
INSERT INTO ORDERLINES VALUES(53,3,50202,8.00,64,5.00);
INSERT INTO ORDERLINES VALUES(53,4,40401,111.00,73,11.00);
INSERT INTO ORDERLINES VALUES(53,5,40103,615.00,1,16.00);
INSERT INTO ORDERLINES VALUES(53,6,40303,24.00,7,10.00);
INSERT INTO ORDERLINES VALUES(54,1,60100,9.00,124,9.00);
INSERT INTO ORDERLINES VALUES(54,2,60402,9.00,504,25.00);
INSERT INTO ORDERLINES VALUES(54,3,50101,32.00,80,11.00);
INSERT INTO ORDERLINES VALUES(54,4,40403,21.00,32,20.00);
INSERT INTO ORDERLINES VALUES(54,5,40301,131.00,4,4.00);
INSERT INTO ORDERLINES VALUES(54,6,40201,129.00,13,2.00);
INSERT INTO ORDERLINES VALUES(55,1,60500,165.00,24,18.00);
INSERT INTO ORDERLINES VALUES(55,2,60401,9.00,631,7.00);
INSERT INTO ORDERLINES VALUES(55,3,50203,8.00,64,21.00);
INSERT INTO ORDERLINES VALUES(55,4,40102,555.00,1,15.00);
INSERT INTO ORDERLINES VALUES(55,5,40200,120.00,16,13.00);
INSERT INTO ORDERLINES VALUES(55,6,40101,518.00,2,20.00);
INSERT INTO ORDERLINES VALUES(56,1,60100,9.00,11,15.00);
INSERT INTO ORDERLINES VALUES(56,2,60302,6.00,403,24.00);
INSERT INTO ORDERLINES VALUES(56,3,50203,8.00,48,17.00);
INSERT INTO ORDERLINES VALUES(56,4,40400,65.00,37,16.00);
INSERT INTO ORDERLINES VALUES(56,5,40200,120.00,16,18.00);
INSERT INTO ORDERLINES VALUES(56,6,40201,129.00,1,3.00);
INSERT INTO ORDERLINES VALUES(57,1,60201,12.00,111,9.00);
INSERT INTO ORDERLINES VALUES(57,2,60501,270.00,14,14.00);
INSERT INTO ORDERLINES VALUES(57,3,50203,8.00,64,4.00);
INSERT INTO ORDERLINES VALUES(57,4,40103,615.00,10,48.00);
INSERT INTO ORDERLINES VALUES(57,5,40303,24.00,3,9.00);
INSERT INTO ORDERLINES VALUES(57,6,40101,518.00,2,48.00);
INSERT INTO ORDERLINES VALUES(58,1,60302,6.00,301,24.00);
INSERT INTO ORDERLINES VALUES(58,2,60301,11.00,535,3.00);
INSERT INTO ORDERLINES VALUES(58,3,50102,56.00,64,18.00);
INSERT INTO ORDERLINES VALUES(58,4,40103,615.00,7,12.00);
INSERT INTO ORDERLINES VALUES(58,5,40402,54.00,16,7.00);
INSERT INTO ORDERLINES VALUES(58,6,40400,65.00,16,13.00);
INSERT INTO ORDERLINES VALUES(59,1,60400,6.00,504,16.00);
INSERT INTO ORDERLINES VALUES(59,3,50203,8.00,32,19.00);
INSERT INTO ORDERLINES VALUES(59,4,40201,129.00,16,24.00);
INSERT INTO ORDERLINES VALUES(59,5,40301,131.00,4,4.00);
INSERT INTO ORDERLINES VALUES(59,6,40400,65.00,32,12.00);
INSERT INTO ORDERLINES VALUES(60,1,60501,270.00,14,6.00);
INSERT INTO ORDERLINES VALUES(60,2,60302,6.00,201,24.00);
INSERT INTO ORDERLINES VALUES(60,3,50202,8.00,48,20.00);
INSERT INTO ORDERLINES VALUES(60,4,40103,615.00,7,1.00);
INSERT INTO ORDERLINES VALUES(60,5,40400,65.00,73,14.00);
INSERT INTO ORDERLINES VALUES(60,6,40201,129.00,19,8.00);
INSERT INTO ORDERLINES VALUES(61,1,60500,165.00,1,14.00);
INSERT INTO ORDERLINES VALUES(61,2,60501,270.00,31,2.00);
INSERT INTO ORDERLINES VALUES(61,3,50202,8.00,48,13.00);
INSERT INTO ORDERLINES VALUES(61,4,40201,129.00,13,15.00);
INSERT INTO ORDERLINES VALUES(61,5,40403,21.00,73,9.00);
INSERT INTO ORDERLINES VALUES(61,6,40100,165.00,34,3.00);
INSERT INTO ORDERLINES VALUES(62,1,60400,6.00,568,25.00);
INSERT INTO ORDERLINES VALUES(62,2,60301,11.00,374,3.00);
INSERT INTO ORDERLINES VALUES(62,3,50101,32.00,32,14.00);
INSERT INTO ORDERLINES VALUES(62,4,40103,615.00,10,19.00);
INSERT INTO ORDERLINES VALUES(62,5,40200,120.00,8,1.00);
INSERT INTO ORDERLINES VALUES(62,6,40201,129.00,19,11.00);
INSERT INTO ORDERLINES VALUES(63,1,60402,9.00,124,2.00);
INSERT INTO ORDERLINES VALUES(63,2,60101,12.00,36,4.00);
INSERT INTO ORDERLINES VALUES(63,3,50102,56.00,80,5.00);
INSERT INTO ORDERLINES VALUES(63,4,40200,120.00,22,12.00);
INSERT INTO ORDERLINES VALUES(63,5,40300,14.00,4,19.00);
INSERT INTO ORDERLINES VALUES(63,6,40202,84.00,16,18.00);
INSERT INTO ORDERLINES VALUES(64,1,60302,6.00,353,21.00);
INSERT INTO ORDERLINES VALUES(64,2,60500,165.00,11,6.00);
INSERT INTO ORDERLINES VALUES(64,3,50201,10.00,32,1.00);
INSERT INTO ORDERLINES VALUES(64,4,40300,14.00,10,7.00);
INSERT INTO ORDERLINES VALUES(64,5,40403,21.00,73,18.00);
INSERT INTO ORDERLINES VALUES(64,6,40100,165.00,9,1.00);
INSERT INTO ORDERLINES VALUES(65,1,60401,9.00,124,25.00);
INSERT INTO ORDERLINES VALUES(65,2,60501,270.00,46,10.00);
INSERT INTO ORDERLINES VALUES(65,3,50203,8.00,64,24.00);
INSERT INTO ORDERLINES VALUES(65,4,40401,111.00,13,6.00);
INSERT INTO ORDERLINES VALUES(65,5,40302,18.00,22,19.00);
INSERT INTO ORDERLINES VALUES(65,6,40100,165.00,15,12.00);
INSERT INTO ORDERLINES VALUES(66,1,60200,6.00,87,22.00);
INSERT INTO ORDERLINES VALUES(66,2,60100,9.00,24,2.00);
INSERT INTO ORDERLINES VALUES(66,3,50202,8.00,80,5.00);
INSERT INTO ORDERLINES VALUES(66,4,40400,65.00,42,14.00);
INSERT INTO ORDERLINES VALUES(66,6,40102,555.00,4,2.00);
INSERT INTO ORDERLINES VALUES(67,1,60501,270.00,14,19.00);
INSERT INTO ORDERLINES VALUES(67,2,60202,30.00,124,2.00);
INSERT INTO ORDERLINES VALUES(67,3,50203,8.00,64,17.00);
INSERT INTO ORDERLINES VALUES(67,4,40101,518.00,7,18.00);
INSERT INTO ORDERLINES VALUES(67,5,40302,18.00,25,19.00);
INSERT INTO ORDERLINES VALUES(68,1,60301,11.00,482,23.00);
INSERT INTO ORDERLINES VALUES(68,2,60302,6.00,353,8.00);
INSERT INTO ORDERLINES VALUES(68,3,50203,8.00,16,23.00);
INSERT INTO ORDERLINES VALUES(68,4,40101,518.00,2,8.00);
INSERT INTO ORDERLINES VALUES(68,5,40403,21.00,66,23.00);
INSERT INTO ORDERLINES VALUES(68,6,40400,65.00,13,12.00);
INSERT INTO ORDERLINES VALUES(69,1,60301,11.00,374,4.00);
INSERT INTO ORDERLINES VALUES(69,2,60102,39.00,74,25.00);
INSERT INTO ORDERLINES VALUES(69,3,50201,10.00,64,15.00);
INSERT INTO ORDERLINES VALUES(69,4,40103,615.00,1,18.00);
INSERT INTO ORDERLINES VALUES(69,6,40301,131.00,2,17.00);
INSERT INTO ORDERLINES VALUES(70,1,60401,9.00,631,10.00);
INSERT INTO ORDERLINES VALUES(70,2,60202,30.00,111,11.00);
INSERT INTO ORDERLINES VALUES(70,3,50203,8.00,32,11.00);
INSERT INTO ORDERLINES VALUES(70,4,40100,165.00,15,12.00);
INSERT INTO ORDERLINES VALUES(70,5,40303,24.00,7,5.00);
INSERT INTO ORDERLINES VALUES(70,6,40103,615.00,1,12.00);
INSERT INTO ORDERLINES VALUES(71,1,60500,165.00,1,22.00);
INSERT INTO ORDERLINES VALUES(71,2,60100,9.00,36,8.00);
INSERT INTO ORDERLINES VALUES(71,3,50101,32.00,48,2.00);
INSERT INTO ORDERLINES VALUES(71,4,40303,24.00,4,23.00);
INSERT INTO ORDERLINES VALUES(71,5,40101,518.00,4,40.00);
INSERT INTO ORDERLINES VALUES(71,6,40100,165.00,1,14.00);
INSERT INTO ORDERLINES VALUES(72,1,60500,165.00,36,25.00);
INSERT INTO ORDERLINES VALUES(72,2,60202,30.00,74,19.00);
INSERT INTO ORDERLINES VALUES(72,3,50202,8.00,32,4.00);
INSERT INTO ORDERLINES VALUES(72,4,40100,165.00,2,6.00);
INSERT INTO ORDERLINES VALUES(72,6,40402,54.00,13,10.00);
INSERT INTO ORDERLINES VALUES(73,1,60100,9.00,111,11.00);
INSERT INTO ORDERLINES VALUES(73,2,60301,11.00,374,4.00);
INSERT INTO ORDERLINES VALUES(73,3,50101,32.00,32,24.00);
INSERT INTO ORDERLINES VALUES(73,4,40402,54.00,37,21.00);
INSERT INTO ORDERLINES VALUES(73,5,40303,24.00,13,13.00);
INSERT INTO ORDERLINES VALUES(73,6,40101,518.00,1,48.00);
INSERT INTO ORDERLINES VALUES(74,1,60102,39.00,87,24.00);
INSERT INTO ORDERLINES VALUES(74,2,60201,12.00,24,23.00);
INSERT INTO ORDERLINES VALUES(74,3,50202,8.00,64,11.00);
INSERT INTO ORDERLINES VALUES(74,4,40202,84.00,20,19.00);
INSERT INTO ORDERLINES VALUES(74,5,40102,555.00,10,2.00);
INSERT INTO ORDERLINES VALUES(74,6,40103,615.00,7,10.00);
INSERT INTO ORDERLINES VALUES(75,1,60200,6.00,62,6.00);
INSERT INTO ORDERLINES VALUES(75,2,60202,30.00,124,11.00);
INSERT INTO ORDERLINES VALUES(75,3,50203,8.00,80,10.00);
INSERT INTO ORDERLINES VALUES(75,4,40102,555.00,3,4.00);
INSERT INTO ORDERLINES VALUES(75,5,40201,129.00,16,5.00);
INSERT INTO ORDERLINES VALUES(76,1,60101,12.00,24,13.00);
INSERT INTO ORDERLINES VALUES(76,2,60302,6.00,504,14.00);
INSERT INTO ORDERLINES VALUES(76,3,50203,8.00,32,23.00);
INSERT INTO ORDERLINES VALUES(76,4,40401,111.00,28,21.00);
INSERT INTO ORDERLINES VALUES(76,5,40400,65.00,66,13.00);
INSERT INTO ORDERLINES VALUES(76,6,40301,131.00,4,25.00);
INSERT INTO ORDERLINES VALUES(77,1,60202,30.00,111,13.00);
INSERT INTO ORDERLINES VALUES(77,2,60500,165.00,11,23.00);
INSERT INTO ORDERLINES VALUES(77,3,50101,32.00,32,17.00);
INSERT INTO ORDERLINES VALUES(77,4,40301,131.00,3,25.00);
INSERT INTO ORDERLINES VALUES(77,5,40101,518.00,4,7.00);
INSERT INTO ORDERLINES VALUES(77,6,40302,18.00,25,24.00);
INSERT INTO ORDERLINES VALUES(78,1,60501,270.00,1,12.00);
INSERT INTO ORDERLINES VALUES(78,2,60401,9.00,442,14.00);
INSERT INTO ORDERLINES VALUES(78,3,50102,56.00,64,8.00);
INSERT INTO ORDERLINES VALUES(78,4,40303,24.00,1,5.00);
INSERT INTO ORDERLINES VALUES(78,5,40302,18.00,19,19.00);
INSERT INTO ORDERLINES VALUES(78,6,40103,615.00,1,17.00);
INSERT INTO ORDERLINES VALUES(79,1,60501,270.00,1,4.00);
INSERT INTO ORDERLINES VALUES(79,2,60500,165.00,24,10.00);
INSERT INTO ORDERLINES VALUES(79,3,50100,28.00,64,15.00);
INSERT INTO ORDERLINES VALUES(79,4,40103,615.00,3,48.00);
INSERT INTO ORDERLINES VALUES(79,5,40101,518.00,7,48.00);
INSERT INTO ORDERLINES VALUES(79,6,40301,131.00,3,13.00);
INSERT INTO ORDERLINES VALUES(100,1,60100,10.00,116,17.00);
INSERT INTO ORDERLINES VALUES(100,2,60501,311.00,5,1.00);
INSERT INTO ORDERLINES VALUES(100,3,60301,13.00,248,7.00);
INSERT INTO ORDERLINES VALUES(100,4,50102,62.00,48,16.00);
INSERT INTO ORDERLINES VALUES(100,5,40403,22.00,18,19.00);
INSERT INTO ORDERLINES VALUES(100,6,40400,68.00,30,5.00);
INSERT INTO ORDERLINES VALUES(101,1,60102,43.00,29,13.00);
INSERT INTO ORDERLINES VALUES(101,2,60201,13.00,2,10.00);
INSERT INTO ORDERLINES VALUES(101,3,60100,10.00,77,19.00);
INSERT INTO ORDERLINES VALUES(101,4,50202,9.00,48,25.00);
INSERT INTO ORDERLINES VALUES(101,5,40101,466.00,2,13.00);
INSERT INTO ORDERLINES VALUES(101,6,40302,19.00,14,23.00);
INSERT INTO ORDERLINES VALUES(102,1,60101,13.00,93,5.00);
INSERT INTO ORDERLINES VALUES(102,2,60400,6.00,136,2.00);
INSERT INTO ORDERLINES VALUES(102,3,60401,11.00,198,2.00);
INSERT INTO ORDERLINES VALUES(102,4,50203,8.00,32,11.00);
INSERT INTO ORDERLINES VALUES(102,5,40102,500.00,7,12.00);
INSERT INTO ORDERLINES VALUES(102,6,40400,68.00,21,4.00);
INSERT INTO ORDERLINES VALUES(104,1,60400,6.00,207,1.00);
INSERT INTO ORDERLINES VALUES(104,2,60201,13.00,3,13.00);
INSERT INTO ORDERLINES VALUES(104,3,60202,33.00,12,19.00);
INSERT INTO ORDERLINES VALUES(104,4,50202,9.00,48,17.00);
INSERT INTO ORDERLINES VALUES(104,5,40401,117.00,10,10.00);
INSERT INTO ORDERLINES VALUES(104,6,40300,14.00,12,15.00);
INSERT INTO ORDERLINES VALUES(105,1,60402,11.00,171,22.00);
INSERT INTO ORDERLINES VALUES(105,4,50202,9.00,80,8.00);
INSERT INTO ORDERLINES VALUES(105,5,40202,80.00,3,13.00);
INSERT INTO ORDERLINES VALUES(105,6,40401,117.00,7,20.00);
INSERT INTO ORDERLINES VALUES(106,1,60500,190.00,1,19.00);
INSERT INTO ORDERLINES VALUES(106,2,60301,13.00,422,18.00);
INSERT INTO ORDERLINES VALUES(106,4,50202,9.00,32,11.00);
INSERT INTO ORDERLINES VALUES(106,5,40103,554.00,3,17.00);
INSERT INTO ORDERLINES VALUES(106,6,40402,57.00,25,5.00);
INSERT INTO ORDERLINES VALUES(107,1,60302,8.00,192,20.00);
INSERT INTO ORDERLINES VALUES(107,2,60501,311.00,80,10.00);
INSERT INTO ORDERLINES VALUES(107,3,60202,33.00,12,7.00);
INSERT INTO ORDERLINES VALUES(107,4,50203,8.00,32,6.00);
INSERT INTO ORDERLINES VALUES(107,5,40200,114.00,2,13.00);
INSERT INTO ORDERLINES VALUES(107,6,40401,117.00,10,24.00);
INSERT INTO ORDERLINES VALUES(108,1,60500,190.00,12,16.00);
INSERT INTO ORDERLINES VALUES(108,2,60301,13.00,50,11.00);
INSERT INTO ORDERLINES VALUES(108,3,60102,43.00,20,22.00);
INSERT INTO ORDERLINES VALUES(108,4,50203,8.00,64,22.00);
INSERT INTO ORDERLINES VALUES(108,5,40300,14.00,3,22.00);
INSERT INTO ORDERLINES VALUES(109,1,60101,13.00,12,10.00);
INSERT INTO ORDERLINES VALUES(109,2,60500,190.00,28,18.00);
INSERT INTO ORDERLINES VALUES(109,3,60501,311.00,1,14.00);
INSERT INTO ORDERLINES VALUES(109,4,50203,8.00,64,24.00);
INSERT INTO ORDERLINES VALUES(109,5,40200,114.00,9,2.00);
INSERT INTO ORDERLINES VALUES(109,6,40100,193.00,133,11.00);
INSERT INTO ORDERLINES VALUES(110,1,60101,13.00,68,17.00);
INSERT INTO ORDERLINES VALUES(110,2,60401,11.00,171,4.00);
INSERT INTO ORDERLINES VALUES(110,3,60100,10.00,38,8.00);
INSERT INTO ORDERLINES VALUES(110,4,50201,11.00,80,13.00);
INSERT INTO ORDERLINES VALUES(110,5,40400,68.00,75,7.00);
INSERT INTO ORDERLINES VALUES(111,1,60200,7.00,16,1.00);
INSERT INTO ORDERLINES VALUES(111,2,60201,13.00,19,24.00);
INSERT INTO ORDERLINES VALUES(111,3,60302,8.00,363,15.00);
INSERT INTO ORDERLINES VALUES(111,4,50203,8.00,32,14.00);
INSERT INTO ORDERLINES VALUES(111,5,40103,554.00,1,19.00);
INSERT INTO ORDERLINES VALUES(111,6,40303,25.00,25,8.00);
INSERT INTO ORDERLINES VALUES(113,1,60201,13.00,30,13.00);
INSERT INTO ORDERLINES VALUES(113,2,60101,13.00,5,12.00);
INSERT INTO ORDERLINES VALUES(113,3,60202,33.00,6,16.00);
INSERT INTO ORDERLINES VALUES(113,4,50203,8.00,32,15.00);
INSERT INTO ORDERLINES VALUES(113,5,40202,80.00,7,12.00);
INSERT INTO ORDERLINES VALUES(113,6,40102,500.00,19,7.00);
INSERT INTO ORDERLINES VALUES(114,1,60200,7.00,1,16.00);
INSERT INTO ORDERLINES VALUES(114,2,60400,6.00,155,5.00);
INSERT INTO ORDERLINES VALUES(114,3,60202,33.00,3,8.00);
INSERT INTO ORDERLINES VALUES(114,4,50201,11.00,32,1.00);
INSERT INTO ORDERLINES VALUES(114,5,40102,500.00,2,4.00);
INSERT INTO ORDERLINES VALUES(115,1,60201,13.00,24,21.00);
INSERT INTO ORDERLINES VALUES(115,2,60101,13.00,53,16.00);
INSERT INTO ORDERLINES VALUES(115,3,60402,11.00,45,5.00);
INSERT INTO ORDERLINES VALUES(115,4,50203,8.00,16,25.00);
INSERT INTO ORDERLINES VALUES(115,5,40303,25.00,2,25.00);
INSERT INTO ORDERLINES VALUES(115,6,40100,193.00,10,24.00);
INSERT INTO ORDERLINES VALUES(116,1,60302,8.00,165,2.00);
INSERT INTO ORDERLINES VALUES(116,2,60301,13.00,422,22.00);
INSERT INTO ORDERLINES VALUES(116,3,60501,311.00,1,21.00);
INSERT INTO ORDERLINES VALUES(116,4,50202,9.00,48,3.00);
INSERT INTO ORDERLINES VALUES(116,5,40102,500.00,1,1.00);
INSERT INTO ORDERLINES VALUES(116,6,40401,117.00,1,18.00);
INSERT INTO ORDERLINES VALUES(117,1,60401,11.00,148,17.00);
INSERT INTO ORDERLINES VALUES(117,2,60201,13.00,3,18.00);
INSERT INTO ORDERLINES VALUES(117,3,60402,11.00,298,23.00);
INSERT INTO ORDERLINES VALUES(117,4,50203,8.00,16,7.00);
INSERT INTO ORDERLINES VALUES(117,5,40403,22.00,37,1.00);
INSERT INTO ORDERLINES VALUES(117,6,40100,193.00,10,10.00);
INSERT INTO ORDERLINES VALUES(118,1,60202,33.00,24,8.00);
INSERT INTO ORDERLINES VALUES(118,2,60402,11.00,171,6.00);
INSERT INTO ORDERLINES VALUES(118,3,60400,6.00,49,15.00);
INSERT INTO ORDERLINES VALUES(118,4,50101,35.00,32,11.00);
INSERT INTO ORDERLINES VALUES(118,5,40400,68.00,37,10.00);
INSERT INTO ORDERLINES VALUES(118,6,40103,554.00,16,3.00);
INSERT INTO ORDERLINES VALUES(119,1,60200,7.00,2,20.00);
INSERT INTO ORDERLINES VALUES(119,2,60400,6.00,12,3.00);
INSERT INTO ORDERLINES VALUES(119,3,60101,13.00,12,5.00);
INSERT INTO ORDERLINES VALUES(119,4,50202,9.00,32,13.00);
INSERT INTO ORDERLINES VALUES(119,5,40400,68.00,7,3.00);
INSERT INTO ORDERLINES VALUES(119,6,40300,14.00,9,18.00);
INSERT INTO ORDERLINES VALUES(120,1,60102,43.00,29,14.00);
INSERT INTO ORDERLINES VALUES(120,2,60200,7.00,7,21.00);
INSERT INTO ORDERLINES VALUES(120,3,60400,6.00,49,13.00);
INSERT INTO ORDERLINES VALUES(120,4,50201,11.00,48,23.00);
INSERT INTO ORDERLINES VALUES(120,5,40402,57.00,56,20.00);
INSERT INTO ORDERLINES VALUES(120,6,40302,19.00,4,16.00);
INSERT INTO ORDERLINES VALUES(122,1,60100,10.00,53,18.00);
INSERT INTO ORDERLINES VALUES(122,2,60402,11.00,45,17.00);
INSERT INTO ORDERLINES VALUES(122,3,60301,13.00,79,25.00);
INSERT INTO ORDERLINES VALUES(122,4,50102,62.00,32,13.00);
INSERT INTO ORDERLINES VALUES(122,5,40300,14.00,6,9.00);
INSERT INTO ORDERLINES VALUES(122,6,40401,117.00,8,12.00);
INSERT INTO ORDERLINES VALUES(123,1,60300,11.00,422,23.00);
INSERT INTO ORDERLINES VALUES(123,2,60100,10.00,62,14.00);
INSERT INTO ORDERLINES VALUES(123,4,50100,31.00,64,15.00);
INSERT INTO ORDERLINES VALUES(123,5,40102,500.00,19,12.00);
INSERT INTO ORDERLINES VALUES(124,1,60301,13.00,106,24.00);
INSERT INTO ORDERLINES VALUES(124,2,60200,7.00,19,10.00);
INSERT INTO ORDERLINES VALUES(124,3,60402,11.00,348,9.00);
INSERT INTO ORDERLINES VALUES(124,4,50201,11.00,16,3.00);
INSERT INTO ORDERLINES VALUES(124,5,40201,123.00,9,21.00);
INSERT INTO ORDERLINES VALUES(124,6,40202,80.00,12,21.00);
INSERT INTO ORDERLINES VALUES(125,1,60100,10.00,53,4.00);
INSERT INTO ORDERLINES VALUES(125,3,60501,311.00,1,7.00);
INSERT INTO ORDERLINES VALUES(125,4,50203,8.00,48,13.00);
INSERT INTO ORDERLINES VALUES(125,5,40202,80.00,10,11.00);
INSERT INTO ORDERLINES VALUES(126,1,60101,13.00,29,25.00);
INSERT INTO ORDERLINES VALUES(126,2,60200,7.00,2,7.00);
INSERT INTO ORDERLINES VALUES(126,3,60301,13.00,138,25.00);
INSERT INTO ORDERLINES VALUES(126,4,50101,35.00,16,7.00);
INSERT INTO ORDERLINES VALUES(126,5,40300,14.00,4,14.00);
INSERT INTO ORDERLINES VALUES(126,6,40102,375.00,10,20.00);
INSERT INTO ORDERLINES VALUES(127,1,60500,190.00,28,12.00);
INSERT INTO ORDERLINES VALUES(127,2,60202,33.00,28,5.00);
INSERT INTO ORDERLINES VALUES(127,3,60402,11.00,45,16.00);
INSERT INTO ORDERLINES VALUES(127,4,50100,31.00,32,17.00);
INSERT INTO ORDERLINES VALUES(127,5,40401,117.00,10,15.00);
INSERT INTO ORDERLINES VALUES(127,6,40402,57.00,37,24.00);
INSERT INTO ORDERLINES VALUES(128,1,60201,13.00,11,18.00);
INSERT INTO ORDERLINES VALUES(128,2,60301,13.00,221,20.00);
INSERT INTO ORDERLINES VALUES(128,3,60401,11.00,348,8.00);
INSERT INTO ORDERLINES VALUES(128,4,50202,9.00,48,3.00);
INSERT INTO ORDERLINES VALUES(128,5,40103,554.00,12,24.00);
INSERT INTO ORDERLINES VALUES(128,6,40400,68.00,52,19.00);
INSERT INTO ORDERLINES VALUES(128,7,40102,555.00,2,20.00);
INSERT INTO ORDERLINES VALUES(129,1,60100,10.00,29,9.00);
INSERT INTO ORDERLINES VALUES(129,2,60301,13.00,248,17.00);
INSERT INTO ORDERLINES VALUES(129,3,60400,6.00,49,4.00);
INSERT INTO ORDERLINES VALUES(129,4,50101,35.00,80,4.00);
INSERT INTO ORDERLINES VALUES(129,5,40101,466.00,10,11.00);
INSERT INTO ORDERLINES VALUES(129,6,40303,25.00,25,7.00);
INSERT INTO ORDERLINES VALUES(130,1,60102,43.00,45,11.00);
INSERT INTO ORDERLINES VALUES(130,2,60301,13.00,50,2.00);
INSERT INTO ORDERLINES VALUES(130,3,60100,10.00,77,10.00);
INSERT INTO ORDERLINES VALUES(130,4,50201,11.00,80,22.00);
INSERT INTO ORDERLINES VALUES(130,5,40403,22.00,12,17.00);
INSERT INTO ORDERLINES VALUES(131,1,60200,7.00,16,5.00);
INSERT INTO ORDERLINES VALUES(131,2,60302,8.00,165,7.00);
INSERT INTO ORDERLINES VALUES(131,3,60101,13.00,12,22.00);
INSERT INTO ORDERLINES VALUES(131,4,50202,9.00,64,25.00);
INSERT INTO ORDERLINES VALUES(131,5,40300,14.00,7,15.00);
INSERT INTO ORDERLINES VALUES(131,6,40201,123.00,6,18.00);
INSERT INTO ORDERLINES VALUES(132,1,60202,33.00,24,3.00);
INSERT INTO ORDERLINES VALUES(132,2,60300,11.00,165,12.00);
INSERT INTO ORDERLINES VALUES(132,3,60101,13.00,77,2.00);
INSERT INTO ORDERLINES VALUES(132,4,50202,9.00,80,5.00);
INSERT INTO ORDERLINES VALUES(132,5,40201,123.00,2,24.00);
INSERT INTO ORDERLINES VALUES(133,1,60102,43.00,29,5.00);
INSERT INTO ORDERLINES VALUES(133,3,60402,11.00,45,24.00);
INSERT INTO ORDERLINES VALUES(133,4,50201,11.00,16,14.00);
INSERT INTO ORDERLINES VALUES(133,5,40300,14.00,3,17.00);
INSERT INTO ORDERLINES VALUES(133,6,40102,500.00,7,48.00);
INSERT INTO ORDERLINES VALUES(134,1,60201,13.00,19,7.00);
INSERT INTO ORDERLINES VALUES(134,2,60202,33.00,26,18.00);
INSERT INTO ORDERLINES VALUES(134,3,60500,190.00,1,22.00);
INSERT INTO ORDERLINES VALUES(134,4,50101,35.00,16,10.00);
INSERT INTO ORDERLINES VALUES(134,5,40200,114.00,1,25.00);
INSERT INTO ORDERLINES VALUES(134,6,40101,466.00,28,5.00);
INSERT INTO ORDERLINES VALUES(135,1,60302,8.00,221,1.00);
INSERT INTO ORDERLINES VALUES(135,3,60301,13.00,422,1.00);
INSERT INTO ORDERLINES VALUES(135,4,50101,35.00,48,22.00);
INSERT INTO ORDERLINES VALUES(135,5,40302,19.00,14,13.00);
INSERT INTO ORDERLINES VALUES(135,6,40101,466.00,2,13.00);
INSERT INTO ORDERLINES VALUES(136,1,60402,11.00,273,12.00);
INSERT INTO ORDERLINES VALUES(136,2,60300,11.00,248,5.00);
INSERT INTO ORDERLINES VALUES(136,3,60100,10.00,62,17.00);
INSERT INTO ORDERLINES VALUES(136,4,50102,62.00,32,8.00);
INSERT INTO ORDERLINES VALUES(136,5,40400,68.00,21,16.00);
INSERT INTO ORDERLINES VALUES(136,6,40401,117.00,12,23.00);
INSERT INTO ORDERLINES VALUES(137,1,60101,13.00,29,1.00);
INSERT INTO ORDERLINES VALUES(137,2,60202,33.00,24,12.00);
INSERT INTO ORDERLINES VALUES(137,3,60300,11.00,165,16.00);
INSERT INTO ORDERLINES VALUES(137,4,50203,8.00,16,20.00);
INSERT INTO ORDERLINES VALUES(137,5,40303,25.00,7,14.00);
INSERT INTO ORDERLINES VALUES(137,6,40200,114.00,4,12.00);
INSERT INTO ORDERLINES VALUES(138,1,60101,13.00,68,8.00);
INSERT INTO ORDERLINES VALUES(138,2,60300,11.00,306,5.00);
INSERT INTO ORDERLINES VALUES(138,3,60401,11.00,375,15.00);
INSERT INTO ORDERLINES VALUES(138,4,50203,8.00,32,10.00);
INSERT INTO ORDERLINES VALUES(138,5,40300,14.00,7,7.00);
INSERT INTO ORDERLINES VALUES(138,6,40200,114.00,10,7.00);
INSERT INTO ORDERLINES VALUES(139,1,60300,11.00,422,20.00);
INSERT INTO ORDERLINES VALUES(139,2,60202,33.00,6,18.00);
INSERT INTO ORDERLINES VALUES(139,3,60302,8.00,279,23.00);
INSERT INTO ORDERLINES VALUES(139,4,50101,35.00,48,7.00);
INSERT INTO ORDERLINES VALUES(139,5,40400,68.00,67,10.00);
INSERT INTO ORDERLINES VALUES(139,6,40302,19.00,2,9.00);
INSERT INTO ORDERLINES VALUES(140,1,60301,13.00,192,2.00);
INSERT INTO ORDERLINES VALUES(140,2,60101,13.00,77,5.00);
INSERT INTO ORDERLINES VALUES(140,3,60402,11.00,148,22.00);
INSERT INTO ORDERLINES VALUES(140,4,50203,8.00,64,4.00);
INSERT INTO ORDERLINES VALUES(140,5,40102,500.00,13,22.00);
INSERT INTO ORDERLINES VALUES(140,6,40100,193.00,10,7.00);
INSERT INTO ORDERLINES VALUES(141,1,60402,11.00,122,4.00);
INSERT INTO ORDERLINES VALUES(141,2,60200,7.00,1,24.00);
INSERT INTO ORDERLINES VALUES(141,3,60201,13.00,30,24.00);
INSERT INTO ORDERLINES VALUES(141,4,50100,31.00,16,11.00);
INSERT INTO ORDERLINES VALUES(141,5,40202,80.00,9,25.00);
INSERT INTO ORDERLINES VALUES(141,6,40400,68.00,52,14.00);
INSERT INTO ORDERLINES VALUES(143,1,60500,190.00,1,1.00);
INSERT INTO ORDERLINES VALUES(143,2,60300,11.00,279,4.00);
INSERT INTO ORDERLINES VALUES(143,3,60501,311.00,57,11.00);
INSERT INTO ORDERLINES VALUES(143,4,50201,11.00,32,21.00);
INSERT INTO ORDERLINES VALUES(143,5,40202,80.00,2,11.00);
INSERT INTO ORDERLINES VALUES(143,6,40401,117.00,10,1.00);
INSERT INTO ORDERLINES VALUES(144,1,60102,43.00,62,8.00);
INSERT INTO ORDERLINES VALUES(144,2,60200,7.00,6,7.00);
INSERT INTO ORDERLINES VALUES(144,3,60402,11.00,171,11.00);
INSERT INTO ORDERLINES VALUES(144,4,50102,62.00,16,16.00);
INSERT INTO ORDERLINES VALUES(144,5,40402,57.00,6,14.00);
INSERT INTO ORDERLINES VALUES(144,6,40103,554.00,1,24.00);
INSERT INTO ORDERLINES VALUES(145,1,60302,8.00,192,7.00);
INSERT INTO ORDERLINES VALUES(145,2,60300,11.00,192,5.00);
INSERT INTO ORDERLINES VALUES(145,3,60501,311.00,14,16.00);
INSERT INTO ORDERLINES VALUES(145,4,50202,9.00,80,16.00);
INSERT INTO ORDERLINES VALUES(145,5,40400,68.00,67,9.00);
INSERT INTO ORDERLINES VALUES(145,6,40202,80.00,8,15.00);
INSERT INTO ORDERLINES VALUES(146,1,60400,6.00,68,18.00);
INSERT INTO ORDERLINES VALUES(146,2,60202,33.00,6,6.00);
INSERT INTO ORDERLINES VALUES(146,3,60501,311.00,80,7.00);
INSERT INTO ORDERLINES VALUES(146,4,50101,35.00,16,19.00);
INSERT INTO ORDERLINES VALUES(146,5,40301,138.00,6,18.00);
INSERT INTO ORDERLINES VALUES(146,6,40103,554.00,1,22.00);
INSERT INTO ORDERLINES VALUES(147,1,60202,33.00,16,6.00);
INSERT INTO ORDERLINES VALUES(147,2,60300,11.00,363,12.00);
INSERT INTO ORDERLINES VALUES(147,3,60102,43.00,62,9.00);
INSERT INTO ORDERLINES VALUES(147,4,50101,35.00,48,1.00);
INSERT INTO ORDERLINES VALUES(147,5,40103,554.00,9,20.00);
INSERT INTO ORDERLINES VALUES(147,6,40403,22.00,37,23.00);
INSERT INTO ORDERLINES VALUES(148,1,60302,8.00,138,10.00);
INSERT INTO ORDERLINES VALUES(148,2,60402,11.00,348,12.00);
INSERT INTO ORDERLINES VALUES(148,3,60200,7.00,16,10.00);
INSERT INTO ORDERLINES VALUES(148,4,50201,11.00,32,16.00);
INSERT INTO ORDERLINES VALUES(148,5,40100,193.00,104,7.00);
INSERT INTO ORDERLINES VALUES(148,6,40201,123.00,7,24.00);
INSERT INTO ORDERLINES VALUES(149,1,60100,10.00,101,1.00);
INSERT INTO ORDERLINES VALUES(149,2,60400,6.00,244,14.00);
INSERT INTO ORDERLINES VALUES(149,3,60202,33.00,6,10.00);
INSERT INTO ORDERLINES VALUES(149,4,50203,8.00,80,18.00);
INSERT INTO ORDERLINES VALUES(149,5,40201,123.00,8,9.00);
INSERT INTO ORDERLINES VALUES(149,6,40101,466.00,1,17.00);
INSERT INTO ORDERLINES VALUES(151,1,60500,190.00,28,11.00);
INSERT INTO ORDERLINES VALUES(151,2,60202,33.00,24,20.00);
INSERT INTO ORDERLINES VALUES(151,4,50203,8.00,64,5.00);
INSERT INTO ORDERLINES VALUES(151,5,40202,80.00,12,14.00);
INSERT INTO ORDERLINES VALUES(151,6,40101,466.00,10,17.00);
INSERT INTO ORDERLINES VALUES(152,1,60102,43.00,53,4.00);
INSERT INTO ORDERLINES VALUES(152,2,60402,11.00,348,21.00);
INSERT INTO ORDERLINES VALUES(152,3,60200,7.00,20,1.00);
INSERT INTO ORDERLINES VALUES(152,4,50202,9.00,32,3.00);
INSERT INTO ORDERLINES VALUES(152,5,40101,466.00,2,35.00);
INSERT INTO ORDERLINES VALUES(152,6,40100,193.00,92,5.00);
INSERT INTO ORDERLINES VALUES(153,1,60201,13.00,24,6.00);
INSERT INTO ORDERLINES VALUES(153,2,60301,13.00,422,20.00);
INSERT INTO ORDERLINES VALUES(153,3,60500,190.00,28,22.00);
INSERT INTO ORDERLINES VALUES(153,4,50203,8.00,64,1.00);
INSERT INTO ORDERLINES VALUES(153,5,40302,19.00,16,18.00);
INSERT INTO ORDERLINES VALUES(153,6,40103,554.00,9,16.00);
INSERT INTO ORDERLINES VALUES(154,1,60201,13.00,12,8.00);
INSERT INTO ORDERLINES VALUES(154,2,60400,6.00,207,18.00);
INSERT INTO ORDERLINES VALUES(154,3,60102,43.00,12,9.00);
INSERT INTO ORDERLINES VALUES(154,4,50102,62.00,64,4.00);
INSERT INTO ORDERLINES VALUES(154,5,40402,57.00,31,18.00);
INSERT INTO ORDERLINES VALUES(154,6,40101,466.00,2,14.00);
INSERT INTO ORDERLINES VALUES(155,1,60200,7.00,16,8.00);
INSERT INTO ORDERLINES VALUES(155,2,60501,311.00,14,6.00);
INSERT INTO ORDERLINES VALUES(155,3,60202,33.00,1,11.00);
INSERT INTO ORDERLINES VALUES(155,4,50100,31.00,80,9.00);
INSERT INTO ORDERLINES VALUES(155,5,40301,138.00,6,7.00);
INSERT INTO ORDERLINES VALUES(155,6,40300,14.00,6,19.00);
INSERT INTO ORDERLINES VALUES(156,1,60201,13.00,1,12.00);
INSERT INTO ORDERLINES VALUES(156,2,60500,190.00,28,1.00);
INSERT INTO ORDERLINES VALUES(156,3,60402,11.00,72,20.00);
INSERT INTO ORDERLINES VALUES(156,4,50203,8.00,32,24.00);
INSERT INTO ORDERLINES VALUES(156,5,40101,466.00,28,40.00);
INSERT INTO ORDERLINES VALUES(157,1,60302,8.00,422,4.00);
INSERT INTO ORDERLINES VALUES(157,3,60501,311.00,1,7.00);
INSERT INTO ORDERLINES VALUES(157,4,50102,62.00,64,9.00);
INSERT INTO ORDERLINES VALUES(157,5,40403,22.00,25,23.00);
INSERT INTO ORDERLINES VALUES(157,6,40302,19.00,19,4.00);
INSERT INTO ORDERLINES VALUES(158,1,60400,6.00,226,7.00);
INSERT INTO ORDERLINES VALUES(158,2,60200,7.00,24,1.00);
INSERT INTO ORDERLINES VALUES(158,3,60102,43.00,53,24.00);
INSERT INTO ORDERLINES VALUES(158,4,50203,8.00,80,3.00);
INSERT INTO ORDERLINES VALUES(158,5,40102,500.00,1,1.00);
INSERT INTO ORDERLINES VALUES(158,6,40103,554.00,1,13.00);
INSERT INTO ORDERLINES VALUES(159,1,60100,10.00,77,6.00);
INSERT INTO ORDERLINES VALUES(159,2,60200,7.00,28,11.00);
INSERT INTO ORDERLINES VALUES(159,3,60102,43.00,101,5.00);
INSERT INTO ORDERLINES VALUES(159,4,50203,8.00,32,19.00);
INSERT INTO ORDERLINES VALUES(159,5,40101,466.00,1,14.00);
INSERT INTO ORDERLINES VALUES(159,6,40400,68.00,44,25.00);
INSERT INTO ORDERLINES VALUES(160,1,60300,11.00,138,25.00);
INSERT INTO ORDERLINES VALUES(160,2,60402,11.00,122,23.00);
INSERT INTO ORDERLINES VALUES(160,3,60400,6.00,207,3.00);
INSERT INTO ORDERLINES VALUES(160,4,50102,62.00,80,15.00);
INSERT INTO ORDERLINES VALUES(160,5,40400,68.00,30,21.00);
INSERT INTO ORDERLINES VALUES(160,6,40403,22.00,12,21.00);
INSERT INTO ORDERLINES VALUES(161,1,60500,190.00,1,10.00);
INSERT INTO ORDERLINES VALUES(161,2,60501,311.00,57,14.00);
INSERT INTO ORDERLINES VALUES(161,3,60300,11.00,50,4.00);
INSERT INTO ORDERLINES VALUES(161,4,50101,35.00,48,12.00);
INSERT INTO ORDERLINES VALUES(161,5,40300,14.00,12,12.00);
INSERT INTO ORDERLINES VALUES(161,6,40402,57.00,43,24.00);
INSERT INTO ORDERLINES VALUES(162,1,60102,43.00,5,21.00);
INSERT INTO ORDERLINES VALUES(162,2,60100,10.00,116,14.00);
INSERT INTO ORDERLINES VALUES(162,3,60302,8.00,422,20.00);
INSERT INTO ORDERLINES VALUES(162,4,50100,31.00,48,15.00);
INSERT INTO ORDERLINES VALUES(162,5,40102,500.00,3,12.00);
INSERT INTO ORDERLINES VALUES(162,6,40200,114.00,7,24.00);
INSERT INTO ORDERLINES VALUES(163,1,60500,190.00,12,13.00);
INSERT INTO ORDERLINES VALUES(163,2,60302,8.00,50,14.00);
INSERT INTO ORDERLINES VALUES(163,3,60200,7.00,2,22.00);
INSERT INTO ORDERLINES VALUES(163,4,50101,35.00,32,21.00);
INSERT INTO ORDERLINES VALUES(163,5,40403,22.00,25,12.00);
INSERT INTO ORDERLINES VALUES(163,6,40300,14.00,10,18.00);
INSERT INTO ORDERLINES VALUES(164,1,60101,13.00,53,5.00);
INSERT INTO ORDERLINES VALUES(164,2,60200,7.00,19,17.00);
INSERT INTO ORDERLINES VALUES(164,3,60302,8.00,332,5.00);
INSERT INTO ORDERLINES VALUES(164,4,50101,35.00,64,14.00);
INSERT INTO ORDERLINES VALUES(164,5,40102,500.00,16,21.00);
INSERT INTO ORDERLINES VALUES(164,6,40302,19.00,12,4.00);
INSERT INTO ORDERLINES VALUES(165,1,60500,190.00,28,23.00);
INSERT INTO ORDERLINES VALUES(165,2,60102,43.00,45,2.00);
INSERT INTO ORDERLINES VALUES(165,4,50101,35.00,16,3.00);
INSERT INTO ORDERLINES VALUES(165,5,40101,466.00,1,15.00);
INSERT INTO ORDERLINES VALUES(165,6,40400,68.00,21,19.00);
INSERT INTO ORDERLINES VALUES(166,1,60201,13.00,20,5.00);
INSERT INTO ORDERLINES VALUES(166,2,60302,8.00,221,1.00);
INSERT INTO ORDERLINES VALUES(166,3,60101,13.00,20,3.00);
INSERT INTO ORDERLINES VALUES(166,4,50201,11.00,32,25.00);
INSERT INTO ORDERLINES VALUES(166,5,40403,22.00,18,23.00);
INSERT INTO ORDERLINES VALUES(166,6,40301,138.00,1,25.00);
INSERT INTO ORDERLINES VALUES(167,1,60401,11.00,375,24.00);
INSERT INTO ORDERLINES VALUES(167,2,60202,33.00,7,11.00);
INSERT INTO ORDERLINES VALUES(167,3,60102,43.00,116,6.00);
INSERT INTO ORDERLINES VALUES(167,4,50203,8.00,64,9.00);
INSERT INTO ORDERLINES VALUES(167,5,40200,114.00,2,25.00);
INSERT INTO ORDERLINES VALUES(167,6,40300,14.00,3,6.00);
INSERT INTO ORDERLINES VALUES(168,1,60501,311.00,30,17.00);
INSERT INTO ORDERLINES VALUES(168,2,60400,6.00,244,6.00);
INSERT INTO ORDERLINES VALUES(168,3,60202,33.00,28,8.00);
INSERT INTO ORDERLINES VALUES(168,4,50201,11.00,16,24.00);
INSERT INTO ORDERLINES VALUES(168,5,40200,114.00,4,10.00);
INSERT INTO ORDERLINES VALUES(168,6,40303,25.00,4,19.00);
INSERT INTO ORDERLINES VALUES(169,1,60501,311.00,30,20.00);
INSERT INTO ORDERLINES VALUES(169,2,60301,13.00,106,1.00);
INSERT INTO ORDERLINES VALUES(169,3,60202,33.00,28,5.00);
INSERT INTO ORDERLINES VALUES(169,4,50203,8.00,48,16.00);
INSERT INTO ORDERLINES VALUES(169,5,40403,22.00,43,3.00);
INSERT INTO ORDERLINES VALUES(169,6,40102,500.00,7,7.00);
INSERT INTO ORDERLINES VALUES(170,1,60202,33.00,28,17.00);
INSERT INTO ORDERLINES VALUES(170,2,60401,11.00,171,8.00);
INSERT INTO ORDERLINES VALUES(170,4,50101,35.00,80,18.00);
INSERT INTO ORDERLINES VALUES(170,5,40201,123.00,1,17.00);
INSERT INTO ORDERLINES VALUES(171,1,60201,13.00,24,20.00);
INSERT INTO ORDERLINES VALUES(171,2,60302,8.00,363,7.00);
INSERT INTO ORDERLINES VALUES(171,3,60202,33.00,11,16.00);
INSERT INTO ORDERLINES VALUES(171,4,50100,31.00,48,24.00);
INSERT INTO ORDERLINES VALUES(171,5,40102,500.00,1,24.00);
INSERT INTO ORDERLINES VALUES(171,6,40301,138.00,1,13.00);
INSERT INTO ORDERLINES VALUES(172,1,60301,13.00,165,9.00);
INSERT INTO ORDERLINES VALUES(172,2,60402,11.00,273,6.00);
INSERT INTO ORDERLINES VALUES(172,3,60500,190.00,20,11.00);
INSERT INTO ORDERLINES VALUES(172,4,50201,11.00,48,21.00);
INSERT INTO ORDERLINES VALUES(172,5,40101,466.00,1,18.00);
INSERT INTO ORDERLINES VALUES(172,6,40201,123.00,2,11.00);
INSERT INTO ORDERLINES VALUES(173,1,60301,13.00,332,2.00);
INSERT INTO ORDERLINES VALUES(173,2,60400,6.00,207,6.00);
INSERT INTO ORDERLINES VALUES(173,3,60202,33.00,16,24.00);
INSERT INTO ORDERLINES VALUES(173,4,50203,8.00,64,12.00);
INSERT INTO ORDERLINES VALUES(173,5,40200,114.00,12,22.00);
INSERT INTO ORDERLINES VALUES(173,6,40301,138.00,6,19.00);
INSERT INTO ORDERLINES VALUES(174,1,60101,13.00,93,9.00);
INSERT INTO ORDERLINES VALUES(174,2,60201,13.00,12,7.00);
INSERT INTO ORDERLINES VALUES(174,3,60300,11.00,306,13.00);
INSERT INTO ORDERLINES VALUES(174,4,50102,62.00,32,22.00);
INSERT INTO ORDERLINES VALUES(174,5,40301,138.00,6,3.00);
INSERT INTO ORDERLINES VALUES(174,6,40400,68.00,14,2.00);
INSERT INTO ORDERLINES VALUES(175,1,60500,190.00,1,7.00);
INSERT INTO ORDERLINES VALUES(175,2,60401,11.00,375,15.00);
INSERT INTO ORDERLINES VALUES(175,3,60302,8.00,192,21.00);
INSERT INTO ORDERLINES VALUES(175,4,50100,31.00,80,7.00);
INSERT INTO ORDERLINES VALUES(175,5,40103,554.00,2,5.00);
INSERT INTO ORDERLINES VALUES(175,6,40303,25.00,7,13.00);
INSERT INTO ORDERLINES VALUES(176,1,60402,11.00,348,7.00);
INSERT INTO ORDERLINES VALUES(176,2,60401,11.00,375,4.00);
INSERT INTO ORDERLINES VALUES(176,3,60202,33.00,30,15.00);
INSERT INTO ORDERLINES VALUES(176,4,50202,9.00,64,7.00);
INSERT INTO ORDERLINES VALUES(176,5,40201,123.00,9,19.00);
INSERT INTO ORDERLINES VALUES(176,6,40403,22.00,50,24.00);
INSERT INTO ORDERLINES VALUES(179,1,60300,11.00,165,3.00);
INSERT INTO ORDERLINES VALUES(179,2,60100,10.00,77,14.00);
INSERT INTO ORDERLINES VALUES(179,3,60201,13.00,3,10.00);
INSERT INTO ORDERLINES VALUES(179,4,50100,31.00,48,2.00);
INSERT INTO ORDERLINES VALUES(179,5,40401,117.00,2,15.00);
INSERT INTO ORDERLINES VALUES(179,6,40403,22.00,56,15.00);
INSERT INTO ORDERLINES VALUES(180,1,60501,311.00,30,13.00);
INSERT INTO ORDERLINES VALUES(180,2,60301,13.00,50,23.00);
INSERT INTO ORDERLINES VALUES(180,3,60500,190.00,5,19.00);
INSERT INTO ORDERLINES VALUES(180,4,50102,62.00,32,11.00);
INSERT INTO ORDERLINES VALUES(180,5,40201,123.00,10,20.00);
INSERT INTO ORDERLINES VALUES(180,6,40400,68.00,75,3.00);
INSERT INTO ORDERLINES VALUES(181,1,60401,11.00,45,17.00);
INSERT INTO ORDERLINES VALUES(181,2,60301,13.00,306,13.00);
INSERT INTO ORDERLINES VALUES(181,3,60202,33.00,16,13.00);
INSERT INTO ORDERLINES VALUES(181,4,50100,31.00,64,21.00);
INSERT INTO ORDERLINES VALUES(181,5,40400,68.00,7,7.00);
INSERT INTO ORDERLINES VALUES(181,6,40201,123.00,7,1.00);
INSERT INTO ORDERLINES VALUES(182,1,60401,11.00,20,12.00);
INSERT INTO ORDERLINES VALUES(182,3,60501,311.00,30,21.00);
INSERT INTO ORDERLINES VALUES(182,4,50102,62.00,48,4.00);
INSERT INTO ORDERLINES VALUES(182,5,40301,138.00,6,21.00);
INSERT INTO ORDERLINES VALUES(182,6,40402,57.00,43,2.00);
INSERT INTO ORDERLINES VALUES(183,1,60301,13.00,221,21.00);
INSERT INTO ORDERLINES VALUES(183,2,60100,10.00,20,23.00);
INSERT INTO ORDERLINES VALUES(183,3,60401,11.00,298,9.00);
INSERT INTO ORDERLINES VALUES(183,4,50203,8.00,64,4.00);
INSERT INTO ORDERLINES VALUES(183,5,40303,25.00,25,16.00);
INSERT INTO ORDERLINES VALUES(183,6,40403,22.00,18,17.00);
INSERT INTO ORDERLINES VALUES(183,7,40102,555.00,2,20.00);
INSERT INTO ORDERLINES VALUES(184,1,60401,11.00,96,22.00);
INSERT INTO ORDERLINES VALUES(184,2,60300,11.00,279,22.00);
INSERT INTO ORDERLINES VALUES(184,4,50102,62.00,16,20.00);
INSERT INTO ORDERLINES VALUES(184,5,40101,466.00,1,40.00);
INSERT INTO ORDERLINES VALUES(184,6,40202,80.00,8,12.00);
INSERT INTO ORDERLINES VALUES(185,1,60200,7.00,7,9.00);
INSERT INTO ORDERLINES VALUES(185,2,60402,11.00,96,16.00);
INSERT INTO ORDERLINES VALUES(185,3,60501,311.00,1,14.00);
INSERT INTO ORDERLINES VALUES(185,4,50101,35.00,80,23.00);
INSERT INTO ORDERLINES VALUES(185,5,40301,138.00,6,4.00);
INSERT INTO ORDERLINES VALUES(185,6,40402,57.00,18,21.00);
INSERT INTO ORDERLINES VALUES(186,1,60200,7.00,28,15.00);
INSERT INTO ORDERLINES VALUES(186,2,60400,6.00,155,17.00);
INSERT INTO ORDERLINES VALUES(186,3,60501,311.00,57,12.00);
INSERT INTO ORDERLINES VALUES(186,4,50203,8.00,64,22.00);
INSERT INTO ORDERLINES VALUES(186,5,40200,114.00,7,23.00);
INSERT INTO ORDERLINES VALUES(186,6,40301,138.00,6,16.00);
INSERT INTO ORDERLINES VALUES(187,1,60401,11.00,148,2.00);
INSERT INTO ORDERLINES VALUES(187,2,60301,13.00,248,23.00);
INSERT INTO ORDERLINES VALUES(187,3,60102,43.00,107,8.00);
INSERT INTO ORDERLINES VALUES(187,4,50101,35.00,64,11.00);
INSERT INTO ORDERLINES VALUES(187,5,40202,80.00,10,9.00);
INSERT INTO ORDERLINES VALUES(187,6,40201,123.00,8,9.00);
INSERT INTO ORDERLINES VALUES(188,1,60301,13.00,192,13.00);
INSERT INTO ORDERLINES VALUES(188,2,60202,33.00,24,6.00);
INSERT INTO ORDERLINES VALUES(188,3,60102,43.00,53,5.00);
INSERT INTO ORDERLINES VALUES(188,4,50202,9.00,64,10.00);
INSERT INTO ORDERLINES VALUES(188,5,40102,500.00,7,40.00);
INSERT INTO ORDERLINES VALUES(188,6,40202,80.00,2,10.00);
INSERT INTO ORDERLINES VALUES(189,1,60200,7.00,24,15.00);
INSERT INTO ORDERLINES VALUES(189,2,60401,11.00,348,12.00);
INSERT INTO ORDERLINES VALUES(189,3,60300,11.00,165,4.00);
INSERT INTO ORDERLINES VALUES(189,4,50102,62.00,48,16.00);
INSERT INTO ORDERLINES VALUES(189,5,40300,14.00,12,1.00);
INSERT INTO ORDERLINES VALUES(189,6,40200,114.00,8,6.00);
INSERT INTO ORDERLINES VALUES(190,1,60201,13.00,7,12.00);
INSERT INTO ORDERLINES VALUES(190,2,60501,311.00,57,4.00);
INSERT INTO ORDERLINES VALUES(190,4,50202,9.00,48,9.00);
INSERT INTO ORDERLINES VALUES(190,5,40103,554.00,16,5.00);
INSERT INTO ORDERLINES VALUES(191,1,60302,8.00,306,16.00);
INSERT INTO ORDERLINES VALUES(191,2,60500,190.00,5,25.00);
INSERT INTO ORDERLINES VALUES(191,3,60300,11.00,363,22.00);
INSERT INTO ORDERLINES VALUES(191,4,50100,31.00,16,7.00);
INSERT INTO ORDERLINES VALUES(191,5,40200,114.00,6,16.00);
INSERT INTO ORDERLINES VALUES(191,6,40100,193.00,25,18.00);
INSERT INTO ORDERLINES VALUES(192,1,60402,11.00,20,7.00);
INSERT INTO ORDERLINES VALUES(192,2,60302,8.00,422,14.00);
INSERT INTO ORDERLINES VALUES(192,3,60202,33.00,30,25.00);
INSERT INTO ORDERLINES VALUES(192,4,50102,62.00,64,6.00);
INSERT INTO ORDERLINES VALUES(192,5,40400,68.00,37,12.00);
INSERT INTO ORDERLINES VALUES(192,6,40102,500.00,19,48.00);
INSERT INTO ORDERLINES VALUES(193,1,60202,33.00,2,3.00);
INSERT INTO ORDERLINES VALUES(193,2,60501,311.00,30,3.00);
INSERT INTO ORDERLINES VALUES(193,3,60300,11.00,279,14.00);
INSERT INTO ORDERLINES VALUES(193,4,50101,35.00,16,17.00);
INSERT INTO ORDERLINES VALUES(193,5,40100,193.00,25,11.00);
INSERT INTO ORDERLINES VALUES(193,6,40200,114.00,10,23.00);
INSERT INTO ORDERLINES VALUES(194,1,60202,33.00,1,6.00);
INSERT INTO ORDERLINES VALUES(194,2,60401,11.00,148,13.00);
INSERT INTO ORDERLINES VALUES(194,3,60301,13.00,279,23.00);
INSERT INTO ORDERLINES VALUES(194,4,50102,62.00,64,12.00);
INSERT INTO ORDERLINES VALUES(194,5,40202,80.00,1,6.00);
INSERT INTO ORDERLINES VALUES(194,6,40302,19.00,14,22.00);
INSERT INTO ORDERLINES VALUES(195,1,60400,6.00,155,14.00);
INSERT INTO ORDERLINES VALUES(195,2,60500,190.00,1,12.00);
INSERT INTO ORDERLINES VALUES(195,3,60201,13.00,20,14.00);
INSERT INTO ORDERLINES VALUES(195,4,50102,62.00,64,13.00);
INSERT INTO ORDERLINES VALUES(195,5,40202,80.00,10,23.00);
INSERT INTO ORDERLINES VALUES(195,6,40200,114.00,8,8.00);
INSERT INTO ORDERLINES VALUES(196,1,60102,43.00,62,3.00);
INSERT INTO ORDERLINES VALUES(196,2,60402,11.00,122,5.00);
INSERT INTO ORDERLINES VALUES(196,3,60401,11.00,250,11.00);
INSERT INTO ORDERLINES VALUES(196,4,50100,31.00,64,4.00);
INSERT INTO ORDERLINES VALUES(196,5,40301,138.00,1,11.00);
INSERT INTO ORDERLINES VALUES(196,6,40200,114.00,1,11.00);
INSERT INTO ORDERLINES VALUES(197,1,60401,11.00,20,2.00);
INSERT INTO ORDERLINES VALUES(197,2,60300,11.00,50,18.00);
INSERT INTO ORDERLINES VALUES(197,4,50102,62.00,48,12.00);
INSERT INTO ORDERLINES VALUES(197,5,40200,114.00,2,19.00);
INSERT INTO ORDERLINES VALUES(197,6,40101,466.00,2,21.00);
INSERT INTO ORDERLINES VALUES(199,1,60201,13.00,24,22.00);
INSERT INTO ORDERLINES VALUES(199,2,60402,11.00,148,25.00);
INSERT INTO ORDERLINES VALUES(199,3,60302,8.00,79,22.00);
INSERT INTO ORDERLINES VALUES(199,4,50202,9.00,48,15.00);
INSERT INTO ORDERLINES VALUES(199,5,40200,114.00,10,4.00);
INSERT INTO ORDERLINES VALUES(199,6,40401,117.00,12,18.00);
INSERT INTO ORDERLINES VALUES(200,1,60101,13.00,101,9.00);
INSERT INTO ORDERLINES VALUES(200,3,60401,11.00,348,9.00);
INSERT INTO ORDERLINES VALUES(200,4,50201,11.00,64,21.00);
INSERT INTO ORDERLINES VALUES(200,5,40301,138.00,1,2.00);
INSERT INTO ORDERLINES VALUES(200,6,40300,14.00,3,21.00);
INSERT INTO ORDERLINES VALUES(201,1,60202,33.00,16,14.00);
INSERT INTO ORDERLINES VALUES(201,2,60300,11.00,79,10.00);
INSERT INTO ORDERLINES VALUES(201,3,60100,10.00,77,24.00);
INSERT INTO ORDERLINES VALUES(201,4,50100,31.00,48,19.00);
INSERT INTO ORDERLINES VALUES(201,5,40101,466.00,1,16.00);
INSERT INTO ORDERLINES VALUES(201,6,40201,123.00,2,19.00);
INSERT INTO ORDERLINES VALUES(202,1,60401,11.00,250,13.00);
INSERT INTO ORDERLINES VALUES(202,2,60200,7.00,1,2.00);
INSERT INTO ORDERLINES VALUES(202,3,60101,13.00,5,13.00);
INSERT INTO ORDERLINES VALUES(202,4,50202,9.00,80,5.00);
INSERT INTO ORDERLINES VALUES(202,5,40201,123.00,9,21.00);
INSERT INTO ORDERLINES VALUES(202,6,40301,138.00,6,20.00);
INSERT INTO ORDERLINES VALUES(203,1,60300,11.00,165,10.00);
INSERT INTO ORDERLINES VALUES(203,2,60402,11.00,122,1.00);
INSERT INTO ORDERLINES VALUES(203,3,60101,13.00,38,25.00);
INSERT INTO ORDERLINES VALUES(203,4,50203,8.00,32,2.00);
INSERT INTO ORDERLINES VALUES(203,5,40202,80.00,2,7.00);
INSERT INTO ORDERLINES VALUES(203,6,40403,22.00,43,5.00);
INSERT INTO ORDERLINES VALUES(204,1,60402,11.00,348,15.00);
INSERT INTO ORDERLINES VALUES(204,2,60301,13.00,165,12.00);
INSERT INTO ORDERLINES VALUES(204,3,60100,10.00,53,8.00);
INSERT INTO ORDERLINES VALUES(204,4,50203,8.00,80,18.00);
INSERT INTO ORDERLINES VALUES(204,5,40102,500.00,2,8.00);
INSERT INTO ORDERLINES VALUES(204,6,40303,25.00,19,3.00);
INSERT INTO ORDERLINES VALUES(205,1,60300,11.00,363,12.00);
INSERT INTO ORDERLINES VALUES(205,2,60302,8.00,165,16.00);
INSERT INTO ORDERLINES VALUES(205,3,60400,6.00,119,2.00);
INSERT INTO ORDERLINES VALUES(205,4,50102,62.00,48,6.00);
INSERT INTO ORDERLINES VALUES(205,5,40200,114.00,3,25.00);
INSERT INTO ORDERLINES VALUES(205,6,40302,19.00,9,8.00);
INSERT INTO ORDERLINES VALUES(206,1,60202,33.00,2,19.00);
INSERT INTO ORDERLINES VALUES(206,2,60102,43.00,38,25.00);
INSERT INTO ORDERLINES VALUES(206,3,60301,13.00,363,14.00);
INSERT INTO ORDERLINES VALUES(206,4,50202,9.00,64,1.00);
INSERT INTO ORDERLINES VALUES(206,5,40402,57.00,18,1.00);
INSERT INTO ORDERLINES VALUES(206,6,40303,25.00,19,25.00);
INSERT INTO ORDERLINES VALUES(207,1,60100,10.00,77,10.00);
INSERT INTO ORDERLINES VALUES(207,2,60400,6.00,173,22.00);
INSERT INTO ORDERLINES VALUES(207,3,60402,11.00,20,18.00);
INSERT INTO ORDERLINES VALUES(207,4,50202,9.00,48,21.00);
INSERT INTO ORDERLINES VALUES(207,5,40100,193.00,10,2.00);
INSERT INTO ORDERLINES VALUES(207,6,40401,117.00,6,1.00);
INSERT INTO ORDERLINES VALUES(208,1,60100,10.00,20,23.00);
INSERT INTO ORDERLINES VALUES(208,2,60301,13.00,221,20.00);
INSERT INTO ORDERLINES VALUES(208,3,60200,7.00,12,14.00);
INSERT INTO ORDERLINES VALUES(208,4,50202,9.00,16,12.00);
INSERT INTO ORDERLINES VALUES(208,5,40103,554.00,12,8.00);
INSERT INTO ORDERLINES VALUES(208,6,40201,123.00,10,10.00);
INSERT INTO ORDERLINES VALUES(209,1,60201,13.00,16,24.00);
INSERT INTO ORDERLINES VALUES(209,2,60302,8.00,389,24.00);
INSERT INTO ORDERLINES VALUES(209,3,60401,11.00,72,15.00);
INSERT INTO ORDERLINES VALUES(209,4,50202,9.00,16,21.00);
INSERT INTO ORDERLINES VALUES(209,5,40200,114.00,2,25.00);
INSERT INTO ORDERLINES VALUES(209,6,40100,193.00,78,5.00);
INSERT INTO ORDERLINES VALUES(210,1,60200,7.00,16,8.00);
INSERT INTO ORDERLINES VALUES(210,2,60300,11.00,389,19.00);
INSERT INTO ORDERLINES VALUES(210,3,60202,33.00,3,16.00);
INSERT INTO ORDERLINES VALUES(210,4,50100,31.00,32,18.00);
INSERT INTO ORDERLINES VALUES(210,5,40102,500.00,3,4.00);
INSERT INTO ORDERLINES VALUES(210,6,40301,138.00,6,4.00);
INSERT INTO ORDERLINES VALUES(211,1,60401,11.00,148,23.00);
INSERT INTO ORDERLINES VALUES(211,2,60202,33.00,7,3.00);
INSERT INTO ORDERLINES VALUES(211,3,60201,13.00,6,20.00);
INSERT INTO ORDERLINES VALUES(211,4,50102,62.00,16,4.00);
INSERT INTO ORDERLINES VALUES(211,5,40202,80.00,3,8.00);
INSERT INTO ORDERLINES VALUES(211,6,40303,25.00,21,2.00);
INSERT INTO ORDERLINES VALUES(212,1,60302,8.00,248,12.00);
INSERT INTO ORDERLINES VALUES(212,2,60401,11.00,222,12.00);
INSERT INTO ORDERLINES VALUES(212,3,60200,7.00,19,12.00);
INSERT INTO ORDERLINES VALUES(212,4,50101,35.00,16,21.00);
INSERT INTO ORDERLINES VALUES(212,5,40101,466.00,1,8.00);
INSERT INTO ORDERLINES VALUES(212,6,40301,138.00,6,12.00);
INSERT INTO ORDERLINES VALUES(213,1,60101,13.00,107,21.00);
INSERT INTO ORDERLINES VALUES(213,2,60500,190.00,12,22.00);
INSERT INTO ORDERLINES VALUES(213,3,60200,7.00,24,18.00);
INSERT INTO ORDERLINES VALUES(213,4,50203,8.00,32,5.00);
INSERT INTO ORDERLINES VALUES(213,5,40202,80.00,2,23.00);
INSERT INTO ORDERLINES VALUES(213,6,40200,114.00,4,6.00);
INSERT INTO ORDERLINES VALUES(214,1,60200,7.00,16,14.00);
INSERT INTO ORDERLINES VALUES(214,3,60501,311.00,1,8.00);
INSERT INTO ORDERLINES VALUES(214,4,50100,31.00,48,6.00);
INSERT INTO ORDERLINES VALUES(214,5,40303,25.00,2,16.00);
INSERT INTO ORDERLINES VALUES(214,6,40100,193.00,78,5.00);
INSERT INTO ORDERLINES VALUES(215,1,60402,11.00,171,9.00);
INSERT INTO ORDERLINES VALUES(215,2,60202,33.00,7,9.00);
INSERT INTO ORDERLINES VALUES(215,3,60500,190.00,12,12.00);
INSERT INTO ORDERLINES VALUES(215,4,50201,11.00,16,17.00);
INSERT INTO ORDERLINES VALUES(215,5,40402,57.00,18,6.00);
INSERT INTO ORDERLINES VALUES(215,6,40403,22.00,12,13.00);
INSERT INTO ORDERLINES VALUES(216,1,60301,13.00,422,7.00);
INSERT INTO ORDERLINES VALUES(216,2,60500,190.00,5,11.00);
INSERT INTO ORDERLINES VALUES(216,3,60101,13.00,29,13.00);
INSERT INTO ORDERLINES VALUES(216,4,50201,11.00,64,20.00);
INSERT INTO ORDERLINES VALUES(216,5,40202,80.00,1,5.00);
INSERT INTO ORDERLINES VALUES(216,6,40101,466.00,10,23.00);
INSERT INTO ORDERLINES VALUES(217,1,60500,190.00,28,25.00);
INSERT INTO ORDERLINES VALUES(217,2,60102,43.00,5,12.00);
INSERT INTO ORDERLINES VALUES(217,3,60300,11.00,192,20.00);
INSERT INTO ORDERLINES VALUES(217,4,50101,35.00,48,15.00);
INSERT INTO ORDERLINES VALUES(217,5,40102,500.00,3,25.00);
INSERT INTO ORDERLINES VALUES(217,6,40202,80.00,8,4.00);
INSERT INTO ORDERLINES VALUES(218,1,60401,11.00,72,1.00);
INSERT INTO ORDERLINES VALUES(218,2,60102,43.00,107,9.00);
INSERT INTO ORDERLINES VALUES(218,3,60200,7.00,24,2.00);
INSERT INTO ORDERLINES VALUES(218,4,50201,11.00,80,5.00);
INSERT INTO ORDERLINES VALUES(218,5,40100,193.00,25,17.00);
INSERT INTO ORDERLINES VALUES(218,6,40301,138.00,1,2.00);
INSERT INTO ORDERLINES VALUES(220,1,40103,615.00,10,5.00);
INSERT INTO ORDERLINES VALUES(220,2,40102,555.00,10,5.00);
INSERT INTO ORDERLINES VALUES(222,1,60100,9.00,4,45.00);
INSERT INTO ORDERLINES VALUES(222,2,60101,12.00,10,45.00);
INSERT INTO ORDERLINES VALUES(222,3,60102,39.00,100,45.00);
INSERT INTO ORDERLINES VALUES(223,1,50102,56.00,100,45.00);
INSERT INTO ORDERLINES VALUES(224,1,50100,28.00,100,45.00);
INSERT INTO ORDERLINES VALUES(225,1,60401,9.00,50,45.00);
INSERT INTO ORDERLINES VALUES(225,2,60402,9.00,500,45.00);
INSERT INTO ORDERLINES VALUES(226,1,60302,6.00,100,45.00);
INSERT INTO ORDERLINES VALUES(226,2,60301,11.00,100,45.00);
INSERT INTO ORDERLINES VALUES(227,1,60402,9.00,400,45.00);
INSERT INTO ORDERLINES VALUES(228,1,60401,9.00,500,45.00);
INSERT INTO ORDERLINES VALUES(231,1,50100,28.00,100,45.00);
INSERT INTO ORDERLINES VALUES(233,1,60100,9.00,500,45.00);
INSERT INTO ORDERLINES VALUES(234,1,60402,9.00,500,45.00);
INSERT INTO ORDERLINES VALUES(235,1,50102,56.00,40,45.00);
INSERT INTO ORDERLINES VALUES(236,1,60102,39.00,100,45.00);
INSERT INTO ORDERLINES VALUES(238,1,50101,32.00,200,45.00);
INSERT INTO ORDERLINES VALUES(239,1,50102,56.00,75,45.00);
INSERT INTO ORDERLINES VALUES(240,1,60401,9.00,200,45.00);
INSERT INTO ORDERLINES VALUES(241,1,50101,32.00,200,45.00);
INSERT INTO ORDERLINES VALUES(243,1,60100,9.00,100,45.00);
INSERT INTO ORDERLINES VALUES(244,1,50102,56.00,100,45.00);
INSERT INTO ORDERLINES VALUES(245,1,50101,32.00,100,45.00);
INSERT INTO ORDERLINES VALUES(246,1,60501,270.00,20,45.00);
INSERT INTO ORDERLINES VALUES(247,1,60500,165.00,20,45.00);
INSERT INTO ORDERLINES VALUES(249,1,60501,270.00,20,45.00);
INSERT INTO ORDERLINES VALUES(250,1,50100,28.00,100,45.00);
INSERT INTO ORDERLINES VALUES(251,1,50102,56.00,100,45.00);
INSERT INTO ORDERLINES VALUES(252,1,60401,9.00,400,45.00);
INSERT INTO ORDERLINES VALUES(254,1,60500,165.00,20,45.00);
INSERT INTO ORDERLINES VALUES(255,1,50100,28.00,400,45.00);
INSERT INTO ORDERLINES VALUES(256,1,60501,270.00,50,45.00);
INSERT INTO ORDERLINES VALUES(258,1,50201,10.00,500,45.00);
INSERT INTO ORDERLINES VALUES(259,1,50100,28.00,500,45.00);
INSERT INTO ORDERLINES VALUES(261,1,60500,165.00,100,45.00);
INSERT INTO ORDERLINES VALUES(262,1,60501,270.00,20,45.00);
INSERT INTO ORDERLINES VALUES(264,1,50100,28.00,100,45.00);
INSERT INTO ORDERLINES VALUES(265,1,50102,56.00,100,45.00);
INSERT INTO ORDERLINES VALUES(267,1,60500,165.00,50,45.00);
INSERT INTO ORDERLINES VALUES(268,1,60501,270.00,10,1.00);
INSERT INTO ORDERLINES VALUES(271,1,60401,11.00,148,23.00);
INSERT INTO ORDERLINES VALUES(271,2,60202,33.00,8,3.00);
INSERT INTO ORDERLINES VALUES(271,3,60201,13.00,6,20.00);
INSERT INTO ORDERLINES VALUES(271,4,50102,62.00,16,4.00);
INSERT INTO ORDERLINES VALUES(271,5,40202,80.00,3,8.00);
INSERT INTO ORDERLINES VALUES(271,6,40303,25.00,21,2.00);
INSERT INTO ORDERLINES VALUES(272,1,60302,8.00,248,12.00);
INSERT INTO ORDERLINES VALUES(272,2,60401,11.00,222,12.00);
INSERT INTO ORDERLINES VALUES(272,3,60200,7.00,19,12.00);
INSERT INTO ORDERLINES VALUES(272,4,50101,35.00,16,21.00);
INSERT INTO ORDERLINES VALUES(272,5,40101,466.00,2,8.00);
INSERT INTO ORDERLINES VALUES(272,6,40301,138.00,6,12.00);
INSERT INTO ORDERLINES VALUES(273,1,60101,13.00,107,21.00);
INSERT INTO ORDERLINES VALUES(273,2,60500,190.00,12,22.00);
INSERT INTO ORDERLINES VALUES(273,3,60200,7.00,24,18.00);
INSERT INTO ORDERLINES VALUES(273,4,50203,8.00,32,5.00);
INSERT INTO ORDERLINES VALUES(273,5,40202,80.00,2,23.00);
INSERT INTO ORDERLINES VALUES(273,6,40200,114.00,4,6.00);
INSERT INTO ORDERLINES VALUES(274,1,60200,7.00,16,14.00);
INSERT INTO ORDERLINES VALUES(274,3,60501,311.00,2,8.00);
INSERT INTO ORDERLINES VALUES(274,4,50100,31.00,48,6.00);
INSERT INTO ORDERLINES VALUES(274,5,40303,25.00,2,16.00);
INSERT INTO ORDERLINES VALUES(274,6,40100,193.00,78,5.00);
INSERT INTO ORDERLINES VALUES(275,1,60402,11.00,171,9.00);
INSERT INTO ORDERLINES VALUES(275,2,60202,33.00,7,9.00);
INSERT INTO ORDERLINES VALUES(275,3,60500,190.00,12,12.00);
INSERT INTO ORDERLINES VALUES(275,4,50201,11.00,16,17.00);
INSERT INTO ORDERLINES VALUES(275,5,40402,57.00,18,6.00);
INSERT INTO ORDERLINES VALUES(275,6,40403,22.00,12,13.00);
INSERT INTO ORDERLINES VALUES(276,1,60301,13.00,422,7.00);
INSERT INTO ORDERLINES VALUES(276,2,60500,190.00,5,11.00);
INSERT INTO ORDERLINES VALUES(276,3,60101,13.00,30,13.00);
INSERT INTO ORDERLINES VALUES(276,4,50201,11.00,64,20.00);
INSERT INTO ORDERLINES VALUES(276,5,40202,80.00,2,5.00);
INSERT INTO ORDERLINES VALUES(276,6,40101,466.00,10,23.00);
INSERT INTO ORDERLINES VALUES(277,1,60500,190.00,28,25.00);
INSERT INTO ORDERLINES VALUES(277,2,60102,43.00,5,12.00);
INSERT INTO ORDERLINES VALUES(277,3,60300,11.00,195,20.00);
INSERT INTO ORDERLINES VALUES(277,4,50101,35.00,48,15.00);
INSERT INTO ORDERLINES VALUES(277,5,40102,500.00,3,25.00);
INSERT INTO ORDERLINES VALUES(277,6,40202,80.00,8,4.00);
INSERT INTO ORDERLINES VALUES(278,1,60401,11.00,72,1.00);
INSERT INTO ORDERLINES VALUES(278,2,60102,43.00,107,9.00);
INSERT INTO ORDERLINES VALUES(278,3,60200,7.00,24,2.00);
INSERT INTO ORDERLINES VALUES(278,4,50201,11.00,80,5.00);
INSERT INTO ORDERLINES VALUES(278,5,40100,193.00,25,17.00);
INSERT INTO ORDERLINES VALUES(278,6,40301,138.00,1,2.00);
INSERT INTO ORDERLINES VALUES(280,1,40103,615.00,10,5.00);
INSERT INTO ORDERLINES VALUES(280,2,40102,555.00,10,5.00);
INSERT INTO ORDERLINES VALUES(283,1,50102,56.00,100,45.00);
INSERT INTO ORDERLINES VALUES(284,1,50100,28.00,100,45.00);
INSERT INTO ORDERLINES VALUES(285,1,60401,9.00,50,45.00);
INSERT INTO ORDERLINES VALUES(285,2,60402,9.00,500,45.00);
INSERT INTO ORDERLINES VALUES(286,1,60302,6.00,100,45.00);
INSERT INTO ORDERLINES VALUES(286,2,60301,11.00,100,45.00);
INSERT INTO ORDERLINES VALUES(287,1,60402,9.00,400,45.00);
INSERT INTO ORDERLINES VALUES(288,1,60401,9.00,500,45.00);
INSERT INTO ORDERLINES VALUES(291,1,50100,28.00,100,45.00);
INSERT INTO ORDERLINES VALUES(293,1,60100,9.00,500,45.00);
INSERT INTO ORDERLINES VALUES(294,1,60402,9.00,500,45.00);
INSERT INTO ORDERLINES VALUES(294,2,60501,270.00,5,45.00);
INSERT INTO ORDERLINES VALUES(294,3,60500,165.00,20,30.00);
INSERT INTO ORDERLINES VALUES(295,1,50102,56.00,40,45.00);
INSERT INTO ORDERLINES VALUES(296,1,60102,39.00,100,45.00);
INSERT INTO ORDERLINES VALUES(298,1,50101,32.00,200,45.00);
INSERT INTO ORDERLINES VALUES(299,1,50102,56.00,75,45.00);
INSERT INTO ORDERLINES VALUES(299,2,60500,165.00,10,45.00);
INSERT INTO ORDERLINES VALUES(299,3,60100,9.00,5,45.00);
INSERT INTO ORDERLINES VALUES(300,1,60401,9.00,200,45.00);
INSERT INTO ORDERLINES VALUES(301,1,50101,32.00,200,45.00);
INSERT INTO ORDERLINES VALUES(303,1,60100,9.00,100,45.00);
INSERT INTO ORDERLINES VALUES(304,1,50102,56.00,100,45.00);
INSERT INTO ORDERLINES VALUES(305,1,50101,32.00,100,45.00);
INSERT INTO ORDERLINES VALUES(306,1,60501,270.00,20,45.00);
INSERT INTO ORDERLINES VALUES(307,1,60500,165.00,20,45.00);
INSERT INTO ORDERLINES VALUES(309,1,60501,270.00,20,45.00);
INSERT INTO ORDERLINES VALUES(310,1,50100,28.00,100,45.00);
INSERT INTO ORDERLINES VALUES(311,1,50102,56.00,100,45.00);
INSERT INTO ORDERLINES VALUES(312,1,60401,9.00,400,45.00);
INSERT INTO ORDERLINES VALUES(312,2,60100,9.00,9,30.00);
INSERT INTO ORDERLINES VALUES(314,1,60500,165.00,20,45.00);
INSERT INTO ORDERLINES VALUES(315,1,50100,28.00,400,45.00);
INSERT INTO ORDERLINES VALUES(316,1,60300,11.00,165,10.00);
INSERT INTO ORDERLINES VALUES(316,1,60501,270.00,50,45.00);
INSERT INTO ORDERLINES VALUES(316,2,60402,11.00,122,1.00);
INSERT INTO ORDERLINES VALUES(316,3,60101,13.00,38,25.00);
INSERT INTO ORDERLINES VALUES(316,4,50203,8.00,32,2.00);
INSERT INTO ORDERLINES VALUES(316,5,40202,80.00,2,7.00);
INSERT INTO ORDERLINES VALUES(316,6,40403,22.00,43,5.00);
INSERT INTO ORDERLINES VALUES(318,1,50201,10.00,500,45.00);
INSERT INTO ORDERLINES VALUES(319,1,50100,28.00,500,45.00);
INSERT INTO ORDERLINES VALUES(321,1,60500,165.00,100,45.00);
INSERT INTO ORDERLINES VALUES(322,1,60501,270.00,20,45.00);
INSERT INTO ORDERLINES VALUES(324,1,50100,28.00,100,45.00);
INSERT INTO ORDERLINES VALUES(325,1,50102,56.00,100,45.00);
INSERT INTO ORDERLINES VALUES(327,1,60500,165.00,50,45.00);
INSERT INTO ORDERLINES VALUES(328,1,60501,270.00,10,5.00);

INSERT INTO PRODUCTS VALUES(40100,'Outdoor Products','Tents','Star Lite',130.00,165.00,'A','P40100',35310.00,85714.00,54540.00,115830.00,1
);
INSERT INTO PRODUCTS VALUES(40101,'Outdoor Products','Tents','Star Gazer-2',343.00,518.00,'A','P40101',18630.00,31671.00,51233.00,47972.00,1
);
INSERT INTO PRODUCTS VALUES(40102,'Outdoor Products','Tents','Star Gazer-3',370.00,555.00,'A','P40102',37740.00,47952.00,86025.00,70905.00,1
);
INSERT INTO PRODUCTS VALUES(40103,'Outdoor Products','Tents','StarDome',410.00,615.00,'A','P40103',26445.00,31550.00,75645.00,45387.00,1
);
INSERT INTO PRODUCTS VALUES(40200,'Outdoor Products','Sleeping Bags','MoonBeam',80.00,120.00,'A','P40200',14640.00,8778.00,21270.00,12768.00,2
);
INSERT INTO PRODUCTS VALUES(40201,'Outdoor Products','Sleeping Bags','MoonGlow',86.00,129.00,'A','P40201',16383.00,7476.00,24639.00,11030.00,2
);
INSERT INTO PRODUCTS VALUES(40202,'Outdoor Products','Sleeping Bags','MoonLite',56.00,84.00,'A','P40202',8820.00,6623.00,13104.00,8778.00,2
);
INSERT INTO PRODUCTS VALUES(40300,'Outdoor Products','Back Packs','Day Tripper',9.00,14.00,'A','P40300',810.00,978.00,1242.00,1375.00,NULL);
INSERT INTO PRODUCTS VALUES(40301,'Outdoor Products','Back Packs','Pack n'' Hike',88.00,131.00,'A','P40301',2882.00,5502.00,5109.00,8941.00,NULL);
INSERT INTO PRODUCTS VALUES(40302,'Outdoor Products','Back Packs','GO Small Waist Pack',12.00,18.00,'A','P40302',1890.00,1418.00,2880.00,1966.00,NULL);
INSERT INTO PRODUCTS VALUES(40303,'Outdoor Products','Back Packs','GO Large Waist Pack',16.00,24.00,'A','P40303',2448.00,2822.00,3696.00,3931.00,NULL);
INSERT INTO PRODUCTS VALUES(40400,'Outdoor Products','Cooking Equipment','Dover-1',43.00,65.00,'A','P40400',27671.00,32914.00,39990.00,44495.00,
NULL);
INSERT INTO PRODUCTS VALUES(40401,'Outdoor Products','Cooking Equipment','Dover-2',74.00,111.00,'A','P40401',23976.00,7226.00,34845.00,10256.00,NULL
);
INSERT INTO PRODUCTS VALUES(40402,'Outdoor Products','Cooking Equipment','GO Cookset',36.00,54.00,'A','P40402',17928.00,12077.00,26136.00,16386.00,NULL
);
INSERT INTO PRODUCTS VALUES(40403,'Outdoor Products','Cooking Equipment','GO Camp Kettle',14.00,21.00,'A','P40403',8631.00,6593.00,12495.00,8952.00,
NULL);
INSERT INTO PRODUCTS VALUES(50100,'GO Sport Line','Carry-Bags','GO Sport  Bag',14.00,28.00,'A','P50100',8120.00,17802.00,29904.00,37990.00,
NULL);
INSERT INTO PRODUCTS VALUES(50101,'GO Sport Line','Carry-Bags','GO Ski Gear Bag',16.00,32.00,'A','P50101',22720.00,22669.00,44672.00,33434.00,NULL
);
INSERT INTO PRODUCTS VALUES(50102,'GO Sport Line','Carry-Bags','GO Duffel Bag',28.00,56.00,'A','P50102',24976.00,41935.00,44800.00,64680.00,NULL
);
INSERT INTO PRODUCTS VALUES(50201,'GO Sport Line','Sport Wear','GO Headband',5.00,10.00,'A','P50201',4190.00,6072.00,10280.00,7216.00,
NULL);
INSERT INTO PRODUCTS VALUES(50202,'GO Sport Line','Sport Wear','GO Wristband',4.00,8.00,'A','P50202',3848.00,7700.00,4864.00,9152.00,NULL
);
INSERT INTO PRODUCTS VALUES(50203,'GO Sport Line','Sport Wear','GO Water Bottle',4.00,8.00,'A','P50203',4872.00,8416.00,6144.00,9984.00,NULL
);
INSERT INTO PRODUCTS VALUES(60100,'Environmental Line','Alert Devices','Pocket U.V. Alerter',3.00,9.00,'A','P60100',2700.00,5811.00,14607.00,11732.00,NULL
);
INSERT INTO PRODUCTS VALUES(60101,'Environmental Line','Alert Devices','Microwave Detective',4.00,12.00,'A','P60101',1296.00,6389.00,4548.00,12949.00,NULL
);
INSERT INTO PRODUCTS VALUES(60102,'Environmental Line','Alert Devices','Pocket Radon Alerter',13.00,39.00,'A','P60102',7098.00,20549.00,28275.00,45556.00,NULL
);
INSERT INTO PRODUCTS VALUES(60200,'Environmental Line','Recycled Products','EnviroSak',2.00,6.00,'A','P60200',816.00,1162.00,2796.00,2367.00,NULL
);
INSERT INTO PRODUCTS VALUES(60201,'Environmental Line','Recycled Products','Enviro-Kit',4.00,12.00,'A','P60201',1764.00,1993.00,6048.00,4092.00,NULL
);
INSERT INTO PRODUCTS VALUES(60202,'Environmental Line','Recycled Products','Enviro-T',10.00,30.00,'A','P60202',7650.00,7689.00,25890.00,15642.00,NULL
);
INSERT INTO PRODUCTS VALUES(60300,'Environmental Line','Bio-Friendly Soaps','RiverKind Shampoo',3.00,9.00,'A','P60300',1512.00,31118.00,5076.00,62381.00,NULL
);
INSERT INTO PRODUCTS VALUES(60301,'Environmental Line','Bio-Friendly Soaps','RiverKind Soap',4.00,11.00,'A','P60301',12915.00,39913.00,43187.00,80981.00,NULL
);
INSERT INTO PRODUCTS VALUES(60302,'Environmental Line','Bio-Friendly Soaps','RiverKind Detergent',2.00,6.00,'A','P60302',7392.00,19935.00,24750.00,40545.00,2
);
INSERT INTO PRODUCTS VALUES(60400,'Environmental Line','Sunblock','Sun Shelter-8',2.00,6.00,'A','P60400',7218.00,7950.00,24150.00,15972.00,1
);
INSERT INTO PRODUCTS VALUES(60401,'Environmental Line','Sunblock','Sun Shelter-15',3.00,9.00,'A','P60401',14040.00,28204.00,47403.00,66386.00,2
);
INSERT INTO PRODUCTS VALUES(60402,'Environmental Line','Sunblock','Sun Shelter-30',3.00,9.00,'A','P60402',5400.00,23963.00,22590.00,56126.00,1
);
INSERT INTO PRODUCTS VALUES(60500,'Environmental Line','Water Purifiers','Pro-Lite Water Filter',55.00,165.00,'A','P60500',11220.00,26186.00,47850.00,82129.00,2
);
INSERT INTO PRODUCTS VALUES(60501,'Environmental Line','Water Purifiers','Pocket Water Filter',90.00,270.00,'A','P60501',14850.00,32292.00,103410.00,184559.00,2
);
/*
****************************
-- changes to tables to meet 2022 requirements
*/
update products set sales_2016 = round (((sales_2016 + sales_2015 + sales_2014 + sales_2013)/4)/ prod_sell/6 , 0);
alter table products rename column sales_2016 to QOH;
alter table products drop ( sales_2015, sales_2014, sales_2013);

-- Rem end of products

INSERT INTO SUPPLIERS VALUES(1,'RT Tent makers','90 Pond Rd','Toronto','M9W1A9','Ron Tarr','416 491 5050','net 30');
-- Grant Permissions � not all are available in dbs311 this semester
grant all on countries to tarr;
grant all on  WHSE to tarr;                                                                                                                             
grant all on  WAREHOUSE to tarr;                                                                                                                        
grant all on  SUPPLIERS to tarr;                                                                                                                        
grant all on  SECTION to tarr;                                                                                                                          
grant all on  SEC to tarr;                                                                                                                              
grant all on  PRODUCTS to tarr;                                                                                                                         
grant all on  ORDERS to tarr;                                                                                                                           
grant all on  ORDERLINES to tarr;                                                                                                                       
grant all on  LOCATIONS to tarr;                                                                                                                        
grant all on  JOB_HISTORY to tarr;                                                                                                                      
grant all on  JOB_GRADES to tarr;                                                                                                                       
grant all on  EMPLOYEES to tarr;                                                                                                                        
grant all on  EMP to tarr;                                                                                                                              
grant all on  DIVISION to tarr;                                                                                                                         
grant all on  DIV to tarr;                                                                                                                              
grant all on  DEPARTMENTS to tarr;                                                                                                                      
grant all on  CUSTOMERS to tarr;                                                                                                                        
-- end of grants
INSERT INTO SUPPLIERS VALUES(2,'NG Outdoor Supplier','125 Hilltop Grove','Mississauga','M2D3T3',NULL,'905 876 1234','2/10 net30');
INSERT INTO SUPPLIERS VALUES(3,'Outdoor Green MFG.','17A Crest Ave','Mississauga','M5H 1D7',NULL,'905 233 3333','2/10 net30');
INSERT INTO SUPPLIERS VALUES(4,'Outdoor Green Ltd.','17B Crest Ave','Mississauga','M5H 1D7',NULL,'905 244 4444','2/10 net30');
Commit;

Rem This is to have students check they have the correct number of entries
Rem in each table

PAUSE The number of rows will be counted ... Press enter each time after you checked to see if the same values show in your output

Rem Counting the rows in each table to ensure they are correct.
select count(*) from employees; -- 55
pause DID YOU SEE employees 55
select count(*) from countries; -- 25
pause countries 25
select count(*) from customers; -- 150
pause customers 150
select count(*) from departments; -- 9
pause departments 9
select count(*) from job_grades; -- 6
pause job_grades 6
select count(*) from locations; -- 23
pause locations 23
select count(*) from orderlines; -- 1225
pause orderlines 1225
select count(*) from orders;  -- 270
pause orders 270
select count(*) from products;  -- 35
pause products 35
select count(*) from suppliers;  -- 4
pause suppliers 4


