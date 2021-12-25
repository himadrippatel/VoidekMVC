using Alliant.DalLayer;
using Alliant.Domain;
using System;
using System.Collections.Generic;

namespace Alliant.Manager
{
                      
    public class PermissionManager : DALProvider,IPermissionManager
    {
    	IPermissionDAL oPermissionDal =  null;  
    
    	public PermissionManager()
    	{
    		oPermissionDal = DALUserManagement.PermissionDAL;
    	}
    
    	public virtual Permission Create()
    	{
    		return new Permission();
    	}
    
        public virtual Permission CreatePost(Permission oPermission)
    	{
            oPermission.CreatedOn = DateTime.Now;
            oPermission.UpdatedOn = DateTime.Now;
            oPermissionDal.CreatePermission(oPermission);
    		return oPermission;
    	}
    
    	public virtual Permission Edit(int Id)
    	{
    		return oPermissionDal.GetPermissionById(Id);
    	}
    
    	public virtual Permission EditPost(Permission oPermission)
    	{
            oPermission.UpdatedOn = DateTime.Now;
            oPermissionDal.UpdatePermission(oPermission);
    		return oPermission;
    	}
    
    	public virtual Permission Delete(int Id)
    	{
    		return oPermissionDal.GetPermissionById(Id);
    	}
    
    	public virtual int DeletePost(int Id)
    	{
    		return oPermissionDal.DeletePermission(Id);
    	}
    
    	public virtual Permission GetPermissionById(int Id)
    	{
    		return oPermissionDal.GetPermissionById(Id);
    	}
    
    	/*public virtual IEnumerable<Permission> GetAllPermission(Search_PermissionModel oPermission)
    	{
    		return oPermissionDal.GetPermissionBySearch(oPermission);
    	}*/  
    	
    	public virtual IEnumerable<Permission> GetAllPermission(GridSearchModel oGridSearchModel)
    	{
    		return oPermissionDal.GetPermissionBySearch(oGridSearchModel);
    	}
    }
}
