using System;
using System.Linq;
using Alliant.Domain;
using System.Web.Mvc;
using Alliant.Manager;
using Kendo.Mvc.UI;
using System.Collections.Generic;

namespace Alliant._ApplicationCode
{                      
    public abstract class AreaManagementImplController : _BaseController ,IAreaManagementController
    {

        /// <summary>
        /// Get Area manager
        /// </summary>
    	public virtual IAreaManagementManager _AreaManagementManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IAreaManagementManager>();
            }
        }
    
    	public virtual ActionResult Home()
    	{
            IsAuthorized("activity_usermanagement_areamanagement");
            UIContainer<AreaManagement> uIContainer = new UIContainer<AreaManagement>();
            uIContainer.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_areamanagement,activity_usermanagement_areamanagement_search,activity_usermanagement_areamanagement_insert,activity_usermanagement_areamanagement_update,activity_usermanagement_areamanagement_delete");
            return View("Index", uIContainer);
    	}
    	
        
    	public virtual ActionResult Create()
    	{
            IsAuthorized("activity_usermanagement_areamanagement_insert");
            
            AreaManagement oAreaManagement = _AreaManagementManager.Create();
             return View("Create", oAreaManagement);
    	}
    	
    	public virtual ActionResult CreatePost(AreaManagement oAreaManagement,FormCollection formCollection)
    	{
            IsAuthorized("activity_usermanagement_areamanagement_insert");

            try
            {
                _AreaManagementManager.CreatePost(oAreaManagement);
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
    	
    	public virtual ActionResult GetAreaManagementById(int Id)
    	{
    		AreaManagement oAreaManagement = _AreaManagementManager.GetAreaManagementById(Id);
    		return View("GetDetail",oAreaManagement);
    	}
    	
    	public virtual ActionResult Edit(int Id)
    	{
            IsAuthorized("activity_usermanagement_areamanagement_update");            

            AreaManagement oAreaManagement = _AreaManagementManager.GetAreaManagementById(Id);
    		return View("Edit",oAreaManagement);
    	}
    	
    	public virtual ActionResult EditPost(AreaManagement oAreaManagement,FormCollection formCollection)
    	{
            IsAuthorized("activity_usermanagement_areamanagement_update");

            try
            {               
                _AreaManagementManager.EditPost(oAreaManagement);
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
            IsAuthorized("activity_usermanagement_areamanagement_delete");

            AreaManagement oAreaManagement = _AreaManagementManager.GetAreaManagementById(Id);
    		return View("Delete",oAreaManagement);
    	}
    	
    	public virtual ActionResult DeletePost(int Id,FormCollection formCollection)
    	{
            IsAuthorized("activity_usermanagement_areamanagement_delete");
            try
            {
                _AreaManagementManager.DeletePost(Id);
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
    	
    	public virtual ActionResult DeleteByModelAreaManagement(AreaManagement oAreaManagement,FormCollection formCollection)
    	{
    		return View();
    	}
    	
    	/*public virtual ActionResult GetAreaManagementBySearch(Search_AreaManagementModel oSearch_AreaManagementModel,FormCollection formCollection)
    	{
    		var oResult = _AreaManagementManager.GetAllAreaManagement(oSearch_AreaManagementModel).ToList();
    		return View("Grid",oResult);
    	}*/
    	
    	public virtual ActionResult GetAreaManagementBySearch(DataSourceRequest request,FormCollection formCollection)
    	{            
    		 GridBinder gridBinder = new GridBinder(request);
    		 GridSearchModel searchModel = gridBinder.GetGridSearchModel();
    		 List<AreaManagement> oResult = _AreaManagementManager.GetAllAreaManagement(searchModel).ToList();
    		 DataSourceResult result = oResult.ToDataSourceResult(request);
    		 request.Page = Convert.ToInt32(searchModel.Page);
             result.Total = Convert.ToInt32(searchModel.ResultCount);
             return Json(result, JsonRequestBehavior.AllowGet);
    	}

        public Dictionary<string, string> GetAreaManagementDropDwon()
        {
            List<AreaManagement> oResult = _AreaManagementManager.GetAllAreaManagement(new GridSearchModel() { }).ToList();
            return oResult.Select(x => new { Value = x.AreaID.ToString(), Text = x.Name }).ToDictionary(x => x.Value, x => x.Text);
        }
    }
}
