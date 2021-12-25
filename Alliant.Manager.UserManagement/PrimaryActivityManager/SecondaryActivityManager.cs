using Alliant.DalLayer;
using Alliant.Domain;
using Alliant.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;

namespace Alliant.Manager
{
    public class SecondaryActivityManager : DALProvider, ISecondaryActivityManager
    {
        ISecondaryActivityDAL oSecondaryActivityDal = null;

        public SecondaryActivityManager()
        {
            oSecondaryActivityDal = DALUserManagement.SecondaryActivityDAL;
        }

        public virtual SecondaryActivity Create()
        {
            return new SecondaryActivity();
        }

        public virtual bool CreatePost(SecondaryActivityViewModel secondaryActivityView)
        {
            using (TransactionScope transactiont = new TransactionScope())
            {
                try
                {
                    if (secondaryActivityView.SecondaryActivityIDs != null && secondaryActivityView.SecondaryActivityIDs.Length > 0)
                    {
                        foreach (int SecondaryActivityID in secondaryActivityView.SecondaryActivityIDs)
                        {
                            oSecondaryActivityDal.CreateSecondaryActivity(new SecondaryActivity()
                            {
                                CreatedOn = DateTime.Now,
                                PrimaryActivityID = secondaryActivityView.PrimaryActivityID,
                                ActivityID = SecondaryActivityID
                            });
                        }
                    }
                    transactiont.Complete();
                    return true;
                }
                catch (Exception ex)
                {
                    transactiont.Dispose();
                    throw ex;
                }
            }
        }

        public virtual int DeletePost(int Id)
        {
            return oSecondaryActivityDal.DeleteSecondaryActivity(Id);
        }

        public virtual IEnumerable<SecondaryActivity> GetAllSecondaryActivity(GridSearchModel oGridSearchModel)
        {
            return oSecondaryActivityDal.GetSecondaryActivityBySearch(oGridSearchModel);
        }
    }
}
