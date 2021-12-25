using System;

namespace Alliant.Domain
{
    public class RoleVsActivity : RootEntity
    {
        public virtual int RoleVsActivityID { get; set; }

        public virtual int RoleID { get; set; }

        public virtual int ActivityID { get; set; }

        public virtual bool IsActive { get; set; }

        public virtual string RoleName { get;set;}

        public virtual string ActivityName { get;set;}
    
    	public virtual Nullable<System.DateTime> CreatedOn { get; set; }
    
    	public virtual string CreatedBy { get; set; }   
    
    }
    
    public class Search_RoleVsActivityModel : RootSearch_Model
    {
    	public virtual string RoleVsActivityID_Values { get; set; }
    	
    	public virtual Nullable<int> RoleVsActivityID_Min { get; set; }
    	
    	public virtual Nullable<int> RoleVsActivityID_Max { get; set; }
    	
    	public virtual string RoleID_Values { get; set; }
    	
    	public virtual Nullable<int> RoleID_Min { get; set; }
    	
    	public virtual Nullable<int> RoleID_Max { get; set; }
    	
    	public virtual string ActivityID_Values { get; set; }
    	
    	public virtual Nullable<int> ActivityID_Min { get; set; }
    	
    	public virtual Nullable<int> ActivityID_Max { get; set; }
    	
    	public virtual Nullable<bool> IsActive { get; set; }
    	
    	public virtual string CreatedOn_Values { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Min { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Max { get; set; }
    	
    	public virtual string CreatedBy { get; set; }
    	
    	public virtual string CreatedBy_Values { get; set; }
    	public Search_RoleVsActivityModel() { }
    }
    
}
