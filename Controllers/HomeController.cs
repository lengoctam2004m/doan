using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TechStore.Models;

namespace TechStore.Controllers
{
    public class HomeController : Controller
    {
        private TechStoreDbContext db = new TechStoreDbContext();

        public ActionResult Index()
        {
            var featuredProducts = db.Products
                .Where(p => p.IsActive)
                .OrderByDescending(p => p.CreatedDate)
                .Take(8)
                .ToList();

            var categories = db.Categories
                .Where(c => c.IsActive)
                .ToList();

            ViewBag.Categories = categories;
            return View(featuredProducts);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Giới thiệu về TechStore";
            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Thông tin liên hệ";
            return View();
        }

        public ActionResult ProductDetails(int id)
        {
            var product = db.Products.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        public ActionResult ProductsByCategory(int categoryId)
        {
            var products = db.Products
                .Where(p => p.CategoryId == categoryId && p.IsActive)
                .ToList();

            var category = db.Categories.Find(categoryId);
            ViewBag.CategoryName = category?.Name ?? "Danh mục không tồn tại";
            
            return View(products);
        }

        [HttpPost]
        public ActionResult Search(string searchTerm)
        {
            if (string.IsNullOrEmpty(searchTerm))
            {
                return RedirectToAction("Index");
            }

            var products = db.Products
                .Where(p => p.IsActive && 
                           (p.Name.Contains(searchTerm) || 
                            p.Description.Contains(searchTerm) ||
                            p.Brand.Contains(searchTerm)))
                .ToList();

            ViewBag.SearchTerm = searchTerm;
            return View(products);
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
}
