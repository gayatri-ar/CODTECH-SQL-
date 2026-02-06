/* =========================================================
   TASK 2: DATA ANALYSIS WITH COMPLEX QUERIES
   ========================================================= */

SELECT name AS Database_Name
FROM sys.databases;
GO

USE CodTech_SQL_Internship;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO

-- Employees table
SELECT * FROM Employees;
GO

-- Departments table
SELECT * FROM Departments;
GO

SELECT 
    e.EmpID,
    e.EmpName,
    e.Salary,
    d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID;
GO
------------------------------------------------------------
-- 1. WINDOW FUNCTION: Rank employees by salary
------------------------------------------------------------
SELECT 
    EmpID,
    EmpName,
    DeptID,
    Salary,
    RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
FROM Employees;
GO
------------------------------------------------------------
-- 2. WINDOW FUNCTION: Average salary per department
------------------------------------------------------------
SELECT 
    EmpID,
    EmpName,
    DeptID,
    Salary,
    AVG(Salary) OVER (PARTITION BY DeptID) AS Avg_Dept_Salary
FROM Employees;
GO
------------------------------------------------------------
-- 3. SUBQUERY: Employees earning above average salary
------------------------------------------------------------
SELECT 
    EmpID,
    EmpName,
    Salary
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
);
GO
------------------------------------------------------------
-- 4. CTE: Highest paid employee in each department
------------------------------------------------------------
WITH DeptSalaryCTE AS (
    SELECT
        EmpID,
        EmpName,
        DeptID,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS rn
    FROM Employees
)
SELECT 
    EmpID,
    EmpName,
    DeptID,
    Salary
FROM DeptSalaryCTE
WHERE rn = 1;
GO
------------------------------------------------------------
-- 5. CASE EXPRESSION: Salary category
------------------------------------------------------------
SELECT
    EmpID,
    EmpName,
    Salary,
    CASE
        WHEN Salary >= 80000 THEN 'High Salary'
        WHEN Salary BETWEEN 50000 AND 79999 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS Salary_Category
FROM Employees;
GO
------------------------------------------------------------
-- 6. ORDER & FILTER: Department-wise salary trend
------------------------------------------------------------
SELECT
    d.DeptName,
    e.EmpName,
    e.Salary
FROM Employees e
JOIN Departments d
ON e.DeptID = d.DeptID
ORDER BY d.DeptName, e.Salary DESC;
GO
