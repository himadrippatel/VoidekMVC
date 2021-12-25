using Alliant._ApplicationCode;
using System.Web.Mvc;

namespace Alliant.Areas.UserManagement.Controllers
{
    public class SharedResourcesController : SharedResourcesImplController
    {

        [ChildActionOnly]
        public override ActionResult Menu()
        {
            AreaManagement = Constant.AreaUserManagement;
            return base.Menu();
        }

    }
}