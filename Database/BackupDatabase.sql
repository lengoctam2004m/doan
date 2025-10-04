-- =============================================
-- Script backup database TechStoreDB
-- Tạo file backup để khôi phục sau này
-- =============================================

USE TechStoreDB;
GO

-- Tạo backup database
BACKUP DATABASE TechStoreDB 
TO DISK = 'C:\Backup\TechStoreDB.bak'
WITH FORMAT, INIT, NAME = 'TechStoreDB Full Backup', 
SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

-- Tạo backup chỉ dữ liệu
BACKUP DATABASE TechStoreDB 
TO DISK = 'C:\Backup\TechStoreDB_Data.bak'
WITH FORMAT, INIT, NAME = 'TechStoreDB Data Only Backup',
SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

PRINT 'Backup database TechStoreDB đã hoàn thành!';
PRINT 'File backup: C:\Backup\TechStoreDB.bak';
PRINT 'File data backup: C:\Backup\TechStoreDB_Data.bak';
