-- Создание базы данных и основных объектов

-- 1. Создание базы данных
CREATE DATABASE WebAppDB
CONTAINMENT = NONE
ON  PRIMARY 
( NAME = N'WebAppDB', FILENAME = N'WebAppDB.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
LOG ON 
( NAME = N'WebAppDB_log', FILENAME = N'WebAppDB_log.ldf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
WITH CATALOG_COLLATION = Latin1_General_CI_AS
GO

USE WebAppDB
GO

-- 2. Создание таблицы пользователей
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    RoleID INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
)
GO

-- 3. Создание таблицы ролей
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
)
GO

-- 4. Создание таблицы категорий
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
)
GO

-- 5. Создание таблицы товаров
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT NOT NULL,
    StockQuantity INT DEFAULT 0,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
)
GO

-- 6. Создание таблицы заказов
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(50),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
)
GO

-- 7. Создание таблицы позиций заказа
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
)
GO

-- 8. Создание индексов
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Products_Category ON Products(CategoryID);
CREATE INDEX IX_Orders_User ON Orders(UserID);
GO

-- 9. Создание последовательности
CREATE SEQUENCE UserSequence
    START WITH 1
    INCREMENT BY 1;
GO

-- 10. Создание триггера
CREATE TRIGGER trg_UpdateStock
ON OrderItems
AFTER INSERT
AS
BEGIN
    UPDATE Products
    SET StockQuantity = StockQuantity - i.Quantity
    FROM Products p
    INNER JOIN inserted i ON p.ProductID = i.ProductID;
END
GO

-- 11. Начальные данные
INSERT INTO Roles (RoleName) VALUES ('Admin');
INSERT INTO Roles (RoleName) VALUES ('User');

INSERT INTO Categories (CategoryName, Description) 
VALUES ('Электроника', 'Электронные устройства');
GO
