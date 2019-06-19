ALTER PROCEDURE [dbo].[usp_FactRental_Populator] AS

BEGIN

	IF EXISTS (
		SELECT 
			RE.RentalID, DDRental.dimDateKey, DDReturn.dimDateKey, PA.PaymentID, PA.Amount, DDPayment.dimDateKey, 
			DC.CustomerKey, DP.ProductKey 
		FROM 
			stgPayment PA LEFT JOIN 
			stgRental RE ON (RE.RentalID = PA.RentalID )   LEFT JOIN
			DimCustomer DC ON (DC.CustomerID = PA.CustomerID AND DC.SourceName = PA.SourceName AND DC.IsActive = 1)  LEFT JOIN
			DimProduct DP ON (DP.ProductID = RE.ProductID AND DP.SourceName = RE.SourceName )  LEFT JOIN
			DimDate DDRental ON DDRental.Date = CAST(RE.RentalDate AS date)  LEFT JOIN
			DimDate DDReturn ON DDReturn.Date = CAST(RE.ReturnDate AS date)  LEFT JOIN
			DimDate DDPayment ON DDPayment.Date = CAST (PA.PaymentDate AS date) 
		
		EXCEPT

		SELECT 
		   RentalID, RentalDateKey, ReturnDateKey, PaymentID, Amount, PaymentDateKey, CustomerKey, ProductKey
		FROM 
		   FactRental
	)


	INSERT INTO FactRental (RentalID, RentalDateKey, ReturnDateKey, PaymentID, Amount, PaymentDateKey,
						   CustomerKey, ProductKey)
	SELECT RE.RentalID, DDRental.dimDateKey, DDReturn.dimDateKey, PA.PaymentID, PA.Amount, DDPayment.dimDateKey, 
		   DC.CustomerKey, DP.ProductKey
		   --  select *
	FROM 
		stgPayment PA LEFT JOIN 
		stgRental RE ON (RE.RentalID = PA.RentalID ) LEFT JOIN
		DimCustomer DC ON (DC.CustomerID = PA.CustomerID AND DC.SourceName = PA.SourceName AND DC.IsActive = 1) LEFT JOIN
		DimProduct DP ON (DP.ProductID = RE.ProductID AND DP.SourceName = RE.SourceName ) LEFT JOIN
		DimDate DDRental ON DDRental.Date = CAST(RE.RentalDate AS date) LEFT JOIN
		DimDate DDReturn ON DDReturn.Date = CAST(RE.ReturnDate AS date) LEFT JOIN
		DimDate DDPayment ON DDPayment.Date = CAST (PA.PaymentDate AS date) 

		LEFT JOIN FactRental FR
		ON (FR.RentalID = RE.RentalID AND FR.PaymentID = PA.PaymentID)
		WHERE (FR.RentalID IS NULL AND FR.PaymentID IS NULL)

END

