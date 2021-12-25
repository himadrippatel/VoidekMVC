/*=========================================================================================
  File Name: Comman.js
  Description: This is common file for use alliant project
  ---------------------------------------------------------------------------------------- 
==========================================================================================*/
/*
 Global var for scope
 */
let currentLi;
let showCurrentLi;
let oTagID;
let oBoxContentID;
let searchText;
let currentTd;
let result = {};
let grid;
let gridDataSource;
let oHtml = [];
let oUrl;
let oThisdataText;
let kendoGrid;
let selectValue;
let filterKendo = [];
let AlliantJqueryEnum = {
    AlliantDateFormat: "MM/DD/YYYY"
};
// Create USD currency formatter.
let AlliantFormatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
});

let enumKendoOperator =
{
    2: "eq"
    , 3: "neq"
    , 11: "isnull"
    , 12: "isnotnull"
    , 0: "lt"
    , 1: "lte"
    , 5: "gt"
    , 4: "gte"
    , 6: "startswith"
    , 7: "endswith"
    , 8: "contains"
    , 10: "doesnotcontain"
    , 13: "isempty"
    , 14: "isnotempty"
};
let enumAlliantDateRanges = {
    1: "Today",
    2: "Yesterday",
    3: "Last 7 Days",
    4: "Last 30 Days",
    5: "This Month",
    6: "Last Month",
    7: "Next Month",
    8: "Next 4 Months",
    9: "Last Year",
    10: "This Year",
    11: "Next Year",
    12: "Next 3 Days",
    13: "Next 7 Days", 
    14: "Next 10 Days",
    15: "Next 30 Days",
    16: "Next 60 Days",
    17: "Next 90 Days"
};
let enumAlliantDateRangesValues = {
    'Today': [moment(), moment()],
    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
    'This Month': [moment().startOf('month'), moment().endOf('month')],
    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
    'Next Month': [moment().add(1, 'month').startOf('month'), moment().add(1, 'month').endOf('month')],
    'Next 4 Months': [moment().add(1, 'months').startOf('months'), moment().add(4, 'months').endOf('months')],
    'Last Year': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')],
    'This Year': [moment().startOf('year'), moment().endOf('year')],
    'Next Year': [moment().add(1, 'year').startOf('year'), moment().add(1, 'year').endOf('year')],
    'Next 3 Days': [moment().add(3, 'days'), moment()],
    'Next 7 Days': [moment().add(7, 'days'), moment()],
    'Next 10 Days': [moment().add(10, 'days'), moment()],
    'Next 30 Days': [moment().add(30, 'days'), moment()],
    'Next 60 Days': [moment().add(60, 'days'), moment()],
    'Next 90 Days': [moment().add(90, 'days'), moment()]

};
/*Comman search box in left menu start*/
jQuery.expr[":"].Contains = jQuery.expr.createPseudo(function (arg) {
    return function (elem) {
        return jQuery(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
    };
});

$("body").on("click", ".jsResetForm", function () {
    $(this).closest('form').trigger('reset');
    $.each($(this).closest('form').find("select[class*=jsSelectBox]"), function (index, elem) {
        $(elem).val(null).trigger('change');
    });
});

$(".jsAlliantQuickLink").click(function () {
    currentLi = $(this).closest("li");
    AlliantAjaxCall("POST", $("#jsSharedResourcesFavorite").val(),
        {
            LinkText: $(currentLi).text().trim(),
            LinkHref: $(currentLi).find("a").attr("href"),
            MenuID: $(currentLi).data("menuid"),
            SubMenuID: $(currentLi).data("childmenuid"),
            IsFavorite: true
        }, function (htmlResult) {
            openModel(htmlResult, "Favorite Menu");
        }, function (error) {
            openModelError("Favorite - Error", error.responseText, "modal-xl");
        });
    return false;
})

$('.jsSearchBox').keyup(function () {

    searchText = $.trim($(this).val());

    $('ul > li').each(function () {
        currentLi = $(this);
        showCurrentLi = $(currentLi).text().indexOf(searchText) !== -1;
        $(this).toggle(showCurrentLi);
    });
    $("#leftMenuLink:not(.notinclude)").removeHighlight().highlight(searchText);
});
/*End*/

$("body").on("dblclick", "td.jsEdtable", function () {
    if (!$(this).hasClass('jsHasEdtable')) {
        $(this).addClass("jsHasEdtable");
        currentTd = $(this);
        $(this).html("<input type='text' data-lastvalue='" + $(currentTd).text() + "' value='" + $(currentTd).text() + "' class='jsTextEdtable'>");
        $(".jsTextEdtable").focus();
    }
});
$("body").on("focusout", "td.jsEdtable input", function () {
    let elem = $(this);
    let pValue = $.trim($(this).val());
    if (pValue != "" && pValue != undefined && pValue != null && pValue != $(elem).attr('data-lastvalue')) {
        let currentTable = $(elem).closest("table");
        let currentTd = $(elem).closest("td");
        let currentTR = $(elem).closest("tr");
        let columnName = $(currentTd).attr('data-column');
        let columnPrimary = $(currentTR).attr('data-primaryid');
        let columnPrimaryValue = $(currentTR).attr('data-id');
        PreparedForm(columnName, pValue, columnPrimary, columnPrimaryValue);
        UpdateInlineGrid("POST", $(currentTable).attr("data-editurl"),
            $(".jsInlineForm").serialize()
            , function () {
                $(elem).closest("td").html(pValue);
                $(elem).closest("td").removeClass('jsHasEdtable');
                $('.jsInlineGridData').html('');
            });
    }
    else {
        $(elem).closest("td").removeClass('jsHasEdtable');
        $(elem).closest("td").html($(elem).attr('data-lastvalue'));
    }
});
/*Gloab print */
$("body").on("click", ".jsPrint", function () {
    var $this = $(this);
    var oHtmlPrintID = $this.attr("data-print");
    if (oHtmlPrintID != "" && oHtmlPrintID != undefined) {
        PrintHTML($("." + oHtmlPrintID).html());
    }
});
/*End Gloabl print*/


/* Collapas  start */
$("body").on("click", "[data-action='collapse']", function () {
    oTagID = $("[data-id='" + $(this).attr('data-id') + "']").find("a").find("i");
    if (oTagID.length == 0) {
        oTagID = "a[data-id='" + $(this).attr('data-id') + "'] > i";
    }
    oBoxContentID = $(this).closest("div.card").find("div.card-body");
    CustomCollapse(oTagID, oBoxContentID);
});
//$("body").on("click", "a[data-action='collapse']", function () {
//    var oTagID = "a[data-id='" + $(this).attr('data-id') + "'] > i";
//    var oBoxContentID = $(this).closest("div.card").find("div.card-body");
//    CustomCollapse(oTagID, oBoxContentID);
//});
/*End */

/* PDF File Dwonload start */
$("body").on("click", ".jsPdfFileDwonload", function () {
    var oCurrentIndex = $(".jsReportIndex").val();
    var oReportContent = $(".jsReportContent[data-index='" + oCurrentIndex + "']").html();
    //PrintPDF(oReportContent,null,null,null,null,null,null,null,null,true,"");
    PrintPDF(oReportContent);
});
/* PDF File Dwonload end */

/*start modal close event*/
$("body").on("hidden.bs.modal", ".jsModelError", function () {
    $(".jsModelShow").html('');
});
/*end modal close event */


/*********Global**********/
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
var EMPTY_Data = '###NULL###';
var BUTTON_MULTI_CLICK_INTERVAL = 1000;
var MINDATE = '1970-01-01';
var SKIP_DOCUMENT_EFFECTED_SCRIPT_ONCE = false;
var SKIP_DOCUMENT_EFFECTED_FORM_PARCING_ONCE = false;
var oIntervalFormReset = 0;
window.DocumentEffectFunctions = new Array();
window.DocumentEffectAfterFunctions = new Array();
/*End*/

/**
 * Get date ranges 
 * @param {any} alliantDateRanges
 */
function GetDateRanges(alliantDateRanges) {
    var dateRangeValues = {};
    if (alliantDateRanges != undefined && alliantDateRanges.length > 0) {
        for (var i = 0; i < alliantDateRanges.length; i++) {
            dateRangeValues[enumAlliantDateRanges[alliantDateRanges[i]]] = enumAlliantDateRangesValues[enumAlliantDateRanges[alliantDateRanges[i]]];
        }
        return dateRangeValues;
    }
    return undefined;
}

/**
 * Get formdata in key value pair
 * @param {any} formID
 */
function GetFormData(formID) {
    result = {};
    $.each($('#' + formID).serializeArray(), function () {
        result[this.name] = this.value;
    });
    return result;
}

/**
 * UpdateKendoGrid is an function. It is defined simply
 * update the grid data 
 * @gridName need to pass gridid
 * @data need to pass data
 */
function UpdateKendoGrid(gridName, data) {
    try {
        grid = $('#' + gridName).getKendoGrid();
        grid.dataSource.data(data);
        grid.refresh();
    } catch (e) {
        openModelError("KendoGrid Error", e.Message);
    }
}

/**
 * use this function in normal click handle like button,a
 * for this function prevent mutiple click
 * @param {any} elem
 * @param {any} enable
 */
function ClickableLoader(elem, enable) {
    if (enable) {
        if ($(elem).hasClass('disabled')) return false;
        $(elem).addClass('disabled');
        $("#jsloading").show();
    }
    else {
        $(elem).removeClass('disabled');
        $("#jsloading").hide();
    }
}

function UpdateInlineGrid(requestType, pUrl, data, pReturnFunction, pErrorFunction) {
    try {
        $.ajax({
            type: requestType,
            url: pUrl,
            data: data,
            success: function (data) {
                if (pReturnFunction != undefined) pReturnFunction(data);
            },
            error: function (error) {
                openModelError("", error.responseText, "modal-xl");
                if (pErrorFunction != undefined) pErrorFunction(error);
            }
        });
    } catch (e) {
        console.log("Error : UpdateInlineGrid :" + e.message);
    }
}
/**
 * Use for $.ajax to avoid code repeat in everywhere.
 * @param {any} requestType
 * @param {any} pUrl
 * @param {any} data
 * @param {any} pReturnFunction
 * @param {any} pErrorFunction
 */
function AlliantAjaxCall(requestType, pUrl, data, pReturnFunction, pErrorFunction) {
    try {
        $.ajax({
            type: requestType,
            url: pUrl,
            data: data,
            success: function (data) {
                if (pReturnFunction != undefined) pReturnFunction(data);
                OnDocumentEffected();
            },
            error: function (error) {
                openModelError("", error.responseText, "modal-xl");
                if (pErrorFunction != undefined) pErrorFunction(error);
                OnDocumentEffected();
            }
        });
    }
    catch (e) {
        console.log("Error : AlliantAjaxCall :" + e.message);
    }
}
function PreparedForm(columnName, columnValue, columnPrimary, columnPrimaryValue) {
    try {
        oHtml = [];
        oHtml.push("<form class='jsInlineForm'>");
        oHtml.push("<input type='hidden' name='" + columnName + "' value='" + columnValue + "'/>");
        oHtml.push("<input type='hidden' name='" + columnPrimary + "' value='" + columnPrimaryValue + "'/>");
        oHtml.push("</form>");
        $(".jsInlineGridData").html(oHtml.join(" "));
    }
    catch (e) {

    }
}

// Collapse Animations
$('.collapseAnimation').each(function () {
    $(this).on("click", function () {
        var data = $(this).attr('data-animation'),
            href = $(this).attr('href');
        $(href).addClass('animated ' + data);
    });
});

function CustomCollapse(FABtnID, BoxBody) {
    $(BoxBody).slideToggle("medium");
    $(FABtnID).toggleClass('ft-minus ft-plus')
}
function addQuotes(value) {
    var quotedVar = "\'" + value + "\'";
    return quotedVar;
}
function IsInvalidClick(oCurrentElem) {
    if ($(oCurrentElem).is("button,:submit,:button,a")) {
        if ($(oCurrentElem).data("lastClickedTime") != undefined)
            if (Math.abs(new Date() - $(oCurrentElem).data("lastClickedTime")) < BUTTON_MULTI_CLICK_INTERVAL)
                return true;
        $(oCurrentElem).data("lastClickedTime", new Date());
    }
    return false;
}
function EnableDisableElement(oCurrentElem, pEnable, oTextHtml) {
    if ($(oCurrentElem).is("button,a")) {
        if (pEnable) {
            $(oCurrentElem).html(oTextHtml);
            $(oCurrentElem).removeClass("disabled").removeAttr("disabled");
        }
        else {
            $(oCurrentElem).html(oTextHtml + "&nbsp;<i class=\"fa fa-spinner fa-spin\"></i>");
            $(oCurrentElem).addClass("disabled").attr("disabled", "disabled");
        }
    }
    else if ($(oCurrentElem).is("button,:submit,:button,a")) {
        if (pEnable) { $(oCurrentElem).removeClass("disabled").removeAttr("disabled"); }
        else { $(oCurrentElem).addClass("disabled").attr("disabled", "disabled"); }
    }
}

/**
 * Avoid to full reload the page use to partial load page & add menu in recent use
 * @param {any} oAnchor
 * @param {any} pReturnFunction
 * @param {any} pErrorFunction
 */
function ajaxAnchorClickRecent(oAnchor, pReturnFunction, pErrorFunction) {
    if ($(oAnchor).hasClass("disabled")) return false;

    AlliantAjaxCall("POST", $("#jsSharedResourcesRecentMenu").val(), {
        LinkText: $(oAnchor).text().trim(),
        LinkHref: $(oAnchor).attr("href"),
        MenuID: $(oAnchor).closest("li").data("menuid"),
        SubMenuID: $(oAnchor).closest("li").data("childmenuid"),
        IsFavorite: false
    });

    return ajaxAnchorClick(oAnchor, pReturnFunction, pErrorFunction);
}

/**
 * Avoid to full reload the page use to partial load page
 * @param {any} oAnchor
 * @param {any} pReturnFunction
 * @param {any} pErrorFunction
 */
function ajaxAnchorClick(oAnchor, pReturnFunction, pErrorFunction) {
    if ($(oAnchor).hasClass("disabled")) return false;

    $(oAnchor).addClass("disabled");
    oThisdataText = $(oAnchor).html();
    $(".jsAlliant-menu-content li").removeClass('active');
    $(oAnchor).parent("li").addClass('active');
    $(oAnchor).html("<i class='la la-spinner spinner'></i>&nbsp;" + oThisdataText);
    if ($("#ForMessage").hasClass("setMessage")) {
        $("#ForMessage").removeClass("setMessage");
        $("#ForMessage").html('');
    }
    try {
        oUrl = $(oAnchor).attr("href");
        $("title").html($(oAnchor).text());

        $("#jsAjaxContent").data("currenturl", oUrl);
        $("#jsAjaxContent").data("currentload", $(oAnchor).data("ajaxdivid"));

        $("#" + $(oAnchor).data("ajaxdivid")).load(oUrl, function (responseTxt, statusTxt, xhr) {
            if (statusTxt == "error") {
                if (xhr.status == 401) {
                    responseTxt = JSON.parse(responseTxt);
                    openModelError("Unauthorized", responseTxt.Message, "modal-lg");
                }
                else {
                    if (responseTxt.length > 2000)
                        openModelError("Error", responseTxt, "modal-xl");
                    else
                        openModelError("Error", responseTxt, "modal-lg");
                }
            }
            if (pReturnFunction != undefined)
                pReturnFunction(responseTxt);
            if (pErrorFunction != undefined)
                pErrorFunction(statusTxt);
            $(oAnchor).removeClass("disabled");
            $(oAnchor).html(oThisdataText);
            window.history.pushState("", "Title", oUrl);
            OnDocumentEffected();
        });
    }
    catch (e) {
        $(oAnchor).removeClass("disabled");
        $(oAnchor).html(oThisdataText);
    }
    return false;
}

/**
 * confirm on delete popup
 * @param {any} oAnchor
 * @param {any} pReturnFunction
 * @param {any} pErrorFunction
 */
function ajaxSweetAlert(oAnchor, pReturnFunction, pErrorFunction) {
    try {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: 'Cancel <i class="la la-times"></i>',
            confirmButtonText: 'Yes delete! <i class="ft-save position-right"></i>',
            confirmButtonClass: 'btn btn-primary',
            cancelButtonClass: 'btn btn-danger ml-1',
            buttonsStyling: false,
        }).then(function (result) {
            if (result.value) {
                oUrl = $(oAnchor).attr("href");

                kendoGrid = $(oAnchor).closest("div[data-role='grid']");

                let data = oUrl.split('/');

                let recordID = data[data.length - 1];

                AlliantAjaxCall("POST", oUrl, { Id: recordID },
                    function (response) {
                        if (response.Success) {
                            Swal.fire({
                                type: "success",
                                title: 'Deleted!',
                                text: response.Message,
                                confirmButtonClass: 'btn btn-success',
                            });

                            if (kendoGrid && kendoGrid != undefined && kendoGrid.length > 0) $('#' + $(kendoGrid).attr('id')).data('kendoGrid').dataSource.read();
                            setTimeout(function () {
                                $(".swal2-confirm").trigger('click');
                            }, 1000)
                        }
                        else {
                            Swal.fire({
                                title: 'Cancelled',
                                text: response.Message,
                                type: 'error',
                                confirmButtonClass: 'btn btn-success',
                            })
                        }
                        if (pReturnFunction != undefined) pReturnFunction(response);
                    },
                    function (error) {
                        if (pErrorFunction != undefined) pErrorFunction(error);
                    }
                )
            }
        });
    }
    catch (e) {
        console.log("Error: ajaxDelete " + e.message);
    }
    return false;
}

