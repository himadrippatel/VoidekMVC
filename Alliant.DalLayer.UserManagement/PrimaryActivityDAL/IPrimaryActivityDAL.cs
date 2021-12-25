using Alliant.Domain;
using Alliant.ViewModel;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface IPrimaryActivityDAL : IDALBase
    {
        int CreatePrimaryActivity(PrimaryActivity oPrimaryActivity);      
    	int DeletePrimaryActivity(int Id);
        IEnumerable<PrimaryActivity> GetPrimaryActivityBySearch(GridSearchModel oGridSearchModel);
        IEnumerable<AutoCompleteViewModel> GetPrimaryActivitySuggestion(string search);
        SelectViewModel GetPrimaryActivitySelectViewModels(SearchRequest searchRequest);
    }
}
