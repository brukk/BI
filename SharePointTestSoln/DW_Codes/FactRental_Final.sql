ALTER PROCEDURE usp_FactRentalPopulator AS

BEGIN

INSERT INTO FactRental (RentalID, RentalDateKey, ReturnDateKey, PaymentID, Amount, PaymentDateKey,
                        AddressSK, CustomerSK, ProductSK)
SELECT RE.RentalID, DDRental.dimDateKey, DDReturn.dimDateKey, PA.PaymentID, PA.Amount, DDPayment.dimDateKey, 
	   DA.AddressSK, DC.CustomerSK, DP.ProductSK
	   --  select *
FROM 
stgRental RE JOIN 
stgPayment PA ON (RE.CustomerID = PA.CustomerID AND RE.SourceName = PA.SourceName ) JOIN
stgCustomerAddress CA ON (CA.CustomerID = PA.CustomerID AND CA.SourceName = PA.SourceName) JOIN
DimAddress DA ON (DA.AddressID = CA.AddressID AND DA.SourceName = CA.SourceName AND DA.IsActive = 1 ) JOIN 
DimCustomer DC ON (DC.CustomerID = PA.CustomerID AND DC.SourceName = PA.SourceName AND DC.IsActive = 1 ) JOIN
DimProduct DP ON (DP.ProductID = RE.ProductID AND DP.SourceName = RE.SourceName ) JOIN

DimDate DDRental ON DDRental.Date = CAST(RE.RentalDate AS date) JOIN
DimDate DDReturn ON DDReturn.Date = CAST(RE.ReturnDate AS date) JOIN
DimDate DDPayment ON DDPayment.Date = CAST (PA.PaymentDate AS date)

END

