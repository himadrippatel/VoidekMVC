using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.Linq;
using System.Reflection;

namespace Alliant.Utility
{
    public static class DataTableExtensions
    {
        public static List<dynamic> ToDynamic(this DataTable dt)
        {
            var dynamicDt = new List<dynamic>();
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    dynamic dyn = new ExpandoObject();
                    dynamicDt.Add(dyn);
                    foreach (DataColumn column in dt.Columns)
                    {
                        var dic = (IDictionary<string, object>)dyn;
                        dic[column.ColumnName] = row[column];
                    }
                }
            }
            else
            {
                dynamic dyn = new ExpandoObject();
                dynamicDt.Add(dyn);
                foreach (DataColumn column in dt.Columns)
                {
                    var dic = (IDictionary<string, object>)dyn;
                    dic[column.ColumnName] = null;
                }
            }
            return dynamicDt;
        }

        public static List<T> DataTableToList<T>(this DataTable dataTable) where T : new()
        {
            var dataList = new List<T>();

            //Define what attributes to be read from the class
            const System.Reflection.BindingFlags flags = System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance;

            //Read Attribute Names and Types
            var objFieldNames = typeof(T).GetProperties(flags).Cast<System.Reflection.PropertyInfo>().
                Select(item => new
                {
                    Name = item.Name,
                    Type = Nullable.GetUnderlyingType(item.PropertyType) ?? item.PropertyType
                }).ToList();

            //Read Datatable column names and types
            var dtlFieldNames = dataTable.Columns.Cast<DataColumn>().
                Select(item => new
                {
                    Name = item.ColumnName,
                    Type = item.DataType
                }).ToList();

            foreach (DataRow dataRow in dataTable.AsEnumerable().ToList())
            {
                var classObj = new T();

                foreach (var dtField in dtlFieldNames)
                {
                    System.Reflection.PropertyInfo propertyInfos = classObj.GetType().GetProperty(dtField.Name);

                    var field = objFieldNames.Find(x => x.Name == dtField.Name);

                    if (field != null)
                    {

                        if (propertyInfos.PropertyType == typeof(DateTime))
                        {
                            propertyInfos.SetValue
                            (classObj, convertToDateTime(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(Nullable<DateTime>))
                        {
                            propertyInfos.SetValue
                            (classObj, convertToDateTime(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(int))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToInt(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(long))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToLong(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(decimal))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToDecimal(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(bool))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToBoolean(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(Guid))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToGuid(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(String))
                        {
                            if (dataRow[dtField.Name].GetType() == typeof(DateTime))
                            {
                                propertyInfos.SetValue
                                (classObj, ConvertToDateString(dataRow[dtField.Name]), null);
                            }
                            else
                            {
                                propertyInfos.SetValue
                                (classObj, ConvertToString(dataRow[dtField.Name]), null);
                            }
                        }
                        else if (propertyInfos.PropertyType == typeof(Nullable<long>))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToLong(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(Nullable<bool>))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToBoolean(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(Nullable<int>))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToInt(dataRow[dtField.Name]), null);
                        }
                        else if (propertyInfos.PropertyType == typeof(Nullable<Guid>))
                        {
                            propertyInfos.SetValue
                            (classObj, ConvertToGuid(dataRow[dtField.Name]), null);
                        }
                        else
                        {
                            propertyInfos.SetValue(classObj, Convert.ChangeType(dataRow[dtField.Name] == DBNull.Value ? default(T) : (T)Convert.ChangeType(dataRow[dtField.Name],
                            Nullable.GetUnderlyingType(typeof(T)) ?? typeof(T)), propertyInfos.PropertyType), null);
                            //var oValue = DBNull.Value ? default(T) : (T)Convert.ChangeType(dataRow[dtField.Name], Nullable.GetUnderlyingType(typeof(T)) ?? typeof(T));
                            //propertyInfos.SetValue(classObj, GetValue<int?>(dataRow[dtField.Name]));
                        }
                    }
                }
                dataList.Add(classObj);
            }
            return dataList;
        }
        public static T? GetValue<T>(object value) where T : struct
        {
            if (value == null || value is DBNull) return null;
            if (value is T) return (T)value;
            return (T)Convert.ChangeType(value, typeof(T));
        }
        private static string ConvertToDateString(object date)
        {
            if (date == null)
                return string.Empty;

            return date == null ? string.Empty : Convert.ToDateTime(date).ConvertDate();
        }

        private static string ConvertToString(object value)
        {
            return Convert.ToString(ReturnEmptyIfNull(value));
        }

        private static int ConvertToInt(object value)
        {
            return Convert.ToInt32(ReturnZeroIfNull(value));
        }

        private static long ConvertToLong(object value)
        {
            return Convert.ToInt64(ReturnZeroIfNull(value));
        }

        private static decimal ConvertToDecimal(object value)
        {
            return Convert.ToDecimal(ReturnZeroIfNull(value));
        }

        private static DateTime convertToDateTime(object date)
        {
            return Convert.ToDateTime(ReturnDateTimeMinIfNull(date));
        }

        private static bool ConvertToBoolean(object pValue)
        {
            return Convert.ToBoolean(ReturnEmptyIfNull(pValue));
        }
        private static Guid ConvertToGuid(object pValue)
        {
            Guid guid;
            Guid.TryParse(ReturnEmptyIfNull(pValue).ToString(), out guid);
            return guid;
        }

        public static string ConvertDate(this DateTime datetTime, bool excludeHoursAndMinutes = false)
        {
            if (datetTime != DateTime.MinValue)
            {
                if (excludeHoursAndMinutes)
                    return datetTime.ToString("yyyy-MM-dd");
                return datetTime.ToString("yyyy-MM-dd HH:mm:ss.fff");
            }
            return null;
        }
        public static object ReturnEmptyIfNull(this object value)
        {
            if (value == DBNull.Value)
                return string.Empty;
            if (value == null)
                return string.Empty;
            return value;
        }
        public static object ReturnZeroIfNull(this object value)
        {
            if (value == DBNull.Value)
                return 0;
            if (value == null)
                return 0;
            return value;
        }
        public static object ReturnDateTimeMinIfNull(this object value)
        {
            if (value == DBNull.Value)
                return DateTime.MinValue;
            if (value == null)
                return DateTime.MinValue;
            return value;
        }

        private static readonly KeyValuePair<long, string>[] Thresholds =
        {
            // new KeyValuePair<long, string>(0, " Bytes"), // Don't devide by Zero!
            new KeyValuePair<long, string>(1, " Byte"),
            new KeyValuePair<long, string>(2, " Bytes"),
            new KeyValuePair<long, string>(1024, " KB"),
            new KeyValuePair<long, string>(1048576, " MB"), // Note: 1024 ^ 2 = 1026 (xor operator)
            new KeyValuePair<long, string>(1073741824, " GB"),
            new KeyValuePair<long, string>(1099511627776, " TB"),
            new KeyValuePair<long, string>(1125899906842620, " PB"),
            new KeyValuePair<long, string>(1152921504606850000, " EB"),

            // These don't fit into a int64
            // new KeyValuePair<long, string>(1180591620717410000000, " ZB"), 
            // new KeyValuePair<long, string>(1208925819614630000000000, " YB") 
        };

        /// <summary>
        /// Returns x Bytes, kB, Mb, etc... 
        /// </summary>
        public static string ToByteSize(this long value)
        {
            if (value == 0) return "0 Bytes"; // zero is plural
            for (int t = Thresholds.Length - 1; t > 0; t--)
                if (value >= Thresholds[t].Key) return ((double)value / Thresholds[t].Key).ToString("0.00") + Thresholds[t].Value;
            return "-" + ToByteSize(-value); // negative bytes (common case optimised to the end of this routine)
        }


        #region datatable extension 
        /// <summary> 
        /// Convert Data Table To List of Type T 
        /// </summary> 
        /// <typeparam name="T">Target Class to convert data table to List of T </typeparam> 
        /// <param name="datatable">Data Table you want to convert it</param> 
        /// <returns>List of Target Class</returns> 
        public static List<T> ToList<T>(this DataTable datatable) where T : new()
        {
            List<T> Temp = new List<T>();
            try
            {
                List<string> columnsNames = new List<string>();
                foreach (DataColumn DataColumn in datatable.Columns)
                    columnsNames.Add(DataColumn.ColumnName);
                Temp = datatable.AsEnumerable().ToList().ConvertAll<T>(row => getObject<T>(row, columnsNames));
                return Temp;
            }
            catch { return Temp; }
        }

        public static T getObject<T>(DataRow row, List<string> columnsName) where T : new()
        {
            T obj = new T();
            try
            {
                string columnname = "";
                string value = "";
                PropertyInfo[] Properties; Properties = typeof(T).GetProperties();
                foreach (PropertyInfo objProperty in Properties)
                {
                    columnname = columnsName.Find(name => name.ToLower() == objProperty.Name.ToLower());
                    if (!string.IsNullOrEmpty(columnname))
                    {
                        value = row[columnname].ToString();
                        if (!string.IsNullOrEmpty(value))
                        {
                            if (Nullable.GetUnderlyingType(objProperty.PropertyType) != null)
                            {
                                value = row[columnname].ToString().Replace("$", "").Replace(",", "");
                                objProperty.SetValue(obj, Convert.ChangeType(value, Type.GetType(Nullable.GetUnderlyingType(objProperty.PropertyType).ToString())), null);
                            }
                            else
                            {
                                value = row[columnname].ToString().Replace("%", "");
                                objProperty.SetValue(obj, Convert.ChangeType(value, Type.GetType(objProperty.PropertyType.ToString())), null);
                            }
                        }
                    }
                }
                return obj;
            }
            catch (Exception ex) { return obj; }
        }
        #endregion
    }
}
