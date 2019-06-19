declare @orderHeader table (salesOrderId int, orderDate date, shipDate date, dueDate date)
insert into @orderHeader values (765, '01-01-2018', '01-02-2018', '01-03-2018'), 
                                (764, '01-02-2018', '01-04-2018', '01-05-2018')

declare @DimDate table (dimDateKey int, dateValue date)
insert into @DimDate values (1, '01-01-2018'), (2, '01-02-2018'), (3, '01-03-2018'), (4, '01-04-2018'),(5, '01-05-2018')

--select * from @orderHeader
--select * from @DimDate

---- implicit join
--select oh.salesOrderId, dd.dimDateKey AS orderDatekey, oh.shipDate, oh.dueDate from @orderHeader oh, @DimDate dd
--where oh.orderDate = dd.dateValue

select oh.salesOrderId , orderDate.dimdatekey as orderDateKey , shipDate.dimDateKey AS shipDateKey
,dueDate.dimDateKey AS dueDateKey
from @orderHeader OH JOIN @DimDate OrderDate
on OH.orderDate = orderDate.dateValue
join @DimDate shipDate ON OH.shipDate = shipDate.dateValue
join @DimDate dueDate ON OH.dueDate = dueDate.dateValue

--*****************************************************************************************************************
--- BK

INSERT INTO FactSales (SalesOrderID, SalesOrderDetailID, OrderDateKey, ShipDateKey,DueDateKey)
select  OH.SalesOrderId, OD.SalesOrderDetailID, DDOrder.dimDateKey AS OrderDateKey, DDShip.dimDateKey AS ShipDateKey, 
	   DDDue.dimDateKey AS DueDateKey  from stgSalesOrderDetail OD join stgSalesOrderHeader OH
ON OD.SalesOrderId = OH.SalesOrderId
JOIN DimDate DDOrder 
ON OH.OrderDate = DDOrder.Date
JOIN DimDate DDShip ON OH.ShipDate = DDShip.Date
JOIN DimDate DDDue ON OH.DueDate = DDDue.Date