using Alliant._ApplicationCode;
using Alliant.Domain;
using Alliant.Utility;
using System;
using System.Web.Mvc;
using System.Web.Routing;

namespace Alliant
{
    public class AlliantFilterAttribute : ActionFilterAttribute
    {
        private AlliantConfigurationSection _AlliantConfigurationSection
           => DependencyResolver.Current.GetService<AlliantConfigurationSection>();

        private AlliantViewsMapper _AlliantViewsMapper
            => DependencyResolver.Current.GetService<AlliantViewsMapper>();
        bool _isRequiredSession = false;
        bool _userSessionValidFilter = false;

        public AlliantFilterAttribute(bool isRequiredSession = true)
        {
            this._isRequiredSession = isRequiredSession;
        }

        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            Log("OnResultExecuted", filterContext.RouteData);
        }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            #region Handle user request check session valid
            if (_isRequiredSession)
            {
                _userSessionValidFilter = this.ValidRequestFilter(filterContext);
                if (!_userSessionValidFilter)
                {
                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary
                     {
                        { "action", "Index" },
                        { "controller", "Account" },
                        { "area",""},
                        { "returnUrl", filterContext.HttpContext.Request.RawUrl}
                      });

                    return;
                }
            }
            #endregion
        }

        public override void OnResultExecuted(ResultExecutedContext filterContext)
        {
            Log("OnResultExecuted", filterContext.RouteData);
        }

        public override void OnResultExecuting(ResultExecutingContext filterContext)
        {
            #region Set Session
            filterContext.Controller.ViewBag.LayoutModel = GetUserSession(filterContext);
            #endregion

            if (_AlliantConfigurationSection.CustomizeView == "1")
            {
                string[] Views = _AlliantViewsMapper.GetViews();
                string[] Customized = _AlliantViewsMapper.GetViews("_CustomizeView");

                #region set custome view
                if (filterContext.Result is ViewResult || filterContext.Result is PartialViewResult)
                {
                    string oFilePath = string.Empty, oViewPath = string.Empty;
                    string oArea = Convert.ToString(filterContext.RouteData.Values["area"]);
                    string oControllerName = Convert.ToString(filterContext.RouteData.Values["controller"]);
                    string oActionName = Convert.ToString(filterContext.RouteData.Values["action"]);
                    string _CustomizePath = filterContext.HttpContext.Server.MapPath(FolderPathConstant.CustomizeViewPath);

                    if (!string.IsNullOrEmpty(oArea))
                    {
                        oFilePath = $"{_CustomizePath}Areas/{oArea}/Views/{oControllerName}/{oActionName}.cshtml";
                        oViewPath = $"{FolderPathConstant.CustomizeViewPath}Areas/{oArea}/Views/{oControllerName}/{oActionName}.cshtml";

                        if (System.IO.File.Exists(oFilePath))
                        {
                            LoadView(filterContext, oViewPath);
                            return;
                        }

                        oFilePath = $"{_CustomizePath}Areas/{oArea}/Views/Shared/{oActionName}.cshtml";
                        oViewPath = $"{FolderPathConstant.CustomizeViewPath}Areas/{oArea}/Views/Shared/{oActionName}.cshtml";

                        if (System.IO.File.Exists(oFilePath))
                        {
                            LoadView(filterContext, oViewPath);
                            return;
                        }

                    }
                    else
                    {
                        oFilePath = $"{_CustomizePath}Views/{oControllerName}/{oActionName}.cshtml";
                        oViewPath = $"{FolderPathConstant.CustomizeViewPath}Views/{oControllerName}/{oActionName}.cshtml";

                        if (System.IO.File.Exists(oFilePath))
                        {
                            LoadView(filterContext, oViewPath);
                            return;
                        }

                        oFilePath = $"{_CustomizePath}Views/Shared/{oActionName}.cshtml";
                        oViewPath = $"{FolderPathConstant.CustomizeViewPath}Views/Shared/{oActionName}.cshtml";

                        if (System.IO.File.Exists(oFilePath))
                        {
                            LoadView(filterContext, oViewPath);
                            return;
                        }
                    }
                }
                #endregion
            }
        }

        private void Log(string methodName, RouteData routeData)
        {
            var controllerName = routeData.Values["controller"];
            var actionName = routeData.Values["action"];
            var message = string.Format("{0}- controller:{1} action:{2}", methodName,
                                                                        controllerName,
                                                                        actionName);
            message = message + "";
        }

        private void LoadView(ResultExecutingContext filterContext, string oViewPath)
        {
            ViewResult viewResult = (ViewResult)filterContext.Result;
            viewResult.ViewName = oViewPath;
        }

        private UserSession GetUserSession(ResultExecutingContext filterContext)
        {
            UserSession userSession = null;
            _BaseController oBaseController = filterContext.Controller as _BaseController;
            if (oBaseController._sessionManager != null)
            {
                userSession = oBaseController.GetSession();
            }
            return userSession;
        }
        private bool ValidRequestFilter(ActionExecutingContext filterContext)
        {
            _BaseController oBaseController = filterContext.Controller as _BaseController;
            return oBaseController.ValidRequestFilter();
        }
    }
}