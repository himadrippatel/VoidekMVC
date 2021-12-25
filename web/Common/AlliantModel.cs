using System.Collections;
using System.Collections.Generic;

namespace Alliant
{
    /// <summary>
    /// Use for bind DropDown
    /// </summary>
    public class AlliantDropDownDataModel
    {
        public AlliantDropDownDataModel()
        {
            ConfigurationOptions = new DropDownConfigurations() { };
            Model = null;
        }
        /// <summary>
        /// use: add select ConfigurationOptions like control id,option text
        /// </summary>
        public virtual DropDownConfigurations ConfigurationOptions { get; set; }
        /// <summary>
        /// add model value for option tag
        /// </summary>
        public virtual IEnumerable Model { get; set; }
    }

    /// <summary>
    /// DropDwon Configurations like control id and all
    /// </summary>
    public class DropDownConfigurations
    {
        /// <summary>
        /// Set control id unique name for control genrate
        /// </summary>
        public virtual string ControlID { get; set; }
        /// <summary>
        /// Set ValueFieldName filed name for option tag
        /// </summary>
        public virtual string ValueFieldName { get; set; }
        /// <summary>
        /// Set Display text name for option tag
        /// </summary>
        public virtual string DisplayTextFieldName { get; set; }
        /// <summary>
        /// If needed prefix in control
        /// </summary>
        public virtual string IDPrefix { get; set; }
        /// <summary>
        /// Display first item in default text
        /// </summary>
        public virtual string FirstItemDisplayText { get; set; }
        /// <summary>
        /// Set first item default value
        /// </summary>
        public virtual string FirstItemValue { get; set; }
        /// <summary>
        /// Add mutiple html attributes like class id and all type of attributes
        /// </summary>
        public virtual object HTMLAttributes { get; set; }
        /// <summary>
        /// use: some case requirment has chnage then we add some more code
        /// </summary>
        public virtual object ExtraDataBasedOnRequirements { get; set; }
        /// <summary>
        /// use for set selected value in control like edit page or predefine value.
        /// </summary>
        public virtual string SelectedValue { get; set; }
        public DropDownConfigurations()
        {
            ExtraDataBasedOnRequirements = new object();
        }

        /// <summary>
        /// set : true when you need cache data
        /// </summary>
        public bool IsCache { get; set; } = Constant.FALSE;
    }

    /// <summary>
    /// Use for select dropdwon with server side.
    /// </summary>
    public class AlliantSelectDropDownModel
    {
        /// <summary>
        /// Set control id unique name for control genrate
        /// </summary>
        public virtual string ControlID { get; set; }
        /// <summary>
        /// Add mutiple html attributes like class id and all type of attributes
        /// </summary>
        public virtual object HTMLAttributes { get; set; }
        /// <summary>
        /// Set "true" whene you need mutiple selection
        /// </summary>
        public virtual bool IsMultiSelect { get; set; }
        /// <summary>
        /// Pass server url for load and search data
        /// </summary>
        public virtual string Url { get; set; }
        /// <summary>
        /// Minimum length for search by default it's 3 character
        /// </summary>
        public virtual int MinLength { get; set; }
        /// <summary>
        /// Display per page record by default 10 result display
        /// </summary>
        public virtual int PageResult { get; set; }
        /// <summary>
        /// Display Placeholder in control by default "Type to search"
        /// </summary>
        public virtual string Placeholder { get; set; }
        /// <summary>
        /// Set some note for user
        /// </summary>
        public virtual string Note { get; set; }
        /// <summary>
        /// CloseOnSelect if "false" then select option not close if "true" then select option auto close after select. by default if false
        /// </summary>
        public virtual bool IsCloseOnSelect { get; set; }
        /// <summary>
        /// Display image in option tag by default "false"
        /// </summary>
        public virtual bool IsImageDisplay { get; set; }
        /// <summary>
        /// Display discription in option tag by default "false"
        /// </summary>
        public virtual bool IsDescriptionDisplay { get; set; }
        /// <summary>
        /// AllowClear if "true" then close icon display, if "false" not display by default if true
        /// </summary>
        public virtual bool AllowClear { get; set; } = true;
        /// <summary>
        /// Set default value for exclude value from server
        /// </summary>
        public virtual string NotIn { get; set; }
        /// <summary>
        /// Set control id like eg "Parent","Child" for exclude value from server
        /// </summary>
        public virtual string ExcludeControlIDValue { get; set; }
    }

