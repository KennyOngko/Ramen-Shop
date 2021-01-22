--CREATE

--Create Database
CREATE DATABASE RamenShopBDDK

USE RamenShopBDDK

--Create Tables
CREATE TABLE RsCustomer(
	CustomerID CHAR(5) PRIMARY KEY CONSTRAINT checkCID CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(50) NOT NULL,
	CustomerDOB DATE NOT NULL,
	CustomerGender VARCHAR(6) NOT NULL CONSTRAINT checkCGender CHECK(CustomerGender LIKE 'Male' OR CustomerGender LIKE 'Female'),
	CustomerAddress VARCHAR(75) CONSTRAINT checkCAddress CHECK(CustomerAddress LIKE '%Street'),
	CustomerPhone VARCHAR(12)
)

CREATE TABLE RsRamen(
	RamenID CHAR(5) PRIMARY KEY CONSTRAINT checkRID CHECK(RamenID LIKE 'RA[0-9][0-9][0-9]'),
	RamenName VARCHAR(50) NOT NULL CONSTRAINT checkRName CHECK(RamenName LIKE '% %'),
	RamenPrice INT
)

CREATE TABLE RsIngredient(
	IngredientID CHAR(5) PRIMARY KEY CONSTRAINT checkIID CHECK(IngredientID LIKE 'RI[0-9][0-9][0-9]'),
	IngredientName VARCHAR(50) NOT NULL,
	IngredientStock INT
)

CREATE TABLE RecipeDetail(
	RamenID CHAR(5),
	IngredientID CHAR(5),
	IngQty INT,
	PRIMARY KEY(RamenID,IngredientID),
	FOREIGN KEY(RamenID) REFERENCES RsRamen(RamenID)
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(IngredientID) REFERENCES RsIngredient(IngredientID)
	ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE RsStaff(
	StaffID CHAR(5) PRIMARY KEY CONSTRAINT checkStID CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(50) NOT NULL,
	StaffDOB DATE NOT NULL,
	StaffGender VARCHAR(6) NOT NULL CONSTRAINT checkSGender CHECK(StaffGender LIKE 'Male' OR StaffGender LIKE 'Female'),
	StaffAddress VARCHAR(75) CONSTRAINT checkStAddress CHECK(StaffAddress LIKE '%Street'),
	StaffPhone VARCHAR(12),
	StaffSalary INT CONSTRAINT checkSalary CHECK(StaffSalary >= 1500000 AND StaffSalary <= 3500000)
)

CREATE TABLE SalesTransaction(
	SalesTransactionID CHAR(5) PRIMARY KEY CONSTRAINT checkSaID CHECK(SalesTransactionID LIKE 'SL[0-9][0-9][0-9]'),
	StaffID CHAR(5) FOREIGN KEY REFERENCES RsStaff(StaffID)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CustomerID CHAR(5) FOREIGN KEY REFERENCES RsCustomer(CustomerID)
	ON UPDATE CASCADE ON DELETE CASCADE,
	SalesTransactionDate DATE NOT NULL
)

CREATE TABLE SalesTransactionDetail(
	SalesTransactionID CHAR(5),
	RamenID CHAR(5),
	RamenQty INT,
	PRIMARY KEY(SalesTransactionID,RamenID),
	FOREIGN KEY(SalesTransactionID) REFERENCES SalesTransaction(SalesTransactionID)
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(RamenID) REFERENCES RsRamen(RamenID)
	ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE RsSupplier(
	SupplierID CHAR(5) PRIMARY KEY CONSTRAINT checkSuID CHECK(SupplierID LIKE 'SP[0-9][0-9][0-9]'),
	SupplierName VARCHAR(50) NOT NULL CONSTRAINT checkSName CHECK(LEN(SupplierName) BETWEEN 5 AND 50),
	SupplierAddress VARCHAR(75) CONSTRAINT checkSuAddress CHECK(SupplierAddress LIKE '%Street'),
	SupplierPhone VARCHAR(12) 
)

CREATE TABLE PurchaseTransaction(
	PurchaseTransactionID CHAR(5) PRIMARY KEY CONSTRAINT checkPID CHECK(PurchaseTransactionID LIKE 'PU[0-9][0-9][0-9]'),
	StaffID CHAR(5) FOREIGN KEY REFERENCES RsStaff(StaffID)
	ON UPDATE CASCADE ON DELETE CASCADE,
	SupplierID CHAR(5) FOREIGN KEY REFERENCES RsSupplier(SupplierID)
	ON UPDATE CASCADE ON DELETE CASCADE,
	PurchaseTransactionDate DATE NOT NULL
)

CREATE TABLE PurchaseTransactionDetail(
	PurchaseTransactionID CHAR(5),
	IngredientID CHAR(5),
	IngredientQty INT,
	PRIMARY KEY(PurchaseTransactionID,IngredientID),
	FOREIGN KEY(PurchaseTransactionID) REFERENCES PurchaseTransaction(PurchaseTransactionID)
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(IngredientID) REFERENCES RsIngredient(IngredientID)
	ON UPDATE CASCADE ON DELETE CASCADE
)