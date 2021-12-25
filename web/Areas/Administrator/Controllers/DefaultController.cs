using Alliant._ApplicationCode;
using System.Web.Mvc;

namespace Alliant.Areas.Administrator.Controllers
{
    public class DefaultController : _BaseController
    {
        // GET: Administrator/Default
        public ActionResult Index()
        {
            return View();
        }
    }
}