using System;

namespace Alliant.Domain
{
    public class SecondaryActivity : RootEntity
    {
    	public virtual int SecondaryActivityID { get; set; }
    
    	public virtual int PrimaryActivityID { get; set; }
    
    	public virtual int ActivityID { get; set; }
    
    	public virtual Nullable<System.DateTime> CreatedOn { get; set; }
    
    	public virtual string CreatedBy { get; set; }

        public virtual string ParentActivity { get; set; }

        public virtual string ActivityName { get; set; }
    }
    
    public class Search_SecondaryActivityModel : RootSearch_Model
    {
    	public virtual string SecondaryActivityID_Values { get; set; }
    	
    	public virtual Nullable<int> SecondaryActivityID_Min { get; set; }
    	
    	public virtual Nullable<int> SecondaryActivityID_Max { get; set; }
    	
    	public virtual string PrimaryActivityID_Values { get; set; }
    	
    	public virtual Nullable<int> PrimaryActivityID_Min { get; set; }
    	
    	public virtual Nullable<int> PrimaryActivityID_Max { get; set; }
    	
    	public virtual string ActivityName { get; set; }
    	
    	public virtual string ActivityName_Values { get; set; }
    	
    	public virtual string CreatedOn_Values { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Min { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Max { get; set; }
    	
    	public virtual string CreatedBy { get; set; }
    	
    	public virtual string CreatedBy_Values { get; set; }
    	public Search_SecondaryActivityModel() { }
    }
    
}
