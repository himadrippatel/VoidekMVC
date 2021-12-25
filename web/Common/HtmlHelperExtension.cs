using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using System.Web.Routing;

namespace Alliant.Common
{
    public static class HtmlHelperExtension
    {
        public static readonly string EncryptionKey = "#Alliant$&SOFTWARE@#";

        public static string Encrypt(this HtmlHelper helper, string encryptString)
        {
            encryptString = Utility.UtilityConstant.Encrypt(encryptString);
            return encryptString;
        }

        public static string Decrypt(this HtmlHelper helper, string cipherText)
        {
            cipherText = Utility.UtilityConstant.Decrypt(cipherText);
            return cipherText;
        }

        #region View extension helper
        public static string StringStoner(this HtmlHelper helper, string pValue, int length = 60, string pdelim = "....")
        {
            return (pValue != null && pValue.Length > length) ? string.Concat(pValue.Substring(0, length), "", pdelim) : pValue;
        }

        public static MvcHtmlString AlliantTooltip(this HtmlHelper htmlHelper, string message, string placement = "top", bool allowhtml = false)
        {
            MvcHtmlString htmlString = new MvcHtmlString($"<img src=\"/Content/Images/icon_tooltip.gif\" title=\"{message}\" data-toggle=\"tooltip\" data-placement=\"{placement}\" data-html=\"{allowhtml}\" />");
            return htmlString;
        }
        #endregion

        public static IHtmlString Routing(this HtmlHelper helper, string pURL)
        {
            if (System.Web.Configuration.WebConfigurationManager.AppSettings["UrlEncrypted"] == "1")
            {
                if (pURL.Contains("?"))
                {
                    pURL = HttpUtility.UrlDecode(HttpUtility.HtmlDecode(pURL));
                    string[] oPathAndQuery = pURL.Split(new string[] { "?" }, StringSplitOptions.None);
                    string oPath = oPathAndQuery[0];
                    string oQueryString = oPathAndQuery[1];
                    string oEncodedQueryString = Decrypt(oQueryString);
                    return new System.Web.HtmlString(oPath + "?=" + oEncodedQueryString);
                }
                else
                    return new System.Web.HtmlString(pURL);
            }
            else
            {
                return new System.Web.HtmlString(pURL);
            }
        }

        #region RemoveHtml
        public static string HtmlDecode(this HtmlHelper helper, string pValue)
        {
            return (pValue != null) ? HttpUtility.HtmlDecode(pValue) : null;
        }
        public static string HtmlEncode(this HtmlHelper helper, string pValue)
        {
            return (pValue != null) ? HttpUtility.HtmlEncode(pValue) : null;
        }
        public static readonly Regex oHtmlRemoveString = new Regex("<.*?>|&.*?;");
        public static string HtmlRemoveFromString(this HtmlHelper helper, string pValue)
        {
            return (string.IsNullOrEmpty(pValue) ? "" : oHtmlRemoveString.Replace(HtmlDecode(helper, pValue), string.Empty));
        }
        #endregion

        #region Action
        /*Action helper */
        public static string AlliantAction(this UrlHelper urlHelper, string actionName) { return urlHelper.Action(actionName).Routing().ToString(); }
        public static string AlliantAction(this UrlHelper urlHelper, string actionName, object routeValues) { return urlHelper.Action(actionName, routeValues).Routing().ToString(); }
        public static string AlliantAction(this UrlHelper urlHelper, string actionName, RouteValueDictionary routeValues) { return urlHelper.Action(actionName, routeValues).Routing().ToString(); }
        public static string AlliantAction(this UrlHelper urlHelper, string actionName, string controllerName) { return urlHelper.Action(actionName, controllerName).Routing().ToString(); }
        public static string AlliantAction(this UrlHelper urlHelper, string actionName, string controllerName, object routeValues) { return urlHelper.Action(actionName, controllerName, routeValues).Routing().ToString(); }
        public static string AlliantAction(this UrlHelper urlHelper, string actionName, string controllerName, RouteValueDictionary routeValues) { return urlHelper.Action(actionName, controllerName, routeValues).Routing().ToString(); }
        public static string AlliantAction(this UrlHelper urlHelper, string actionName, string controllerName, object routeValues, string protocol) { return urlHelper.Action(actionName, controllerName, routeValues, protocol).Routing().ToString(); }
        public static string AlliantAction(this UrlHelper urlHelper, string actionName, string controllerName, RouteValueDictionary routeValues, string protocol, string hostName) { return urlHelper.Action(actionName, controllerName, routeValues, protocol, hostName).Routing().ToString(); }
        #endregion

