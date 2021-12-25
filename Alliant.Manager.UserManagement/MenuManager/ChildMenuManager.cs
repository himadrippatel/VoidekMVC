using Alliant.DalLayer;
using Alliant.Domain;
using System;
using System.Collections.Generic;

namespace Alliant.Manager
{

    public class ChildMenuManager : DALProvider, IChildMenuManager
    {
        IChildMenuDAL oChildMenuDal = null;

        public ChildMenuManager()
        {
            oChildMenuDal = DALUserManagement.ChildMenuDAL;
        }

        public virtual ChildMenu Create()
        {
            return new ChildMenu();
        }

        public virtual ChildMenu CreatePost(ChildMenu oChildMenu)
        {
            oChildMenu.CreatedOn = DateTime.Now;
            oChildMenu.UpdatedOn = DateTime.Now;

            oChildMenuDal.CreateChildMenu(oChildMenu);
            return oChildMenu;
        }

        public virtual ChildMenu Edit(int Id)
        {
            return oChildMenuDal.GetChildMenuById(Id);
        }

        public virtual ChildMenu EditPost(ChildMenu oChildMenu)
        {
            oChildMenu.UpdatedOn = DateTime.Now;
            oChildMenuDal.UpdateChildMenu(oChildMenu);
            return oChildMenu;
        }

        public virtual ChildMenu Delete(int Id)
        {
            return oChildMenuDal.GetChildMenuById(Id);
        }

        public virtual int DeletePost(int Id)
        {
            return oChildMenuDal.DeleteChildMenu(Id);
        }

        public virtual ChildMenu GetChildMenuById(int Id)
        {
            return oChildMenuDal.GetChildMenuById(Id);
        }

        /*public virtual IEnumerable<ChildMenu> GetAllChildMenu(Search_ChildMenuModel oChildMenu)
    	{
    		return oChildMenuDal.GetChildMenuBySearch(oChildMenu);
    	}*/

        public virtual IEnumerable<ChildMenu> GetAllChildMenu(GridSearchModel oGridSearchModel)
        {
            return oChildMenuDal.GetChildMenuBySearch(oGridSearchModel);
        }

        public int UpdateSequance(List<ChildMenu> childMenus)
        {
            int result = 0;

            foreach (var childMenu in childMenus)
            {
                oChildMenuDal.UpdateSequance(childMenu);
            }

            return result;
        }

        public virtual int FavoriteMenu(FavoriteMenu favoriteMenu)
        {
            return oChildMenuDal.FavoriteMenu(favoriteMenu);
        }

        public virtual IEnumerable<FavoriteMenu> GetFavoriteMenus(int userID)
        {
            return oChildMenuDal.GetFavoriteMenus(userID);
        }

        public IEnumerable<FavoriteMenu> GetFavoriteMenusUser(int userID)
        {
            return oChildMenuDal.GetFavoriteMenusUser(userID);
        }

        public int DeleteFavoriteMenu(int favoriteMenuID, int userID)
        {
            return oChildMenuDal.DeleteFavoriteMenu(favoriteMenuID, userID);
        }

        public int CreateRecentFavoriteMenu(FavoriteMenu favoriteMenu)
        {
            return oChildMenuDal.CreateRecentFavoriteMenu(favoriteMenu);
        }
    }
}
