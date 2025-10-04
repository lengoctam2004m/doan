@echo off
echo =============================================
echo    TechStore Database Setup Script
echo =============================================
echo.

REM Kiểm tra SQL Server có đang chạy không
echo [1/4] Kiểm tra SQL Server...
sqlcmd -S . -E -Q "SELECT @@VERSION" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Không thể kết nối đến SQL Server!
    echo Vui lòng kiểm tra SQL Server có đang chạy không.
    pause
    exit /b 1
)
echo ✓ SQL Server đang chạy

REM Tạo thư mục backup nếu chưa có
echo.
echo [2/4] Tạo thư mục backup...
if not exist "C:\Backup" mkdir "C:\Backup"
echo ✓ Thư mục backup đã sẵn sàng

REM Chạy script tạo database
echo.
echo [3/4] Tạo database TechStoreDB...
sqlcmd -S . -E -i "CreateDatabase.sql"
if %errorlevel% neq 0 (
    echo ERROR: Không thể tạo database!
    pause
    exit /b 1
)
echo ✓ Database đã được tạo thành công

REM Kiểm tra database đã tạo
echo.
echo [4/4] Kiểm tra database...
sqlcmd -S . -E -d TechStoreDB -Q "SELECT COUNT(*) as ProductCount FROM Products"
if %errorlevel% neq 0 (
    echo ERROR: Database không hoạt động đúng!
    pause
    exit /b 1
)
echo ✓ Database hoạt động bình thường

echo.
echo =============================================
echo    SETUP HOÀN THÀNH THÀNH CÔNG!
echo =============================================
echo.
echo Database: TechStoreDB
echo Sản phẩm: 6 sản phẩm mẫu
echo Danh mục: 5 danh mục
echo Admin: admin/admin123, manager/manager123
echo.
echo Bạn có thể chạy website ngay bây giờ!
echo.
pause
