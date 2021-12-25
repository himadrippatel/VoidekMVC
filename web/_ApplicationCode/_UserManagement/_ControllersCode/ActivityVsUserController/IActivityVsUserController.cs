using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{                      
    public interface IActivityVsUserController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(ActivityVsUserViewModel activityVsUserViewModel, FormCollection formCollection);    
    	ActionResult DeletePost(int Id,FormCollection formCollection);    	
    	ActionResult GetActivityVsUserBySearch(DataSourceRequest request,FormCollection formCollection);
    }
}
