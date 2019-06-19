
INSERT INTO FactSales (SalesOrderID, SalesOrderDetailID, OrderQty, UnitPrice, UnitPriceDiscount, LineTotal,
					   OrderDateKey, ShipDateKey, DueDateKey, SalesOrderNumber, PurchaseOrderNumber, SubTotal, TaxAmt, Freight, TotalDue)
select  OH.SalesOrderId, OD.SalesOrderDetailID, OD.OrderQty, OD.Unitprice, OD.UnitPriceDiscount, OD.LineTotal , DDOrder.dimDateKey , DDShip.dimDateKey , 
	   DDDue.dimDateKey , OH.SalesOrderNumber, OH.PurchaseOrderNumber, OH.SubTotal, OH.TaxAmt, OH.Freight, OH.TotalDue
-- SELECT * 
from stgSalesOrderDetail OD 
join stgSalesOrderHeader OH
ON OD.SalesOrderId = OH.SalesOrderId
JOIN DimDate DDOrder 
ON OH.OrderDate = DDOrder.Date
JOIN DimDate DDShip ON OH.ShipDate = DDShip.Date
JOIN DimDate DDDue ON OH.DueDate = DDDue.Date




