using System;
using System.Linq;
using Alliant.Domain;
using System.Web.Mvc;
using Alliant.Manager;
using System.Collections.Generic;
using Alliant.Utility;

namespace Alliant._ApplicationCode
{

    public abstract class MenuImplController : _BaseController, IMenuController
    {
        public virtual IMenuManager _MenuManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IMenuManager>();
            }
        }

        public virtual IconManager _IconManager { get { return DependencyResolver.Current.GetService<IconManager>(); } }

        public virtual ActionResult Home()
        {
            IsAuthorized("activity_usermanagement_menu");
            UIContainer<Menu> uIContainer = new UIContainer<Menu>();
            uIContainer.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_menu,activity_usermanagement_menu_search,activity_usermanagement_menu_insert,activity_usermanagement_menu_update,activity_usermanagement_menu_delete");
            return View("Index", uIContainer);
        }

        public virtual ActionResult Create()
        {
            IsAuthorized("activity_usermanagement_menu_insert");

            List<Icon> icons = _IconManager.GetAllIcon(new GridSearchModel() { }).ToList();
            return View("Create", icons);
        }

        public virtual ActionResult CreatePost(Menu oMenu, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_menu_insert");

            try
            {               
                 oMenu.LinkText = $"{formCollection["LinkIcon"]} <span class=\"menu-title\">{oMenu.LinkText}</span>";
                _MenuManager.CreatePost(oMenu);
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

        public virtual ActionResult GetMenuById(int Id)
        {
            Menu oMenu = _MenuManager.GetMenuById(Id);
            return View("GetDetail", oMenu);
        }

        public virtual ActionResult Edit(int Id)
        {
            IsAuthorized("activity_usermanagement_menu_update");

            Menu oMenu = _MenuManager.GetMenuById(Id);
            List<Icon> icons = _IconManager.GetAllIcon(new GridSearchModel() { }).ToList();
            Tuple<Menu, List<Icon>> tuple = Tuple.Create(oMenu, icons);
            return View("Edit", tuple);
        }

        public virtual ActionResult EditPost(Menu oMenu, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_menu_update");

            try
            {
                oMenu.LinkText = $"{formCollection["LinkIcon"]} <span class=\"menu-title\">{oMenu.LinkText}</span>";
                _MenuManager.EditPost(oMenu);
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

        public virtual ActionResult Delete(int Id)
        {
            IsAuthorized("activity_usermanagement_menu_delete");

            Menu oMenu = _MenuManager.GetMenuById(Id);
            return View("Delete", oMenu);
        }

        public virtual ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_menu_delete");

            try
            {
                _MenuManager.DeletePost(Id);
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

        public virtual ActionResult DeleteByModelMenu(Menu oMenu, FormCollection formCollection)
        {
            return View();
        }

        /*public virtual ActionResult GetMenuBySearch(Search_MenuModel oSearch_MenuModel,FormCollection formCollection)
    	{
    		var oResult = _MenuManager.GetAllMenu(oSearch_MenuModel).ToList();
    		return View("Grid",oResult);
    	}*/

        public virtual ActionResult GetMenuBySearch(Kendo.Mvc.UI.DataSourceRequest request, FormCollection formCollection)
        {
            GridBinder gridBinder = new GridBinder(request);
            GridSearchModel searchModel = gridBinder.GetGridSearchModel();
            List<Menu> oResult = _MenuManager.GetAllMenu(searchModel).ToList();
            
            Kendo.Mvc.UI.DataSourceResult result = oResult.ToDataSourceResult(request);
            request.Page = Convert.ToInt32(searchModel.Page);
            result.Total = Convert.ToInt32(searchModel.ResultCount);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public virtual Dictionary<string, string> GetMenuDropDown()
        {
            List<Menu> oResult = _MenuManager.GetAllMenu(new GridSearchModel() { }).ToList();

            oResult.ForEach(x =>
            {
                x.LinkText = x.LinkText.RemoveHtmlFromString();
            });

            return oResult.Select(x => new { Value = x.MenuID.ToString(), Text = x.LinkText }).ToDictionary(x => x.Value, x => x.Text);
        }

        public virtual JsonResult GetMenuJsonDropDown(string id, string fixedValues = null)
        {
            var data = _MenuManager.GetAllMenu(new GridSearchModel() { Filter = $"AreaID = {id}" }).Select(o => new { Text = o.LinkText.RemoveHtmlFromString(), Value = o.MenuID }).ToList();

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public virtual ActionResult Sequence()
        {   
            //List<Menu> oResult = _MenuManager.GetAllMenu(new GridSearchModel() { }).ToList();

            //oResult.ForEach(x =>
            //{
            //    x.LinkText = x.LinkText.RemoveHtmlFromString();
            //});

            //return View("Sequence", oResult);
            return View("Sequence");
        }

        public virtual ActionResult SequenceMenu(int AreaID)
        {
            List<Menu> oResult = _MenuManager.GetAllMenu(new GridSearchModel() { Filter = $"AreaID = {AreaID}", SortOrder = "Sequance ASC" }).ToList();

            oResult.ForEach(x =>
            {
                x.LinkText = x.LinkText.RemoveHtmlFromString();
            });

            return View("SequenceMenu", oResult);
        }

        public virtual ActionResult UpdateSequence(List<Menu> menus, FormCollection formCollection)
        {
            try
            {
                if (menus != null)
                {
                    _MenuManager.UpdateSequance(menus);
                }
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