    public class AlliantAutoCompleteModel
    {
        /// <summary>
        /// Set control id unique name for control genrate
        /// </summary>
        public virtual string ControlID { get; set; }
        /// <summary>
        /// Add mutiple html attributes like class id and all type of attributes
        /// </summary>
        public virtual object HTMLAttributes { get; set; }
        /// <summary>
        /// If "true" then result select mutiple, If "false" then single result select
        /// </summary>
        public virtual bool IsMultiSelect { get; set; }
        /// <summary>
        /// Pass server url for load and search data
        /// </summary>
        public virtual string Url { get; set; }
        /// <summary>
        /// Minimum length for search by default it's 3 character
        /// </summary>
        public virtual int MinLength { get; set; }
        /// <summary>
        /// Display Placeholder in control by default "Type to search"
        /// </summary>
        public virtual string Placeholder { get; set; }
        /// <summary>
        /// Set some note for user
        /// </summary>
        public virtual string Note { get; set; }
        /// <summary>
        /// If "true" then data store in case per search result
        /// </summary>
        public virtual bool IsCacheData { get; set; }
        /// <summary>
        /// Set selected value like id,label,value
        /// </summary>
        public virtual string SelectValue { get; set; }
        /// <summary>
        /// Set selected value like edit page or predefine value
        /// </summary>
        public virtual string SelectedValue { get; set; }

        /// <summary>
        /// Use wehen you post modal multiple
        /// </summary>
        public virtual string ViewModelID { get; set; }
    }


    /// <summary>
    /// Use for select Date Range Picker with server side.
    /// </summary>
    public class AlliantDateRangePickerModel
    {
        ///<summary>
        ///Set unique id for control generate
        ///</summary>
        public virtual string ControlID { get; set; }
        /// <summary>
        /// Add mutiple html attributes like class id and all type of attributes
        /// </summary>
        public virtual Dictionary<string, object> HTMLAttributes { get; set; }
        //public virtual object HTMLAttributes { get; set; }
        /////<summary>
        /////Add Date range key, value pair
        /////</summary>
        //public virtual Dictionary<string, object> Ranges { get; set; }
        public virtual List<AlliantDateRanges> DateRanges { get; set; }
        /// <summary>
        /// (true/false) Hide the apply and cancel buttons, and automatically apply a new date range as soon as two dates are clicked.
        /// </summary>
        public virtual bool AutoApply { get; set; } = true;
        /// <summary>
        ///  (true/false) Show year and month select boxes above calendars to jump to a specific month and year.
        /// </summary>
        public virtual bool ShowDropDowns { get; set; }
        /// <summary>
        /// When this option is set to true, the calendars for always shown .
        /// </summary>
        public virtual bool AlwaysShowCalendars { get; set; }
        /// <summary>
        /// true => Show localized week numbers at the start of each week on the calendars.
        /// </summary>
        public virtual bool ShowWeekNumbers { get; set; }
        public virtual string StartDate { get; set; }
        public virtual string EndDate { get; set; }
        public virtual string DateFormat { get; set; } = Constant.DateFormat;
        /// <summary>
        /// (true/false) Adds select boxes to choose times in addition to dates.
        /// </summary>
        public virtual bool TimePicker { get; set; }

        public virtual int TimePickerIncrement { get; set; }
        public virtual bool TimePicker24Hour { get; set; }
        public virtual bool TimePickerSeconds { get; set; }

