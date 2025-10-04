# TechStore - Website Bán Đồ Công Nghệ

## Mô tả dự án
TechStore là một website bán đồ công nghệ được xây dựng bằng ASP.NET MVC với kết nối SQL Server. Website cung cấp đầy đủ các chức năng quản lý sản phẩm, đơn hàng và khách hàng.

## Tính năng chính

### 🛍️ **Trang chủ (Frontend)**
- **Quản lý sản phẩm**: Thêm, sửa, xóa, xem chi tiết sản phẩm
- **Quản lý danh mục**: Phân loại sản phẩm theo danh mục
- **Quản lý khách hàng**: Thông tin khách hàng và lịch sử mua hàng
- **Quản lý đơn hàng**: Tạo, cập nhật trạng thái đơn hàng
- **Tìm kiếm**: Tìm kiếm sản phẩm theo tên, mô tả, thương hiệu
- **Giao diện responsive**: Tương thích với mọi thiết bị

### 🔧 **Admin Panel (Backend)**
- **Dashboard tổng quan**: Thống kê doanh thu, đơn hàng, sản phẩm
- **Quản lý sản phẩm nâng cao**: Xem, sửa, xóa sản phẩm với giao diện admin
- **Quản lý đơn hàng**: Cập nhật trạng thái đơn hàng, xem chi tiết
- **Quản lý khách hàng**: Thông tin chi tiết khách hàng và lịch sử mua hàng
- **Quản lý danh mục**: Thêm, sửa, xóa danh mục sản phẩm
- **Báo cáo thống kê**: Biểu đồ doanh thu, sản phẩm bán chạy
- **Hệ thống phân quyền**: Đăng nhập admin với các cấp độ khác nhau

## Yêu cầu hệ thống
- Visual Studio 2019 hoặc mới hơn
- .NET Framework 4.8
- SQL Server 2016 hoặc mới hơn
- Entity Framework 6.x

## Cài đặt và chạy dự án

### Bước 1: Clone dự án
```bash
git clone <repository-url>
cd banhang
```

### Bước 2: Cấu hình kết nối cơ sở dữ liệu
1. Mở file `Web.config`
2. Cập nhật connection string trong phần `<connectionStrings>`:
```xml
<add name="DefaultConnection" 
     connectionString="Data Source=YOUR_SERVER;Initial Catalog=TechStoreDB;Integrated Security=True;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False" 
     providerName="System.Data.SqlClient" />
```

### Bước 3: Tạo cơ sở dữ liệu
1. Mở Package Manager Console trong Visual Studio
2. Chạy lệnh:
```powershell
Update-Database
```

### Bước 4: Chạy dự án
1. Nhấn F5 hoặc Ctrl+F5 để chạy dự án
2. Mở trình duyệt và truy cập: `http://localhost:port`

### Bước 5: Truy cập Admin Panel
1. Truy cập: `http://localhost:port/Admin/Auth/Login`
2. Sử dụng tài khoản mặc định:
   - **SuperAdmin**: `admin` / `admin123`
   - **Admin**: `manager` / `manager123`

## Cấu trúc dự án

