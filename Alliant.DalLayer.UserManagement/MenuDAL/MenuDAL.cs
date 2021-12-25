using System;
using System.Linq;
using System.Collections;
using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{
    public class MenuDAL : CommonDAL, IMenuDAL
    {
        public virtual int CreateMenu(Menu oMenu)
        {
            int? oResultID = 0;
            int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Menu_Insert(ref oResultID, oMenu.AreaID, oMenu.LinkText, oMenu.Description, oMenu.IsActive, oMenu.ActionName, oMenu.ControllerName, oMenu.HtmlAttributes, oMenu.RouteData, oMenu.Sequance,oMenu.ActivityName, oMenu.CreatedOn, oMenu.CreatedBy, oMenu.UpdatedOn, oMenu.UpdatedBy);
            oMenu.MenuID = (int)oResultID;
            return Result;
        }

        public virtual int UpdateMenu(Menu oMenu)
        {
            int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Menu_Update(oMenu.MenuID, oMenu.AreaID, oMenu.LinkText, oMenu.Description, oMenu.IsActive, oMenu.ActionName, oMenu.ControllerName, oMenu.HtmlAttributes, oMenu.RouteData, oMenu.Sequance, oMenu.ActivityName, oMenu.CreatedOn, oMenu.CreatedBy, oMenu.UpdatedOn, oMenu.UpdatedBy);
            return oResult;
        }

        public virtual int DeleteByModelMenu(Menu pMenu)
    	{		
    		int oResult = 0;
    		//Custom code genrate here
            return oResult;
        }
    
    	public virtual int DeleteMenu(int Id)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Menu_Delete(Id);
            return oResult;
        }
    
    	public virtual Menu GetMenuById(int Id)
    	{
    		var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Menu_GetByID(Id).FirstOrDefault();;
    		return oResult;	
    	}	    
    		
    
    	/*public virtual IEnumerable<Menu> GetMenuBySearch(Search_MenuModel oSearch_MenuModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Menu_Search(ref oResultCount,oSearch_MenuModel.MenuID_Values, oSearch_MenuModel.MenuID_Min, oSearch_MenuModel.MenuID_Max, oSearch_MenuModel.LinkText, oSearch_MenuModel.LinkText_Values, oSearch_MenuModel.Description, oSearch_MenuModel.Description_Values, oSearch_MenuModel.IsActive, oSearch_MenuModel.CreatedOn_Values, oSearch_MenuModel.CreatedOn_Min, oSearch_MenuModel.CreatedOn_Max, oSearch_MenuModel.CreatedBy, oSearch_MenuModel.CreatedBy_Values, oSearch_MenuModel.UpdatedOn_Values, oSearch_MenuModel.UpdatedOn_Min, oSearch_MenuModel.UpdatedOn_Max, oSearch_MenuModel.UpdatedBy, oSearch_MenuModel.UpdatedBy_Values,oSearch_MenuModel.Page_Size,oSearch_MenuModel.Page_Index,oSearch_MenuModel.Sort_Column,oSearch_MenuModel.Sort_Ascending,oSearch_MenuModel.IsBinaryRequired,oSearch_MenuModel.IsPrimaryIN);
             oSearch_MenuModel.ResultCount = oResultCount; 
             return oResult;
    	}*/
    
    	public virtual IEnumerable<Menu> GetMenuBySearch(GridSearchModel oGridSearchModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Menu_Search(ref oResultCount,oGridSearchModel.Page,oGridSearchModel.PageSize,oGridSearchModel.Filter,oGridSearchModel.SortOrder);
             oGridSearchModel.ResultCount = oResultCount; 
             return oResult;
    	}

        public virtual int UpdateSequance(Menu oMenu)
        {
            int result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_Menu_UpdateSequance(oMenu.MenuID, oMenu.Sequance);
            return result;
        }
    }
}
