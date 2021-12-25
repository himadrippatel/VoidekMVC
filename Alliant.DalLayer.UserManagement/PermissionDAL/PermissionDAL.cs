using Alliant.Domain;
using System.Collections.Generic;
using System.Linq;

namespace Alliant.DalLayer
{
    public class PermissionDAL : CommonDAL, IPermissionDAL
    {    	
    	
    	public virtual int CreatePermission(Permission oPermission)
    	{ 	    		
    		int? oResultID = 0;
    		int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Permission_Insert(ref oResultID,oPermission.Name, oPermission.RoleID, oPermission.ParentID, oPermission.IsActive, oPermission.CreatedOn, oPermission.CreatedBy, oPermission.UpdatedOn, oPermission.UpdatedBy);
    		oPermission.PermissionID = (int)oResultID;
            return Result;		      
    	}
    
    	public virtual int UpdatePermission(Permission oPermission)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Permission_Update(oPermission.PermissionID, oPermission.Name, oPermission.RoleID, oPermission.ParentID, oPermission.IsActive, oPermission.CreatedOn, oPermission.CreatedBy, oPermission.UpdatedOn, oPermission.UpdatedBy);
            return oResult;
        }
    
    	public virtual int DeleteByModelPermission(Permission pPermission)
    	{		
    		int oResult = 0;
    		//Custom code genrate here
            return oResult;
        }
    
    	public virtual int DeletePermission(int Id)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Permission_Delete(Id);
            return oResult;
        }
    
    	public virtual Permission GetPermissionById(int Id)
    	{
    		var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Permission_GetByID(Id).FirstOrDefault();
    		return oResult;	
    	}	    
    		
    
    	/*public virtual IEnumerable<Permission> GetPermissionBySearch(Search_PermissionModel oSearch_PermissionModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Permission_Search(ref oResultCount,oSearch_PermissionModel.PermissionID_Values, oSearch_PermissionModel.PermissionID_Min, oSearch_PermissionModel.PermissionID_Max, oSearch_PermissionModel.Name, oSearch_PermissionModel.Name_Values, oSearch_PermissionModel.RoleID_Values, oSearch_PermissionModel.RoleID_Min, oSearch_PermissionModel.RoleID_Max, oSearch_PermissionModel.ParentID_Values, oSearch_PermissionModel.ParentID_Min, oSearch_PermissionModel.ParentID_Max, oSearch_PermissionModel.IsActive, oSearch_PermissionModel.CreatedOn_Values, oSearch_PermissionModel.CreatedOn_Min, oSearch_PermissionModel.CreatedOn_Max, oSearch_PermissionModel.CreatedBy, oSearch_PermissionModel.CreatedBy_Values, oSearch_PermissionModel.UpdatedOn_Values, oSearch_PermissionModel.UpdatedOn_Min, oSearch_PermissionModel.UpdatedOn_Max, oSearch_PermissionModel.UpdatedBy, oSearch_PermissionModel.UpdatedBy_Values,oSearch_PermissionModel.Page_Size,oSearch_PermissionModel.Page_Index,oSearch_PermissionModel.Sort_Column,oSearch_PermissionModel.Sort_Ascending,oSearch_PermissionModel.IsBinaryRequired,oSearch_PermissionModel.IsPrimaryIN);
             oSearch_PermissionModel.ResultCount = oResultCount; 
             return oResult;
    	}*/
    
    	public virtual IEnumerable<Permission> GetPermissionBySearch(GridSearchModel oGridSearchModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Permission_Search(ref oResultCount,oGridSearchModel.Page,oGridSearchModel.PageSize,oGridSearchModel.Filter,oGridSearchModel.SortOrder);
             oGridSearchModel.ResultCount = oResultCount; 
             return oResult;
    	}
    }
}
