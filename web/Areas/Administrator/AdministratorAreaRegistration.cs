using System.Web.Mvc;

namespace Alliant.Areas.Administrator
{
    public class AdministratorAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "Administrator";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "Administrator_default",
                "Administrator/{controller}/{action}/{id}",
                new {area= "Administrator", controller ="Default", action = "Index", id = UrlParameter.Optional },
                namespaces: new[] { "Alliant.Areas.Administrator.Controllers" }
            );
        }
    }
}
