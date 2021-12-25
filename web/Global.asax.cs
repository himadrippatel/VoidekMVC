using Alliant.Common;
using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace Alliant
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            UnityConfig.RegisterComponents();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
            Response.Cache.SetNoStore();

            /* HttpContext context = base.Context;
             #region ForQuesryStringPrevent
             var oHttpApplication = (HttpApplication)sender;
             var oPathAndQuery = oHttpApplication.Context.Request.Url.PathAndQuery;
             if (oPathAndQuery.Contains("?" + HtmlHelperExtension.Encrypt("Alliant=")))
             {
                 var NewoPathAndQuery = oPathAndQuery.Split(new string[] { "?" }, StringSplitOptions.None);
                 var oPath = NewoPathAndQuery[0];
                 var oQueryString = NewoPathAndQuery[1].Replace(HtmlHelperExtension.Encrypt("Alliant="), "");
                 var oDecodedURL = HtmlHelperExtension.Decrypt(oQueryString.ToString());
                 oHttpApplication.Context.RewritePath(oPath + "?" + oDecodedURL.ToString());
             }
             #endregion */  
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            //Exception exception = Server.GetLastError();           
            //Response.Clear();       
            //Server.ClearError();
            //Response.Redirect(String.Format("~/Error/{0}?message={1}", "Index", exception.Message));
        }

    }
}
