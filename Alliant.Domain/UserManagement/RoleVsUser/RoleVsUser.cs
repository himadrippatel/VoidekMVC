using System;

namespace Alliant.Domain
{
    public class RoleVsUser : RootEntity
    {
        public virtual int RoleVsUserID { get; set; }

        public virtual int RoleID { get; set; }

        public virtual int UserID { get; set; }

        public virtual Nullable<System.DateTime> StartDate { get; set; }

        public virtual Nullable<System.DateTime> ExpiryDate { get; set; }

        public virtual Nullable<System.DateTime> CreatedOn { get; set; }

        public virtual string CreatedBy { get; set; }

        public virtual Nullable<System.DateTime> UpdatedOn { get; set; }

        public virtual string UpdatedBy { get; set; }

        public virtual string RoleName { get; set; }
        public virtual string CustomerName { get; set; }
        public virtual string CustomerNameCode { get; set; }

    }

    public class Search_RoleVsUserModel : RootSearch_Model
    {
        public virtual string RoleVsUserID_Values { get; set; }

        public virtual Nullable<int> RoleVsUserID_Min { get; set; }

        public virtual Nullable<int> RoleVsUserID_Max { get; set; }

        public virtual string RoleID_Values { get; set; }

        public virtual Nullable<int> RoleID_Min { get; set; }

        public virtual Nullable<int> RoleID_Max { get; set; }

        public virtual string UserID_Values { get; set; }

        public virtual Nullable<int> UserID_Min { get; set; }

        public virtual Nullable<int> UserID_Max { get; set; }

        public virtual string StartDate_Values { get; set; }

        public virtual Nullable<System.DateTime> StartDate_Min { get; set; }

        public virtual Nullable<System.DateTime> StartDate_Max { get; set; }

        public virtual string ExpiryDate_Values { get; set; }

        public virtual Nullable<System.DateTime> ExpiryDate_Min { get; set; }

        public virtual Nullable<System.DateTime> ExpiryDate_Max { get; set; }

        public virtual string CreatedOn_Values { get; set; }

        public virtual Nullable<System.DateTime> CreatedOn_Min { get; set; }

        public virtual Nullable<System.DateTime> CreatedOn_Max { get; set; }

        public virtual string CreatedBy { get; set; }

        public virtual string CreatedBy_Values { get; set; }

        public virtual string UpdatedOn_Values { get; set; }

        public virtual Nullable<System.DateTime> UpdatedOn_Min { get; set; }

        public virtual Nullable<System.DateTime> UpdatedOn_Max { get; set; }

        public virtual string UpdatedBy { get; set; }

        public virtual string UpdatedBy_Values { get; set; }
        public Search_RoleVsUserModel() { }
    }

}
