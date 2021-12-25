using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;


namespace Alliant.Manager
{
    public interface IRoleManager : IRootManager
    {
        Role Create();
        Role CreatePost(Role oRole);
        Role Edit(int Id);
        Role EditPost(Role oRole);
        Role Delete(int Id);
        Role DeletePost(int Id);
        Role GetRoleById(int Id);
        IEnumerable<Role> GetAllRole(Search_RoleModel oRole);
        IEnumerable<Role> GetAllRoleV2(GridSearchModel gridSearchModel);
        IEnumerable<HierarchicalViewModel> GetRoleHierarchicalViewModel(int? Id);
        IEnumerable<Role> GetRoleHierarchy(int? Id);
        SelectViewModel GetRoleSelectViewModels(SearchRequest searchRequest);
    }
}
