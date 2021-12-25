using Alliant.Domain;
using System.Data.Linq;
using System.Reflection;

namespace Alliant.DalLayer
{
    public class StoreProcedureAdministrator : DataClassesDataContext
    {
        #region ICon
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_AM_ICon_Delete")]
        public int spr_tb_AM_ICon_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IconID", DbType = "Int")] System.Nullable<int> iconID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iconID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_AM_ICon_Update")]
        public int spr_tb_AM_ICon_Update([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IconID", DbType = "Int")] System.Nullable<int> iconID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ICon", DbType = "VarChar(100)")] string iCon, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IconName", DbType = "VarChar(100)")] string iconName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iconID, iCon, iconName, isActive, createdOn, createdBy);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_AM_ICon_GetByID")]
        public ISingleResult<Icon> spr_tb_AM_ICon_GetByID([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IconID", DbType = "Int")] System.Nullable<int> iconID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iconID);
            return ((ISingleResult<Icon>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_AM_ICon_Insert")]
        public int spr_tb_AM_ICon_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ICon", DbType = "VarChar(100)")] string iCon, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IconName", DbType = "VarChar(100)")] string iconName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, iCon, iconName, isActive, createdOn, createdBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_AM_ICon_Search")]
        public ISingleResult<Icon> spr_tb_AM_ICon_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<Icon>)(result.ReturnValue));
        }
        #endregion
    }
}
