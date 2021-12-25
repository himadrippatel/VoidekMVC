using Alliant.DalLayer;
using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public class PrimaryActivityManager : DALProvider,IPrimaryActivityManager
    {
    	IPrimaryActivityDAL oPrimaryActivityDal =  null;  
    
    	public PrimaryActivityManager()
    	{
    		oPrimaryActivityDal = DALUserManagement.PrimaryActivityDAL;
    	}
    
    	public virtual PrimaryActivity Create()
    	{
    		return new PrimaryActivity();
    	}
    
        public virtual PrimaryActivity CreatePost(PrimaryActivity oPrimaryActivity)
    	{
            oPrimaryActivityDal.CreatePrimaryActivity(oPrimaryActivity);
    		return oPrimaryActivity;
    	}  

    	public virtual int DeletePost(int Id)
    	{
    		return oPrimaryActivityDal.DeletePrimaryActivity(Id);
    	}  

    	public virtual IEnumerable<PrimaryActivity> GetAllPrimaryActivity(GridSearchModel oGridSearchModel)
    	{
    		return oPrimaryActivityDal.GetPrimaryActivityBySearch(oGridSearchModel);
    	}

        public SelectViewModel GetPrimaryActivitySelectViewModels(SearchRequest searchRequest)
        {
            return oPrimaryActivityDal.GetPrimaryActivitySelectViewModels(searchRequest);
        }

        public virtual IEnumerable<AutoCompleteViewModel> GetPrimaryActivitySuggestion(string search)
        {
            return oPrimaryActivityDal.GetPrimaryActivitySuggestion(search);
        }
    }
}
