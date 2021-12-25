using Alliant.Common;
using Alliant.Domain;
using Alliant.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public class SharedResourcesImplController : _BaseController, ISharedResourcesController
    {
        public IAlliantManager _AlliantManager => DependencyResolver.Current.GetService<IAlliantManager>();

        /// <summary>
        /// Get current area management
        /// </summary>
        public string AreaManagement { get; set; }

        /// <summary>
        /// Set cache key run time
        /// </summary>
        public string oMenuCacheKey { get; set; }

        public virtual ActionResult Menu()
        {
            List<AlliantMenu> alliantMenus = null;
            try
            {
                alliantMenus = GetAlliantMenus();
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }

            return PartialView(alliantMenus);
        }

        public virtual ActionResult Favorite(FavoriteMenu favoriteMenu, FormCollection formCollection)
        {
            return PartialView("Favorite", favoriteMenu);
        }

        public virtual ActionResult FavoritePost(FavoriteMenu favoriteMenu, FormCollection formCollection)
        {
            try
            {
                oMenuCacheKey = $"{AlliantDataCacheKey.FavoriteMenu}_{_UserID}";
                _alliantDataCacheManager.Delete(oMenuCacheKey);

                favoriteMenu.UserID = _UserID;
                favoriteMenu.CreatedOn = DateTime.Now;
                _AlliantManager.ChildMenuManager.FavoriteMenu(favoriteMenu);

                return Json(new AjaxActionResult()
                {
                    Message = Constant.SaveMessage,
                    Success = true
                });
            }
            catch (Exception ex)
            {
                return Json(new AjaxActionResult()
                {
                    Message = ex.Message,
                    Success = false
                });
            }
        }

        public virtual ActionResult MenuFavorite()
        {
            List<FavoriteMenu> favoriteMenus = null;
            oMenuCacheKey = $"{AlliantDataCacheKey.FavoriteMenu}_{_UserID}";
            if (_alliantDataCacheManager.CheckKeyExists(oMenuCacheKey))
            {
                favoriteMenus = _alliantDataCacheManager.GetValue(oMenuCacheKey) as List<FavoriteMenu>;
            }
            else
            {
                favoriteMenus = _AlliantManager.ChildMenuManager.GetFavoriteMenus(_UserID).ToList();
                _alliantDataCacheManager.Add(oMenuCacheKey, favoriteMenus, DateTimeOffset.Now.AddHours(1));
            }
            return PartialView("MenuFavorite", favoriteMenus);
        }

        public virtual ActionResult FavoriteMenu()
        {
            List<FavoriteMenu> favoriteMenus = _AlliantManager.ChildMenuManager.GetFavoriteMenusUser(_UserID).ToList();
            return View("FavoriteMenu", favoriteMenus);
        }

        private List<AlliantMenu> GetAlliantMenus()
        {
            List<AlliantMenu> alliantMenu = new List<AlliantMenu>();
            AlliantMenu oAlliantMenu = null;
            IDictionary<string, bool> UserActivities = _dtUserActivities;

            oMenuCacheKey = $"{AlliantDataCacheKey.AreaMenu}_{AreaManagement}_{_UserID}";

            if (_alliantDataCacheManager.CheckKeyExists(oMenuCacheKey))
            {
                alliantMenu = _alliantDataCacheManager.GetValue(oMenuCacheKey) as List<AlliantMenu>;
            }
            else
            {
                AreaManagement areaManagement = _AlliantManager.AreaManagementManager.GetAllAreaManagement(new GridSearchModel()
                {
                    Filter = $"Name = '{AreaManagement}'"
                }).FirstOrDefault() ?? new AreaManagement();

                List<Menu> menus = _AlliantManager.MenuManager.GetAllMenu(new GridSearchModel()
                {
                    Filter = $"AreaID = {areaManagement.AreaID} AND IsActive = 1 AND ActivityName IN({UserActivities.Where(x => x.Value).Select(x => $"'{x.Key}'").JoinValues()})",
                    SortOrder = "Sequance ASC"

                }).ToList();

                List<ChildMenu> childMenus = _AlliantManager.ChildMenuManager.GetAllChildMenu(new GridSearchModel()
                {
                    Filter = $"MenuID IN({ menus.Select(x => x.MenuID).JoinValues() }) AND IsActive = 1 AND ActivityName IN({UserActivities.Where(x => x.Value).Select(x => $"'{x.Key}'").JoinValues()})",
                    SortOrder = "Sequance ASC"
                }).ToList();

                var oHtmlAttributes = new { @onclick = "return ajaxAnchorClickRecent(this)", @data_ajaxdivid = "jsAjaxContent" };

                var oRouteData = new { @area = (AreaManagement == Constant.MainMenu ? "" : AreaManagement) };

                foreach (Menu menu in menus)
                {
                    oAlliantMenu = new AlliantMenu()
                    {
                        ActionName = menu.ActionName,
                        ControllerName = menu.ControllerName,
                        LinkText = menu.LinkText,
                        MenuID = Guid.NewGuid(),
                        HtmlAttributes = oHtmlAttributes,
                        RouteData = oRouteData,
                        ID = menu.MenuID
                    };
                    foreach (ChildMenu childMenu in childMenus.Where(x => x.MenuID == menu.MenuID))
                    {
                        oAlliantMenu.ChildMenu.Add(new AlliantMenu()
                        {
                            ActionName = childMenu.ActionName,
                            ControllerName = childMenu.ControllerName,

                            LinkText = childMenu.LinkText,
                            MenuID = Guid.NewGuid(),
                            HtmlAttributes = oHtmlAttributes,
                            RouteData = oRouteData,
                            ID = childMenu.SubMenuID
                        });
                    }

                    alliantMenu.Add(oAlliantMenu);
                }

                _alliantDataCacheManager.Add(oMenuCacheKey, alliantMenu, DateTimeOffset.Now.AddHours(1));
            }

            return alliantMenu;
        }

        public virtual ActionResult DeleteFavoriteMenu(int Id)
        {
            try
            {
                oMenuCacheKey = $"{AlliantDataCacheKey.FavoriteMenu}_{_UserID}";
                _alliantDataCacheManager.Delete(oMenuCacheKey);
                _AlliantManager.ChildMenuManager.DeleteFavoriteMenu(Id, _UserID);
                //return RedirectToAction("Index", "Home");
                return Json(new AjaxActionResult()
                {
                    Message = Constant.SaveMessage,
                    Success = true
                });
            }
            catch (Exception ex)
            {
                return Json(new AjaxActionResult()
                {
                    Message = ex.Message,
                    Success = false
                });
                //return HandleException(ex);
            }
        }

        public virtual ActionResult RecentMenu(FavoriteMenu favoriteMenu)
        {
            try
            {
                favoriteMenu.CreatedOn = DateTime.Now;
                favoriteMenu.UserID = _UserID;
                favoriteMenu.IsFavorite = false;
                _AlliantManager.ChildMenuManager.CreateRecentFavoriteMenu(favoriteMenu);
                return Json(new AjaxActionResult()
                {
                    Message = Constant.SaveMessage,
                    Success = true
                });
            }
            catch (Exception ex)
            {
                return Json(new AjaxActionResult()
                {
                    Message = ex.Message,
                    Success = false
                });
            }
        }
    }
}