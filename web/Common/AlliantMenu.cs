using System;
using System.Collections.Generic;

namespace Alliant.Common
{
    public class AlliantMenu
    {
        public Guid? MenuID { get; set; }
        public string LinkText { get; set; }
        public string ActionName { get; set; }
        public string ControllerName { get; set; }
        public object HtmlAttributes { get; set; }
        public object RouteData { get; set; }
        public int ID { get; set; }

        public List<AlliantMenu> ChildMenu { get; set; }

        public AlliantMenu()
        {
            ChildMenu = new List<AlliantMenu>();
            MenuID = Guid.NewGuid();
        }
    }    
}