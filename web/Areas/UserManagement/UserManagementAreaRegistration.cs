using System.Web.Mvc;

namespace Alliant.Areas.UserManagement
{
    public class UserManagementAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "UserManagement";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "UserManagement_default",
                "UserManagement/{controller}/{action}/{id}",
                new { area= "UserManagement", controller = "Default",action = "Index", id = UrlParameter.Optional },
                 namespaces: new[] { "Alliant.Areas.UserManagement.Controllers" }
            );
        }
    }
}