        /*use in .cs file*/
        public static string Encrypt(string encryptString)
        {
            encryptString = Utility.UtilityConstant.Encrypt(encryptString);
            return encryptString;
        }

        public static string Decrypt(string cipherText)
        {
            cipherText = Utility.UtilityConstant.Decrypt(cipherText);
            return cipherText;
        }

        public static IHtmlString Routing(this string pURL)
        {
            if (System.Web.Configuration.WebConfigurationManager.AppSettings["UrlEncrypted"] == "1")
            {
                if (pURL.Contains("?"))
                {
                    pURL = HttpUtility.UrlDecode(HttpUtility.HtmlDecode(pURL));
                    string[] oPathAndQuery = pURL.Split(new string[] { "?" }, StringSplitOptions.None);
                    string oPath = oPathAndQuery[0];
                    string oQueryString = oPathAndQuery[1];
                    string oEncodedQueryString = Encrypt(oQueryString);
                    return new HtmlString(string.Concat(oPath, "?", Encrypt("Alliant="), oEncodedQueryString));
                }
                else
                    return new HtmlString(pURL);
            }
            else
            {
                return new HtmlString(pURL);
            }
        }

        #region AjaxHelper
        public static string DropDownData(this HtmlHelper htmlHelper, string oelem, string actionURL, string targetControlID, string fixedValue = null, string pReturnFunction = null, string pCallEvenIfNull = null)
        {
            return string.Concat("DropDownData(", oelem, ",'", actionURL, "',", "'", targetControlID, "',", (string.IsNullOrEmpty(fixedValue) ? "undefined" : fixedValue), ",", (string.IsNullOrEmpty(pReturnFunction) ? "undefined" : pReturnFunction), ",", (string.IsNullOrEmpty(pCallEvenIfNull) ? "undefined" : pCallEvenIfNull), ")");
        }
        public static string AjaxCall(this HtmlHelper helper, string thisdata, string pUrl, string pRequestType, string pPostParentForm = "true", string pSaveAndNew = "false", string pData = null, string pDataLoadDivID = null, string pLoadOnly = null, string pReturnFunction = null, string pGridIds = null)
        {
            if (string.IsNullOrEmpty(pUrl))
            {
                pUrl = System.Web.HttpContext.Current.Server.UrlDecode(pUrl);
            }
            thisdata = string.IsNullOrEmpty(thisdata) ? "undefined" : thisdata;
            pRequestType = string.IsNullOrEmpty(pRequestType) ? "'post'" : "'" + pRequestType + "'";
            pPostParentForm = string.IsNullOrEmpty(pPostParentForm) ? "undefined" : pPostParentForm;
            pDataLoadDivID = pDataLoadDivID == null ? "undefined" : "'" + pDataLoadDivID + "'";
            pReturnFunction = pReturnFunction == null ? "undefined" : pReturnFunction;
            pData = pData == null ? "undefined" : pData;
            pLoadOnly = pLoadOnly == null ? "undefined" : pLoadOnly;
            pGridIds = string.IsNullOrEmpty(pGridIds) ? "" : pGridIds;
            pSaveAndNew = (pSaveAndNew == null ? "false" : pSaveAndNew);
            return string.Concat("AjaxCall(", thisdata, ",'", pUrl, "',", pRequestType, ",", pPostParentForm, ",", pSaveAndNew, ",", pData, ",", pDataLoadDivID, ",", pLoadOnly, ",", pReturnFunction, ",'", pGridIds, "');");
        }
        public static string PostOnlyAjaxCall(this HtmlHelper helper, string thisdata, string pUrl, string pRequestType = "POST", string pPostParentForm = "true", string pData = null, string pReturnFunction = null, string pErrorFunction = null)
        {
            if (string.IsNullOrEmpty(pUrl))
            {
                pUrl = System.Web.HttpContext.Current.Server.UrlDecode(pUrl);
            }
            thisdata = string.IsNullOrEmpty(thisdata) ? "undefined" : thisdata;
            pRequestType = string.IsNullOrEmpty(pRequestType) ? "'post'" : "'" + pRequestType + "'";
            pPostParentForm = string.IsNullOrEmpty(pPostParentForm) ? "undefined" : pPostParentForm;
            pReturnFunction = pReturnFunction == null ? "undefined" : pReturnFunction;
            pData = pData == null ? "undefined" : pData;
            pErrorFunction = pErrorFunction == null ? "undefined" : pErrorFunction;
            return string.Concat("PostOnlyAjaxCall(", thisdata, ",'", pUrl, "',", pRequestType, ",", pPostParentForm, ",", pData, ",", pReturnFunction, ",", pErrorFunction, ");");
        }

