using System.Collections.Generic;

namespace Alliant
{
    public class UIContainer<T> where T : new()
    {
        public T Model { get; set; }
        public IDictionary<string, bool> dtUserActivities { get; set; }
        public string ModelID { get; set; }
        public string Title { get; set; }
    }

    public class UIDBData<T, U>
    {
        public int TotalCount { get; set; }
        public T Model { get; set; }
        public U SearchModel { get; set; }
    }
}