function ConvertToDatatable(TableId) {
    $(TableId).DataTable();
}

/**
 * Display swal message for user
 * @param {any} text
 * @param {any} title
 * @param {any} type
 */
function SwalMessage(text, title, type) {
    Swal.fire({
        type: type,
        title: title,
        text: text,
        confirmButtonClass: 'btn btn-success',
    });
}
function openModel(oBody, oTitle, oWidth) {
    var oSizeClass = "modal-dialog";
    if (oWidth != undefined && oWidth != null && oWidth > 400) oSizeClass += " modal-lg";
    if (oWidth != undefined && oWidth != null && oWidth < 200) oSizeClass += " modal-sm";
    oHtml = [];
    try {
        oHtml.push(" <div class=\"modal fade\" id=\"modal-alliant\">");
        oHtml.push("     <div class=\"" + oSizeClass + "\">");
        oHtml.push("         <div class=\"modal-content\">");
        oHtml.push("             <div class=\"modal-header\">");
        oHtml.push("                 <h4 class=\"modal-title\">" + (oTitle == "" ? "ERP" : oTitle) + "</h4>");
        oHtml.push("                 <button type=\"button\" class=\"close modalalliantclose\" data-dismiss=\"modal\" aria-label=\"Close\">");
        oHtml.push("                     <span aria-hidden=\"true\">&times;</span>");
        oHtml.push("                 </button>");
        oHtml.push("             </div>");
        oHtml.push("             <div class=\"modal-body jsalliant-model-body\">");
        oHtml.push("                 <p>" + (oBody == "" ? "" : oBody) + "</p>");
        oHtml.push("             </div>");
        oHtml.push("             <div class=\"modal-footer\">");
        oHtml.push("                 <button type=\"button\" class=\"btn btn-default pull-left\" data-dismiss=\"modal\">Close</button>");
        oHtml.push("             </div>");
        oHtml.push("         </div>");
        oHtml.push("     </div>");
        oHtml.push(" </div >");
        $(oHtml.join(" ")).modal("show");
    } catch (e) {
        console.log(e);
    }
}
function openModelError(oTitle, oBody, oModelSize) {
    if (oModelSize == undefined) oModelSize = "";
    oHtml = [];
    try {
        $(".jsModelShow").html("");
        oHtml.push(" <div class=\"modal fade jsModelError\" id=\"modal-error\">");
        oHtml.push("     <div class=\"modal-dialog " + oModelSize + "\">");
        oHtml.push("         <div class=\"modal-content\">");
        oHtml.push("             <div class=\"modal-header\">");
        oHtml.push("                 <h4 class=\"modal-title\">" + (oTitle == "" ? "Error" : oTitle) + "</h4>");
        oHtml.push("                 <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\">");
        oHtml.push("                     <span aria-hidden=\"true\">&times;</span>");
        oHtml.push("                 </button>");
        oHtml.push("             </div>");
        oHtml.push("             <div class=\"modal-body\" style=\"overflow:auto;\">");
        oHtml.push("                 <p>" + (oBody == "" ? "Something went wrong please contect to admin." : oBody) + "</p>");
        oHtml.push("             </div>");
        oHtml.push("             <div class=\"modal-footer\">");
        oHtml.push("                 <button type=\"button\" class=\"btn btn-default pull-left\" data-dismiss=\"modal\">Close</button>");
        oHtml.push("             </div>");
        oHtml.push("         </div>");
        oHtml.push("     </div>");
        oHtml.push(" </div >");
        $(".jsModelShow").html(oHtml.join(" "));
        $(".jsModelError").modal("show");
    } catch (e) {
        console.log(e);
    }
}
function DropDownData(e, actionURL, targetControlID, fixedValue, pReturnFunction, pCallEvenIfNull) {
    $("body").css("cursor", "progress");
    if ($("#ForMessage").hasClass("setMessage")) {
        $("#ForMessage").removeClass("setMessage");
        $("#ForMessage").addClass("removeMessage");
    }
    if (pCallEvenIfNull == undefined || pCallEvenIfNull == null) { pCallEvenIfNull = false; }
    if (!pCallEvenIfNull && ($(e).val() == undefined || $(e).val() == "")) {
        CreateDropdownOptions("", targetControlID, e, pReturnFunction);
        $("body").css("cursor", "auto");
        return false;
    }
    $.ajax({
        url: actionURL,
        type: "get",
        data: { ID: $(e).val(), fixedValues: fixedValue },
        success: function (argData) {
            CreateDropdownOptions(argData, targetControlID, e, pReturnFunction);
            $("body").css("cursor", "auto");
        },
        error: function (oerror) {
            console.log("Create Dropdown " + oerror);
            $("body").css("cursor", "auto");
        }
    });
}
function CreateDropdownOptions(data, targetControlID, pObj, pReturnFunction) {
    try {
        var oTargetControl = $($(pObj).parents('form:first')).find("#" + targetControlID + ":first"); // $("#" + targetControlID);
        var oFirstElement = $($(pObj).parents('form:first')).find("#" + targetControlID + " option:first"); //$("#" + targetControlID + " option:first");
        var oAddFirstElement = false;
        if (oFirstElement.length > 0)
            if (oFirstElement.val() == "") {
                oAddFirstElement = true;
            }
        if (oAddFirstElement) oTargetControl.html(oFirstElement);
        else oTargetControl.html("");
        if (data != undefined && data != "")
            oTargetControl.append($.tmpl("<option value=${Value}>${Text}</option>", data));
        if ($(pObj).attr("id") != targetControlID)
            oTargetControl.trigger("onchange");
        if (pReturnFunction != undefined) pReturnFunction(data, pObj, targetControlID);

    }
    catch (ex) {
        console.log("Create DropDown Error " + ex.message);
    }
}
function PrintHTML(htmlToPrint) {
    try {
        var oTitle = "";
        var myWindow = window.open('', '', 'width=600,height=600');
        if (!myWindow) { alert('A popup blocker was detected. Please turn it off to use this application.'); }

        var IsUseHead = $('.jsHead:first') != undefined && $('.jsHead:first') != null && $('.jsHead:first').length == 1 && $('.jsHead:first').val() == "1";

        if (IsUseHead)
            myWindow.document.write("<!DOCTYPE html><html><head>" + (oTitle == "" ? "" : "<title>" + oTitle + "</title>") + $('head').html() + "</head><body><div style='text-align:center;clear:both;padding:5px;' onclick='window.location.reload();this.parentNode.removeChild(this);window.focus();window.print();window.close();'><button style='background:green;color:white'>Print</button></div><div>" + htmlToPrint + "</div></body></html>");
        else
            myWindow.document.write("<!DOCTYPE html><html><head><meta name='viewport' charset='utf-8' content='width=device-width, initial-scale=1.0'>" + (oTitle == "" ? "" : "<title>" + oTitle + "</title>") + "<link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic' rel='stylesheet' /></head><body><div style='text-align:center;clear:both;padding:5px;' onclick='window.location.reload();this.parentNode.removeChild(this);window.focus();window.print();window.close();'><button style='background:green;color:white'>Print</button></div><div>" + htmlToPrint + "</div></body></html>");

    } catch (eds) { console.log(eds); }
}
function ParseDate(str) {
    if (str.indexOf(" ") > -1) { str = str.split(" ")[0]; }
    var m = str.match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/);
    return (m) ? new Date(m[1], m[2] - 1, m[3]) : null;
}
function OnDocumentEffected() {
    for (var i = 0; i < window.DocumentEffectFunctions.length; i++) {
        if (typeof (window.DocumentEffectFunctions[i]) == 'function') {
            window.DocumentEffectFunctions[i]();
        }
    }

    $(".jsTimePicker").each(function (index) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).data("isProcessed", "1").attr("isProcessed", "1").timepicker({
                minutes: {
                    interval: 1
                },
                showInputs: false
            });
        }
    });

    $(".jsDatePicker").each(function (index) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).val($(this).val().toString().replace(/ 00:00:00.0000000/g, ''));
            var jsDatePickerFormat = $(this).data("jsdatepickerformat");

            var jdpMin = null;
            var jdpMax = null;
            if ($(this).data("valDaterangeMin") == null || $(this).data("valDaterangeMin") == undefined) {
                jdpMin = null;
                $(this).removeData("valDaterangeMin");
                $(this).removeAttr("data-val-daterange-min");
            } else {
                jdpMin = ParseDate($(this).data("valDaterangeMin"));
                $(this).data("valDaterangeMin", jdpMin.getFullYear() + "-" + (jdpMin.getMonth() + 1) + "-" + jdpMin.getDate());
                $(this).attr("data-val-daterange-min", jdpMin.getFullYear() + "-" + (jdpMin.getMonth() + 1) + "-" + jdpMin.getDate());
            }
            if ($(this).data("valDaterangeMax") == null || $(this).data("valDaterangeMax") == undefined) {
                jdpMax = null;
                $(this).removeData("valDaterangeMax");
                $(this).removeAttr("data-val-daterange-max");
            } else {
                jdpMax = ParseDate($(this).data("valDaterangeMax"));
                $(this).data("valDaterangeMax", jdpMax.getFullYear() + "-" + (jdpMax.getMonth() + 1) + "-" + jdpMax.getDate());
                $(this).attr("data-val-daterange-max", $(this).data("valDaterangeMax"));
            }

            $(this).attr("autocomplete", "off");

            $(this).data("isProcessed", "1").attr("isProcessed", "1").datepicker({
                dateFormat: (jsDatePickerFormat != undefined && jsDatePickerFormat != null) ? jsDatePickerFormat : 'mm/dd/yy',
                minDate: jdpMin,
                maxDate: jdpMax,
                autoclose: true,
                changeMonth: true,
                changeYear: true,
                altField: $(this).attr("data-altfield"),
                yearRange: ($(this).data("jsdatepickerYearrange") == undefined ? "-200:+50" : $(this).data("jsdatepickerYearrange"))
            });
        }
    });

    $(".jsOnlyDecimalCheck").each(function (index) {
        if ($(this).data("isProcessed") != "1") {
            $(this).data("isProcessed", "1").keydown(function (event) {
                var key = event.charCode || event.keyCode || 0;
                // Allow: backspace, delete, tab, escape, and enter
                if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
                    // Allow: Ctrl+A
                    (event.keyCode == 65 && event.ctrlKey === true) ||
                    // Allow: Ctrl+C
                    (event.keyCode == 67 && event.ctrlKey === true) ||
                    // Allow: Ctrl+V
                    (event.keyCode == 86 && event.ctrlKey === true) ||
                    // Allow: home, end, left, right
                    (event.keyCode >= 35 && event.keyCode <= 39)) {
                    // let it happen, don't do anything
                    return;
                } else if (key == 110 || key == 190 || (key >= 35 && key <= 40) || (key >= 48 && key <= 57) || (key >= 96 && key <= 105)) {
                    return;
                }
                else {
                    // Ensure that it is a number and stop the keypress
                    if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                        event.preventDefault();
                    }
                }
            }).blur(function (event) {
                if ($(this).val().toString().length < 15 && $(this).val().toString().length > 0) {
                    $(this).val(parseFloat($(this).val()));
                }
            });
        }
    });


    $(".jsTextCharCount").keyup(function () {
        if ($(this).attr("TargetTextCharCount") != undefined && $(this).attr("TargetTextCharCount") != "") {
            $("#" + $(this).attr("TargetTextCharCount")).html($(this).val().length);
        }
    });


    if (SKIP_DOCUMENT_EFFECTED_FORM_PARCING_ONCE) {
        SKIP_DOCUMENT_EFFECTED_FORM_PARCING_ONCE = false;
    } else {
        $('form').removeData("validator");
        $('form').removeData("unobtrusiveValidation");

        //$.validator.unobtrusive.parse('form');

        $("form").bind("reset", function () {
            if (oIntervalFormReset == 0) {
                /*Add login some*/
            }
        });
    }

    $(".jsSelectBox").each(function (index, element) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).data("isProcessed", "1");
            $(this).attr("isProcessed", "1");
            $(this).select2({
                dropdownAutoWidth: true,
                width: '100%',
                allowClear: ($(element).data('allowclear') == "True" ? true : false),
                closeOnSelect: ($(element).data('iscloseonselect') == "True" ? true : false),
                placeholder: ($(element).data('placeholder') != undefined ? $(element).data('placeholder') : "Type to search")
            });
            if ($(element).data("value")) {
                selectValue = $(element).data("value") + '';
                $(element).val(selectValue.split(',')).trigger('change');
            }
        }
    });

    $(".jsCurrentSortable").each(function (index, oRootElem) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).attr("isProcessed", "1")
            $(this).data("isProcessed", "1").sortable({
                connectWith: ".jsNextSortable",
                stop: function (e, ui) {
                    var children = $(this).sortable('refreshPositions').children();
                    $.each(children, function (oIndex) {
                        $(this).find("input.jsCurrentSequence.HasSequence").val(oIndex);
                    });
                }
            });
            $(".jsNextSortable").sortable({
                connectWith: oRootElem,
                dropOnEmpty: false
            });
        }
    });

    $(".jsSortable").each(function (index, oRootElem) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).data("isProcessed", "1");
            $(this).attr("isProcessed", "1");
            $(this).sortable();
            $(this).disableSelection();
        }
    });

    $(".jsSortable").each(function (index, oRootElem) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).data("isProcessed", "1");
            $(this).attr("isProcessed", "1");
            $(this).sortable();
            $(this).disableSelection();
        }
    });

    $(".jsDataTable").each(function (index, oRootElem) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).data("isProcessed", "1");
            $(this).attr("isProcessed", "1");
            $(this).DataTable();
        }
    });

    $(".jsDataGrid").each(function (index) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).data("isProcessed", "1");
            $(this).attr("isProcessed", "1");
            GridLoad(this);
        }
    });

    $(".jsMultiAutoComplete").each(function (index, element) {
        if ($(element).data("isProcessed") != "1" && $(element).attr("isProcessed") != 1) {
            $(element).data("isProcessed", "1");
            $(element).attr("isProcessed", "1");
            $(element)
                .on("keydown", function (event) {
                    if (event.keyCode === $.ui.keyCode.TAB &&
                        $(this).autocomplete("instance").menu.active) {
                        event.preventDefault();
                    }
                })
                .autocomplete({
                    source: function (request, response) {
                        $.getJSON($(element).data('url'),
                            {
                                term: extractLast_r(request.term),
                                notIn: element.value
                            }, response);
                    },
                    search: function () {
                        var term = extractLast_r(this.value);
                        if (term.length < ($(element).data('mincharacter') != undefined ? $(element).data('mincharacter') : 3))
                            return false;

                    },
                    focus: function () {
                        return false;
                    },
                    select: function (event, ui) {
                        var terms = split_r(this.value);
                        terms.pop();
                        terms.push(ui.item.value);
                        terms.push("");
                        this.value = terms.join(", ");
                        return false;
                    }
                });
        }
    });

    $(".jsAutoComplete").each(function (index, element) {
        if ($(element).data("isProcessed") != "1" && $(element).attr("isProcessed") != 1) {
            $(element).data("isProcessed", "1");
            $(element).attr("isProcessed", "1");
            var cache = {};
            $(element).autocomplete({
                minLength: ($(element).data('minlength') != undefined ? $(element).data('minlength') : 3),
                source: function (request, response) {
                    if ($(element).data("iscache") == "True") {
                        var term = request.term;
                        if (term in cache) {
                            response(cache[term]);
                            return;
                        }
                        $.getJSON($(element).data("url"), request,
                            function (data, status, xhr) {
                                cache[term] = data;
                                response(data);
                            });
                    }
                    else {
                        $.getJSON($(element).data("url"), request,
                            function (data, status, xhr) {
                                response(data);
                            });
                    }
                },
                select: function (event, ui) {

                    switch ($(element).data('select')) {
                        case "id":
                            $("#" + $(element).data('target')).val(ui.item.id);
                            break;
                        case "label":
                            $("#" + $(element).data('target')).val(ui.item.label);
                            break;
                        case "value":
                            $("#" + $(element).data('target')).val(ui.item.value);
                            break;
                        default:
                            break;
                    }

                    $("#" + $(element).data('target')).attr('model', JSON.stringify(ui.item));
                    $(element).val(ui.item.value);
                    return false;
                }
            });
        }
    });

    $(".jsRemoteSelectBox").each(function (index, element) {
        if ($(element).data("isProcessed") != "1" && $(element).attr("isProcessed") != 1) {
            $(element).data("isProcessed", "1");
            $(element).attr("isProcessed", "1");
            var oOptionHtml = [];
            var oTargetControl = $(element).data('targetcontrol');
            $(element).select2({
                dropdownAutoWidth: true,
                allowClear: ($(element).data('allowclear') == "True" ? true : false),
                closeOnSelect: ($(element).data('iscloseonselect') == "True" ? true : false),
                width: '100%',
                placeholder: ($(element).data('placeholder') != undefined ? $(element).data('placeholder') : "Type to search"),
                ajax:
                {
                    url: $(element).data('url'),
                    type: "POST",
                    dataType: 'json',
                    data: function (params) {
                        return {
                            search: params.term,
                            pageResult: ($(element).data('pageresult') != undefined ? $(element).data('pageresult') : 10),
                            page: params.page,
                            notIn: (oTargetControl != undefined ? ($.isArray($("#" + oTargetControl).val()) ? $("#" + oTargetControl).val().join(",") : $("#" + oTargetControl).val()) : ($(element).data('fixedvalue') != undefined ? $(element).data('fixedvalue') : ""))
                        };
                    },
                    processResults: function (data, params) {
                        params.page = params.page || 1;

                        return {
                            results: data.items,
                            pagination: {
                                more: (params.page * ($(element).data('pageresult') != undefined ? $(element).data('pageresult') : 10)) < data.total_count
                            }
                        };
                    },
                    cache: true
                },
                escapeMarkup: function (markup) { return markup; },
                minimumInputLength: ($(element).data('minlength') != undefined ? $(element).data('minlength') : 3),
                //templateResult: formatResult,
                templateResult: function (optionResult) {
                    if (optionResult.loading) return optionResult.text;
                    oOptionHtml = [];
                    oOptionHtml.push("<div class='select2-result-repository clearfix'>");
                    if ($(element).data("isimagedisplay") == "True") {
                        oOptionHtml.push("<div class='select2-result-repository__avatar'>");
                        oOptionHtml.push("<img src='" + optionResult.imageurl + "' />");
                        oOptionHtml.push("</div>");
                    }
                    oOptionHtml.push("<div class='select2-result-repository__meta'>");
                    oOptionHtml.push("<div class='select2-result-repository__title'>");
                    oOptionHtml.push(optionResult.full_name);
                    oOptionHtml.push("</div>");
                    oOptionHtml.push("</div>");
                    if ($(element).data("isdescriptiondisplay") == "True") {
                        oOptionHtml.push("<div class='select2-result-repository__description'>");
                        oOptionHtml.push(optionResult.description);
                        oOptionHtml.push("</div>");
                    }
                    oOptionHtml.push("</div>");

                    return oOptionHtml.join(" ");
                },
                templateSelection: formatResultSelection
            });
        }
    });

    $(".jsTree").each(function (index, element) {
        if ($(element).data("isProcessed") != "1" && $(element).attr("isProcessed") != 1) {
            $(element).data("isProcessed", "1");
            $(element).attr("isProcessed", "1");
            $(this).jstree({
                core:
                {
                    check_callback: true
                },
                checkbox:
                {
                    keep_selected_style: true,
                    three_state: ($(element).data("three-state") == "false" ? false : true)
                },
                search:
                {
                    case_insensitive: true,
                    show_only_matches: true
                },
                plugins: ["checkbox", "search"]
            }).on('search.jstree', function (nodes, str, res) {
                if (str.nodes.length === 0) {
                    $(element).jstree(true).hide_all();
                }
            });
        }
    });

    /*collapse*/
    //$("a[data-action='collapse']").each(function (index) {
    //    if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
    //        $(this).attr("data-id", GUID());
    //        $(this).data("isProcessed", "1");
    //        $(this).attr("isProcessed", "1");
    //    }
    //});
    $("[data-action='collapse']").each(function (index) {
        if ($(this).data("isProcessed") != "1" && $(this).attr("isProcessed") != 1) {
            $(this).attr("data-id", GUID());
            $(this).data("isProcessed", "1");
            $(this).attr("isProcessed", "1");
        }
    });

    $(".jsLiSearchFilter").each(function (index, element) {
        if ($(element).data("isProcessed") != "1" && $(element).attr("isProcessed") != 1) {
            $(element).data("isProcessed", "1");
            $(element).attr("isProcessed", "1");

            $(element).keyup(function () {
                $('#' + $(element).data('target-ul') + ' > li:not(.jsNotInclude)').hide();
                $('#' + $(element).data('target-ul') + ' > li:Contains(' + $(element).val() + ')').show();
            })
        }
    });

    // Tooltip Initialization
    $('[data-toggle="tooltip"]').each(function (index, element) {
        if ($(element).data("isProcessed") != "1" && $(element).attr("isProcessed") != 1) {
            $(element).data("isProcessed", "1");
            $(element).attr("isProcessed", "1");
            $(element).tooltip({
                container: 'body'
            });
        }
    });

    $(".jsDateRangePicker").each(function (index, element) {
        if ($(element).data("isProcessed") != "1" && $(element).attr("isProcessed") != 1) {
            $(element).data("isProcessed", "1");
            $(element).attr("isProcessed", "1");

            $(element).daterangepicker({
                showDropdowns: ($(element).data("showdropdowns") === "True" ? true : false),
                autoApply: ($(element).data("autoapply") === "True" ? true : false),
                showWeekNumbers: ($(element).data("showweeknumbers") === "True" ? true : false),
                timePicker: ($(element).data("timepicker") === "True" ? true : false),
                startDate: ($(element).data('startdate') != undefined ? $(element).data('startdate') : new Date(new Date().setFullYear(new Date().getFullYear() - 1))),
                endDate: ($(element).data('enddate') != undefined ? $(element).data('enddate') : new Date()),
                alwaysShowCalendars: ($(element).data("alwaysshowcalendars") == "True" ? true : false),
                locale: {
                    format: ($(element).data('dateformat') != undefined ? $(element).data('dateformat') : 'MM/DD/YYYY')
                },
                ranges: ($(element).data('dateranges') != undefined ? GetDateRanges($(element).data('dateranges')) : undefined),
            });
        }
    });

    $(".jsFileUploads").each(function (index, element) {
        if ($(element).data("isProcessed") != "1" && $(element).attr("isProcessed") != 1) {
            $(element).data("isProcessed", "1");
            $(element).attr("isProcessed", "1");

            $(element).fileupload({
                maxNumberOfFiles: parseInt($(element).data("fileinput")),
                autoUpload: ($(element).data("autoupload") == "True" ? true : false),
                //acceptFileTypes: $(element).data("filetype"),
                //acceptFileTypes: ($(element).data("filetype") != undefined ? new RegExp($(element).data("filetype"), "i") : /.+$/),
                //minFileSize: $(element).data("minfilesize"),
                //maxFileSize: $(element).data("maxfilesize"),
                url: $(element).data("url")
            });
        }
    });

    for (var i = 0; i < window.DocumentEffectAfterFunctions.length; i++) {
        if (typeof (window.DocumentEffectAfterFunctions[i]) == 'function') {
            window.DocumentEffectAfterFunctions[i]();
        }
    }
}

