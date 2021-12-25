using System.Linq;
using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{
    public class ChildMenuDAL : CommonDAL, IChildMenuDAL
    {

        public virtual int CreateChildMenu(ChildMenu oChildMenu)
        {

            int? oResultID = 0;
            int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ChildMenu_Insert(ref oResultID, oChildMenu.MenuID, oChildMenu.ParentID, oChildMenu.LinkText, oChildMenu.Description, oChildMenu.ActionName, oChildMenu.ControllerName, oChildMenu.HtmlAttributes, oChildMenu.RouteData, oChildMenu.IsActive, oChildMenu.Sequance,oChildMenu.ActivityName, oChildMenu.CreatedOn, oChildMenu.CreatedBy, oChildMenu.UpdatedOn, oChildMenu.UpdatedBy);
            oChildMenu.SubMenuID = (int)oResultID;
            return Result;
        }

        public virtual int UpdateChildMenu(ChildMenu oChildMenu)
        {
            int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ChildMenu_Update(oChildMenu.SubMenuID, oChildMenu.MenuID, oChildMenu.ParentID, oChildMenu.LinkText, oChildMenu.Description, oChildMenu.ActionName, oChildMenu.ControllerName, oChildMenu.HtmlAttributes, oChildMenu.RouteData, oChildMenu.IsActive, oChildMenu.Sequance,oChildMenu.ActivityName, oChildMenu.CreatedOn, oChildMenu.CreatedBy, oChildMenu.UpdatedOn, oChildMenu.UpdatedBy);
            return oResult;
        }

        public virtual int DeleteByModelChildMenu(ChildMenu pChildMenu)
    	{		
    		int oResult = 0;
    		//Custom code genrate here
            return oResult;
        }
    
    	public virtual int DeleteChildMenu(int Id)
    	{		
    		int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ChildMenu_Delete(Id);
            return oResult;
        }
    
    	public virtual ChildMenu GetChildMenuById(int Id)
    	{
    		var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ChildMenu_GetByID(Id).FirstOrDefault();;
    		return oResult;	
    	}	
    
    		
    
    	/*public virtual IEnumerable<ChildMenu> GetChildMenuBySearch(Search_ChildMenuModel oSearch_ChildMenuModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ChildMenu_Search(ref oResultCount,oSearch_ChildMenuModel.SubMenuID_Values, oSearch_ChildMenuModel.SubMenuID_Min, oSearch_ChildMenuModel.SubMenuID_Max, oSearch_ChildMenuModel.MenuID_Values, oSearch_ChildMenuModel.MenuID_Min, oSearch_ChildMenuModel.MenuID_Max, oSearch_ChildMenuModel.ParentID_Values, oSearch_ChildMenuModel.ParentID_Min, oSearch_ChildMenuModel.ParentID_Max, oSearch_ChildMenuModel.LinkText, oSearch_ChildMenuModel.LinkText_Values, oSearch_ChildMenuModel.Description, oSearch_ChildMenuModel.Description_Values, oSearch_ChildMenuModel.ActionName, oSearch_ChildMenuModel.ActionName_Values, oSearch_ChildMenuModel.ControllerName, oSearch_ChildMenuModel.ControllerName_Values, oSearch_ChildMenuModel.HtmlAttributes, oSearch_ChildMenuModel.HtmlAttributes_Values, oSearch_ChildMenuModel.RouteData, oSearch_ChildMenuModel.RouteData_Values, oSearch_ChildMenuModel.IsActive, oSearch_ChildMenuModel.CreatedOn_Values, oSearch_ChildMenuModel.CreatedOn_Min, oSearch_ChildMenuModel.CreatedOn_Max, oSearch_ChildMenuModel.CreatedBy, oSearch_ChildMenuModel.CreatedBy_Values, oSearch_ChildMenuModel.UpdatedOn_Values, oSearch_ChildMenuModel.UpdatedOn_Min, oSearch_ChildMenuModel.UpdatedOn_Max, oSearch_ChildMenuModel.UpdatedBy, oSearch_ChildMenuModel.UpdatedBy_Values,oSearch_ChildMenuModel.Page_Size,oSearch_ChildMenuModel.Page_Index,oSearch_ChildMenuModel.Sort_Column,oSearch_ChildMenuModel.Sort_Ascending,oSearch_ChildMenuModel.IsBinaryRequired,oSearch_ChildMenuModel.IsPrimaryIN);
             oSearch_ChildMenuModel.ResultCount = oResultCount; 
             return oResult;
    	}*/
    
    	public virtual IEnumerable<ChildMenu> GetChildMenuBySearch(GridSearchModel oGridSearchModel)
    	{		
    		 int? oResultCount = 0;		
             var oResult= _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ChildMenu_Search(ref oResultCount,oGridSearchModel.Page,oGridSearchModel.PageSize,oGridSearchModel.Filter,oGridSearchModel.SortOrder);
             oGridSearchModel.ResultCount = oResultCount; 
             return oResult;
    	}

        public virtual int UpdateSequance(ChildMenu oChildMenu)
        {
            int result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ChildMenu_UpdateSequance(oChildMenu.SubMenuID, oChildMenu.Sequance);
            return result;
        }

        public virtual int FavoriteMenu(FavoriteMenu favoriteMenu)
        {
            int? oResultID = 0;
            int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_FavoriteMenu_Insert(ref oResultID,favoriteMenu.UserID,favoriteMenu.LinkText,favoriteMenu.LinkHref,favoriteMenu.MenuID,favoriteMenu.SubMenuID,favoriteMenu.IsFavorite,favoriteMenu.CreatedOn,favoriteMenu.CreatedBy);
            favoriteMenu.FavoriteMenuID = (int)oResultID;
            return Result;            
        }

        public virtual IEnumerable<FavoriteMenu> GetFavoriteMenus(int userID)
        {
            return _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_FavoriteMenu_GetBy(userID);
        }

        public IEnumerable<FavoriteMenu> GetFavoriteMenusUser(int userID)
        {
            return _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_FavoriteMenu_GetByUserID(userID);
        }

        public int DeleteFavoriteMenu(int favoriteMenuID,int userID)
        {
            return _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_FavoriteMenu_Delete(favoriteMenuID, userID);
        }

        public int CreateRecentFavoriteMenu(FavoriteMenu favoriteMenu)
        {
            int? oResultID = 0;
            int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_FavoriteMenu_InsertRecent(ref oResultID, favoriteMenu.UserID, favoriteMenu.LinkText, favoriteMenu.LinkHref, favoriteMenu.MenuID, favoriteMenu.SubMenuID, favoriteMenu.IsFavorite, favoriteMenu.CreatedOn, favoriteMenu.CreatedBy);
            favoriteMenu.FavoriteMenuID = (int)oResultID;
            return Result;
        }
    }
}
