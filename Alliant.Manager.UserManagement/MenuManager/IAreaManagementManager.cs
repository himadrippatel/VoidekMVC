using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.Manager
{                      
    public interface IAreaManagementManager : IRootManager
    {
        AreaManagement Create();
        AreaManagement CreatePost(AreaManagement oAreaManagement);
    	AreaManagement Edit(int Id);
    	AreaManagement EditPost(AreaManagement oAreaManagement);
    	AreaManagement Delete(int Id);
    	int DeletePost(int Id);
    	AreaManagement GetAreaManagementById(int Id);
    	//IEnumerable<AreaManagement> GetAllAreaManagement(Search_AreaManagementModel oAreaManagement);   
    	IEnumerable<AreaManagement> GetAllAreaManagement(GridSearchModel oGridSearchModel);   
    }
}
