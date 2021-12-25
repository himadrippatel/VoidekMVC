using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;

namespace Alliant.Utility
{
    public static class Extensions
    {

        /// <summary>
        ///     Joins the list of values using specified delimeter.
        ///     ex : ObjectList.Select(o => o.PropertyName).JoinValues(",");
        /// </summary>
        public static string JoinValues(this IEnumerable<string> lstValues, string oDelimeter = ",", bool oOnlyDistinct = false) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => !string.IsNullOrEmpty(o)).Distinct() : lstValues.Where(o => !string.IsNullOrEmpty(o))).Trim(); }
        public static string JoinValues(this IEnumerable<float> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Distinct() : lstValues); }
        public static string JoinValues(this IEnumerable<float?> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => o != null).Distinct() : lstValues.Where(o => o != null)); }
        public static string JoinValues(this IEnumerable<short> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Distinct() : lstValues); }
        public static string JoinValues(this IEnumerable<short?> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => o != null).Distinct() : lstValues.Where(o => o != null)); }
        public static string JoinValues(this IEnumerable<bool> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Distinct() : lstValues); }
        public static string JoinValues(this IEnumerable<bool?> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => o != null).Distinct() : lstValues.Where(o => o != null)); }
        public static string JoinValues(this IEnumerable<int> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Distinct() : lstValues); }
        public static string JoinValues(this IEnumerable<int?> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => o != null).Distinct() : lstValues.Where(o => o != null)); }
        public static string JoinValues(this IEnumerable<char> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Distinct() : lstValues); }
        public static string JoinValues(this IEnumerable<char?> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => o != null).Distinct() : lstValues.Where(o => o != null)); }
        public static string JoinValues(this IEnumerable<decimal> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Distinct() : lstValues); }
        public static string JoinValues(this IEnumerable<decimal?> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => o != null).Distinct() : lstValues.Where(o => o != null)); }
        public static string JoinValues(this IEnumerable<Guid> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Distinct() : lstValues); }
        public static string JoinValues(this IEnumerable<Guid?> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => o != null).Distinct() : lstValues.Where(o => o != null)); }
        public static string JoinValues(this IEnumerable<DateTime> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Select(o => o.ToString().Replace(" 00:00:00.0000000", "").Replace(".0000000", "")).Distinct() : lstValues.Select(o => o.ToString().Replace(" 00:00:00.0000000", "").Replace(".0000000", ""))); }
        public static string JoinValues(this IEnumerable<DateTime?> lstValues, string oDelimeter = ",", bool oOnlyDistinct = true) { return string.Join(oDelimeter, (oOnlyDistinct) ? lstValues.Where(o => o != null).Select(o => o.ToString().Replace(" 00:00:00.0000000", "").Replace(".0000000", "")).Distinct() : lstValues.Where(o => o != null).Select(o => o.ToString().Replace(" 00:00:00.0000000", "").Replace(".0000000", ""))); }

        public static string RemoveHtmlFromString(this string pvalue)
        {
            string result = Regex.Replace(pvalue, @"<[^>]*>", String.Empty);
            return result;
        }

        public static Dictionary<string, string> EnumToDictionary<T>() where T : struct, IConvertible
        {
            var oResult = new Dictionary<string, string>();
            if (typeof(T).IsEnum)
                foreach (T oItem in Enum.GetValues(typeof(T)))
                    oResult.Add(oItem.ToString(), oItem.ToString());
            return oResult;
        }

        public static T ToEnum<T>(this string value)
        {
            return (T)Enum.Parse(typeof(T), value, true);
        }

        public static string ToAlliantString(this object pValue)
        {
            return Convert.ToString(pValue);
        }

        /// <summary>
        /// to string override avoid exception
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static string ToAlliantString(this int pValue)
        {
            return Convert.ToString(pValue);
        }

        public static bool EqualsIgnoreCase(this string pVale, string pCompare)
        {
            return string.Equals(pVale ?? "", pCompare ?? "", StringComparison.OrdinalIgnoreCase);
        }

        public static bool IsNullOrEmpty(this string pValue)
        {
            return string.IsNullOrEmpty(pValue);
        }

        public static void AddOrUpdate(this IDictionary pDictionary, object pKey, object pValue, bool pEmptyStringExclude = false)
        {
            if (pDictionary == null) return;
            if (pEmptyStringExclude == true && string.IsNullOrWhiteSpace(pValue.ToString())) return;
            if (pDictionary.Contains(pKey)) pDictionary[pKey] = pValue;
            else pDictionary.Add(pKey, pValue);
        }

        public static void AddOrMerge(this IDictionary pDictionary, object pKey, object pValue, bool pEmptyStringExclude = false)
        {
            if (pDictionary == null) return;
            if (pEmptyStringExclude == true && string.IsNullOrWhiteSpace(pValue.ToString())) return;
            if (pDictionary.Contains(pKey)) pDictionary[pKey] = $"{pDictionary[pKey]} {pValue}";
            else pDictionary.Add(pKey, pValue);
        }

        /// <summary>
        /// Return first letter word
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static string FirstCharToUpper(this string pValue)
        {
            return (IsNullOrEmpty(pValue) ? "" : $"{char.ToUpper(pValue[0])}{pValue.Substring(1)}");
        }

        /// <summary>
        /// return mm/dd/yyyy dateformat
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static string ToAlliantDate(this DateTime pValue)
        {
            return pValue.ToString("MM/dd/yyyy");
        }

        /// <summary>
        /// return mm/dd/yyyy dateformat and check date is null 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static string ToAlliantDate(this DateTime? pValue)
        {
            return (pValue!=null ? pValue.Value.ToString("MM/dd/yyyy") : "");
        }

        /// <summary>
        /// return "yyyy-MM-dd" dateformat for sql
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static string ToSqlDate(this DateTime pValue)
        {
            return pValue.ToString("yyyy-MM-dd");
        }

        /// <summary>
        /// Merge two model object into one object
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="target"></param>
        /// <param name="source"></param>
        /// <returns></returns>
        public static T MergeObject<T>(T target, T source)
        {
            Type t = typeof(T);

            var properties = t.GetProperties().Where(prop => prop.CanRead && prop.CanWrite);

            foreach (var prop in properties)
            {
                var value = prop.GetValue(source, null);
                if (value != null)
                    prop.SetValue(target, value, null);
            }

            return target;
        }

        public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
        {
            HashSet<TKey> tableSeenKeys = new HashSet<TKey>();
            foreach (TSource element in source)
            {
                if (!tableSeenKeys.Contains(keySelector(element)))
                {
                    tableSeenKeys.Add(keySelector(element));
                    yield return element;
                }
            }

            //System.Threading.Tasks.Parallel.ForEach(source, element =>
            //{
            //    if (!seenKeys.Contains(keySelector(element)))
            //    {
            //        seenKeys.Add(keySelector(element));
            //        yield return element;
            //    }
            //});
        }

        public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IList<TSource> source, Func<TSource, TKey> keySelector)
        {
            HashSet<TKey> tableSeenKeys = new HashSet<TKey>();
            foreach (TSource element in source)
            {
                if (!tableSeenKeys.Contains(keySelector(element)))
                {
                    tableSeenKeys.Add(keySelector(element));
                    yield return element;
                }
            }

            //System.Threading.Tasks.Parallel.ForEach(source, element =>
            //{
            //    if (!seenKeys.Contains(keySelector(element)))
            //    {
            //        seenKeys.Add(keySelector(element));
            //        yield return element;
            //    }
            //});
        }

        public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this List<TSource> source, Func<TSource, TKey> keySelector)
        {
            HashSet<TKey> tableSeenKeys = new HashSet<TKey>();
            foreach (TSource element in source)
            {
                if (!tableSeenKeys.Contains(keySelector(element)))
                {
                    tableSeenKeys.Add(keySelector(element));
                    yield return element;
                }
            }

            //System.Threading.Tasks.Parallel.ForEach(source, element =>
            //{
            //    if (!seenKeys.Contains(keySelector(element)))
            //    {
            //        seenKeys.Add(keySelector(element));
            //        yield return element;
            //    }
            //});
        }

        public static string ToBase64String(this string pValue)
        {
            byte[] buffer = Encoding.Unicode.GetBytes(pValue);
            return Convert.ToBase64String(buffer);
        }

        public static string ToBase64String(this object pValue)
        {
            byte[] buffer = Encoding.Unicode.GetBytes(Convert.ToString(pValue));
            return Convert.ToBase64String(buffer);
        }

        public static string Base64ToString(this string pValue)
        {
            byte[] buffer = Convert.FromBase64String(pValue);
            return Encoding.UTF8.GetString(buffer);
        }
    }

    public static class ObjectExtensions
    {
        //TODO: need some improvement here we need to map this MergeObject so we can avoid two call
        public static T ToObject<T>(this IDictionary<string, object> source)
            where T : class, new()
        {
            var pObject = new T();
            var pObjectType = pObject.GetType();
            Type typeInfo = null;
            foreach (var item in source)
            {
                typeInfo = item.Value.GetType();

                if (typeof(DateTime) == typeInfo && item.Key.EndsWith(UtilityConstant.Values))
                {
                    //pObjectType
                    //     .GetProperty(item.Key)
                    //     .SetValue(pObject, Convert.ToDateTime(item.Value).ToSqlDate(), null);
                    SetValue(pObject, item.Key, Convert.ToDateTime(item.Value).ToSqlDate());
                }
                //else if (typeof(double) == typeInfo && item.Key.EndsWith(UtilityConstant.Values))
                //{
                //    //pObjectType
                //    //     .GetProperty(item.Key)
                //    //     .SetValue(pObject, item.Value.ToAlliantString(), null);
                //    SetValue(pObject, item.Key, item.Value.ToAlliantString());
                //}
                else
                {
                    //pObjectType
                    //     .GetProperty(item.Key)
                    //     .SetValue(pObject, item.Value, null);
                    SetValue(pObject, item.Key, item.Value);
                }
            }

            return pObject;
        }

        //public static T ToObjects<T>(this IList<T> source)
        //   where T : class, new()
        //{
        //    var pObject = new T();
        //    var pObjectType = pObject.GetType();

        //    foreach (var item in source)
        //    {
        //        pObjectType
        //                 .GetProperty(item.Key)
        //                 .SetValue(pObject, item.Value, null);
        //    }

        //    return pObject;
        //}


        public static IDictionary<string, object> AsDictionary(this object source, BindingFlags bindingAttr = BindingFlags.DeclaredOnly | BindingFlags.Public | BindingFlags.Instance)
        {
            return source.GetType().GetProperties(bindingAttr).ToDictionary
            (
                propInfo => propInfo.Name,
                propInfo => propInfo.GetValue(source, null)
            );

        }

        public static void SetValue(object inputObject, string propertyName, object propertyVal)
        {
            //find out the type
            Type type = inputObject.GetType();

            //get the property information based on the type
            System.Reflection.PropertyInfo propertyInfo = type.GetProperty(propertyName);

            //find the property type
            Type propertyType = propertyInfo.PropertyType;

            //Convert.ChangeType does not handle conversion to nullable types
            //if the property type is nullable, we need to get the underlying type of the property
            var targetType = IsNullableType(propertyType) ? Nullable.GetUnderlyingType(propertyType) : propertyType;

            //Returns an System.Object with the specified System.Type and whose value is
            //equivalent to the specified object.
            propertyVal = Convert.ChangeType(propertyVal, targetType);

            //Set the value of the property
            propertyInfo.SetValue(inputObject, propertyVal, null);

        }
        private static bool IsNullableType(Type type)
        {
            return type.IsGenericType && type.GetGenericTypeDefinition().Equals(typeof(Nullable<>));
        }
    }
}
