using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{
    public class SecondaryActivityDAL : CommonDAL, ISecondaryActivityDAL
    {
        public virtual int CreateSecondaryActivity(SecondaryActivity oSecondaryActivity)
        {
            int? oResultID = 0;
            int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_SecondaryActivity_Insert(ref oResultID, oSecondaryActivity.PrimaryActivityID, oSecondaryActivity.ActivityID, oSecondaryActivity.CreatedOn, oSecondaryActivity.CreatedBy);
            oSecondaryActivity.SecondaryActivityID = (int)oResultID;
            return Result;
        }

        public virtual int DeleteSecondaryActivity(int Id)
        {
            int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_SecondaryActivity_Delete(Id);
            return oResult;
        }

        public virtual IEnumerable<SecondaryActivity> GetSecondaryActivityBySearch(GridSearchModel oGridSearchModel)
        {
            int? oResultCount = 0;
            var oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_SecondaryActivity_Search(ref oResultCount, oGridSearchModel.Page, oGridSearchModel.PageSize, oGridSearchModel.Filter, oGridSearchModel.SortOrder);
            oGridSearchModel.ResultCount = oResultCount;
            return oResult;
        }
    }
}
