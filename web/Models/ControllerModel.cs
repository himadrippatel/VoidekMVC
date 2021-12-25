using System;
using System.Collections.Generic;

namespace Alliant.Models
{
    public class DefaultControllerModel
    {
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public string ReturnType { get; set; }
        public List<Attribute> Attributes { get; set; }
    }

    public class ActionModel
    {
        public string Name { get; set; }

        public bool IsHttpPost { get; set; }
    }

    public class ControllerModel
    {
        public string Name { get; set; }

        public string Namespace { get; set; }

        public IEnumerable<ActionModel> ActionModels { get; set; }
    }

    public class AreaModel
    {
        public string Name { get; set; }

        public IList<string> Namespace { get; set; }

        public IEnumerable<ControllerModel> ControllerModels { get; set; }
    }
}