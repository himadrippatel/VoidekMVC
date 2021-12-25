using Alliant.DalLayer;
using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.Manager
{
    public class RoleManager :DALProvider ,IRoleManager
    {
        IRoleDAL oRoleDal = null;

        public RoleManager()
        {
            oRoleDal = DALUserManagement.RoleDAL;
        }

        public virtual Role Create()
        {
            return new Role();
        }

        public virtual Role CreatePost(Role oRole)
        {
            oRoleDal.CreateRole(oRole);
            return oRole;
        }

        public virtual Role Edit(int Id)
        {
            return oRoleDal.GetRoleById(Id);
        }

        public virtual Role EditPost(Role oRole)
        {
            oRoleDal.UpdateRole(oRole);
            return oRole;
        }

        public virtual Role Delete(int Id)
        {
            return oRoleDal.GetRoleById(Id);
        }

        public virtual Role DeletePost(int Id)
        {
            oRoleDal.DeleteRole(Id);
            return new Role();
        }

        public virtual Role GetRoleById(int Id)
        {
            return new Role();
        }

        public virtual IEnumerable<Role> GetAllRole(Search_RoleModel oRole)
        {
            return oRoleDal.GetRoleBySearch(oRole);
        }

        public virtual IEnumerable<HierarchicalViewModel> GetRoleHierarchicalViewModel(int? Id)
        {
            return oRoleDal.GetRoleHierarchicalViewModel(Id);
        }

        public virtual IEnumerable<Role> GetAllRoleV2(GridSearchModel gridSearchModel)
        {
            return oRoleDal.GetRoleBySearchV2(gridSearchModel);
        }

        public virtual IEnumerable<Role> GetRoleHierarchy(int? Id)
        {
            return oRoleDal.GetRoleHierarchy(Id);
        }

        public virtual SelectViewModel GetRoleSelectViewModels(SearchRequest searchRequest)
        {
            return oRoleDal.GetRoleSelectViewModels(searchRequest);
        }
    }
}
