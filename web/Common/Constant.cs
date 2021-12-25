using System;
using System.Collections.Generic;
using System.Linq;

namespace Alliant
{
    public class Constant
    {
        public const string SaveMessage = "saved successfully",
        UnauthorizedMessage = "Unauthorized due to roles/permission on resource.";

        public static string AreaUserManagement = "UserManagement",
        AreaAdministrator = "Administrator",
        MainMenu = "MainMenu",
        ActiveTrue = "true",
        ActiveYes = "YES",
        ActiveNo = "NO",
        DateFormat = "MM/DD/YYYY";
        public const string SortAscending = "Ascending", SortDescending = "Descending";
        public const string NULLVALUES = "###NULL###";

        #region Kendo Page size
        public static readonly int[] KendoGridPageSize = new int[] { 10, 20, 25, 50, 100 };
        public const int KendoDefaultPageSize = 50;
        public const int EmployeePageSize = 20;
        #endregion

        #region Year        

        public static Dictionary<string, string> Years =>
           Enumerable.Range(0, 50).
           Select(i => new
           KeyValuePair<string, string>((DateTime.Now.Year - i).ToString(), (DateTime.Now.Year - i).ToString()))
           .ToDictionary(x => x.Key, x => x.Value);
        #endregion

        #region MonthName
        public static Dictionary<int, string> Months =>
            Enumerable.Range(1, 12).
            Select(i => new
            KeyValuePair<int, string>(i, System.Globalization.DateTimeFormatInfo.CurrentInfo.GetMonthName(i)))
            .ToDictionary(x => x.Key, x => x.Value);
        #endregion

        #region Validation
        public static Dictionary<string, Dictionary<string, object>> dtnUnobtrusiveValidation = new Dictionary<string, Dictionary<string, object>>()
            {
                {"Int", new Dictionary<string,object>(){ {"data-val-regex","Format Invalid"}, {"data-val-regex-pattern","\\d*"}, {"data-val-number","The field  must be a number."}, {"data-val","true"}}},
                {"Decimal",new Dictionary<string,object>(){ {"data-val-number","The field  must be a number."},{"data-val","true"}}},
                {"Guid",new Dictionary<string,object>(){}},
                {"Required",new Dictionary<string,object>(){ {"data-val-required", "The field  must be required" },{"data-val","true"}}},
                {"DateTime",new Dictionary<string,object>(){ {"data-val-date","The field  must be a date."},{"data-val","true"}}},
                {"Currency",new Dictionary<string,object>(){ }},
                {"Date",new Dictionary<string,object>(){ {"data-val-date","The field  must be a date."},{"data-val","true"}}},
                {"Duration",new Dictionary<string,object>(){ }},
                {"EmailAddress",new Dictionary<string,object>(){ }},
                {"Html",new Dictionary<string,object>(){ {"data-val-required", "The field  must be required" },{"data-val","true"}}},
                {"ImageUrl",new Dictionary<string,object>(){ }},
                {"MultilineText",new Dictionary<string,object>(){ }},
                {"Password",new Dictionary<string,object>(){ }},
                {"PhoneNumber",new Dictionary<string,object>(){ }},
                {"Text",new Dictionary<string,object>(){ }},
                {"Time",new Dictionary<string,object>(){ }},
                {"Url",new Dictionary<string,object>(){ }},
                {"StringLength",new Dictionary<string,object>(){ {"data-val-length","Data Length Invalid"},{"data-val-length-min",-2147483648},{"data-val","true"},{"data-val-length-max",2147483647}}},
                {"IntValue",new Dictionary<string,object>(){ {"data-val-range","Value Not In Range"},{"data-val-range-min",-2147483648},{"data-val-range-max",2147483647},{"data-val-number","The field  must be a number."},{"data-val","true"}}},
                {"DoubleValue",new Dictionary<string,object>(){ {"data-val-range","Value Not In Range"},{"data-val-range-min",-1.7976931348623157E+308},{"data-val-range-max",1.7976931348623157E+308},{"data-val-number","The field  must be a number."},{"data-val","true"}}},
                {"DateRange",new Dictionary<string,object>(){ {"data-val-daterange","Date must be less then 2015-04-20"},{"data-val-daterange-min","1900-01-01"},{"data-val-daterange-max","2015-04-20"},{"data-val-date","The field DateRange must be a date."},{"data-val","true"}}},
                {"RegularExpression",new Dictionary<string,object>(){ {"data-val-regex","Format Invalid"},{"data-val-regex-pattern","^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$"},{"data-val","true"}}}
            };
        #endregion

