using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface IRoleVsActivityManager : IRootManager
    {
        RoleVsActivity Create();
        bool CreatePost(RoleVsActivityViewModel roleVsActivityView);    	
    	int DeletePost(int Id);
    	//IEnumerable<RoleVsActivity> GetAllRoleVsActivity(Search_RoleVsActivityModel oRoleVsActivity);   
    	IEnumerable<RoleVsActivity> GetAllRoleVsActivity(GridSearchModel oGridSearchModel);   
    }
}