//select2
function formatResult(optionResult, element) {
    console.log($(element).find(".select2-results__option").closest("ul"));
    //select2 - UserIDs - results
    if (optionResult.loading) return optionResult.text;
    var oOptionHtml = [];
    oOptionHtml.push("<div class='select2-result-repository clearfix'>");
    oOptionHtml.push("<div class='select2-result-repository__avatar'>");
    oOptionHtml.push("<img src='" + optionResult.imageurl + "' />");
    oOptionHtml.push("</div>");
    oOptionHtml.push("<div class='select2-result-repository__meta'>");
    oOptionHtml.push("<div class='select2-result-repository__title'>");
    oOptionHtml.push(optionResult.full_name);
    oOptionHtml.push("</div>");
    oOptionHtml.push("<div class='select2-result-repository__description'>");
    oOptionHtml.push(optionResult.description);
    oOptionHtml.push("</div>");
    oOptionHtml.push("</div>");

    return oOptionHtml.join(" ");
}
function formatResultSelection(optionResult) {
    return optionResult.full_name || optionResult.text;
}
//end

// Multiple autocomplete Remote
function split_r(val) {
    return val.split(/,\s*/);
}

function extractLast_r(term) {
    return split_r(term).pop();
}
//end
function GUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}
function AjaxCall(thisdata, pUrl, pRequestType, pPostParentForm, pSaveAndNew, pData, pDataLoadDivID, pLoadOnly, pReturnFunction, pGridIds) {
    $("body").css("cursor", "progress");
    if ($(thisdata).hasClass("disabled")) return false;
    $(thisdata).addClass("disabled");
    var oThisdataText = $(thisdata).html();
    $(thisdata).html("<i class='la la-spinner spinner'></i>&nbsp;" + oThisdataText).html();
    if ($("#ForMessage").hasClass("setMessage")) {
        $("#ForMessage").removeClass("setMessage");
        $("#ForMessage").addClass("removeMessage");
    }
    try {
        var oParentForm = null;
        if (pPostParentForm == true) oParentForm = $(thisdata).closest('form');
        if (pUrl == "" || pUrl == undefined || pUrl == null) {
            return;
        }

        $('form').removeData("validator");
        $('form').removeData("unobtrusiveValidation");

        $.validator.unobtrusive.parse('form');
        if (oParentForm != null) { pData = (pData == undefined ? $(oParentForm).serialize() : pData); }
        if (pDataLoadDivID != "" && pDataLoadDivID != undefined && pLoadOnly == true) {
            $("#" + pDataLoadDivID).load(pUrl, function (responseTxt, statusTxt, xhr) {
                if (statusTxt == "error") {
                    $("body").css("cursor", "auto");
                    $(thisdata).removeClass("disabled");
                    $(thisdata).html(oThisdataText);
                }
                else {
                    if (pReturnFunction != undefined) pReturnFunction(responseTxt);
                    $("body").css("cursor", "auto");
                    $(thisdata).removeClass("disabled");
                    $(thisdata).html(oThisdataText);
                }
            });
        }
        else {
            if ($(oParentForm).valid()) {
                $.ajax({
                    url: pUrl,
                    type: ((pRequestType.toString().toLowerCase() == "get") ? "get" : "post"),
                    data: pData,
                    success: function (argData, status, xhr) {
                        if (pSaveAndNew == true) {
                            $($(thisdata).parents('form:first'))[0].reset();
                        }
                        if (pReturnFunction != undefined) pReturnFunction(argData);
                        if (argData.Success != undefined && argData.Success == true) {
                            $("#ForMessage").removeClass("removeMessage");
                            $("#ForMessage").addClass("setMessage");
                            $("#ForMessage").html(argData.Message);
                        }
                        else if (argData.Success != undefined && argData.Success == false) {
                            openModelError("", argData.Message);
                        }
                        $("body").css("cursor", "auto");
                        $(thisdata).removeClass("disabled");
                        $(thisdata).html(oThisdataText);
                    },
                    error: function (response, statusTxt, xhr) {
                        openModelError("", response.responseText, "modal-xl");
                        $("body").css("cursor", "auto");
                        $(thisdata).removeClass("disabled");
                        $(thisdata).html(oThisdataText);
                    }
                });
            }
            else {
                try { $($(thisdata).parents('form:first')).find(".input-validation-error:first")[0].scrollIntoView({ behavior: 'smooth' }); } catch (e) { }
                $(thisdata).removeClass("disabled");
                $(thisdata).html(oThisdataText);
                $("body").css("cursor", "auto");
            }
        }
    }
    catch (e) {
        console.log("Error " + e.message);
        $("body").css("cursor", "auto");
        $(thisdata).removeClass("disabled");
        $(thisdata).html(oThisdataText);
    }
    $("body").css("cursor", "auto");
}
function PostOnlyAjaxCall(thisdata, pUrl, pRequestType, pPostParentForm, pData, pReturnFunction, pErrorFunction) {
    if ($(thisdata).hasClass("disabled")) return false;
    $("body").css("cursor", "progress");
    $(thisdata).addClass("disabled");
    var oThisdataText = $(thisdata).html();
    $(thisdata).html("<i class='la la-spinner spinner'></i>&nbsp;" + oThisdataText).html();
    if ($("#ForMessage").hasClass("setMessage")) {
        $("#ForMessage").removeClass("setMessage");
        $("#ForMessage").addClass("removeMessage");
    }
    try {
        var oParentForm = null;
        if (pPostParentForm == true) oParentForm = $(thisdata).closest('form');
        if (pUrl == "" || pUrl == undefined || pUrl == null) {
            return;
        }

        $('form').removeData("validator");
        $('form').removeData("unobtrusiveValidation");

        $.validator.unobtrusive.parse('form');
        if (oParentForm != null) { pData = $(oParentForm).serialize(); }

        if ($(oParentForm).valid()) {
            $.ajax({
                url: pUrl,
                type: ((pRequestType.toString().toLowerCase() == "get") ? "get" : "post"),
                data: pData,
                success: function (argData, status, xhr) {

                    if (pReturnFunction != undefined) pReturnFunction(argData);
                    if (argData.Success == true) {
                        $("#ForMessage").removeClass("removeMessage");
                        $("#ForMessage").addClass("setMessage");
                        $("#ForMessage").html(argData.Message);
                    }
                    else
                        openModelError("", argData.Message);

                    $("body").css("cursor", "auto");
                    $(thisdata).removeClass("disabled");
                    $(thisdata).html(oThisdataText);

                    let loadContent = $("#jsAjaxContent").data();
                    $("#" + loadContent.currentload).load(loadContent.currenturl,
                        function (responseTxt, statusTxt, xhr) {

                            if (statusTxt == "error") {
                                if (responseTxt.length > 2000)
                                    openModelError("Error", responseTxt, "modal-xl");
                                else
                                    openModelError("Error", responseTxt, "modal-lg");
                            }
                            OnDocumentEffected();
                        });

                },
                error: function (response, statusTxt, xhr) {
                    openModelError("", response.responseText, "modal-xl");
                    if (pErrorFunction != undefined) pErrorFunction(response);

                    $("body").css("cursor", "auto");
                    $(thisdata).removeClass("disabled");
                    $(thisdata).html(oThisdataText);
                }
            });
        }
        else {
            try { $($(thisdata).parents('form:first')).find(".input-validation-error:first")[0].scrollIntoView({ behavior: 'smooth' }); } catch (e) { }
            $(thisdata).removeClass("disabled");
            $(thisdata).html(oThisdataText);
            $("body").css("cursor", "auto");
        }
    }
    catch (e) {
        console.log("Error " + e.message);
        $("body").css("cursor", "auto");
        $(thisdata).removeClass("disabled");
        $(thisdata).html(oThisdataText);
    }
    $("body").css("cursor", "auto");
}
function GridLoad(grid) {
    try {
        var pRequestType = "get", pUrl = "", pData = [];
        var oCurrentGrid = grid;
        pUrl = ($(oCurrentGrid).data("fixedurl") != undefined && $(oCurrentGrid).data("fixedurl") != "" ? $(oCurrentGrid).data("fixedurl") : $(oCurrentGrid).data("url"));

        $.ajax({
            url: pUrl,
            type: ((pRequestType.toString().toLowerCase() == "get") ? "get" : "post"),
            data: pData,
            success: function (oGridResponse) {
                $('#' + $(oCurrentGrid).attr('id') + ' tbody').html(oGridResponse);
            },
            error: function (response, statusTxt, xhr) {
                openModelError("", response.responseText, "modal-xl");
            }
        });
    }
    catch (e) {
        console.log("GridLoad " + e.message);
    }
}

