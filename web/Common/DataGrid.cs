using System;
using System.Collections.Generic;

namespace Alliant.Common
{
    public class DataGrid
    {
        public Guid TableID { get; set; }
        public string GridID { get; set; }

        public string GridName { get; set; }

        public string DataUrl { get; set; }
        public bool IsTotalTiTleShow { get; set; }
        public int TotalCount { get; set; }
        public bool IsCenterRequired { get; set; }
        public DataGridColumn[] DataGridColumn { get; set; }
        public List<PageSize> PageSize { get; set; }
        public bool IsSelectionRequired { get; set; }

        public string EditUrl { get; set; }

        public DataGrid()
        {
            TableID = Guid.NewGuid();
            DataGridColumn = new DataGridColumn[] { };

        }
    }
    public class PageSize
    {
        public int ID { get; set; }
        public int PageRecord { get; set; }
    }
    public class DataGridColumn
    {
        public string ColumnName { get; set; }
        public string SortColumName { get; set; }
        public bool IsEditable { get; set; }
        public bool IsCenterRequired { get; set; }
        public bool IsFilter { get; set; }
        public string CustomeUrl { get; set; }

        public DataTableType DataTableType { get; set; }
    }

    public enum DataTableType
    {
        String = 0,
        Int = 1,
        Float = 2,
        Decimal = 3,
        DateTime = 4
    }
}