using Alliant.Common;
using Alliant.Domain;
using Alliant.Manager;
using Alliant.Utility;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Alliant._ApplicationCode
{
    [SessionState(System.Web.SessionState.SessionStateBehavior.Disabled)]
    public class _BaseController : Controller
    {
        /// <summary>
        /// get session manager
        /// </summary>
        public ISessionManager _sessionManager
            => DependencyResolver.Current.GetService<ISessionManager>();

        /// <summary>
        /// Alliant cache manager for quick performace
        /// </summary>
        public AlliantDataCacheManager _alliantDataCacheManager 
            => AlliantDataCacheManager.Instance;

        /// <summary>
        /// Alliant configuration section read any appSetting in web.config
        /// </summary>
        public AlliantConfigurationSection _alliantConfigurationSection 
            => DependencyResolver.Current.GetService<AlliantConfigurationSection>();

        /// <summary>
        /// get login user detail
        /// </summary>
        public UserSession _userSession 
            => GetSession();

        /// <summary>
        /// get login userid
        /// </summary>
        public int _UserID 
            => GetSession().UserID;

        /// <summary>
        /// get current user Activities
        /// </summary>
        public IDictionary<string, bool> _dtUserActivities 
            => GetSession().dtUserActivities;

        /// <summary>
        /// get user login authorizationManager access
        /// </summary>
        public IAuthorizationManager _authorizationManager 
            => DependencyResolver.Current.GetService<IAuthorizationManager>();

        /// <summary>
        /// handle error & insert log
        /// </summary>
        public IErrorLogManager _errorLogManager 
            => DependencyResolver.Current.GetService<IErrorLogManager>();

        /// <summary>
        /// use for cache key
        /// </summary>
        public string _cacheKey { get; set; }

        #region authorization
        /// <summary>
        /// Prevent other user access unauthorized access role/permission
        /// </summary>
        /// <param name="activity">activity name</param>
        /// <param name="message">message for display</param>
        public virtual void IsAuthorized(string activity, string message = null)
        {
            if (!_authorizationManager.IsAuthorized(activity))
                throw new UnauthorizedAccessException(message ?? Constant.UnauthorizedMessage);
        }
        #endregion

        #region UI Exception
        public ActionResult HandleException(Exception oException)
        {
            string controllerName = Convert.ToString(RouteData.Values["controller"]);
            string actionName = Convert.ToString(RouteData.Values["action"]);
            if (oException != null)
            {
                LogError(oException);
                HandleErrorInfo handleErrorInfo = new HandleErrorInfo(oException, controllerName, actionName);
                return View("CommonError", null, handleErrorInfo);
            }
            else
            {
                //return Json(new ActionResultData() { Success = false, Message = "SomeThing went wrong please contact to admin" }, JsonRequestBehavior.AllowGet);
                return View("CommonError", null, new HandleErrorInfo(new Exception("SomeThing went wrong please contact to admin"), controllerName, actionName));
            }
        }
        public void LogError(Exception ex, string RoutesValues = "")
        {
            try
            {
                if (string.IsNullOrEmpty(RoutesValues))
                {
                    RoutesValues = $"Area Name {Convert.ToString(RouteData.Values["area"])} Controller Name: {Convert.ToString(RouteData.Values["controller"])} Action Name: { Convert.ToString(RouteData.Values["action"]) }";
                }
                _errorLogManager.CreateErrorLog(new ErrorLog()
                {
                    Message = ex.Message,
                    Route = RoutesValues,
                    StatckTrace = ex.StackTrace,
                    UserID = _UserID
                });
            }
            catch (Exception failedException)
            {
                FileLog(failedException);
            }
        }

        public void FileLog(Exception ex, string RoutesValues = "")
        {
            /*Genrate UserWise File Here*/
            if (string.IsNullOrEmpty(RoutesValues))
            {
                RoutesValues = $"Area Name {Convert.ToString(RouteData.Values["area"])} Controller Name: {Convert.ToString(RouteData.Values["controller"])} Action Name: { Convert.ToString(RouteData.Values["action"]) }";
            }
            StringBuilder message = new StringBuilder(string.Format("Time: {0}", DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss tt")));
            message.Append(Environment.NewLine);
            message.Append("-----------------------------------------------------------");
            message.Append(Environment.NewLine);
            message.Append("Route Values " + RoutesValues);
            message.Append(Environment.NewLine);
            message.Append(Environment.NewLine);
            message.Append(string.Format("Message: {0}", ex.Message));
            message.Append(Environment.NewLine);
            message.Append(string.Format("StackTrace: {0}", ex.StackTrace));
            message.Append(Environment.NewLine);
            message.Append(string.Format("Source: {0}", ex.Source));
            message.Append(Environment.NewLine);
            message.Append(string.Format("TargetSite: {0}", ex.TargetSite.ToString()));
            message.Append(Environment.NewLine);
            message.Append("-----------------------------------------------------------");
            message.Append(Environment.NewLine);
            string path = Server.MapPath(string.Concat(FolderPathConstant.ErrorLogPath, "ErrorLog_", DateTime.Now.ToString("ddMMyyyy"), ".txt"));
            if (!System.IO.File.Exists(path))//Check File Exists or not
            {
                StreamWriter sw = System.IO.File.CreateText(path);
                sw.WriteLine(message.ToString());
                sw.Close();
            }
            else
            {
                using (StreamWriter writer = new StreamWriter(path, true))
                {
                    writer.WriteLine(message.ToString());
                    writer.Close();
                }
            }
        }

        public void WriteLog(string data)
        {
            string path = Server.MapPath(string.Concat(FolderPathConstant.Upload, "Log_", DateTime.Now.ToString("ddMMyyyy"), ".txt"));
            if (!System.IO.File.Exists(path))//Check File Exists or not
            {
                StreamWriter sw = System.IO.File.CreateText(path);
                sw.WriteLine(data);
                sw.Close();
            }
            else
            {
                using (StreamWriter writer = new StreamWriter(path, true))
                {
                    writer.WriteLine(data);
                    writer.Close();
                }
            }
        }
        #endregion

        #region Session management      

        public UserSession GetSession()
        {
            UserSession oSessionData = null;
            try
            {
                string oToken = GetHttpCookie()?.Value;
                //if (!string.IsNullOrEmpty(oToken) && !string.IsNullOrEmpty(Session[SessionKeyConstant.Session_Token].ToAlliantString()))
                if (!string.IsNullOrEmpty(oToken))
                {
                    string oCacheKey = $"{AlliantDataCacheKey.SessionStore}_{oToken}";
                    if (_alliantDataCacheManager.CheckKeyExists(oCacheKey))
                    {
                        oSessionData = _alliantDataCacheManager.GetValue(oCacheKey) as UserSession;
                    }
                    else
                    {
                        HttpCookie cookie = Request.Cookies[FormsAuthentication.FormsCookieName];
                        FormsAuthenticationTicket ticketInfo = FormsAuthentication.Decrypt(cookie.Value);

                        oSessionData = _sessionManager.GetUserSession(Convert.ToInt32(ticketInfo.UserData), oToken);

                        oSessionData.dtUserActivities = _authorizationManager.GetUserLayoutActivities(oSessionData.UserID, oSessionData.IsSuperAdminLoggedIn);
                        _alliantDataCacheManager.Add(oCacheKey, oSessionData, DateTimeOffset.Now.AddHours(1));
                    }
                }
            }
            catch (Exception)
            {

            }

            return oSessionData;
        }

        public bool ValidRequestFilter()
        {
            string oToken = GetHttpCookie()?.Value;
            if (!string.IsNullOrEmpty(oToken) && GetSession()?.UserID > 0)
                return true;
            else
                return false;
        }

        public UserSession SetorUpdateSession(UserSession userSession)
        {
            UserSession session = _sessionManager.AddUpdateUserSession(userSession.UserID, JsonConvert.SerializeObject(userSession), userSession.Token);
            session.dtUserActivities = _authorizationManager.GetUserLayoutActivities(session.UserID, session.IsSuperAdminLoggedIn);
            string oToken = GetHttpCookie()?.Value;
            string oCacheKey = $"{AlliantDataCacheKey.SessionStore}_{oToken}";
            _alliantDataCacheManager.Add(oCacheKey, session, DateTimeOffset.Now.AddHours(1));

            return session;
        }

        public UserSession GetCacheUserSession()
        {
            UserSession userSession = new UserSession();
            try
            {
                string oToken = GetHttpCookie()?.Value;
                string oKey = string.Concat(AlliantDataCacheKey.SessionStore, "-", oToken);

                if (_alliantDataCacheManager.CheckKeyExists(oKey))
                    userSession = _alliantDataCacheManager.GetValue(oKey) as UserSession;
                else
                {
                    userSession = GetSession();
                    _alliantDataCacheManager.Add(oKey, userSession, DateTimeOffset.Now.AddHours(1));
                }

            }
            catch (Exception)
            {

            }

            return userSession;
        }

        #region HasKeySessionHijeking
        public string SessionHijacking(string RandomKey = null)
        {
            StringBuilder oStringBuilder = new StringBuilder();
            oStringBuilder.Append(HttpContext.Request.Browser.Browser);
            oStringBuilder.Append(HttpContext.Request.Browser.Platform);
            oStringBuilder.Append(HttpContext.Request.Browser.MajorVersion);
            oStringBuilder.Append(HttpContext.Request.Browser.MinorVersion);
            oStringBuilder.Append(HttpContext.Request.LogonUserIdentity.Token.ToInt64());
            if (!string.IsNullOrEmpty(RandomKey))
            {
                oStringBuilder.Append(RandomKey);
            }
            SHA1 sha = new SHA1CryptoServiceProvider();
            byte[] hashdata = sha.ComputeHash(Encoding.UTF8.GetBytes(oStringBuilder.ToString()));

            return string.Concat(Convert.ToBase64String(hashdata), " (", HttpContext.Request.LogonUserIdentity.AuthenticationType, ")");
        }
        #endregion
        #endregion

        #region Store Detail in cookie
        public HttpCookie GetHttpCookie(bool IsSetOrGet = false, string Unique = null)
        {
            HttpCookie oCookie = null;
            try
            {
                if (IsSetOrGet)//Set Cookie
                {
                    oCookie = new HttpCookie(SessionKeyConstant.Cookie_Key);
                    oCookie.Value = Unique;
                    oCookie.HttpOnly = true;
                    oCookie.Expires = DateTime.Now.AddDays(1);
                    Response.Cookies.Add(oCookie);
                }
                else
                {
                    oCookie = Request.Cookies.Get(SessionKeyConstant.Cookie_Key);
                }
            }
            catch { }

            return oCookie;
        }

        public void SetUserCookie(UserLogin userLogin)
        {
            try
            {
                // create a cookie
                HttpCookie username = new HttpCookie("WebSite", HtmlHelperExtension.Encrypt(userLogin.UserName));
                username.Expires = DateTime.Now.AddDays(12);
                username.HttpOnly = true;
                Response.Cookies.Add(username);

                HttpCookie userpassword = new HttpCookie("Information", HtmlHelperExtension.Encrypt(userLogin.Password));
                userpassword.Expires = DateTime.Now.AddDays(12);
                userpassword.HttpOnly = true;
                Response.Cookies.Add(userpassword);
            }
            catch
            { }
        }

        public UserLogin GetUserCookie()
        {
            UserLogin oUser = new UserLogin();
            try
            {
                HttpCookie cookie = Request.Cookies.Get("WebSite");

                if (cookie != null && !string.IsNullOrEmpty(cookie?.Value))
                {
                    oUser.UserName = HtmlHelperExtension.Decrypt(cookie.Value);
                }

                cookie = Request.Cookies.Get("Information");

                if (cookie != null && !string.IsNullOrEmpty(cookie?.Value))
                {
                    oUser.Password = HtmlHelperExtension.Decrypt(cookie.Value);
                }
                if (!string.IsNullOrEmpty(oUser.Password) && !string.IsNullOrEmpty(oUser.UserName))
                    oUser.IsRemeber = true;
            }
            catch
            { }

            return oUser;
        }

        public void RemoveUserCookie()
        {
            try
            {
                HttpCookie httpCookie = Request.Cookies.Get("WebSite");
                if (httpCookie != null && !string.IsNullOrEmpty(httpCookie?.Value))
                {
                    httpCookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(httpCookie);

                    httpCookie = Request.Cookies.Get("Information");
                    httpCookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(httpCookie);
                }
            }
            catch
            { }
        }

        public void RemoveCookie(string oKey)
        {
            HttpCookie httpCookie = Request.Cookies.Get(oKey);
            if (httpCookie != null && !string.IsNullOrEmpty(httpCookie?.Value))
            {
                httpCookie = new HttpCookie(oKey);
                httpCookie.Expires = DateTime.Now.AddYears(-1);
                Response.Cookies.Add(httpCookie);
            }
        }
        #endregion       

        #region ViewPath
        public string ReportPath(string name, string path)
        {
            name = $"{path}{name}.cshtml";
            return name;
        }
        #endregion

        public string GetUrl()
        {
            HttpRequestBase request = Request;
            return string.Format("{0}://{1}{2}", request.Url.Scheme, request.Url.Authority, (new UrlHelper(request.RequestContext)).Content("~"));
        }

        #region File Uploder
        public void FileToMove(string SourceFile, string DestinationFile)
        {
            try
            {
                if (!string.IsNullOrEmpty(SourceFile) && !string.IsNullOrEmpty(DestinationFile))
                {
                    if (System.IO.File.Exists(Server.MapPath(SourceFile)))
                    {
                        System.IO.File.Move(Server.MapPath(SourceFile), Server.MapPath(DestinationFile));
                    }
                }
            }
            catch (Exception ex)
            {
                LogError(ex);
            }
        }

        public bool CreateDirectory(string path, bool IsPhysicalPath = false)
        {
            if (IsPhysicalPath)
            {
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);

                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                if (!Directory.Exists(Path.Combine(Server.MapPath(path))))
                {
                    Directory.CreateDirectory(Path.Combine(Server.MapPath(path)));

                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public bool DeleteDirectory(string path)
        {
            if (Directory.Exists(Path.Combine(Server.MapPath(path))))
            {
                Directory.Delete(Path.Combine(Server.MapPath(path)), true);

                return true;
            }
            else
            {
                return false;
            }
        }

        public string[] GetFileFromDirectory(string path)
        {
            CreateDirectory(path);

            return Directory.GetFiles(Path.Combine(Server.MapPath(path)));
        }

        public void CopyFilesRecursively(DirectoryInfo source, DirectoryInfo target)
        {
            try
            {
                foreach (DirectoryInfo dir in source.GetDirectories())
                    CopyFilesRecursively(dir, target.CreateSubdirectory(dir.Name));
                foreach (FileInfo file in source.GetFiles())
                    file.CopyTo(Path.Combine(target.FullName, file.Name));
            }
            catch (Exception ex)
            {
                LogError(ex);
            }
        }
        #endregion

        #region Dynamic report
        public IEnumerable<Type> GetDomains()
        {
            string nspace = "Alliant.Domain";

            IEnumerable<Type> types = from type in Assembly.GetExecutingAssembly().GetTypes()
                                      where type.IsClass && type.Namespace == nspace
                                      select type;

            var temp = AppDomain.CurrentDomain.GetAssemblies().Where(x => x.FullName.Contains("Alliant.Domain")).SelectMany(x => x.DefinedTypes);
            //temp = AppDomain.CurrentDomain.GetAssemblies().ToList();

            return types;
        }
        #endregion
    }
}