Alter PROCEDURE usp_DimJunk_Populator AS

BEGIN

declare @dimjunk table
	 (JunkSK int identity(1,1),NKey INT, [Name] varchar(200), [Value] varchar(200))
Insert INTO @dimjunk (NKey, Name, Value)
/*the first row has to be a null handling row to record null values but that has contextual meaning*/
select * from (
select -1 Nkey,'NA' Name,'Unknown' Value
) x

Insert INTO @dimjunk (NKey, Name, Value)
Select 1,'Status','5'
UNION
Select 21, 'RevisionNumber', '1'
UNION
Select 41, 'ShipMethod', 'Cargo Transport 5'
UNION
Select 61,'OnlineOrderFlag','1'
UNION
Select 62,'OnlineOrderFlag','0'
Union
Select 81, 'SourceName', 'MySQL'
UNION
Select 82, 'SourceName', 'SharePoint'


select * into DimJunk from @dimjunk

END



