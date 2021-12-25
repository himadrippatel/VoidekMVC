using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public interface ISecondaryActivityController : IRootController
    {
        ActionResult Home();
        ActionResult Create();
        ActionResult CreatePost(SecondaryActivityViewModel secondaryActivityView, FormCollection formCollection);
        ActionResult DeletePost(int Id, FormCollection formCollection);
        ActionResult GetSecondaryActivityBySearch(DataSourceRequest request, FormCollection formCollection);
    }
}
