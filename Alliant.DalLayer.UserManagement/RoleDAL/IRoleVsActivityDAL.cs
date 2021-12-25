using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface IRoleVsActivityDAL : IDALBase
    {
        int CreateRoleVsActivity(RoleVsActivity oRoleVsActivity);
        int DeleteRoleVsActivity(int Id);
    	IEnumerable<RoleVsActivity> GetRoleVsActivityBySearch(GridSearchModel oGridSearchModel);
    }
}
