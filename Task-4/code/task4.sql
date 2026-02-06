/* =========================================
   TASK 4: DATABASE BACKUP AND RECOVERY
   Database: InternshipDB
   ========================================= */

-- STEP 1: CHECK DATABASE
SELECT name FROM sys.databases;
GO

-- STEP 2: FULL BACKUP (default backup location)
BACKUP DATABASE InternshipDB
TO DISK = 'InternshipDB_Task4_FullBackup.bak'
WITH INIT;
GO

-- STEP 3: VERIFY BACKUP
RESTORE VERIFYONLY
FROM DISK = 'InternshipDB_Task4_FullBackup.bak';
GO

-- STEP 4: SIMULATE FAILURE
USE InternshipDB;
GO

CREATE TABLE Backup_Test (
    ID INT PRIMARY KEY,
    Info VARCHAR(50)
);

INSERT INTO Backup_Test VALUES (1, 'Before Restore');

SELECT * FROM Backup_Test;

DROP TABLE Backup_Test;
GO

-- STEP 5: RESTORE DATABASE
USE master;
GO

ALTER DATABASE InternshipDB
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

RESTORE DATABASE InternshipDB
FROM DISK = 'InternshipDB_Task4_FullBackup.bak'
WITH REPLACE;
GO

ALTER DATABASE InternshipDB
SET MULTI_USER;
GO

-- STEP 6: VERIFY RECOVERY
USE InternshipDB;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;
GO
