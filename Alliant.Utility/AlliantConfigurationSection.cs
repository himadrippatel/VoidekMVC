using System;
using System.Collections.Specialized;
using System.Configuration;

namespace Alliant.Utility
{
    public class AlliantConfigurationSection : ConfigurationSection
    {
        NameValueCollection appSettingsKeys = null;
        public AlliantConfigurationSection()
        {
            appSettingsKeys = ConfigurationManager.AppSettings;
        }

        public string UrlEncrypted
        {
            get { return Convert.ToString(appSettingsKeys["UrlEncrypted"]); }
            set { appSettingsKeys["UrlEncrypted"] = value; }
        }

        public string CustomizeView
        {
            get { return Convert.ToString(appSettingsKeys["CustomizeView"]); }
            set { appSettingsKeys["CustomizeView"] = value; }
        }

        public string EnableCache
        {
            get { return Convert.ToString(appSettingsKeys["EnableCache"]); }
            set { appSettingsKeys["EnableCache"] = value; }
        }
    }
}
