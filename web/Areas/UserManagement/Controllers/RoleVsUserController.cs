using Alliant._ApplicationCode;
using Alliant.Domain;
using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System.Web.Mvc;
namespace Alliant.Areas.UserManagement.Controllers
{
    public class RoleVsUserController : RoleVsUserImplController
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
        public override ActionResult CreatePost(RoleVsUserViewModel roleVsUserViewModel, FormCollection formCollection)
        {
            return base.CreatePost(roleVsUserViewModel, formCollection);
        }

        public override ActionResult Edit(int Id)
        {
            return base.Edit(Id);
        }

        [HttpPost]
        public override ActionResult EditPost(RoleVsUser oRoleVsUser, FormCollection formCollection)
        {
            return base.EditPost(oRoleVsUser, formCollection);
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

        /*public override ActionResult GetRoleVsUserBySearch(Search_RoleVsUserModel oSearch_RoleVsUserModel,FormCollection formCollection)
        {
        	return base.GetRoleVsUserBySearch(oSearch_RoleVsUserModel,formCollection);
        }*/

        [HttpPost]
        public override ActionResult GetRoleVsUserBySearch([DataSourceRequest]DataSourceRequest request, FormCollection formCollection)
        {
            return base.GetRoleVsUserBySearch(request, formCollection);
        }

        public override JsonResult Search(string term, string notIn, FormCollection formCollection)
        {
            return base.Search(term, notIn, formCollection);
        }

        [HttpPost]
        public override JsonResult SearchUser(SearchRequest searchRequest, FormCollection formCollection)
        {
            return base.SearchUser(searchRequest, formCollection);
        }
    }
}
