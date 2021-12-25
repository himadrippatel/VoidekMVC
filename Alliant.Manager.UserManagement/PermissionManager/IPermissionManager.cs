using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface IPermissionManager : IRootManager
    {
        Permission Create();
        Permission CreatePost(Permission oPermission);
    	Permission Edit(int Id);
    	Permission EditPost(Permission oPermission);
    	Permission Delete(int Id);
    	int DeletePost(int Id);
    	Permission GetPermissionById(int Id);
    	//IEnumerable<Permission> GetAllPermission(Search_PermissionModel oPermission);   
    	IEnumerable<Permission> GetAllPermission(GridSearchModel oGridSearchModel);   
    }
}
