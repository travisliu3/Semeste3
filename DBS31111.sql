/* DBS311-ZAA
* ASSIGNMENT-2
GROUP-11
MEMBER 1: Loveneet Kaur
 Student Id: 150002210
MEMBER 1: Kirandeep Kaur
 Student Id: 153834213
MEMBER 1: Faizal Aslam
 Student Id: 152121216
Date: December 11, 2022*/
CREATE OR REPLACE PROCEDURE find_customer(customer_id IN NUMBER, found OUT NUMBER) IS
v_custid NUMBER;
BEGIN
found:=1;
SELECT customer_id
INTO v_custid
FROM customers
WHERE customer_id=customer_id;
EXCEPTION 
WHEN NO_DATA_FOUND THEN
found:=0;
END;
/
CREATE OR REPLACE PROCEDURE find_product(p_product_id IN NUMBER, price OUT products.list_price%TYPE,productName OUT products.product_name%TYPE)
AS
 pMonth NUMBER;
BEGIN
 
SELECT list_price,product_name INTO price, productName
FROM products
WHERE product_id=p_product_id;
 IF pMonth = 11 OR pMonth = 12 THEN
 price:=price-0.1*price;
 END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
price:=0;
productName:=NULL;
END;
/
CREATE OR REPLACE PROCEDURE add_order(p_customer_id IN NUMBER, new_order_id OUT NUMBER) IS
BEGIN
SELECT MAX(order_id) INTO new_order_id
FROM orders;
new_order_id:=new_order_id+1;
INSERT INTO orders
VALUES(new_order_id, p_customer_id, 'Shipped', 56, sysdate);
END;
/
CREATE OR REPLACE PROCEDURE generate_order_id()
AS

mID NUMBER;
nID NUMBER
BEGIN
SELECT MAX(order_id)INTO mID
FROM orders;
nId=mId+1;
EXCEPTION
WHEN OTHERS
THEN 
 dbms_output.put_line('ERROR!'); 
RETURN nID
END;
/
CREATE OR REPLACE PROCEDURE add_order(p_customer_id IN NUMBER, new_order_id OUT NUMBER) IS
BEGIN
SELECT MAX(order_id) INTO new_order_id
FROM orders;
new_order_id:=new_order_id+1;
INSERT INTO orders
VALUES(new_order_id, p_customer_id, 'Shipped', 56, sysdate);
END;
/
CREATE OR REPLACE PROCEDURE customer_order(customerId IN NUMBER, orderId IN OUT NUMBER)

AS
DECLARE 
o_ID NUMBER;
BEGIN
SELECT order_id INTO o_ID
FROM orders
WHERE customer_id=customerId AND order_id=orderId;
 IF o_ID EXISTS THEN
 RETURN o_ID
 ELSE
 RETURN 0
EXCEPTION
WHEN NO_DATA_FOUND THEN
 dbms_output.put_line('ERROR!'); 
END;
/
CREATE OR REPLACE PROCEDURE display_order_status(orderId IN NUMBER, status OUT orders.status%type)AS
BEGIN
 IF EXISTS(SELECT*FROM orders WHERE order_id=orderID) THEN
 SELECT status INTO status
 FROM orders
 WHERE order_id=orderID;
 ELSE
 status=NULL;
 END IF;
WHEN NO_DATA_FOUND THEN
 dbms_output.put_line('ERROR!'); 
END;
/
CREATE OR REPLACE PROCEDURE cancel_order(orderId IN NUMBER, cancelStatus OUT NUMBER)AS
DECLARE 
orderStatus VARCHAR2(20 BYTE);
BEGIN
 IF EXISTS(SELECT*FROM orders WHERE order_id=orderId)THEN
 SELECT status INTO orderStatus
 FROM orders
 WHERE order_id=orderId;
 END IF;
 CASE orderStatus
 WHEN EXISTS THEN cancelStatus=0;
 WHEN 'Canceled' THEN cancelStatus=1;
 WHEN 'Shipped' THEN cancelStatus=2;
 ELSE cancelStatus=3 AND orderStatus='Canceled';
 END CASE;
END;
/