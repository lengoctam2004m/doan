-- =============================================
-- Database: TechStoreDB
-- Description: Cơ sở dữ liệu cho website bán đồ công nghệ TechStore
-- Created: 2024
-- =============================================

-- Tạo database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TechStoreDB')
BEGIN
    CREATE DATABASE TechStoreDB;
END
GO

USE TechStoreDB;
GO

-- =============================================
-- Tạo bảng Categories (Danh mục sản phẩm)
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Categories' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Categories] (
        [CategoryId] [int] IDENTITY(1,1) NOT NULL,
        [Name] [nvarchar](100) NOT NULL,
        [Description] [nvarchar](500) NULL,
        [ImageUrl] [nvarchar](200) NULL,
        [IsActive] [bit] NOT NULL DEFAULT(1),
        [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
        CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryId] ASC)
    );
END
GO

-- =============================================
-- Tạo bảng Products (Sản phẩm)
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Products' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Products] (
        [ProductId] [int] IDENTITY(1,1) NOT NULL,
        [Name] [nvarchar](200) NOT NULL,
        [Description] [nvarchar](1000) NULL,
        [Price] [decimal](18,2) NOT NULL,
        [StockQuantity] [int] NOT NULL DEFAULT(0),
        [ImageUrl] [nvarchar](200) NULL,
        [CategoryId] [int] NOT NULL,
        [Brand] [nvarchar](100) NOT NULL,
        [SKU] [nvarchar](50) NULL,
        [IsActive] [bit] NOT NULL DEFAULT(1),
        [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
        [UpdatedDate] [datetime] NULL,
        CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductId] ASC)
    );
    
    -- Tạo foreign key constraint
    ALTER TABLE [dbo].[Products] 
    ADD CONSTRAINT [FK_Products_Categories] 
    FOREIGN KEY([CategoryId]) REFERENCES [dbo].[Categories] ([CategoryId]);
END
GO

-- =============================================
-- Tạo bảng Customers (Khách hàng)
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Customers' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Customers] (
        [CustomerId] [int] IDENTITY(1,1) NOT NULL,
        [FullName] [nvarchar](100) NOT NULL,
        [Email] [nvarchar](100) NOT NULL,
        [Phone] [nvarchar](20) NOT NULL,
        [Address] [nvarchar](200) NULL,
        [City] [nvarchar](100) NULL,
        [PostalCode] [nvarchar](10) NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
        [UpdatedDate] [datetime] NULL,
        CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
    );
END
GO

-- =============================================
-- Tạo bảng Orders (Đơn hàng)
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Orders' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Orders] (
        [OrderId] [int] IDENTITY(1,1) NOT NULL,
        [CustomerId] [int] NOT NULL,
        [OrderDate] [datetime] NOT NULL DEFAULT(GETDATE()),
        [Status] [int] NOT NULL DEFAULT(0),
        [TotalAmount] [decimal](18,2) NOT NULL,
        [Notes] [nvarchar](500) NULL,
        [ShippingAddress] [nvarchar](200) NULL,
        [ShippingCity] [nvarchar](100) NULL,
        [ShippingPostalCode] [nvarchar](10) NULL,
        [ShippedDate] [datetime] NULL,
        [DeliveredDate] [datetime] NULL,
        CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderId] ASC)
    );
    
    -- Tạo foreign key constraint
    ALTER TABLE [dbo].[Orders] 
    ADD CONSTRAINT [FK_Orders_Customers] 
    FOREIGN KEY([CustomerId]) REFERENCES [dbo].[Customers] ([CustomerId]);
END
GO

-- =============================================
-- Tạo bảng OrderDetails (Chi tiết đơn hàng)
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='OrderDetails' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[OrderDetails] (
        [OrderDetailId] [int] IDENTITY(1,1) NOT NULL,
        [OrderId] [int] NOT NULL,
        [ProductId] [int] NOT NULL,
        [Quantity] [int] NOT NULL,
        [UnitPrice] [decimal](18,2) NOT NULL,
        [TotalPrice] [decimal](18,2) NOT NULL,
        CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED ([OrderDetailId] ASC)
    );
    
    -- Tạo foreign key constraints
    ALTER TABLE [dbo].[OrderDetails] 
    ADD CONSTRAINT [FK_OrderDetails_Orders] 
    FOREIGN KEY([OrderId]) REFERENCES [dbo].[Orders] ([OrderId]) ON DELETE CASCADE;
    
    ALTER TABLE [dbo].[OrderDetails] 
    ADD CONSTRAINT [FK_OrderDetails_Products] 
    FOREIGN KEY([ProductId]) REFERENCES [dbo].[Products] ([ProductId]);
