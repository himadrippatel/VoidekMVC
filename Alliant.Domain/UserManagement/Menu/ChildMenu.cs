using System;

namespace Alliant.Domain
{
    public class ChildMenu : RootEntity
    {
        public virtual int SubMenuID { get; set; }

        public virtual int MenuID { get; set; }

        public virtual Nullable<int> ParentID { get; set; }

        public virtual string LinkText { get; set; }

        public virtual string Description { get; set; }

        public virtual string ActionName { get; set; }

        public virtual string ControllerName { get; set; }

        public virtual string HtmlAttributes { get; set; }

        public virtual string RouteData { get; set; }

        public virtual bool IsActive { get; set; }

        public virtual Nullable<int> Sequance { get; set; }

        public virtual string ActivityName { get; set; }

        public virtual Nullable<System.DateTime> CreatedOn { get; set; }

        public virtual string CreatedBy { get; set; }

        public virtual Nullable<System.DateTime> UpdatedOn { get; set; }

        public virtual string UpdatedBy { get; set; }


    }

    public class Search_ChildMenuModel : RootSearch_Model
    {
        public virtual string SubMenuID_Values { get; set; }

        public virtual Nullable<int> SubMenuID_Min { get; set; }

        public virtual Nullable<int> SubMenuID_Max { get; set; }

        public virtual string MenuID_Values { get; set; }

        public virtual Nullable<int> MenuID_Min { get; set; }

        public virtual Nullable<int> MenuID_Max { get; set; }

        public virtual string ParentID_Values { get; set; }

        public virtual Nullable<int> ParentID_Min { get; set; }

        public virtual Nullable<int> ParentID_Max { get; set; }

        public virtual string LinkText { get; set; }

        public virtual string LinkText_Values { get; set; }

        public virtual string Description { get; set; }

        public virtual string Description_Values { get; set; }

        public virtual string ActionName { get; set; }

        public virtual string ActionName_Values { get; set; }

        public virtual string ControllerName { get; set; }

        public virtual string ControllerName_Values { get; set; }

        public virtual string HtmlAttributes { get; set; }

        public virtual string HtmlAttributes_Values { get; set; }

        public virtual string RouteData { get; set; }

        public virtual string RouteData_Values { get; set; }

        public virtual Nullable<bool> IsActive { get; set; }

        public virtual string Sequance_Values { get; set; }

        public virtual Nullable<int> Sequance_Min { get; set; }

        public virtual Nullable<int> Sequance_Max { get; set; }

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
        public Search_ChildMenuModel() { }
    }
}
