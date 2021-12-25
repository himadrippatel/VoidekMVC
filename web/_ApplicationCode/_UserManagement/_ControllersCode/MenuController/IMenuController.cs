using Alliant.Domain;
using System.Web.Mvc;
using System.Collections.Generic;

namespace Alliant._ApplicationCode
{                      
    public interface IMenuController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(Menu oMenu,FormCollection formCollection);
    	ActionResult GetMenuById(int Id);
    	ActionResult Edit(int Id);
    	ActionResult EditPost(Menu oMenu,FormCollection formCollection);
    	ActionResult Delete(int Id);
    	ActionResult DeletePost(int Id,FormCollection formCollection);
    	ActionResult DeleteByModelMenu(Menu oMenu,FormCollection formCollection);
    	//ActionResult GetMenuBySearch(Search_MenuModel oSearch_MenuModel,FormCollection formCollection);
    	ActionResult GetMenuBySearch(Kendo.Mvc.UI.DataSourceRequest request,FormCollection formCollection);
        Dictionary<string, string> GetMenuDropDown();
        JsonResult GetMenuJsonDropDown(string id, string fixedValues = null);
        ActionResult Sequence();
        ActionResult SequenceMenu(int AreaID);
        ActionResult UpdateSequence(List<Menu> menus,FormCollection formCollection);
    }
}
