
 ; with cte (FactRentalDate) As (
  select PaymentDate  from stgPayment 
  union
  Select RentalDate from stgRental 
  union
  Select ReturnDate from stgRental )
  insert into RentalDate (dimDateKey, FactRentalDate)
  select  D.dimDateKey, C.FactRentalDate from cte C
  JOIN DimDate D on CAST(C.FactRentalDate AS date) = D.[Date]

