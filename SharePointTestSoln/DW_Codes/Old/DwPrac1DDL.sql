--use master;
--go
--Create Database DwPrac1
--use DwPrac1

CREATE TABLE DimAddress (
    AddressSK       INTEGER NOT NULL IDENTITY(1,1),
    AddressID       INTEGER,
    AddressLine1    VARCHAR(60),
    AddressLine2    VARCHAR(60),
    City            VARCHAR(30),
    StateProvince   VARCHAR(50),
    CountryRegion   VARCHAR(50),
    PostalCode      VARCHAR(15),
	SourceName Varchar(100)
);

ALTER TABLE DimAddress ADD CONSTRAINT DIMADDRESS_PK PRIMARY KEY ( AddressSK );

CREATE TABLE DimCustomer (
    CustomerSK     INTEGER NOT NULL IDENTITY(1,1),
    CustomerID     INTEGER,
    Title          VARCHAR(8),
    FirstName      VARCHAR(50),
    MiddleName     VARCHAR(50),
    LastName       VARCHAR(50),
    Suffix         VARCHAR(10),
    CompanyName    VARCHAR(128),
    SalesPerson    VARCHAR(256),
    EmailAddress   VARCHAR(50),
    Phone          VARCHAR(25),
	SourceName Varchar(100)
);

ALTER TABLE DimCustomer ADD CONSTRAINT DIMCUSTOMER_PK PRIMARY KEY ( CustomerSK );

CREATE TABLE DimProduct (
    ProductSK           INTEGER NOT NULL IDENTITY(1,1),
    ProductID           INTEGER,
    ProductName         VARCHAR(50),
    ProductNumber      VARCHAR(25),
    Color               VARCHAR(15),
    StandardCost        money,
    ListPrice           money,
    "Size"              VARCHAR(15),
    [Weight]              decimal(8, 2),
    ProductCategoryID   INTEGER,
    ProductModelID      INTEGER,
    SellStartDate       DATE,
    SellEndDate         DATE,
	SourceName Varchar(100)
);

ALTER TABLE DimProduct ADD CONSTRAINT DIMPRODUCT_PK PRIMARY KEY ( ProductSK );

CREATE TABLE FactSales (
    SalesOrderID             INTEGER NOT NULL,
    SalesOrderDetailID       INTEGER NOT NULL,
    SalesOrderNumber         NVARCHAR(25),
    OrderQty                 SMALLINT,
    UnitPrice                money,
    UnitPriceDiscount        money,
    OrderDate                DATE,
    DueDate                  DATE,
    ShipDate                 DATE,
    TaxAmt                   money,
    Freight                  money,
    LineTotal                Decimal(38, 6),
    CustomerSK  INTEGER NOT NULL,
    ProductSK     INTEGER NOT NULL,
    AddressSK    INTEGER NOT NULL
);

ALTER TABLE FactSales ADD CONSTRAINT FACTSALES_PK PRIMARY KEY ( SalesOrderDetailID,
                                                                SalesOrderID );

ALTER TABLE FactSales
    ADD CONSTRAINT FACTSALES_DIMADDRESS_FK FOREIGN KEY ( ADDRESSSK )
        REFERENCES DimAddress ( AddressSK );

ALTER TABLE FactSales
    ADD CONSTRAINT FACTSALES_DIMCUSTOMER_FK FOREIGN KEY ( CUSTOMERSK )
        REFERENCES DimCustomer ( CustomerSK );

ALTER TABLE FactSales
    ADD CONSTRAINT FACTSALES_DIMPRODUCT_FK FOREIGN KEY ( PRODUCTSK )
        REFERENCES DimProduct ( ProductSK );




