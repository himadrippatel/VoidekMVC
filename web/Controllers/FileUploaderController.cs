using Alliant._ApplicationCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Alliant.Controllers
{
    public class FileUploaderController : FileUploderImplController
    {
        // GET: FileUploader
     
        public override void Delete(string id) => base.Delete(id);
        public override void Download(string id) => base.Download(id);
        public override ActionResult UploadFiles() => base.UploadFiles();
   
    }
}
