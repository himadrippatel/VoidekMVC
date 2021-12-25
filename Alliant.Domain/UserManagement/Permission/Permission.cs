using System;

namespace Alliant.Domain
{
    public class Permission : RootEntity
    {
        public virtual int PermissionID { get; set; }

        public virtual string Name { get; set; }

        public virtual int RoleID { get; set; }

        public virtual Nullable<int> ParentID { get; set; }

        public virtual bool IsActive { get; set; }

        public virtual Nullable<System.DateTime> CreatedOn { get; set; }

        public virtual string CreatedBy { get; set; }

        public virtual Nullable<System.DateTime> UpdatedOn { get; set; }

        public virtual string UpdatedBy { get; set; }


    }

    public class Search_PermissionModel : RootSearch_Model
    {
        public virtual string PermissionID_Values { get; set; }

        public virtual Nullable<int> PermissionID_Min { get; set; }

        public virtual Nullable<int> PermissionID_Max { get; set; }

        public virtual string Name { get; set; }

        public virtual string Name_Values { get; set; }

        public virtual string RoleID_Values { get; set; }

        public virtual Nullable<int> RoleID_Min { get; set; }

        public virtual Nullable<int> RoleID_Max { get; set; }

        public virtual string ParentID_Values { get; set; }

        public virtual Nullable<int> ParentID_Min { get; set; }

        public virtual Nullable<int> ParentID_Max { get; set; }

        public virtual Nullable<bool> IsActive { get; set; }

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
        public Search_PermissionModel() { }
    }
}
