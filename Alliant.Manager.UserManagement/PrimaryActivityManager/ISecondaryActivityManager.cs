using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface ISecondaryActivityManager : IRootManager
    {
        SecondaryActivity Create();
        bool CreatePost(SecondaryActivityViewModel secondaryActivityView);    	
    	int DeletePost(int Id);    
    	IEnumerable<SecondaryActivity> GetAllSecondaryActivity(GridSearchModel oGridSearchModel);
    }
}
