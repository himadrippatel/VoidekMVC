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
    public abstract class RoleVsActivityImplController : _BaseController ,IRoleVsActivityController
    {		
    	public virtual IRoleVsActivityManager _RoleVsActivityManager {get{return DependencyResolver.Current.GetService<IRoleVsActivityManager>();}}
        public virtual IRoleManager _RoleManager { get { return DependencyResolver.Current.GetService<IRoleManager>(); } }
        public virtual ISecondaryActivityManager _SecondaryActivityManager { get { return DependencyResolver.Current.GetService<ISecondaryActivityManager>(); } }
        
        public virtual ActionResult Home()
    	{
            IsAuthorized("activity_usermanagement_rolevsactivity");
            UIContainer<RoleVsActivity> uIContainer = new UIContainer<RoleVsActivity>();
            uIContainer.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_rolevsactivity,activity_usermanagement_rolevsactivity_search,activity_usermanagement_rolevsactivity_insert,activity_usermanagement_rolevsactivity_delete");
    		return View("Index", uIContainer);
    	}
    	
    	public virtual ActionResult Create()
    	{
            IsAuthorized("activity_usermanagement_rolevsactivity_insert");
            List<SecondaryActivity> secondaryActivity = _SecondaryActivityManager.GetAllSecondaryActivity(new GridSearchModel() { SortOrder = "ParentActivity ASC" }).ToList();
            List<Role> roles = _RoleManager.GetAllRoleV2(new GridSearchModel() { SortOrder = "RoleID ASC" }).ToList();
            Tuple<List<Role>, List<SecondaryActivity>> tupleRoleActivity = Tuple.Create(roles, secondaryActivity);
            return View("Create", tupleRoleActivity);
        }
    	
    	public virtual ActionResult CreatePost(RoleVsActivityViewModel roleVsActivityView, FormCollection formCollection)
    	{
            IsAuthorized("activity_usermanagement_rolevsactivity_insert");

            try
            {
                _RoleVsActivityManager.CreatePost(roleVsActivityView);
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
                    Success = false,
                    Data = ex
                });
            }
    	} 
    	
    	public virtual ActionResult DeletePost(int Id,FormCollection formCollection)
    	{
            IsAuthorized("activity_usermanagement_rolevsactivity_delete");
            
            try
            {
                _RoleVsActivityManager.DeletePost(Id);
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
                    Success = false,
                    Data = ex
                });
            }
    	}
    	
    	public virtual ActionResult DeleteByModelRoleVsActivity(RoleVsActivity oRoleVsActivity,FormCollection formCollection)
    	{
    		return View();
    	}
    	
    	/*public virtual ActionResult GetRoleVsActivityBySearch(Search_RoleVsActivityModel oSearch_RoleVsActivityModel,FormCollection formCollection)
    	{
    		var oResult = _RoleVsActivityManager.GetAllRoleVsActivity(oSearch_RoleVsActivityModel).ToList();
    		return View("Grid",oResult);
    	}*/
    	
    	public virtual ActionResult GetRoleVsActivityBySearch(DataSourceRequest request,FormCollection formCollection)
    	{
    		 GridBinder gridBinder = new GridBinder(request);
    		 GridSearchModel searchModel = gridBinder.GetGridSearchModel();
    		 List<RoleVsActivity> oResult = _RoleVsActivityManager.GetAllRoleVsActivity(searchModel).ToList();
    		 DataSourceResult result = oResult.ToDataSourceResult(request);
    		 request.Page = Convert.ToInt32(searchModel.Page);
             result.Total = Convert.ToInt32(searchModel.ResultCount);
             return Json(result, JsonRequestBehavior.AllowGet);
    	}
    }
}
