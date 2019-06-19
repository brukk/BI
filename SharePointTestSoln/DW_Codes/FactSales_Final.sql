ALTER procedure usp_FactSales_Populator AS

BEGIN

IF EXISTS (
	SELECT 
		OH.SalesOrderId, OD.SalesOrderDetailID, OD.OrderQty, OD.Unitprice, OD.UnitPriceDiscount, OD.LineTotal , DDOrder.dimDateKey , DDShip.dimDateKey , 
	    DDDue.dimDateKey , OH.SalesOrderNumber, OH.PurchaseOrderNumber, OH.SubTotal, OH.TaxAmt, OH.Freight, OH.TotalDue, 
		DA.AddressKey, DC.CustomerKey, DP.ProductKey, D3.JunkKey, D2.JunkKey, D4.JunkKey, D.JunkKey
	FROM 
		stgSalesOrderDetail OD JOIN 
		stgSalesOrderHeader OH ON (OD.SalesOrderId = OH.SalesOrderId ) JOIN 
		DimAddress DA ON (DA.AddressID = OH.BillToAddressID AND DA.SourceName = OH.SourceName AND DA.IsActive = 1 ) JOIN 
		DimCustomer DC ON (DC.CustomerID = OH.CustomerID AND DC.SourceName = OH.SourceName AND DC.IsActive = 1 ) JOIN 
		DimProduct DP ON (DP.ProductID = OD.ProductId AND DP.SourceName = OD.sourceName ) JOIN 
		DimDate DDOrder ON OH.OrderDate = DDOrder.[Date] JOIN 
		DimDate DDShip ON OH.ShipDate = DDShip.[Date] JOIN 
		DimDate DDDue ON OH.DueDate = DDDue.[Date] JOIN 
		DimJunk D on D.[Value] = OH.OnlineOrderFlag AND D.[Name] ='OnlineOrderFlag' JOIN 
		DimJunk D2 on D2.[Value] = OH.RevisionNumber AND D2.[Name] ='RevisionNumber' JOIN 
		DimJunk D3 on D3.[Value] = OH.[status]  AND D3.[Name] = 'status' JOIN
		DimJunk D4 on D4.[Value] = OH.ShipMethod AND D4.[Name] = 'shipMethod'

	EXCEPT

	SELECT SalesOrderID, SalesOrderDetailID, OrderQty, UnitPrice, UnitPriceDiscount, LineTotal,
		   OrderDateKey, ShipDateKey, DueDateKey, SalesOrderNumber, PurchaseOrderNumber, SubTotal, TaxAmt, Freight, TotalDue, 
		   AddressKey, CustomerKey, ProductKey, StatusKey, RevisionNumberKey, ShipMethodKey, OnlineOrderFlagKey 
    FROM FactSales

)

INSERT INTO FactSales (SalesOrderID, SalesOrderDetailID, OrderQty, UnitPrice, UnitPriceDiscount, LineTotal,
					   OrderDateKey, ShipDateKey, DueDateKey, SalesOrderNumber, PurchaseOrderNumber, SubTotal, TaxAmt, Freight, TotalDue, 
					   AddressKey, CustomerKey, ProductKey , StatusKey, RevisionNumberKey, ShipMethodKey, OnlineOrderFlagKey
)
select  OH.SalesOrderId, OD.SalesOrderDetailID, OD.OrderQty, OD.Unitprice, OD.UnitPriceDiscount, OD.LineTotal , DDOrder.dimDateKey , DDShip.dimDateKey , 
	   DDDue.dimDateKey , OH.SalesOrderNumber, OH.PurchaseOrderNumber, OH.SubTotal, OH.TaxAmt, OH.Freight, OH.TotalDue, 
	   DA.AddressKey, DC.CustomerKey, DP.ProductKey
	   , D3.JunkKey, D2.JunkKey, D4.JunkKey, D.JunkKey
-- SELECT * 
from 
stgSalesOrderDetail OD JOIN 
stgSalesOrderHeader OH ON (OD.SalesOrderId = OH.SalesOrderId ) JOIN 
DimAddress DA ON (DA.AddressID = OH.BillToAddressID AND DA.SourceName = OH.SourceName AND DA.IsActive = 1 ) JOIN 
DimCustomer DC ON (DC.CustomerID = OH.CustomerID AND DC.SourceName = OH.SourceName AND DC.IsActive = 1 ) JOIN 
DimProduct DP ON (DP.ProductID = OD.ProductId AND DP.SourceName = OD.sourceName ) JOIN 
DimDate DDOrder ON OH.OrderDate = DDOrder.[Date] JOIN 
DimDate DDShip ON OH.ShipDate = DDShip.[Date] JOIN 
DimDate DDDue ON OH.DueDate = DDDue.[Date] JOIN 
DimJunk D on D.[Value] = OH.OnlineOrderFlag AND D.[Name] ='OnlineOrderFlag' JOIN 
DimJunk D2 on D2.[Value] = OH.RevisionNumber AND D2.[Name] ='RevisionNumber' JOIN 
DimJunk D3 on D3.[Value] = OH.[status]  AND D3.[Name] = 'status' JOIN
DimJunk D4 on D4.[Value] = OH.ShipMethod AND D4.[Name] = 'shipMethod' 

LEFT JOIN FactSales FS
ON OH.SalesOrderId = FS.SalesOrderID AND OD.SalesOrderDetailID = FS.SalesOrderDetailID
WHERE  FS.SalesOrderDetailID IS NULL


END




