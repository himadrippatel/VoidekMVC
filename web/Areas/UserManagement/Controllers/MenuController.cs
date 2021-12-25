using Alliant.Domain;
using System.Web.Mvc;
using Alliant._ApplicationCode;
using System.Collections.Generic;

namespace Alliant.Areas.UserManagement.Controllers
{
                      
    public class MenuController : MenuImplController
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
        [ValidateInput(false)]
    	public override ActionResult CreatePost(Menu oMenu, FormCollection formCollection)
    	{
    		return base.CreatePost(oMenu, formCollection);
    	}
    	
    	public override ActionResult Edit(int Id)
    	{
    		return base.Edit(Id);
    	}
    
    	[HttpPost]
        [ValidateInput(false)]
        public override ActionResult EditPost(Menu oMenu, FormCollection formCollection)
    	{
    		return base.EditPost(oMenu, formCollection);
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
    
    	/*public override ActionResult GetMenuBySearch(Search_MenuModel oSearch_MenuModel,FormCollection formCollection)
        {
        	return base.GetMenuBySearch(oSearch_MenuModel,formCollection);
        }*/
    
    	[HttpPost]
    	public override ActionResult GetMenuBySearch([Kendo.Mvc.UI.DataSourceRequest]Kendo.Mvc.UI.DataSourceRequest request,FormCollection formCollection)
        {            
        	return base.GetMenuBySearch(request,formCollection);
        }

        public ActionResult MenuDropDown(AlliantDropDownDataModel oDropDownDataModel)
        {           
            oDropDownDataModel.ConfigurationOptions.ControlID = oDropDownDataModel.ConfigurationOptions.ControlID ?? "MenuID";
            if (oDropDownDataModel.Model == null)
            {
                oDropDownDataModel.Model = base.GetMenuDropDown();
            }
            return View("DropDown", oDropDownDataModel);
        }

        public JsonResult MenuJsonDropDown(string id, string fixedValues = null)
        {
            return base.GetMenuJsonDropDown(id, fixedValues);
        }

        public override ActionResult Sequence()
        {
            return base.Sequence();
        }

        public override ActionResult SequenceMenu(int AreaID)
        {
            return base.SequenceMenu(AreaID);
        }

        [HttpPost]
        public override ActionResult UpdateSequence(List<Menu> menus, FormCollection formCollection)
        {
            return base.UpdateSequence(menus, formCollection);
        }
    }
}
