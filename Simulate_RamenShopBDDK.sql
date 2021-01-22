--SIMULATE
USE RamenShopBDDK

--SalesTransaction
--There is a new customer [CU014] who buys 5 Hakodate Ramen(s) [RA010] which the transaction was handled by Roberto Hans [ST005] on 21 March 2019
GO
INSERT INTO RsCustomer 
VALUES	('CU014','Ryan Reynolds','2002-02-22','Male','Pool Street','089583214361')

GO
INSERT INTO SalesTransaction
VALUES	('SL021','ST005','CU014','2019-03-21')

GO
INSERT INTO SalesTransactionDetail
VALUES	('SL021','RA010',5)

--Stock of Hakodate Ramen ingredients updated
BEGIN TRAN
GO
UPDATE RsIngredient
SET IngredientStock = IngredientStock - 1
WHERE IngredientID = 'RI001'

GO
UPDATE RsIngredient
SET IngredientStock = IngredientStock - 5
WHERE IngredientID = 'RI003'

GO
UPDATE RsIngredient
SET IngredientStock = IngredientStock - 3
WHERE IngredientID = 'RI005'

GO
UPDATE RsIngredient
SET IngredientStock = IngredientStock - 1
WHERE IngredientID = 'RI009'

GO
UPDATE RsIngredient
SET IngredientStock = IngredientStock - 1
WHERE IngredientID = 'RI010'
ROLLBACK

--PurchaseTransaction
--Supply 11 Pork(s) [RI002] from Purwo Kamto [SP008] which the transaction was handled by Pricillia Effendi [ST007] on 20 July 2019
GO
INSERT INTO PurchaseTransaction
VALUES	('PU021','ST007','SP008','2019-07-20')

GO
INSERT INTO PurchaseTransactionDetail
VALUES	('PU021','RI002',11)

--Stock of Pork updated
BEGIN TRAN
GO
UPDATE RsIngredient
SET IngredientStock = IngredientStock + 11
WHERE IngredientID = 'RI002'
ROLLBACK