        #region FileUploader     
        public static string UploadTemplateId { get => "alliant-template-upload"; }
        public static string DownloadTemplateId => "alliant-template-download";
        public static string FileUploderUrl => "/_FileUploader/UploadFiles";
        public static string JqueryUndefined => "undefined";
        public static int MaxFileUpload => 1;
        public static string FileTypes => "/.+$/";
        public static bool TRUE => true;
        public static bool FALSE => false;
        public static string ButtonText => "Choose file";
        public static string FileDownloadUrl => "/_FileUploader/Download";
        public static string FileDeleteUrl => "/_FileUploader/Delete";
        public static string POST => "POST";
        public static string AllImages => @"/^image\/(gif|jpeg|png)$/";
        public static int DefaultNameLength => 37;
        public static int DefaultGuidNameLength => 36;
        #endregion

        #region Color Code
        public static string[] ColorCodes = new string[]
        {
            "#00A5A8",
            "#626E82",
            "#FF7D4D",
            "#FF4558",
            "#28D094",
            "#FF1493",
            "#DDA0DD",
            "#5175E0",
            "#F98E76",
            "#f3f3f3"

        };
        #endregion

        #region Razor page
        public static string NullLayout => "~/Views/Shared/_LayoutNull.cshtml";
        public static string LayoutAdmin => "~/Views/Shared/_LayoutAdmin.cshtml";
        public static string SalesRep => "SalesRep";
        public static string Branch => "Branch";
        public static string ID => "ID";
        #endregion
    }

    public class SessionKeyConstant
    {
        public static string Session_Token { get => "Session_Token"; }
        public static string Cookie_Key { get => "_Key"; }
    }

    public class FolderPathConstant
    {
        public const string ErrorLogPath = "~/Upload/ErrorLog/";
        public const string CustomizeViewPath = "~/_CustomizeView/";
        public const string NoImagePath = "~/Content/images/";
        public const string NoImageUrlPath = "/Content/images/";
        public const string Upload = "~/Upload/";
        public static string UploadTemp => "~/Upload/Temp/";
        public static string UploadTestingImg => "~/Upload/TestingImg/";
        public static string Branch => "~/Upload/Branch/";
        public static string Employee => "~/Upload/Employee/";
    }

    public class ReportPathConstant
    {
        public static string FollowUpReport => "~/Views/Reports/FollowUpReport/";
        public static string FunctionReport => "~/Views/Reports/FunctionReport/";
        public static string DailyFunctionsReport => "~/Views/Reports/DailyAccountingFunctionReport/";
        public static string InvoiceSalesReport => "~/Views/Reports/InvoiceSales/";
    }

    public class AlliantValidationAdditionalValue
    {
        public virtual string CompareErrorMessage { get; set; }
        public virtual string CompareTo { get; set; }
        public virtual DateTime? DateTime_Max { get; set; }
        public virtual DateTime? DateTime_Min { get; set; }
        public virtual double? DoubleValue_Max { get; set; }
        public virtual double? DoubleValue_Min { get; set; }
        public virtual int? IntValue_Max { get; set; }
        public virtual int? IntValue_Min { get; set; }
        public virtual string RegularExpression_CompareExpression { get; set; }
        public virtual int? StringLength_Max { get; set; }
        public virtual int? StringLength_Min { get; set; }
    }

    public enum AlliantValidations
    {
        Int, Decimal, Guid, Required, DateTime, Currency,
        Date, Duration, EmailAddress, Html, ImageUrl, MultilineText,
        Password, PhoneNumber, Text, Time, Url,
        /// <summary> Must specify additional values of StringLength_Min, StringLength_Max</summary>
        StringLength,
        /// <summary> Must specify additional values of IntValue_Min, IntValue_Max</summary>
        IntValue,
        /// <summary> Must specify additional values of DoubleValue_Min, DoubleValue_Max</summary>
        DoubleValue,
        /// <summary> Must specify additional values of CompareTo, CompareErrorMessage</summary>
        Compare,
        /// <summary> Specify additional values of DateTime_Min AND/OR DateTime_Max</summary>
        DateRange,
        /// <summary> Must specify additional values of RegularExpression_CompareExpression</summary>
        RegularExpression
    }

    public enum AlliantJSCompare
    {
        EqualString = 0,
        EqualStringIgnoreCase = 1,
        EqualInt = 2,
        EqualDate = 3,
        EqualFloat = 4,
        NotEqualString = 5,
        NotEqualStringIgnoreCase = 6,
        NotEqualInt = 7,
        NotEqualDate = 8,
        NotEqualFloat = 9,
        LessInt = 10,
        LessDate = 11,
        LessFloat = 12,
        LessTime = 13,
        GreaterInt = 14,
        GreaterDate = 15,
        GreaterFloat = 16,
        GreaterTime = 17,
        LessOrEqualInt = 18,
        LessOrEqualDate = 19,
        LessOrEqualFloat = 20,
        LessOrEqualTime = 21,
        GreaterOrEqualInt = 22,
        GreaterOrEqualDate = 23,
        GreaterOrEqualFloat = 24,
        GreaterOrEqualTime = 25,
        ContainedByParent = 26,
        ContainsParent = 27,
    }

