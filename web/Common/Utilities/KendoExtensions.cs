using Alliant.Domain;
using Kendo.Mvc;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Dynamic;
using System.Linq;
using System.Text;

namespace Alliant
{
    public static class KendoExtensions
    {
        public static int _index = 0;
        public static CustomDataSourceResult ToDataSourceResult(this IEnumerable enumerable, DataSourceRequest request)
        {
            CustomDataSourceResult result = CustomDataSourceResult.Instance;
            result.Data = enumerable;
            return result;
        }

        public static List<dynamic> GetFilterDynamic(this DataSourceRequest request, string isOld = null)
        {
            List<dynamic> dynamics = new List<dynamic>();
            if (request.Filters != null && request.Filters.Count > 0)
            {
                dynamic filter = null;
                FilterDescriptor descriptor = null;
                CompositeFilterDescriptor compositeFilterDescriptor = null;
                foreach (IFilterDescriptor filterDescriptor in request.Filters)
                {
                    if (filterDescriptor is CompositeFilterDescriptor)
                    {
                        compositeFilterDescriptor = (CompositeFilterDescriptor)filterDescriptor;
                        foreach (IFilterDescriptor childFilter in compositeFilterDescriptor.FilterDescriptors)
                        {
                            filter = new ExpandoObject();
                            descriptor = (FilterDescriptor)childFilter;
                            filter.Key = descriptor.Member;
                            filter.Value = descriptor.Value;
                            filter.Operator = descriptor.Operator;

                            dynamics.Add(filter);
                        }
                    }
                    else
                    {
                        filter = new ExpandoObject();
                        descriptor = (FilterDescriptor)filterDescriptor;
                        filter.Key = descriptor.Member;
                        filter.Value = descriptor.Value;
                        filter.Operator = descriptor.Operator;

                        dynamics.Add(filter);
                    }
                }
            }

            return dynamics;
        }

        //public static IList<KendoFilterKeyValue> GetFilterDynamic(this DataSourceRequest request)
        //{
        //    List<KendoFilterKeyValue> kendoFilters = new List<KendoFilterKeyValue>();
        //    if (request.Filters != null && request.Filters.Count > 0)
        //    {
        //        FilterDescriptor descriptor = null;
        //        CompositeFilterDescriptor compositeFilterDescriptor = null;
        //        foreach (IFilterDescriptor filterDescriptor in request.Filters)
        //        {
        //            if (filterDescriptor is CompositeFilterDescriptor)
        //            {
        //                compositeFilterDescriptor = (CompositeFilterDescriptor)filterDescriptor;
        //                foreach (IFilterDescriptor childFilter in compositeFilterDescriptor.FilterDescriptors)
        //                {
        //                    if (childFilter is CompositeFilterDescriptor)
        //                    {
        //                        CompositeFilterDescriptor compositeFilter = (CompositeFilterDescriptor)childFilter;
        //                        foreach (IFilterDescriptor filter in compositeFilter.FilterDescriptors)
        //                        {
        //                            FilterDescriptor filtdescriptor = (FilterDescriptor)filter;
        //                            kendoFilters.AddOrMerge(GetKeyValue(filtdescriptor));
        //                        }
        //                    }
        //                    else
        //                    {
        //                        descriptor = (FilterDescriptor)childFilter;
        //                        kendoFilters.AddOrMerge(GetKeyValue(descriptor));
        //                    }

        //                }
        //            }
        //            else
        //            {
        //                descriptor = (FilterDescriptor)filterDescriptor;
        //                kendoFilters.AddOrMerge(GetKeyValue(descriptor));
        //            }
        //        }
        //    }
        //    return kendoFilters;
        //}

        public static IList<KendoFilterKeyValue> GetFilterDynamic(this DataSourceRequest request)
        {
            kendoFilters_temp.Clear();
            List<KendoFilterKeyValue> kendoFilters = new List<KendoFilterKeyValue>();
            if (request.Filters != null && request.Filters.Count > 0)
            {                
                foreach (IFilterDescriptor filterDescriptor in request.Filters)
                {                   
                    kendoFilters = Recursive_kendoFilters(filterDescriptor);                    
                }
            }
            return kendoFilters;
        }

