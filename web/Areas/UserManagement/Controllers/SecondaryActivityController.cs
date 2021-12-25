using System.Web.Mvc;
using Alliant._ApplicationCode;
using Alliant.ViewModel;
using Kendo.Mvc.UI;

namespace Alliant.Areas.UserManagement.Controllers
{
    public class SecondaryActivityController : SecondaryActivityImplController
    {
        public ActionResult Index()
        {
            return base.Home();
        }

        public override ActionResult Create()
        {
            return base.Create();
        }

        [HttpPost]
        public override ActionResult CreatePost(SecondaryActivityViewModel secondaryActivityView, FormCollection formCollection)
        {
            return base.CreatePost(secondaryActivityView, formCollection);
        }

        [HttpPost]
        public override ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            return base.DeletePost(Id, formCollection);
        }

        public override ActionResult GetSecondaryActivityBySearch([DataSourceRequest]DataSourceRequest request, FormCollection formCollection)
        {
            return base.GetSecondaryActivityBySearch(request, formCollection);
        }
    }
}