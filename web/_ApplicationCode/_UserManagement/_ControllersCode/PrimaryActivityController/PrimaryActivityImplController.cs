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

    public abstract class PrimaryActivityImplController : _BaseController, IPrimaryActivityController
    {
        public virtual IPrimaryActivityManager _PrimaryActivityManager
        {
            get { return DependencyResolver.Current.GetService<IPrimaryActivityManager>(); }
        }

        public virtual ActionResult Home()
        {
            IsAuthorized("activity_usermanagement_primaryactivity");
            UIContainer<PrimaryActivity> uIContainer = new UIContainer<PrimaryActivity>();
            uIContainer.dtUserActivities = _authorizationManager.GetActivityPermittions("activity_usermanagement_primaryactivity,activity_usermanagement_primaryactivity_search,activity_usermanagement_primaryactivity_insert,activity_usermanagement_primaryactivity_delete");
            return View("Index",uIContainer);
        }

        public virtual ActionResult Create()
        {
            IsAuthorized("activity_usermanagement_primaryactivity_insert");
            PrimaryActivity oPrimaryActivity = _PrimaryActivityManager.Create();
            return View("Create", oPrimaryActivity);
        }

        public virtual ActionResult CreatePost(PrimaryActivity oPrimaryActivity, FormCollection formCollection)
        {
            IsAuthorized("activity_usermanagement_primaryactivity_insert");
            try
            {
                oPrimaryActivity.CreatedOn = DateTime.Now;
                oPrimaryActivity.RoleID = 1;
                _PrimaryActivityManager.CreatePost(oPrimaryActivity);
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
            IsAuthorized("activity_usermanagement_primaryactivity_delete");
            try
            {
                _PrimaryActivityManager.DeletePost(Id);
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

        public virtual ActionResult GetPrimaryActivityBySearch(DataSourceRequest request, FormCollection formCollection)
        {
            GridBinder gridBinder = new GridBinder(request);
            GridSearchModel searchModel = gridBinder.GetGridSearchModel();
            List<PrimaryActivity> oResult = _PrimaryActivityManager.GetAllPrimaryActivity(searchModel).ToList();
            DataSourceResult result = oResult.ToDataSourceResult(request);
            request.Page = Convert.ToInt32(searchModel.Page);
            result.Total = Convert.ToInt32(searchModel.ResultCount);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public virtual JsonResult Suggestion(string term, FormCollection formCollection)
        {
            List<AutoCompleteViewModel> autoCompletes = _PrimaryActivityManager.GetPrimaryActivitySuggestion(term).ToList();
            return Json(autoCompletes, JsonRequestBehavior.AllowGet);
        }

        public virtual JsonResult SearchPrimaryActivity(SearchRequest searchRequest, FormCollection formCollection)
        {
            SelectViewModel selectViewModel = _PrimaryActivityManager.GetPrimaryActivitySelectViewModels(searchRequest);            
            return Json(selectViewModel, JsonRequestBehavior.AllowGet);
        }
    }
}
