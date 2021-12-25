namespace Alliant.Domain
{
    public class RootSearch_Model
    {
        public int? ResultCount { get; set; }
        public int? Page_Size { get; set; }
        public int? Page_Index { get; set; }
        public string Sort_Column { get; set; }
        public bool? Sort_Ascending { get; set; }
        public bool IsBinaryRequired { get; set; }
        public bool IsPrimaryIN { get; set; }

        public RootSearch_Model()
        {
            IsPrimaryIN = true;
            IsBinaryRequired = false;
            Page_Index = 1;
            Page_Size = 10;
        }
    }

    public class GridSearchModel
    {
        public int? Page { get; set; }
        public int? PageSize { get; set; }
        public string Filter { get; set; }
        public string SortOrder { get; set; }
        public int? ResultCount { get; set; }
    }
}
