using Alliant._ApplicationCode;
using Alliant.Domain;
using System.Web.Mvc;

namespace Alliant.Controllers
{
    public class SharedResourcesController : SharedResourcesImplController
    {        
        [ChildActionOnly]
        public override ActionResult Menu()
        {
            AreaManagement = Constant.MainMenu;
            return base.Menu();
        }

        [HttpPost]
        public override ActionResult Favorite(FavoriteMenu favoriteMenu, FormCollection formCollection) 
            => base.Favorite(favoriteMenu, formCollection);

        [HttpPost]
        public override ActionResult FavoritePost(FavoriteMenu favoriteMenu, FormCollection formCollection)
            => base.FavoritePost(favoriteMenu, formCollection);

        [ChildActionOnly]
        public override ActionResult MenuFavorite() 
            => base.MenuFavorite();

        public override ActionResult FavoriteMenu() 
            => base.FavoriteMenu();

        public override ActionResult DeleteFavoriteMenu(int FavoriteMenuID) 
            => base.DeleteFavoriteMenu(FavoriteMenuID);

        public override ActionResult RecentMenu(FavoriteMenu favoriteMenu) 
            => base.RecentMenu(favoriteMenu);
    }
}