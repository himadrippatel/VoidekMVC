using Alliant.Domain;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public interface IAccountController
    {
        ActionResult Index();

        ActionResult LoginPost();
        ActionResult LoginPost(UserLogin userLogin);

        ActionResult LogOut();
    }
}