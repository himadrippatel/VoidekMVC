using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;
using System.Linq;

namespace Alliant.DalLayer
{
    public class PrimaryActivityDAL : CommonDAL, IPrimaryActivityDAL
    {
        public virtual int CreatePrimaryActivity(PrimaryActivity oPrimaryActivity)
        {
            int? oResultID = 0;
            int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_PrimaryActivity_Insert(ref oResultID, oPrimaryActivity.RoleID, oPrimaryActivity.PermissionID, oPrimaryActivity.ActivityName, oPrimaryActivity.IsActive, oPrimaryActivity.CreatedOn, oPrimaryActivity.CreatedBy);
            oPrimaryActivity.PrimaryActivityID = (int)oResultID;
            return Result;
        }

        public virtual int DeletePrimaryActivity(int Id)
        {
            int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_PrimaryActivity_Delete(Id);
            return oResult;
        }

        public virtual IEnumerable<PrimaryActivity> GetPrimaryActivityBySearch(GridSearchModel oGridSearchModel)
        {
            int? oResultCount = 0;
            var oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_PrimaryActivity_Search(ref oResultCount, oGridSearchModel.Page, oGridSearchModel.PageSize, oGridSearchModel.Filter, oGridSearchModel.SortOrder);
            oGridSearchModel.ResultCount = oResultCount;
            return oResult;
        }

        public SelectViewModel GetPrimaryActivitySelectViewModels(SearchRequest searchRequest)
        {
            SelectViewModel selectViewModel = new SelectViewModel();
            int? oResultCount = 0;
            selectViewModel.items = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_PrimaryActivity_Select(searchRequest.search, searchRequest.page, searchRequest.pageResult,searchRequest.notIn, ref oResultCount).ToList();
            selectViewModel.total_count = oResultCount;
            return selectViewModel;
        }

        public virtual IEnumerable<AutoCompleteViewModel> GetPrimaryActivitySuggestion(string search)
        {
            return _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_PrimaryActivity_Suggestion(search);
        }
    }
}
