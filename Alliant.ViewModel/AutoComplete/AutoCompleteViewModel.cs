using System.Collections.Generic;

namespace Alliant.ViewModel
{
    public partial class AutoCompleteViewModel
    {
        public int UserID { get; set; }
        public string id { get; set; }
        public string label { get; set; }
        public string value { get; set; }
    }


    public partial class SelectViewModel
    {
        public int? total_count { get; set; }
        public bool incomplete_results { get; set; }
        public List<SelectResultViewModel> items { get; set; }
    }

    public partial class SelectResultViewModel
    {
        public string id { get; set; }
        public string node_id { get; set; }
        public string name { get; set; }
        public string full_name { get; set; }
        public string imageurl { get; set; }
        public string description { get; set; }
    }
}
