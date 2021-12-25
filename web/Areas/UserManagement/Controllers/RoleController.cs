using Alliant._ApplicationCode;
using Alliant.Domain;
using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace Alliant.Areas.UserManagement.Controllers
{
    public class RoleController : RoleImplController
    {
        public ActionResult Index()
        {
            return base.Home();
        }

        [HttpPost]
        public ActionResult Grid([DataSourceRequest]DataSourceRequest request)
        {
            return base.GetRoleBySearch(request);
        }

        public override ActionResult Create()
        {
            return base.Create();
        }

        [HttpPost]
        public override ActionResult CreatePost(Role oRole, FormCollection formCollection)
        {
            return base.CreatePost(oRole, formCollection);
        }

        public override ActionResult Edit(int Id)
        {
            return base.Edit(Id);
        }

        [HttpPost]
        public override ActionResult EditPost(Role oRole, FormCollection formCollection)
        {
            return base.EditPost(oRole, formCollection);
        }

        public override ActionResult Delete(int Id)
        {
            return base.Delete(Id);
        }

        public override ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            return base.DeletePost(Id, formCollection);
        }

        public ActionResult RoleDropDown(AlliantDropDownDataModel oDropDownDataModel)
        {            
            oDropDownDataModel.ConfigurationOptions.ControlID = oDropDownDataModel.ConfigurationOptions.ControlID ?? "ParentID";
            if (oDropDownDataModel.Model == null)
            {
                oDropDownDataModel.Model = GetRoleDropDown();
            }
            return View("DropDown", oDropDownDataModel);
        }

        public JsonResult RoleDropDownTreeData(int? id)
        {
            return base.GetRoleHierarchicalViewModel(id);
        }

        public override JsonResult SearchRoleSelect(SearchRequest searchRequest, FormCollection formCollection)
        {
            return base.SearchRoleSelect(searchRequest, formCollection);
        }
    }
}