--use master;
--create database DWPrac2
--use DwPrac2


CREATE TABLE DimAddress (
    AddressSK       INTEGER NOT NULL,
    AddressID       INTEGER,
    AddressLine1    VARCHAR(60),
    AddressLine2    VARCHAR(60),
    City            VARCHAR(30),
    StateProvince   VARCHAR(50),
    CountryRegion   VARCHAR(50),
    PostalCode      VARCHAR(15)
);

ALTER TABLE DimAddress ADD CONSTRAINT DimAddress_PK PRIMARY KEY ( AddressSK );


CREATE TABLE DimCustomer (
    CustomerSK     INTEGER NOT NULL,
    CustomerID     INTEGER,
    Title          VARCHAR(8),
    FirstName      VARCHAR(50),
    MiddleName     VARCHAR(50),
    LastName       VARCHAR(50),
    Suffix         VARCHAR(10),
    CompanyName    VARCHAR(128),
    SalesPerson    VARCHAR(256),
    EmailAddress   VARCHAR(50),
    Phone          VARCHAR(25)
);

ALTER TABLE DimCustomer ADD CONSTRAINT DimCustomer_PK PRIMARY KEY ( CustomerSK );


CREATE TABLE DimDate (
    DimDateKey     CHAR(8) NOT NULL,
    "Date"         DATE,
    [Day]          DATE,
    Month          DATE,
    FirstOfMonth   DATE,
    MonthName      DATE,
    Week           DATE,
    ISOweek        DATE,
    DayName        DATE,
    DayOfWeek      DATE,
    Quarter        DATE,
    Year           DATE,
    FirstofYear    DATE
);

ALTER TABLE DimDate ADD CONSTRAINT DimDate_PK PRIMARY KEY ( DimDateKey );

CREATE TABLE DimJunk (
    JunkKey      INTEGER NOT NULL,
    NKey         INTEGER,
    Name         VARCHAR(200),
    Value        VARCHAR(200),
    SourceName   VARCHAR(100)
);

ALTER TABLE DimJunk ADD CONSTRAINT DimJunk_PK PRIMARY KEY ( JunkKey );

CREATE TABLE DimProduct (
    ProductSK           INTEGER NOT NULL,
    ProductID           INTEGER,
    ProductName         VARCHAR(50),
    ProductNumber       VARCHAR(25),
    Color               VARCHAR(15),
    StandardCost        money,
    ListPrice           money,
    "Size"              VARCHAR(15),
    Weight              NUmeric(8, 2),
    ProductCategoryID   INTEGER,
    ProductModelID      INTEGER,
    SellStartDate       DATE,
    SellEndDate         DATE
);

ALTER TABLE DimProduct ADD CONSTRAINT DimProduct_PK PRIMARY KEY ( ProductSK );


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
    LineTotal                NUMeric(38, 6),
    CustomerSK               INTEGER NOT NULL,
    ProductSK				 INTEGER NOT NULL,
    AddressSK				 INTEGER NOT NULL,
    DimDateKey				 CHAR(8) NOT NULL,
    JunkKey                  INTEGER NOT NULL,
);

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_PK PRIMARY KEY (    CustomerSK,
												 ProductSK,
												AddressSK,
                                                DimDateKey,
                                                JunkKey );


ALTER TABLE FactSales ADD CONSTRAINT FactSales_DimAddress_FK FOREIGN KEY ( AddressSK )
    REFERENCES DimAddress (AddressSK)
;

ALTER TABLE FactSales ADD CONSTRAINT FactSales_DimCustomer_FK FOREIGN KEY ( CustomerSK )
    REFERENCES DimCustomer (CustomerSK)

;

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimDate_FK FOREIGN KEY (DimDateKey )
        REFERENCES DimDate ( DimDateKey );

ALTER TABLE FactSales
    ADD CONSTRAINT FactSales_DimJunk_FK FOREIGN KEY (JunkKey )
        REFERENCES DimJunk ( JunkKey );

ALTER TABLE FactSales ADD CONSTRAINT FactSales_DimProduct_FK FOREIGN KEY ( ProductSK )
    REFERENCES DimProduct (ProductSK)

;



