using Alliant.Manager;
using System.Web.Mvc;

namespace Alliant
{
    public interface IAlliantManager_Genration
    {

        #region Common Manager
  
        IRootManager RootManager { get; }
        #endregion

        #region Administrator
      
        #endregion

        #region UserManagement
        IAccountManager AccountManager { get; }
        IChildMenuManager ChildMenuManager { get; }
        IMenuManager MenuManager { get; }
        IRoleManager RoleManager { get; }
    
        ISessionManager SessionManager { get; }
        #endregion
    }

    public class AlliantManager_Genration : IAlliantManager_Genration
    {

        #region Common Manager
    
        public IRootManager RootManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IRootManager>();
            }
        }
        #endregion

        #region Administrator
      
        #endregion

        #region UserManagement
        public IAccountManager AccountManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IAccountManager>();
            }
        }
        public IChildMenuManager ChildMenuManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IChildMenuManager>();
            }
        }
        public IMenuManager MenuManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IMenuManager>();
            }
        }
        public IRoleManager RoleManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IRoleManager>();
            }
        }
  
        public ISessionManager SessionManager
        {
            get
            {
                return DependencyResolver.Current.GetService<ISessionManager>();
            }
        }
        #endregion
    }
}

