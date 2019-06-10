MERGE DwPrac1.dbo.DimProduct AS TARGET
USING masterpieces.dbo.stgProduct AS SOURCE 
ON (TARGET.ProductID = SOURCE.ProductID AND TARGET.SourceName = Source.SourceName) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND TARGET.ProductName <> SOURCE.Name 
			  OR TARGET.ProductID <> SOURCE.ProductID
			  OR TARGET.ProductNumber <> SOURCE.ProductNumber
			  OR TARGET.Color <> SOURCE.Color
			  OR TARGET.StandardCost <> SOURCE.StandardCost
			  OR TARGET.ListPrice <> SOURCE.ListPrice
			  OR TARGET.Size <> SOURCE.Size
			  OR TARGET.Weight <> SOURCE.Weight
			  OR TARGET.ProductCategoryID <> SOURCE.ProductCategoryID
			  OR TARGET.ProductModelID <> SOURCE.ProductModelID
			  OR TARGET.SellStartDate <> SOURCE.SellStartDate
			  OR TARGET.SellEndDate <> SOURCE.SellEndDate
			  OR TARGET.SourceName <> SOURCE.SourceName
THEN UPDATE SET TARGET.ProductName = SOURCE.Name, 
			    TARGET.ProductID = SOURCE.ProductID,
			    TARGET.ProductNumber = SOURCE.ProductNumber,
			    TARGET.Color = SOURCE.Color,
			    TARGET.StandardCost = SOURCE.StandardCost,
			    TARGET.ListPrice = SOURCE.ListPrice,
			    TARGET.Size = SOURCE.Size,
			    TARGET.Weight = SOURCE.Weight,
			    TARGET.ProductCategoryID = SOURCE.ProductCategoryID,
			    TARGET.ProductModelID = SOURCE.ProductModelID,
			    TARGET.SellStartDate = SOURCE.SellStartDate,
			    TARGET.SellEndDate = SOURCE.SellEndDate,
				TARGET.SourceName = SOURCE.SourceName
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET THEN 
INSERT([ProductID]
      ,[ProductName]
      ,[ProductNumber]
      ,[Color]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[Weight]
      ,[ProductCategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
	  , SourceName)
VALUES(SOURCE.[ProductID]
      ,SOURCE.[Name]
      ,SOURCE.[ProductNumber]
      ,SOURCE.[Color]
	  ,SOURCE.[StandardCost]
	  ,SOURCE.[ListPrice]
	  ,SOURCE.[Size]
	  ,SOURCE.[Weight]
	  ,SOURCE.[ProductCategoryID]
	  ,SOURCE.[ProductModelID]
      ,SOURCE.[sellStartdate]
      ,SOURCE.[sellEndDate]
	  ,Source.SourceName
)          
--When there is a row that exists in target and same record does not exist in source then 
   --delete this record target
WHEN NOT MATCHED BY SOURCE 
THEN DELETE 
--$action specifies a column of type nvarchar(10) in the OUTPUT clause that returns 
OUTPUT $action,
--one of three values for each row: 'INSERT', 'UPDATE', or 'DELETE' 
   --according to the action that was performed on that row
DELETED.ProductID AS TargetProductID, 
DELETED.ProductName AS TargetProductName, 
DELETED.[ProductNumber] AS TargetProductNumber,
DELETED.[Color] AS TargetColor,
DELETED.[StandardCost] AS TargetStandardCost,
DELETED.[ListPrice] AS TargetListPrice,
DELETED.[Size] AS TargetSize,
DELETED.[Weight] AS TargetWeight,
DELETED.[ProductCategoryID] AS TargetProductCategoryID,
DELETED.[ProductModelID] AS TargetProductModelID,
DELETED.[SellStartDate] AS TargetSellStartDate,
DELETED.[SellEndDate] AS TargetSellEndDate,

INSERTED.ProductID AS SourceProductID, 
INSERTED.ProductName AS SourceName,
INSERTED.[ProductNumber] AS SourceProductNumber,
INSERTED.[Color] AS SourceColor,
INSERTED.[StandardCost] AS SourceStandardCost,
INSERTED.[ListPrice] AS SourceListPrice,
INSERTED.[Size] AS SourceSize,
INSERTED.[Weight] AS SourceWeight,
INSERTED.[ProductCategoryID] AS SourceProductCategoryID,
INSERTED.[ProductModelID] AS SourceProductModelID,
INSERTED.[SellStartDate] AS SourceSellStartDate,
INSERTED.[SellEndDate] AS SourceSellEndDate ;


SELECT @@ROWCOUNT AS [No of columns affected];
GO