using Alliant.Domain;
using Alliant.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Alliant.DalLayer
{
    public class RoleDAL : CommonDAL, IRoleDAL
    {

        public virtual int CreateRole(Role oRole)
        {
            var oProcessingDateTime = DateTime.UtcNow;
            int? oResultID = 0;
            int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_Insert(ref oResultID, oRole.Name, oRole.ParentID, oRole.IsActive, oRole.CreatedOn, oRole.CreatedBy, oRole.UpdatedOn, oRole.UpdatedBy, oProcessingDateTime);
            oRole.RoleID = (int)oResultID;
            return oResult;        
        }

        public virtual int UpdateRole(Role oRole)
        {
            var oProcessingDateTime = DateTime.UtcNow;
            int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_Update(oRole.RoleID, oRole.Name, oRole.ParentID, oRole.IsActive, oRole.CreatedOn, oRole.CreatedBy, oRole.UpdatedOn, oRole.UpdatedBy, oProcessingDateTime);
            return oResult;          
        }

        public virtual int DeleteByModelRole(Role pRole)
        {
            int oResult = 0;
            //Custom code genrate here
            return oResult;
        }

        public virtual int DeleteRole(int Id)
        {           
            int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_Delete(Id);
            return oResult;
        }

        public virtual Role GetRoleById(int Id)
        {
            Role oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_GetByID(Id)?.FirstOrDefault();
            return oResult;
        }

        public virtual IEnumerable<Role> GetRoleBySearch(Search_RoleModel oSearch_RoleModel)
        {
            int? oResultCount = 0;
            var oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_SearchAll(ref oResultCount, oSearch_RoleModel.RoleID_Values, oSearch_RoleModel.RoleID_Min, oSearch_RoleModel.RoleID_Max, oSearch_RoleModel.Name, oSearch_RoleModel.Name_Values, oSearch_RoleModel.ParentID_Values, oSearch_RoleModel.ParentID_Min, oSearch_RoleModel.ParentID_Max, oSearch_RoleModel.IsActive, oSearch_RoleModel.CreatedOn_Values, oSearch_RoleModel.CreatedOn_Min, oSearch_RoleModel.CreatedOn_Max, oSearch_RoleModel.CreatedBy, oSearch_RoleModel.CreatedBy_Values, oSearch_RoleModel.UpdatedOn_Values, oSearch_RoleModel.UpdatedOn_Min, oSearch_RoleModel.UpdatedOn_Max, oSearch_RoleModel.UpdatedBy, oSearch_RoleModel.UpdatedBy_Values, oSearch_RoleModel.Page_Size, oSearch_RoleModel.Page_Index, oSearch_RoleModel.Sort_Column, oSearch_RoleModel.Sort_Ascending, oSearch_RoleModel.IsBinaryRequired, oSearch_RoleModel.IsPrimaryIN);
            oSearch_RoleModel.ResultCount = oResultCount;
            return oResult;           
        }

        public virtual IEnumerable<HierarchicalViewModel> GetRoleHierarchicalViewModel(int? Id)
        {
            return _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_DropdwonHierarchy(Id);
        }

        public virtual IEnumerable<Role> GetRoleBySearchV2(GridSearchModel gridSearchModel)
        {
            int? oResultCount = 0;
            var oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_SearchAll_V2(ref oResultCount,gridSearchModel.Page,gridSearchModel.PageSize,gridSearchModel.Filter,gridSearchModel.SortOrder);
            gridSearchModel.ResultCount = oResultCount;
            return oResult;
        }

        public virtual IEnumerable<Role> GetRoleHierarchy(int? Id)
        {
            return _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_Hierarchy(Id);
        }

        public virtual SelectViewModel GetRoleSelectViewModels(SearchRequest searchRequest)
        {
            SelectViewModel selectViewModel = new SelectViewModel();
            int? oResultCount = 0;
            selectViewModel.items = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Role_Select(searchRequest.search, searchRequest.page, searchRequest.pageResult, searchRequest.notIn, ref oResultCount).ToList();
            selectViewModel.total_count = oResultCount;
            return selectViewModel;
        }
    }
}
