using Alliant.Core;
using Alliant.Utility;
using Alliant.Domain;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Alliant.Manager
{
    public class ErrorLogManager : IErrorLogManager
    {
        public virtual void CreateErrorLog(ErrorLog errorLog)
        {
            _DBProvider.ExecuteQuery(PredefinedStoreProcedure.spr_tb_UM_ErrorLog_Insert, CommandType.StoredProcedure, new List<SqlParameter>()
            {
                new SqlParameter(){ ParameterName="@Route",Value=errorLog.Route},
                new SqlParameter(){ ParameterName="@Message", Value=errorLog.Message},
                new SqlParameter(){ ParameterName="@StatckTrace",Value=errorLog.StatckTrace},
                new SqlParameter(){ ParameterName="@UserID",Value=errorLog.UserID},
                new SqlParameter(){ ParameterName="@ConnectionID",Value=errorLog.ConnectionID},
                new SqlParameter(){ ParameterName="@TransactionID",Value=errorLog.TransactionID},
                new SqlParameter(){ ParameterName="@CreatedOn",Value=DateTime.Now},
            });
        }

        public virtual List<ErrorLog> GetErrorLogs()
        {
            List<ErrorLog> errorLogs = _DBProvider.GetDataTable(PredefinedStoreProcedure.spr_tb_UM_ErrorLog_Search, CommandType.StoredProcedure).DataTableToList<ErrorLog>();
            return errorLogs;
        }
    }
}