        static List<KendoFilterKeyValue> kendoFilters_temp = new List<KendoFilterKeyValue>();
        public static List<KendoFilterKeyValue> Recursive_kendoFilters(IFilterDescriptor filterDescriptor)
        {
            
            FilterDescriptor descriptor = null;
            CompositeFilterDescriptor compositeFilterDescriptor = null;
            if (filterDescriptor is CompositeFilterDescriptor)
            {
                compositeFilterDescriptor = (CompositeFilterDescriptor)filterDescriptor;
                foreach (IFilterDescriptor childFilter in compositeFilterDescriptor.FilterDescriptors)
                {
                    Recursive_kendoFilters(childFilter);
                }
            }
            else
            {
                descriptor = (FilterDescriptor)filterDescriptor;
                kendoFilters_temp.AddOrMerge(GetKeyValue(descriptor));
            }

            return kendoFilters_temp;
        }
        public static KendoFilterKeyValue GetKeyValue(FilterDescriptor descriptor)
        {
            KendoFilterKeyValue filterKeyValue = new KendoFilterKeyValue();
            switch (descriptor.Operator)
            {
                case FilterOperator.Contains:
                    filterKeyValue.KeyName = descriptor.Member;
                    filterKeyValue.KeyValue = descriptor.Value;
                    break;
                case FilterOperator.IsEqualTo:
                    filterKeyValue.KeyName = $"{descriptor.Member}_Values";
                    filterKeyValue.KeyValue = descriptor.Value;
                    break;
                case FilterOperator.IsGreaterThan:
                    filterKeyValue.KeyName = $"{descriptor.Member}_Min";
                    filterKeyValue.KeyValue = descriptor.Value;
                    break;
                case FilterOperator.IsLessThan:
                    filterKeyValue.KeyName = $"{descriptor.Member}_Max";
                    filterKeyValue.KeyValue = descriptor.Value;
                    break;
            }
            return filterKeyValue;
        }

        public static KendoFilterKeyValue AddOrMerge(this List<KendoFilterKeyValue> kendoFilters, KendoFilterKeyValue kendoFilterKeyValue)
        {
            KendoFilterKeyValue keyValue = kendoFilters.FirstOrDefault(x => x.KeyName == kendoFilterKeyValue.KeyName);
            if (keyValue == null) { kendoFilters.Add(kendoFilterKeyValue); }
            else
            {
                _index = kendoFilters.FindIndex(x => x.KeyName == kendoFilterKeyValue.KeyName);
                kendoFilters[_index].KeyValue = $"{kendoFilters[_index].KeyValue},{kendoFilterKeyValue.KeyValue}";
            }
            return kendoFilterKeyValue;
        }
    }

    /// <summary>
    /// Use for custome property 
    /// </summary>
    public class AlliantKendoDataSourceResult : DataSourceResult
    {
        public AlliantKendoDataSourceResult() { }
        public AlliantKendoDataSourceResult(DataSourceResult dataSourceResult)
        {
            this.AggregateResults = dataSourceResult.AggregateResults;
            this.Data = dataSourceResult.Data;
            this.Errors = dataSourceResult.Errors;
            this.Total = dataSourceResult.Total;
        }

        public int ResultSum { get; set; }
        public dynamic Dynamic { get; set; }
        public object OthersObjects { get; set; }
    }

    public class KendoFilterKeyValue
    {
        public string KeyName { get; set; }
        public object KeyValue { get; set; }
    }

    public class CustomDataSourceResult : DataSourceResult
    {
        private static readonly CustomDataSourceResult instance = new CustomDataSourceResult();
        static CustomDataSourceResult() { }

        private CustomDataSourceResult() { }

        public static CustomDataSourceResult Instance { get { return instance; } }
    }

    public class GridBinder
    {
        private int _Page { get; set; } = 1;

        private int _PageSize { get; set; } = 10;

        private int RecordCount { get; set; }

        public SortInfo SortInfo { get; set; } = new SortInfo() { Direction = SortDirection.Asc, Member = string.Empty };

        private readonly DataSourceRequest _gridRequest;

        public GridBinder(DataSourceRequest gridRequest)
        {
            _gridRequest = gridRequest;
            _Page = gridRequest.Page;
            _PageSize = gridRequest.PageSize;
            GetSortDescriptor();
        }

        private void GetSortDescriptor()
        {
            foreach (SortDescriptor descriptor in _gridRequest.Sorts)
            {
                SortInfo.Member = descriptor.Member;
                SortInfo.Direction = descriptor.SortDirection == ListSortDirection.Ascending ? SortDirection.Asc : SortDirection.Desc;
            }
        }

