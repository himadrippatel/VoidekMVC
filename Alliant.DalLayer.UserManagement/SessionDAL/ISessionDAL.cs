using Alliant.Domain;

namespace Alliant.DalLayer
{
    public interface ISessionDAL
    {
        UserSession AddUpdateUserSession(int UserID, string SessionData, string Token);
        UserSession GetUserSession(int? UserID, string Token = null);
        UserSession GetUserSessionByToken(string token);
        void RemoveSession(int UserID, string Token);
    }
}
