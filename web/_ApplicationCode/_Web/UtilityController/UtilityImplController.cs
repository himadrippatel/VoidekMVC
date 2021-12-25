using Alliant.Domain;
using Alliant.Manager;
using Alliant.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web.Mvc;
using System.Web.Routing;

namespace Alliant._ApplicationCode
{
    public abstract class UtilityImplController : _BaseController
    {
        ICustomersManager _CustomersManager
        {
            get { return DependencyResolver.Current.GetService<ICustomersManager>(); }
        }

        IPrimaryActivityManager _PrimaryActivityManager
        {
            get { return DependencyResolver.Current.GetService<IPrimaryActivityManager>(); }
        }

        public virtual ActionResult UserLoginData()
        {
            return View("UserLoginData");
        }

        public virtual ActionResult UserLoginDataUpdate()
        {
            try
            {
                UserCustomersSyncup userCustomersSyncup = _CustomersManager.UpdateUserLoginDetail();
                return Json(new AjaxActionResult()
                {
                    Message = userCustomersSyncup.Message,
                    Success = userCustomersSyncup.Success
                }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new AjaxActionResult()
                {
                    Data = ex,
                    Message = ex.Message,
                    Success = false
                }, JsonRequestBehavior.AllowGet);
            }
        }

        /* public virtual ActionResult SyncController()
         {
             Assembly assembly = Assembly.GetAssembly(typeof(MvcApplication));

             List<DefaultControllerModel> controllerModels = assembly.GetTypes()
                     .Where(type => typeof(Controller).IsAssignableFrom(type))
                     .SelectMany(type => type.GetMethods(BindingFlags.Instance | BindingFlags.DeclaredOnly | BindingFlags.Public))
                     .Where(m => !m.GetCustomAttributes(typeof(System.Runtime.CompilerServices.CompilerGeneratedAttribute), true).Any())
                     .Select(x => new DefaultControllerModel { ControllerName = x.DeclaringType.Name, ActionName = x.Name, ReturnType = x.ReturnType.Name, Attributes = x.GetCustomAttributes().ToList() })
                     .OrderBy(x => x.ControllerName).ThenBy(x => x.ActionName).ToList();

             return View("SyncController", controllerModels);
         }*/
        public virtual ActionResult SyncController()
        {
            List<Type> getChilds = GetSubClasses<Controller>();

            // Get all controllers with their actions
            List<ControllerModel> controllerModels = (from item in getChilds
                                                      let name = item.Name
                                                      where !item.Name.StartsWith("_Base")
                                                      select new ControllerModel()
                                                      {
                                                          Name = name.Replace("Controller", ""),
                                                          Namespace = item.Namespace,
                                                          ActionModels = GetListOfAction(item)
                                                      }).ToList();

            // Now we will get all areas that has been registered in route collection
            List<AreaModel> areaModels = RouteTable.Routes.OfType<Route>()
                .Where(d => d.DataTokens != null && d.DataTokens.ContainsKey("area"))
                .Select(
                    r =>
                        new AreaModel
                        {
                            Name = r.DataTokens["area"].ToString(),
                            Namespace = r.DataTokens["Namespaces"] as IList<string>,
                        }).ToList()
                .Distinct().ToList();

            // Now we will get all controllers that has been registered in route collection
            var controller = RouteTable.Routes.OfType<Route>()
                .Where(d => d.DataTokens != null && !d.DataTokens.ContainsKey("area"))
                .Select(
                    r =>
                        new AreaModel
                        {
                            Name = "Alliant.Controllers",
                            Namespace = r.DataTokens["Namespaces"] as IList<string>,
                        }).ToList()
                .Distinct().ToList();
            areaModels.AddRange(controller);
            foreach (var area in areaModels)
            {
                var temp = new List<ControllerModel>();
                foreach (var item in area.Namespace)
                {
                    temp.AddRange(controllerModels.Where(x => x.Namespace == item).ToList());
                }
                area.ControllerModels = temp;
            }
            List<PrimaryActivity> primaryActivities = _PrimaryActivityManager.GetAllPrimaryActivity(new GridSearchModel() { }).ToList();
            Tuple<List<AreaModel>, List<PrimaryActivity>> tupleModel = new Tuple<List<AreaModel>, List<PrimaryActivity>>(areaModels, primaryActivities);
            return View("SyncController_v1", tupleModel);
        }

        private static List<Type> GetSubClasses<T>()
        {
            return Assembly.GetCallingAssembly().GetTypes().Where(
                type => type.IsSubclassOf(typeof(T))).ToList();
        }

        private IEnumerable<ActionModel> GetListOfAction(Type controller)
        {
            var navItems = new List<ActionModel>();
            bool validAction = true;
            bool isHttpPost = false;
            // Get a descriptor of this controller
            ReflectedControllerDescriptor controllerDesc = new ReflectedControllerDescriptor(controller);
            List<string> lstExcludeAction = this.GetBaseAction();
            IEnumerable<ActionDescriptor> actionDescriptors = controllerDesc.GetCanonicalActions().Where(e => !lstExcludeAction.Contains(e.ActionName));
            // Look at each action in the controller
            foreach (ActionDescriptor action in actionDescriptors)
            {
                validAction = true;
                isHttpPost = false;
                // Get any attributes (filters) on the action
                object[] attributes = action.GetCustomAttributes(false);

                // Look at each attribute
                foreach (object filter in attributes)
                {                    
                    if (filter is HttpPostAttribute)
                    {
                        isHttpPost = true;
                    }                  

                }

                // Add the action to the list if it's "valid"
                if (validAction)
                    navItems.Add(new ActionModel()
                    {
                        Name = action.ActionName,
                        IsHttpPost = isHttpPost
                    });
            }
            return navItems;
        }

        private List<string> GetBaseAction()
        {
            List<string> baseAction = new List<string>();
            Assembly assembly = Assembly.GetAssembly(typeof(MvcApplication));

            List<DefaultControllerModel> controllerModels = assembly.GetTypes()
                    .Where(type => typeof(Controller).IsAssignableFrom(type))
                    .SelectMany(type => type.GetMethods(BindingFlags.Instance | BindingFlags.DeclaredOnly | BindingFlags.Public))
                    .Where(m => !m.GetCustomAttributes(typeof(System.Runtime.CompilerServices.CompilerGeneratedAttribute), true).Any() && m.DeclaringType.Name == "_BaseController")
                    .Select(x => new DefaultControllerModel { ControllerName = x.DeclaringType.Name, ActionName = x.Name, ReturnType = x.ReturnType.Name, Attributes = x.GetCustomAttributes().ToList() })
                    .OrderBy(x => x.ControllerName).ThenBy(x => x.ActionName).ToList();
            baseAction = controllerModels.Select(x => x.ActionName).ToList();
            return baseAction;
        }
    }
}