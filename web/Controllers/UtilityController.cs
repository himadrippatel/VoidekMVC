using Alliant._ApplicationCode;
using System.Web.Mvc;

namespace Alliant.Controllers
{
    public class UtilityController : UtilityImplController
    {
        public override ActionResult UserLoginData()
        {
            return base.UserLoginData();
        }

        [HttpPost]
        public override ActionResult UserLoginDataUpdate()
        {
            return base.UserLoginDataUpdate();
        }

        public override ActionResult SyncController()
        {
            return base.SyncController();
        }
    }
}