using Alliant.DalLayer;
using Alliant.Domain;
using System;
using System.Collections.Generic;

namespace Alliant.Manager
{

    public class AreaManagementManager : DALProvider,IAreaManagementManager
    {
        IAreaManagementDAL oAreaManagementDal = null;

        public AreaManagementManager()
        {
            oAreaManagementDal = DALUserManagement.AreaManagementDAL;           
        }

        public virtual AreaManagement Create()
        {
            return new AreaManagement();
        }

        public virtual AreaManagement CreatePost(AreaManagement oAreaManagement)
        {
            oAreaManagement.CreatedOn = DateTime.Now;
            oAreaManagement.UpdatedOn = oAreaManagement.CreatedOn;
            oAreaManagementDal.CreateAreaManagement(oAreaManagement);
            return oAreaManagement;
        }

        public virtual AreaManagement Edit(int Id)
        {
            return oAreaManagementDal.GetAreaManagementById(Id);
        }

        public virtual AreaManagement EditPost(AreaManagement oAreaManagement)
        {
            oAreaManagement.UpdatedOn = DateTime.Now;
            oAreaManagementDal.UpdateAreaManagement(oAreaManagement);
            return oAreaManagement;
        }

        public virtual AreaManagement Delete(int Id)
        {
            return oAreaManagementDal.GetAreaManagementById(Id);
        }

        public virtual int DeletePost(int Id)
        {
            return oAreaManagementDal.DeleteAreaManagement(Id);
        }

        public virtual AreaManagement GetAreaManagementById(int Id)
        {
            return oAreaManagementDal.GetAreaManagementById(Id);
        }

        /*public virtual IEnumerable<AreaManagement> GetAllAreaManagement(Search_AreaManagementModel oAreaManagement)
    	{
    		return oAreaManagementDal.GetAreaManagementBySearch(oAreaManagement);
    	}*/

        public virtual IEnumerable<AreaManagement> GetAllAreaManagement(GridSearchModel oGridSearchModel)
        {
            return oAreaManagementDal.GetAreaManagementBySearch(oGridSearchModel);
        }
    }
}
