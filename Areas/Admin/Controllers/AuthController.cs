using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using TechStore.Models;

namespace TechStore.Areas.Admin.Controllers
{
    public class AuthController : Controller
    {
        private TechStoreDbContext db = new TechStoreDbContext();

        // GET: Admin/Auth/Login
        public ActionResult Login()
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Admin");
            }
            return View();
        }

        // POST: Admin/Auth/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginViewModel model)
        {
            if (ModelState.IsValid)
            {
                var admin = db.AdminUsers.FirstOrDefault(a => a.Username == model.Username && a.IsActive);
                
                if (admin != null && VerifyPassword(model.Password, admin.Password))
                {
                    // Cập nhật thời gian đăng nhập cuối
                    admin.LastLoginDate = DateTime.Now;
                    db.SaveChanges();

                    // Tạo authentication ticket
                    FormsAuthentication.SetAuthCookie(admin.Username, model.RememberMe);
                    
                    // Lưu thông tin admin vào session
                    Session["AdminId"] = admin.AdminId;
                    Session["AdminName"] = admin.FullName;
                    Session["AdminRole"] = admin.Role;

                    return RedirectToAction("Index", "Admin");
                }
                else
                {
                    ModelState.AddModelError("", "Tên đăng nhập hoặc mật khẩu không đúng.");
                }
            }
            return View(model);
        }

        // GET: Admin/Auth/Logout
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            Session.Clear();
            return RedirectToAction("Login");
        }

        // GET: Admin/Auth/Profile
        [Authorize]
        public ActionResult Profile()
        {
            var adminId = (int)Session["AdminId"];
            var admin = db.AdminUsers.Find(adminId);
            if (admin == null)
            {
                return HttpNotFound();
            }
            return View(admin);
        }

        // POST: Admin/Auth/ChangePassword
        [HttpPost]
        [Authorize]
        public ActionResult ChangePassword(ChangePasswordViewModel model)
        {
            if (ModelState.IsValid)
            {
                var adminId = (int)Session["AdminId"];
                var admin = db.AdminUsers.Find(adminId);
                
                if (admin != null && VerifyPassword(model.OldPassword, admin.Password))
                {
                    admin.Password = HashPassword(model.NewPassword);
                    db.SaveChanges();
                    TempData["SuccessMessage"] = "Đổi mật khẩu thành công!";
                }
                else
                {
                    ModelState.AddModelError("OldPassword", "Mật khẩu cũ không đúng.");
                }
            }
            return RedirectToAction("Profile");
        }

        private string HashPassword(string password)
        {
            // Sử dụng BCrypt hoặc một thuật toán hash mạnh khác
            // Ở đây tôi sử dụng một cách đơn giản (không nên dùng trong production)
            return Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(password + "TechStoreSalt"));
        }

        private bool VerifyPassword(string password, string hashedPassword)
        {
            var hashedInput = HashPassword(password);
            return hashedInput == hashedPassword;
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

    public class LoginViewModel
    {
        [Required(ErrorMessage = "Tên đăng nhập là bắt buộc")]
        public string Username { get; set; }

        [Required(ErrorMessage = "Mật khẩu là bắt buộc")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        public bool RememberMe { get; set; }
    }

    public class ChangePasswordViewModel
    {
        [Required(ErrorMessage = "Mật khẩu cũ là bắt buộc")]
        [DataType(DataType.Password)]
        public string OldPassword { get; set; }

        [Required(ErrorMessage = "Mật khẩu mới là bắt buộc")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Mật khẩu phải có ít nhất 6 ký tự")]
        [DataType(DataType.Password)]
        public string NewPassword { get; set; }

        [Required(ErrorMessage = "Xác nhận mật khẩu là bắt buộc")]
        [DataType(DataType.Password)]
        [Compare("NewPassword", ErrorMessage = "Mật khẩu xác nhận không khớp")]
        public string ConfirmPassword { get; set; }
    }
}
