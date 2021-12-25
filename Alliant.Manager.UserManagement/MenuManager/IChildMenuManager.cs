using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.Manager
{
                      
    public interface IChildMenuManager : IRootManager
    {
        ChildMenu Create();
        ChildMenu CreatePost(ChildMenu oChildMenu);
    	ChildMenu Edit(int Id);
    	ChildMenu EditPost(ChildMenu oChildMenu);
    	ChildMenu Delete(int Id);
    	int DeletePost(int Id);
    	ChildMenu GetChildMenuById(int Id);
    	//IEnumerable<ChildMenu> GetAllChildMenu(Search_ChildMenuModel oChildMenu);   
    	IEnumerable<ChildMenu> GetAllChildMenu(GridSearchModel oGridSearchModel);
        int UpdateSequance(List<ChildMenu> childMenus);
        int FavoriteMenu(FavoriteMenu favoriteMenu);
        IEnumerable<FavoriteMenu> GetFavoriteMenus(int userID);
        IEnumerable<FavoriteMenu> GetFavoriteMenusUser(int userID);
        int DeleteFavoriteMenu(int favoriteMenuID, int userID);
        int CreateRecentFavoriteMenu(FavoriteMenu favoriteMenu);
    }
}
