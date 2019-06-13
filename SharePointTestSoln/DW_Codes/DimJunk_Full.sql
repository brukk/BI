declare @dimjunk table
	 (JunkSK int identity(1,1),NKey INT, [Name] varchar(200), [Value] varchar(200), SourceName varchar(100))
Insert INTO @dimjunk (NKey, Name, Value,SourceName)
/*the first row has to be a null handling row to record null values but that has contextual meaning*/
select * from (
select -1 Nkey,'NA' Name,'Unknown' Value,'NA' SourceName
) x

Insert INTO @dimjunk (NKey, Name, Value, SourceName)
Select 1,'Status','5','SharePoint'
UNION
Select 21, 'RevisionNumber', '1', 'SharePoint'
UNION
Select 41, 'ShipMethod', 'CargoTransport 5', 'SharePoint'
UNION
Select 61,'OnlineOrderFlag','1','SharePoint'
UNION
Select 62,'OnlineOrderFlag','0','SharePoint'

select * into dimJunk from @dimjunk
select * from dimJunk