function RemoveAjaxContainer(id, pReturnFunction) {
    if (id != undefined) {
        $("#" + id).html('');
        if (pReturnFunction != undefined) pReturnFunction(id);
    }
    else
        $(".jsAjaxContainer:first").html('');
}

function Reload() {
    location.reload();
}

function PrintPDF(htmlToPrint, pt, po, ml, mr, mt, mb, ph, pw, isDownload, filename, pReturnFunction) {
    pt = pt == undefined ? "A4" : pt;
    po = po == undefined ? "Portrait" : po;
    ml = ml == undefined ? "0" : ml;
    mr = mr == undefined ? "0" : mr;
    mt = mt == undefined ? "0" : mt;
    mb = mb == undefined ? "0" : mb;
    ph = ph == undefined ? "0" : ph;
    pw = pw == undefined ? "0" : pw;
    isDownload = isDownload == undefined ? true : isDownload;

    //AjaxCall(null, $("#HiddenApplicationPath").val() + "/Export/DownloadPdf", 'post', false, {
    //    "Content": htmlToPrint, "PDFPageSize": pt, "PDFPageOrientation": po
    //    , "MarginLeft": ml, "MarginRight": mr, "MarginTop": mt, "MarginBottom": mb, "PageHeight": ph, "PageWidth": pw, filename: filename
    //}, null, null, function (arg) {
    //    if (arg.Success != "true") { window.open(arg.Data + (isDownload == true ? "&download=pdf" + (filename == undefined ? "" : "&filename=" + filename) : "")); }
    //}, null)
    $.ajax({
        url: "/Export/DownloadPdf",
        type: "POST",
        data: {
            "Content": htmlToPrint, "PDFPageSize": pt, "PDFPageOrientation": po, "MarginLeft": ml, "MarginRight": mr, "MarginTop": mt, "MarginBottom": mb, "PageHeight": ph, "PageWidth": pw, filename: filename
        },
        success: function (argData, status, xhr) {
            console.log(argData);
            if (argData.Success) {
                window.location.href = argData.Data;
            }
            //window.open(argData.Data + (isDownload == true ? "&download=pdf" + (filename == undefined ? "" : "&filename=" + filename) : ""));
            //if (pReturnFunction != undefined) pReturnFunction(argData);
            //var ct = xhr.getResponseHeader("content-type") || "";
            //if (ct.indexOf('html') > -1)
            //{

            //}
            //else if (ct.indexOf('json') > -1)
            //{
            //    if (argData.Success != "true") {
            //        window.open(argData.Data + (isDownload == true ? "&download=pdf" + (filename == undefined ? "" : "&filename=" + filename) : ""));
            //    }
            //    if (argData.Success == true)
            //    {     

            //    }
            //    else {
            //        openModelError("", argData.Message);
            //    }
            //}
            $("body").css("cursor", "auto");
        },
        error: function (response, statusTxt, xhr) {
            openModelError("", response.responseText, "modal-xl");
            $("body").css("cursor", "auto");
        }
    });
}