        public string GetFilterDescriptor()
        {
            StringBuilder filters = new StringBuilder();
            foreach (IFilterDescriptor filter in _gridRequest.Filters)
            {
                filters.Append(ApplyFilter(filter));
            }

            return filters.ToString();
        }

        private static string ApplyFilter(IFilterDescriptor filter)
        {
            var filters = "";
            if (filter is CompositeFilterDescriptor)
            {
                filters += "(";
                var compositeFilterDescriptor = (CompositeFilterDescriptor)filter;
                foreach (IFilterDescriptor childFilter in compositeFilterDescriptor.FilterDescriptors)
                {
                    filters += ApplyFilter(childFilter);
                    filters += " " + compositeFilterDescriptor.LogicalOperator.ToString() + " ";
                }
            }
            else
            {
                string filterDescriptor = "{0} {1} {2}";
                var descriptor = (FilterDescriptor)filter;

                switch (descriptor.Operator)
                {
                    case FilterOperator.IsLessThan:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "<", "'" + ReplaceValue(descriptor.Value) + "'");
                        break;
                    case FilterOperator.IsLessThanOrEqualTo:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "<=", "'" + ReplaceValue(descriptor.Value) + "'");
                        break;
                    case FilterOperator.IsEqualTo:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "=", "'" + ReplaceValue(descriptor.Value) + "'");
                        break;
                    case FilterOperator.IsNotEqualTo:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "<>", "'" + ReplaceValue(descriptor.Value) + "'");
                        break;
                    case FilterOperator.IsGreaterThanOrEqualTo:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, ">=", "'" + ReplaceValue(descriptor.Value) + "'");
                        break;
                    case FilterOperator.IsGreaterThan:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, ">", "'" + ReplaceValue(descriptor.Value) + "'");
                        break;
                    case FilterOperator.StartsWith:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "LIKE", "'" + ReplaceValue(descriptor.Value) + "%'");
                        break;
                    case FilterOperator.EndsWith:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "LIKE", "'%" + ReplaceValue(descriptor.Value) + "'");
                        break;
                    case FilterOperator.Contains:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "LIKE", "'%" + ReplaceValue(descriptor.Value) + "%'");
                        break;
                    case FilterOperator.IsContainedIn:
                        break;
                    case FilterOperator.DoesNotContain:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "NOT LIKE", "'%" + ReplaceValue(descriptor.Value) + "%'");
                        break;
                    case FilterOperator.IsNull:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "IS NULL", "");
                        break;
                    case FilterOperator.IsNotNull:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "IS NOT NULL", "");
                        break;
                    case FilterOperator.IsEmpty:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "IS NULL", "");
                        break;
                    case FilterOperator.IsNotEmpty:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "IS NOT NULL", "");
                        break;
                    case FilterOperator.IsNullOrEmpty:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "IS NULL", "");
                        break;
                    case FilterOperator.IsNotNullOrEmpty:
                        filterDescriptor = string.Format(filterDescriptor, descriptor.Member, "IS NOT NULL", "");
                        break;
                    default:
                        break;
                }

                filters = filterDescriptor;
            }

            filters = filters.EndsWith("And ") == true ? filters.Substring(0, filters.Length - 4) + ")" : filters;
            filters = filters.EndsWith("Or ") == true ? filters.Substring(0, filters.Length - 4) + ")" : filters;

            return filters;
        }

        private static string ReplaceValue(object pValue)
        {
            StringBuilder sb = new StringBuilder(Convert.ToString(pValue));
            sb.Replace("'", "''");

            return sb.ToString();
        }

        public virtual GridSearchModel GetGridSearchModel()
        {
            GridSearchModel gridSearchModel = new GridSearchModel();
            gridSearchModel.Page = _Page;
            gridSearchModel.PageSize = _PageSize;
            gridSearchModel.SortOrder = (SortInfo.Member.HasValue() ? string.Format("{0} {1}", SortInfo.Member, SortInfo.Direction) : "");
            gridSearchModel.Filter = GetFilterDescriptor();
            return gridSearchModel;
        }
    }
    public class SortInfo
    {
        public string Member { get; set; }
        public SortDirection Direction { get; set; }
    }

    public enum SortDirection
    {
        Asc, Desc
    }
}