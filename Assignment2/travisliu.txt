-- Name - Travis Liu, StudentID - 156740201, OracleID - dbs311_223zee22
-- Name - Nivedita Sharma, StudentID - 138647201, OracleID - dbs311_223zee31
-- Name - Mohammed bin obaid Abilail, StudentID - 144013208, OracleID - dbs311_223zee38
-- Name - Shaheid Amin Malik, StudentID - 152600201, OracleID - dbs311_223zee37

CREATE TABLE CUSTdbs311_223zee22 AS (
    SELECT cust_no, phone_no AS "balance"
    FROM customers
    WHERE cust_no <= 1050
);

-- DROP TABLE CUSTdbs311_223zee22;

CREATE TABLE TRANSdbs311_223zee22 (
    cust_no     NUMBER(4,0),
    operation   CHAR(1 BYTE),
    amount      NUMBER(7,0),
    status      VARCHAR2(50 BYTE),
    when        DATE
);

INSERT ALL
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1001, 'u', 213, '2022-10-29')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1002, 'u', 1002, '2022-10-29')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1003, 'u', 333, '2022-10-30')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1004, 'u', 4000, '2022-10-30')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1002, 'u', 2000, '2022-10-31')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1006, 'u', 600, '2022-10-31')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1010, 'i', 213, '2022-10-29')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1011, 'i', 2002, '2022-10-29')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1100, 'i', 333, '2022-10-30')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1012, 'd', null, '2022-10-30')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1013, 'i', 2000, '2022-10-31')
    INTO TRANSdbs311_223zee22 (cust_no, operation, amount, when) VALUES (1014, 'x', 600, '2022-10-31')
    SELECT * FROM dual;

-- DROP TABLE TRANSdbs311_223zee22;

DECLARE
    t_trans TRANSdbs311_223zee22%rowtype;
    CURSOR trans_cursor IS
        SELECT *
        FROM TRANSdbs311_223zee22;
BEGIN
    OPEN trans_cursor;
    LOOP
        FETCH trans_cursor INTO t_trans;
        EXIT WHEN trans_cursor%notfound;
        CASE
            WHEN t_trans.operation = 'u' THEN UPDATE CUSTdbs311_223zee22
                                                SET "balance" = t_trans.amount
                                                WHERE cust_no = t_trans.cust_no;
                                              IF SQL%FOUND THEN
                                                UPDATE TRANSdbs311_223zee22
                                                    SET status = 'Update: AMOUNT is updated'
                                                    WHERE cust_no = t_trans.cust_no;
                                              ELSE
                                                INSERT INTO CUSTdbs311_223zee22 VALUES (t_trans.cust_no, t_trans.amount);
                                                UPDATE TRANSdbs311_223zee22
                                                    SET status = 'Update: NEW data is inserted with the amount'
                                                    WHERE cust_no = t_trans.cust_no;
                                              END IF;
                                              
            WHEN t_trans.operation = 'd' THEN DELETE FROM CUSTdbs311_223zee22
                                                WHERE cust_no = t_trans.cust_no;
                                              IF SQL%FOUND THEN
                                                UPDATE TRANSdbs311_223zee22
                                                    SET status = 'Delete: ID is deleted'
                                                    WHERE cust_no = t_trans.cust_no;
                                              ELSE
                                                UPDATE TRANSdbs311_223zee22
                                                    SET status = 'Delete: ID does not exist'
                                                    WHERE cust_no = t_trans.cust_no;
                                              END IF;
                                              
            WHEN t_trans.operation = 'i' THEN UPDATE CUSTdbs311_223zee22
                                                SET "balance" = to_number("balance") + t_trans.amount
                                                WHERE cust_no = t_trans.cust_no;
                                              IF SQL%FOUND THEN
                                                UPDATE TRANSdbs311_223zee22
                                                    SET status = 'Increading: Balance is increased'
                                                    WHERE cust_no = t_trans.cust_no;
                                              ELSE
                                                UPDATE TRANSdbs311_223zee22
                                                    SET status = 'Increading: ID does not exist'
                                                    WHERE cust_no = t_trans.cust_no;
                                              END IF;
                                              
            ELSE UPDATE TRANSdbs311_223zee22
                    SET status = 'Incorrect operation code'
                    WHERE cust_no = t_trans.cust_no;
        END CASE;
    END LOOP;
    CLOSE trans_cursor;
END;
/
SELECT * FROM CUSTdbs311_223zee22;
SELECT * FROM TRANSdbs311_223zee22;