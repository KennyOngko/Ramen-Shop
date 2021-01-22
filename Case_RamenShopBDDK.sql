--CASE
USE RamenShopBDDK
 
--Cases are answered with query in number order
--1
SELECT RD.RamenID, RamenName, 
	[Total Ingredient] = CAST(COUNT(RD.IngredientID) AS VARCHAR) + ' Ingredients'
FROM RecipeDetail RD
JOIN RsRamen RR ON RR.RamenID = RD.RamenID
JOIN RsIngredient RI ON RI.IngredientID = RD.IngredientID
WHERE IngredientStock < 25
GROUP BY RD.RamenID, RamenName
HAVING COUNT(RD.IngredientID) > 1

--2
SELECT
	[Number of Sales] = COUNT(STD.SalesTransactionID),
	CustomerName,
	[Gender] = LEFT(CustomerGender,1),
	StaffName
FROM SalesTransactionDetail STD
JOIN SalesTransaction ST ON ST.SalesTransactionID = STD.SalesTransactionID
JOIN RsCustomer RC ON RC.CustomerID = ST.CustomerID
JOIN RsStaff RS ON RS.StaffID = ST.StaffID
WHERE StaffGender LIKE 'Female' AND DATEDIFF(YEAR,StaffDOB,CustomerDOB) > 5
GROUP BY STD.SalesTransactionID, CustomerName, StaffName, CustomerGender
ORDER BY CustomerName

--3
SELECT
	[Purchase Date] = CONVERT(VARCHAR,PurchaseTransactionDate,103),
	StaffName, SupplierName,
	[Total Ingredient] = COUNT(PTD.IngredientID),
	[Total Quantity] = SUM(IngredientQty)
FROM PurchaseTransaction PT
JOIN PurchaseTransactionDetail PTD ON PTD.PurchaseTransactionID = PT.PurchaseTransactionID
JOIN RsStaff RS ON RS.StaffID = PT.StaffID
JOIN RsSupplier RSU ON RSU.SupplierID = PT.SupplierID
WHERE YEAR(PurchaseTransactionDate) = 2016 AND LEN(SupplierName) < 15
GROUP BY PurchaseTransactionDate, StaffName, SupplierName

--4
SELECT CustomerName, CustomerPhone,
	[Sales Day] = DATENAME(WEEKDAY,SalesTransactionDate),
	[Variant Ramen Sold] = COUNT(STD.RamenID)
FROM SalesTransactionDetail STD
JOIN SalesTransaction ST ON ST.SalesTransactionID = STD.SalesTransactionID
JOIN RsCustomer RC ON RC.CustomerID = ST.CustomerID
WHERE MONTH(SalesTransactionDate) = 3
GROUP BY DATENAME(WEEKDAY,SalesTransactionDate), CustomerName, CustomerPhone
HAVING SUM(RamenQty) > 10

--5
SELECT 
	[PurchaseID] = PTD.PurchaseTransactionID,
	[RamenIngredientName] = IngredientName,
	[Quantity] = IngredientQty,
	StaffName,
	[Staff Phone] = REPLACE(StaffPhone,'0','+62'),
	[Staff Salary] = 'Rp. ' + CAST(StaffSalary AS VARCHAR)
FROM PurchaseTransactionDetail PTD
JOIN PurchaseTransaction PT ON PT.PurchaseTransactionID = PTD.PurchaseTransactionID
JOIN RsIngredient RI ON RI.IngredientID = PTD.IngredientID
JOIN RsStaff RS ON RS.StaffID = PT.StaffID
WHERE YEAR(PurchaseTransactionDate) = 2017
AND StaffSalary > (
	SELECT AVG(StaffSalary) AS SS
	FROM RsStaff
)
ORDER BY PTD.PurchaseTransactionID ASC

