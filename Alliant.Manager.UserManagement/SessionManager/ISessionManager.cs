using Alliant.Domain;

namespace Alliant.Manager
{
    public interface ISessionManager : IRootManager
    {
        UserSession GetUserSession(int? UserID, string Token = null);
        UserSession GetUserSessionByToken(string token);
        UserSession AddUpdateUserSession(int UserID, string SessionData, string Token);
        void RemoveSession(int UserID, string Token);
    }
} 
