SELECT @@VERSION;
SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('ProductLevel')   AS ProductLevel,
       SERVERPROPERTY('Edition')        AS Edition;

SELECT name, compatibility_level
FROM sys.databases
WHERE name = DB_NAME();

SELECT JARO_WINKLER_SIMILARITY('John','Jon') AS sim;