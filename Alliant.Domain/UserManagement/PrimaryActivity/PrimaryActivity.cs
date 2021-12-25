using System;

namespace Alliant.Domain
{
    public class PrimaryActivity : RootEntity
    {
    	public virtual int PrimaryActivityID { get; set; }
    
    	public virtual int RoleID { get; set; }
    
    	public virtual Nullable<int> PermissionID { get; set; }
    
    	public virtual string ActivityName { get; set; }
    
    	public virtual bool IsActive { get; set; }
    
    	public virtual Nullable<DateTime> CreatedOn { get; set; }
    
    	public virtual string CreatedBy { get; set; }    
    
    }
    
    public class Search_PrimaryActivityModel : RootSearch_Model
    {
    	public virtual string PrimaryActivityID_Values { get; set; }
    	
    	public virtual Nullable<int> PrimaryActivityID_Min { get; set; }
    	
    	public virtual Nullable<int> PrimaryActivityID_Max { get; set; }
    	
    	public virtual string RoleID_Values { get; set; }
    	
    	public virtual Nullable<int> RoleID_Min { get; set; }
    	
    	public virtual Nullable<int> RoleID_Max { get; set; }
    	
    	public virtual string PermissionID_Values { get; set; }
    	
    	public virtual Nullable<int> PermissionID_Min { get; set; }
    	
    	public virtual Nullable<int> PermissionID_Max { get; set; }
    	
    	public virtual string ActivityName { get; set; }
    	
    	public virtual string ActivityName_Values { get; set; }
    	
    	public virtual Nullable<bool> IsActive { get; set; }
    	
    	public virtual string CreatedOn_Values { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Min { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Max { get; set; }
    	
    	public virtual string CreatedBy { get; set; }
    	
    	public virtual string CreatedBy_Values { get; set; }
    	public Search_PrimaryActivityModel() { }
    }
    
}