/*
    document ready set default configuration 
*/
$(document).ready(function () {
    OnDocumentEffected();
    $(window).scroll((function () {
        $(this).scrollTop() > 40 ? $("#scroll-top").fadeIn() : $("#scroll-top").fadeOut()
    })),
        $("#scroll-top").click((function () {
            $("html, body").animate({
                scrollTop: 0
            }, 1e3)
        }));

    /*
    Reload page when click back button in browser 
    */
    jQuery(document).ready(function ($) {
        $(window).on('popstate', function () {
            location.reload(true);
        });
    });

    /*
     Hit button in while pressed enter
     */
    $(window).keydown(function (e) {
        if (e.which == 13) {//Check here enter press or not
            let currentTarget = $(e.target);
            if ($(currentTarget) == undefined || $(currentTarget)[0] == $('body')[0]) { }
            else {
                if ($(currentTarget).is('textarea')) {
                    return true;
                }
                else {
                    var ofirstButton = $(currentTarget).parents("form:not(.skipOnEnter):first").find(":input[type=button], :input[type=submit]").first();
                    if (ofirstButton != undefined) {
                        $(ofirstButton).trigger('click');
                    }
                }
            }
            return false;
        }
    })
});

//highlight some jquery function prepred
jQuery.fn.highlight = function (pat) {
    function innerHighlight(node, pat) {
        var skip = 0;
        //console.log(node);
        if (node.nodeType == 3) {
            var pos = node.data.toUpperCase().indexOf(pat);
            pos -= (node.data.substr(0, pos).toUpperCase().length - node.data.substr(0, pos).length);
            if (pos >= 0) {
                var spannode = document.createElement('span');
                spannode.className = 'highlight';
                var middlebit = node.splitText(pos);
                var endbit = middlebit.splitText(pat.length);
                var middleclone = middlebit.cloneNode(true);
                spannode.appendChild(middleclone);
                middlebit.parentNode.replaceChild(spannode, middlebit);
                skip = 1;
            }
        }
        else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
            for (var i = 0; i < node.childNodes.length; ++i) {
                i += innerHighlight(node.childNodes[i], pat);
            }
        }
        return skip;
    }
    return this.length && pat && pat.length ? this.each(function () {
        innerHighlight(this, pat.toUpperCase());
    }) : this;
};

jQuery.fn.removeHighlight = function () {
    return this.find("span.highlight").each(function () {
        this.parentNode.firstChild.nodeName;
        with (this.parentNode) {
            replaceChild(this.firstChild, this);
            normalize();
        }
    }).end();
};

/*Validation Pulgin start*/

let enumCompareType =
{
    EqualString: "EqualString",
    EqualStringIgnoreCase: "EqualStringIgnoreCase",
    NotEqualString: "NotEqualString",
    NotEqualStringIgnoreCase: "NotEqualStringIgnoreCase",
    ContainedByParent: "ContainedByParent",
    ContainsParent: "ContainsParent",
    EqualInt: "EqualInt",
    NotEqualInt: "NotEqualInt",
    LessInt: "LessInt",
    GreaterInt: "GreaterInt",
    LessOrEqualInt: "LessOrEqualInt",
    LessFloat: "LessFloat",
    GreaterFloat: "GreaterFloat",
    LessOrEqualFloat: "LessOrEqualFloat",
    GreaterOrEqualFloat: "GreaterOrEqualFloat",
    EqualDate: "EqualDate",
    NotEqualDate: "NotEqualDate",
    LessDate: "LessDate",
    GreaterDate: "GreaterDate",
    LessOrEqualDate: "LessOrEqualDate",
    GreaterOrEqualDate: "GreaterOrEqualDate",
    EqualTime: "EqualTime",
    NotEqualTime: "NotEqualTime",
    LessTime: "LessTime",
    GreaterTime: "GreaterTime",
    LessOrEqualTime: "LessOrEqualTime",
    GreaterOrEqualTime: "GreaterOrEqualTime"
};

(function ($) {
    var parseDate = function (str) {
        var m = str.match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/);
        return (m) ? new Date(m[1], m[2] - 1, m[3]) : null;
    };
    $.validator.setDefaults({
        ignore: ".jsIgnore",
    });
    $.validator.addMethod('daterange', function (value, element, param) {
        if (!value) return true;
        var min = parseDate(param.min);
        var max = parseDate(param.max);
        var current = parseDate(value);
        if (min == null || max == null || current == null) { return false; }
        return (current >= min && current <= max);
    });
    $.validator.unobtrusive.adapters.add('daterange', ['min', 'max'], function (options) {
        var params = { min: options.params.min, max: options.params.max };
        options.rules['daterange'] = params;
        if (options.message) { options.messages['daterange'] = options.message; }
    });
})(jQuery);


