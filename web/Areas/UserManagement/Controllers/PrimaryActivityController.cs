using System.Web.Mvc;
using Alliant._ApplicationCode;
using Alliant.Domain;
using Kendo.Mvc.UI;

namespace Alliant.Areas.UserManagement.Controllers
{
    public class PrimaryActivityController : PrimaryActivityImplController
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
        public override ActionResult CreatePost(PrimaryActivity oPrimaryActivity, FormCollection formCollection)
        {
            return base.CreatePost(oPrimaryActivity, formCollection);
        }

        [HttpPost]
        public override ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            return base.DeletePost(Id, formCollection);
        }

        public override ActionResult GetPrimaryActivityBySearch([DataSourceRequest]DataSourceRequest request, FormCollection formCollection)
        {
            return base.GetPrimaryActivityBySearch(request, formCollection);
        }

        public override JsonResult Suggestion(string term, FormCollection formCollection)
        {
            return base.Suggestion(term, formCollection);
        }

        [HttpPost]
        public override JsonResult SearchPrimaryActivity(SearchRequest searchRequest, FormCollection formCollection)
        {
            return base.SearchPrimaryActivity(searchRequest, formCollection);
        }
    }
}