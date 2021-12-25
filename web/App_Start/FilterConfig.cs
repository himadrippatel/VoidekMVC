using System.Web.Mvc;

namespace Alliant
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
            filters.Add(new AlliantFilterAttribute());
            filters.Add(new AlliantErrorHandling());
        }
    }
}
