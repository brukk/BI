--DimAddress
--keep historical data if City changes
--update any other changes on active row

ALTER PROCEDURE [dbo].[usp_DimAddress_Populator] AS

BEGIN

	IF EXISTS (
		SELECT 1 FROM stgAddress SA JOIN DimAddress DA 
		ON SA.AddressID = DA.AddressID
		AND SA.SourceName = DA.SourceName
		AND SA.City <> DA.City
		WHERE DA.EndDate IS NULL
	)

		SET XACT_ABORT ON;
	
		BEGIN TRY

			BEGIN TRANSACTION;

			--#1 -INSERTING a new Row for updated City
			INSERT INTO DimAddress
			   (AddressID, AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode, SourceName)
			SELECT 
				SA.AddressID, SA.AddressLine1, SA.AddressLine2, SA.City, DA.StateProvince, SA.CountryRegion, SA.PostalCode, SA.SourceName
			FROM stgAddress SA 
			JOIN DimAddress DA
			ON SA.AddressID = DA.AddressID
			AND SA.SourceName = DA.SourceName
			AND SA.City <> DA.City
			where DA.IsActive = 1
			---------------------------------------------------------------------------

			--#2 -Historical data to City changed row
			DECLARE @ED DATETIME 

			UPDATE DimAddress
			SET EndDate = GETDATE(),
			IsActive = 0,
			@ED =GETDATE()
			--   SELECT DA.*
			FROM DimAddress DA JOIN stgAddress SA 
			ON DA.AddressID = SA.AddressID
			AND SA.SourceName = DA.SourceName
			AND SA.City <> DA.City
			WHERE DA.EndDate IS NULL;

		
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SELECT @@TRANCOUNT
	END CATCH



	-- -Null handling row
	IF NOT EXISTS (
				SELECT 	1 FROM DimAddress WHERE AddressID = -1
			)
			BEGIN
				INSERT INTO DimAddress
			   (AddressID, AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode, SourceName)
			   SELECT -1, 'Unknown' AddressLine1,'Unknown' AddressLine2,'Unknown' City,'Unknown' StateProvince,
					  'Unknown' CountryRegion,'Unknown' PostalCode,'N/A' SourceName
			END



	-- - Checking if there is a difference b/n Source and Dim
	IF EXISTS (
    		SELECT SA.AddressID, SA.AddressLine1, SA.AddressLine2, SA.City, SA.CountryRegion, SA.PostalCode, SA.SourceName FROM stgAddress SA
			EXCEPT
			SELECT DA.AddressID, DA.AddressLine1, DA.AddressLine2 ,DA.City, DA.CountryRegion, DA.PostalCode, DA.SourceName FROM dbo.DimAddress DA 

	)  
			SET XACT_ABORT ON;
		
				
	BEGIN TRY

			BEGIN TRANSACTION;

			--#3 -INSerting new Data into Dim Table
			INSERT INTO DimAddress
			   (AddressID, AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode, SourceName)
			SELECT 
			   SA.AddressID, SA.AddressLine1, SA.AddressLine2, SA.City, SA.StateProvince , SA.CountryRegion, SA.PostalCode, SA.SourceName
			FROM stgAddress SA 
			LEFT JOIN DimAddress DA
			ON SA.AddressID = DA.AddressID AND SA.SourceName = DA.SourceName
			WHERE DA.AddressID IS NULL

		
			--*****************************************************************************
			--#4 -Updating if (AddressID, AddressLine1, AddressLine2, StateProvince, CountryRegion, PostalCode, SourceName) Changes
			UPDATE DimAddress
			SET AddressID = SA.AddressID, AddressLine1 = SA.AddressLine1, AddressLine2 = SA.AddressLine2,
				CountryRegion = SA.CountryRegion, PostalCode = SA.PostalCode, SourceName = SA.SourceName
			--  SELECT DA.*
			FROM DimAddress DA JOIN  stgAddress SA
			ON DA.AddressID = SA.AddressID AND SA.SourceName = DA.SourceName
			WHERE (SA.AddressID <> DA.AddressID OR SA.AddressLine1 <> DA.AddressLine1 OR SA.AddressLine2 <> DA.AddressLine2 
				OR DA.CountryRegion <> SA.CountryRegion OR DA.PostalCode <> SA.PostalCode OR DA.SourceName <> SA.SourceName)
			And IsActive = 1

			--********************************************************************************


			COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH
		SELECT @@ERROR
	END CATCH

END


GO


