
IF EXISTS (
		 	
		SELECT CS.customerID, CS.FirstName, CS.LastNAme, CS.Gender FROM customerSource CS
		EXCEPT
		SELECT DC.customerID, DC.FirstName, DC.LastNAme, DC.Gender FROM dbo.dimCustomer DC
)  

	begin
	SET XACT_ABORT ON;
	--GO

	BEGIN TRY

		BEGIN TRANSACTION;

		INSERT INTO dimCustomer(customerID,FirstName,LastNAme,Gender)
		SELECT CS.customerID, CS.FirstName, CS.LastNAme, CS.Gender FROM customerSource CS 
		LEFT JOIN dimCustomer DC 
		ON CS.customerID = DC.customerID
		WHERE DC.customerID IS NULL

		-----------------------------------------------------------------------------

		DECLARE @ED DATETIME 

		UPDATE dimCustomer
		SET EndDate = GETDATE(),
		IsActive = 0,
		@ED =GETDATE()
		--SELECT DC.*
		FROM dimCustomer DC JOIN customerSource CS 
		ON DC.customerID = CS.customerID
		AND CS.FirstName <> DC.FirstName
		WHERE DC.EndDate IS NULL

		INSERT INTO dimCustomer (customerID, FirstName, LastNAme, Gender)
		SELECT CS.customerID, CS.FirstName, CS.LastNAme, CS.Gender FROM customerSource CS 
		JOIN dimCustomer DC
		ON CS.customerID = DC.customerID
		AND CS.FirstName <> DC.FirstName 
		---------------------------------------------------------------------------
		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH

		SELECT @@ERROR

	END CATCH

END
ELSE

IF EXISTS (
	SELECT 1 FROM customerSource CS JOIN dimCustomer DC 
	ON CS.customerID = DC.customerID
	AND CS.FirstName <> DC.FirstName
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
		FROM dimCustomer DC JOIN customerSource CS 
		ON DC.customerID = CS.customerID
		AND CS.FirstName <> DC.FirstName
		WHERE DC.EndDate IS NULL

		INSERT INTO dimCustomer (customerID, FirstName, LastNAme, Gender)
		SELECT CS.customerID, CS.FirstName, CS.LastNAme, CS.Gender FROM customerSource CS 
		JOIN dimCustomer DC
		ON CS.customerID = DC.customerID
		AND CS.FirstName <> DC.FirstName 
		where DC.EndDate = @ED
	--Find a way to use MAX End DATE for the same ID with a different First Name

		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH

		SELECT @@TRANCOUNT

	END CATCH

END