/****** Script for SelectTopNRows command from SSMS  ******/
--  SELECT * FROM DimJunk
--as
--      ,[NKey]
--      ,[Name]
--      ,[Value]
      ----,[SourceName]
	  SELECT *
  FROM [DwPrac4].[dbo].[DimJunk] a
  join dbo.stgSalesOrderHeader b
    on a.Value = b.OnlineOrderFlag and a.Name ='OnlineOrderFlag' 
	join DimJunk a2
	on a2.Value = b.RevisionNumber and a2.Name ='RevisionNumber' JOIN DimJunk a3
	on a3.value = b.status  and a3.Name = 'status' 
	join DimJunk a4
	on a4.Value = b.ShipMethod and a4.Name = 'shipMethod'


	





