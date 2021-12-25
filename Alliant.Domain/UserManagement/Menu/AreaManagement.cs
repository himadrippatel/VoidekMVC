using System;

namespace Alliant.Domain
{
    public class AreaManagement : RootEntity
    {
    	public virtual int AreaID { get; set; }
    
    	public virtual string Name { get; set; }

        public virtual string ActivityName { get; set; }

        public virtual bool IsActive { get; set; }
    
    	public virtual Nullable<DateTime> CreatedOn { get; set; }
    
    	public virtual string CreatedBy { get; set; }
    
    	public virtual Nullable<DateTime> UpdatedOn { get; set; }
    
    	public virtual string UpdatedBy { get; set; }    
    
    }
    
    public class Search_AreaManagementModel : RootSearch_Model
    {
    	public virtual string AreaID_Values { get; set; }
    	
    	public virtual Nullable<int> AreaID_Min { get; set; }
    	
    	public virtual Nullable<int> AreaID_Max { get; set; }
    	
    	public virtual string Name { get; set; }
    	
    	public virtual string Name_Values { get; set; }
    	
    	public virtual Nullable<bool> IsActive { get; set; }
    	
    	public virtual string CreatedOn_Values { get; set; }
    	
    	public virtual Nullable<DateTime> CreatedOn_Min { get; set; }
    	
    	public virtual Nullable<DateTime> CreatedOn_Max { get; set; }
    	
    	public virtual string CreatedBy { get; set; }
    	
    	public virtual string CreatedBy_Values { get; set; }
    	
    	public virtual string UpdatedOn_Values { get; set; }
    	
    	public virtual Nullable<DateTime> UpdatedOn_Min { get; set; }
    	
    	public virtual Nullable<DateTime> UpdatedOn_Max { get; set; }
    	
    	public virtual string UpdatedBy { get; set; }
    	
    	public virtual string UpdatedBy_Values { get; set; }
    	public Search_AreaManagementModel() { }
    }
    
}
