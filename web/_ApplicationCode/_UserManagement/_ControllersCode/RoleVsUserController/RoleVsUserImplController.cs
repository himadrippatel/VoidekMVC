using System;
using System.Linq;
using Alliant.Domain;
using System.Web.Mvc;
using Alliant.Manager;
using Kendo.Mvc.UI;
using System.Collections.Generic;
using Alliant.ViewModel;

namespace Alliant._ApplicationCode
{

    public abstract class RoleVsUserImplController : _BaseController, IRoleVsUserController
    {
        public virtual IRoleVsUserManager _RoleVsUserManager
        {
            get { return DependencyResolver.Current.GetService<IRoleVsUserManager>(); }
        }

        public virtual IRoleManager _RoleManager
        {
            get { return DependencyResolver.Current.GetService<IRoleManager>(); }
        }

        public virtual ActionResult Home()
        {
            IsAuthorized("activity_usermanagement_rolevsuser");
            UIContainer<RoleVsUser> uIContainer = new UIContainer<RoleVsUser>();
            uIContainer.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_rolevsuser,activity_usermanagement_rolevsuser_search,activity_usermanagement_rolevsuser_insert,activity_usermanagement_rolevsuser_update,activity_usermanagement_rolevsuser_delete");
            return View("Index",uIContainer);
        }

        public virtual ActionResult Create()
        {
            IsAuthorized("activity_usermanagement_rolevsuser_insert");
            List<Role> roles = _RoleManager.GetAllRoleV2(new GridSearchModel() { }).ToList();
            return View("Create", roles);
        }

        public virtual ActionResult CreatePost(RoleVsUserViewModel roleVsUserViewModel, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_rolevsuser_insert");
            try
            {
                _RoleVsUserManager.CreatePost(roleVsUserViewModel);
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

        public virtual ActionResult GetRoleVsUserById(int Id)
        {
            RoleVsUser oRoleVsUser = _RoleVsUserManager.GetRoleVsUserById(Id);
            return View("GetDetail", oRoleVsUser);
        }

        public virtual ActionResult Edit(int Id)
        {
            IsAuthorized("activity_usermanagement_rolevsuser_update");
            RoleVsUser oRoleVsUser = _RoleVsUserManager.GetRoleVsUserById(Id);
            return View("Edit", oRoleVsUser);
        }

        public virtual ActionResult EditPost(RoleVsUser oRoleVsUser, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_rolevsuser_update");
            try
            {
                _RoleVsUserManager.EditPost(oRoleVsUser);
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
            RoleVsUser oRoleVsUser = _RoleVsUserManager.GetRoleVsUserById(Id);
            return View("Delete", oRoleVsUser);
        }

        public virtual ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_rolevsuser_delete");
            try
            {
                _RoleVsUserManager.DeletePost(Id);
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

        public virtual ActionResult DeleteByModelRoleVsUser(RoleVsUser oRoleVsUser, FormCollection formCollection)
        {
            return View();
        }

        /*public virtual ActionResult GetRoleVsUserBySearch(Search_RoleVsUserModel oSearch_RoleVsUserModel,FormCollection formCollection)
    	{
    		var oResult = _RoleVsUserManager.GetAllRoleVsUser(oSearch_RoleVsUserModel).ToList();
    		return View("Grid",oResult);
    	}*/

        public virtual ActionResult GetRoleVsUserBySearch(DataSourceRequest request, FormCollection formCollection)
        {
            GridBinder gridBinder = new GridBinder(request);
            GridSearchModel searchModel = gridBinder.GetGridSearchModel();
            List<RoleVsUser> oResult = _RoleVsUserManager.GetAllRoleVsUser(searchModel).ToList();
            DataSourceResult result = oResult.ToDataSourceResult(request);
            request.Page = Convert.ToInt32(searchModel.Page);
            result.Total = Convert.ToInt32(searchModel.ResultCount);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public virtual JsonResult Search(string term, string notIn, FormCollection formCollection)
        {
            if (!string.IsNullOrEmpty(notIn?.Trim()))
            {
                string[] excludeCustomer = notIn.Split(',');
                excludeCustomer = excludeCustomer.Take(excludeCustomer.Length - 1).ToArray();
                notIn = string.Join(",", excludeCustomer.Select(x => string.Format("'{0}'", x)));
            }

            List<AutoCompleteViewModel> autoCompleteViewModels = _RoleVsUserManager.GetCustomerAutoCompleteViewModels(term, notIn).ToList();
            return Json(autoCompleteViewModels, JsonRequestBehavior.AllowGet);
        }

        public virtual JsonResult SearchUser(SearchRequest searchRequest, FormCollection formCollection)
        {
            SelectViewModel selectViewModel = _RoleVsUserManager.GetCustomerSelectViewModels(searchRequest);
            foreach (var selectResult in selectViewModel.items)
            {
                selectResult.imageurl = string.Concat(GetUrl(), FolderPathConstant.NoImageUrlPath, selectResult.imageurl);
            }
            return Json(selectViewModel, JsonRequestBehavior.AllowGet);
        }
    }
}