```
banhang/
├── App_Data/
│   ├── ConnectionStrings.config      # Cấu hình kết nối SQL
│   └── DatabaseHelper.cs             # Helper class cho database
├── App_Start/
│   ├── BundleConfig.cs               # Cấu hình bundle CSS/JS
│   ├── FilterConfig.cs               # Cấu hình filter
│   └── RouteConfig.cs                # Cấu hình routing
├── Controllers/
│   ├── HomeController.cs             # Controller trang chủ
│   ├── ProductsController.cs         # Controller quản lý sản phẩm
│   ├── OrdersController.cs           # Controller quản lý đơn hàng
│   └── CustomersController.cs        # Controller quản lý khách hàng
├── Areas/
│   └── Admin/                        # Admin Panel
│       ├── Controllers/
│       │   ├── AdminController.cs    # Controller admin chính
│       │   └── AuthController.cs     # Controller đăng nhập admin
│       ├── Views/
│       │   ├── Admin/                # Views admin
│       │   └── Auth/                 # Views đăng nhập
│       ├── Filters/
│       │   └── AdminAuthorizeAttribute.cs  # Filter phân quyền admin
│       └── AdminAreaRegistration.cs  # Đăng ký Area Admin
├── Models/
│   ├── Product.cs                    # Model sản phẩm
│   ├── Category.cs                   # Model danh mục
│   ├── Customer.cs                   # Model khách hàng
│   ├── Order.cs                      # Model đơn hàng
│   ├── OrderDetail.cs                # Model chi tiết đơn hàng
│   ├── AdminUser.cs                  # Model tài khoản admin
│   ├── TechStoreDbContext.cs         # DbContext Entity Framework
│   └── SeedData.cs                   # Dữ liệu mẫu
├── Views/
│   ├── Shared/
│   │   └── _Layout.cshtml            # Layout chính
│   ├── Home/                         # Views trang chủ
│   ├── Products/                     # Views quản lý sản phẩm
│   ├── Orders/                       # Views quản lý đơn hàng
│   └── Customers/                    # Views quản lý khách hàng
├── Content/
│   └── Site.css                      # CSS tùy chỉnh
├── Scripts/
│   └── custom.js                     # JavaScript tùy chỉnh
├── Web.config                        # Cấu hình ứng dụng
├── packages.config                   # Danh sách packages NuGet
└── README.md                         # Hướng dẫn này
```

## Cấu hình cơ sở dữ liệu

### Tạo database thủ công
```sql
CREATE DATABASE TechStoreDB;
GO

USE TechStoreDB;
GO
```

### Sử dụng Entity Framework Migrations
```powershell
# Tạo migration
Add-Migration InitialCreate

# Cập nhật database
Update-Database
```

## API Endpoints

### Sản phẩm
- `GET /Products` - Danh sách sản phẩm
- `GET /Products/Details/{id}` - Chi tiết sản phẩm
- `GET /Products/Create` - Form tạo sản phẩm
- `POST /Products/Create` - Tạo sản phẩm mới
- `GET /Products/Edit/{id}` - Form sửa sản phẩm
- `POST /Products/Edit/{id}` - Cập nhật sản phẩm
- `GET /Products/Delete/{id}` - Form xóa sản phẩm
- `POST /Products/Delete/{id}` - Xóa sản phẩm

### Đơn hàng
- `GET /Orders` - Danh sách đơn hàng
- `GET /Orders/Details/{id}` - Chi tiết đơn hàng
- `POST /Orders/UpdateStatus` - Cập nhật trạng thái đơn hàng

### Khách hàng
- `GET /Customers` - Danh sách khách hàng
- `GET /Customers/Details/{id}` - Chi tiết khách hàng

### Admin Panel
- `GET /Admin/Auth/Login` - Trang đăng nhập admin
- `POST /Admin/Auth/Login` - Xử lý đăng nhập
- `GET /Admin/Auth/Logout` - Đăng xuất admin
- `GET /Admin/Admin` - Dashboard admin
- `GET /Admin/Admin/Products` - Quản lý sản phẩm (Admin)
- `GET /Admin/Admin/Orders` - Quản lý đơn hàng (Admin)
- `GET /Admin/Admin/Customers` - Quản lý khách hàng (Admin)
- `GET /Admin/Admin/Categories` - Quản lý danh mục (Admin)
- `GET /Admin/Admin/Reports` - Báo cáo thống kê (Admin)

## Troubleshooting

### Lỗi kết nối database
1. Kiểm tra connection string trong `Web.config`
2. Đảm bảo SQL Server đang chạy
3. Kiểm tra quyền truy cập database

### Lỗi Entity Framework
1. Chạy `Update-Database` trong Package Manager Console
2. Kiểm tra model có thay đổi không
3. Xóa và tạo lại database nếu cần

### Lỗi CSS/JS không load
1. Kiểm tra BundleConfig.cs
2. Đảm bảo file CSS/JS tồn tại
3. Kiểm tra đường dẫn trong Views

## Đóng góp

1. Fork dự án
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## License

Dự án này được phân phối dưới MIT License. Xem file `LICENSE` để biết thêm chi tiết.

## Liên hệ

- Email: info@techstore.com
- Website: https://techstore.com
- GitHub: https://github.com/techstore

## Changelog

### Version 1.0.0
- Phiên bản đầu tiên
- Quản lý sản phẩm, đơn hàng, khách hàng
- Giao diện responsive
- Tìm kiếm sản phẩm