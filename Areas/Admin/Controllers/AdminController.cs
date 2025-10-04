using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TechStore.Models;
using TechStore.Areas.Admin.Filters;

namespace TechStore.Areas.Admin.Controllers
{
    [AdminAuthorize]
    public class AdminController : Controller
    {
        private TechStoreDbContext db = new TechStoreDbContext();

        // GET: Admin/Admin
        public ActionResult Index()
        {
            // Thống kê tổng quan
            var stats = new AdminDashboardViewModel
            {
                TotalProducts = db.Products.Count(p => p.IsActive),
                TotalOrders = db.Orders.Count(),
                TotalCustomers = db.Customers.Count(),
                TotalRevenue = db.Orders.Sum(o => o.TotalAmount),
                PendingOrders = db.Orders.Count(o => o.Status == OrderStatus.Pending),
                ProcessingOrders = db.Orders.Count(o => o.Status == OrderStatus.Processing),
                ShippedOrders = db.Orders.Count(o => o.Status == OrderStatus.Shipped),
                DeliveredOrders = db.Orders.Count(o => o.Status == OrderStatus.Delivered)
            };

            // Sản phẩm bán chạy
            stats.TopSellingProducts = db.OrderDetails
                .GroupBy(od => od.Product)
                .Select(g => new TopSellingProduct
                {
                    Product = g.Key,
                    TotalSold = g.Sum(od => od.Quantity),
                    TotalRevenue = g.Sum(od => od.TotalPrice)
                })
                .OrderByDescending(x => x.TotalSold)
                .Take(5)
                .ToList();

            // Đơn hàng gần đây
            stats.RecentOrders = db.Orders
                .Include(o => o.Customer)
                .OrderByDescending(o => o.OrderDate)
                .Take(10)
                .ToList();

            // Doanh thu theo tháng (6 tháng gần nhất)
            stats.MonthlyRevenue = GetMonthlyRevenue();

            return View(stats);
        }

        // GET: Admin/Admin/Products
        public ActionResult Products()
        {
            var products = db.Products
                .Include(p => p.Category)
                .Where(p => p.IsActive)
                .OrderBy(p => p.Name)
                .ToList();
            return View(products);
        }

        // GET: Admin/Admin/Orders
        public ActionResult Orders()
        {
            var orders = db.Orders
                .Include(o => o.Customer)
                .OrderByDescending(o => o.OrderDate)
                .ToList();
            return View(orders);
        }

        // GET: Admin/Admin/Customers
        public ActionResult Customers()
        {
            var customers = db.Customers
                .OrderBy(c => c.FullName)
                .ToList();
            return View(customers);
        }

        // GET: Admin/Admin/Categories
        public ActionResult Categories()
        {
            var categories = db.Categories
                .Where(c => c.IsActive)
                .OrderBy(c => c.Name)
                .ToList();
            return View(categories);
        }

        // POST: Admin/Admin/UpdateOrderStatus
        [HttpPost]
        public ActionResult UpdateOrderStatus(int orderId, OrderStatus status)
        {
            var order = db.Orders.Find(orderId);
            if (order != null)
            {
                order.Status = status;
                
                if (status == OrderStatus.Shipped)
                {
                    order.ShippedDate = DateTime.Now;
                }
                else if (status == OrderStatus.Delivered)
                {
                    order.DeliveredDate = DateTime.Now;
                }
                
                db.SaveChanges();
                TempData["SuccessMessage"] = "Cập nhật trạng thái đơn hàng thành công!";
            }
            else
            {
                TempData["ErrorMessage"] = "Không tìm thấy đơn hàng!";
            }
            
            return RedirectToAction("Orders");
        }

        // GET: Admin/Admin/Reports
        public ActionResult Reports()
        {
            var reportData = new ReportViewModel
            {
                StartDate = DateTime.Now.AddMonths(-1),
                EndDate = DateTime.Now,
                Orders = db.Orders
                    .Where(o => o.OrderDate >= DateTime.Now.AddMonths(-1))
                    .OrderByDescending(o => o.OrderDate)
                    .ToList(),
                Products = db.Products
                    .Where(p => p.IsActive)
                    .ToList()
            };
            
            return View(reportData);
        }

        // POST: Admin/Admin/GenerateReport
        [HttpPost]
        public ActionResult GenerateReport(DateTime startDate, DateTime endDate)
        {
            var reportData = new ReportViewModel
            {
                StartDate = startDate,
                EndDate = endDate,
                Orders = db.Orders
                    .Where(o => o.OrderDate >= startDate && o.OrderDate <= endDate)
                    .OrderByDescending(o => o.OrderDate)
                    .ToList(),
                Products = db.Products
                    .Where(p => p.IsActive)
                    .ToList()
            };
            
            return View("Reports", reportData);
        }

        private List<MonthlyRevenue> GetMonthlyRevenue()
        {
            var monthlyRevenue = new List<MonthlyRevenue>();
            var currentDate = DateTime.Now;
            
            for (int i = 5; i >= 0; i--)
            {
                var month = currentDate.AddMonths(-i);
                var startOfMonth = new DateTime(month.Year, month.Month, 1);
                var endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);
                
                var revenue = db.Orders
                    .Where(o => o.OrderDate >= startOfMonth && o.OrderDate <= endOfMonth)
                    .Sum(o => o.TotalAmount);
                
                monthlyRevenue.Add(new MonthlyRevenue
                {
                    Month = month.ToString("MM/yyyy"),
                    Revenue = revenue
                });
            }
            
            return monthlyRevenue;
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }

    // View Models
    public class AdminDashboardViewModel
    {
        public int TotalProducts { get; set; }
        public int TotalOrders { get; set; }
        public int TotalCustomers { get; set; }
        public decimal TotalRevenue { get; set; }
        public int PendingOrders { get; set; }
        public int ProcessingOrders { get; set; }
        public int ShippedOrders { get; set; }
        public int DeliveredOrders { get; set; }
        public List<TopSellingProduct> TopSellingProducts { get; set; }
        public List<Order> RecentOrders { get; set; }
        public List<MonthlyRevenue> MonthlyRevenue { get; set; }
    }

    public class TopSellingProduct
    {
        public Product Product { get; set; }
        public int TotalSold { get; set; }
        public decimal TotalRevenue { get; set; }
    }

    public class MonthlyRevenue
    {
        public string Month { get; set; }
        public decimal Revenue { get; set; }
    }

    public class ReportViewModel
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public List<Order> Orders { get; set; }
        public List<Product> Products { get; set; }
    }
}