(function ($) {
    var parseDate = function (str) {
        var m = str.match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/);
        return (m) ? new Date(m[1], m[2] - 1, m[3]) : null;
    };

    var parseTime = function (str) {
        var currDate = new Date();
        var mt = str.match(/^(\d{2}):(\d{2})$/);
        return (mt) ? new Date(currDate.getFullYear(), currDate.getMonth(), currDate.getDay(), mt[1], mt[2], 0) : null;
    };

    var compareValues = function (selfValue, compareValue, compareType) {
        try {
            if (compareType == null || compareType == undefined || compareType == '') { return false; }
            if (compareType != enumCompareType.EqualString && compareType != enumCompareType.NotEqualString) {
                if (selfValue == null || selfValue == undefined || selfValue == '') { return true; }
                if (compareValue == null || compareValue == undefined || compareValue == '') { return false; }
            }

            if (compareType == enumCompareType.EqualString) { return selfValue == compareValue; }
            else if (compareType == enumCompareType.EqualStringIgnoreCase) { return selfValue.toUpperCase() == compareValue.toUpperCase(); }
            else if (compareType == enumCompareType.NotEqualString) { return selfValue != compareValue; }
            else if (compareType == enumCompareType.NotEqualStringIgnoreCase) { return selfValue.toUpperCase() != compareValue.toUpperCase(); }
            else if (compareType == enumCompareType.ContainedByParent) { return compareValue.indefOf(selfValue) > -1; }
            else if (compareType == enumCompareType.ContainsParent) { return selfValue.indefOf(compareValue) > -1; }
            else if (compareType == enumCompareType.EqualInt) { return parseInt(selfValue) == parseInt(compareValue); }
            else if (compareType == enumCompareType.NotEqualInt) { return parseInt(selfValue) != parseInt(compareValue); }
            else if (compareType == enumCompareType.LessInt) { return parseInt(selfValue) < parseInt(compareValue); }
            else if (compareType == enumCompareType.GreaterInt) { return parseInt(selfValue) > parseInt(compareValue); }
            else if (compareType == enumCompareType.LessOrEqualInt) { return parseInt(selfValue) <= parseInt(compareValue); }
            else if (compareType == enumCompareType.GreaterOrEqualInt) { return parseInt(selfValue) >= parseInt(compareValue); }
            else if (compareType == enumCompareType.EqualFloat) { return parseFloat(selfValue) == parseFloat(compareValue); }
            else if (compareType == enumCompareType.NotEqualFloat) { return parseFloat(selfValue) != parseFloat(compareValue); }
            else if (compareType == enumCompareType.LessFloat) { return parseFloat(selfValue) < parseFloat(compareValue); }
            else if (compareType == enumCompareType.GreaterFloat) { return parseFloat(selfValue) > parseFloat(compareValue); }
            else if (compareType == enumCompareType.LessOrEqualFloat) { return parseFloat(selfValue) <= parseFloat(compareValue); }
            else if (compareType == enumCompareType.GreaterOrEqualFloat) { return parseFloat(selfValue) >= parseFloat(compareValue); }
            else if (compareType == enumCompareType.EqualDate) { return parseDate(selfValue).getTime() == parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.NotEqualDate) { return parseDate(selfValue).getTime() != parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.LessDate) { return parseDate(selfValue).getTime() < parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.GreaterDate) { return parseDate(selfValue).getTime() > parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.LessOrEqualDate) { return parseDate(selfValue).getTime() <= parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.GreaterOrEqualDate) { return parseDate(selfValue).getTime() >= parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.EqualTime) { return parseTime(selfValue).getTime() == parseTime(compareValue).getTime(); }
            else if (compareType == enumCompareType.NotEqualTime) { return parseTime(selfValue).getTime() != parseTime(compareValue).getTime(); }
            else if (compareType == enumCompareType.LessTime) { return parseTime(selfValue).getTime() < parseTime(compareValue).getTime(); }
            else if (compareType == enumCompareType.GreaterTime) { return parseTime(selfValue).getTime() > parseTime(compareValue).getTime(); }
            else if (compareType == enumCompareType.LessOrEqualTime) { return parseTime(selfValue).getTime() <= parseTime(compareValue).getTime(); }
            else if (compareType == enumCompareType.GreaterOrEqualTime) { return parseTime(selfValue).getTime() >= parseTime(compareValue).getTime(); }
            return false;
        } catch (parsingIssue) { return false; }
    };
    $.validator.addMethod('compare', function (value, element, param) {
        if (!value) return true;

        var to = $(element).data("valCompareTo");
        var comparetype = $(element).data("valCompareComparetype");

        if (to == null || to == undefined || $("#" + to).val() == "" || value == null || value == "") { return true; }
        return compareValues(value, $("#" + to).val(), comparetype);
    });
    $.validator.unobtrusive.adapters.add('compare', ['to', 'comparetype'], function (options) {
        var params = { to: options.params.to, comparetype: options.params.comparetype };
        options.rules['compare'] = params;
        if (options.message) { options.messages['compare'] = options.message; }
    });
})(jQuery);

(function ($) {
    var compareValues = function (selfValue, compareValue, compareType) {
        try {

            if (compareType == null || compareType == undefined || compareType == '') { return false; }
            if (compareType != enumCompareType.EqualString && compareType != enumCompareType.NotEqualString) {
                if (selfValue == null || selfValue == undefined || selfValue == '') { return true; }
                if (compareValue == null || compareValue == undefined || compareValue == '') { return false; }
            }


            if (compareType == enumCompareType.EqualString) { return selfValue == compareValue; }
            else if (compareType == enumCompareType.EqualStringIgnoreCase) { return selfValue.toUpperCase() == compareValue.toUpperCase(); }
            else if (compareType == enumCompareType.NotEqualString) { return selfValue != compareValue; }
            else if (compareType == enumCompareType.NotEqualStringIgnoreCase) { return selfValue.toUpperCase() != compareValue.toUpperCase(); }
            else if (compareType == enumCompareType.ContainedByParent) { return compareValue.indefOf(selfValue) > -1; }
            else if (compareType == enumCompareType.ContainsParent) { return selfValue.indefOf(compareValue) > -1; }
            else if (compareType == enumCompareType.EqualInt) { return parseInt(selfValue) == parseInt(compareValue); }
            else if (compareType == enumCompareType.NotEqualInt) { return parseInt(selfValue) != parseInt(compareValue); }
            else if (compareType == enumCompareType.LessInt) { return parseInt(selfValue) < parseInt(compareValue); }
            else if (compareType == enumCompareType.GreaterInt) { return parseInt(selfValue) > parseInt(compareValue); }
            else if (compareType == enumCompareType.LessOrEqualInt) { return parseInt(selfValue) <= parseInt(compareValue); }
            else if (compareType == enumCompareType.GreaterOrEqualInt) { return parseInt(selfValue) >= parseInt(compareValue); }
            else if (compareType == enumCompareType.EqualFloat) { return parseFloat(selfValue) == parseFloat(compareValue); }
            else if (compareType == enumCompareType.NotEqualFloat) { return parseFloat(selfValue) != parseFloat(compareValue); }
            else if (compareType == enumCompareType.LessFloat) { return parseFloat(selfValue) < parseFloat(compareValue); }
            else if (compareType == enumCompareType.GreaterFloat) { return parseFloat(selfValue) > parseFloat(compareValue); }
            else if (compareType == enumCompareType.LessOrEqualFloat) { return parseFloat(selfValue) <= parseFloat(compareValue); }
            else if (compareType == enumCompareType.GreaterOrEqualFloat) { return parseFloat(selfValue) >= parseFloat(compareValue); }
            else if (compareType == enumCompareType.EqualDate) { return parseDate(selfValue).getTime() == parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.NotEqualDate) { return parseDate(selfValue).getTime() != parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.LessDate) { return parseDate(selfValue).getTime() < parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.GreaterDate) { return parseDate(selfValue).getTime() > parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.LessOrEqualDate) { return parseDate(selfValue).getTime() <= parseDate(compareValue).getTime(); }
            else if (compareType == enumCompareType.GreaterOrEqualDate) { return parseDate(selfValue).getTime() >= parseDate(compareValue).getTime(); }
            return false;
        } catch (parsingIssue) { return false; }
    };
    $.validator.addMethod('validateif', function (value, element, param) {
        try {
            var id = '#' + param['dependentproperty'];
            var targetvalue = param['targetvalue'];
            var comparetype = param['comparetype'];
            targetvalue = ((targetvalue == null || targetvalue == undefined) ? '' : targetvalue).toString();
            comparetype = ((comparetype == null || comparetype == undefined) ? 'EqualString' : comparetype).toString();

            var control = $(id);
            var controltype = control.attr('type');
            var actualvalue = controltype === 'checkbox' ? control.attr('checked') : control.val();
            if (controltype === 'checkbox') {
                if ("undefined" != typeof (console) && "undefined" != console.log) { console.log(targetvalue + "," + actualvalue + "," + comparetype); }
                if ((targetvalue == 'unchecked' && actualvalue != 'checked') || (targetvalue != 'unchecked' && actualvalue == 'checked'))
                    return $.validator.methods.required.call(this, value, element, param);
            } else {
                if (compareValues($.trim(actualvalue), $.trim(targetvalue), comparetype))
                    return $.validator.methods.required.call(this, value, element, param);
            }
            return true;
        } catch (ex) { if ("undefined" != typeof (console) && "undefined" != console.log) { console.log(ex); } return false; }
    });
    $.validator.unobtrusive.adapters.add('validateif', ['dependentproperty', 'targetvalue', 'comparetype'], function (options) {
        var params = { dependentproperty: options.params.dependentproperty, targetvalue: options.params.targetvalue, comparetype: options.params.comparetype };
        options.rules['validateif'] = params;
        if (options.message) { options.messages['validateif'] = options.message; }
    });
})(jQuery);

