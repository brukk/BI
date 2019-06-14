ALTER procedure usp_FactSales_Populator AS
BEGIN

INSERT INTO FactSales (SalesOrderID, SalesOrderDetailID, OrderQty, UnitPrice, UnitPriceDiscount, LineTotal,
					   OrderDateKey, ShipDateKey, DueDateKey, SalesOrderNumber, PurchaseOrderNumber, SubTotal, TaxAmt, Freight, TotalDue, 
					   AddressSK, CustomerSK, ProductSK )

select  OH.SalesOrderId, OD.SalesOrderDetailID, OD.OrderQty, OD.Unitprice, OD.UnitPriceDiscount, OD.LineTotal , DDOrder.dimDateKey , DDShip.dimDateKey , 
	   DDDue.dimDateKey , OH.SalesOrderNumber, OH.PurchaseOrderNumber, OH.SubTotal, OH.TaxAmt, OH.Freight, OH.TotalDue, 
	   DA.AddressSK, DC.CustomerSK, DP.ProductSK
-- SELECT * 
from 
stgSalesOrderDetail OD join 
stgSalesOrderHeader OH ON (OD.SalesOrderId = OH.SalesOrderId ) JOIN 
DimAddress DA ON (DA.AddressID = OH.BillToAddressID AND DA.SourceName = OH.SourceName AND DA.IsActive = 1 ) JOIN 
DimCustomer DC ON (DC.CustomerID = OH.CustomerID AND DC.SourceName = OH.SourceName AND DC.IsActive = 1 ) JOIN 
DimProduct DP ON (DP.ProductID = OD.ProductId AND DP.SourceName = OD.sourceName ) JOIN 
DimDate DDOrder ON OH.OrderDate = DDOrder.Date JOIN 
DimDate DDShip ON OH.ShipDate = DDShip.Date JOIN 
DimDate DDDue ON OH.DueDate = DDDue.Date

END




