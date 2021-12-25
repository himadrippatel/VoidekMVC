using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Alliant.Core
{
    public class _DBProvider
    {
        private static SqlConnection _sqlConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["AlliantConnection"].ConnectionString);

        public static int ExecuteQuery(string spr_Name, CommandType commandType, List<SqlParameter> parameters)
        {
            int result = 0;
            try
            {
                SqlCommand _Command = _sqlConnection.CreateCommand();
                _Command.CommandType = commandType;
                _Command.CommandText = spr_Name;
                if (parameters != null && parameters.Count > 0)
                    _Command.Parameters.AddRange(parameters.ToArray());
                _sqlConnection.Open();
                result = _Command.ExecuteNonQuery();
                _sqlConnection.Close();

            }
            catch (Exception ex)
            {
                _sqlConnection.Close();
                throw ex;
            }
            return result;
        }
        public static int ExecuteQuery(string spr_Name, CommandType commandType)
        {
            int result = 0;
            try
            {
                SqlCommand _Command = _sqlConnection.CreateCommand();
                _Command.CommandType = commandType;
                _Command.CommandText = spr_Name;

                _sqlConnection.Open();
                result = _Command.ExecuteNonQuery();
                _sqlConnection.Close();

            }
            catch (Exception ex)
            {
                _sqlConnection.Close();
                throw ex;
            }
            return result;
        }
        public static DataSet GetDataSet(string spr_Name, CommandType commandType, List<SqlParameter> parameters)
        {
            DataSet _dataSet = new DataSet();
            try
            {
                SqlCommand _Command = _sqlConnection.CreateCommand();
                _Command.CommandType = commandType;
                _Command.CommandText = spr_Name;
                if (parameters != null && parameters.Count > 0)
                    _Command.Parameters.AddRange(parameters.ToArray());

                _sqlConnection.Open();
                SqlDataAdapter da = new SqlDataAdapter(_Command);
                da.Fill(_dataSet);
                _sqlConnection.Close();

            }
            catch (Exception ex)
            {
                _sqlConnection.Close();
                throw ex;
            }
            return _dataSet;
        }
        public static DataSet GetDataSet(string spr_Name, CommandType commandType)
        {
            DataSet _dataSet = new DataSet();
            try
            {
                SqlCommand _Command = _sqlConnection.CreateCommand();
                _Command.CommandType = commandType;
                _Command.CommandText = spr_Name;

                _sqlConnection.Open();
                SqlDataAdapter da = new SqlDataAdapter(_Command);
                da.Fill(_dataSet);
                _sqlConnection.Close();

            }
            catch (Exception ex)
            {
                _sqlConnection.Close();
                throw ex;
            }
            return _dataSet;
        }
        public static DataTable GetDataTable(string spr_Name, CommandType commandType, List<SqlParameter> parameters)
        {
            DataTable _dataTable = new DataTable();
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["AlliantConnection"].ConnectionString))
                {
                    sqlConnection.Open();
                    using (SqlCommand sqlCommand = sqlConnection.CreateCommand())
                    {
                        if (parameters != null && parameters.Count > 0)
                            sqlCommand.Parameters.AddRange(parameters.ToArray());

                        sqlCommand.CommandText = spr_Name;
                        sqlCommand.CommandType = commandType;
                        sqlCommand.CommandTimeout = 500;
                        using (SqlDataAdapter da = new SqlDataAdapter(sqlCommand))
                        {
                            da.Fill(_dataTable);
                        }
                    }
                }
            }
            catch (Exception ex)
            {              
                throw ex;
            }
            return _dataTable;
        }
        public static DataTable GetDataTable(string spr_Name, CommandType commandType)
        {
            DataTable _dataTable = new DataTable();
            try
            {
                SqlCommand _Command = _sqlConnection.CreateCommand();
                _Command.CommandType = commandType;
                _Command.CommandText = spr_Name;            
                _sqlConnection.Open();
                SqlDataAdapter da = new SqlDataAdapter(_Command);
                da.Fill(_dataTable);
                _sqlConnection.Close();

            }
            catch (Exception ex)
            {
                _sqlConnection.Close();
                throw ex;
            }
            return _dataTable;
        }
        public static object ExecuteScalar(string spr_Name, CommandType commandType, List<SqlParameter> parameters)
        {
            object _object = new object();
            try
            {
                SqlCommand _Command = _sqlConnection.CreateCommand();
                _Command.CommandType = commandType;
                _Command.CommandText = spr_Name;
                if (parameters != null && parameters.Count > 0)
                    _Command.Parameters.AddRange(parameters.ToArray());

                _sqlConnection.Open();
                _object = _Command.ExecuteScalar();
                _sqlConnection.Close();

            }
            catch (Exception ex)
            {
                _sqlConnection.Close();
                throw ex;
            }
            return _object;
        }
        public static object ExecuteScalar(string spr_Name, CommandType commandType)
        {
            object _object = new object();
            try
            {
                SqlCommand _Command = _sqlConnection.CreateCommand();
                _Command.CommandType = commandType;
                _Command.CommandText = spr_Name;

                _sqlConnection.Open();
                _object = _Command.ExecuteScalar();
                _sqlConnection.Close();

            }
            catch (Exception ex)
            {
                _sqlConnection.Close();
                throw ex;
            }
            return _object;
        }

        public static SqlConnection GetSqlConnection()
        {
            return _sqlConnection;
        }
    }
}
