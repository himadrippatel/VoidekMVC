using System;

namespace Alliant.Domain
{
    public class LoginCustomer
    {
        public int CustID { get; set; }
        public string Inactive { get; set; }
        public string OnHold { get; set; }
        public string IsVendor { get; set; }
        public string VendorType { get; set; }
        public string Customer { get; set; }
        public string WebAddress { get; set; }
        public string Address { get; set; }
        public string AddrCity { get; set; }
        public string AddrState { get; set; }
        public string AddrZip { get; set; }
        public string Phone { get; set; }
        public string creditauth { get; set; }
        public string creditapp { get; set; }
        public string Account_Rep { get; set; }
        public string UrgentNotes { get; set; }
        public bool donotcontact { get; set; }
        public DateTime? DonotContactDate { get; set; }
        public string DoNotContactBy { get; set; }
        public int CustAccountRep { get; set; }
        public string Email { get; set; }
        public string Imageurl { get; set; }
    }
}
