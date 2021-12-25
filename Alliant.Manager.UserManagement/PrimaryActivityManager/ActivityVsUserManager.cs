using Alliant.DalLayer;
using Alliant.Domain;
using Alliant.ViewModel;
using System;
using System.Collections.Generic;
using System.Transactions;

namespace Alliant.Manager
{

    public class ActivityVsUserManager : DALProvider, IActivityVsUserManager
    {
        IActivityVsUserDAL oActivityVsUserDal = null;

        public ActivityVsUserManager()
        {
            oActivityVsUserDal = DALUserManagement.ActivityVsUserDAL;
        }

        public virtual ActivityVsUser Create()
        {
            return new ActivityVsUser();
        }

        public virtual bool CreatePost(ActivityVsUserViewModel activityVsUserViewModel)
        {
            //oActivityVsUserDal.CreateActivityVsUser(oActivityVsUser);
            //return oActivityVsUser;
            using (TransactionScope transaction = new TransactionScope())
            {
                try
                {
                    if (activityVsUserViewModel.UserIDs != null && activityVsUserViewModel.UserIDs.Length > 0)
                    {
                        string[] activityIDs = activityVsUserViewModel.ActivityIDs.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        if (activityIDs != null && activityIDs.Length > 0)
                        {
                            foreach (int userid in activityVsUserViewModel.UserIDs)
                            {
                                foreach (string activityID in activityIDs)
                                {                                    
                                    oActivityVsUserDal.CreateActivityVsUser(new ActivityVsUser()
                                    {
                                        CreatedOn = DateTime.Now,
                                        ActivityID = Convert.ToInt32(activityID),
                                        UserID = userid,
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
            return oActivityVsUserDal.DeleteActivityVsUser(Id);
        }

        public virtual IEnumerable<ActivityVsUser> GetAllActivityVsUser(GridSearchModel oGridSearchModel)
        {
            return oActivityVsUserDal.GetActivityVsUserBySearch(oGridSearchModel);
        }
    }
}
