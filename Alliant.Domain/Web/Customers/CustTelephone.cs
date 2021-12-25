using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Alliant.Domain
{
    public class CustTelephone : RootEntity
    {
        public int PhoneID { get; set; }
        public int CustID { get; set; }
        public int ContactID { get; set; }
        public int EmployeeID { get; set; }
        public int VendorID { get; set; }
        public int PhoneTypeID { get; set; }
        public string PhoneNumber { get; set; }
    }
}