        public string SelectedValue { get; set; }
    }

    /// <summary>
    /// Use for file uploader control
    /// </summary>
    public class AlliantFileUploadModel
    {
        /// <summary>
        /// Set control id unique name for control genrate
        /// </summary>
        public virtual string ControlID { get; set; }
        /// <summary>
        /// Add mutiple html attributes like class id and all type of attributes
        /// </summary>
        public virtual IDictionary<string, string> HTMLAttributes { get; set; }
        /// <summary>
        /// Add file path or location
        /// </summary>
        public virtual string TempUploadFilePath { get; set; } = FolderPathConstant.UploadTemp;
        /// <summary>
        /// Add file path or location
        /// </summary>
        public virtual string SaveUploadFilePath { get; set; }
        /// <summary>
        ///  file size max
        /// </summary>
        public virtual string MaxFileSize { get; set; }
        /// <summary>
        ///  file size min
        /// </summary>
        public virtual string MinFileSize { get; set; }
        /// <summary>
        /// file type like 'jpg', 'png', ,pdf  etc
        /// </summary>
        public virtual string AllowFileType { get; set; }
        /// <summary>
        /// If true then can upload multiple files
        /// </summary>
        public virtual bool IsMultipleFile { get; set; }
        /// <summary>
        /// Show previews for multiple files
        /// </summary>
        public virtual bool AllowPreviews { get; set; } = Constant.FALSE;
        /// <summary>
        /// If true then drag & drop file otherwise select the file
        /// </summary>
        public virtual bool AllowDragAndDrop { get; set; }
        /// <summary>
        /// set limit for multiple files uploading 
        /// </summary>
        public virtual int MaxFileUpload { get; set; } = Constant.MaxFileUpload;
        /// <summary>
        /// By default, files added to the widget are uploaded as soon as the user clicks on the start buttons.
        ///  To enable automatic uploads, set the following option to true:
        /// </summary>
        public virtual bool AllowAutoUpload { get; set; } = Constant.TRUE;
        /// <summary>
        ///  The container for the list of files. If undefined, it is set to an element with class "files" inside of the widget element.
        /// </summary>
        public virtual string FilesContainer { get; set; }
        /// <summary>
        /// By default, files are appended to the files container.
        /// Set the following option to true, to prepend files instead.
        /// </summary>
        public virtual string PrependFiles { get; set; }
        /// <summary>
        /// The ID of the upload template
        /// </summary>
        public virtual string UploadTemplateId { get; set; } = Constant.UploadTemplateId;
        /// <summary>
        /// The ID of the download template
        /// </summary>
        public virtual string DownloadTemplateId { get; set; } = Constant.DownloadTemplateId;
        /// <summary>
        /// Url set a default url anyone can override 
        /// </summary>
        public virtual string Url { get; set; } = Constant.FileUploderUrl;
        /// <summary>
        /// Default button text
        /// </summary>
        public virtual string ButtonText { get; set; } = Constant.ButtonText;

        public virtual List<FilesDataUploadResult> Files { get; set; }
    }

    /// <summary>
    /// use in file get action parameter for get file
    /// </summary>
    public class FileUploderModel
    {
        public string[] FileName { get; set; }
        public string[] OriginalFileName { get; set; }
        public string[] FilePath { get; set; }
        public bool[] IsUploded { get; set; }
    }

    /// <summary>
    /// bind file result
    /// </summary>
    public class FilesDataUploadResult
    {
        public string name { get; set; }
        public int size { get; set; }
        public string type { get; set; }
        public string url { get; set; }
        public string delete_url { get; set; }
        public string thumbnail_url { get; set; }
        public string delete_type { get; set; } = Constant.POST;
        public string download_type { get; set; } = Constant.POST;
        public string filePath { get; set; }
        public string webPath { get; set; }
        public string originalFileName { get; set; }
        public bool isUploded { get; set; } = Constant.FALSE;
    }
}