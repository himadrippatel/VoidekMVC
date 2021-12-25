using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface IActivityVsUserManager : IRootManager
    {
        ActivityVsUser Create();
        bool CreatePost(ActivityVsUserViewModel activityVsUserViewModel); 
    	int DeletePost(int Id);    
    	IEnumerable<ActivityVsUser> GetAllActivityVsUser(GridSearchModel oGridSearchModel);   
    }
}
