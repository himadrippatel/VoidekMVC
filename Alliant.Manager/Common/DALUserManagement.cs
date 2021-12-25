using Alliant.DalLayer;

namespace Alliant.Manager
{
    public class DALUserManagement
    {
        public virtual AccountDAL AccountDAL
        {
            get
            {
                return new AccountDAL();
            }
        }

        public virtual AreaManagementDAL AreaManagementDAL
        {
            get
            {
                return new AreaManagementDAL();
            }
        }

        public virtual MenuDAL MenuDAL
        {
            get
            {
                return new MenuDAL();
            }
        }

        public virtual ChildMenuDAL ChildMenuDAL
        {
            get
            {
                return new ChildMenuDAL();
            }
        }

        public virtual RoleDAL RoleDAL
        {
            get
            {
                return new RoleDAL();
            }
        }

        public virtual SessionDAL SessionDAL
        {
            get
            {
                return new SessionDAL();
            }
        }

        public virtual PermissionDAL PermissionDAL
        {
            get
            {
                return new PermissionDAL();
            }
        }

        public virtual RoleVsUserDAL RoleVsUserDAL
        {
            get { return new RoleVsUserDAL(); }
        }

        public virtual PrimaryActivityDAL PrimaryActivityDAL { get { return new PrimaryActivityDAL(); } }
        public virtual SecondaryActivityDAL SecondaryActivityDAL { get { return new SecondaryActivityDAL(); } }
        public virtual AuthorizationDAL AuthorizationDAL { get { return new AuthorizationDAL(); } }
        public virtual ActivityVsUserDAL ActivityVsUserDAL { get { return new ActivityVsUserDAL(); } }
        public virtual RoleVsActivityDAL RoleVsActivityDAL { get { return new RoleVsActivityDAL(); } }
    }
}
