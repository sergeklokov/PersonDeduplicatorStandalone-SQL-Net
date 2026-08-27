select count(*) from dbo.People
--truncate table dbo.people

SELECT FirstName, LastName, COUNT(*) AS DuplicateCount
FROM dbo.People
GROUP BY FirstName, LastName
HAVING COUNT(*) > 1

SELECT FirstName, LastName, COUNT(*) AS DuplicateCount
FROM dbo.People
GROUP BY FirstName, LastName
HAVING COUNT(*) > 1;


SELECT p.*
FROM dbo.People AS p
INNER JOIN (
    SELECT FirstName, LastName
    FROM dbo.People
    GROUP BY FirstName, LastName
    HAVING COUNT(*) > 1
) d
  ON p.FirstName = d.FirstName
 AND p.LastName = d.LastName
ORDER BY p.FirstName, p.LastName, p.ID;