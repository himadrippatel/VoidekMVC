using Alliant.Domain;
using Kendo.Mvc.UI;
using System.Collections.Generic;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public interface IRoleController : IRootController
    {
        ActionResult Home();
        ActionResult Create();
        ActionResult CreatePost(Role oRole, FormCollection formCollection);
        ActionResult GetRoleById(int Id);
        ActionResult Edit(int Id);
        ActionResult EditPost(Role oRole, FormCollection formCollection);
        ActionResult Delete(int Id);
        ActionResult DeletePost(int Id, FormCollection formCollection);
        ActionResult DeleteByModelRole(Role oRole, FormCollection formCollection);
        ActionResult GetRoleBySearch(DataSourceRequest request);
        IDictionary<string, string> GetRoleDropDown();
        JsonResult GetRoleHierarchicalViewModel(int? Id);
        JsonResult SearchRoleSelect(SearchRequest searchRequest, FormCollection formCollection);
    }
}
