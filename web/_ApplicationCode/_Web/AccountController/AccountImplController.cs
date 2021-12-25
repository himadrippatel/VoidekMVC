using Alliant.Domain;
using Alliant.Manager;
using System.Web.Mvc;
using System;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Security;

namespace Alliant._ApplicationCode
{
    public abstract class AccountImplController : _BaseController, IAccountController
    {
        IAccountManager _accountManager
        {
            get
            {
                return DependencyResolver.Current.GetService<IAccountManager>();
            }
        }

        public virtual ActionResult Index()
        {
            if (ValidRequestFilter()) return RedirectToAction("Index", "Home");

            UserLogin userLogin = GetUserCookie();
            return View(userLogin);
        }

        public virtual ActionResult LoginPost()
        {
            if (ValidRequestFilter()) return RedirectToAction("Index", "Home");

            UserLogin userLogin = GetUserCookie();
            return View("Index",userLogin);
        }

        public virtual ActionResult LoginPost(UserLogin userLogin)
        {

            UserLogin result = _accountManager.Login(userLogin);

            if (result != null && result.UserLoginID > 0)
            {
                LoginCustomer loginCustomer = _accountManager.GetLoginCustomer(result.UserID);
                if (userLogin.IsRemeber)
                    SetUserCookie(userLogin);
                else
                    RemoveUserCookie();

                UserSession oUserSession = null;
                string oToken = Guid.NewGuid().ToString();
                UserSession oGetSession = _sessionManager.GetUserSession(result.UserID, oToken);
                if (oGetSession == null)
                {
                    oUserSession = new UserSession()
                    {
                        UserID = result.UserID,
                        LastAccessOn = DateTime.Now,
                        Token = oToken,
                        Session_Token = SessionHijacking(),
                        Account_Rep = loginCustomer.Account_Rep,
                        AddrCity = loginCustomer.AddrCity,
                        Address = loginCustomer.Address,
                        AddrState = loginCustomer.AddrState,
                        AddrZip = loginCustomer.AddrZip,
                        creditapp = loginCustomer.creditapp,
                        creditauth = loginCustomer.creditauth,
                        CustAccountRep = loginCustomer.CustAccountRep,
                        CustID = loginCustomer.CustID,
                        Customer = loginCustomer.Customer,
                        donotcontact = loginCustomer.donotcontact,
                        DoNotContactBy = loginCustomer.DoNotContactBy,
                        DonotContactDate = loginCustomer.DonotContactDate,
                        Email = loginCustomer.Email,
                        Inactive = loginCustomer.Inactive,
                        IsVendor = loginCustomer.IsVendor,
                        OnHold = loginCustomer.OnHold,
                        Phone = loginCustomer.Phone,
                        UrgentNotes = loginCustomer.UrgentNotes,
                        VendorType = loginCustomer.VendorType,
                        WebAddress = loginCustomer.WebAddress,
                        Imageurl = loginCustomer.Imageurl
                    };
                    oGetSession = _sessionManager.AddUpdateUserSession(result.UserID, JsonConvert.SerializeObject(oUserSession), oUserSession.Token);
                }
                GetHttpCookie(true, oToken);
                //Session[SessionKeyConstant.Session_Token] = oToken;

                FormsAuthenticationTicket authenticationTicket = new FormsAuthenticationTicket(1, $"{oGetSession.CustID}_{oGetSession.Customer}", DateTime.Now, DateTime.Now.AddHours(24), true, oGetSession.UserID.ToString());
                string encryptedTicket = FormsAuthentication.Encrypt(authenticationTicket);
                Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket));
                return RedirectToAction("Index", "Home");
            }

            userLogin.Message = "You have entered an invalid username or password";

            return View("Index", userLogin);
        }

        public virtual ActionResult LogOut()
        {
            UserSession userSession = GetSession();
            //Session.Abandon();
            //Session.Clear();
            //Session.RemoveAll();

            Thread thread = new Thread(() =>
            {
                Dictionary<string, object> userCacheKeyValues = _alliantDataCacheManager.GetAllCache(userSession.UserID);

                foreach (KeyValuePair<string, object> userCache in userCacheKeyValues)
                    _alliantDataCacheManager.Delete(userCache.Key);
            });
            thread.Start();
            thread.IsBackground = true;

            _sessionManager.RemoveSession(userSession.UserID, userSession.Token);
            RemoveCookie(SessionKeyConstant.Cookie_Key);
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Account");
        }
    }
}