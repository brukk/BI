use dwprac5

SET XACT_ABORT ON;
	


BEGIN TRANSACTION;


CREATE TABLE DimAddress (
    AddressKey      INTEGER NOT NULL identity(1,1),
    AddressID       INTEGER,
    AddressLine1    VARCHAR(60),
    AddressLine2    VARCHAR(60),
    City            VARCHAR(30),
    StateProvince   VARCHAR(50),
    CountryRegion   VARCHAR(50),
    PostalCode      VARCHAR(15),
    StartDate       datetime2(7) default getdate(),
    EndDate         datetime2(7),
    IsActive        INTEGER default 1,
    SourceName      VARCHAR(100)
);

ALTER TABLE DimAddress ADD CONSTRAINT DimAddress_PK PRIMARY KEY ( AddressKey );

CREATE TABLE DimAddressDimCustomerLink (
    AddressType               VARCHAR(50),
    SourceName                VARCHAR(100),
    AddressKey     INTEGER NOT NULL,
    CustomerKey   INTEGER NOT NULL
);

ALTER TABLE DimAddressDimCustomerLink ADD CONSTRAINT DimAddressDimCustomerLink_PK PRIMARY KEY ( AddressKey,
                                                                                                  CustomerKey );


CREATE TABLE DimCustomer (
    CustomerKey    INTEGER NOT NULL identity(1,1),
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
    StartDate      datetime2(7) default getdate(),
    EndDate        datetime2(7),
    IsActive       INTEGER default 1,
    SourceName     VARCHAR(100)
);

ALTER TABLE DimCustomer ADD CONSTRAINT DimCustomer_PK PRIMARY KEY ( CustomerKey );

CREATE TABLE DimDate (
    DateKey        CHAR(8) NOT NULL,
    [Date]         DATE,
    [Day]            INTEGER,
    [Month]          INTEGER,
    FirstOfMonth   DATE,
    [MonthName]      NVARCHAR(30),
    [Week ]          INTEGER,
    ISOweek        INTEGER,
    [DayName]        NVARCHAR(4000),
    [DayOfWeek]    INTEGER,
    [Quarter]        INTEGER,
    [Year]           INTEGER,
    FirstOfYear    DATE
);

ALTER TABLE DimDate ADD CONSTRAINT DimDate_PK PRIMARY KEY ( DateKey );

CREATE TABLE DimJunk (
    JunkKey      INTEGER NOT NULL identity(1,1),
    NKey         INTEGER,
    [Name]         VARCHAR(200),
    [Value]        VARCHAR(200),
    SourceName   VARCHAR(100)
);

ALTER TABLE DimJunk ADD CONSTRAINT DimJunk_PK PRIMARY KEY ( JunkKey );

CREATE TABLE DimProduct (
    ProductKey                INTEGER NOT NULL identity(1,1) ,
    ProductID                 INTEGER,
    ProductName               VARCHAR(50),
    ProductNumber             VARCHAR(25),
    Color                     VARCHAR(15),
    StandardCost              money,
    ListPrice                 money,
    [Size]                    VARCHAR(15),
    [Weight]                  decimal(8, 2),
    ProductCategoryID         INTEGER,
    ProductModelID            INTEGER,
    SellStartDate             DATE,
    SellEndDate               DATE,
    SourceName                VARCHAR(100),
    ParentProductCategoryID   INTEGER,
    ProductCategoryName       VARCHAR(50),
    ProductModelName          VARCHAR(50)
);

ALTER TABLE DimProduct ADD CONSTRAINT DimProduct_PK PRIMARY KEY ( ProductKey );

CREATE TABLE FactRental (
	RentalKey                 INTEGER NOT NULL identity(1,1),
    RentalID                  INTEGER,
	RentalDateKey           CHAR(8)  NULL,
    ReturnDateKey           CHAR(8)  NULL,
    PaymentID                 INTEGER ,
    Amount                    decimal(5,2),
    PaymentDateKey         CHAR(8)  NULL,
	CustomerKey               INTEGER  NULL,
	ProductKey             INTEGER NULL
   
);

