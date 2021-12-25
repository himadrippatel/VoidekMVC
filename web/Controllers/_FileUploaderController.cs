using Alliant._ApplicationCode;
using System.Web.Mvc;

namespace Alliant.Controllers
{
    public class _FileUploaderController : FileUploderImplController
    {
        [HttpPost]
        public override void Delete(string fileName)
            => base.Delete(fileName);

        [HttpGet]
        public override void Download(string fileName)
            => base.Download(fileName);

        [HttpPost]
        public override ActionResult UploadFiles()
            => base.UploadFiles();

        public override void DeleteSaveFile(string fileName)
            => base.DeleteSaveFile(fileName);

        public override void DownloadSaveFile(string fileName)
            => base.DownloadSaveFile(fileName);
    }
}
