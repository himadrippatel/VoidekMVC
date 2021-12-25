using System;
using System.Linq;
using Alliant.Domain;
using System.Web.Mvc;
using Alliant.Manager;
using Kendo.Mvc.UI;
using System.Collections.Generic;

namespace Alliant._ApplicationCode
{

    public abstract class PermissionImplController : _BaseController, IPermissionController
    {
        public virtual IPermissionManager _PermissionManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IPermissionManager>();
            }
        }

        public virtual ActionResult Home()
        {
            IsAuthorized("activity_usermanagement_permission");

            UIContainer<Permission> uIContainerPermission = new UIContainer<Permission>();
            uIContainerPermission.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_permission,activity_usermanagement_permission_insert,activity_usermanagement_permission_update,activity_usermanagement_permission_delete,activity_usermanagement_permission_search");

            return View("Index", uIContainerPermission);
        }

        public virtual ActionResult Create()
        {
            IsAuthorized("activity_usermanagement_permission_insert");

            Permission oPermission = _PermissionManager.Create();
            return View("Create", oPermission);
        }

        public virtual ActionResult CreatePost(Permission oPermission, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_permission_insert");

            try
            {
                _PermissionManager.CreatePost(oPermission);
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

        public virtual ActionResult GetPermissionById(int Id)
        {
            Permission oPermission = _PermissionManager.GetPermissionById(Id);
            return View("GetDetail", oPermission);
        }

        public virtual ActionResult Edit(int Id)
        {
            IsAuthorized("activity_usermanagement_permission_update");

            Permission oPermission = _PermissionManager.GetPermissionById(Id);
            return View("Edit", oPermission);
        }

        public virtual ActionResult EditPost(Permission oPermission, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_permission_update");

            try
            {
                _PermissionManager.EditPost(oPermission);
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
            IsAuthorized("activity_usermanagement_permission_delete");

            Permission oPermission = _PermissionManager.GetPermissionById(Id);
            return View("Delete", oPermission);
        }

        public virtual ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_permission_delete");

            try
            {
                _PermissionManager.DeletePost(Id);
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

        public virtual ActionResult DeleteByModelPermission(Permission oPermission, FormCollection formCollection)
        {
            return View();
        }

        /*public virtual ActionResult GetPermissionBySearch(Search_PermissionModel oSearch_PermissionModel,FormCollection formCollection)
    	{
    		var oResult = _PermissionManager.GetAllPermission(oSearch_PermissionModel).ToList();
    		return View("Grid",oResult);
    	}*/

        public virtual ActionResult GetPermissionBySearch(DataSourceRequest request, FormCollection formCollection)
        {
            GridBinder gridBinder = new GridBinder(request);
            GridSearchModel searchModel = gridBinder.GetGridSearchModel();
            List<Permission> oResult = _PermissionManager.GetAllPermission(searchModel).ToList();
            DataSourceResult result = oResult.ToDataSourceResult(request);
            request.Page = Convert.ToInt32(searchModel.Page);
            result.Total = Convert.ToInt32(searchModel.ResultCount);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public virtual IDictionary<string, string> GetPermissionDropDown()
        {
            var oResult = _PermissionManager.GetAllPermission(new GridSearchModel() { });
            return oResult.Select(x => new { Text = x.Name, Value = x.PermissionID.ToString() }).ToDictionary(x => x.Value, x => x.Text);
        }
    }
}
