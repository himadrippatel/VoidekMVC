using System;
using System.Linq;
using Alliant.Domain;
using System.Web.Mvc;
using Alliant.Manager;
using Kendo.Mvc.UI;
using System.Collections.Generic;
using Alliant.Utility;

namespace Alliant._ApplicationCode
{

    public abstract class ChildMenuImplController : _BaseController, IChildMenuController
    {
        public virtual IChildMenuManager _ChildMenuManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IChildMenuManager>();
            }
        }

        public virtual IconManager _IconManager { get { return DependencyResolver.Current.GetService<IconManager>(); } }
        
        public virtual ActionResult Home()
        {
            IsAuthorized("activity_usermanagement_childmenu");
            UIContainer<ChildMenu> uIContainer = new UIContainer<ChildMenu>();
            uIContainer.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_childmenu,activity_usermanagement_childmenu_search,activity_usermanagement_childmenu_insert,activity_usermanagement_childmenu_update,activity_usermanagement_childmenu_delete");
            return View("Index",uIContainer);
        }

        public virtual ActionResult Create()
        {
            IsAuthorized("activity_usermanagement_childmenu_insert");
            List<Icon> icons = _IconManager.GetAllIcon(new GridSearchModel() { }).ToList();
            return View("Create", icons);
        }

        public virtual ActionResult CreatePost(ChildMenu oChildMenu, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_childmenu_insert");
            try
            {
                oChildMenu.LinkText = $"{formCollection["LinkIcon"]} <span class=\"menu-title\">{oChildMenu.LinkText}</span>";
                _ChildMenuManager.CreatePost(oChildMenu);
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

        public virtual ActionResult GetChildMenuById(int Id)
        {
            ChildMenu oChildMenu = _ChildMenuManager.GetChildMenuById(Id);
            return View("GetDetail", oChildMenu);
        }

        public virtual ActionResult Edit(int Id)
        {
            IsAuthorized("activity_usermanagement_childmenu_update");
            ChildMenu oChildMenu = _ChildMenuManager.GetChildMenuById(Id);
            List<Icon> icons = _IconManager.GetAllIcon(new GridSearchModel() { }).ToList();
            Tuple<ChildMenu, List<Icon>> tuple = Tuple.Create(oChildMenu, icons);
            return View("Edit", tuple);
        }

        public virtual ActionResult EditPost(ChildMenu oChildMenu, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_childmenu_update");
            try
            {
                oChildMenu.LinkText = $"{formCollection["LinkIcon"]} <span class=\"menu-title\">{oChildMenu.LinkText}</span>";
                _ChildMenuManager.EditPost(oChildMenu);
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
            ChildMenu oChildMenu = _ChildMenuManager.GetChildMenuById(Id);
            return View("Delete", oChildMenu);
        }

        public virtual ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_childmenu_delete");
            try
            {
                _ChildMenuManager.DeletePost(Id);
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

        public virtual ActionResult DeleteByModelChildMenu(ChildMenu oChildMenu, FormCollection formCollection)
        {
            return View();
        }

        /*public virtual ActionResult GetChildMenuBySearch(Search_ChildMenuModel oSearch_ChildMenuModel,FormCollection formCollection)
    	{
    		var oResult = _ChildMenuManager.GetAllChildMenu(oSearch_ChildMenuModel).ToList();
    		return View("Grid",oResult);
    	}*/

        public virtual ActionResult GetChildMenuBySearch(DataSourceRequest request, FormCollection formCollection)
        {
            GridBinder gridBinder = new GridBinder(request);
            GridSearchModel searchModel = gridBinder.GetGridSearchModel();
            List<ChildMenu> oResult = _ChildMenuManager.GetAllChildMenu(searchModel).ToList();
            
            DataSourceResult result = oResult.ToDataSourceResult(request);
            request.Page = Convert.ToInt32(searchModel.Page);
            result.Total = Convert.ToInt32(searchModel.ResultCount);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public virtual ActionResult Sequence()
        {
            return View("Sequence");
        }

        public virtual ActionResult SequenceChildMenu(int MenuID)
        {
            List<ChildMenu> oResult = _ChildMenuManager.GetAllChildMenu(new GridSearchModel() { Filter = $"MenuID = {MenuID}", SortOrder = "Sequance ASC" }).ToList();

            oResult.ForEach(x =>
            {
                x.LinkText = x.LinkText.RemoveHtmlFromString();
            });

            return View("SequenceChildMenu", oResult);
        }

        public virtual ActionResult UpdateSequence(List<ChildMenu> menus, FormCollection formCollection)
        {
            try
            {
                if (menus != null)
                {
                    _ChildMenuManager.UpdateSequance(menus);
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