--6
SELECT
	[Staff ID] = REPLACE(RS.StaffID,'ST','Staff'),
	StaffName,
	[Sales Date] = CONVERT(VARCHAR,SalesTransactionDate,107),
	[Quantity] = SUM(RamenQty)
FROM SalesTransactionDetail STD
JOIN SalesTransaction ST ON ST.SalesTransactionID = STD.SalesTransactionID
JOIN RsStaff RS ON RS.StaffID = ST.StaffID
WHERE LEN(StaffName) >=3 
AND StaffSalary < (
	SELECT AVG(StaffSalary) AS SS 
	FROM RsStaff
)
GROUP BY STD.SalesTransactionID, RS.StaffID, StaffName, SalesTransactionDate

--7
SELECT
	[Total Ramen Sold] = SUM(RamenQty),
	[Customer Last Name] = SUBSTRING(CustomerName,CHARINDEX(' ',CustomerName)+1,LEN(CustomerName)),
	StaffName,
	[SalesDate] = SalesTransactionDate
FROM SalesTransactionDetail STD
JOIN SalesTransaction ST ON ST.SalesTransactionID = STD.SalesTransactionID
JOIN RsCustomer RC ON RC.CustomerID = ST.CustomerID
JOIN RsStaff RS ON RS.StaffID = ST.StaffID
WHERE LEN(CustomerName) > 15
AND RamenQty < (
	SELECT AVG(RamenQty) AS RQ
	FROM SalesTransactionDetail
)
GROUP BY STD.SalesTransactionID, CustomerName, StaffName, SalesTransactionDate

--8
SELECT
	[SalesID] = STD.SalesTransactionID,
	CustomerName,
	[Gender] = LEFT(CustomerGender,1),
	[Ramen Name] = RamenName,
	[Total Price] = CAST(RamenQty*RamenPrice AS VARCHAR) + ' IDR'
FROM SalesTransactionDetail STD
JOIN SalesTransaction ST ON ST.SalesTransactionID = STD.SalesTransactionID
JOIN RsCustomer RC ON RC.CustomerID = ST.CustomerID
JOIN RsRamen RR ON RR.RamenID = STD.RamenID
WHERE DATEDIFF(YEAR,CustomerDOB,GETDATE()) < 17
AND RamenPrice > (
	SELECT MIN(RamenPrice) AS RP
	FROM RsRamen
)
ORDER BY STD.SalesTransactionID ASC

--9
CREATE VIEW ViewSales AS(
	SELECT CustomerName,
		[Number of Sales] = COUNT(STD.SalesTransactionID),
		[Total Price] = SUM(RamenPrice*RamenQty)
		FROM SalesTransactionDetail STD
	JOIN SalesTransaction ST ON ST.SalesTransactionID = STD.SalesTransactionID
	JOIN RsCustomer RC ON RC.CustomerID = ST.CustomerID
	JOIN RsRamen RR ON RR.RamenID = STD.RamenID
	WHERE YEAR(SalesTransactionDate) < 2017 
	AND ST.CustomerID IN(
		SELECT CustomerID FROM RsCustomer
		WHERE CustomerAddress LIKE 'Pasar%'
	)
	GROUP BY CustomerName
)

--10
CREATE VIEW PurchaseDetail AS(
	SELECT 
		[Number of Item Purchased] = CAST(SUM(IngredientQty) AS VARCHAR) + ' Pcs',
		[Number of Transaction] = COUNT(PTD.PurchaseTransactionID),
		SupplierName, StaffName
	FROM PurchaseTransaction PT
	JOIN PurchaseTransactionDetail PTD ON PTD.PurchaseTransactionID = PT.PurchaseTransactionID
	JOIN RsSupplier RSU ON RSU.SupplierID = PT.SupplierID
	JOIN RsStaff RS ON RS.StaffID = PT.StaffID
	WHERE YEAR(PurchaseTransactionDate) = 2016 AND StaffGender LIKE 'Male'
	GROUP BY StaffName, SupplierName
)