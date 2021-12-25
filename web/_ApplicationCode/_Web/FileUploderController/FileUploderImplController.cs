using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Web;
using System.Web.Mvc;

namespace Alliant._ApplicationCode
{
    public abstract class FileUploderImplController : _BaseController, IFileUploaderController
    {
        private string _FileStoreDefaultPath
        {
            get { return Server.MapPath(FolderPathConstant.UploadTemp); }
        }

        private string fullPath { get; set; }

        public virtual void Delete(string id)
        {
            fullPath = Path.Combine(Server.MapPath(FolderPathConstant.UploadTemp), id);

            if (System.IO.File.Exists(fullPath))
            {
                System.IO.File.Delete(fullPath);
            }
        }

        public virtual void Download(string id)
        {
            fullPath = Path.Combine(Server.MapPath(FolderPathConstant.UploadTemp), id);
            id = id.Substring(Constant.DefaultNameLength, id.Length - Constant.DefaultNameLength);
            HttpContextBase context = HttpContext;

            if (System.IO.File.Exists(fullPath))
            {
                context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + id + "\"");
                context.Response.ContentType = "application/octet-stream";
                context.Response.ClearContent();
                context.Response.WriteFile(fullPath);
            }
            else
                context.Response.StatusCode = 404;
        }

        public virtual ActionResult UploadFiles()
        {
            List<FilesDataUploadResult> uploadFilesResults = new List<FilesDataUploadResult>();

            foreach (string file in Request.Files)
            {
                List<FilesDataUploadResult> statuses = new List<FilesDataUploadResult>();
                NameValueCollection headers = Request.Headers;

                if (string.IsNullOrEmpty(headers["X-File-Name"]))
                {
                    UploadWholeFile(Request, statuses);
                }
                else
                {
                    UploadPartialFile(headers["X-File-Name"], Request, statuses);
                }

                JsonResult result = Json(statuses);
                result.ContentType = "text/plain";
                result.MaxJsonLength = int.MaxValue;

                return result;
            }

            return Json(uploadFilesResults);
        }

        public string EncodeFile(string fileName)
        {
            return Convert.ToBase64String(System.IO.File.ReadAllBytes(fileName));
        }

        private void UploadPartialFile(string fileName, HttpRequestBase request, List<FilesDataUploadResult> statuses)
        {
            if (request.Files.Count != 1) throw new HttpRequestValidationException("Attempt to upload chunked file containing more than one fragment per request");

            HttpPostedFileBase file = request.Files[0];
            Stream inputStream = file.InputStream;

            fullPath = Path.Combine(_FileStoreDefaultPath, Path.GetFileName(fileName));

            using (FileStream fileStream = new FileStream(fullPath, FileMode.Append, FileAccess.Write))
            {
                byte[] buffer = new byte[1024];

                int lengthReadStream = inputStream.Read(buffer, 0, 1024);
                while (lengthReadStream > 0)
                {
                    fileStream.Write(buffer, 0, lengthReadStream);
                    lengthReadStream = inputStream.Read(buffer, 0, 1024);
                }
                fileStream.Flush();
                fileStream.Close();
            }

            statuses.Add(new FilesDataUploadResult()
            {
                name = fileName,
                size = file.ContentLength,
                type = file.ContentType,
                url = $"{Constant.FileDownloadUrl}?fileName={file.FileName}",
                delete_url = $"{Constant.FileDeleteUrl}?fileName={file.FileName}",
                thumbnail_url = @"data:image/png;base64," + EncodeFile(fullPath),
                filePath = fullPath,
                originalFileName = fileName,
                webPath = $"{FolderPathConstant.UploadTemp}{fileName}",
                isUploded = true
            });
        }

        private void UploadWholeFile(HttpRequestBase request, List<FilesDataUploadResult> statuses)
        {
            HttpPostedFileBase file = null;
            fullPath = default(string);
            string fileNameGenrated = default(string);
            for (int i = 0; i < request.Files.Count; i++)
            {
                file = request.Files[i];
                fileNameGenrated = $"{Guid.NewGuid()}_{Path.GetFileName(file.FileName)}";
                fullPath = Path.Combine(_FileStoreDefaultPath, fileNameGenrated);
                file.SaveAs(fullPath);

                statuses.Add(new FilesDataUploadResult()
                {
                    name = file.FileName,
                    size = file.ContentLength,
                    type = file.ContentType,
                    url = $"{Constant.FileDownloadUrl}?fileName={fileNameGenrated}",
                    delete_url = $"{Constant.FileDeleteUrl}?fileName={fileNameGenrated}",
                    thumbnail_url = @"data:image/png;base64," + EncodeFile(fullPath),
                    filePath = fullPath,
                    originalFileName = fileNameGenrated,
                    webPath = $"{FolderPathConstant.UploadTemp}{fileNameGenrated}",
                    isUploded = true,
                });
            }
        }

        #region downloadsave / delete file
        public virtual void DownloadSaveFile(string fileName)
        {
            fullPath = Path.Combine(Server.MapPath(fileName));
            fileName = Path.GetFileName(fullPath);
            fileName = fileName.Substring(Constant.DefaultNameLength, fileName.Length - Constant.DefaultNameLength);
            HttpContextBase context = HttpContext;

            if (System.IO.File.Exists(fullPath))
            {
                context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                context.Response.ContentType = "application/octet-stream";
                context.Response.ClearContent();
                context.Response.WriteFile(fullPath);
            }
            else
                context.Response.StatusCode = 404;
        }

        public virtual void DeleteSaveFile(string fileName)
        {
            fullPath = Path.Combine(Server.MapPath(fileName));

            if (System.IO.File.Exists(fullPath))
            {
                System.IO.File.Delete(fullPath);
            }
        }
        #endregion
    }
}
