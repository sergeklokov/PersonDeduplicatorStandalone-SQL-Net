use Phones
GO

-- Create table if it does not exist
IF OBJECT_ID('dbo.People','U') IS NULL
BEGIN
    CREATE TABLE dbo.People
    (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL
    );
END
ELSE
BEGIN
    PRINT 'Table dbo.People already exists; rows will be inserted into existing table.';
END
GO

-- Insert 300 test rows using a set-based approach (randomized combinations)
SET NOCOUNT ON;
BEGIN TRY
    ;WITH FirstNames(Name) AS
    (
        SELECT Name FROM (VALUES
        ('James'),('Mary'),('John'),('Patricia'),('Robert'),('Jennifer'),('Michael'),('Linda'),
        ('William'),('Elizabeth'),('David'),('Barbara'),('Richard'),('Susan'),('Joseph'),('Jessica'),
        ('Thomas'),('Sarah'),('Charles'),('Karen'),('Christopher'),('Nancy'),('Daniel'),('Lisa'),
        ('Matthew'),('Betty'),('Anthony'),('Margaret'),('Mark'),('Sandra'),('Donald'),('Ashley'),
        ('Steven'),('Kimberly'),('Paul'),('Emily'),('Andrew'),('Donna'),('Joshua'),('Michelle'),
        ('Kenneth'),('Carol'),('Kevin'),('Amanda'),('Brian'),('Dorothy'),('George'),('Melissa'),
        ('Edward'),('Deborah'),('Ronald'),('Stephanie'),('Timothy'),('Rebecca'),('Jason'),('Sharon'),
        ('Jeffrey'),('Laura'),('Ryan'),('Cynthia'),('Jacob'),('Kathleen')
        ) AS v(Name)
    ),
    LastNames(LastName) AS
    (
        SELECT LastName FROM (VALUES
        ('Smith'),('Johnson'),('Williams'),('Brown'),('Jones'),('Garcia'),('Miller'),('Davis'),
        ('Rodriguez'),('Martinez'),('Hernandez'),('Lopez'),('Gonzalez'),('Wilson'),('Anderson'),
        ('Thomas'),('Taylor'),('Moore'),('Jackson'),('Martin'),('Lee'),('Perez'),('Thompson'),
        ('White'),('Harris'),('Sanchez'),('Clark'),('Ramirez'),('Lewis'),('Robinson'),('Walker'),
        ('Young'),('Allen'),('King'),('Wright'),('Scott'),('Torres'),('Nguyen'),('Hill'),
        ('Flores'),('Green'),('Adams'),('Nelson'),('Baker'),('Hall'),('Rivera'),('Campbell'),
        ('Mitchell'),('Carter'),('Roberts'),('Gomez'),('Phillips'),('Evans'),('Turner'),('Diaz'),
        ('Parker'),('Cruz'),('Edwards'),('Collins'),('Reyes'),('Stewart'),('Morris')
        ) AS v(LastName)
    ),
    Combos AS
    (
        SELECT f.Name, l.LastName
        FROM FirstNames f
        CROSS JOIN LastNames l
    )
    INSERT INTO dbo.People (FirstName, LastName)
    SELECT TOP (300) Name, LastName
    FROM Combos
    ORDER BY NEWID();  -- randomize combinations
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO