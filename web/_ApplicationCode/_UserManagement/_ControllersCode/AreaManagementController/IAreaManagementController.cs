using Alliant.Domain;
using Kendo.Mvc.UI;
using System.Collections.Generic;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
                      
    public interface IAreaManagementController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(AreaManagement oAreaManagement,FormCollection formCollection);
    	ActionResult GetAreaManagementById(int Id);
    	ActionResult Edit(int Id);
    	ActionResult EditPost(AreaManagement oAreaManagement,FormCollection formCollection);
    	ActionResult Delete(int Id);
    	ActionResult DeletePost(int Id,FormCollection formCollection);
    	ActionResult DeleteByModelAreaManagement(AreaManagement oAreaManagement,FormCollection formCollection);
    	//ActionResult GetAreaManagementBySearch(Search_AreaManagementModel oSearch_AreaManagementModel,FormCollection formCollection);
    	ActionResult GetAreaManagementBySearch(DataSourceRequest request,FormCollection formCollection);
        Dictionary<string, string> GetAreaManagementDropDwon();
    }
}
