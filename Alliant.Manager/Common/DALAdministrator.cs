using Alliant.DalLayer;

namespace Alliant.Manager
{
    public class DALAdministrator
    {
        public virtual IconDAL IconDAL { get { return new IconDAL(); } }
    }
}
