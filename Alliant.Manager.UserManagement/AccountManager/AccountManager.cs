using Alliant.DalLayer;
using Alliant.Domain;

namespace Alliant.Manager
{
    public class AccountManager : DALProvider,IAccountManager
    {
        private AccountDAL _AccountDal = null;

        public AccountManager()
        {
            _AccountDal = DALUserManagement.AccountDAL;
        }

        public LoginCustomer GetLoginCustomer(int UserID)
        {  
            return _AccountDal.GetLoginCustomer(UserID);
        }

        public virtual UserLogin Login(UserLogin userLogin)
        {
            return _AccountDal.UserLoginRequest(userLogin);
        }
    }
}
