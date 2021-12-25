using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface IPermissionDAL : IDALBase
    {
        int CreatePermission(Permission oPermission);
        int UpdatePermission(Permission oPermission);
    	int DeleteByModelPermission(Permission oPermission);
    	int DeletePermission(int Id);
    	Permission GetPermissionById(int Id);
        //IEnumerable<Permission> GetPermissionBySearch(Search_PermissionModel oSearch_PermissionModel);  
    	IEnumerable<Permission> GetPermissionBySearch(GridSearchModel oGridSearchModel);
    }
}
