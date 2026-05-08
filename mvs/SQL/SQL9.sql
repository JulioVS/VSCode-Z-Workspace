-----------------------------------------------------------------------
-- IBM Z Xplore SQL9 Challenge - Sample SQL Queries
-----------------------------------------------------------------------

-- IBM USER TABLES FOR THE CHALLENGE

SELECT * FROM IBMUSER.EMP;
SELECT * FROM IBMUSER.PROJ;


-- 4.1 HANDLING MISSING DATA

SELECT PROJNO,
       PROJNAME,
       DEPTNO,
       COALESCE(MAJPROJ, 'NO MAJOR PROJECT') AS MAJPROJ
  FROM IBMUSER.PROJ
 WHERE DEPTNO IN ('D01', 'D11')
 ORDER BY PROJNO;

-- 4.2 CONDITIONAL CATEGORIZATION

--> SQL CASE Tutorial:
--> https://www.w3schools.com/sql/sql_case.asp

SELECT EMPNO,
       FIRSTNME,
       LASTNAME,
       CASE
         WHEN SALARY < 25000 THEN 'LOW'
         WHEN SALARY >= 25000 AND SALARY <= 30000 THEN 'NORMAL'
         WHEN SALARY > 30000 THEN 'HIGH'
         ELSE 'NULL'
       END AS INCOME
  FROM IBMUSER.EMP
 WHERE WORKDEPT = 'D11';

-- 4.3 MATHS AND TYPE CASTING

--> The CASE in the WHERE clause is to protect from division by zero.

--> MARINO and MONTEVERDE will both show a COMM_PERCENTAGE of '8.000'
--> but in reality their true value is 8,000695 % so that's why they
--> are included in the result set!

SELECT LASTNAME,
       CAST((100.0 * COMM / SALARY) AS DECIMAL(8,3)) AS COMM_PERCENTAGE
  FROM IBMUSER.EMP
 WHERE CASE
         WHEN COMM = 0 OR SALARY = 0 THEN NULL
         ELSE COMM/SALARY
       END
       > 0.08;

-- 4.4 THE ALL SUBQUERY

SELECT EMPNO,
       LASTNAME,
       SALARY,
       WORKDEPT
  FROM IBMUSER.EMP
 WHERE WORKDEPT <> 'D11'
   AND SALARY > ALL (SELECT SALARY
                       FROM IBMUSER.EMP
                      WHERE WORKDEPT = 'D11')
 ORDER BY EMPNO;

-- 4.5 THE CORRELATED SUBQUERY      <= Evaluation Query!!!

SELECT EMPNO,
       SALARY,
       WORKDEPT
  FROM IBMUSER.EMP AS E1
 WHERE SALARY > (SELECT AVG(SALARY)
                  FROM IBMUSER.EMP AS E2
                 WHERE E2.WORKDEPT = E1.WORKDEPT)
 ORDER BY WORKDEPT, EMPNO;

-- 5 PUTTING IT ALL TOGETHER (EXPORT)

-->  Exported last query (4.5) results to "DB2OUT9.csv"

-- 6 LAST CHECK AND WRAP-UP

-->  Uploaded the csv file to my 'Z45864.OUTPUT' dataset
-->  Submitted the validation job CHKSQL9 at 'ZXP.PUBLIC.JCL'
-->  It was successful! Challenge done :)
