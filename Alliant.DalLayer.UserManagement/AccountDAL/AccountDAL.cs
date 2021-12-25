using Alliant.Core;
using Alliant.Domain;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Alliant.Utility;

namespace Alliant.DalLayer
{
    public class AccountDAL : CommonDAL
    {
        public virtual UserLogin UserLoginRequest(UserLogin userLogin)
        {           
            UserLogin user = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UserLogin(userLogin.UserName, userLogin.Password)?.FirstOrDefault();
            return user;
        }

        public virtual LoginCustomer GetLoginCustomer(int UserID)
        {
            LoginCustomer loginCustomer = null;
            loginCustomer = _DBProvider.GetDataTable(PredefinedStoreProcedure.spr_at_GetLoginUser, CommandType.StoredProcedure, new List<SqlParameter>()
            {
                new SqlParameter(){ ParameterName="@UserID",Value=UserID }
            }).DataTableToList<LoginCustomer>().FirstOrDefault();            
            return loginCustomer;
        }
    }
}
