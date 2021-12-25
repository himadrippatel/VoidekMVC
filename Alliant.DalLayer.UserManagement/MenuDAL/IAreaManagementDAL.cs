using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface IAreaManagementDAL : IDALBase
    {
        int CreateAreaManagement(AreaManagement oAreaManagement);
        int UpdateAreaManagement(AreaManagement oAreaManagement);
    	int DeleteByModelAreaManagement(AreaManagement oAreaManagement);
    	int DeleteAreaManagement(int Id);
    	AreaManagement GetAreaManagementById(int Id);
        //IEnumerable<AreaManagement> GetAreaManagementBySearch(Search_AreaManagementModel oSearch_AreaManagementModel);  
    	IEnumerable<AreaManagement> GetAreaManagementBySearch(GridSearchModel oGridSearchModel);
    }
}
