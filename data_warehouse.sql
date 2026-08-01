CREATE DATABASE school;
USE school;

SELECT * FROM sales_dataset;

CREATE TABLE Fact_Sales (
    Sales_Key INT IDENTITY(1,1) PRIMARY KEY,
    Product_Key INT,
    Date_Key INT,
    SalesRep_Key INT,
    Region_Key INT,
    Customer_Key INT,
    Payment_Key INT,
    Channel_Key INT,

    Sales_Amount DECIMAL(10,2),
    Quantity_Sold INT,
    Unit_Cost DECIMAL(10,2),
    Unit_Price DECIMAL(10,2),
    Discount DECIMAL(5,2),

    FOREIGN KEY (Product_Key) REFERENCES Dim_Product(Product_Key),
    FOREIGN KEY (Date_Key) REFERENCES Dim_Date(Date_Key),
    FOREIGN KEY (SalesRep_Key) REFERENCES Dim_SalesRep(SalesRep_Key),
    FOREIGN KEY (Region_Key) REFERENCES Dim_Region(Region_Key),
    FOREIGN KEY (Customer_Key) REFERENCES Dim_Customer(Customer_Key),
    FOREIGN KEY (Payment_Key) REFERENCES Dim_Payment(Payment_Key),
    FOREIGN KEY (Channel_Key) REFERENCES Dim_Channel(Channel_Key)
);



CREATE TABLE Dim_Product (
    Product_Key INT IDENTITY(1,1) PRIMARY KEY,
    Product_ID INT,
    Product_Category VARCHAR(50)
);

CREATE TABLE Dim_Date (
    Date_Key INT PRIMARY KEY,
    Sale_Date DATE,
    Day INT,
    Month INT,
    Quarter INT,
    Year INT
);

CREATE TABLE Dim_SalesRep (
    SalesRep_Key INT IDENTITY(1,1) PRIMARY KEY,
    Sales_Rep VARCHAR(50)
);

CREATE TABLE Dim_Region (
    Region_Key INT IDENTITY(1,1) PRIMARY KEY,
    Region VARCHAR(50)
);

CREATE TABLE Dim_Customer (
    Customer_Key INT IDENTITY(1,1) PRIMARY KEY,
    Customer_Type VARCHAR(50)
);

CREATE TABLE Dim_Payment (
    Payment_Key INT IDENTITY(1,1) PRIMARY KEY,
    Payment_Method VARCHAR(50)
);

CREATE TABLE Dim_Channel (
    Channel_Key INT IDENTITY(1,1) PRIMARY KEY,
    Sales_Channel VARCHAR(50)
);

INSERT INTO Dim_Product (Product_ID, Product_Category)
SELECT DISTINCT Product_ID, Product_Category
FROM sales_dataset;

INSERT INTO Dim_Date
(Date_Key, Sale_Date, Day, Month, Quarter, Year)
SELECT DISTINCT
    CONVERT(INT, FORMAT(Sale_Date,'yyyyMMdd')),
    Sale_Date,
    DAY(Sale_Date),
    MONTH(Sale_Date),
    DATEPART(QUARTER, Sale_Date),
    YEAR(Sale_Date)
FROM sales_dataset;


INSERT INTO Dim_SalesRep (Sales_Rep)
SELECT DISTINCT Sales_Rep
FROM Sales_dataset;


INSERT INTO Dim_Region (Region)
SELECT DISTINCT Region
FROM Sales_dataset;

INSERT INTO Dim_Customer (Customer_Type)
SELECT DISTINCT Customer_Type
FROM Sales_dataset;

INSERT INTO Dim_Payment (Payment_Method)
SELECT DISTINCT Payment_Method
FROM Sales_dataset;

INSERT INTO Dim_Channel (Sales_Channel)
SELECT DISTINCT Sales_Channel
FROM Sales_dataset;

INSERT INTO Fact_Sales
(
    Product_Key,
    Date_Key,
    SalesRep_Key,
    Region_Key,
    Customer_Key,
    Payment_Key,
    Channel_Key,
    Sales_Amount,
    Quantity_Sold,
    Unit_Cost,
    Unit_Price,
    Discount
)
SELECT
    p.Product_Key,
    CONVERT(INT, FORMAT(s.Sale_Date,'yyyyMMdd')),
    sr.SalesRep_Key,
    r.Region_Key,
    c.Customer_Key,
    pm.Payment_Key,
    ch.Channel_Key,
    s.Sales_Amount,
    s.Quantity_Sold,
    s.Unit_Cost,
    s.Unit_Price,
    s.Discount
FROM Sales_dataset s
JOIN Dim_Product p
    ON s.Product_ID = p.Product_ID
JOIN Dim_SalesRep sr
    ON s.Sales_Rep = sr.Sales_Rep
JOIN Dim_Region r
    ON s.Region = r.Region
JOIN Dim_Customer c
    ON s.Customer_Type = c.Customer_Type
JOIN Dim_Payment pm
    ON s.Payment_Method = pm.Payment_Method
JOIN Dim_Channel ch
    ON s.Sales_Channel = ch.Sales_Channel;
