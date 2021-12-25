using System.Web.Optimization;

namespace Alliant
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            #region All CSS File
            bundles.Add(new StyleBundle("~/bundles/cssAlliantKendo").Include("~/Content/AlliantKendo.css"));
            bundles.Add(new StyleBundle("~/bundles/cssAlliant").Include("~/Content/Alliant.css", new CssRewriteUrlTransform()));
            //bundles.Add(new StyleBundle("~/bundles/cssvendors").Include("~/Content/css/vendors.min.css",
            //    "~/Content/css/ui/jquery-ui.min.css",
            //    "~/Content/css/forms/icheck/icheck.css",
            //    "~/Content/css/forms/icheck/custom.css"));
            //bundles.Add(new StyleBundle("~/bundles/csstheme").Include("~/Content/css/bootstrap.css",
            //    "~/Content/css/bootstrap-extended.css",
            //    "~/Content/css/colors.css",
            //    "~/Content/css/components.css"));

            //bundles.Add(new StyleBundle("~/bundles/cssallpage").Include("~/Content/css/core/menu/menu-types/vertical-menu-modern.css",
            //    "~/Content/css/core/colors/palette-gradient.css"
            //    ));

            //bundles.Add(new StyleBundle("~/bundles/cssextension").Include(
            //    "~/Content/css/extensions/sweetalert2.min.css",
            //    "~/Content/css/plugins/loaders/loaders.min.css",
            //    "~/Content/css/forms/selects/select2.min.css",               
            //    "~/Content/css/plugins/ui/jqueryui.min.css",
            //    "~/Content/css/extensions/bootstrap-treeview.min.css",
            //    "~/Content/css/jstree/jstree.min.css"
            //));

            //bundles.Add(new StyleBundle("~/bundles/csscustomstyle").Include(
            //    "~/Content/css/style.css"
            //    ));
            #endregion

            #region ALL JS File
            bundles.Add(new ScriptBundle("~/bundles/jsAlliantKendo").Include("~/Scripts/AlliantKendo.min.js"));
            bundles.Add(new ScriptBundle("~/bundles/jsAlliant").Include("~/Scripts/Alliant.js"));
            //bundles.Add(new ScriptBundle("~/bundles/jsjquery")
            //    .Include("~/Scripts/jquery.min.js")
            //    );

            //bundles.Add(new ScriptBundle("~/bundles/jsvendors").Include(
            //    "~/Scripts/js/vendors.min.js"
            //    ));

            //bundles.Add(new ScriptBundle("~/bundles/jsjqueryui").Include("~/Scripts/jquery-ui.min.js"));

            //bundles.Add(new ScriptBundle("~/bundles/jstheme")
            //    .Include("~/Scripts/js/core/app-menu.js",
            //    "~/Scripts/js/core/app.js"
            //    ));

            //bundles.Add(new ScriptBundle("~/bundles/jsvalidation")
            //    .Include("~/Scripts/jquery.validate.min.js",
            //    "~/Scripts/jquery.validate.unobtrusive.min.js"
            //    ));

            //bundles.Add(new ScriptBundle("~/bundles/jsextension").Include(
            //    "~/Scripts/jquery.tmpl.min.js",
            //    "~/Scripts/js/extensions/sweetalert2.all.min.js",
            //    "~/Scripts/js/forms/select/select2.full.min.js",
            //    "~/Scripts/js/extensions/bootstrap-treeview.min.js",
            //    "~/Scripts/js/jstree/jstree.min.js"
            //    ));

            //bundles.Add(new ScriptBundle("~/bundles/jscomman").Include("~/Scripts/Comman.js"));


            #endregion

            #region ALL Kendo
            //bundles.Add(new ScriptBundle("~/Kendo/js").Include(
            //    "~/Kendo/js/kendo.all.min.js",
            //   "~/Kendo/js/kendo.aspnetmvc.min.js"
            //   ));

            //bundles.Add(new StyleBundle("~/Kendo/css").Include(
            //    "~/Kendo/styles/kendo.common.min.css",
            //    "~/Kendo/styles/kendo.default.min.css"));
            #endregion

            BundleTable.EnableOptimizations = false;
        }
    }
}
