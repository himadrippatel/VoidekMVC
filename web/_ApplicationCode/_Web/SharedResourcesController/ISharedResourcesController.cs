using Alliant.Domain;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public interface ISharedResourcesController
    {
        ActionResult Menu();
        ActionResult Favorite(FavoriteMenu favoriteMenu,FormCollection formCollection);
        ActionResult FavoritePost(FavoriteMenu favoriteMenu, FormCollection formCollection);
        ActionResult MenuFavorite();
        ActionResult FavoriteMenu();
        ActionResult DeleteFavoriteMenu(int Id);
        ActionResult RecentMenu(FavoriteMenu favoriteMenu);
    }
}