        public static DataGrid DataGrid(this HtmlHelper htmlHelper, string GridID, string DataUrl = null)
        {
            DataGrid oDataGrid = new DataGrid();
            oDataGrid.GridID = GridID;
            oDataGrid.DataUrl = DataUrl;
            List<PageSize> lstPageSize = new List<PageSize>();
            lstPageSize.Add(new PageSize() { ID = 1, PageRecord = 10 });
            lstPageSize.Add(new PageSize() { ID = 2, PageRecord = 20 });
            lstPageSize.Add(new PageSize() { ID = 3, PageRecord = 50 });
            lstPageSize.Add(new PageSize() { ID = 4, PageRecord = 100 });
            oDataGrid.PageSize = lstPageSize;
            oDataGrid.GridName = GridID;
            return oDataGrid;
        }
        #endregion

        #region Jquery helper
        public static string RemoveAjaxContainer(this HtmlHelper helper, string id = null)
        {
            return string.Concat("RemoveAjaxContainer(", (string.IsNullOrEmpty(id) ? "undefined" : id), ");");
        }

        /// <summary>
        /// Use for display file control
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="uploadModel"></param>
        /// <returns></returns>
        public static MvcHtmlString AlliantFileUploder(this HtmlHelper htmlHelper, AlliantFileUploadModel uploadModel)
        {
            return htmlHelper.Partial("FileUpload", uploadModel);
        }

        /// <summary>
        /// Use for display date range control
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="pickerModel"></param>
        /// <returns></returns>
        public static MvcHtmlString AlliantDateRangePicker(this HtmlHelper htmlHelper, AlliantDateRangePickerModel pickerModel)
        {           
            return htmlHelper.Partial("DateRangePicker", pickerModel);
        }

        public static MvcHtmlString AlliantDropdown(this HtmlHelper htmlHelper, AlliantDropDownDataModel downDataModel)
        {
            return htmlHelper.Partial("Dropdown", downDataModel);
        }
        #endregion

