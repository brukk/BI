--  SELECT * FROM DimJunk

  SELECT *
  FROM
  stgSalesOrderHeader OH JOIN 
  DimJunk D on D.[Value] = OH.OnlineOrderFlag and D.[Name] ='OnlineOrderFlag' join 
  DimJunk D2 on D2.[Value] = OH.RevisionNumber and D2.[Name] ='RevisionNumber' JOIN 
  DimJunk D3 on D3.[Value] = OH.[status]  and D3.[Name] = 'status' join 
  DimJunk D4 on D4.[Value] = OH.ShipMethod and D4.[Name] = 'shipMethod'


	





