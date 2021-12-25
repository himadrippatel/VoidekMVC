using Alliant.Manager;
using System.Web.Mvc;
using Alliant.Domain;
using System;
using Kendo.Mvc.UI;
using System.Collections.Generic;
using System.Linq;


namespace Alliant._ApplicationCode
{
                      
    public abstract class IconImplController : _BaseController ,IIconController
    {		
    	public virtual IIconManager _IconManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IIconManager>();
            }
        }
    
    	public virtual ActionResult Home()
    	{
    		return View("Index");
    	}
    	
    	public virtual ActionResult Create()
    	{
    		 Icon oIcon = _IconManager.Create();
             return View("Create", oIcon);
    	}
    	
    	public virtual ActionResult CreatePost(Icon oIcon,FormCollection formCollection)
    	{
    		try
            {
                _IconManager.CreatePost(oIcon);
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
    	
    	public virtual ActionResult GetIconById(int Id)
    	{
    		Icon oIcon = _IconManager.GetIconById(Id);
    		return View("GetDetail",oIcon);
    	}
    	
    	public virtual ActionResult Edit(int Id)
    	{
    		Icon oIcon = _IconManager.GetIconById(Id);
    		return View("Edit",oIcon);
    	}
    	
    	public virtual ActionResult EditPost(Icon oIcon,FormCollection formCollection)
    	{
    		try
            {
                _IconManager.EditPost(oIcon);
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
    	
    	public virtual ActionResult Delete(int Id)
    	{
    		Icon oIcon = _IconManager.GetIconById(Id);
    		return View("Delete",oIcon);
    	}
    	
    	public virtual ActionResult DeletePost(int Id,FormCollection formCollection)
    	{
    		try
            {
                _IconManager.DeletePost(Id);
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
    	
    	public virtual ActionResult DeleteByModelIcon(Icon oIcon,FormCollection formCollection)
    	{
    		return View();
    	}
    	
    	/*public virtual ActionResult GetIconBySearch(Search_IconModel oSearch_IconModel,FormCollection formCollection)
    	{
    		var oResult = _IconManager.GetAllIcon(oSearch_IconModel).ToList();
    		return View("Grid",oResult);
    	}*/
    	
    	public virtual ActionResult GetIconBySearch(DataSourceRequest request,FormCollection formCollection)
    	{
    		 GridBinder gridBinder = new GridBinder(request);
    		 GridSearchModel searchModel = gridBinder.GetGridSearchModel();
    		 List<Icon> oResult = _IconManager.GetAllIcon(searchModel).ToList();
    		 DataSourceResult result = oResult.ToDataSourceResult(request);
    		 request.Page = Convert.ToInt32(searchModel.Page);
             result.Total = Convert.ToInt32(searchModel.ResultCount);
             return Json(result, JsonRequestBehavior.AllowGet);
    	}
    }
}
