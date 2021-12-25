using Alliant.Domain;
using System.Collections.Generic;

namespace Alliant.DalLayer
{
    public interface IAuthorizationDAL : IDALBase
    {
        List<SecondaryActivity> GetUserActivities(int UserID);
        List<SecondaryActivity> GetUserParentActivity(string ActivityIDs);
    }
}
