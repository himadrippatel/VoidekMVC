using System.Web.Mvc;
using Alliant._ApplicationCode;

namespace Alliant.Areas.Administrator.Controllers
{
    public class SharedResourcesController : SharedResourcesImplController
    {

        //public override ActionResult Menu()
        //{
        //    //Dictionary<string, bool> dtMenuPermission = new Dictionary<string, bool>();
        //    //dtMenuPermission.Add("GeneralMaster", true);
        //    //return PartialView(dtMenuPermission);
        //    return base.Menu();
        //}
        [ChildActionOnly]
        public override ActionResult Menu()
        {
            AreaManagement = Constant.AreaAdministrator;
            return base.Menu();
        }
    }
}