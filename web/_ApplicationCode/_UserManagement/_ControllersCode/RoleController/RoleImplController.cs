using Alliant.Domain;
using Alliant.Manager;
using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public abstract class RoleImplController : _BaseController, IRoleController
    {
        IRoleManager _RoleManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IRoleManager>();
            }
        }
        public virtual ActionResult Home()
        {
            IsAuthorized("activity_usermanagement_role");
            UIContainer<Role> uIRoleContainer = new UIContainer<Role>();
            uIRoleContainer.Model = new Role();
            uIRoleContainer.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_role,activity_usermanagement_role_search,activity_usermanagement_role_insert,activity_usermanagement_role_delete,activity_usermanagement_role_update");
            return View("Index", uIRoleContainer);
        }

        public virtual ActionResult Create()
        {
            IsAuthorized("activity_usermanagement_role_insert");
            
            Role role = _RoleManager.Create();
            return View("Create", role);
        }

        public virtual ActionResult CreatePost(Role oRole, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_role_insert");
            try
            {
                _RoleManager.CreatePost(oRole);
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

        public virtual ActionResult GetRoleById(int Id)
        {
            return View(_RoleManager.GetRoleById(Id));
        }

        public virtual ActionResult Edit(int Id)
        {
            IsAuthorized("activity_usermanagement_role_update");

            Role role = _RoleManager.Edit(Id);
            return View("Edit", role);
        }

        public virtual ActionResult EditPost(Role oRole, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_role_update");

            try
            {
                _RoleManager.EditPost(oRole);
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
            IsAuthorized("activity_usermanagement_role_delete");

            Role role = _RoleManager.Delete(Id);
            return View("Delete", role);
        }

        public virtual ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_role_delete");
            try
            {
                _RoleManager.DeletePost(Id);
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

        public virtual ActionResult DeleteByModelRole(Role oRole, FormCollection formCollection)
        {
            return View();
        }

        public virtual ActionResult GetRoleBySearch(DataSourceRequest request)
        {
            GridBinder gridBinder = new GridBinder(request);

            GridSearchModel searchModel = gridBinder.GetGridSearchModel();

            //Search_RoleModel search_Role = new Search_RoleModel();
            //search_Role.Page_Size = request.PageSize;
            //search_Role.Page_Index = request.Page;
            //if (request.Sorts.Count > 0)
            //{
            //    search_Role.Sort_Column = request.Sorts[0].Member;
            //    search_Role.Sort_Ascending = (Convert.ToString(request.Sorts[0].SortDirection) == Constant.SortAscending ? true : false);
            //}

            //List<Role> oResult = _RoleManager.GetAllRole(search_Role).ToList();

            //List<Role> oResult = _RoleManager.GetAllRoleV2(searchModel).ToList();
            searchModel.SortOrder = "LEVEL ASC,Name ASC";
            var oResult = _RoleManager.GetAllRoleV2(searchModel).ToList();

            DataSourceResult result = oResult.ToDataSourceResult(request);
            request.Page = Convert.ToInt32(searchModel.Page);
            result.Total = Convert.ToInt32(searchModel.ResultCount);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public virtual IDictionary<string, string> GetRoleDropDown()
        {
            //var oResult = _RoleManager.GetAllRole(new Search_RoleModel() { Page_Size = null });
            var oResult = _RoleManager.GetRoleHierarchy(null);
            return oResult.Select(x => new { Text = x.Name, Value = x.RoleID.ToString() }).ToDictionary(x => x.Value, x => x.Text);
        }

        public virtual JsonResult GetRoleHierarchicalViewModel(int? Id)
        {
            var result =
                _RoleManager.GetRoleHierarchicalViewModel(Id)
                 .Where(x => Id.HasValue ? x.ParentID == Id : x.ParentID == null)
                 .Select(item => new
                 {
                     id = item.ID,
                     Name = item.Name,
                     hasChildren = item.HasChildren
                 });
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public virtual JsonResult SearchRoleSelect(SearchRequest searchRequest, FormCollection formCollection)
        {
            SelectViewModel selectViewModel = _RoleManager.GetRoleSelectViewModels(searchRequest);
            return Json(selectViewModel, JsonRequestBehavior.AllowGet);
        }

        //ActionResult IRoleController.Home() { return Home(); }
    }
}