using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.Manager
{
    public interface IAuthorizationManager : IRootManager
    {
        List<SecondaryActivity> GetUserActivities(int UserID);
        List<SecondaryActivity> GetUserParentActivity(string ActivityIDs);
        IDictionary<string, bool> GetValidActivities(int UserID, params string[] activitys);
        IDictionary<string, bool> GetUserLayoutActivities(int UserID,bool IsSuperAdminLoggedIn);
        bool IsAuthorized(string pActivityName = null);
        bool IsAuthorizedForAny(string pActivityNames);
        Dictionary<string, bool> GetActivityPermittions(string pActivityNames);
        UserSession GetUserSession();
    }
}
