select top 10 ID, FirstName, SOUNDEX(FirstName) 'SOUNDEXFirstName', LastName, SOUNDEX(LastName) 'SOUNDEXLastName' 
from dbo.People
where FirstName like 'John%' or FirstName like 'Jon%'
--select SOUNDEX('Kathleen')