namespace Alliant.Domain
{
    public partial class spr_at_GetColumnNamesResult
    {

        private string _COLUMN_NAME;

        private System.Nullable<int> _ORDINAL_POSITION;

        private string _COLUMN_DEFAULT;

        private string _IS_NULLABLE;

        private System.Nullable<int> _CHARACTER_MAXIMUM_LENGTH;

        private System.Nullable<int> _CHARACTER_OCTET_LENGTH;

        private string _DATA_TYPE;

        private System.Nullable<byte> _NUMERIC_PRECISION;

        private System.Nullable<short> _NUMERIC_PRECISION_RADIX;

        private System.Nullable<int> _NUMERIC_SCALE;

        private string _COLLATION_NAME;

        public spr_at_GetColumnNamesResult()
        {
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_COLUMN_NAME", DbType = "NVarChar(128)")]
        public string COLUMN_NAME
        {
            get
            {
                return this._COLUMN_NAME;
            }
            set
            {
                if ((this._COLUMN_NAME != value))
                {
                    this._COLUMN_NAME = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_ORDINAL_POSITION", DbType = "Int")]
        public System.Nullable<int> ORDINAL_POSITION
        {
            get
            {
                return this._ORDINAL_POSITION;
            }
            set
            {
                if ((this._ORDINAL_POSITION != value))
                {
                    this._ORDINAL_POSITION = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_COLUMN_DEFAULT", DbType = "NVarChar(4000)")]
        public string COLUMN_DEFAULT
        {
            get
            {
                return this._COLUMN_DEFAULT;
            }
            set
            {
                if ((this._COLUMN_DEFAULT != value))
                {
                    this._COLUMN_DEFAULT = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_IS_NULLABLE", DbType = "VarChar(3)")]
        public string IS_NULLABLE
        {
            get
            {
                return this._IS_NULLABLE;
            }
            set
            {
                if ((this._IS_NULLABLE != value))
                {
                    this._IS_NULLABLE = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_CHARACTER_MAXIMUM_LENGTH", DbType = "Int")]
        public System.Nullable<int> CHARACTER_MAXIMUM_LENGTH
        {
            get
            {
                return this._CHARACTER_MAXIMUM_LENGTH;
            }
            set
            {
                if ((this._CHARACTER_MAXIMUM_LENGTH != value))
                {
                    this._CHARACTER_MAXIMUM_LENGTH = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_CHARACTER_OCTET_LENGTH", DbType = "Int")]
        public System.Nullable<int> CHARACTER_OCTET_LENGTH
        {
            get
            {
                return this._CHARACTER_OCTET_LENGTH;
            }
            set
            {
                if ((this._CHARACTER_OCTET_LENGTH != value))
                {
                    this._CHARACTER_OCTET_LENGTH = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_DATA_TYPE", DbType = "NVarChar(128)")]
        public string DATA_TYPE
        {
            get
            {
                return this._DATA_TYPE;
            }
            set
            {
                if ((this._DATA_TYPE != value))
                {
                    this._DATA_TYPE = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_NUMERIC_PRECISION", DbType = "TinyInt")]
        public System.Nullable<byte> NUMERIC_PRECISION
        {
            get
            {
                return this._NUMERIC_PRECISION;
            }
            set
            {
                if ((this._NUMERIC_PRECISION != value))
                {
                    this._NUMERIC_PRECISION = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_NUMERIC_PRECISION_RADIX", DbType = "SmallInt")]
        public System.Nullable<short> NUMERIC_PRECISION_RADIX
        {
            get
            {
                return this._NUMERIC_PRECISION_RADIX;
            }
            set
            {
                if ((this._NUMERIC_PRECISION_RADIX != value))
                {
                    this._NUMERIC_PRECISION_RADIX = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_NUMERIC_SCALE", DbType = "Int")]
        public System.Nullable<int> NUMERIC_SCALE
        {
            get
            {
                return this._NUMERIC_SCALE;
            }
            set
            {
                if ((this._NUMERIC_SCALE != value))
                {
                    this._NUMERIC_SCALE = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_COLLATION_NAME", DbType = "NVarChar(128)")]
        public string COLLATION_NAME
        {
            get
            {
                return this._COLLATION_NAME;
            }
            set
            {
                if ((this._COLLATION_NAME != value))
                {
                    this._COLLATION_NAME = value;
                }
            }
        }
    }

    public partial class spr_at_GetDatabaseTablesResult
    {

        private string _Name;

        private int _OBJECT_ID;

        private System.DateTime _CREATE_DATE;

        private System.DateTime _MODIFY_DATE;

        public spr_at_GetDatabaseTablesResult()
        {
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Name", DbType = "NVarChar(128) NOT NULL", CanBeNull = false)]
        public string Name
        {
            get
            {
                return this._Name;
            }
            set
            {
                if ((this._Name != value))
                {
                    this._Name = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_OBJECT_ID", DbType = "Int NOT NULL")]
        public int OBJECT_ID
        {
            get
            {
                return this._OBJECT_ID;
            }
            set
            {
                if ((this._OBJECT_ID != value))
                {
                    this._OBJECT_ID = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_CREATE_DATE", DbType = "DateTime NOT NULL")]
        public System.DateTime CREATE_DATE
        {
            get
            {
                return this._CREATE_DATE;
            }
            set
            {
                if ((this._CREATE_DATE != value))
                {
                    this._CREATE_DATE = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_MODIFY_DATE", DbType = "DateTime NOT NULL")]
        public System.DateTime MODIFY_DATE
        {
            get
            {
                return this._MODIFY_DATE;
            }
            set
            {
                if ((this._MODIFY_DATE != value))
                {
                    this._MODIFY_DATE = value;
                }
            }
        }
    }

    public partial class spr_tb_UM_SearchMaster_SearchHeaderResult
    {

        private int _SearchMasterID;

        private string _TableName;

        private string _DisplayName;

        private string _ColumnName;

        private int _SearchColumnsID;

        private string _Condition;

        private System.Nullable<int> _OperationID;

        private string _Expression;

        private string _OperationName;

        private string _SupportDataType;

        public spr_tb_UM_SearchMaster_SearchHeaderResult()
        {
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_SearchMasterID", DbType = "Int NOT NULL")]
        public int SearchMasterID
        {
            get
            {
                return this._SearchMasterID;
            }
            set
            {
                if ((this._SearchMasterID != value))
                {
                    this._SearchMasterID = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TableName", DbType = "VarChar(MAX) NOT NULL", CanBeNull = false)]
        public string TableName
        {
            get
            {
                return this._TableName;
            }
            set
            {
                if ((this._TableName != value))
                {
                    this._TableName = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_DisplayName", DbType = "NVarChar(MAX) NOT NULL", CanBeNull = false)]
        public string DisplayName
        {
            get
            {
                return this._DisplayName;
            }
            set
            {
                if ((this._DisplayName != value))
                {
                    this._DisplayName = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_ColumnName", DbType = "VarChar(250) NOT NULL", CanBeNull = false)]
        public string ColumnName
        {
            get
            {
                return this._ColumnName;
            }
            set
            {
                if ((this._ColumnName != value))
                {
                    this._ColumnName = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_SearchColumnsID", DbType = "Int NOT NULL")]
        public int SearchColumnsID
        {
            get
            {
                return this._SearchColumnsID;
            }
            set
            {
                if ((this._SearchColumnsID != value))
                {
                    this._SearchColumnsID = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Condition", DbType = "VarChar(3)")]
        public string Condition
        {
            get
            {
                return this._Condition;
            }
            set
            {
                if ((this._Condition != value))
                {
                    this._Condition = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_OperationID", DbType = "Int")]
        public System.Nullable<int> OperationID
        {
            get
            {
                return this._OperationID;
            }
            set
            {
                if ((this._OperationID != value))
                {
                    this._OperationID = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Expression", DbType = "VarChar(100)")]
        public string Expression
        {
            get
            {
                return this._Expression;
            }
            set
            {
                if ((this._Expression != value))
                {
                    this._Expression = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_OperationName", DbType = "VarChar(100)")]
        public string OperationName
        {
            get
            {
                return this._OperationName;
            }
            set
            {
                if ((this._OperationName != value))
                {
                    this._OperationName = value;
                }
            }
        }

        [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_SupportDataType", DbType = "VarChar(250)")]
        public string SupportDataType
        {
            get
            {
                return this._SupportDataType;
            }
            set
            {
                if ((this._SupportDataType != value))
                {
                    this._SupportDataType = value;
                }
            }
        }
    }
}