(function ($) {
    var matcher = /\s*(?:((?:(?:\\\.|[^.,])+\.?)+)\s*([!~><=]=|[><])\s*("|')?((?:\\\3|.)*?)\3|(.+?))\s*(?:,|$)/g;
    function resolve(element, data) {
        data = data.match(/(?:\\\.|[^.])+(?=\.|$)/g);
        var cur = jQuery.data(element)[data.shift()];
        while (cur && data[0]) { cur = cur[data.shift()]; }
        return cur || undefined;
    }
    jQuery.expr[':'].data = function (el, i, match) {
        matcher.lastIndex = 0;
        var expr = match[3],
            m,
            check, val,
            allMatch = null,
            foundMatch = false;
        while (m = matcher.exec(expr)) {
            check = m[4];
            val = resolve(el, m[1] || m[5]);
            switch (m[2]) {
                case '==': foundMatch = val == check; break;
                case '!=': foundMatch = val != check; break;
                case '<=': foundMatch = val <= check; break;
                case '>=': foundMatch = val >= check; break;
                case '~=': foundMatch = RegExp(check).test(val); break;
                case '>': foundMatch = val > check; break;
                case '<': foundMatch = val < check; break;
                default: if (m[5]) foundMatch = !!val;
            }
            allMatch = allMatch === null ? foundMatch : allMatch && foundMatch;
        }
        return allMatch;
    };
})(jQuery);
/*End validation*/


/*
Kendo plugin start 
*/
let columnsName = {
    hidden: "hidden",
    locked: "locked"

};
(function ($, kendo) {
    var ExtGrid = kendo.ui.Grid.extend({
        options: {
            toolbarColumnMenu: false,
            toolbarClearFilter: false,
            toolbarFrozenMenu: false,
            toolColumnClubMenu: false,
            reportName: '',
            name: "AlliantGrid"
        },
        init: function (element, options) {
            /// <summary>
            /// Initialize the widget.
            /// </summary>            

            // Call the base class init.            
            kendo.ui.Grid.fn.init.call(this, element, options);
            this._initToolbarColumnMenu();
            this._initToolbarclearFilter();
            this._initToolbarFrozenMenu();
            this._columnClubMenu();
            OnDocumentEffected();
        },
        gridConfiguration: function () {
            if (this.options.reportName != undefined && $.trim(this.options.reportName) != '') {
                SaveGridConfiguration(this.element.attr("id"), this.options.reportName);
            }
        },
        columnMenuCount: function (className, columnName) {
            switch (columnName) {
                case columnsName.hidden:
                    $("." + className).html(this.getOptions().columns.where({ hidden: true }).length > 0 ?
                        kendo.format("<b class='jsAlliantCountMenu'>({0})</b>", this.getOptions().columns.where({ hidden: true }).length) : ""
                    );
                    break;
                case columnsName.locked:
                    $("." + className).html(this.getOptions().columns.where({ locked: true }).length > 0 ?
                        kendo.format("<b class='jsAlliantCountMenu'>({0})</b>", this.getOptions().columns.where({ locked: true }).length) : ""
                    );
                    break;
                default:
            }

        },
        _bindColumnsMenu: function ($menu, columnName) {
            // Loop over all the columns and add them to the column menu.          
            for (var idx = 0; idx < this.columns.length; idx++) {
                var column = this.columns[idx];
                // A column must have a title to be added.
                if ($.trim(column.title).length > 0) {
                    // Add columns to the column menu.
                    $menu.append(kendo.format("<li><label class='jskendoMenuLabel'><input  type='checkbox' data-index='{0}' data-field='{1}' data-title='{2}' {3}> {4}</label></li>",
                        idx, column.field, column.title, (columnName == columnsName.hidden ? (column.hidden ? "" : "checked") : ""), column.title));
                }
            }
            return $menu;
        },
        _initToolbarclearFilter: function () {
            if (this.options.toolbarClearFilter) {
                if (this.wrapper.find("div.k-grid-toolbar button.jsAlliantClearFilter").length > 0) {
                    this.wrapper.find("div.k-grid-toolbar button.jsAlliantClearFilter").remove();                    
                }
                this.wrapper.parent().parent().find("div.jsAlliantFilters").remove();
                this.wrapper.parent().parent().prepend(`<div class=\"col-md-12 jsAlliantFilters\" id='jsFilterCube${this.element.attr("id")}'></div>`);
                this.wrapper.find("div.k-grid-toolbar").append("<button type=\"button\" class=\"k-button jsAlliantClearFilter\" onclick=\"_clearFilter(this)\"><i class=\"k-icon k-i-filter-clear\"></i>&nbsp;  Clear Filter</button>");
                this._preparedFilterCube(this);
               
                this._removeFilterCube(this);
                this._filterHtml(this);
            }
        },      
        //filterMenuInit: function (e) {
        //    console.log("comman")
        //    console.log(e);
        //    console.log($("#RentalWorksheetViewModel").data("kendoAlliantGrid").wrapper.data());
        //},
        _preparedFilterCube: function ($this) {
            $this.dataSource.originalFilter = $this.dataSource.filter;
            $this.dataSource.filter = function () {
                var result = $this.dataSource.originalFilter.apply(this, arguments);
                if (arguments.length > 0) {
                    this.trigger("filter", arguments);
                }
                return result;
            }
            $this.dataSource.bind("filter", function () {
                $this._filterHtml($this);
            });
        },
        _removeFilterCube: function ($this) {
            $(`#jsFilterCube${$this.element.attr("id")}`).on("click", ".jsRemoveKendoFilter", function () {
                filters = $this.dataSource.filter().filters;
                filters = removeFilter(filters, $(this).data('field'));            
                $this.dataSource.filter(filters);
            });
        },
        _filterHtml: function ($this) {
            var currentFilter = $this.dataSource._filter;
            if (currentFilter != null) {
                var filterHtml = [];
                currentFilter.filters.forEach(function (filter, index) {
                    if (filter.field != undefined) {
                        filterHtml.push("<div title=\"Click to remove filter\" class=\"badge badge-primary badge-square\"><a href=\"javascript:void(0)\" class=\"jsRemoveKendoFilter\" data-field=" + filter.field + ">")
                        filterHtml.push(filter.field)
                        filterHtml.push(filter.operator)
                        filterHtml.push(filter.value)
                        filterHtml.push("<i class=\"la la-remove font-medium-2\"></i>")
                        filterHtml.push("</a></div>")
                    }
                    else if (filter.logic != undefined && filter.filters.length > 0) {
                        filterHtml.push("<div title=\"Click to remove filter\" class=\"badge badge-primary badge-square\"><a href=\"javascript:void(0)\" class=\"jsRemoveKendoFilter\" data-field=" + filter.filters[0].field + ">")
                        filterHtml.push(filter.filters[0].field);
                        filterHtml.push(" (");
                        filter.filters.forEach(function (childFilter, childIndex) {
                            filterHtml.push(childFilter.value)
                            if (childIndex <= filter.filters.length - 2) {
                                filterHtml.push(",")
                            }
                        });
                        filterHtml.push(") ");
                        filterHtml.push("<i class=\"la la-remove font-medium-2\"></i>")
                        filterHtml.push("</a></div>")
                    }
                });
                $this.wrapper.parent().parent().find(".jsAlliantFilters").html(filterHtml.join(" "));
            }
        },
        _initToolbarColumnMenu: function () {
            /// <summary>
            /// Determine whether the column menu should be displayed, and if so, display it.
            /// </summary>

            ///If columnmenu present then remove
            if (this.options.toolbarColumnMenu === true && this.element.find(".k-ext-grid-columnmenu").length > 0) {
                this.element.find(".k-ext-grid-columnmenu").remove();
            }

            // The toolbar column menu should be displayed.
            if (this.options.toolbarColumnMenu === true && this.element.find(".k-ext-grid-columnmenu").length === 0) {

                // Create the column menu items.
                var $menu = $(kendo.format("<ul id='{0}{1}' class='jsMenu{1}'></ul>", "JsUlFilter", this.element.attr('id')));
                $menu.append(kendo.format("<li class='jsNotInclude' ><input data-target-ul='{0}' class='jsLiSearchFilter' type='text' placeholder='Type to search'></li>", kendo.format('{0}{1}', "JsUlFilter", this.element.attr('id'))));
                $menu = this._bindColumnsMenu($menu, columnsName.hidden);

                // Create a "Columns" menu for the toolbar.
                this.wrapper.find("div.k-grid-toolbar").append(kendo.format("<ul class='k-ext-grid-columnmenu pull-right'><li data-role='menutitle'><i class='k-icon k-i-borders-show-hide'></i> Hide column <span class='{0}{1}'></span></li></ul>", "jsAlliantColumnMenu", this.element.attr('id')));
                this.wrapper.find("div.k-grid-toolbar ul.k-ext-grid-columnmenu li").append($menu);

                var that = this;

                this.wrapper.find("div.k-grid-toolbar ul.k-ext-grid-columnmenu").kendoMenu({
                    closeOnClick: false,
                    select: function (e) {
                        // Get the selected column.
                        var $item = $(e.item), $input, columns = that.columns;
                        $input = $item.find(":checkbox");
                        if ($input.attr("disabled") || $item.attr("data-role") === "menutitle") {
                            return;
                        }
                        var column = that._findColumnByTitle($input.attr("data-title"));

                        // If checked, then show the column; otherwise hide the column.
                        if ($input.is(":checked")) {
                            that.showColumn(column);
                            hideShowColumn($input.data("index"), false);
                        } else {
                            that.hideColumn(column);
                            hideShowColumn($input.data("index"), true);
                        }
                        that.gridConfiguration();
                        that.columnMenuCount(kendo.format("{0}{1}", "jsAlliantColumnMenu", that.element.attr('id')), columnsName.hidden);
                    }
                });
            }
        },
        _initToolbarFrozenMenu: function () {
            if (this.options.toolbarFrozenMenu === true && this.element.find(".k-ext-grid-FrozenMenu").length > 0) {
                this.element.find(".k-ext-grid-FrozenMenu").remove();
            }

            // The toolbar column menu should be displayed.
            if (this.options.toolbarFrozenMenu === true && this.element.find(".k-ext-grid-FrozenMenu").length === 0) {

                // Create the column menu items.
                var $menu = $(kendo.format("<ul id='{0}{1}' class='jsMenu{1}'></ul>", "JsUlFilter", this.element.attr('id')));

                $menu = this._bindColumnsMenu($menu, columnsName.locked);

                // Create a "Columns" menu for the toolbar.         
                this.wrapper.find("div.k-grid-toolbar").append(kendo.format("<ul class='k-ext-grid-FrozenMenu pull-left'><li data-role='menutitle'><i class='k-icon k-i-lock'></i> Lock & Unlock &nbsp;<i class='k-icon k-i-unlock'></i> <span class='{0}{1}'></span></li></ul>", "jsAlliantFrozenMenu", this.element.attr('id')));
                this.wrapper.find("div.k-grid-toolbar ul.k-ext-grid-FrozenMenu li").append($menu);

                var that = this;

                this.wrapper.find("div.k-grid-toolbar ul.k-ext-grid-FrozenMenu").kendoMenu({
                    closeOnClick: false,
                    select: function (e) {
                        // Get the selected column.
                        var $item = $(e.item), $input, columns = that.columns;
                        $input = $item.find(":checkbox");
                        if ($input.attr("disabled") || $item.attr("data-role") === "menutitle") {
                            return;
                        }

                        var column = that._findColumnByTitle($input.attr("data-title"));

                        if ($input.is(":checked")) {
                            $("#" + that.element.attr('id')).data("kendoAlliantGrid").lockColumn(column.field);
                        }
                        else {
                            $("#" + that.element.attr('id')).data("kendoAlliantGrid").unlockColumn(column.field);
                        }

                        that.columnMenuCount(kendo.format("{0}{1}", "jsAlliantFrozenMenu", that.element.attr('id')), columnsName.locked);
                    }
                });
            }
        },
        _findColumnByTitle: function (title) {
            /// <summary>
            /// Find a column by column title.
            /// </summary>
            var result = null;

            for (var idx = 0; idx < this.columns.length && result === null; idx++) {
                column = this.columns[idx];

                if (column.title === title) {
                    result = column;
                }
            }

            return result;
        },
        _columnClubMenu: function () {
            if (this.options.toolColumnClubMenu === true && this.element.find(".k-ext-grid-columnClubMenu").length > 0) {
                this.element.find(".k-ext-grid-columnClubMenu").remove();
            }

            if (this.options.toolColumnClubMenu === true && this.element.find(".k-ext-grid-columnClubMenu").length === 0) {

                var that = this;
                // Create the column menu items.
                var $menu = $(kendo.format("<ul id='{0}{1}' class='jsMenu{1}'></ul>", "JsUlFilter", this.element.attr('id')));

                // Loop over all the columns and add them to the column menu.
                $menu.append(kendo.format("<li class='jsNotInclude' ><input data-target-ul='{0}' class='jsLiSearchFilter' type='text' placeholder='Type to search'></li>", kendo.format('{0}{1}', "JsUlFilter", this.element.attr('id'))));
                for (var idx = 0; idx < this.columns.length; idx++) {
                    var column = this.columns[idx];
                    // A column must have a title to be added.
                    if ($.trim(column.title).length > 0) {
                        // Add columns to the column menu.
                        $menu.append(kendo.format("<li><span class='jsAlliantLockUnlockIcon' data-islocked='{8}' data-grid='{5}' data-field='{6}'  onclick='lockUnlockColumn(this)'>{7} <input type='checkbox' data-index='{0}' data-field='{1}' data-title='{2}' {3}/> {4}</li>",
                            idx, column.field, column.title, (column.hidden ? "" : "checked"), column.title, this.element.attr('id'), column.field,
                            (column.locked ? "<i class='k-icon k-i-lock'></i></span>" : "<i class='k-icon k-i-unlock'></i></span>"),
                            (column.locked ? 1 : 0)
                        ));
                    }
                }
                // Create a "Columns" menu for the toolbar.         
                this.wrapper.find("div.k-grid-toolbar").append(kendo.format("<ul class='k-ext-grid-columnClubMenu pull-right'><li data-role='menutitle'> <i class='k-icon k-i-grid'></i> <span class='jsAlliantClubLockColumn{1}'></span> Columns <span class='{0}{1}'></span></li></ul>", "jsAlliantClubMenuColumn", this.element.attr('id')));
                this.wrapper.find("div.k-grid-toolbar ul.k-ext-grid-columnClubMenu li").append($menu);

                this.wrapper.find("div.k-grid-toolbar ul.k-ext-grid-columnClubMenu").kendoMenu({
                    closeOnClick: false,
                    select: function (e) {
                        // Get the selected column.
                        var $item = $(e.item), $input;
                        $input = $item.find(":checkbox");
                        if ($input.attr("disabled") || $item.attr("data-role") === "menutitle") {
                            return;
                        }

                        var column = that._findColumnByTitle($input.attr("data-title"));

                        // If checked, then show the column; otherwise hide the column.
                        if ($input.is(":checked")) {
                            that.showColumn(column);
                            hideShowColumn($input.data("index"), false);
                        } else {
                            that.hideColumn(column);
                            hideShowColumn($input.data("index"), true);
                        }
                        that.gridConfiguration();
                        that.columnMenuCount(kendo.format("{0}{1}", "jsAlliantClubMenuColumn", that.element.attr('id')), columnsName.hidden);
                    }
                });
            }
        }
    });
    kendo.ui.plugin(ExtGrid);
})(window.kendo.jQuery, window.kendo);

function onFilterMenuInit(e) {
    console.log(e);
    e.container.on("click", "[type='reset']", function () {
        $(".jsRemoveKendoFilter[data-field='" + e.field + "']").parent().remove();
    });
}
/**
 * Remove filter from kendo
 * @param {any} filter
 * @param {any} searchFor
 */
function removeFilter(filter, searchFor) {
    if (filter == null)
        return [];

    for (var x = 0; x < filter.length; x++) {

        if (filter[x].filters != null && filter[x].filters.length >= 0) {
            if (filter[x].filters.length == 0) {
                filter.splice(x, 1);
                return removeFilter(filter, searchFor);
            }
            filter[x] = removeFilter(filter[x].filters, searchFor);
        }
        else {
            if (filter[x].field == searchFor) {
                filter.splice(x, 1);
                return removeFilter(filter, searchFor);
            }
        }
    }

    return filter;
}

/**
 * return the kendo filter
 * @param {any} filter
 */
function getKendoFilter(filter) {
    try {
        if (filter != "") {
            filterKendo = [];
            for (var i = 0; i < filter.Filters.length; i++) {
                filterKendo.push({
                    field: filter.Filters[i].Member,
                    operator: getKendoOperator(filter.Filters[i].Operator),
                    value: filter.Filters[i].Value
                });
            }
        }

    } catch (e) {

    }
    return filterKendo;
}
/**
 * get operator name based on enum key number
 * @param {any} operator
 */
function getKendoOperator(operator) {
    return enumKendoOperator[operator];
}

/**
 * Hide Show columns footer based on current index
 * @param {any} index
 * @param {any} isHide
 */
function hideShowColumn(index, isHide) {
    if (isHide)
        $('.jsColumnFooter[data-index=' + index + ']').hide();
    else
        $('.jsColumnFooter[data-index=' + index + ']').show();
}

/**
 * Clear filter kendo grid 
 * @param {any} elem
 */
function _clearFilter(elem) {
    $("#" + $(elem).closest("div[data-role='alliantgrid']").attr('id')).data("kendoAlliantGrid").dataSource.filter({});
    $("#jsFilterCube" + $(elem).closest("div[data-role='alliantgrid']").attr('id')).html('');
}

/**
 * save grid configuration user wise
 * @param {any} alliantGridID
 * @param {any} reportName
 */
function SaveGridConfiguration(alliantGridID, reportName) {
    try {
        alliantGridID = JSON.stringify($("#" + alliantGridID).data('kendoAlliantGrid').getOptions());
        AlliantAjaxCall("POST", $("#jsGridConfigurationReports").val(), { GridConfiguration: alliantGridID, ReportName: reportName });
    }
    catch (e) {
        console.log("Error : SaveGridConfiguration " + e.message);
    }
}

/**
 * set last grid configuration user wise
 * @param {any} gridObject
 * @param {any} gridConfiguration
 */
function SetGridConfiguration(gridObject, gridConfiguration) {
    if (gridObject != undefined) {

        if (gridConfiguration != undefined) {
            manageGridColumns(gridObject, gridConfiguration, columnsName.hidden);
            manageGridColumns(gridObject, gridConfiguration, columnsName.locked);
        }

        gridObject.columnMenuCount(kendo.format("{0}{1}", "jsAlliantClubMenuColumn", gridObject.element.attr('id')), columnsName.hidden);
        gridObject.columnMenuCount(kendo.format("{0}{1}", "jsAlliantClubLockColumn", gridObject.element.attr('id')), columnsName.locked);
        gridObject.columnMenuCount(kendo.format("{0}{1}", "jsAlliantColumnMenu", gridObject.element.attr('id')), columnsName.hidden);
    }
}

/**
 * manage hide/show columns manually avoid server call/mutiple
 * @param {any} gridObject
 * @param {any} gridConfiguration
 * @param {any} columnName
 */
function manageGridColumns(gridObject, gridConfiguration, columnName) {
    switch (columnName) {
        case columnsName.hidden:
            gridConfiguration.columns.where({ hidden: true }).forEach(function (oKey, index) {
                gridObject.hideColumn(oKey.field);
            });
            break;
        case columnsName.locked:
            gridConfiguration.columns.where({ locked: true }).forEach(function (oKey, index) {
                gridObject.lockColumn(oKey.field);
            });
            break;
        default:
    }
    manageCheckboxAndLockMenuKendoGrid(gridObject);
}

/**
 * checkbox uncheck and checked while grid load
 * @param {any} gridObject
 */
function manageCheckboxAndLockMenuKendoGrid(gridObject) {
    $(kendo.format("#{0} ul.jsMenu{0} > li", gridObject.element.attr("id"))).
        each(function () {
            if ($.inArray($(this).find("input").attr('data-field'), gridObject.columns.where({ hidden: true }).select('x.field')) > -1) {
                $(this).find(`input[data-field='${$(this).find("input").attr('data-field')}']`).prop("checked", false);
            }

            if ($.inArray($(this).find("span.jsAlliantLockUnlockIcon").attr('data-field'), gridObject.columns.where({ locked: true }).select('x.field')) > -1) {
                $(this).find(`span.jsAlliantLockUnlockIcon[data-field='${$(this).find("span.jsAlliantLockUnlockIcon").attr('data-field')}']`).html("<span class=\"k-icon k-i-lock\"></span>");
                $(this).find(`span.jsAlliantLockUnlockIcon[data-field='${$(this).find("span.jsAlliantLockUnlockIcon").attr('data-field')}']`).data('islocked', 1);
            }
        })
}

/**
 * lock unlock grid column
 * @param {any} elem
 */
function lockUnlockColumn(elem) {

    grid = $("#" + $(elem).data('grid')).data('kendoAlliantGrid');
    if (parseInt($(elem).data('islocked')) == 0) {
        $(elem).data('islocked', 1);
        grid.lockColumn($(elem).data('field'));
        $(elem).html("<span class=\"k-icon k-i-lock\"></span>");
    }
    else {
        $(elem).data('islocked', 0);
        grid.unlockColumn($(elem).data('field'));
        $(elem).html("<span class=\"k-icon k-i-unlock\"></span>");
    }
    grid.columnMenuCount(kendo.format("{0}{1}", "jsAlliantClubLockColumn", grid.element.attr('id')), columnsName.locked);
    grid.gridConfiguration();
}
/*End kendo plugin*/

/*File plugin start*/
window.locale = {
    "fileupload": {
        "errors": {
            "maxFileSize": "File is too big",
            "minFileSize": "File is too small",
            "acceptFileTypes": "Filetype not allowed",
            "maxNumberOfFiles": "Max number of files exceeded",
            "uploadedBytes": "Uploaded bytes exceed file size",
            "emptyResult": "Empty file upload result"
        },
        "error": "Error",
        "start": "Start",
        "cancel": "Cancel",
        "destroy": "Delete"
    }
};
/*File plugin end*/



/*
Prepared some common prototype function similar to c#
*/

/**
 * Use this function for select any key from array
 * var persons = [{ name: 'foo', age: 1 }, { name: 'bar', age: 2 }];
 * console.log(persons.select(function(x){
    return x.name;
}));
 *console.log(persons.select('x.name'));
 * @param {any} expr
 */
Array.prototype.select = function (expr) {
    var arr = this;
    switch (typeof expr) {
        case 'function':
            return $.map(arr, expr);
            break;

        case 'string':
            try {
                var func = new Function(expr.split('.')[0],
                    'return ' + expr + ';');
                return $.map(arr, func);
            }
            catch (error) {
                return error;
            }
            break;

        default:
            throw new ReferenceError('expresion not defined or not supported');
            break;
    }
};

/**
 * Use this function for where clause any array or object property
 * var persons = [{ name: 'foo', age: 1 }, { name: 'bar', age: 2 }];
 * returns an array with one element:
 * var result1 = persons.where({ age: 1, name: 'foo' });
 * @param {any} filter
 */
Array.prototype.where = function (filter) {
    var collection = this;
    switch (typeof filter) {
        case 'function':
            return $.grep(collection, filter);
        case 'object':
            for (var property in filter) {
                if (!filter.hasOwnProperty(property))
                    continue;

                collection = $.grep(collection, function (item) {
                    return item[property] === filter[property];
                });
            }
            return collection.slice(0);

        default:
            throw new TypeError('function must be either a function or an object of properties and values to filter by');
    }
};

/**
 * Use this function get first values from collection
 * returns the first matching item in the array, or null if no match
 * var result2 = persons.firstOrDefault({ age: 1, name: 'foo' });
 * @param {any} func
 */
Array.prototype.firstOrDefault = function (func) {
    return this.where(func)[0] || null;
};

/**
 * Use this function for array collection to sum values
 **/

Array.prototype.sum = function () {
    return (!this.length) ? 0 : this.slice(1).sum() +
        ((typeof this[0] == 'number') ? this[0] : 0);
};





