using Alliant.Domain;
using Kendo.Mvc.UI;
using System.Collections.Generic;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
                      
    public interface IPermissionController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(Permission oPermission,FormCollection formCollection);
    	ActionResult GetPermissionById(int Id);
    	ActionResult Edit(int Id);
    	ActionResult EditPost(Permission oPermission,FormCollection formCollection);
    	ActionResult Delete(int Id);
    	ActionResult DeletePost(int Id,FormCollection formCollection);
    	ActionResult DeleteByModelPermission(Permission oPermission,FormCollection formCollection);
    	//ActionResult GetPermissionBySearch(Search_PermissionModel oSearch_PermissionModel,FormCollection formCollection);
    	ActionResult GetPermissionBySearch(DataSourceRequest request,FormCollection formCollection);
        IDictionary<string, string> GetPermissionDropDown();
    }
}
