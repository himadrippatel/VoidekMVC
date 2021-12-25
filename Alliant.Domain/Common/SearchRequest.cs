namespace Alliant.Domain
{
    public class SearchRequest
    {
        public virtual string search { get; set; }
        public virtual int? pageResult { get; set; }
        public virtual int? page { get; set; }
        public virtual string notIn { get; set; }
    }
}
