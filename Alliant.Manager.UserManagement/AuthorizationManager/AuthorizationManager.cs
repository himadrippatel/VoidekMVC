using Alliant.DalLayer;
using Alliant.Domain;
using Alliant.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Alliant.Manager
{
    public class AuthorizationManager : DALProvider, IAuthorizationManager
    {
        AuthorizationDAL oAuthorizationDAL = null;
        ISessionManager oSessionManager = null;
        AlliantDataCacheManager _AlliantDataCacheManager = AlliantDataCacheManager.Instance;
        public readonly List<string> UserLayoutActivitys;
        public AuthorizationManager()
        {
            oAuthorizationDAL = DALUserManagement.AuthorizationDAL;
            oSessionManager = new SessionManager();
            UserLayoutActivitys = new List<string>()
            {   "activity_mainmenu",
                "activity_administrator",
                "activity_usermanagement",
                "activity_usermanagement_searchmaster_dropdown",
                "activity_search",
                "activity_search_customer",
                "activity_search_po"
            };
        }

        public List<SecondaryActivity> GetUserActivities(int UserID)
        {
            return oAuthorizationDAL.GetUserActivities(UserID);
        }

        public IDictionary<string, bool> GetValidActivities(int UserID, params string[] activitys)
        {
            List<SecondaryActivity> secondaryActivities = GetUserActivities(UserID);

            IEnumerable<string> primaryActivity = secondaryActivities.Select(x => x.ParentActivity);
            IEnumerable<string> secondartyActivity = secondaryActivities.Select(x => x.ActivityName);
            IEnumerable<string> validActivity = primaryActivity.Union(secondartyActivity);

            IDictionary<string, bool> userActivity = new Dictionary<string, bool>();
            foreach (string activity in activitys)
            {
                userActivity.Add(activity, (validActivity.Where(x => string.Equals(x, activity, System.StringComparison.OrdinalIgnoreCase)).Count() > 0 ? true : false));
            }
            return userActivity;
        }

        public bool IsAuthorized(string pActivityName = null)
        {
            return GetActivityPermittions(pActivityName).Any(o => o.Value == true);
        }

        public bool IsAuthorizedForAny(string pActivityNames)
        {
            Dictionary<string, bool> ActivityPermittions = GetActivityPermittions(pActivityNames);
            if (ActivityPermittions.Keys.Any(o => o != UtilityConstant.DefaultActivity)
                && ActivityPermittions.Where(o => o.Key != UtilityConstant.DefaultActivity).Any(o => o.Value == true)) return true;
            else if (ActivityPermittions.Keys.Any(o => o != UtilityConstant.DefaultActivity)) return false;
            else return true;
        }

        public Dictionary<string, bool> GetActivityPermittions(string pActivityNames)
        {
            if (pActivityNames.IsNullOrEmpty())
                return new Dictionary<string, bool>() { };

            if (pActivityNames.EqualsIgnoreCase(UtilityConstant.DefaultActivity))
            {
                return new Dictionary<string, bool>() { { UtilityConstant.DefaultActivity, true } };
            }

            UserSession oSession = this.GetUserSession();

            List<string> lstActivityName = pActivityNames.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(o => o.Trim()).ToList();
            if (!lstActivityName.Contains(UtilityConstant.DefaultActivity))
                lstActivityName.Add(UtilityConstant.DefaultActivity);


            if (oSession.IsSuperAdminLoggedIn)
                return lstActivityName.ToDictionary(o => o, p => true);

            Dictionary<string, bool> userValidActivities = this.GetUserActivities(lstActivityName, oSession.UserID);

            return userValidActivities;
        }

        public Dictionary<string, bool> GetUserActivities(List<string> lstActivityName, int UserID)
        {
            IEnumerable<string> validActivity = this.validActivity(UserID);
            Dictionary<string, bool> userActivity = new Dictionary<string, bool>();
            foreach (string activity in lstActivityName)
            {
                userActivity.Add(activity, (validActivity.Where(x => string.Equals(x, activity, StringComparison.OrdinalIgnoreCase)).Count() > 0 ? true : false));
            }
            return userActivity;

        }

        public UserSession GetUserSession()
        {
            UserSession oSessionData = null;
            HttpCookie oCookie = HttpContext.Current.Request.Cookies.Get("_Key");
            string oToken = oCookie?.Value;
            string oCacheKey = $"{AlliantDataCacheKey.UserSession}_{oToken}";

            if (_AlliantDataCacheManager.CheckKeyExists(oCacheKey))
            {
                oSessionData = _AlliantDataCacheManager.GetValue(oCacheKey) as UserSession;
            }
            else
            {
                oSessionData = oSessionManager.GetUserSessionByToken(oToken);
                _AlliantDataCacheManager.Add(oCacheKey, oSessionData, DateTimeOffset.Now.AddHours(1));
            }

            return oSessionData;
        }

        public List<SecondaryActivity> GetUserParentActivity(string ActivityIDs)
        {
            return oAuthorizationDAL.GetUserParentActivity(ActivityIDs);
        }

        public IDictionary<string, bool> GetUserLayoutActivities(int UserID, bool IsSuperAdminLoggedIn)
        {
            Dictionary<string, bool> dtuserActivity = null;
            string oCacheKey = $"{AlliantDataCacheKey.LayoutActivities}_{UserID}";

            if (_AlliantDataCacheManager.CheckKeyExists(oCacheKey))
            {
                dtuserActivity = _AlliantDataCacheManager.GetValue(oCacheKey) as Dictionary<string, bool>;
            }
            else
            {
                IEnumerable<string> validLayoutActivity = this.validActivity(UserID);

                if (IsSuperAdminLoggedIn)
                {
                    validLayoutActivity = validLayoutActivity.Union(UserLayoutActivitys);
                    dtuserActivity = validLayoutActivity.ToDictionary(k => k, v => true);
                    dtuserActivity.AddOrUpdate(UtilityConstant.DefaultActivity, true);
                }
                else
                {
                    dtuserActivity = validLayoutActivity.ToDictionary(k => k, v => true);
                    foreach (string activity in UserLayoutActivitys)
                    {
                        dtuserActivity.AddOrUpdate(activity, validLayoutActivity.Where(x => string.Equals(x, activity, StringComparison.OrdinalIgnoreCase)).Count() > 0 ? true : false);
                    }
                }

                _AlliantDataCacheManager.Add(oCacheKey, dtuserActivity, DateTimeOffset.Now.AddHours(1));
            }

            return dtuserActivity;
        }

        private IEnumerable<string> validActivity(int UserID)
        {
            IEnumerable<string> activitys = null;
            string oCacheKey = $"{AlliantDataCacheKey.UserActivities}_{UserID}";

            if (_AlliantDataCacheManager.CheckKeyExists(oCacheKey))
            {
                activitys = _AlliantDataCacheManager.GetValue(oCacheKey) as IEnumerable<string>;
            }
            else
            {
                List<SecondaryActivity> UserActivities = this.GetUserActivities(UserID);
                string ActivityIDs = UserActivities.Select(x => x.PrimaryActivityID).JoinValues();
                UserActivities.AddRange(this.GetUserParentActivity(ActivityIDs));
                IEnumerable<string> primaryActivity = UserActivities.Select(x => x.ParentActivity);
                IEnumerable<string> secondartyActivity = UserActivities.Select(x => x.ActivityName);
                activitys = primaryActivity.Union(secondartyActivity);

                _AlliantDataCacheManager.Add(oCacheKey, activitys, DateTimeOffset.Now.AddHours(1));
            }

            return activitys;
        }
    }
}