END
GO

-- =============================================
-- Tạo bảng AdminUsers (Tài khoản Admin)
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AdminUsers' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AdminUsers] (
        [AdminId] [int] IDENTITY(1,1) NOT NULL,
        [Username] [nvarchar](50) NOT NULL,
        [Password] [nvarchar](100) NOT NULL,
        [FullName] [nvarchar](100) NOT NULL,
        [Email] [nvarchar](100) NOT NULL,
        [IsActive] [bit] NOT NULL DEFAULT(1),
        [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
        [LastLoginDate] [datetime] NULL,
        [Role] [nvarchar](50) NOT NULL DEFAULT('Admin'),
        CONSTRAINT [PK_AdminUsers] PRIMARY KEY CLUSTERED ([AdminId] ASC)
    );
END
GO

-- =============================================
-- Tạo Indexes để tối ưu hiệu suất
-- =============================================

-- Index cho Products
CREATE NONCLUSTERED INDEX [IX_Products_CategoryId] ON [dbo].[Products] ([CategoryId]);
CREATE NONCLUSTERED INDEX [IX_Products_IsActive] ON [dbo].[Products] ([IsActive]);
CREATE NONCLUSTERED INDEX [IX_Products_Brand] ON [dbo].[Products] ([Brand]);

-- Index cho Orders
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerId] ON [dbo].[Orders] ([CustomerId]);
CREATE NONCLUSTERED INDEX [IX_Orders_OrderDate] ON [dbo].[Orders] ([OrderDate]);
CREATE NONCLUSTERED INDEX [IX_Orders_Status] ON [dbo].[Orders] ([Status]);

-- Index cho OrderDetails
CREATE NONCLUSTERED INDEX [IX_OrderDetails_OrderId] ON [dbo].[OrderDetails] ([OrderId]);
CREATE NONCLUSTERED INDEX [IX_OrderDetails_ProductId] ON [dbo].[OrderDetails] ([ProductId]);

-- Index cho Customers
CREATE NONCLUSTERED INDEX [IX_Customers_Email] ON [dbo].[Customers] ([Email]);

-- Index cho AdminUsers
CREATE NONCLUSTERED INDEX [IX_AdminUsers_Username] ON [dbo].[AdminUsers] ([Username]);

-- =============================================
-- Chèn dữ liệu mẫu
-- =============================================

-- Chèn Categories
IF NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Laptop')
BEGIN
    INSERT INTO Categories (Name, Description, IsActive) VALUES
    ('Laptop', 'Máy tính xách tay', 1),
    ('Smartphone', 'Điện thoại thông minh', 1),
    ('Tablet', 'Máy tính bảng', 1),
    ('Desktop', 'Máy tính để bàn', 1),
    ('Accessories', 'Phụ kiện công nghệ', 1);
END
GO

-- Chèn Products
IF NOT EXISTS (SELECT 1 FROM Products WHERE Name = 'MacBook Pro 16-inch M2')
BEGIN
    INSERT INTO Products (Name, Description, Price, StockQuantity, ImageUrl, CategoryId, Brand, SKU, IsActive) VALUES
    ('MacBook Pro 16-inch M2', 'MacBook Pro 16-inch với chip M2 mạnh mẽ, màn hình Liquid Retina XDR', 45990000, 10, '/Images/macbook-pro-16.jpg', 1, 'Apple', 'MBP16-M2-001', 1),
    ('iPhone 15 Pro Max', 'iPhone 15 Pro Max với chip A17 Pro, camera 48MP', 32990000, 25, '/Images/iphone-15-pro-max.jpg', 2, 'Apple', 'IP15PM-001', 1),
    ('Samsung Galaxy S24 Ultra', 'Galaxy S24 Ultra với S Pen, camera 200MP', 29990000, 20, '/Images/galaxy-s24-ultra.jpg', 2, 'Samsung', 'S24U-001', 1),
    ('iPad Pro 12.9-inch M2', 'iPad Pro 12.9-inch với chip M2, màn hình Liquid Retina XDR', 22990000, 15, '/Images/ipad-pro-12-9.jpg', 3, 'Apple', 'IPAD12-M2-001', 1),
    ('Dell XPS 13', 'Dell XPS 13 với Intel Core i7, màn hình 13.4 inch', 25990000, 8, '/Images/dell-xps-13.jpg', 1, 'Dell', 'XPS13-001', 1),
    ('AirPods Pro 2nd Gen', 'AirPods Pro thế hệ 2 với chip H2, chống ồi chủ động', 5990000, 50, '/Images/airpods-pro-2.jpg', 5, 'Apple', 'APP2-001', 1);
