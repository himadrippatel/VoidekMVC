using System;

namespace Alliant.Domain
{
    public class ActivityVsUser : RootEntity
    {
    	public virtual int UserActivityID { get; set; }
    
    	public virtual int ActivityID { get; set; }
    
    	public virtual int UserID { get; set; }
    
    	public virtual bool IsActive { get; set; }

        public virtual string ActivityName { get; set; }

        public virtual string CustomerName { get; set; }

        public virtual Nullable<System.DateTime> CreatedOn { get; set; }
    
    	public virtual string CreatedBy { get; set; }    
    
    }
    
    public class Search_ActivityVsUserModel : RootSearch_Model
    {
    	public virtual string UserActivityID_Values { get; set; }
    	
    	public virtual Nullable<int> UserActivityID_Min { get; set; }
    	
    	public virtual Nullable<int> UserActivityID_Max { get; set; }
    	
    	public virtual string ActivityID_Values { get; set; }
    	
    	public virtual Nullable<int> ActivityID_Min { get; set; }
    	
    	public virtual Nullable<int> ActivityID_Max { get; set; }
    	
    	public virtual string UserID_Values { get; set; }
    	
    	public virtual Nullable<int> UserID_Min { get; set; }
    	
    	public virtual Nullable<int> UserID_Max { get; set; }
    	
    	public virtual Nullable<bool> IsActive { get; set; }
    	
    	public virtual string CreatedOn_Values { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Min { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Max { get; set; }
    	
    	public virtual string CreatedBy { get; set; }
    	
    	public virtual string CreatedBy_Values { get; set; }
    	public Search_ActivityVsUserModel() { }
    }
    
}
