using Alliant.DalLayer;
using Alliant.Domain;
using Alliant.ViewModel;
using System;
using System.Collections.Generic;
using System.Transactions;

namespace Alliant.Manager
{
    public class RoleVsActivityManager : DALProvider, IRoleVsActivityManager
    {
        IRoleVsActivityDAL oRoleVsActivityDal = null;

        public RoleVsActivityManager()
        {
            oRoleVsActivityDal = DALUserManagement.RoleVsActivityDAL;
        }

        public virtual RoleVsActivity Create()
        {
            return new RoleVsActivity();
        }

        public virtual bool CreatePost(RoleVsActivityViewModel roleVsActivityView)
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                try
                {
                    if (roleVsActivityView.RoleIDs != null && roleVsActivityView.RoleIDs.Length > 0)
                    {
                        string[] activityIDs = roleVsActivityView.ActivityIDs.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        if (activityIDs != null && activityIDs.Length > 0)
                        {
                            foreach (int roleID in roleVsActivityView.RoleIDs)
                            {
                                foreach (string activityID in activityIDs)
                                {
                                    oRoleVsActivityDal.CreateRoleVsActivity(new RoleVsActivity()
                                    {
                                        ActivityID = Convert.ToInt32(activityID),
                                        CreatedOn = DateTime.Now,
                                        RoleID = roleID,
                                        IsActive = true
                                    });
                                }
                            }
                        }
                    }
                    transaction.Complete();
                    return true;
                }
                catch (Exception ex)
                {
                    transaction.Dispose();
                    throw ex;
                }
            }
        }


        public virtual int DeletePost(int Id)
        {
            return oRoleVsActivityDal.DeleteRoleVsActivity(Id);
        }

        /*public virtual IEnumerable<RoleVsActivity> GetAllRoleVsActivity(Search_RoleVsActivityModel oRoleVsActivity)
    	{
    		return oRoleVsActivityDal.GetRoleVsActivityBySearch(oRoleVsActivity);
    	}*/

        public virtual IEnumerable<RoleVsActivity> GetAllRoleVsActivity(GridSearchModel oGridSearchModel)
        {
            return oRoleVsActivityDal.GetRoleVsActivityBySearch(oGridSearchModel);
        }
    }
}
