using System;

namespace Alliant.Domain
{
    public class Icon : RootEntity
    {
    	public virtual int IconID { get; set; }
    
    	public virtual string ICon { get; set; }
    
    	public virtual string IconName { get; set; }
    
    	public virtual bool IsActive { get; set; }
    
    	public virtual Nullable<System.DateTime> CreatedOn { get; set; }
    
    	public virtual string CreatedBy { get; set; }
    }
    
    public class Search_IconModel : RootSearch_Model
    {
    	public virtual string IconID_Values { get; set; }
    	
    	public virtual Nullable<int> IconID_Min { get; set; }
    	
    	public virtual Nullable<int> IconID_Max { get; set; }
    	
    	public virtual string ICon { get; set; }
    	
    	public virtual string ICon_Values { get; set; }
    	
    	public virtual string IconName { get; set; }
    	
    	public virtual string IconName_Values { get; set; }
    	
    	public virtual Nullable<bool> IsActive { get; set; }
    	
    	public virtual string CreatedOn_Values { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Min { get; set; }
    	
    	public virtual Nullable<System.DateTime> CreatedOn_Max { get; set; }
    	
    	public virtual string CreatedBy { get; set; }
    	
    	public virtual string CreatedBy_Values { get; set; }
    	public Search_IconModel() { }
    }
    
}
