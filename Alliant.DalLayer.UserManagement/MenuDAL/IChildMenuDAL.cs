using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface IChildMenuDAL : IDALBase
    {
        int CreateChildMenu(ChildMenu oChildMenu);
        int UpdateChildMenu(ChildMenu oChildMenu);
    	int DeleteByModelChildMenu(ChildMenu oChildMenu);
    	int DeleteChildMenu(int Id);
    	ChildMenu GetChildMenuById(int Id);
        //IEnumerable<ChildMenu> GetChildMenuBySearch(Search_ChildMenuModel oSearch_ChildMenuModel);  
    	IEnumerable<ChildMenu> GetChildMenuBySearch(GridSearchModel oGridSearchModel);
        int UpdateSequance(ChildMenu oMenu);
        int FavoriteMenu(FavoriteMenu favoriteMenu);
        IEnumerable<FavoriteMenu> GetFavoriteMenus(int userID);
        IEnumerable<FavoriteMenu> GetFavoriteMenusUser(int userID);
        int DeleteFavoriteMenu(int favoriteMenuID, int userID);
        int CreateRecentFavoriteMenu(FavoriteMenu favoriteMenu);
    }
}
