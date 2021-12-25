using Alliant.Domain;
using System.Web.Mvc;
using Alliant._ApplicationCode;

namespace Alliant.Controllers
{
    [AlliantFilterAttribute(false)]
    public class AccountController : AccountImplController
    {
        public override ActionResult Index() => base.Index();

        public override ActionResult LoginPost() => base.LoginPost();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(UserLogin userLogin, FormCollection formCollection) => base.LoginPost(userLogin);

        public override ActionResult LogOut() => base.LogOut();
    }
}