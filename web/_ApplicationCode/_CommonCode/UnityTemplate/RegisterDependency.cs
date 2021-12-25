using Alliant.Manager;
using System.Web.Mvc;
using Unity;
using Unity.Mvc5;

namespace Alliant
{
    public static class UnityConfig_Genration
    {
        public static void RegisterComponents()
        {
            var container = new UnityContainer();

            #region Common Manager
            container.RegisterType<IRootManager, RootManager>();
            #endregion

            #region Administrator
           
            container.RegisterType<IconManager, IconManager>();
            container.RegisterType<IIconManager, IconManager>();
            
            #endregion

            #region UserManagement
            container.RegisterType<IAccountManager, AccountManager>();
            container.RegisterType<IAuthorizationManager, AuthorizationManager>();
            container.RegisterType<IErrorLogManager, ErrorLogManager>();
            container.RegisterType<IAreaManagementManager, AreaManagementManager>();
            container.RegisterType<IChildMenuManager, ChildMenuManager>();
            container.RegisterType<IMenuManager, MenuManager>();
            container.RegisterType<IPermissionManager, PermissionManager>();
            container.RegisterType<IActivityVsUserManager, ActivityVsUserManager>();
            container.RegisterType<IPrimaryActivityManager, PrimaryActivityManager>();
            container.RegisterType<ISecondaryActivityManager, SecondaryActivityManager>();
            container.RegisterType<IRoleManager, RoleManager>();
            container.RegisterType<IRoleVsActivityManager, RoleVsActivityManager>();
            container.RegisterType<IRoleVsUserManager, RoleVsUserManager>();
            container.RegisterType<ISessionManager, SessionManager>();
            #endregion
            #region Controller Register here

            #endregion

            DependencyResolver.SetResolver(new UnityDependencyResolver(container));
        }
    }
}

