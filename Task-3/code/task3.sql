/* =========================================================
   TASK 3: DATABASE MIGRATION
   ========================================================= */

/* =========================================================
   1: VERIFY SOURCE DATABASE
   ========================================================= */
SELECT name AS Database_Name
FROM sys.databases;

-- Using the source database created in Task 1
USE InternshipDB;
GO

/* =========================================================
   2: VERIFY TABLES AND DATA
   ========================================================= */
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT * FROM Employees;

SELECT * FROM Departments;

/* =========================================================
   3: EXPORT DATA (SIMULATED MIGRATION SCRIPT)
   ========================================================= */

CREATE TABLE Employees_Migration (
    EmpID INT,
    EmpName VARCHAR(100),
    Salary DECIMAL(10,2),
    DeptID INT
);

CREATE TABLE Departments_Migration (
    DeptID INT,
    DeptName VARCHAR(100)
);

/* =========================================================
   4: COPY DATA INTO MIGRATION TABLES
   ========================================================= */

INSERT INTO Employees_Migration (EmpID, EmpName, Salary, DeptID)
SELECT EmpID, EmpName, Salary, DeptID
FROM Employees;

INSERT INTO Departments_Migration (DeptID, DeptName)
SELECT DeptID, DeptName
FROM Departments;

/* =========================================================
   5: DATA INTEGRITY CHECK
   ========================================================= */

-- Check record counts
SELECT COUNT(*) AS Employee_Count_Source FROM Employees;
SELECT COUNT(*) AS Employee_Count_Migrated FROM Employees_Migration;

SELECT COUNT(*) AS Department_Count_Source FROM Departments;
SELECT COUNT(*) AS Department_Count_Migrated FROM Departments_Migration;

/* =========================================================
   6: DATA VALIDATION
   ========================================================= */

-- Compare data
SELECT * FROM Employees
EXCEPT
SELECT * FROM Employees_Migration;

SELECT * FROM Departments
EXCEPT
SELECT * FROM Departments_Migration;

/* =========================================================
   7: FINAL SUCCESS MESSAGE
   ========================================================= */

PRINT 'Database Migration Completed Successfully';
