using Alliant.Domain;
using System.Linq;

namespace Alliant.DalLayer
{
    public class SessionDAL : CommonDAL, ISessionDAL
    {
        public virtual UserSession AddUpdateUserSession(int UserID, string SessionData, string Token)
        {
            UserSession userSession = _StoreProcedure.StoreProcedureUserManagement.spr_at_UserSession_Insert(UserID, SessionData, Token)?.FirstOrDefault();
            if (userSession != null)
            {
                AdminResult adminResult = _StoreProcedure.StoreProcedureUserManagement.spr_at_IsSuperAdmin(userSession.UserID)?.FirstOrDefault();
                userSession.IsSuperAdminLoggedIn = (adminResult != null ? adminResult.IsSuperAdminLoggedIn : false);
            }
            return userSession;
        }

        public virtual UserSession GetUserSession(int? UserID, string Token = null)
        {
            UserSession userSession = _StoreProcedure.StoreProcedureUserManagement.spr_at_UserSession(UserID, Token)?.FirstOrDefault();
            if (userSession != null)
            {
                AdminResult adminResult = _StoreProcedure.StoreProcedureUserManagement.spr_at_IsSuperAdmin(userSession.UserID)?.FirstOrDefault();
                userSession.IsSuperAdminLoggedIn = (adminResult != null ? adminResult.IsSuperAdminLoggedIn : false);
            }

            return userSession;
        }

        public UserSession GetUserSessionByToken(string token)
        {
            UserSession userSession = _StoreProcedure.StoreProcedureUserManagement.spr_at_UserSessionByToken(token)?.FirstOrDefault();
            if (userSession != null)
            {
                AdminResult adminResult = _StoreProcedure.StoreProcedureUserManagement.spr_at_IsSuperAdmin(userSession.UserID)?.FirstOrDefault();
                userSession.IsSuperAdminLoggedIn = (adminResult != null ? adminResult.IsSuperAdminLoggedIn : false);
            }

            return userSession;
        }

        public void RemoveSession(int UserID, string Token)
        {
            _StoreProcedure.StoreProcedureUserManagement.spr_at_UserSession_Delete(UserID, Token);
        }
    }
}
