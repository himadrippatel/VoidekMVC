using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface IActivityVsUserDAL : IDALBase
    {
        int CreateActivityVsUser(ActivityVsUser oActivityVsUser);       
    	int DeleteActivityVsUser(int Id);          
    	IEnumerable<ActivityVsUser> GetActivityVsUserBySearch(GridSearchModel oGridSearchModel);
    }
}
