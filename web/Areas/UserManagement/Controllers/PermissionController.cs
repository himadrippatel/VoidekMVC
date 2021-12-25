using Alliant._ApplicationCode;
using Alliant.Domain;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant.Areas.UserManagement.Controllers
{

    public class PermissionController : PermissionImplController
    {
    	public virtual ActionResult Index()
    	{
    		return base.Home();
    	}
    	
    	public override ActionResult Create()
    	{
    		return base.Create();
    	}
    
    	[HttpPost]
    	public override ActionResult CreatePost(Permission oPermission, FormCollection formCollection)
    	{
    		return base.CreatePost(oPermission, formCollection);
    	}
    	
    	public override ActionResult Edit(int Id)
    	{
    		return base.Edit(Id);
    	}
    
    	[HttpPost]
    	public override ActionResult EditPost(Permission oPermission, FormCollection formCollection)
    	{
    		return base.EditPost(oPermission, formCollection);
    	}
    
    	public override ActionResult Delete(int Id)
    	{
    		return base.Delete(Id);
    	}
    
    	[HttpPost]
    	public override ActionResult DeletePost(int Id, FormCollection formCollection)
    	{
    		return base.DeletePost(Id, formCollection);
    	}
    
    	/*public override ActionResult GetPermissionBySearch(Search_PermissionModel oSearch_PermissionModel,FormCollection formCollection)
        {
        	return base.GetPermissionBySearch(oSearch_PermissionModel,formCollection);
        }*/
    
    	[HttpPost]
    	public override ActionResult GetPermissionBySearch([DataSourceRequest]DataSourceRequest request,FormCollection formCollection)
        {
        	return base.GetPermissionBySearch(request,formCollection);
        }

        public ActionResult PermissionDropDown(AlliantDropDownDataModel oDropDownDataModel)
        {            
            oDropDownDataModel.ConfigurationOptions.ControlID = oDropDownDataModel.ConfigurationOptions.ControlID ?? "PermissionID";
            if (oDropDownDataModel.Model == null)
            {
                oDropDownDataModel.Model = base.GetPermissionDropDown();
            }
            return View("DropDown", oDropDownDataModel);
        }
    }
}
