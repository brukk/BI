--DimCustomer
--keep historical data if Email changes
--updata Firstname, LastName, Phone if Source changes
--Title is fixed value, ignore it if source changes 

IF EXISTS (
		SELECT CS.customerID, CS.FirstName, CS.LastNAme, CS.EmailAddress, CS.Phone FROM stgCustomer CS
		EXCEPT
		SELECT DC.customerID, DC.FirstName, DC.LastNAme ,DC.EmailAddress, DC.Phone FROM dbo.dimCustomer DC
)  

	begin
	SET XACT_ABORT ON;
	--GO

	BEGIN TRY

		BEGIN TRANSACTION;

		--INSerting new Data into Dim Table
		INSERT INTO dimCustomer
		   ([CustomerID] ,[Title], [FirstName], [MiddleName], [LastName], [Suffix], [CompanyName], [SalesPerson], [EmailAddress], [Phone], [SourceName])
		SELECT 
		   CS.customerID, CS.Title, CS.FirstName, CS.MiddleName , CS.LastNAme, CS.Suffix, CS.CompanyName, CS.SalesPerson, CS.EmailAddress,CS.Phone, CS.SourceName
	    FROM stgCustomer CS 
		LEFT JOIN dimCustomer DC 
		ON CS.customerID = DC.customerID AND CS.SourceName = DC.SourceName
		WHERE DC.customerID IS NULL

		-----------------------------------------------------------------------------

		--Historical data to EmailAddress
		DECLARE @ED DATETIME 

		UPDATE dimCustomer
		SET EndDate = GETDATE(),
		IsActive = 0,
		@ED =GETDATE()
		--SELECT DC.*
		FROM dimCustomer DC JOIN stgCustomer CS 
		ON DC.customerID = CS.customerID
		AND CS.SourceName = DC.SourceName
		AND CS.EmailAddress <> DC.EmailAddress
		WHERE DC.EndDate IS NULL;

		--INSERTING a new Row for updated EmailAddress
		INSERT INTO dimCustomer
		   ([CustomerID] ,[Title], [FirstName], [MiddleName], [LastName], [Suffix], [CompanyName], [SalesPerson], [EmailAddress], [Phone], [SourceName])
		SELECT 
		   CS.customerID, CS.Title, CS.FirstName, CS.MiddleName , CS.LastNAme, CS.Suffix, CS.CompanyName, CS.SalesPerson, CS.EmailAddress,CS.Phone, CS.SourceName
	    FROM stgCustomer CS 
		JOIN dimCustomer DC
		ON CS.customerID = DC.customerID
		AND CS.SourceName = DC.SourceName
		AND CS.EmailAddress <> DC.EmailAddress
		---------------------------------------------------------------------------

		--*****************************************************************************
		--Updating if FirstName/LastName/Phone changed
		UPDATE DimCustomer
		SET FirstName = CS.FirstName, LastName = CS.LastName, Phone = CS.Phone
	    FROM stgCustomer CS JOIN DimCustomer DC 
		ON DC.customerID = CS.customerID AND CS.SourceName = DC.SourceName
		WHERE CS.FirstName <> DC.FirstName OR CS.LastName <> DC.LastName OR CS.Phone <> DC.Phone
		And IsActive = 1

		--********************************************************************************

		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH

		SELECT @@ERROR

	END CATCH

END
ELSE

IF EXISTS (
	SELECT 1 FROM stgCustomer CS JOIN dimCustomer DC 
	ON CS.customerID = DC.customerID
	AND CS.SourceName = DC.SourceName
	AND CS.EmailAddress <> DC.EmailAddress
	WHERE DC.EndDate IS NULL
)
BEGIN

	SET XACT_ABORT ON;
	--GO

	BEGIN TRY

		BEGIN TRANSACTION;

		--DECLARE @ED DATETIME 

		UPDATE dimCustomer
		SET EndDate = GETDATE(),
		IsActive = 0,
		@ED =GETDATE()
		--SELECT DC.*
		FROM dimCustomer DC JOIN stgCustomer CS 
		ON DC.customerID = CS.customerID
		AND CS.SourceName = DC.SourceName
		AND CS.EmailAddress <> DC.EmailAddress
		WHERE DC.EndDate IS NULL

		INSERT INTO dimCustomer
		   ([CustomerID] ,[Title], [FirstName], [MiddleName], [LastName], [Suffix], [CompanyName], [SalesPerson], [EmailAddress], [Phone], [SourceName])
		SELECT 
		   CS.customerID, CS.Title, CS.FirstName, CS.MiddleName , CS.LastNAme, CS.Suffix, CS.CompanyName, CS.SalesPerson, CS.EmailAddress,CS.Phone, CS.SourceName
	    FROM stgCustomer CS 
		JOIN dimCustomer DC
		ON CS.customerID = DC.customerID
		AND CS.SourceName = DC.SourceName
		AND CS.EmailAddress <> DC.EmailAddress
		where DC.EndDate = @ED
	--Find a way to use MAX End DATE for the same ID with a different First Name
	
		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH

		SELECT @@TRANCOUNT

	END CATCH

END