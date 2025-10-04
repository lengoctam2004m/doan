# 📊 Cơ sở dữ liệu TechStore

## 📁 Các file database

### 1. **TechStoreDB.sql** - Database đầy đủ
- ✅ Tạo database hoàn chỉnh với tất cả tính năng
- ✅ Bao gồm Stored Procedures, Views, Triggers, Functions
- ✅ Indexes tối ưu hiệu suất
- ✅ Dữ liệu mẫu đầy đủ
- 📏 **Kích thước**: ~15KB

### 2. **CreateDatabase.sql** - Database đơn giản
- ✅ Tạo database cơ bản nhanh chóng
- ✅ Chỉ có các bảng chính và dữ liệu mẫu
- ✅ Phù hợp cho việc test và demo
- 📏 **Kích thước**: ~5KB

## 🚀 Cách sử dụng

### **Phương pháp 1: Sử dụng SQL Server Management Studio (SSMS)**

1. **Mở SQL Server Management Studio**
2. **Kết nối đến SQL Server** (LocalDB, Express, hoặc Full)
3. **Mở file `TechStoreDB.sql`** hoặc `CreateDatabase.sql`
4. **Chạy script** (F5 hoặc Execute)
5. **Kiểm tra database** đã được tạo thành công

### **Phương pháp 2: Sử dụng Visual Studio**

1. **Mở Visual Studio**
2. **View → SQL Server Object Explorer**
3. **Chuột phải vào SQL Server → New Query**
4. **Copy nội dung file SQL** và paste vào
5. **Execute** để chạy

### **Phương pháp 3: Sử dụng Command Line**

```bash
# Sử dụng sqlcmd
sqlcmd -S . -E -i "TechStoreDB.sql"

# Hoặc sử dụng sqlcmd với LocalDB
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -i "TechStoreDB.sql"
```

## 📋 Cấu trúc Database

### **Bảng chính:**
- 🏷️ **Categories** - Danh mục sản phẩm
- 🛍️ **Products** - Sản phẩm
- 👥 **Customers** - Khách hàng
- 📦 **Orders** - Đơn hàng
- 📋 **OrderDetails** - Chi tiết đơn hàng
- 👨‍💼 **AdminUsers** - Tài khoản admin

### **Dữ liệu mẫu có sẵn:**
- ✅ **5 danh mục**: Laptop, Smartphone, Tablet, Desktop, Accessories
- ✅ **6 sản phẩm**: MacBook Pro, iPhone 15 Pro Max, Galaxy S24 Ultra, iPad Pro, Dell XPS 13, AirPods Pro
- ✅ **3 khách hàng**: Dữ liệu khách hàng mẫu
- ✅ **3 đơn hàng**: Đơn hàng mẫu với chi tiết
- ✅ **2 tài khoản admin**: admin/admin123, manager/manager123

## 🔧 Cấu hình Connection String

Sau khi tạo database, cập nhật connection string trong `Web.config`:

```xml
<connectionStrings>
  <add name="DefaultConnection" 
       connectionString="Data Source=.;Initial Catalog=TechStoreDB;Integrated Security=True;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False" 
       providerName="System.Data.SqlClient" />
</connectionStrings>
```

### **Các loại connection string khác:**

#### **SQL Server LocalDB:**
```xml
<add name="DefaultConnection" 
     connectionString="Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\TechStoreDB.mdf;Integrated Security=True;Connect Timeout=30" 
     providerName="System.Data.SqlClient" />
```

#### **SQL Server Express:**
```xml
<add name="DefaultConnection" 
     connectionString="Data Source=.\SQLEXPRESS;Initial Catalog=TechStoreDB;Integrated Security=True;Connect Timeout=30" 
     providerName="System.Data.SqlClient" />
```

#### **SQL Server với Username/Password:**
```xml
<add name="DefaultConnection" 
     connectionString="Data Source=YOUR_SERVER;Initial Catalog=TechStoreDB;User Id=YOUR_USERNAME;Password=YOUR_PASSWORD;Connect Timeout=30;Encrypt=True;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False" 
     providerName="System.Data.SqlClient" />
```

## 🎯 Tính năng Database

### **Stored Procedures:**
- `GetProductStatistics` - Thống kê sản phẩm
- `GetOrderStatistics` - Thống kê đơn hàng
- `GetMonthlyRevenue` - Doanh thu theo tháng

### **Views:**
- `ProductSummary` - Tóm tắt sản phẩm
- `OrderSummary` - Tóm tắt đơn hàng

### **Triggers:**
- `UpdateProductStock` - Tự động cập nhật tồn kho khi có đơn hàng

### **Functions:**
- `GetOrderStatusText` - Chuyển đổi mã trạng thái thành text

## 🔍 Kiểm tra Database

### **Kiểm tra dữ liệu:**
```sql
-- Kiểm tra số lượng bản ghi
SELECT 'Categories' as TableName, COUNT(*) as RecordCount FROM Categories
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderDetails', COUNT(*) FROM OrderDetails
UNION ALL
SELECT 'AdminUsers', COUNT(*) FROM AdminUsers;
```

### **Kiểm tra tài khoản admin:**
```sql
SELECT Username, FullName, Email, Role, IsActive 
FROM AdminUsers;
```

## 🚨 Troubleshooting

### **Lỗi thường gặp:**

1. **"Database already exists"**
   - Xóa database cũ: `DROP DATABASE TechStoreDB;`
   - Chạy lại script

2. **"Login failed"**
   - Kiểm tra SQL Server đang chạy
   - Kiểm tra quyền truy cập

3. **"Cannot connect to server"**
   - Kiểm tra SQL Server service
   - Kiểm tra firewall

### **Reset Database:**
```sql
-- Xóa và tạo lại database
DROP DATABASE TechStoreDB;
-- Sau đó chạy lại script tạo database
```

## 📞 Hỗ trợ

Nếu gặp vấn đề với database, hãy kiểm tra:
1. ✅ SQL Server đang chạy
2. ✅ Có quyền tạo database
3. ✅ Connection string đúng
4. ✅ Port không bị chặn

---

**🎉 Chúc bạn sử dụng database thành công!**
