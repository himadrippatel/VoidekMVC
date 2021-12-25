using Alliant._ApplicationCode;
using Alliant.Domain;
using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant.Areas.UserManagement.Controllers
{
    public class ActivityVsUserController : ActivityVsUserImplController
    {
        public ActionResult Index() => base.Home();

        public override ActionResult Create() => base.Create();

        [HttpPost]
        public override ActionResult CreatePost(ActivityVsUserViewModel activityVsUserViewModel, FormCollection formCollection) => base.CreatePost(activityVsUserViewModel, formCollection);

        [HttpPost]
        public override ActionResult DeletePost(int Id, FormCollection formCollection) => base.DeletePost(Id, formCollection);

        [HttpPost]
        public override ActionResult GetActivityVsUserBySearch([DataSourceRequest]DataSourceRequest request, FormCollection formCollection) => base.GetActivityVsUserBySearch(request, formCollection);
    }
}