END
GO

-- Chèn AdminUsers
IF NOT EXISTS (SELECT 1 FROM AdminUsers WHERE Username = 'admin')
BEGIN
    INSERT INTO AdminUsers (Username, Password, FullName, Email, IsActive, Role) VALUES
    ('admin', 'YWRtaW4xMjNUZWNoU3RvcmVTYWx0', 'Administrator', 'admin@techstore.com', 1, 'SuperAdmin'),
    ('manager', 'bWFuYWdlcjEyM1RlY2hTdG9yZVNhbHQ=', 'Manager', 'manager@techstore.com', 1, 'Admin');
END
GO

-- Chèn Customers mẫu
IF NOT EXISTS (SELECT 1 FROM Customers WHERE Email = 'customer1@example.com')
BEGIN
    INSERT INTO Customers (FullName, Email, Phone, Address, City, PostalCode) VALUES
    ('Nguyễn Văn An', 'customer1@example.com', '0123456789', '123 Đường ABC, Quận 1', 'TP.HCM', '700000'),
    ('Trần Thị Bình', 'customer2@example.com', '0987654321', '456 Đường XYZ, Quận 2', 'TP.HCM', '700000'),
    ('Lê Văn Cường', 'customer3@example.com', '0369258147', '789 Đường DEF, Quận 3', 'TP.HCM', '700000');
END
GO

-- Chèn Orders mẫu
IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderId = 1)
BEGIN
    INSERT INTO Orders (CustomerId, OrderDate, Status, TotalAmount, Notes, ShippingAddress, ShippingCity) VALUES
    (1, '2024-01-15 10:30:00', 3, 45990000, 'Giao hàng nhanh', '123 Đường ABC, Quận 1', 'TP.HCM'),
    (2, '2024-01-16 14:20:00', 2, 32990000, 'Cẩn thận khi giao hàng', '456 Đường XYZ, Quận 2', 'TP.HCM'),
    (3, '2024-01-17 09:15:00', 1, 5990000, 'Giao trong giờ hành chính', '789 Đường DEF, Quận 3', 'TP.HCM');
END
GO

-- Chèn OrderDetails mẫu
IF NOT EXISTS (SELECT 1 FROM OrderDetails WHERE OrderDetailId = 1)
BEGIN
    INSERT INTO OrderDetails (OrderId, ProductId, Quantity, UnitPrice, TotalPrice) VALUES
    (1, 1, 1, 45990000, 45990000),
    (2, 2, 1, 32990000, 32990000),
    (3, 6, 1, 5990000, 5990000);
END
GO

-- =============================================
-- Tạo Stored Procedures
-- =============================================

-- Stored Procedure: GetProductStatistics
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetProductStatistics')
    DROP PROCEDURE GetProductStatistics;
GO

CREATE PROCEDURE GetProductStatistics
AS
BEGIN
    SELECT 
        p.ProductId,
        p.Name,
        p.Price,
        p.StockQuantity,
        ISNULL(SUM(od.Quantity), 0) as TotalSold,
        ISNULL(SUM(od.TotalPrice), 0) as TotalRevenue
    FROM Products p
    LEFT JOIN OrderDetails od ON p.ProductId = od.ProductId
    WHERE p.IsActive = 1
    GROUP BY p.ProductId, p.Name, p.Price, p.StockQuantity
    ORDER BY TotalSold DESC;
END
GO

-- Stored Procedure: GetOrderStatistics
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetOrderStatistics')
    DROP PROCEDURE GetOrderStatistics;
GO

CREATE PROCEDURE GetOrderStatistics
AS
BEGIN
    SELECT 
        Status,
        COUNT(*) as OrderCount,
        SUM(TotalAmount) as TotalAmount
    FROM Orders
    GROUP BY Status;
