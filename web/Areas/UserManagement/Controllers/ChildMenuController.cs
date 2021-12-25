using Alliant.Domain;
using System.Web.Mvc;
using Kendo.Mvc.UI;
using Alliant._ApplicationCode;
using System.Collections.Generic;

namespace Alliant.Areas.UserManagement.Controllers
{
                      
    public class ChildMenuController : ChildMenuImplController
    {
        public virtual ActionResult Index() => base.Home();

        public override ActionResult Create() => base.Create();

        [HttpPost]
        [ValidateInput(false)]
        public override ActionResult CreatePost(ChildMenu oChildMenu, FormCollection formCollection) => base.CreatePost(oChildMenu, formCollection);

        public override ActionResult Edit(int Id) => base.Edit(Id);

        [HttpPost]
        [ValidateInput(false)]
        public override ActionResult EditPost(ChildMenu oChildMenu, FormCollection formCollection) => base.EditPost(oChildMenu, formCollection);

        public override ActionResult Delete(int Id) => base.Delete(Id);

        [HttpPost]
        public override ActionResult DeletePost(int Id, FormCollection formCollection) => base.DeletePost(Id, formCollection);

        /*public override ActionResult GetChildMenuBySearch(Search_ChildMenuModel oSearch_ChildMenuModel,FormCollection formCollection)
        {
        	return base.GetChildMenuBySearch(oSearch_ChildMenuModel,formCollection);
        }*/

        [HttpPost]
        public override ActionResult GetChildMenuBySearch([DataSourceRequest]DataSourceRequest request, FormCollection formCollection) => base.GetChildMenuBySearch(request, formCollection);

        public override ActionResult Sequence() => base.Sequence();

        public override ActionResult SequenceChildMenu(int MenuID) => base.SequenceChildMenu(MenuID);

        [HttpPost]
        public override ActionResult UpdateSequence(List<ChildMenu> menus, FormCollection formCollection) => base.UpdateSequence(menus, formCollection);
    }
}
