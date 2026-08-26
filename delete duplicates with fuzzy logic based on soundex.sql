-- Preview candidate pairs (read-only)
SELECT p1.ID        AS KeepID,
       p2.ID        AS DuplicateID,
       p1.FirstName, p1.LastName,
       p2.FirstName AS FirstName2, p2.LastName AS LastName2,
       DIFFERENCE(p1.LastName, p2.LastName) AS LastNameDiff
FROM dbo.People p1
JOIN dbo.People p2
  ON p1.ID < p2.ID
 -- blocking to reduce comparisons
 AND LEFT(p1.LastName,1) = LEFT(p2.LastName,1)
 AND ABS(LEN(p1.LastName) - LEN(p2.LastName)) <= 2
 -- fuzzy conditions
 AND SOUNDEX(p1.FirstName) = SOUNDEX(p2.FirstName)
 AND DIFFERENCE(p1.LastName, p2.LastName) >= 3
ORDER BY LastNameDiff DESC, p1.LastName, p1.FirstName;
GO

-- Build candidate list (create temp table then insert)
CREATE TABLE #ToDelete (DuplicateID INT);
GO

INSERT INTO #ToDelete (DuplicateID)
SELECT DISTINCT p2.ID
FROM dbo.People p1
JOIN dbo.People p2
  ON p1.ID < p2.ID
 AND LEFT(p1.LastName,1) = LEFT(p2.LastName,1)
 AND ABS(LEN(p1.LastName) - LEN(p2.LastName)) <= 2
 AND SOUNDEX(p1.FirstName) = SOUNDEX(p2.FirstName)
 AND DIFFERENCE(p1.LastName, p2.LastName) >= 3;
GO

-- Inspect candidates before deleting
SELECT TOP (200) p.*
FROM dbo.People p
WHERE p.ID IN (SELECT DuplicateID FROM #ToDelete)
ORDER BY p.LastName, p.FirstName;
GO

select * From #ToDelete

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
GO

DROP TABLE IF EXISTS #ToDelete;
GO

select count(*) from People