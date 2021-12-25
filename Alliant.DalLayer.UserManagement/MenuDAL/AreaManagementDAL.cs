using Alliant.Domain;
using System.Collections.Generic;
using System.Linq;

namespace Alliant.DalLayer
{
    public class AreaManagementDAL : CommonDAL, IAreaManagementDAL
    {    	
    	
    	public virtual int CreateAreaManagement(AreaManagement oAreaManagement)
    	{ 	
    		
    		int? oResultID = 0;
    		int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_AreaManagement_Insert(ref oResultID,oAreaManagement.Name,oAreaManagement.ActivityName, oAreaManagement.IsActive, oAreaManagement.CreatedOn, oAreaManagement.CreatedBy, oAreaManagement.UpdatedOn, oAreaManagement.UpdatedBy);
    		oAreaManagement.AreaID = (int)oResultID;
            return Result;		      
    	}
    
    	public virtual int UpdateAreaManagement(AreaManagement oAreaManagement)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_AreaManagement_Update(oAreaManagement.AreaID, oAreaManagement.Name,oAreaManagement.ActivityName, oAreaManagement.IsActive, oAreaManagement.CreatedOn, oAreaManagement.CreatedBy, oAreaManagement.UpdatedOn, oAreaManagement.UpdatedBy);
            return oResult;
        }
    
    	public virtual int DeleteByModelAreaManagement(AreaManagement pAreaManagement)
    	{		
    		int oResult = 0;
    		//Custom code genrate here
            return oResult;
        }
    
    	public virtual int DeleteAreaManagement(int Id)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_AreaManagement_Delete(Id);
            return oResult;
        }
    
    	public virtual AreaManagement GetAreaManagementById(int Id)
    	{
    		var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_AreaManagement_GetByID(Id).FirstOrDefault();
    		return oResult;	
    	}	
    
    		
    
    	/*public virtual IEnumerable<AreaManagement> GetAreaManagementBySearch(Search_AreaManagementModel oSearch_AreaManagementModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_AreaManagement_Search(ref oResultCount,oSearch_AreaManagementModel.AreaID_Values, oSearch_AreaManagementModel.AreaID_Min, oSearch_AreaManagementModel.AreaID_Max, oSearch_AreaManagementModel.Name, oSearch_AreaManagementModel.Name_Values, oSearch_AreaManagementModel.IsActive, oSearch_AreaManagementModel.CreatedOn_Values, oSearch_AreaManagementModel.CreatedOn_Min, oSearch_AreaManagementModel.CreatedOn_Max, oSearch_AreaManagementModel.CreatedBy, oSearch_AreaManagementModel.CreatedBy_Values, oSearch_AreaManagementModel.UpdatedOn_Values, oSearch_AreaManagementModel.UpdatedOn_Min, oSearch_AreaManagementModel.UpdatedOn_Max, oSearch_AreaManagementModel.UpdatedBy, oSearch_AreaManagementModel.UpdatedBy_Values,oSearch_AreaManagementModel.Page_Size,oSearch_AreaManagementModel.Page_Index,oSearch_AreaManagementModel.Sort_Column,oSearch_AreaManagementModel.Sort_Ascending,oSearch_AreaManagementModel.IsBinaryRequired,oSearch_AreaManagementModel.IsPrimaryIN);
             oSearch_AreaManagementModel.ResultCount = oResultCount; 
             return oResult;
    	}*/
    
    	public virtual IEnumerable<AreaManagement> GetAreaManagementBySearch(GridSearchModel oGridSearchModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_AreaManagement_Search(ref oResultCount,oGridSearchModel.Page,oGridSearchModel.PageSize,oGridSearchModel.Filter,oGridSearchModel.SortOrder);
             oGridSearchModel.ResultCount = oResultCount; 
             return oResult;
    	}
    }
}
