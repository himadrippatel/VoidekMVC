using Alliant.Domain;
using Alliant.Manager;
using Alliant.Utility;
using Alliant.ViewModel;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{

    public abstract class SecondaryActivityImplController : _BaseController, ISecondaryActivityController
    {
        public virtual ISecondaryActivityManager _SecondaryActivityManager { get { return DependencyResolver.Current.GetService<ISecondaryActivityManager>(); } }

        public virtual ActionResult Home()
        {
            IsAuthorized("activity_usermanagement_secondaryactivity");
            //var activity = _authorizationManager.GetValidActivities(_UserID, "activity_name", "activity_menumain", "activity_usermanagement", "activity_administrator");
            var activity = _authorizationManager.GetActivityPermittions("activity_name,activity_menumain,activity_usermanagement,activity_administrator,activity_usermanagement_secondaryactivity,activity_usermanagement_secondaryactivity_search,activity_usermanagement_secondaryactivity_insert,activity_usermanagement_secondaryactivity_delete");
            UIContainer<SecondaryActivity> uIContainer = new UIContainer<SecondaryActivity>();
            uIContainer.Model = new SecondaryActivity();
            uIContainer.dtUserActivities = activity;
            return View("Index", uIContainer);
        }

        public virtual ActionResult Create()
        {
            IsAuthorized("activity_usermanagement_secondaryactivity_insert");
            SecondaryActivity oSecondaryActivity = _SecondaryActivityManager.Create();
            return View("Create", oSecondaryActivity);
        }

        public virtual ActionResult CreatePost(SecondaryActivityViewModel secondaryActivityView, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_secondaryactivity_insert");
            try
            {
                _SecondaryActivityManager.CreatePost(secondaryActivityView);
                return Json(new AjaxActionResult()
                {
                    Message = Constant.SaveMessage,
                    Success = true
                });
            }
            catch (Exception ex)
            {
                return Json(new AjaxActionResult()
                {
                    Message = ex.Message,
                    Success = false
                });
            }
        }

        public virtual ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_secondaryactivity_delete");
            try
            {
                _SecondaryActivityManager.DeletePost(Id);
                return Json(new AjaxActionResult()
                {
                    Message = Constant.SaveMessage,
                    Success = true
                });
            }
            catch (Exception ex)
            {
                return Json(new AjaxActionResult()
                {
                    Message = ex.Message,
                    Success = false
                });
            }
        }

        public virtual ActionResult GetSecondaryActivityBySearch(DataSourceRequest request, FormCollection formCollection)
        {
            GridBinder gridBinder = new GridBinder(request);
            GridSearchModel searchModel = gridBinder.GetGridSearchModel();
            searchModel.PageSize = null;
            searchModel.Page = null;
            List<SecondaryActivity> oResult = _SecondaryActivityManager.GetAllSecondaryActivity(searchModel).ToList();
            //oResult.ForEach(x =>
            //{
            //    x.ActivityName = x.ActivityName.Split(new char[] { '_' }).Last().FirstCharToUpper();
            //    x.ParentActivity = (!string.IsNullOrEmpty(x.ParentActivity) ? x.ParentActivity.Split(new char[] { '_' }).Last().FirstCharToUpper() : null);
            //});
            //DataSourceResult result = oResult.ToDataSourceResult(request);
            var result = oResult.ToTreeDataSourceResult(request, e => e.ActivityName, e => e.ParentActivity, e => e);
            request.Page = Convert.ToInt32(searchModel.Page);
            result.Total = Convert.ToInt32(searchModel.ResultCount);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}
