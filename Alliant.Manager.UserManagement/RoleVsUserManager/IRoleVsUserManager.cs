using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface IRoleVsUserManager : IRootManager
    {
        RoleVsUser Create();
        bool CreatePost(RoleVsUserViewModel roleVsUserViewModel);
    	RoleVsUser Edit(int Id);
    	RoleVsUser EditPost(RoleVsUser oRoleVsUser);
    	RoleVsUser Delete(int Id);
    	int DeletePost(int Id);
    	RoleVsUser GetRoleVsUserById(int Id);
    	//IEnumerable<RoleVsUser> GetAllRoleVsUser(Search_RoleVsUserModel oRoleVsUser);   
    	IEnumerable<RoleVsUser> GetAllRoleVsUser(GridSearchModel oGridSearchModel);
        IEnumerable<AutoCompleteViewModel> GetCustomerAutoCompleteViewModels(string search, string notIn);
        SelectViewModel GetCustomerSelectViewModels(SearchRequest searchRequest);
    }
}
