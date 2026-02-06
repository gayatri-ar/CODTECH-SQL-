/* =========================================
   TASK 1: SQL JOINS PRACTICE
   ========================================= */

/* ---------- STEP 1: USE DATABASE ---------- */
USE InternshipDB;
GO


/* ---------- STEP 2: CREATE TABLES ---------- */
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,       -- Unique employee ID
    EmpName VARCHAR(50),          -- Employee name
    DeptID INT                   -- Department ID (can be NULL)
);

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,       -- Unique department ID
    DeptName VARCHAR(50)          -- Department name
);
GO


/* ---------- STEP 3: INSERT DATA ---------- */
INSERT INTO Employees VALUES
(1, 'Amit', 101),
(2, 'Neha', 102),
(3, 'Rahul', 103),
(4, 'Sneha', NULL);

INSERT INTO Departments VALUES
(101, 'HR'),
(102, 'IT'),
(104, 'Finance');
GO


/* ---------- STEP 4: INNER JOIN ---------- */
/* 
INNER JOIN:
Returns only records that have matching values in both Employees and Departments tables */
SELECT E.EmpName, D.DeptName
FROM Employees E
INNER JOIN Departments D
ON E.DeptID = D.DeptID;
GO


/* ---------- STEP 5: LEFT JOIN ---------- */
/* 
LEFT JOIN:
Returns all records from Employees table and matching records from Departments */
SELECT E.EmpName, D.DeptName
FROM Employees E
LEFT JOIN Departments D
ON E.DeptID = D.DeptID;
GO


/* ---------- STEP 6: RIGHT JOIN ---------- */
/* 
RIGHT JOIN:
Returns all records from Departments table and matching records from Employees */
SELECT E.EmpName, D.DeptName
FROM Employees E
RIGHT JOIN Departments D
ON E.DeptID = D.DeptID;
GO


/* ---------- STEP 7: FULL JOIN ---------- */
/* 
FULL JOIN:
Returns all records when there is a match in either Employees or Departments */
SELECT E.EmpName, D.DeptName
FROM Employees E
FULL JOIN Departments D
ON E.DeptID = D.DeptID;
GO


/* ---------- STEP 8: VIEW TABLE DATA  ---------- */

SELECT * FROM Employees;
SELECT * FROM Departments;
GO

/* =========================================================
   Task 2: Data Analysis with Complex Queries
   ========================================================= */

/* ---------------------------------------------------------
   1. WINDOW FUNCTIONS
   --------------------------------------------------------- */

-- 1.1 Rank employees based on salary (highest to lowest)
SELECT 
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
FROM Employees;


-- 1.2 Dense rank employees within each department
SELECT 
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    DENSE_RANK() OVER (
        PARTITION BY DepartmentID 
        ORDER BY Salary DESC
    ) AS Department_Salary_Rank
FROM Employees;


-- 1.3 Average salary of employees per department (window function)
SELECT 
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER (PARTITION BY DepartmentID) AS Avg_Department_Salary
FROM Employees;


-- 1.4 Running total of salaries (trend analysis)
SELECT 
    EmployeeID,
    EmployeeName,
    Salary,
    SUM(Salary) OVER (ORDER BY EmployeeID) AS Running_Total_Salary
FROM Employees;



/* ---------------------------------------------------------
   2. SUBQUERIES
   --------------------------------------------------------- */

-- 2.1 Employees earning more than the overall average salary
SELECT 
    EmployeeID,
    EmployeeName,
    Salary
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
);


-- 2.2 Employees with the highest salary in each department
SELECT 
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary
FROM Employees e
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);



/* ---------------------------------------------------------
   3. COMMON TABLE EXPRESSIONS (CTEs)
   --------------------------------------------------------- */

-- 3.1 CTE to calculate average salary per department
WITH Dept_Avg_Salary AS (
    SELECT 
        DepartmentID,
        AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT 
    e.EmployeeID,
    e.EmployeeName,
    e.DepartmentID,
    e.Salary,
    d.AvgSalary
FROM Employees e
JOIN Dept_Avg_Salary d
ON e.DepartmentID = d.DepartmentID;


-- 3.2 CTE to find top 2 highest paid employees in each department
WITH Salary_Rank_CTE AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        DepartmentID,
        Salary,
        ROW_NUMBER() OVER (
            PARTITION BY DepartmentID 
            ORDER BY Salary DESC
        ) AS RowNum
    FROM Employees
)
SELECT 
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary
FROM Salary_Rank_CTE
WHERE RowNum <= 2;
