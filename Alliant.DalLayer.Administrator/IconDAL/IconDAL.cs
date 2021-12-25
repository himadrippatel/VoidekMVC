using Alliant.Domain;
using System.Collections.Generic;
using System.Linq;

namespace Alliant.DalLayer
{
    public class IconDAL : CommonDAL, IIconDAL
    {	
    	public virtual int CreateIcon(Icon oIcon)
    	{ 	
    		
    		int? oResultID = 0;
    		int Result = _StoreProcedure.StoreProcedureAdministrator.spr_tb_AM_ICon_Insert(ref oResultID,oIcon.ICon, oIcon.IconName, oIcon.IsActive, oIcon.CreatedOn, oIcon.CreatedBy);
    		oIcon.IconID = (int)oResultID;
            return Result;		      
    	}
    
    	public virtual int UpdateIcon(Icon oIcon)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureAdministrator.spr_tb_AM_ICon_Update(oIcon.IconID, oIcon.ICon, oIcon.IconName, oIcon.IsActive, oIcon.CreatedOn, oIcon.CreatedBy);
            return oResult;
        }
    
    	public virtual int DeleteByModelIcon(Icon pIcon)
    	{		
    		int oResult = 0;
    		//Custom code genrate here
            return oResult;
        }
    
    	public virtual int DeleteIcon(int Id)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureAdministrator.spr_tb_AM_ICon_Delete(Id);
            return oResult;
        }
    
    	public virtual Icon GetIconById(int Id)
    	{
    		var oResult= _StoreProcedure.StoreProcedureAdministrator.spr_tb_AM_ICon_GetByID(Id).FirstOrDefault();
    		return oResult;	
    	}	
    
    		
    
    	/*public virtual IEnumerable<Icon> GetIconBySearch(Search_IconModel oSearch_IconModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureAdministrator.spr_tb_AM_Icon_Search(ref oResultCount,oSearch_IconModel.IconID_Values, oSearch_IconModel.IconID_Min, oSearch_IconModel.IconID_Max, oSearch_IconModel.ICon, oSearch_IconModel.ICon_Values, oSearch_IconModel.IconName, oSearch_IconModel.IconName_Values, oSearch_IconModel.IsActive, oSearch_IconModel.CreatedOn_Values, oSearch_IconModel.CreatedOn_Min, oSearch_IconModel.CreatedOn_Max, oSearch_IconModel.CreatedBy, oSearch_IconModel.CreatedBy_Values,oSearch_IconModel.Page_Size,oSearch_IconModel.Page_Index,oSearch_IconModel.Sort_Column,oSearch_IconModel.Sort_Ascending,oSearch_IconModel.IsBinaryRequired,oSearch_IconModel.IsPrimaryIN);
             oSearch_IconModel.ResultCount = oResultCount; 
             return oResult;
    	}*/
    
    	public virtual IEnumerable<Icon> GetIconBySearch(GridSearchModel oGridSearchModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureAdministrator.spr_tb_AM_ICon_Search(ref oResultCount,oGridSearchModel.Page,oGridSearchModel.PageSize,oGridSearchModel.Filter,oGridSearchModel.SortOrder);
             oGridSearchModel.ResultCount = oResultCount; 
             return oResult;
    	}
    }
}
