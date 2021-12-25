using Alliant._ApplicationCode;
using Alliant.Domain;
using Alliant.Manager;
using Alliant.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web.Mvc;

namespace Alliant.Controllers
{
    public class HomeController : _BaseController
    {
        /// <summary>
        /// chart manager get chart all method
        /// </summary>
        // GET: Home
        public ActionResult Index()
        {           
            return View();
        }

        /// <summary>
        /// clear application cache 
        /// </summary>
        /// <returns></returns>
        public ActionResult ClearCache()
        {
            Thread thread = new Thread(() =>
            {
                _alliantDataCacheManager.ClearAlliantCache();
            });
            thread.Start();
            thread.IsBackground = true;
            return RedirectToAction("Index", "Home");
        }
    }
}