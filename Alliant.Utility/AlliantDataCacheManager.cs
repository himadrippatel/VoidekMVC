using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;

namespace Alliant.Utility
{
    public class AlliantDataCacheManager : AlliantConfigurationSection
    {
        private static readonly AlliantDataCacheManager instance = new AlliantDataCacheManager();

        static AlliantDataCacheManager() { }

        private AlliantDataCacheManager() { }

        public static AlliantDataCacheManager Instance { get { return instance; } }

        private MemoryCache GetMemoryCache()
        {
            return MemoryCache.Default;
        }

        private bool IsEnableCache()
        {
            if (EnableCache == "1")
                return true;
            else
                return false;
        }

        public object GetValue(string key)
        {
            if (!IsEnableCache()) return null;
            MemoryCache memoryCache = GetMemoryCache();
            return memoryCache.Get(key);
        }

        public object GetValue(AlliantDataCacheKey key)
        {
            if (!IsEnableCache()) return null;
            MemoryCache memoryCache = GetMemoryCache();
            return memoryCache.Get(key.ToAlliantString());
        }

        public bool CheckKeyExists(AlliantDataCacheKey key)
        {
            if (!IsEnableCache()) return false;
            MemoryCache memoryCache = GetMemoryCache();
            return memoryCache.Contains(key.ToAlliantString());
        }

        public bool CheckKeyExists(string key)
        {
            if (!IsEnableCache()) return false;
            MemoryCache memoryCache = GetMemoryCache();
            return memoryCache.Contains(key);
        }

        public bool Add(string key, object value, DateTimeOffset absExpiration)
        {
            if (!IsEnableCache()) return false;
            MemoryCache memoryCache = GetMemoryCache();
            return memoryCache.Add(key, value, absExpiration);
        }

        public bool Add(AlliantDataCacheKey key, object value, DateTimeOffset absExpiration)
        {
            if (!IsEnableCache()) return false;
            MemoryCache memoryCache = GetMemoryCache();
            return memoryCache.Add(key.ToAlliantString(), value, absExpiration);
        }

        public void Delete(string key)
        {
            MemoryCache memoryCache = GetMemoryCache();
            if (memoryCache.Contains(key))
            {
                memoryCache.Remove(key);
            }
        }

        public void Delete(AlliantDataCacheKey key)
        {
            MemoryCache memoryCache = GetMemoryCache();
            if (memoryCache.Contains(key.ToAlliantString()))
            {
                memoryCache.Remove(key.ToAlliantString());
            }
        }

        public Dictionary<string, object> GetAllCache(int? UserID = null)
        {
            if (UserID == null)
                return GetMemoryCache().Select(x => new { x.Key, x.Value }).ToDictionary(x => x.Key, y => y.Value);
            else
                return GetMemoryCache().Where(x => x.Key.EndsWith($"_{UserID}")).Select(x => new { x.Key, x.Value }).ToDictionary(x => x.Key, y => y.Value);
        }

        public Dictionary<string, object> GetAlliantCache()
        {
            List<string> _cacheAlliantKey = ((AlliantDataCacheKey[])Enum.GetValues(typeof(AlliantDataCacheKey))).Select(c => c.ToString()).ToList();
            Dictionary<string, object> dtAlliantCache = GetMemoryCache()
                .Where(x => _cacheAlliantKey.Any(z => x.Key.StartsWith(z)))
                .Select(x => new { x.Key, x.Value }).ToDictionary(x => x.Key, y => y.Value);
            return dtAlliantCache;
        }

        public void ClearAlliantCache()
        {
            List<string> _cacheAlliantKey = ((AlliantDataCacheKey[])Enum.GetValues(typeof(AlliantDataCacheKey))).Select(c => c.ToString()).ToList();
            List<string> alliantCaches = GetMemoryCache().Where(x => _cacheAlliantKey.Any(z => x.Key.StartsWith(z)))
                .Select(x => x.Key).ToList();
            MemoryCache memoryCache = GetMemoryCache();
            foreach (string key in alliantCaches)
            {
                if (memoryCache.Contains(key.ToAlliantString()))
                {
                    memoryCache.Remove(key.ToAlliantString());
                }
            }
        }
    }

    public enum AlliantDataCacheKey
    {
        SessionStore = 0,
        AreaMenu = 1,
        LayoutActivities = 2,
        UserActivities = 3,
        UserSession = 4,
        Report_CrossRentalWorksheet = 5,
        FavoriteMenu = 6,
        Report_PurchaseOrder = 7,
        Report_EquipmentSearch = 8,
        Report_FullFillmentLaborEstimator = 9,
        Report_OrdersToPull = 10,
        Report_EquipmentDelivery = 11,
        Report_EquipmentReturns = 12,
        Report_BranchTransfer = 13,
        Report_QuoteDiscountAnalysis = 16,
        Report_AccountAnalysisData = 17,
        Report_DailyQuotes = 18,
        Report_PODelivery = 19,
        Report_FollowUpReminders = 20,
        Report_QuoteNeedingFollowUp = 21,
        Report_FutureBusinessFollowUp = 22,
        Report_ConfirmedQuoteFollow = 23,
        Report_CancelQuoteFollowUp = 24,
        Report_PotentialRepeatBusinessFollowUp = 25,
        Report_InActiveAccountFolloUp = 26,
        Report_POReturn = 27,
        Report_Invoice = 28,
        Report_CreditMemo = 29,
        Report_AccountsReceivableAging = 30,
        Report_DailyAccountingFunction = 31,
        Report_QuotesWithApplication = 32,
        Report_QuotesWithCreditCardAuthorization = 33,        Report_QuotesToApproveOrRelease = 34,        Report_QuotesToCharge = 35,        Report_InvoicesWithPrePayment = 36,        Report_InvoicesWithOpenCredit = 37,        Report_InvoicesWithCreditCardAuthorization = 38,        Report_InvoicesWithApplication = 39,        Report_InvoicesWithNoInformation = 40,
        Report_SalesCommission = 41,
        DropDown_Key = 1000
      
        

    }
}
