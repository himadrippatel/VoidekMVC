namespace Alliant.ViewModel
{
    public partial class HierarchicalViewModel
    {
        public int ID { get; set; }
        public int? ParentID { get; set; }
        public bool HasChildren { get; set; }
        public string Name { get; set; }
    }
}
