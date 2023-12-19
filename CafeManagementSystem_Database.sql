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

EXEC sp_RENAME 'Bill.timePayment', 'datePayment', 'COLUMN';
ALTER TABLE Bill
ALTER COLUMN datePayment DATE;
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
CREATE TABLE Cutomer
(
	phoneNumber NVARCHAR(100) PRIMARY KEY,
	name NVARCHAR(100) NOT NULL,
	dateOfBirth DATE ,
	level NVARCHAR(100) DEFAULT 'Member'
)
GO

ALTER TABLE Bill
ADD FOREIGN KEY (customer) REFERENCES dbo.Customer(phoneNumber)

CREATE PROC USP_Login -- lấy ds account
@userName NVARCHAR(100), @passWord NVARCHAR(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE userName = @userName AND passWord = @passWord
END 
GO

CREATE PROC USP_GetTableList -- lấy ds bàn
AS SELECT * FROM dbo.TableFood
GO

CREATE PROC USP_GetTableListByLocation -- lọc ds bàn theo vị trí
@location NVARCHAR(100)
AS
BEGIN 
	SELECT * FROM dbo.TableFood WHERE location = @location
END
GO


INSERT INTO Account
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=D:\Software Engineer-Nhập môn Công nghệ phần mềm\Cafe_Management_System\Excel data\CafeDatabase.xlsx;HDR=YES', 'SELECT * FROM [Account$]')
GO

INSERT INTO TableFood
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=D:\Software Engineer-Nhập môn Công nghệ phần mềm\Cafe_Management_System\Excel data\Tablefood.xlsx;HDR=YES', 'SELECT * FROM [TableFood$]')
GO

INSERT INTO Category
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=D:\Software Engineer-Nhập môn Công nghệ phần mềm\Cafe_Management_System\Excel data\CafeDatabase.xlsx;HDR=YES', 'SELECT * FROM [Category$]')
GO

INSERT INTO Customer
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=D:\Software Engineer-Nhập môn Công nghệ phần mềm\Cafe_Management_System\Excel data\CafeDatabase.xlsx;HDR=YES', 'SELECT * FROM [Customer$]')
GO

INSERT INTO Food
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=D:\Software Engineer-Nhập môn Công nghệ phần mềm\Cafe_Management_System\Excel data\Food.xlsx;HDR=YES', 'SELECT * FROM [Food$]')
GO

-- thêm bill demo
INSERT dbo.Bill
		(id, idTable, customer, datePayment, status)
VALUES (1, 1, '0865308367', GETDATE(), 0)

INSERT dbo.Bill
		(id, idTable, customer, datePayment, status)
VALUES (2, 2, '0872436824', GETDATE(), 0)

INSERT dbo.BillInfo
		(id, idBill, idFood, count)
VALUES (1, 1, 1004, 2)

INSERT dbo.BillInfo
		(id, idBill, idFood, count)
VALUES (2, 1, 1003, 1)

INSERT dbo.BillInfo
		(id, idBill, idFood, count)
VALUES (3, 2, 1001, 5)
GO

SELECT * FROM dbo.Bill
SELECT * FROM dbo.BillInfo
SELECT * FROM dbo.Food
SELECT * FROM dbo.Category