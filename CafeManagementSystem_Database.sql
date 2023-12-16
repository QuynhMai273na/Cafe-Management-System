CREATE DATABASE CafeManagement
GO

USE CafeManagement
GO

--Food
--category
--staff
--customer
--Table
--account
--bill
--billInfo

CREATE TABLE TableFood
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100),
	status NVARCHAR(100),
	color NVARCHAR(100)
	-- thêm chức năng đặt bàn, thêm màu sắc: red|green, giới hạn số người
)
GO

CREATE TABLE Account
(
	userName NVARCHAR(100) PRIMARY KEY,
	passWord NVARCHAR(1000) NOT NULL,
	accountType NVARCHAR(100) NOT NULL -- manager/ staff/ customer

)
GO

CREATE TABLE Category
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100)
)
GO

CREATE TABLE Food
( 
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL,
	idCategory INT NOT NULL,
	price INT NOT NULL

	FOREIGN KEY (idCategory) REFERENCES dbo.Category(id)
)
GO

CREATE TABLE bill
(
	id INT IDENTITY PRIMARY KEY,
	idTable INT NOT NULL,
	customer NVARCHAR(100),
	timePayment DATETIME NOT NULL,
	status INT NOT NULL DEFAULT 0 -- 1: đã thanh toán, 0: chưa thanh toán

	FOREIGN KEY (idTable) REFERENCES dbo.TableFood (id)
)
GO 

CREATE TABLE billInfo
(
	id INT IDENTITY PRIMARY KEY,
	idBill INT NOT NULL,
	idFood INT NOT NULL,
	count INT NOT NULL DEFAULT 0
	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idFood) REFERENCES dbo.Food(id)

)
GO