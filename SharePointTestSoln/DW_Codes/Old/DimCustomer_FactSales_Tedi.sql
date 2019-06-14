create table dimCustomer(dimCustomerkey int IDENTITY(1,1), CustomerID int)
Select 
	 djs.JunkKey as StatusKey
	,djo.JunkKey as OnlineOrderFlagKey
	,dc.dimCustomerkey 
	,d.[SalesOrderDetailID]
	,d.orderqty
	,d.unitprice 
	,d.unitpricediscount
	,d.linetotal
	,h.SalesOrderNumber
	,h.accountnumber
	,h.salesordernumber
	,h.purchaseordernumber
	,h.taxamt
	,h.freight
From [stgSalesOrderDetail] d
Inner Join [stgSalesOrderHeader] h
on d.[SalesOrderID]=h.[SalesOrderID]
Inner join dbo.dimJunk djs on djs.[Value] = ISNull(h.Status,'Unknown') AND djs.Name = 'Status'
Inner Join dbo.dimJunk djo on djo.Value = IsNull(h.OnlineOrderFlag,'Unknown') AND djo.Name = 'OnlineOrderFlag'
Inner Join dimCustomer dc on dc.CustomerID = IsNull(h.CustomerID,'Unknown')
