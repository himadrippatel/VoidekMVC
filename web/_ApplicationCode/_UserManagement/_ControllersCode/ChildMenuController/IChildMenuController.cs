using Alliant.Domain;
using System.Web.Mvc;
using Kendo.Mvc.UI;
using System.Collections.Generic;

namespace Alliant._ApplicationCode
{
                      
    public interface IChildMenuController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(ChildMenu oChildMenu,FormCollection formCollection);
    	ActionResult GetChildMenuById(int Id);
    	ActionResult Edit(int Id);
    	ActionResult EditPost(ChildMenu oChildMenu,FormCollection formCollection);
    	ActionResult Delete(int Id);
    	ActionResult DeletePost(int Id,FormCollection formCollection);
    	ActionResult DeleteByModelChildMenu(ChildMenu oChildMenu,FormCollection formCollection);
    	//ActionResult GetChildMenuBySearch(Search_ChildMenuModel oSearch_ChildMenuModel,FormCollection formCollection);
    	ActionResult GetChildMenuBySearch(DataSourceRequest request,FormCollection formCollection);
        ActionResult Sequence();
        ActionResult SequenceChildMenu(int MenuID);
        ActionResult UpdateSequence(List<ChildMenu> menus, FormCollection formCollection);
    }
}
