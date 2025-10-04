using System;
using System.Web;
using System.Web.Mvc;

namespace TechStore.Areas.Admin.Filters
{
    public class AdminAuthorizeAttribute : AuthorizeAttribute
    {
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (!httpContext.User.Identity.IsAuthenticated)
            {
                return false;
            }

            // Kiểm tra session admin
            var adminId = httpContext.Session["AdminId"];
            var adminName = httpContext.Session["AdminName"];
            var adminRole = httpContext.Session["AdminRole"];

            if (adminId == null || adminName == null || adminRole == null)
            {
                return false;
            }

            return true;
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            if (filterContext.HttpContext.User.Identity.IsAuthenticated)
            {
                // Nếu đã đăng nhập nhưng không có quyền admin
                filterContext.Result = new RedirectToRouteResult(
                    new System.Web.Routing.RouteValueDictionary
                    {
                        { "area", "Admin" },
                        { "controller", "Auth" },
                        { "action", "Login" }
                    });
            }
            else
            {
                // Nếu chưa đăng nhập
                filterContext.Result = new RedirectToRouteResult(
                    new System.Web.Routing.RouteValueDictionary
                    {
                        { "area", "Admin" },
                        { "controller", "Auth" },
                        { "action", "Login" }
                    });
            }
        }
    }
}
