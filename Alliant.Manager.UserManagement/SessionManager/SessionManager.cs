using Alliant.DalLayer;
using Alliant.Domain;

namespace Alliant.Manager
{
    public class SessionManager : DALProvider, ISessionManager
    {
        ISessionDAL _sessionDal = null;
 
        public SessionManager()
        {
            _sessionDal = DALUserManagement.SessionDAL;
        }

        public virtual UserSession AddUpdateUserSession(int UserID, string SessionData, string Token)
        {
            return _sessionDal.AddUpdateUserSession(UserID, SessionData, Token);
        }

        public virtual UserSession GetUserSession(int? UserID, string Token = null)
        {
            return _sessionDal.GetUserSession(UserID, Token);
        }

        public UserSession GetUserSessionByToken(string token)
        {
            return _sessionDal.GetUserSessionByToken(token);
        }

        public void RemoveSession(int UserID, string Token)
        {
            _sessionDal.RemoveSession(UserID, Token);
        }
    }
}
