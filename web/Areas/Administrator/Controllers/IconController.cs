using Alliant._ApplicationCode;
using Alliant.Domain;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant.Areas.Administrator.Controllers
{                      
    public class IconController : IconImplController
    {
    	public virtual ActionResult Index()
    	{
    		return base.Home();
    	}
    	
    	public override ActionResult Create()
    	{
    		return base.Create();
    	}
    
        [ValidateInput(false)]
    	[HttpPost]
    	public override ActionResult CreatePost(Icon oIcon, FormCollection formCollection)
    	{
    		return base.CreatePost(oIcon, formCollection);
    	}
    	
    	public override ActionResult Edit(int Id)
    	{
    		return base.Edit(Id);
    	}

        [ValidateInput(false)]
        [HttpPost]
    	public override ActionResult EditPost(Icon oIcon, FormCollection formCollection)
    	{
    		return base.EditPost(oIcon, formCollection);
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
    
    	/*public override ActionResult GetIconBySearch(Search_IconModel oSearch_IconModel,FormCollection formCollection)
        {
        	return base.GetIconBySearch(oSearch_IconModel,formCollection);
        }*/
    
    	[HttpPost]
    	public override ActionResult GetIconBySearch([DataSourceRequest]DataSourceRequest request,FormCollection formCollection)
        {
        	return base.GetIconBySearch(request,formCollection);
        }
    }
}
