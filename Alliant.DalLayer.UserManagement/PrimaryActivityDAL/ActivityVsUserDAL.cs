using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{
    public class ActivityVsUserDAL : CommonDAL, IActivityVsUserDAL
    {
        public virtual int CreateActivityVsUser(ActivityVsUser oActivityVsUser)
        {
            int? oResultID = 0;
            int Result = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ActivityVsUser_Insert(ref oResultID, oActivityVsUser.ActivityID, oActivityVsUser.UserID, oActivityVsUser.IsActive, oActivityVsUser.CreatedOn, oActivityVsUser.CreatedBy);
            oActivityVsUser.UserActivityID = (int)oResultID;
            return Result;
        }

        public virtual int DeleteActivityVsUser(int Id)
        {
            int oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ActivityVsUser_Delete(Id);
            return oResult;
        }

        public virtual IEnumerable<ActivityVsUser> GetActivityVsUserBySearch(GridSearchModel oGridSearchModel)
        {
            int? oResultCount = 0;
            var oResult = _StoreProcedure.StoreProcedureUserManagement.spr_tb_UM_ActivityVsUser_Search(ref oResultCount, oGridSearchModel.Page, oGridSearchModel.PageSize, oGridSearchModel.Filter, oGridSearchModel.SortOrder);
            oGridSearchModel.ResultCount = oResultCount;
            return oResult;
        }
    }
}
