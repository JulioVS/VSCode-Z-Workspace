-----------------------------------------------------------------------
-- IBM Z Xplore SQL8 Challenge - Sample SQL Queries
-----------------------------------------------------------------------

-- IBM USER TABLES FOR THE CHALLENGE

SELECT * FROM IBMUSER.EMP;
SELECT * FROM IBMUSER.DEPT;
SELECT * FROM IBMUSER.PROJ;


-- 4.1 CROSSTAB

--> SQL CUBE Tutorial:
--> https://www.sqltutorial.org/sql-cube/

--> CUBE me da no solo los subtotales de las combinaciones de WORKDEPT y
--> SEX, sino también los totales generales para cada uno de esos campos
--> por separado, así como el total general!

--> O sea, me va a dar minimo, maximo y total de salario para:

--> - Cada combinación de WORKDEPT y SEX
-->     (es decir el comportamiento normal de GROUP BY)

--> - Cada WORKDEPT (independientemente del SEX)
--> - Cada SEX (independientemente del WORKDEPT)
--> - El total general (independientemente de WORKDEPT y SEX)

SELECT  WORKDEPT,
        SEX,
        MIN(SALARY) AS MIN,
        MAX(SALARY) AS MAX,
        SUM(SALARY) AS SUM
  FROM IBMUSER.EMP
 WHERE WORKDEPT LIKE 'D%'
 GROUP BY CUBE (WORKDEPT, SEX);

-- 4.2 THE RANKING

--> SQL RANK Tutorial:
--> https://www.geeksforgeeks.org/sql/rank-function-in-sql-server/

SELECT LASTNAME,
       WORKDEPT,
       BONUS,
       RANK() OVER (ORDER BY BONUS DESC) AS BONUS_RANKING
  FROM IBMUSER.EMP
 WHERE WORKDEPT IN ('A00', 'B01', 'C01')
 ORDER BY WORKDEPT, BONUS_RANKING DESC;

-- 4.3 CREATING A VIEW

--> SQL VIEW Tutorial:
--> https://www.w3schools.com/sql/sql_view.asp

-- Part A: Create the View

CREATE VIEW VEMPPAY AS
SELECT EMPNO,
       LASTNAME,
       WORKDEPT,
       (SALARY + BONUS + COMM) AS TOTAL_EARNINGS
  FROM IBMUSER.EMP;

-- Test the view first...

SELECT * FROM VEMPPAY;

-- Part B: Query the View

SELECT WORKDEPT,
       AVG(TOTAL_EARNINGS) AS AVG_TOTAL_EARNINGS
  FROM VEMPPAY
 GROUP BY WORKDEPT;

-- 4.4 FULL OUTER JOIN

--> SQL JOIN Tutorial:
--> https://www.w3schools.com/sql/sql_join.asp
--> https://www.w3schools.com/sql/sql_join_inner.asp
--> https://www.w3schools.com/sql/sql_join_left.asp
--> https://www.w3schools.com/sql/sql_join_right.asp
--> https://www.w3schools.com/sql/sql_join_full.asp

SELECT E.EMPNO,
       E.LASTNAME,
       E.WORKDEPT,
       P.PROJNAME
  FROM IBMUSER.EMP E
  FULL JOIN IBMUSER.PROJ P
    ON E.WORKDEPT = P.DEPTNO
 ORDER BY E.LASTNAME, P.PROJNAME;

-- 4.5 THE ANTI-JOIN                <= Evaluation Query!!!

--> SQL EXISTS Tutorial:
--> https://www.w3schools.com/sql/sql_exists.asp

SELECT DEPTNO,
       DEPTNAME
  FROM IBMUSER.DEPT D
 WHERE NOT EXISTS (SELECT 1
                     FROM IBMUSER.EMP E
                    WHERE E.WORKDEPT = D.DEPTNO);

-- 4.6 PUTTING IT ALL TOGETHER (EXPORT)

-->  Exported last query (4.5) results to "DB2OUT8.csv"

-- 4.7 LAST CHECK AND WRAP-UP

-->  Uploaded the csv file to my 'Z45864.OUTPUT' dataset
-->  Submitted the validation job CHKSQL8 at 'ZXP.PUBLIC.JCL'
-->  It was successful! Challenge done :)
