using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.Manager
{
    public interface IErrorLogManager
    {
        void CreateErrorLog(ErrorLog errorLog);
        List<ErrorLog> GetErrorLogs();
    }
}
