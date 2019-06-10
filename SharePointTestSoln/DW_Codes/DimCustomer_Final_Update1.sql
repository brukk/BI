--Bk - Checking if there is a difference bn source and Dim
IF EXISTS (
    	SELECT CS.customerID, CS.FirstName, CS.LastNAme, CS.EmailAddress, CS.Phone FROM stgCustomer CS
		EXCEPT
		SELECT DC.customerID, DC.FirstName, DC.LastNAme ,DC.EmailAddress, DC.Phone FROM dbo.dimCustomer DC 
)  
		SET XACT_ABORT ON;
		GO	
BEGIN TRY

		BEGIN TRANSACTION;

		--#1 -INSerting new Data into Dim Table
		INSERT INTO dimCustomer
		   ([CustomerID] ,[Title], [FirstName], [MiddleName], [LastName], [Suffix], [CompanyName], [SalesPerson], [EmailAddress], [Phone], [SourceName])
		SELECT 
		   CS.customerID, CS.Title, CS.FirstName, CS.MiddleName , CS.LastNAme, CS.Suffix, CS.CompanyName, CS.SalesPerson, CS.EmailAddress,CS.Phone, CS.SourceName
	    FROM stgCustomer CS 
		LEFT JOIN dimCustomer DC 
		ON CS.customerID = DC.customerID AND CS.SourceName = DC.SourceName
		WHERE DC.customerID IS NULL
		
		--*****************************************************************************
		--#2 -Updating if FirstName/LastName/Phone changed
		UPDATE DimCustomer
		SET FirstName = CS.FirstName, LastName = CS.LastName, Phone = CS.Phone
		--  SELECT DC.*
	    FROM DimCustomer DC JOIN  stgCustomer CS
		ON DC.customerID = CS.customerID AND CS.SourceName = DC.SourceName
		WHERE (CS.FirstName <> DC.FirstName OR CS.LastName <> DC.LastName OR CS.Phone <> DC.Phone)
		And IsActive = 1

		--********************************************************************************
		COMMIT TRANSACTION;

END TRY
BEGIN CATCH
	SELECT @@ERROR
END CATCH

IF EXISTS (
	SELECT 1 FROM stgCustomer CS JOIN dimCustomer DC 
	ON CS.customerID = DC.customerID
	AND CS.SourceName = DC.SourceName
	AND CS.EmailAddress <> DC.EmailAddress
	WHERE DC.EndDate IS NULL
)

	SET XACT_ABORT ON;
	GO
	BEGIN TRY

		BEGIN TRANSACTION;

		--#3 -INSERTING a new Row for updated EmailAddress
		INSERT INTO dimCustomer
		   ([CustomerID] ,[Title], [FirstName], [MiddleName], [LastName], [Suffix], [CompanyName], [SalesPerson], [EmailAddress], [Phone], [SourceName])
		SELECT 
		   CS.customerID, CS.Title, CS.FirstName, CS.MiddleName , CS.LastNAme, CS.Suffix, CS.CompanyName, CS.SalesPerson, CS.EmailAddress,CS.Phone, CS.SourceName
	    FROM stgCustomer CS 
		JOIN dimCustomer DC
		ON CS.customerID = DC.customerID
		AND CS.SourceName = DC.SourceName
		AND CS.EmailAddress <> DC.EmailAddress
		where DC.IsActive = 1
		---------------------------------------------------------------------------

		--#4 -Historical data to EmailAddress changed row
		DECLARE @ED DATETIME 

		UPDATE dimCustomer
		SET EndDate = GETDATE(),
		IsActive = 0,
		@ED =GETDATE()
		--   SELECT DC.*
		FROM dimCustomer DC JOIN stgCustomer CS 
		ON DC.customerID = CS.customerID
		AND CS.SourceName = DC.SourceName
		AND CS.EmailAddress <> DC.EmailAddress
		WHERE DC.EndDate IS NULL;

		
		COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	SELECT @@TRANCOUNT
END CATCH