namespace Alliant.DalLayer
{
    public class CommonDAL : DataClassesDataContext
    {
        //public virtual StoreProcedure _StoreProcedure
        //{
        //    get 
        //    {
        //        return new StoreProcedure();
        //    }
        //} 
        protected StoreProcedure _StoreProcedure = null;
        public CommonDAL()
        {
            _StoreProcedure = new StoreProcedure();
        }
    }
}