        #region validation Helper
        public static IDictionary<string, object> GetAlliantValidationAttributes(this HtmlHelper pHtml, List<AlliantValidations> pValidation, AlliantValidationAdditionalValue pAlliantValidationAdditionalValue = null)
        {
            Dictionary<string, Dictionary<string, object>> dtnFinalValidations = Constant.dtnUnobtrusiveValidation;
            if (pAlliantValidationAdditionalValue != null)
            {
                if (pAlliantValidationAdditionalValue.StringLength_Min != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["StringLength"].First(o => o.Key.Contains("min"));
                    dtnFinalValidations["StringLength"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.StringLength_Min;
                }
                if (pAlliantValidationAdditionalValue.StringLength_Max != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["StringLength"].First(o => o.Key.Contains("max"));
                    dtnFinalValidations["StringLength"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.StringLength_Max;
                }
                if (pAlliantValidationAdditionalValue.IntValue_Min != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["IntValue"].First(o => o.Key.Contains("min"));
                    dtnFinalValidations["IntValue"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.IntValue_Min;
                }
                if (pAlliantValidationAdditionalValue.IntValue_Max != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["IntValue"].First(o => o.Key.Contains("max"));
                    dtnFinalValidations["IntValue"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.IntValue_Max;
                }
                if (pAlliantValidationAdditionalValue.DoubleValue_Min != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["DoubleValue"].First(o => o.Key.Contains("min"));
                    dtnFinalValidations["DoubleValue"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.DoubleValue_Min;
                }
                if (pAlliantValidationAdditionalValue.DoubleValue_Max != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["DoubleValue"].First(o => o.Key.Contains("max"));
                    dtnFinalValidations["DoubleValue"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.DoubleValue_Max;
                }
                if (pAlliantValidationAdditionalValue.RegularExpression_CompareExpression != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["RegularExpression"].First(o => o.Key.Contains("pattern"));
                    dtnFinalValidations["RegularExpression"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.RegularExpression_CompareExpression;
                }
                if (pAlliantValidationAdditionalValue.DateTime_Min != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["DateRange"].First(o => o.Key.Contains("min"));
                    dtnFinalValidations["DateRange"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.DateTime_Min.Value.ToString("yyyy-MM-dd");
                }
                if (pAlliantValidationAdditionalValue.DateTime_Max != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["DateRange"].First(o => o.Key.Contains("max"));
                    dtnFinalValidations["DateRange"][oChiledDictionary.Key] = pAlliantValidationAdditionalValue.DateTime_Max.Value.ToString("yyyy-MM-dd");
                }
                if (pAlliantValidationAdditionalValue.DateTime_Min != null && pAlliantValidationAdditionalValue.DateTime_Max != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["DateRange"].First(o => !o.Key.Contains("min") && !o.Key.Contains("max") && o.Key.Contains("daterange"));
                    dtnFinalValidations["DateRange"][oChiledDictionary.Key] = string.Format("Date must be between {0} and {1}", pAlliantValidationAdditionalValue.DateTime_Min.Value.ToString("yyyy-MM-dd"), pAlliantValidationAdditionalValue.DateTime_Max.Value.ToString("yyyy-MM-dd"));
                }
                else if (pAlliantValidationAdditionalValue.DateTime_Min != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["DateRange"].First(o => !o.Key.Contains("min") && !o.Key.Contains("max") && o.Key.Contains("daterange"));
                    dtnFinalValidations["DateRange"][oChiledDictionary.Key] = string.Format("Date must be greater then {0}", pAlliantValidationAdditionalValue.DateTime_Min.Value.ToString("yyyy-MM-dd"));

                    KeyValuePair<string, object> oChiledDictionary1 = dtnFinalValidations["DateRange"].First(o => o.Key.Contains("max"));
                    dtnFinalValidations["DateRange"][oChiledDictionary1.Key] = "2999-01-01";// (new DateTime(2999, 1, 1)).ToString("yyyy-MM-dd");
                }
                else if (pAlliantValidationAdditionalValue.DateTime_Max != null)
                {
                    KeyValuePair<string, object> oChiledDictionary = dtnFinalValidations["DateRange"].First(o => !o.Key.Contains("min") && !o.Key.Contains("max") && o.Key.Contains("daterange"));
                    dtnFinalValidations["DateRange"][oChiledDictionary.Key] = string.Format("Date must be less then {0}", pAlliantValidationAdditionalValue.DateTime_Max.Value.ToString("yyyy-MM-dd"));

                    KeyValuePair<string, object> oChiledDictionary1 = dtnFinalValidations["DateRange"].First(o => o.Key.Contains("min"));
                    dtnFinalValidations["DateRange"][oChiledDictionary1.Key] = "1900-01-01";// (new DateTime(1900, 1, 1)).ToString("yyyy-MM-dd");
                }
            }
            Dictionary<string, object> oResult = new Dictionary<string, object>();
            foreach (AlliantValidations oValidation in pValidation)
            {
                dtnFinalValidations[oValidation.ToString()].Select(o => o.Key).ToList().ForEach(o =>
                { if (!oResult.ContainsKey(o)) oResult.Add(o, dtnFinalValidations[oValidation.ToString()][o]); });
            }
            return oResult;
        }

        public static IHtmlString AlliantValidationMessage(this HtmlHelper helper, string pControlID)
        {
            return helper.Raw("<span data-valmsg-replace=\"true\" data-valmsg-for=\"" + pControlID + "\" class=\"field-validation-valid red\"></span>");
        }

        public static IDictionary<string, object> RequiredMessage(this IDictionary<string, object> pKeys, string pMessege = "Required")
        {
            Dictionary<string, object> dtValidation = new Dictionary<string, object>(pKeys);
            if (dtValidation != null && !string.IsNullOrEmpty(pMessege))
            {
                if (dtValidation.ContainsKey("data-val-required"))
                {
                    dtValidation["data-val-required"] = pMessege;
                }
            }
            return dtValidation;
        }

        public static IDictionary<string, object> AddGeneral(this IDictionary<string, object> pExistingAttributeDictionary, string pKey, string pValue)
        {
            if (pExistingAttributeDictionary == null) return pExistingAttributeDictionary;
            if (pKey == "class" && pExistingAttributeDictionary.ContainsKey(pKey) && pKey == "class") pExistingAttributeDictionary[pKey] += " " + pValue;
            else if (pExistingAttributeDictionary.ContainsKey(pKey)) pExistingAttributeDictionary[pKey] = pValue;
            else pExistingAttributeDictionary.Add(pKey, pValue);

            return pExistingAttributeDictionary;
        }

        public static IDictionary<string, object> AddDatepickerYearRange(this IDictionary<string, object> pExistingAttributeDictionary, string pYearRange)
        {
            if (pExistingAttributeDictionary == null) return pExistingAttributeDictionary;
            pExistingAttributeDictionary.Add("data-jsdatepicker-yearrange", pYearRange);
            return pExistingAttributeDictionary;
        }

        public static IDictionary<string, object> AddCompareValidation(this IDictionary<string, object> pExistingAttributeDictionary, string pCompareTo, AlliantJSCompare pCompareType, string pErrorMessage)
        {
            if (pExistingAttributeDictionary == null) return pExistingAttributeDictionary;
            if (string.IsNullOrEmpty(pErrorMessage))
                pErrorMessage = "Value Comparison Failed. Compared With " + pCompareTo;
            pExistingAttributeDictionary.Add("data-val-compare-to", pCompareTo);
            pExistingAttributeDictionary.Add("data-val-compare-comparetype", pCompareType);
            pExistingAttributeDictionary.Add("data-val-compare", pErrorMessage);
            if (!pExistingAttributeDictionary.ContainsKey("data-val")) pExistingAttributeDictionary.Add("data-val", "true");
            return pExistingAttributeDictionary;
        }

        public static IDictionary<string, object> AddValidateIf(this IDictionary<string, object> pExistingAttributeDictionary, string pBaseControlID, string pTargetValue, AlliantJSCompare pCompareType, string pErrorMessage)
        {
            if (pExistingAttributeDictionary == null) return pExistingAttributeDictionary;
            pExistingAttributeDictionary.Add("data-val-validateif", string.IsNullOrWhiteSpace(pErrorMessage) ? "Required" : pErrorMessage);
            pExistingAttributeDictionary.Add("data-val-validateif-dependentproperty", pBaseControlID);
            pExistingAttributeDictionary.Add("data-val-validateif-targetvalue", pTargetValue);
            pExistingAttributeDictionary.Add("data-val-validateif-comparetype", pCompareType);
            if (!pExistingAttributeDictionary.ContainsKey("data-val")) pExistingAttributeDictionary.Add("data-val", "true");
            return pExistingAttributeDictionary;
        }
        #endregion

        #region Datatable to html
        public static MvcHtmlString DataTableToHTML(this HtmlHelper htmlHelper, DataTable dataTable)
        {
            StringBuilder builder = new StringBuilder();
            builder.AppendLine("<table class=\"jsAutoReports table table-striped table-hover table-bordered\">");
            builder.AppendLine("<thead>");
            builder.AppendLine("<tr>");
            for (int iCnt = 0; iCnt < dataTable.Columns.Count; iCnt++)
            {
                builder.AppendLine("<th>");
                builder.AppendLine(dataTable.Columns[iCnt].ColumnName);
                builder.AppendLine("</th>");
            }
            builder.AppendLine("</tr>");

            builder.AppendLine("<tbody>");
            for (int iCnt = 0; iCnt < dataTable.Rows.Count; iCnt++)
            {
                builder.AppendLine("<tr>");
                for (int jCnt = 0; jCnt < dataTable.Columns.Count; jCnt++)
                {
                    builder.AppendLine("<td>");
                    builder.AppendLine(dataTable.Rows[iCnt][jCnt].ToString());
                    builder.AppendLine("</td>");
                }
                builder.AppendLine("</tr>");
            }
            builder.AppendLine("</tbody>");
            builder.AppendLine("</table>");
            return new MvcHtmlString(builder.ToString());
        }
        #endregion

        #region Area
        public static string AreaUserManagement(this HtmlHelper htmlHelper)
        {
            return Constant.AreaUserManagement;
        }
        public static string AreaAdministrator(this HtmlHelper htmlHelper)
        {
            return Constant.AreaAdministrator;
        }
        #endregion

        #region Bread
        public static MvcHtmlString BreadcrumbNavigation(this HtmlHelper helper)
        {
            if (helper.ViewContext.RouteData.Values["controller"].ToString() == "Home" ||
                helper.ViewContext.RouteData.Values["controller"].ToString() == "Account")
            {
                return new MvcHtmlString(string.Empty);
            }

            string controllerName = helper.ViewContext.RouteData.Values["controller"].ToString();
            string actionName = helper.ViewContext.RouteData.Values["action"].ToString();

            StringBuilder breadcrumb = new StringBuilder()
                                .AppendLine("<ol class='breadcrumb'><li>")
                                .AppendLine(helper.ActionLink("Home", "Index", "Home").ToHtmlString())
                                .AppendLine("</li><li>")
                                .AppendLine(helper.ActionLink(controllerName,
                                                          "Index", controllerName).ToHtmlString())
                                .AppendLine("</li>");


            if (helper.ViewContext.RouteData.Values["action"].ToString() != "Index")
            {
                breadcrumb.AppendLine("<li>")
                          .AppendLine(helper.ActionLink(actionName, actionName, controllerName).ToHtmlString())
                          .AppendLine("</li>");
            }
            breadcrumb.AppendLine("</ol>");
            return new MvcHtmlString(breadcrumb.ToString());
        }
        #endregion

        #region Partial
        public static MvcHtmlString AlliantPartial(this HtmlHelper htmlHelper, string partialViewName)
        {
            return htmlHelper.Partial(partialViewName);
        }
        public static MvcHtmlString AlliantPartial(this HtmlHelper htmlHelper, string partialViewName, ViewDataDictionary viewData)
        {
            return htmlHelper.Partial(partialViewName, viewData);
        }
        public static MvcHtmlString AlliantPartial(this HtmlHelper htmlHelper, string partialViewName, object model)
        {
            return htmlHelper.Partial(partialViewName, model);
        }
        public static MvcHtmlString AlliantPartial(this HtmlHelper htmlHelper, string partialViewName, object model, ViewDataDictionary viewData)
        {
            return htmlHelper.Partial(partialViewName, model, viewData);
        }
        #endregion

        #region Enum
        public static List<SelectListItem> EnumToList<T>(this HtmlHelper htmlHelper)
        {
            return Enum.GetValues(typeof(T)).Cast<T>().Select(v => new SelectListItem
            {
                Text = v.ToString(),
                Value = v.ToString()
            }).ToList();
        }
        #endregion

        #region View helper
        /// <summary>
        /// get file name given by path
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="fullName"></param>
        /// <returns></returns>
        public static string GetFileName(this HtmlHelper htmlHelper, string fullName)
        {
            return System.IO.Path.GetFileName(fullName);
        }

        public static bool isValid = false;
        /// <summary>
        /// guid pattern check in IsGuid
        /// </summary>
        private static Regex isGuid = new Regex(@"^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$", RegexOptions.Compiled);

        /// <summary>
        /// check image name presnet guid or not
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static bool IsGuid(this HtmlHelper htmlHelper, string pValue)
        {
            isValid = false;

            if (!string.IsNullOrEmpty(pValue))
            {
                if (pValue.Length > Constant.DefaultGuidNameLength)
                {
                    pValue = pValue.Substring(0, Constant.DefaultGuidNameLength);
                }

                if (isGuid.IsMatch(pValue))
                {
                    isValid = true;
                }
            }
            return isValid;
        }
        #endregion
    }
}
