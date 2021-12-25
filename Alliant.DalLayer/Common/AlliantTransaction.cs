using System.Data.Common;

namespace Alliant.DalLayer
{
    public class AlliantTransaction : DataClassesDataContext
    {
        DbTransaction _transaction = null;

        public AlliantTransaction()
        {

        }

        public void BeginTransaction()
        {
            this.Connection.Open();
            _transaction = this.Connection.BeginTransaction();
            this.Transaction = _transaction;
        }

        public void Commit()
        {
            _transaction.Commit();
            //this.Transaction.Commit();
            this.Connection.Close();
        }

        public void Rollback()
        {
            _transaction.Rollback();
            ///this.Transaction.Rollback();
            this.Connection.Close();
        }
    }
}
