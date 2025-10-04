-- =============================================
-- Script khôi phục database TechStoreDB
-- Sử dụng file backup để khôi phục database
-- =============================================

-- Khôi phục database từ file backup
RESTORE DATABASE TechStoreDB 
FROM DISK = 'C:\Backup\TechStoreDB.bak'
WITH REPLACE, STATS = 10;
GO

PRINT 'Database TechStoreDB đã được khôi phục thành công!';
