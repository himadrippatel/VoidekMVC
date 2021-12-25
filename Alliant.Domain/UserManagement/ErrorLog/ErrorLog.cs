using System;

namespace Alliant.Domain
{
    public class ErrorLog
    {
        public long ErrorLogID { get; set; }

        public string Route { get; set; }

        public string Message { get; set; }

        public string StatckTrace { get; set; }

        public int? UserID { get; set; }

        public Guid? ConnectionID { get; set; }

        public Guid? TransactionID { get; set; }

        public DateTime? CreatedOn { get; set; }
    }
}
