using Alliant._ApplicationCode;
using System.Web.Mvc;

namespace Alliant.Areas.UserManagement.Controllers
{
    public class DefaultController : _BaseController
    {
        // GET: UserManagement/Default
        public ActionResult Index()
        {
            return View();
        }
    }
}