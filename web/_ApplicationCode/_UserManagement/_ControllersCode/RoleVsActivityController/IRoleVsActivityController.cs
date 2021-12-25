using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{                      
    public interface IRoleVsActivityController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(RoleVsActivityViewModel roleVsActivityView, FormCollection formCollection);    	
    	ActionResult DeletePost(int Id,FormCollection formCollection);    	
    	//ActionResult GetRoleVsActivityBySearch(Search_RoleVsActivityModel oSearch_RoleVsActivityModel,FormCollection formCollection);
    	ActionResult GetRoleVsActivityBySearch(DataSourceRequest request,FormCollection formCollection);
    }
}
