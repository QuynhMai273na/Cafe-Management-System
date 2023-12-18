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
	id INT PRIMARY KEY,
	name NVARCHAR(100),
	numPeople INT NOT NULL DEFAULT 4,
	status NVARCHAR(100) NOT NULL,
	location NVARCHAR(100) NOT NULL
	-- thêm chức năng đặt bàn, thêm màu sắc: red|green, giới hạn số người
)
GO

CREATE TABLE Account
(
	userName NVARCHAR(100) PRIMARY KEY,
	displayName NVARCHAR(100) NOT NULL,
	passWord NVARCHAR(1000) NOT NULL,
	accountType NVARCHAR(100) NOT NULL -- manager/ staff/ customer

)
GO

CREATE TABLE Category
(
	id INT PRIMARY KEY,
	name NVARCHAR(100)
)
GO

CREATE TABLE Food
( 
	id INT PRIMARY KEY,
	name NVARCHAR(100) NOT NULL,
	idCategory INT NOT NULL,
	price INT NOT NULL

	FOREIGN KEY (idCategory) REFERENCES dbo.Category(id)
)
GO

CREATE TABLE Bill
(
	id INT PRIMARY KEY,
	idTable INT NOT NULL,
	customer NVARCHAR(100),
	timePayment DATETIME NOT NULL,
	status INT NOT NULL DEFAULT 0 -- 1: đã thanh toán, 0: chưa thanh toán

	FOREIGN KEY (idTable) REFERENCES dbo.TableFood (id)
)
GO 

CREATE TABLE BillInfo
(
	id INT PRIMARY KEY,
	idBill INT NOT NULL,
	idFood INT NOT NULL,
	count INT NOT NULL DEFAULT 0
	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idFood) REFERENCES dbo.Food(id)

)
GO

CREATE PROC USP_Login
@userName NVARCHAR(100), @passWord NVARCHAR(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE userName = @userName AND passWord = @passWord
END 
GO

CREATE PROC USP_GetTableList
AS SELECT * FROM dbo.TableFood
GO

CREATE PROC USP_GetTableListByLocation
@location NVARCHAR(100)
AS
BEGIN 
	SELECT * FROM dbo.TableFood WHERE location = @location
END
GO


INSERT INTO Account
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=D:\Software Engineer-Nhập môn Công nghệ phần mềm\Cafe_Management_System\Excel data\CafeDatabase.xlsx;HDR=YES', 'SELECT * FROM [Account$]')
