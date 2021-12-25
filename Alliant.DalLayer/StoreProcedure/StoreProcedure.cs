namespace Alliant.DalLayer
{
    public class StoreProcedure
    {
        // StoreProcedureUserManagement, StoreProcedureAdministrator
        //public StoreProcedureUserManagement StoreProcedureUserManagement
        //{
        //    get
        //    {
        //        return new StoreProcedureUserManagement();
        //    }
        //}

        //public StoreProcedureAdministrator StoreProcedureAdministrator
        //{
        //    get
        //    {
        //        return new StoreProcedureAdministrator();
        //    }
        //}
        public StoreProcedureUserManagement StoreProcedureUserManagement = null;
        public StoreProcedureAdministrator StoreProcedureAdministrator = null;
        public StoreProcedureWeb StoreProcedureWeb = null;
        public StoreProcedure()
        {
            StoreProcedureUserManagement = new StoreProcedureUserManagement();
            StoreProcedureAdministrator = new StoreProcedureAdministrator();
            StoreProcedureWeb = new StoreProcedureWeb();
        }
    }
}
