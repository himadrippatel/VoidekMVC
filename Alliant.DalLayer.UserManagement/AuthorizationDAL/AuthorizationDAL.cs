using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Alliant.Core;
using Alliant.Domain;
using Alliant.Utility;

namespace Alliant.DalLayer
{
    public class AuthorizationDAL : IAuthorizationDAL
    {
        public List<SecondaryActivity> GetUserActivities(int UserID)
        {
            List<SecondaryActivity> secondaryActivities = null;
            secondaryActivities = _DBProvider.GetDataTable(PredefinedStoreProcedure.spr_at_GetUserActivity, 
                CommandType.StoredProcedure, new List<SqlParameter>()
            {
                new SqlParameter(){ ParameterName="@UserID",Value=UserID}
            }).DataTableToList<SecondaryActivity>();
            return secondaryActivities;
        }

        public List<SecondaryActivity> GetUserParentActivity(string ActivityIDs)
        {
            List<SecondaryActivity> secondaryActivities = null;
            secondaryActivities = _DBProvider.GetDataTable(PredefinedStoreProcedure.spr_at_UserParentActivity,
                CommandType.StoredProcedure, new List<SqlParameter>()
            {
                new SqlParameter(){ ParameterName="@ActivityIDs",Value=ActivityIDs}
            }).DataTableToList<SecondaryActivity>();
            return secondaryActivities;
        }
    }
}
