using Alliant._ApplicationCode;
using Alliant.Manager;
using Alliant.Utility;
using System.Web.Mvc;
using System.Web.Routing;
using Unity;
using Unity.Mvc5;

namespace Alliant
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
            var container = new UnityContainer();

            #region All Manager Register here
            container.RegisterType<IAccountManager, AccountManager>();
           
            container.RegisterType<ISessionManager, SessionManager>();
            container.RegisterType<IRoleManager, RoleManager>();
       
            container.RegisterType<IMenuManager, MenuManager>();
            container.RegisterType<IChildMenuManager, ChildMenuManager>();
            container.RegisterType<IAreaManagementManager, AreaManagementManager>();
            container.RegisterType<IPermissionManager, PermissionManager>();
            container.RegisterType<IRoleVsUserManager, RoleVsUserManager>();
            container.RegisterType<ICustomersManager, CustomersManager>();
            container.RegisterType<IPrimaryActivityManager, PrimaryActivityManager>();
            container.RegisterType<ISecondaryActivityManager, SecondaryActivityManager>();
            container.RegisterType<IAuthorizationManager, AuthorizationManager>();
            container.RegisterType<IActivityVsUserManager, ActivityVsUserManager>();
            container.RegisterType<IRoleVsActivityManager, RoleVsActivityManager>();
            container.RegisterType<IErrorLogManager, ErrorLogManager>();
            container.RegisterType<IIconManager, IconManager>();           

            #endregion

            #region Controller Register here            
            #endregion

            #region Singleton
            container.RegisterSingleton<AlliantConfigurationSection>();
            container.RegisterSingleton<AlliantViewsMapper>();
            #endregion

            container.RegisterType<IAlliantManager, AlliantManager>();

            #region web instance
            //container.RegisterInstance<RouteCollection>(RouteTable.Routes);
            //container.RegisterInstance<ViewEngineCollection>(ViewEngines.Engines);
            //container.RegisterInstance<GlobalFilterCollection>(GlobalFilters.Filters);
            #endregion

            DependencyResolver.SetResolver(new UnityDependencyResolver(container));
        }
    }
}