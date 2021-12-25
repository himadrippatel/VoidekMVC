namespace Alliant.Manager
{
    public class DALProvider
    {
        protected DALAdministrator DALAdministrator = null;
        protected DALUserManagement DALUserManagement = null;
        protected DALWeb DALWeb = null;
        public DALProvider()
        {
            DALAdministrator = new DALAdministrator();
            DALUserManagement = new DALUserManagement();
            DALWeb = new DALWeb();
        }
        //public DALAdministrator DALAdministrator
        //{
        //    get
        //    {
        //        return new DALAdministrator();
        //    }
        //}

        //public DALUserManagement DALUserManagement
        //{
        //    get
        //    {
        //        return new DALUserManagement();
        //    }
        //}
    }
}
