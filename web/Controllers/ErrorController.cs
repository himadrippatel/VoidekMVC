using Alliant._ApplicationCode;
using System.Web.Mvc;

namespace Alliant.Controllers
{
    public class ErrorController : _BaseController
    {
        // GET: Error
        public ActionResult Index()
        {
            return View();
        }
    }
}