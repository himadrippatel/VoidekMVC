using Alliant.Manager;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public class AlliantManager : IAlliantManager
    {
        public IAccountManager AccountManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IAccountManager>();
            }
        }


        public ISessionManager SessionManager
        {
            get
            {
                return DependencyResolver.Current.GetService<ISessionManager>();
            }
        }

        public IRoleManager RoleManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IRoleManager>();
            }
        }

        public IAreaManagementManager AreaManagementManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IAreaManagementManager>();
            }
        }

        public IMenuManager MenuManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IMenuManager>();
            }
        }

        public IChildMenuManager ChildMenuManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IChildMenuManager>();
            }
        }
    }
}