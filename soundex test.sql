select top 50 ID, FirstName, SOUNDEX(FirstName) 'SOUNDEXFirstName', LastName, SOUNDEX(LastName) 'SOUNDEXLastName' 
from dbo.People
where FirstName like 'John%' or FirstName like 'Jon%'
or LastName like 'Carter%'or LastName like 'Carteer%'
--select SOUNDEX('Kathleen')