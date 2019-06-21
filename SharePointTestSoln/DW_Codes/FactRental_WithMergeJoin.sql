ALTER PROCEDURE usp_FactRental_Popuator_WithMergeJoin AS

BEGIN

	SET XACT_ABORT ON;
	
	BEGIN TRANSACTION;

	MERGE dbo.FactRental AS TARGET
	USING (
		SELECT PA.*,DDRental.[DimDateKey] AS RentalDateKey, DDReturn.[DimDateKey] AS ReturnDateKey, 
			   DDPayment.[DImDateKey] AS PaymentDateKey, DC.Customerkey, DP.ProductKey 
		FROM
		stgPayment PA LEFT JOIN 
		stgRental RE ON (RE.RentalID = PA.RentalID )   LEFT JOIN
		DimCustomer DC ON (DC.CustomerID = PA.CustomerID AND DC.SourceName = PA.SourceName AND DC.IsActive = 1)  LEFT JOIN
		DimProduct DP ON (DP.ProductID = RE.ProductID AND DP.SourceName = RE.SourceName )  LEFT JOIN
		DimDate DDRental ON DDRental.[Date]= CAST(RE.RentalDate AS DATE) LEFT JOIN
		DimDate DDReturn ON DDReturn.[Date]= CAST(RE.ReturnDate AS DATE) LEFT JOIN
		DimDate DDPayment ON DDPayment.[Date]= CAST(PA.PaymentDate AS DATE)
	)
	AS SOURCE ON (TARGET.PaymentID = SOURCE.PaymentID)
	WHEN MATCHED AND TARGET.RentalID <> Source.RentalID
				  OR TARGET.RentalDateKey <> SOURCE.RentalDateKey 
				  OR TARGET.ReturnDateKey <> SOURCE.ReturnDateKey
				  OR TARGET.PaymentID <> SOURCE.PaymentID
				  OR TARGET.Amount <> SOURCE.Amount
				  OR TARGET.PaymentDateKey <> SOURCE.PaymentDateKey
				  OR TARGET.CustomerKey <> SOURCE.CustomerKey
				  OR TARGET.ProductKey <> SOURCE.Productkey
	THEN UPDATE SET TARGET.RentalID = Source.RentalID,
					TARGET.RentalDateKey = SOURCE.RentalDateKey,
					TARGET.ReturnDateKey = SOURCE.ReturnDateKey,
					TARGET.PaymentID = SOURCE.PaymentID,
					TARGET.Amount = SOURCE.Amount,
					TARGET.PaymentDateKey = SOURCE.PaymentDateKey,
					TARGET.CustomerKey = SOURCE.CustomerKey,
					TARGET.ProductKey = SOURCE.Productkey

	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ( [RentalID]
			,[RentalDateKey]
			,[ReturnDateKey]
			,[PaymentID]
			,[Amount]
			,[PaymentDateKey]
			,[CustomerKey]
			,[ProductKey]
	)
	VALUES ( SOURCE.[RentalID]
			,SOURCE.[RentalDateKey]
			,SOURCE.[ReturnDateKey]
			,SOURCE.[PaymentID]
			,SOURCE.[Amount]
			,SOURCE.[PaymentDateKey]
			,SOURCE.[CustomerKey]
			,SOURCE.[ProductKey]
	);

	COMMIT TRANSACTION;

END

