using System;
using System.Collections.Generic;
using System.Data.Entity;

namespace TechStore.Models
{
    public class SeedData : DropCreateDatabaseIfModelChanges<TechStoreDbContext>
    {
        protected override void Seed(TechStoreDbContext context)
        {
            // Seed Categories
            var categories = new List<Category>
            {
                new Category { Name = "Laptop", Description = "Máy tính xách tay", IsActive = true },
                new Category { Name = "Smartphone", Description = "Điện thoại thông minh", IsActive = true },
                new Category { Name = "Tablet", Description = "Máy tính bảng", IsActive = true },
                new Category { Name = "Desktop", Description = "Máy tính để bàn", IsActive = true },
                new Category { Name = "Accessories", Description = "Phụ kiện công nghệ", IsActive = true }
            };

            categories.ForEach(c => context.Categories.Add(c));
            context.SaveChanges();

            // Seed Products
            var products = new List<Product>
            {
                new Product
                {
                    Name = "MacBook Pro 16-inch M2",
                    Description = "MacBook Pro 16-inch với chip M2 mạnh mẽ, màn hình Liquid Retina XDR",
                    Price = 45990000,
                    StockQuantity = 10,
                    ImageUrl = "/Images/macbook-pro-16.jpg",
                    CategoryId = 1,
                    Brand = "Apple",
                    SKU = "MBP16-M2-001",
                    IsActive = true
                },
                new Product
                {
                    Name = "iPhone 15 Pro Max",
                    Description = "iPhone 15 Pro Max với chip A17 Pro, camera 48MP",
                    Price = 32990000,
                    StockQuantity = 25,
                    ImageUrl = "/Images/iphone-15-pro-max.jpg",
                    CategoryId = 2,
                    Brand = "Apple",
                    SKU = "IP15PM-001",
                    IsActive = true
                },
                new Product
                {
                    Name = "Samsung Galaxy S24 Ultra",
                    Description = "Galaxy S24 Ultra với S Pen, camera 200MP",
                    Price = 29990000,
                    StockQuantity = 20,
                    ImageUrl = "/Images/galaxy-s24-ultra.jpg",
                    CategoryId = 2,
                    Brand = "Samsung",
                    SKU = "S24U-001",
                    IsActive = true
                },
                new Product
                {
                    Name = "iPad Pro 12.9-inch M2",
                    Description = "iPad Pro 12.9-inch với chip M2, màn hình Liquid Retina XDR",
                    Price = 22990000,
                    StockQuantity = 15,
                    ImageUrl = "/Images/ipad-pro-12-9.jpg",
                    CategoryId = 3,
                    Brand = "Apple",
                    SKU = "IPAD12-M2-001",
                    IsActive = true
                },
                new Product
                {
                    Name = "Dell XPS 13",
                    Description = "Dell XPS 13 với Intel Core i7, màn hình 13.4 inch",
                    Price = 25990000,
                    StockQuantity = 8,
                    ImageUrl = "/Images/dell-xps-13.jpg",
                    CategoryId = 1,
                    Brand = "Dell",
                    SKU = "XPS13-001",
                    IsActive = true
                },
                new Product
                {
                    Name = "AirPods Pro 2nd Gen",
                    Description = "AirPods Pro thế hệ 2 với chip H2, chống ồi chủ động",
                    Price = 5990000,
                    StockQuantity = 50,
                    ImageUrl = "/Images/airpods-pro-2.jpg",
                    CategoryId = 5,
                    Brand = "Apple",
                    SKU = "APP2-001",
                    IsActive = true
                }
            };

            products.ForEach(p => context.Products.Add(p));
            context.SaveChanges();

            // Seed Admin Users
            var adminUsers = new List<AdminUser>
            {
                new AdminUser
                {
                    Username = "admin",
                    Password = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("admin123" + "TechStoreSalt")),
                    FullName = "Administrator",
                    Email = "admin@techstore.com",
                    IsActive = true,
                    Role = "SuperAdmin"
                },
                new AdminUser
                {
                    Username = "manager",
                    Password = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("manager123" + "TechStoreSalt")),
                    FullName = "Manager",
                    Email = "manager@techstore.com",
                    IsActive = true,
                    Role = "Admin"
                }
            };

            adminUsers.ForEach(a => context.AdminUsers.Add(a));
            context.SaveChanges();

            base.Seed(context);
        }
    }
}
