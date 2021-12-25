using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.DalLayer
{
    public interface IRoleDAL : IDALBase
    {
        int CreateRole(Role oRole);
        int UpdateRole(Role oRole);
        int DeleteByModelRole(Role oRole);
        int DeleteRole(int Id);
        Role GetRoleById(int Id);
        IEnumerable<Role> GetRoleBySearch(Search_RoleModel oSearch_RoleModel);
        IEnumerable<Role> GetRoleBySearchV2(GridSearchModel gridSearchModel);
        IEnumerable<HierarchicalViewModel> GetRoleHierarchicalViewModel(int? Id);
        IEnumerable<Role> GetRoleHierarchy(int? Id);
        SelectViewModel GetRoleSelectViewModels(SearchRequest searchRequest);
    }
}
