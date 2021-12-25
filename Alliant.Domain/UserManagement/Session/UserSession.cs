using System;
using System.Collections.Generic;

namespace Alliant.Domain
{
    public class UserSession : RootEntity
    {
        public long UserSessionID { get; set; }

        public int UserID { get; set; }

        public string SessionData { get; set; }

        public string Token { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? LastAccessOn { get; set; }

        public string RequestIP { get; set; }

        public string Session_Token { get; set; }
        public bool IsSuperAdminLoggedIn { get; set; }
        public bool IsAdminLoggedIn { get; set; }


        #region UserDetail
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
        #endregion

        #region UserActivities
        public IDictionary<string,bool> dtUserActivities { get; set; }
        #endregion

    }
}
