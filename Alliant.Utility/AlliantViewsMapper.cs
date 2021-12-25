using System.IO;
using System.Web.Hosting;

namespace Alliant.Utility
{
    public class AlliantViewsMapper
    {
        public AlliantViewsMapper()
        {
            
        }

        public string[] GetViews(string path = "Views")
        {
            string[] files = Directory.GetFiles(string.Concat(HostingEnvironment.ApplicationPhysicalPath, "/", path),
                "*.cshtml",
                SearchOption.AllDirectories);
            return files;
        }
    }
}
