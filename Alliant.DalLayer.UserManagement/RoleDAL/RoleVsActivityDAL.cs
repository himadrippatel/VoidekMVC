using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{
    public class RoleVsActivityDAL : CommonDAL, IRoleVsActivityDAL
    {
    	public virtual int CreateRoleVsActivity(RoleVsActivity oRoleVsActivity)
    	{ 	
    		
    		int? oResultID = 0;
    		int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsActivity_Insert(ref oResultID,oRoleVsActivity.RoleID, oRoleVsActivity.ActivityID, oRoleVsActivity.IsActive, oRoleVsActivity.CreatedOn, oRoleVsActivity.CreatedBy);
    		oRoleVsActivity.RoleVsActivityID = (int)oResultID;
            return Result;		      
    	}
    
    	public virtual int DeleteRoleVsActivity(int Id)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsActivity_Delete(Id);
            return oResult;
        }
    
    	/*public virtual IEnumerable<RoleVsActivity> GetRoleVsActivityBySearch(Search_RoleVsActivityModel oSearch_RoleVsActivityModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsActivity_Search(ref oResultCount,oSearch_RoleVsActivityModel.RoleVsActivityID_Values, oSearch_RoleVsActivityModel.RoleVsActivityID_Min, oSearch_RoleVsActivityModel.RoleVsActivityID_Max, oSearch_RoleVsActivityModel.RoleID_Values, oSearch_RoleVsActivityModel.RoleID_Min, oSearch_RoleVsActivityModel.RoleID_Max, oSearch_RoleVsActivityModel.ActivityID_Values, oSearch_RoleVsActivityModel.ActivityID_Min, oSearch_RoleVsActivityModel.ActivityID_Max, oSearch_RoleVsActivityModel.IsActive, oSearch_RoleVsActivityModel.CreatedOn_Values, oSearch_RoleVsActivityModel.CreatedOn_Min, oSearch_RoleVsActivityModel.CreatedOn_Max, oSearch_RoleVsActivityModel.CreatedBy, oSearch_RoleVsActivityModel.CreatedBy_Values,oSearch_RoleVsActivityModel.Page_Size,oSearch_RoleVsActivityModel.Page_Index,oSearch_RoleVsActivityModel.Sort_Column,oSearch_RoleVsActivityModel.Sort_Ascending,oSearch_RoleVsActivityModel.IsBinaryRequired,oSearch_RoleVsActivityModel.IsPrimaryIN);
             oSearch_RoleVsActivityModel.ResultCount = oResultCount; 
             return oResult;
    	}*/
    
    	public virtual IEnumerable<RoleVsActivity> GetRoleVsActivityBySearch(GridSearchModel oGridSearchModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_RoleVsActivity_Search(ref oResultCount,oGridSearchModel.Page,oGridSearchModel.PageSize,oGridSearchModel.Filter,oGridSearchModel.SortOrder);
             oGridSearchModel.ResultCount = oResultCount; 
             return oResult;
    	}
    }
}
