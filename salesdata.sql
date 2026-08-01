CREATE DATABASE salesDB;

USE salesDB;

SELECT * FROM sales_data;

----Dim_Date----
CREATE TABLE Dim_Date
(
    Date_Key INT IDENTITY(1,1) PRIMARY KEY,
    Sale_Date DATE,
    Day_No INT,
    Month_No INT,
    Month_Name VARCHAR(20),
    Quarter_No INT,
    Year_No INT
);

INSERT INTO Dim_Date
(Sale_Date, Day_No, Month_No, Month_Name, Quarter_No, Year_No)
SELECT DISTINCT
    Sale_Date,
    DAY(Sale_Date),
    MONTH(Sale_Date),
    DATENAME(MONTH, Sale_Date),
    DATEPART(QUARTER, Sale_Date),
    YEAR(Sale_Date)
FROM sales_data;

---- Dim_Product ----
CREATE TABLE Dim_Product
(
    Product_Key INT IDENTITY(1,1) PRIMARY KEY,
    Product_ID INT,
    Product_Category VARCHAR(50)
);

INSERT INTO Dim_Product(Product_ID, Product_Category)
SELECT DISTINCT
    Product_ID,
    Product_Category
FROM sales_data;

---- Dim_SalesRep ----
CREATE TABLE Dim_SalesRep
(
    SalesRep_Key INT IDENTITY(1,1) PRIMARY KEY,
    Sales_Rep VARCHAR(50),
    Region VARCHAR(30)
);

INSERT INTO Dim_SalesRep(Sales_Rep, Region)
SELECT DISTINCT
    Sales_Rep,
    Region
FROM sales_data;

---- Dim_Customer ----
CREATE TABLE Dim_Customer
(
    Customer_Key INT IDENTITY(1,1) PRIMARY KEY,
    Customer_Type VARCHAR(30)
);

INSERT INTO Dim_Customer(Customer_Type)
SELECT DISTINCT Customer_Type
FROM sales_data;

---- Dim_Payment ----
CREATE TABLE Dim_Payment
(
    Payment_Key INT IDENTITY(1,1) PRIMARY KEY,
    Payment_Method VARCHAR(50)
);

INSERT INTO Dim_Payment(Payment_Method)
SELECT DISTINCT Payment_Method
FROM sales_data;

---- Dim_Channel ----
CREATE TABLE Dim_Channel
(
    Channel_Key INT IDENTITY(1,1) PRIMARY KEY,
    Sales_Channel VARCHAR(30)
);

INSERT INTO Dim_Channel(Sales_Channel)
SELECT DISTINCT Sales_Channel
FROM sales_data;

---- Fact_Table ----
CREATE TABLE Fact_Sales
(
    Sales_Key INT IDENTITY(1,1) PRIMARY KEY,

    Date_Key INT,
    Product_Key INT,
    SalesRep_Key INT,
    Customer_Key INT,
    Payment_Key INT,
    Channel_Key INT,

    Sales_Amount DECIMAL(18,2),
    Quantity_Sold INT,
    Unit_Cost DECIMAL(18,2),
    Unit_Price DECIMAL(18,2),
    Discount DECIMAL(5,2),

    FOREIGN KEY (Date_Key) REFERENCES Dim_Date(Date_Key),
    FOREIGN KEY (Product_Key) REFERENCES Dim_Product(Product_Key),
    FOREIGN KEY (SalesRep_Key) REFERENCES Dim_SalesRep(SalesRep_Key),
    FOREIGN KEY (Customer_Key) REFERENCES Dim_Customer(Customer_Key),
    FOREIGN KEY (Payment_Key) REFERENCES Dim_Payment(Payment_Key),
    FOREIGN KEY (Channel_Key) REFERENCES Dim_Channel(Channel_Key)
);

---- Load Fact Table ----
INSERT INTO Fact_Sales
(
    Date_Key,
    Product_Key,
    SalesRep_Key,
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
    d.Date_Key,
    p.Product_Key,
    s.SalesRep_Key,
    c.Customer_Key,
    pm.Payment_Key,
    ch.Channel_Key,
    sd.Sales_Amount,
    sd.Quantity_Sold,
    sd.Unit_Cost,
    sd.Unit_Price,
    sd.Discount

FROM sales_data sd

JOIN Dim_Date d
ON sd.Sale_Date = d.Sale_Date

JOIN Dim_Product p
ON sd.Product_ID = p.Product_ID
AND sd.Product_Category = p.Product_Category

JOIN Dim_SalesRep s
ON sd.Sales_Rep = s.Sales_Rep
AND sd.Region = s.Region

JOIN Dim_Customer c
ON sd.Customer_Type = c.Customer_Type

JOIN Dim_Payment pm
ON sd.Payment_Method = pm.Payment_Method

JOIN Dim_Channel ch
ON sd.Sales_Channel = ch.Sales_Channel;







