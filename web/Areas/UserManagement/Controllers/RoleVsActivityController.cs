using Alliant._ApplicationCode;
using Alliant.Domain;
using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant.Areas.UserManagement.Controllers
{                      
    public class RoleVsActivityController : RoleVsActivityImplController
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
    	public override ActionResult CreatePost(RoleVsActivityViewModel roleVsActivityView, FormCollection formCollection)
    	{
    		return base.CreatePost(roleVsActivityView, formCollection);
    	}   
    
    	[HttpPost]
    	public override ActionResult DeletePost(int Id, FormCollection formCollection)
    	{
    		return base.DeletePost(Id, formCollection);
    	}
    
    	/*public override ActionResult GetRoleVsActivityBySearch(Search_RoleVsActivityModel oSearch_RoleVsActivityModel,FormCollection formCollection)
        {
        	return base.GetRoleVsActivityBySearch(oSearch_RoleVsActivityModel,formCollection);
        }*/
    
    	[HttpPost]
    	public override ActionResult GetRoleVsActivityBySearch([DataSourceRequest]DataSourceRequest request,FormCollection formCollection)
        {
        	return base.GetRoleVsActivityBySearch(request,formCollection);
        }
    }
}
