using Alliant.Manager;

namespace Alliant._ApplicationCode
{
    /// <summary>
    /// Add all manager
    /// </summary>
    public interface IAlliantManager
    {
        IAccountManager AccountManager { get; }
       
        ISessionManager SessionManager { get; }
    
        IAreaManagementManager AreaManagementManager { get; }
        IMenuManager MenuManager { get; }
        IChildMenuManager ChildMenuManager { get; }
    }
}