    public static class AlliantRegularExpresion
    {
        public static string Numbers = "^[0-9]+$";
        public static string CapitalChar = "^[A-Z]+$";
        public static string SmallChar = "^[a-z]+$";
        public static string SmallChar_UnderScore = "^[a-z_]+$";
        public static string Character_Dot = "^[A-Za-z.]+$";
        public static string Character = "^[A-Za-z]+$";
        public static string Character_Space = "^[A-Za-z ]+$";
        public static string Character_SpaceAddSub = "^[A-Za-z +-]+$";
        public static string Character_SpaceDotApostropheBrackets = "^[A-Za-z.'() ]+$";
        public static string Character_SpacesDash = "^[A-Za-z- ]+$";
        public static string Character_SpaceDotApostropheDash = "^[A-Za-z.' -]+$";
        public static string Character_SpaceDotApostrophe = "^[A-Za-z.' ]+$";
        public static string Character_SpaceApostrophe = "^[A-Za-z' ]+$";
        public static string NoSpace = @"^\S*$";
        public static string Numbers_CapitalChar = "^[0-9A-Z]+$";
        public static string Numbers_SmallChar = "^[0-9a-z]+$";
        public static string Numbers_Dash = "^[0-9-]+$";
        public static string Numbers_Dot = "^[0-9.]+$";
        public static string Number_Character = "^[0-9A-Za-z]+$";
        public static string Number_CharacterSpace = "^[0-9A-Za-z ]+$";
        public static string Number_Characters_SpaceDotDash = "^[0-9A-Za-z .-]+$";
        public static string Number_Characters_SpaceDotDashApostrophe = "^[0-9A-Za-z.' -]+$";
        public static string Number_Character_SpaceDotApostropheBrackets = "^[0-9A-Za-z.'() ]+$";
        public static string Number_Characters_SpaceDotDashApostropheBrackets = "^[0-9A-Za-z.' ()-]+$";
        public static string Income = "^[0-9.]+$";
        public static string Grades = "^[A-Z+-]+$";

        public static string NumbersLeadingNonZero = "^[1-9]{0,1}[0-9]+$";
        public static string Date = "^[1-9]\\d{3}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$";
        public static string YearDash = "^[1-9]\\d{3}-([1-9]\\d{3})+$";
        public static string Year = "^[1-9]\\d{3}$";
        public static string MobileNumber = "^[1-9]\\d{9}$";
        public static string LandLineNumber = "^[0-9(][0-9-/()]+$";
        public static string PhoneNumber_USA = "^\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$";
        public static string Fax_USA = "^\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$";/* "\\+1(|\\.|\\-)[2-9][0-9]{2}(|\\.|\\-)[0-9]{3}(|\\.|\\-)[0-9]{4}";*/
        public static string Zip_USA = "^[0-9]{5}(?:-[0-9]{4})?$";
        public static string Email = "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";
        public static string Website = "(((http|ftp|https):\\/\\/)|www\\.)[\\w\\-_]+(\\.[\\w\\-_]+)+([\\\\w\\-\\.,@?^=%&amp;:/~\\+#!]*[\\w\\-\\@?^=%&amp;/~\\+#])?";

        public static string Time_12 = "^(?:0?[0-9]|1[0-2]):[0-5][0-9] [aApP][mM]$";
        public static string Time_24 = "^(?:[01][0-9]|2[0-3]):[0-5][0-9]$";
        public static string Time_12And24 = "^(?:(?:0?[0-9]|1[0-2]):[0-5][0-9] [aApP][mM]|(?:[01][0-9]|2[0-3]):[0-5][0-9])$";

        public static string CustomExpr(bool pNumbers, bool pSmallChar, bool pCapitalChar, string pOtherSpecialChar)
        {
            var oFinalExpression = "^[";
            if (pNumbers) oFinalExpression += "0-9";
            if (pSmallChar) oFinalExpression += "a-z";
            if (pCapitalChar) oFinalExpression += "A-Z";
            if (!string.IsNullOrEmpty(pOtherSpecialChar)) oFinalExpression += pOtherSpecialChar;
            oFinalExpression += "]+$";
            return oFinalExpression;
        }
    }

    public enum AlliantDateRanges
    {
        /// <summary>
        /// set this if you want all date ranges in control
        /// </summary>
        All = -1,
        Today = 1,
        Yesterday = 2,
        Last7Days = 3,
        Last30Days = 4,
        ThisMonth = 5,
        LastMonth = 6,
        NextMonth = 7,
        Next4Months = 8,
        LastYear = 9,
        ThisYear = 10,
        NextYear = 11,
        Next3Days = 12,
        Next7Days = 13,
        Next10Days = 14,
        Next30Days = 15,
        Next60Days = 16,
        Next90Days = 17
    }
}