using Alliant.Domain;
using Alliant.Manager;
using Alliant.ViewModel;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public abstract class ActivityVsUserImplController : _BaseController, IActivityVsUserController
    {
        public virtual IActivityVsUserManager _ActivityVsUserManager { get { return DependencyResolver.Current.GetService<IActivityVsUserManager>(); } }
        public virtual ISecondaryActivityManager _SecondaryActivityManager { get { return DependencyResolver.Current.GetService<ISecondaryActivityManager>(); } }

        public virtual ActionResult Home()
        {
            IsAuthorized("activity_usermanagement_activityvsuser");

            UIContainer<ActivityVsUser> uIContainerActivityVsUser = new UIContainer<ActivityVsUser>();
            uIContainerActivityVsUser.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_activityvsuser,activity_usermanagement_activityvsuser_search,activity_usermanagement_activityvsuser_delete,activity_usermanagement_activityvsuser_insert");
            return View("Index", uIContainerActivityVsUser);
        }

        public virtual ActionResult Create()
        {
            IsAuthorized("activity_usermanagement_activityvsuser_insert");

            ActivityVsUser oActivityVsUser = _ActivityVsUserManager.Create();
            List<SecondaryActivity> secondaryActivity = _SecondaryActivityManager.GetAllSecondaryActivity(new GridSearchModel() { SortOrder= "ParentActivity ASC" }).ToList();
            return View("Create", secondaryActivity);
        }

        public virtual ActionResult CreatePost(ActivityVsUserViewModel activityVsUserViewModel, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_activityvsuser_insert");
            try
            {
                _ActivityVsUserManager.CreatePost(activityVsUserViewModel);
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
                    Success = false,
                    Data = ex
                });
            }
        }

        public virtual ActionResult DeletePost(int Id, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_activityvsuser_delete");
            try
            {
                _ActivityVsUserManager.DeletePost(Id);
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
                    Success = false,
                    Data = ex
                });
            }
        }

        public virtual ActionResult GetActivityVsUserBySearch(DataSourceRequest request, FormCollection formCollection)
        {
            GridBinder gridBinder = new GridBinder(request);
            GridSearchModel searchModel = gridBinder.GetGridSearchModel();
            List<ActivityVsUser> oResult = _ActivityVsUserManager.GetAllActivityVsUser(searchModel).ToList();
            DataSourceResult result = oResult.ToDataSourceResult(request);
            request.Page = Convert.ToInt32(searchModel.Page);
            result.Total = Convert.ToInt32(searchModel.ResultCount);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}
