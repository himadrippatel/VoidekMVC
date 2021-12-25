using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface IRoleVsUserDAL : IDALBase
    {
        int CreateRoleVsUser(RoleVsUser oRoleVsUser);
        int UpdateRoleVsUser(RoleVsUser oRoleVsUser);
    	int DeleteByModelRoleVsUser(RoleVsUser oRoleVsUser);
    	int DeleteRoleVsUser(int Id);
    	RoleVsUser GetRoleVsUserById(int Id);
        //IEnumerable<RoleVsUser> GetRoleVsUserBySearch(Search_RoleVsUserModel oSearch_RoleVsUserModel);  
    	IEnumerable<RoleVsUser> GetRoleVsUserBySearch(GridSearchModel oGridSearchModel);
        IEnumerable<AutoCompleteViewModel> GetCustomerAutoCompleteViewModels(string search, string notIn);
        SelectViewModel GetCustomerSelectViewModels(SearchRequest searchRequest);
    }
}
