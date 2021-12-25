using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public interface IFileUploaderController
    {       
        void Delete(string id);
        void Download(string id);
        ActionResult UploadFiles();
        void DownloadSaveFile(string fileName);
        void DeleteSaveFile(string fileName);
    }
}
