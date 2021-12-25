using Alliant.Domain;
using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{                      
    public interface IRoleVsUserController : IRootController
    {		
    	ActionResult Home();
    	ActionResult Create();
    	ActionResult CreatePost(RoleVsUserViewModel roleVsUserViewModel, FormCollection formCollection);
    	ActionResult GetRoleVsUserById(int Id);
    	ActionResult Edit(int Id);
    	ActionResult EditPost(RoleVsUser oRoleVsUser,FormCollection formCollection);
    	ActionResult Delete(int Id);
    	ActionResult DeletePost(int Id,FormCollection formCollection);
    	ActionResult DeleteByModelRoleVsUser(RoleVsUser oRoleVsUser,FormCollection formCollection);
    	//ActionResult GetRoleVsUserBySearch(Search_RoleVsUserModel oSearch_RoleVsUserModel,FormCollection formCollection);
    	ActionResult GetRoleVsUserBySearch(DataSourceRequest request,FormCollection formCollection);
        JsonResult Search(string term,string notIn, FormCollection formCollection);
        JsonResult SearchUser(SearchRequest searchRequest, FormCollection formCollection);
    }
}
