CREATE TABLE customerSource(
	customerID INT IDENTITY(1,1) NOT NULL primary key,
	FirstName VARCHAR(100),
	LastNAme VARCHAR(100),
	Gender Varchar(2)
)
 
CREATE TABLE dimCustomer(
	dimCustomerSkey INT IDENTITY(1,1) NOT NULL primary key,
	customerID INT,
	FirstName VARCHAR(100),
	LastNAme VARCHAR(100),
	Gender Varchar(2),
	StartDate datetime2(7) default getdate(),
	EndDate datetime2(7),
	IsActive bit default 1
)    

select * from dbo.customerSource
select * from dbo.dimCustomer         

-- Insert new data points in to Dim Table
-- If a customer Exists in Dim table and his/her FirstNAme has changed on the source, keep historical data
-- If a customer Exists in Dim table and his/her LastName has changed on the source, update LastName on Dim
-- If a Customer Exist in Dim table and gender changed, ignore 

INSERT INTO customerSource(FirstName,LastNAme,Gender)
SELECT * FROM (VALUES ('Ajay','Q','M'), ('Zack','Ravi','M'), ('Mike','Tom','M')) AS CSource (FN,LN,G)