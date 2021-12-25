using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;
using System.Linq;

namespace Alliant.DalLayer
{
    public class RoleVsUserDAL : CommonDAL, IRoleVsUserDAL
    {    	
    	
    	public virtual int CreateRoleVsUser(RoleVsUser oRoleVsUser)
    	{ 	
    		
    		int? oResultID = 0;
    		int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsUser_Insert(ref oResultID,oRoleVsUser.RoleID, oRoleVsUser.UserID, oRoleVsUser.StartDate, oRoleVsUser.ExpiryDate, oRoleVsUser.CreatedOn, oRoleVsUser.CreatedBy, oRoleVsUser.UpdatedOn, oRoleVsUser.UpdatedBy);
    		oRoleVsUser.RoleVsUserID = (int)oResultID;
            return Result;		      
    	}
    
    	public virtual int UpdateRoleVsUser(RoleVsUser oRoleVsUser)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsUser_Update(oRoleVsUser.RoleVsUserID, oRoleVsUser.RoleID, oRoleVsUser.UserID, oRoleVsUser.StartDate, oRoleVsUser.ExpiryDate, oRoleVsUser.CreatedOn, oRoleVsUser.CreatedBy, oRoleVsUser.UpdatedOn, oRoleVsUser.UpdatedBy);
            return oResult;
        }
    
    	public virtual int DeleteByModelRoleVsUser(RoleVsUser pRoleVsUser)
    	{		
    		int oResult = 0;
    		//Custom code genrate here
            return oResult;
        }
    
    	public virtual int DeleteRoleVsUser(int Id)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsUser_Delete(Id);
            return oResult;
        }
    
    	public virtual RoleVsUser GetRoleVsUserById(int Id)
    	{
    		var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsUser_GetByID(Id).FirstOrDefault();
    		return oResult;	
    	}  
    		
    
    	/*public virtual IEnumerable<RoleVsUser> GetRoleVsUserBySearch(Search_RoleVsUserModel oSearch_RoleVsUserModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsUser_Search(ref oResultCount,oSearch_RoleVsUserModel.RoleVsUserID_Values, oSearch_RoleVsUserModel.RoleVsUserID_Min, oSearch_RoleVsUserModel.RoleVsUserID_Max, oSearch_RoleVsUserModel.RoleID_Values, oSearch_RoleVsUserModel.RoleID_Min, oSearch_RoleVsUserModel.RoleID_Max, oSearch_RoleVsUserModel.UserID_Values, oSearch_RoleVsUserModel.UserID_Min, oSearch_RoleVsUserModel.UserID_Max, oSearch_RoleVsUserModel.StartDate_Values, oSearch_RoleVsUserModel.StartDate_Min, oSearch_RoleVsUserModel.StartDate_Max, oSearch_RoleVsUserModel.ExpiryDate_Values, oSearch_RoleVsUserModel.ExpiryDate_Min, oSearch_RoleVsUserModel.ExpiryDate_Max, oSearch_RoleVsUserModel.CreatedOn_Values, oSearch_RoleVsUserModel.CreatedOn_Min, oSearch_RoleVsUserModel.CreatedOn_Max, oSearch_RoleVsUserModel.CreatedBy, oSearch_RoleVsUserModel.CreatedBy_Values, oSearch_RoleVsUserModel.UpdatedOn_Values, oSearch_RoleVsUserModel.UpdatedOn_Min, oSearch_RoleVsUserModel.UpdatedOn_Max, oSearch_RoleVsUserModel.UpdatedBy, oSearch_RoleVsUserModel.UpdatedBy_Values,oSearch_RoleVsUserModel.Page_Size,oSearch_RoleVsUserModel.Page_Index,oSearch_RoleVsUserModel.Sort_Column,oSearch_RoleVsUserModel.Sort_Ascending,oSearch_RoleVsUserModel.IsBinaryRequired,oSearch_RoleVsUserModel.IsPrimaryIN);
             oSearch_RoleVsUserModel.ResultCount = oResultCount; 
             return oResult;
    	}*/
    
    	public virtual IEnumerable<RoleVsUser> GetRoleVsUserBySearch(GridSearchModel oGridSearchModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsUser_Search(ref oResultCount,oGridSearchModel.Page,oGridSearchModel.PageSize,oGridSearchModel.Filter,oGridSearchModel.SortOrder);
             oGridSearchModel.ResultCount = oResultCount; 
             return oResult;
    	}

        public virtual IEnumerable<AutoCompleteViewModel> GetCustomerAutoCompleteViewModels(string search, string notIn)
        {
            return _StoreProcedure.StoreProcedureUserManagement.spr_tb_tblCustomers_AutoComplete(search, notIn);
        }

        public virtual SelectViewModel GetCustomerSelectViewModels(SearchRequest searchRequest)
        {
            SelectViewModel selectViewModel = new SelectViewModel();
            int? oResultCount = 0;
            selectViewModel.items = _StoreProcedure.StoreProcedureUserManagement.spr_tb_tblCustomers_Select(searchRequest.search,searchRequest.page,searchRequest.pageResult,ref oResultCount).ToList();
            selectViewModel.total_count = oResultCount;
            return selectViewModel;
        }
    }
}
