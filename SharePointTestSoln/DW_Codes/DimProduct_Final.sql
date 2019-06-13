CREATE PROCEDURE usp_DimProduct_Populator AS
BEGIN

SET XACT_ABORT ON;
	

BEGIN TRANSACTION;

MERGE DwPrac4.dbo.DimProduct AS TARGET
USING (SELECT P.*, PC.ParentProductCategoryID , PC.[Name] AS CategoryName, M.[Name] AS ModelName FROM stgProduct P
JOIN stgProductCategory PC
ON P.ProductCategoryID = PC.ProductCategoryID 
JOIN stgProductModel M
ON P.ProductModelID = M.ProductModelID ) AS SOURCE 
ON (TARGET.ProductID = SOURCE.ProductID AND TARGET.SourceName = Source.SourceName) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND TARGET.ProductID <> SOURCE.ProductID
			  OR TARGET.ProductName <> SOURCE.[Name] 
			  OR TARGET.ProductNumber <> SOURCE.ProductNumber
			  OR TARGET.Color <> SOURCE.Color
			  OR TARGET.StandardCost <> SOURCE.StandardCost
			  OR TARGET.ListPrice <> SOURCE.ListPrice
			  OR TARGET.Size <> SOURCE.Size
			  OR TARGET.[Weight] <> SOURCE.[Weight]
			  OR TARGET.ProductCategoryID <> SOURCE.ProductCategoryID
			  OR TARGET.ProductModelID <> SOURCE.ProductModelID
			  OR TARGET.SellStartDate <> SOURCE.SellStartDate
			  OR TARGET.SellEndDate <> SOURCE.SellEndDate
			  OR TARGET.SourceName <> SOURCE.SourceName
  			  OR TARGET.ParentProductCategoryID <> Source.ParentProductCategoryID
			  OR TARGET.CategoryName <> Source.CategoryName
			  OR TARGET.ProductModelName <> Source.ModelName
THEN UPDATE SET TARGET.ProductName = SOURCE.[Name], 
			    TARGET.ProductID = SOURCE.ProductID,
			    TARGET.ProductNumber = SOURCE.ProductNumber,
			    TARGET.Color = SOURCE.Color,
			    TARGET.StandardCost = SOURCE.StandardCost,
			    TARGET.ListPrice = SOURCE.ListPrice,
			    TARGET.Size = SOURCE.Size,
			    TARGET.[Weight] = SOURCE.[Weight],
			    TARGET.ProductCategoryID = SOURCE.ProductCategoryID,
			    TARGET.ProductModelID = SOURCE.ProductModelID,
			    TARGET.SellStartDate = SOURCE.SellStartDate,
			    TARGET.SellEndDate = SOURCE.SellEndDate,
				TARGET.SourceName = SOURCE.SourceName,
				TARGET.ParentProductCategoryID = Source.ParentProductCategoryID , 
				TARGET.CategoryName = Source.CategoryName,
				TARGET.ProductModelName = Source.ModelName

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
	  , SourceName 
	  ,ParentProductCategoryID
	  ,CategoryName 
	  ,ProductModelName
)
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
	  ,Source.ParentProductCategoryID
	  ,Source.CategoryName
	  ,Source.ModelName
) ;      

COMMIT TRANSACTION;

END