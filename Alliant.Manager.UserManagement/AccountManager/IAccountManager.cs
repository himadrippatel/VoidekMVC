using Alliant.Domain;

namespace Alliant.Manager
{
    public interface IAccountManager : IRootManager
    {
        UserLogin Login(UserLogin userLogin);
        LoginCustomer GetLoginCustomer(int UserID);
    }
}
