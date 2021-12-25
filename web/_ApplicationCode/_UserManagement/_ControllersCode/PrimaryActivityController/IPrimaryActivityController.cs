using Alliant.Domain;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{                  
    public interface IPrimaryActivityController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(PrimaryActivity oPrimaryActivity,FormCollection formCollection);    	
    	ActionResult DeletePost(int Id,FormCollection formCollection);    	
    	ActionResult GetPrimaryActivityBySearch(DataSourceRequest request,FormCollection formCollection);
        JsonResult Suggestion(string term, FormCollection formCollection);
        JsonResult SearchPrimaryActivity(SearchRequest searchRequest, FormCollection formCollection);
    }
}
