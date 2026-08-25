select count(*) from dbo.People

SELECT Name, LastName, COUNT(*) AS DuplicateCount
FROM dbo.People
GROUP BY Name, LastName
HAVING COUNT(*) > 1

SELECT [Name], LastName, COUNT(*) AS DuplicateCount
FROM dbo.People
GROUP BY [Name], LastName
HAVING COUNT(*) > 1;


SELECT p.*
FROM dbo.People AS p
INNER JOIN (
    SELECT [Name], LastName
    FROM dbo.People
    GROUP BY [Name], LastName
    HAVING COUNT(*) > 1
) d
  ON p.[Name] = d.[Name]
 AND p.LastName = d.LastName
ORDER BY p.[Name], p.LastName, p.ID;