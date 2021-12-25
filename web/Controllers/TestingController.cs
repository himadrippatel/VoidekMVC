using Alliant._ApplicationCode;
using System.IO;
using System.Web;
using System.Web.Mvc;

namespace Alliant.Controllers
{
    public class TestingController : _BaseController
    {
        // GET: Testing
        public ActionResult Index(string topic = default(string))
        {
            return View();
        }

        public ActionResult UrlDemo()
        {
            return View();
        }

        public ActionResult TestUrl(string name)
        {
            return Json(name, JsonRequestBehavior.AllowGet);
        }

        public ActionResult TreeView()
        {
            return View();
        }

        public ActionResult LoadIcon()
        {
            return View();
        }

        /// <summary>
        /// Template Range Slider
        ///  Author: Harvi Patel
        /// </summary>
        /// <returns></returns>
        public ActionResult NoUiSlider()
        {
            return View("NoUiSlider");
        }

        /// <summary>
        /// Jquery Range Slider
        /// Author: Harvi Patel
        /// </summary>
        /// <returns></returns>
        public ActionResult Slider()
        {
            return View("Slider");
        }

        /// <summary>
        /// Clickable collapse
        /// Author: Harvi Patel
        /// </summary>
        /// <returns></returns>
        public ActionResult Collapse()
        {
            return View("Collapse");
        }

        /// <summary>
        /// Jquery range slider with textbox inputs
        /// Author: Harvi Patel
        /// </summary>
        /// <returns></returns>
        public ActionResult SliderWithTB()
        {
            return View("SliderWithTB");
        }

        /// <summary>
        /// Kendo range slider with textbox inputs
        /// Author: Jishan Siddique
        /// </summary>
        /// <returns></returns>
        public ActionResult kendoRangeSlider()
        {
            return View("kendoRangeSlider");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult Debounce()
        {
            return View("debounce");
        }

        public ActionResult ExportSnippet()
        {
            return View();
        }

        public ActionResult FileUploadDemo()
        {
            return View("FileUploadDemo");
        }

        [HttpPost]
        public ActionResult FileUploadDemo(HttpPostedFileBase file)
        {
            if (file?.ContentLength > 0)
            {
                string _FileName = Path.GetFileName(file.FileName);
                string _Path = Path.Combine(Server.MapPath(FolderPathConstant.Branch), _FileName);
                file.SaveAs(_Path);
            }
            return View();
        }

        public ActionResult KendoGrid()
        {
            return View("KendoGrid");
        }
        public ActionResult KendoAlliantGrid()
        {
            return View("KendoAlliantGrid");
        }
        public ActionResult KendomvcGrid()
        {
            return View("KendomvcGrid");
        }

        #region file with data
        public ActionResult FileDemo()
        {
            return View(new FileDemo());
        }

        public ActionResult FileDemoPost(FileDemo fileDemo, FormCollection formCollection, HttpPostedFileBase fileBranch)
        {
            return Json(fileDemo, JsonRequestBehavior.AllowGet);
        }
        #endregion

        public ActionResult AlliantFileUpload()
        {
            return View("AlliantFileUpload");
        }

        public ActionResult FilePost(FileDemo model, FileUploderModel fileUploders, FormCollection formCollection)
        {
            if (fileUploders != null && fileUploders.FilePath != null)
            {
                for (int iCnt = 0; iCnt < fileUploders.FilePath.Length; iCnt++)
                {
                    this.FileToMove(fileUploders.FilePath[iCnt], $"{FolderPathConstant.UploadTestingImg}{fileUploders.OriginalFileName[iCnt]}");
                }
            }

            return Json(fileUploders, JsonRequestBehavior.AllowGet);
        }

        public ActionResult JobTypeDropDownDemo()
        {
            return View("JobTypeDropDownDemo");
        }

        public ActionResult KendoGridDemo()
        {
            return View("KendoGridDemo");
        }

        #region ChartJS
        /// <summary>
        /// charts js bar charts demo
        /// Author: Harvi Patel
        /// </summary>
        /// <returns></returns>
        public ActionResult ChartDemo()
        {
            return View("ChartDemo");
        }

        /// <summary>
        /// charts js  demo
        /// Author: Jishan Siddique
        /// </summary>
        /// <returns></returns>
        public ActionResult Chart()
        {
            ChartModel chartModel = GetChartModel();

            return View(chartModel);
        }

        public ActionResult ChartData()
        {
            ChartModel chartModel = GetChartModel();

            return Json(chartModel, JsonRequestBehavior.AllowGet);
        }

        public ChartModel GetChartModel()
        {
            ChartModel chartModel = DependencyResolver.Current.GetService<ChartModel>();
            chartModel.labels = new string[] { "January", "February", "March", "April", "May", "June", "July" };
            chartModel.datasets = new ChartDatasets[] {
                new ChartDatasets(){label="Branch-1",data=new int[]{ 65, 59, 80, 81, 56, 55, 40 },backgroundColor="rgba(22,211,154,.5)",borderColor="transparent",pointBorderColor="#28D094",pointBackgroundColor="#FFF",pointBorderWidth=2,pointHoverBorderWidth=2,pointRadius=4 },
                new ChartDatasets(){label="Branch-2",data=new int[]{28, 48, 40, 19, 86, 27, 90 },backgroundColor="rgba(81,117,224,.5)",borderColor="transparent",pointBorderColor="#5175E0",pointBackgroundColor="#FFF",pointBorderWidth=2,pointHoverBorderWidth=2,pointRadius=4 },
                new ChartDatasets(){label="Branch-3",data=new int[]{80, 25, 16, 36, 67, 18, 76 },backgroundColor="rgba(249,142,118,.5)",borderColor="transparent",pointBorderColor="#F98E76",pointBackgroundColor="#FFF",pointBorderWidth=2,pointHoverBorderWidth=2,pointRadius=4 }
            };
            return chartModel;
        }

        public ActionResult AnimationChart()
        {
            return View();
        }
        #endregion
    }

    public class FileDemo
    {
        public string Name { get; set; }
        public int Age { get; set; }
        public bool IsActive { get; set; }
    }

    #region Chart Model
    public class ChartModel
    {
        public string[] labels { get; set; }
        public ChartDatasets[] datasets { get; set; }
    }

    public class ChartDatasets
    {
        public string label { get; set; }
        public int[] data { get; set; }
        public string backgroundColor { get; set; }
        public string borderColor { get; set; }
        public string pointBorderColor { get; set; }
        public string pointBackgroundColor { get; set; }
        public int pointBorderWidth { get; set; }
        public int pointHoverBorderWidth { get; set; }
        public int pointRadius { get; set; }
    }
    #endregion
}