END
GO

-- Stored Procedure: GetMonthlyRevenue
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetMonthlyRevenue')
    DROP PROCEDURE GetMonthlyRevenue
GO

CREATE PROCEDURE GetMonthlyRevenue
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SELECT 
        YEAR(OrderDate) as Year,
        MONTH(OrderDate) as Month,
        COUNT(*) as OrderCount,
        SUM(TotalAmount) as TotalRevenue
    FROM Orders
    WHERE OrderDate BETWEEN @StartDate AND @EndDate
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
    ORDER BY Year, Month;
END
GO

-- =============================================
-- Tạo Views
-- =============================================

-- View: ProductSummary
IF EXISTS (SELECT * FROM sys.views WHERE name = 'ProductSummary')
    DROP VIEW ProductSummary;
GO

CREATE VIEW ProductSummary
AS
SELECT 
    p.ProductId,
    p.Name,
    p.Price,
    p.StockQuantity,
    c.Name as CategoryName,
    p.Brand,
    p.IsActive,
    ISNULL(SUM(od.Quantity), 0) as TotalSold,
    ISNULL(SUM(od.TotalPrice), 0) as TotalRevenue
FROM Products p
LEFT JOIN Categories c ON p.CategoryId = c.CategoryId
LEFT JOIN OrderDetails od ON p.ProductId = od.ProductId
GROUP BY p.ProductId, p.Name, p.Price, p.StockQuantity, c.Name, p.Brand, p.IsActive;
GO

-- View: OrderSummary
IF EXISTS (SELECT * FROM sys.views WHERE name = 'OrderSummary')
    DROP VIEW OrderSummary;
GO

CREATE VIEW OrderSummary
AS
SELECT 
    o.OrderId,
    o.OrderDate,
    o.Status,
    o.TotalAmount,
    c.FullName as CustomerName,
    c.Email as CustomerEmail,
    c.Phone as CustomerPhone,
    COUNT(od.OrderDetailId) as ItemCount
FROM Orders o
LEFT JOIN Customers c ON o.CustomerId = c.CustomerId
LEFT JOIN OrderDetails od ON o.OrderId = od.OrderId
GROUP BY o.OrderId, o.OrderDate, o.Status, o.TotalAmount, c.FullName, c.Email, c.Phone;
GO

-- =============================================
-- Tạo Triggers
-- =============================================

-- Trigger: UpdateProductStock
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'UpdateProductStock')
    DROP TRIGGER UpdateProductStock;
GO

CREATE TRIGGER UpdateProductStock
ON OrderDetails
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET StockQuantity = p.StockQuantity - i.Quantity
    FROM Products p
    INNER JOIN inserted i ON p.ProductId = i.ProductId
    WHERE p.StockQuantity >= i.Quantity;
END
GO

-- =============================================
-- Tạo Functions
-- =============================================

-- Function: GetOrderStatusText
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetOrderStatusText')
    DROP FUNCTION GetOrderStatusText;
GO

CREATE FUNCTION GetOrderStatusText(@Status INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @StatusText NVARCHAR(50);
    
    SET @StatusText = CASE @Status
        WHEN 0 THEN 'Chờ xử lý'
        WHEN 1 THEN 'Đang xử lý'
        WHEN 2 THEN 'Đã giao hàng'
        WHEN 3 THEN 'Đã nhận hàng'
        WHEN 4 THEN 'Đã hủy'
        ELSE 'Không xác định'
    END;
    
    RETURN @StatusText;
END
GO

-- =============================================
-- Hoàn thành
-- =============================================

PRINT '=============================================';
PRINT 'Database TechStoreDB đã được tạo thành công!';
PRINT '=============================================';
PRINT 'Thông tin database:';
PRINT '- Tên: TechStoreDB';
PRINT '- Bảng: 6 bảng chính';
PRINT '- Dữ liệu mẫu: Đã có sẵn';
PRINT '- Stored Procedures: 3 procedures';
PRINT '- Views: 2 views';
PRINT '- Triggers: 1 trigger';
PRINT '- Functions: 1 function';
PRINT '=============================================';
PRINT 'Tài khoản Admin mặc định:';
PRINT '- Username: admin, Password: admin123';
PRINT '- Username: manager, Password: manager123';
PRINT '=============================================';
