using Alliant.Domain;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{                      
    public interface IIconController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(Icon oIcon,FormCollection formCollection);
    	ActionResult GetIconById(int Id);
    	ActionResult Edit(int Id);
    	ActionResult EditPost(Icon oIcon,FormCollection formCollection);
    	ActionResult Delete(int Id);
    	ActionResult DeletePost(int Id,FormCollection formCollection);
    	ActionResult DeleteByModelIcon(Icon oIcon,FormCollection formCollection);
    	//ActionResult GetIconBySearch(Search_IconModel oSearch_IconModel,FormCollection formCollection);
    	ActionResult GetIconBySearch(DataSourceRequest request,FormCollection formCollection);
    }
}
