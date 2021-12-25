using Alliant._ApplicationCode;
using Alliant.Domain;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant.Areas.UserManagement.Controllers
{
                      
    public class AreaManagementController : AreaManagementImplController
    {
        public virtual ActionResult Index() => base.Home();

        public override ActionResult Create() => base.Create();

        [HttpPost]
        public override ActionResult CreatePost(AreaManagement oAreaManagement, FormCollection formCollection) => base.CreatePost(oAreaManagement, formCollection);

        public override ActionResult Edit(int Id) => base.Edit(Id);

        [HttpPost]
        public override ActionResult EditPost(AreaManagement oAreaManagement, FormCollection formCollection) => base.EditPost(oAreaManagement, formCollection);

        public override ActionResult Delete(int Id) => base.Delete(Id);

        [HttpPost]
        public override ActionResult DeletePost(int Id, FormCollection formCollection) => base.DeletePost(Id, formCollection);

        /*public override ActionResult GetAreaManagementBySearch(Search_AreaManagementModel oSearch_AreaManagementModel,FormCollection formCollection)
        {
        	return base.GetAreaManagementBySearch(oSearch_AreaManagementModel,formCollection);
        }*/

        [HttpPost]
        public override ActionResult GetAreaManagementBySearch([DataSourceRequest]DataSourceRequest request, FormCollection formCollection) => base.GetAreaManagementBySearch(request, formCollection);

        public ActionResult AreaManagementDropDwon(AlliantDropDownDataModel oDropDownDataModel)
        {            
            oDropDownDataModel.ConfigurationOptions.ControlID = oDropDownDataModel.ConfigurationOptions.ControlID ?? "AreaID";
            if (oDropDownDataModel.Model == null)
            {
                oDropDownDataModel.Model = base.GetAreaManagementDropDwon();
            }
            return View("DropDown", oDropDownDataModel);
        }
    }
}
