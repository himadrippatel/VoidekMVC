using Alliant.Core;
using Alliant.Domain;
using Alliant.Utility;
using System.Data;
using System.Linq;

namespace Alliant.Manager
{
    public class CustomersManager : ICustomersManager
    {
        public UserCustomersSyncup UpdateUserLoginDetail()
        {
            UserCustomersSyncup userCustomersSyncup = null;
            //DataTable customerData = _DBProvider.GetDataTable(PredefinedStoreProcedure.spr_at_tblCustomers_GetUserPassword, CommandType.StoredProcedure);

            //userCustomersSyncup = _DBProvider.GetDataTable(PredefinedStoreProcedure.spr_at_tblCustomers_UserCustomersSyncup, CommandType.StoredProcedure,
            //    new List<SqlParameter>()
            //    {
            //        new SqlParameter(){
            //            ParameterName="@UserCustomersSyncup",
            //            Value=customerData,
            //            SqlDbType=SqlDbType.Structured
            //        }
            //    }).DataTableToList<UserCustomersSyncup>().FirstOrDefault();

            userCustomersSyncup = _DBProvider.GetDataTable(PredefinedStoreProcedure.spr_at_tblCustomers_UserCustomersSyncupV2, CommandType.StoredProcedure).DataTableToList<UserCustomersSyncup>().FirstOrDefault();

            return userCustomersSyncup;
        }
    }
}
