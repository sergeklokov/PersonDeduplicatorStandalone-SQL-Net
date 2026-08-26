-- Preview fuzzy candidate pairs (replace dbo.People and ID)
SELECT p1.ID   AS KeepID,
       p2.ID   AS DuplicateID,
       p1.FirstName, p1.LastName,
       p2.FirstName   AS FirstName2,
       p2.LastName    AS LastName2,
       JARO_WINKLER_SIMILARITY(p1.FirstName, p2.FirstName) AS FirstSim,
       JARO_WINKLER_SIMILARITY(p1.LastName,  p2.LastName)  AS LastSim,
       -- simple combined score (weighted)
       (JARO_WINKLER_SIMILARITY(p1.FirstName,p2.FirstName)*0.45
        + JARO_WINKLER_SIMILARITY(p1.LastName,p2.LastName)*0.55) AS CombinedSim
FROM dbo.People p1
JOIN dbo.People p2
  ON p1.ID < p2.ID
 -- blocking: first letter of last name and similar length
 AND LEFT(p1.LastName,1) = LEFT(p2.LastName,1)
 AND ABS(LEN(p1.LastName) - LEN(p2.LastName)) <= 2
WHERE (JARO_WINKLER_SIMILARITY(p1.FirstName,p2.FirstName) >= 0.88
       AND JARO_WINKLER_SIMILARITY(p1.LastName,p2.LastName) >= 0.88)
   OR ( (JARO_WINKLER_SIMILARITY(p1.FirstName,p2.FirstName)*0.45
          + JARO_WINKLER_SIMILARITY(p1.LastName,p2.LastName)*0.55) >= 0.90 )
ORDER BY CombinedSim DESC;