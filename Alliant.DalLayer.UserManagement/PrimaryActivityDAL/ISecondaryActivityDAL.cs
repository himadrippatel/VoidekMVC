using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{                      
    public interface ISecondaryActivityDAL : IDALBase
    {
        int CreateSecondaryActivity(SecondaryActivity oSecondaryActivity);  
    	int DeleteSecondaryActivity(int Id);
        IEnumerable<SecondaryActivity> GetSecondaryActivityBySearch(GridSearchModel oGridSearchModel);
    }
}
