-- If a customer Exists in Dim table and his/her FirstNAme has changed on the source, keep historical data
-- If a customer Exists in Dim table and his/her LastName has changed on the source, update LastName on Dim


--Bk - Checking if FirstName in source table different with Dim
IF EXISTS (
	SELECT 1 FROM customerSource CS JOIN dimCustomer DC 
	ON CS.customerID = DC.customerID
	AND CS.FirstName <> DC.FirstName 
	WHERE DC.EndDate IS NULL 
)
BEGIN
	SET XACT_ABORT ON;


	BEGIN TRY

		BEGIN TRANSACTION;

		DECLARE @ED DATETIME 

		--bk--updating the historical data already existing in Dim 
				 --Giving EndDate and setting IsActive 0.
		UPDATE dimCustomer
		SET EndDate = GETDATE(),
		IsActive = 0,
		@ED =GETDATE()
		--SELECT DC.*
		FROM dimCustomer DC JOIN customerSource CS 
		ON DC.customerID = CS.customerID
		AND CS.FirstName <> DC.FirstName
		WHERE DC.EndDate IS NULL

		--bk-- inserting new row for active one (the previous one changed to historical data)
		INSERT INTO dimCustomer (customerID, FirstName, LastNAme, Gender)
		SELECT CS.customerID, CS.FirstName, CS.LastNAme, CS.Gender FROM customerSource CS JOIN dimCustomer DC
		ON CS.customerID = DC.customerID
		AND CS.FirstName <> DC.FirstName where DC.EndDate =  @ED
	--Find a way to use MAX End DATE for the same ID with a different First Name

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		SELECT @@TRANCOUNT

	END CATCH
END
--Bk - Checking if LastName in source table different with Dim
ELSE
IF EXISTS (
	SELECT 1 FROM customerSource CS JOIN dimCustomer DC 
	ON CS.customerID = DC.customerID
	AND CS.LastNAme <> DC.LastNAme
	WHERE DC.EndDate IS NULL 
)
SET XACT_ABORT ON;
BEGIN
	Begin TRY

	  --bk - updating LastName 
		UPDATE dimCustomer
		SET LastNAme = CS.LastNAme
		FROM dimCustomer DC JOIN customerSource CS 
		ON DC.customerID = CS.customerID
		AND CS.LastNAme <> DC.LastNAme
		WHERE DC.EndDate IS NULL

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SELECT @@TRANCOUNT
	END CATCH
END














