-- STEP 0: Build name of backup table
DECLARE @BackupTable NVARCHAR(200);
SET @BackupTable = N'People_Backup_' + REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), ':', '');
SET @BackupTable = REPLACE(@BackupTable, ' ', '_');
SET @BackupTable = REPLACE(@BackupTable, '-', '');

-- Create backup table with same structure (define columns explicitly)
DECLARE @CreateSQL NVARCHAR(MAX) =
    'CREATE TABLE ' + @BackupTable + ' (
        ID INT,
        FirstName NVARCHAR(100),
        LastName NVARCHAR(100)
    );';

EXEC (@CreateSQL);

-----------------------------------------------------------
-- STEP 1: Identify duplicates
-----------------------------------------------------------
CREATE TABLE #ToDelete (DuplicateID INT);

INSERT INTO #ToDelete (DuplicateID)
SELECT DISTINCT p2.ID
FROM dbo.People p1
JOIN dbo.People p2
  ON p1.ID < p2.ID
 AND LEFT(p1.LastName,1) = LEFT(p2.LastName,1)
 AND ABS(LEN(p1.LastName) - LEN(p2.LastName)) <= 2
 AND SOUNDEX(p1.FirstName) = SOUNDEX(p2.FirstName)
 AND DIFFERENCE(p1.LastName, p2.LastName) >= 3;

-----------------------------------------------------------
-- STEP 2: Backup records BEFORE deletion
-----------------------------------------------------------
DECLARE @BackupSQL NVARCHAR(MAX) =
    'INSERT INTO ' + @BackupTable +
    ' SELECT p.* FROM dbo.People p
      JOIN #ToDelete d ON p.ID = d.DuplicateID;';

EXEC (@BackupSQL);

-----------------------------------------------------------
-- STEP 3: Delete duplicates
-----------------------------------------------------------
BEGIN TRAN;
BEGIN TRY
    DELETE p
    FROM dbo.People p
    JOIN #ToDelete d ON p.ID = d.DuplicateID;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    ROLLBACK;
    THROW;
END CATCH;

DROP TABLE IF EXISTS #ToDelete;

-----------------------------------------------------------
-- Optional: Show final record count
-----------------------------------------------------------
SELECT COUNT(*) AS FinalCount FROM dbo.People;