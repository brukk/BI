ALTER PROCEDURE usp_DimProduct_Populator AS
BEGIN

SET XACT_ABORT ON;
	
BEGIN TRANSACTION;

IF NOT EXISTS (
	SELECT 1 FROM DimProduct WHERE ProductID = -1
)

	BEGIN
    -- Inserting Null handler
	INSERT INTO DimProduct ([ProductID], [ProductName], [ProductNumber], [Color], [StandardCost], 
	                       [ListPrice], [Size], [Weight], [SellStartDate], [SellEndDate], ProductCategoryName, ProductModelName, SourceName )

	SELECT -1, 'Unknown' [ProductName], 'Unknown' [ProductNumber], 'Unknown' [Color], '0' [StandardCost], '0' [ListPrice], 'Unknown' [Size], 
	       '0' [Weight], '' [SellStartDate],'' [SellEndDate], 'Unknown' ProductCategoryName, 'Unknown' ProductModelName, 'N/A' [SourceName]

	END

MERGE DwPrac4.dbo.DimProduct AS TARGET
USING (SELECT P.*, PC.ParentProductCategoryID , PC.[Name] AS CategoryName, M.[Name] AS ModelName FROM 
stgProduct P JOIN 
stgProductCategory PC ON P.ProductCategoryID = PC.ProductCategoryID JOIN 
stgProductModel M ON P.ProductModelID = M.ProductModelID ) AS SOURCE 
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
			  OR TARGET.SellStartDate <> SOURCE.SellStartDate
			  OR TARGET.SellEndDate <> SOURCE.SellEndDate
			  OR TARGET.ProductCategoryName <> Source.CategoryName
			  OR TARGET.ProductModelName <> Source.ModelName
			  OR TARGET.SourceName <> SOURCE.SourceName
THEN UPDATE SET TARGET.ProductID = SOURCE.ProductID,
				TARGET.ProductName = SOURCE.[Name], 
			    TARGET.ProductNumber = SOURCE.ProductNumber,
			    TARGET.Color = SOURCE.Color,
			    TARGET.StandardCost = SOURCE.StandardCost,
			    TARGET.ListPrice = SOURCE.ListPrice,
			    TARGET.Size = SOURCE.Size,
			    TARGET.[Weight] = SOURCE.[Weight],
			    TARGET.SellStartDate = SOURCE.SellStartDate,
			    TARGET.SellEndDate = SOURCE.SellEndDate,
				TARGET.ProductCategoryName = Source.CategoryName,
				TARGET.ProductModelName = Source.ModelName,
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
      ,[SellStartDate]
      ,[SellEndDate]
	  ,ProductCategoryName 
	  ,ProductModelName
	  , SourceName 
)
VALUES(SOURCE.[ProductID]
      ,SOURCE.[Name]
      ,SOURCE.[ProductNumber]
      ,SOURCE.[Color]
	  ,SOURCE.[StandardCost]
	  ,SOURCE.[ListPrice]
	  ,SOURCE.[Size]
	  ,SOURCE.[Weight]
      ,SOURCE.[sellStartdate]
      ,SOURCE.[sellEndDate]
	  ,Source.CategoryName
	  ,Source.ModelName
  	  ,Source.SourceName

) ;      

COMMIT TRANSACTION;

END