ALTER TABLE FactRental ADD CONSTRAINT FactRental_PK PRIMARY KEY ( RentalKey );




CREATE TABLE FactSales (
    SalesKey                  INTEGER NOT NULL identity(1,1),
    SalesOrderID              INTEGER  NULL,
    SalesOrderDetailID        INTEGER  NULL,
    OrderQty                  SMALLINT,
    UnitPrice                money,
    UnitPriceDiscount        money,
    LineTotal                 numeric(38, 6),
	OrderDateKey        CHAR(8)  NULL,
    ShipDateKey        CHAR(8)  NULL,
    DueDateKey         CHAR(8)  NULL,
    SalesOrderNumber          NVARCHAR(25),
    PurchaseOrderNumber       VARCHAR(25),
    SubTotal                  money,
    TaxAmt                    money,
    Freight                  money,
    TotalDue                  money,
    CustomerKey   INTEGER  NULL,
    ProductKey     INTEGER  NULL,
    StatusKey           INTEGER NULL,
    RevisionNumberKey          INTEGER  NULL,
    ShipMethodKey         INTEGER  NULL,
    OnlineOrderFlagKey        INTEGER NULL
   
);

ALTER TABLE FactSales ADD CONSTRAINT FactSales_PK PRIMARY KEY ( SalesKey );


ALTER TABLE DimAddressDimCustomerLink
    ADD CONSTRAINT DimAddressDimCustomerLink_DimAddress_FK FOREIGN KEY (AddressKey )
        REFERENCES DimAddress (AddressKey );

ALTER TABLE DimAddressDimCustomerLink
    ADD CONSTRAINT DimAddressDimCustomerLink_DimCustomer_FK FOREIGN KEY (CustomerKey )
        REFERENCES DimCustomer (CustomerKey );

ALTER TABLE FactRental
    ADD CONSTRAINT FactRental_DimCustomer_FK FOREIGN KEY (CustomerKey )
        REFERENCES DimCustomer (CustomerKey );

ALTER TABLE FactRental
    ADD CONSTRAINT FactRental_DimDate_FK FOREIGN KEY (RentalDateKey)
        REFERENCES DimDate ( DateKey );

		
ALTER TABLE FactRental
    ADD CONSTRAINT FactRental_DimDate_FK2 FOREIGN KEY (ReturnDateKey)
        REFERENCES DimDate ( DateKey );

ALTER TABLE FactRental
    ADD CONSTRAINT FactRental_DimDate_FK3 FOREIGN KEY (PaymentDateKey )
        REFERENCES DimDate ( DateKey );



ALTER TABLE FactRental
    ADD CONSTRAINT FactRental_DimProduct_FK FOREIGN KEY (ProductKey )
        REFERENCES DimProduct (ProductKey );

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimCustomer_FK FOREIGN KEY (CustomerKey )
        REFERENCES DimCustomer (CustomerKey );


ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimDate_FK FOREIGN KEY (OrderDateKey )
        REFERENCES DimDate ( DateKey );

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimDate_FK2 FOREIGN KEY (ShipDateKey )
        REFERENCES DimDate ( DateKey );

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimDate_FK3 FOREIGN KEY (DueDateKey )
        REFERENCES DimDate ( DateKey );


		 
ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimJunk_FK FOREIGN KEY (StatusKey )
        REFERENCES DimJunk ( JunkKey );

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimJunk_FK1 FOREIGN KEY (RevisionNumberKey )
        REFERENCES DimJunk ( JunkKey );

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimJunk_FK2 FOREIGN KEY (ShipMethodKey )
        REFERENCES DimJunk ( JunkKey );

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimJunk_FK3 FOREIGN KEY (OnlineOrderFlagKey )
        REFERENCES DimJunk ( JunkKey );

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimProduct_FK FOREIGN KEY (ProductKey )
        REFERENCES DimProduct ( ProductKey );




COMMIT TRANSACTION;