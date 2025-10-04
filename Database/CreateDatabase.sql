-- =============================================
-- Script tạo database đơn giản cho TechStore
-- Chạy file này để tạo database nhanh chóng
-- =============================================

-- Tạo database
CREATE DATABASE TechStoreDB;
GO

USE TechStoreDB;
GO

-- Tạo bảng Categories
CREATE TABLE Categories (
    CategoryId int IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Description nvarchar(500) NULL,
    ImageUrl nvarchar(200) NULL,
    IsActive bit NOT NULL DEFAULT(1),
    CreatedDate datetime NOT NULL DEFAULT(GETDATE())
);

-- Tạo bảng Products
CREATE TABLE Products (
    ProductId int IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(200) NOT NULL,
    Description nvarchar(1000) NULL,
    Price decimal(18,2) NOT NULL,
    StockQuantity int NOT NULL DEFAULT(0),
    ImageUrl nvarchar(200) NULL,
    CategoryId int NOT NULL,
    Brand nvarchar(100) NOT NULL,
    SKU nvarchar(50) NULL,
    IsActive bit NOT NULL DEFAULT(1),
    CreatedDate datetime NOT NULL DEFAULT(GETDATE()),
    UpdatedDate datetime NULL,
    FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);

-- Tạo bảng Customers
CREATE TABLE Customers (
    CustomerId int IDENTITY(1,1) PRIMARY KEY,
    FullName nvarchar(100) NOT NULL,
    Email nvarchar(100) NOT NULL,
    Phone nvarchar(20) NOT NULL,
    Address nvarchar(200) NULL,
    City nvarchar(100) NULL,
    PostalCode nvarchar(10) NULL,
    CreatedDate datetime NOT NULL DEFAULT(GETDATE()),
    UpdatedDate datetime NULL
);

-- Tạo bảng Orders
CREATE TABLE Orders (
    OrderId int IDENTITY(1,1) PRIMARY KEY,
    CustomerId int NOT NULL,
    OrderDate datetime NOT NULL DEFAULT(GETDATE()),
    Status int NOT NULL DEFAULT(0),
    TotalAmount decimal(18,2) NOT NULL,
    Notes nvarchar(500) NULL,
    ShippingAddress nvarchar(200) NULL,
    ShippingCity nvarchar(100) NULL,
    ShippingPostalCode nvarchar(10) NULL,
    ShippedDate datetime NULL,
    DeliveredDate datetime NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

-- Tạo bảng OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailId int IDENTITY(1,1) PRIMARY KEY,
    OrderId int NOT NULL,
    ProductId int NOT NULL,
    Quantity int NOT NULL,
    UnitPrice decimal(18,2) NOT NULL,
    TotalPrice decimal(18,2) NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);

-- Tạo bảng AdminUsers
CREATE TABLE AdminUsers (
    AdminId int IDENTITY(1,1) PRIMARY KEY,
    Username nvarchar(50) NOT NULL,
    Password nvarchar(100) NOT NULL,
    FullName nvarchar(100) NOT NULL,
    Email nvarchar(100) NOT NULL,
    IsActive bit NOT NULL DEFAULT(1),
    CreatedDate datetime NOT NULL DEFAULT(GETDATE()),
    LastLoginDate datetime NULL,
    Role nvarchar(50) NOT NULL DEFAULT('Admin')
);

-- Chèn dữ liệu mẫu
INSERT INTO Categories (Name, Description, IsActive) VALUES
('Laptop', 'Máy tính xách tay', 1),
('Smartphone', 'Điện thoại thông minh', 1),
('Tablet', 'Máy tính bảng', 1),
('Desktop', 'Máy tính để bàn', 1),
('Accessories', 'Phụ kiện công nghệ', 1);

INSERT INTO Products (Name, Description, Price, StockQuantity, ImageUrl, CategoryId, Brand, SKU, IsActive) VALUES
('MacBook Pro 16-inch M2', 'MacBook Pro 16-inch với chip M2 mạnh mẽ, màn hình Liquid Retina XDR', 45990000, 10, '/Images/macbook-pro-16.jpg', 1, 'Apple', 'MBP16-M2-001', 1),
('iPhone 15 Pro Max', 'iPhone 15 Pro Max với chip A17 Pro, camera 48MP', 32990000, 25, '/Images/iphone-15-pro-max.jpg', 2, 'Apple', 'IP15PM-001', 1),
('Samsung Galaxy S24 Ultra', 'Galaxy S24 Ultra với S Pen, camera 200MP', 29990000, 20, '/Images/galaxy-s24-ultra.jpg', 2, 'Samsung', 'S24U-001', 1),
('iPad Pro 12.9-inch M2', 'iPad Pro 12.9-inch với chip M2, màn hình Liquid Retina XDR', 22990000, 15, '/Images/ipad-pro-12-9.jpg', 3, 'Apple', 'IPAD12-M2-001', 1),
('Dell XPS 13', 'Dell XPS 13 với Intel Core i7, màn hình 13.4 inch', 25990000, 8, '/Images/dell-xps-13.jpg', 1, 'Dell', 'XPS13-001', 1),
('AirPods Pro 2nd Gen', 'AirPods Pro thế hệ 2 với chip H2, chống ồi chủ động', 5990000, 50, '/Images/airpods-pro-2.jpg', 5, 'Apple', 'APP2-001', 1);

INSERT INTO AdminUsers (Username, Password, FullName, Email, IsActive, Role) VALUES
('admin', 'YWRtaW4xMjNUZWNoU3RvcmVTYWx0', 'Administrator', 'admin@techstore.com', 1, 'SuperAdmin'),
('manager', 'bWFuYWdlcjEyM1RlY2hTdG9yZVNhbHQ=', 'Manager', 'manager@techstore.com', 1, 'Admin');

INSERT INTO Customers (FullName, Email, Phone, Address, City, PostalCode) VALUES
('Nguyễn Văn An', 'customer1@example.com', '0123456789', '123 Đường ABC, Quận 1', 'TP.HCM', '700000'),
('Trần Thị Bình', 'customer2@example.com', '0987654321', '456 Đường XYZ, Quận 2', 'TP.HCM', '700000'),
('Lê Văn Cường', 'customer3@example.com', '0369258147', '789 Đường DEF, Quận 3', 'TP.HCM', '700000');

INSERT INTO Orders (CustomerId, OrderDate, Status, TotalAmount, Notes, ShippingAddress, ShippingCity) VALUES
(1, '2024-01-15 10:30:00', 3, 45990000, 'Giao hàng nhanh', '123 Đường ABC, Quận 1', 'TP.HCM'),
(2, '2024-01-16 14:20:00', 2, 32990000, 'Cẩn thận khi giao hàng', '456 Đường XYZ, Quận 2', 'TP.HCM'),
(3, '2024-01-17 09:15:00', 1, 5990000, 'Giao trong giờ hành chính', '789 Đường DEF, Quận 3', 'TP.HCM');

INSERT INTO OrderDetails (OrderId, ProductId, Quantity, UnitPrice, TotalPrice) VALUES
(1, 1, 1, 45990000, 45990000),
(2, 2, 1, 32990000, 32990000),
(3, 6, 1, 5990000, 5990000);

PRINT 'Database TechStoreDB đã được tạo thành công!';
PRINT 'Tài khoản Admin: admin/admin123 hoặc manager/manager123';
