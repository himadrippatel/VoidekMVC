using Alliant._ApplicationCode;
using Alliant.Domain;
using System;
using System.Net;
using System.Web.Mvc;

namespace Alliant
{
    public class AlliantErrorHandling : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            #region Set Session
            _BaseController oBaseController = filterContext.Controller as _BaseController;
            #endregion

            var exception = filterContext.Exception;
            HttpStatusCode statusCode = (filterContext.Exception as WebException != null &&
                        ((HttpWebResponse)(filterContext.Exception as WebException).Response) != null) ?
                         ((HttpWebResponse)(filterContext.Exception as WebException).Response).StatusCode
                         : GetStatusCode(filterContext.Exception.GetType());

            oBaseController.LogError(exception);

            if (exception is UnauthorizedAccessException)
            {
                filterContext.ExceptionHandled = true;

                if (filterContext.HttpContext.Request.IsAjaxRequest())
                {
                    filterContext.HttpContext.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                    filterContext.HttpContext.Response.ContentType = "application/json";

                    filterContext.Result = new JsonResult // Set the response to JSon
                    {
                        Data = new { Success = false, Message = exception.Message }
                        ,
                        JsonRequestBehavior = JsonRequestBehavior.AllowGet
                    };

                    filterContext.ExceptionHandled = true;
                    filterContext.HttpContext.Response.Clear();
                    filterContext.HttpContext.Response.TrySkipIisCustomErrors = true;
                    return;
                }
                else //*** From here, is the original code againg **//
                {
                    string areaName = (string)filterContext.RouteData.Values["area"];
                    string controllerName = (string)filterContext.RouteData.Values["controller"];
                    string actionName = (string)filterContext.RouteData.Values["action"];
                    HandleErrorInfo model = new HandleErrorInfo(filterContext.Exception, controllerName, actionName);
                    
                    filterContext.Result = new ViewResult
                    {
                        ViewName = "CommonError",
                        MasterName = Master,
                        ViewData = new ViewDataDictionary<HandleErrorInfo>(model),
                        TempData = filterContext.Controller.TempData,
                        ViewBag = { LayoutModel = oBaseController.GetSession() }
                    };

                    filterContext.ExceptionHandled = true;
                    filterContext.HttpContext.Response.Clear();
                    filterContext.HttpContext.Response.StatusCode = (int)statusCode;

                    // Certain versions of IIS will sometimes use their own error page when
                    // they detect a server error. Setting this property indicates that we
                    // want it to try to render ASP.NET MVC's error page instead.
                    filterContext.HttpContext.Response.TrySkipIisCustomErrors = true;
                    return;
                }
            }
        }

        private HttpStatusCode GetStatusCode(Type exceptionType)
        {
            EnumExceptions tryParseResult;
            if (Enum.TryParse<EnumExceptions>(exceptionType.Name, out tryParseResult))
            {
                switch (tryParseResult)
                {
                    case EnumExceptions.NullReferenceException:
                        return HttpStatusCode.LengthRequired;

                    case EnumExceptions.FileNotFoundException:
                        return HttpStatusCode.NotFound;

                    case EnumExceptions.OverflowException:
                        return HttpStatusCode.RequestedRangeNotSatisfiable;

                    case EnumExceptions.OutOfMemoryException:
                        return HttpStatusCode.ExpectationFailed;

                    case EnumExceptions.InvalidCastException:
                        return HttpStatusCode.PreconditionFailed;

                    case EnumExceptions.ObjectDisposedException:
                        return HttpStatusCode.Gone;

                    case EnumExceptions.UnauthorizedAccessException:
                        return HttpStatusCode.Unauthorized;

                    case EnumExceptions.NotImplementedException:
                        return HttpStatusCode.NotImplemented;

                    case EnumExceptions.NotSupportedException:
                        return HttpStatusCode.NotAcceptable;

                    case EnumExceptions.InvalidOperationException:
                        return HttpStatusCode.MethodNotAllowed;

                    case EnumExceptions.TimeoutException:
                        return HttpStatusCode.RequestTimeout;

                    case EnumExceptions.ArgumentException:
                        return HttpStatusCode.BadRequest;

                    case EnumExceptions.StackOverflowException:
                        return HttpStatusCode.RequestedRangeNotSatisfiable;

                    case EnumExceptions.FormatException:
                        return HttpStatusCode.UnsupportedMediaType;

                    case EnumExceptions.IOException:
                        return HttpStatusCode.NotFound;

                    case EnumExceptions.IndexOutOfRangeException:
                        return HttpStatusCode.ExpectationFailed;

                    default:
                        return HttpStatusCode.InternalServerError;
                }
            }
            else
            {
                return HttpStatusCode.InternalServerError;
            }
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
    }
}