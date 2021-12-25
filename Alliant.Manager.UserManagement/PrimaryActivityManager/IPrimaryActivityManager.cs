using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface IPrimaryActivityManager : IRootManager
    {
        PrimaryActivity Create();
        PrimaryActivity CreatePost(PrimaryActivity oPrimaryActivity);  
    	int DeletePost(int Id);    	   
    	IEnumerable<PrimaryActivity> GetAllPrimaryActivity(GridSearchModel oGridSearchModel);
        IEnumerable<AutoCompleteViewModel> GetPrimaryActivitySuggestion(string search);
        SelectViewModel GetPrimaryActivitySelectViewModels(SearchRequest searchRequest);
    }
}
