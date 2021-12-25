using Alliant.Domain;
using Alliant.ViewModel;
using System.Data.Linq;
using System.Reflection;

namespace Alliant.DalLayer
{
    public class StoreProcedureUserManagement : DataClassesDataContext
    {
        #region Account
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UserLogin")]
        public virtual ISingleResult<UserLogin> spr_tb_UserLogin([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserName", DbType = "NVarChar(250)")] string userName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Password", DbType = "VarChar(250)")] string password)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userName, password);
            return ((ISingleResult<UserLogin>)(result.ReturnValue));
        }
        #endregion

        #region Session
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_at_UserSession_Insert")]
        public ISingleResult<UserSession> spr_at_UserSession_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SessionData", DbType = "VarChar(MAX)")] string sessionData, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Token", DbType = "VarChar(40)")] string token)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userID, sessionData, token);
            return ((ISingleResult<UserSession>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_at_UserSession")]
        public ISingleResult<UserSession> spr_at_UserSession([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Toekn", DbType = "VarChar(40)")] string toekn)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userID, toekn);
            return ((ISingleResult<UserSession>)(result.ReturnValue));
        }
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_at_UserSessionByToken")]
        public ISingleResult<UserSession> spr_at_UserSessionByToken([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Toekn", DbType = "VarChar(40)")] string toekn)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), toekn);
            return ((ISingleResult<UserSession>)(result.ReturnValue));
        }
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_at_UserSession_Delete")]
        public int spr_at_UserSession_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Token", DbType = "VarChar(40)")] string token)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userID, token);
            return ((int)(result.ReturnValue));
        }
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_at_IsSuperAdmin")]
        public ISingleResult<AdminResult> spr_at_IsSuperAdmin([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userID);
            return ((ISingleResult<AdminResult>)(result.ReturnValue));
        }
        #endregion

        #region Role

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_Insert")]
        public int spr_tb_UM_Role_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Name", DbType = "NVarChar(250)")] string name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID", DbType = "Int")] System.Nullable<int> parentID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ProcessingDateTime", DbType = "DateTime2")] System.Nullable<System.DateTime> processingDateTime)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, name, parentID, isActive, createdOn, createdBy, updatedOn, updatedBy, processingDateTime);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_SearchAll")]
        public ISingleResult<Role> spr_tb_UM_Role_SearchAll(
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID_Values", DbType = "NVarChar(MAX)")] string roleID_Values,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID_Min", DbType = "Int")] System.Nullable<int> roleID_Min,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID_Max", DbType = "Int")] System.Nullable<int> roleID_Max,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Name", DbType = "NVarChar(250)")] string name,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Name_Values", DbType = "NVarChar(MAX)")] string name_Values,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID_Values", DbType = "NVarChar(MAX)")] string parentID_Values,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID_Min", DbType = "Int")] System.Nullable<int> parentID_Min,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID_Max", DbType = "Int")] System.Nullable<int> parentID_Max,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn_Values", DbType = "NVarChar(MAX)")] string createdOn_Values,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn_Min", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn_Min,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn_Max", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn_Max,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy_Values", DbType = "NVarChar(MAX)")] string createdBy_Values,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn_Values", DbType = "NVarChar(MAX)")] string updatedOn_Values,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn_Min", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn_Min,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn_Max", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn_Max,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy_Values", DbType = "NVarChar(MAX)")] string updatedBy_Values,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page_Size", DbType = "Int")] System.Nullable<int> page_Size,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page_Index", DbType = "Int")] System.Nullable<int> page_Index,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Sort_Column", DbType = "NVarChar(250)")] string sort_Column,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Sort_Ascending", DbType = "Bit")] System.Nullable<bool> sort_Ascending,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsBinaryRequired", DbType = "Bit")] System.Nullable<bool> isBinaryRequired,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsPrimaryIN", DbType = "Bit")] System.Nullable<bool> isPrimaryIN)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, roleID_Values, roleID_Min, roleID_Max, name, name_Values, parentID_Values, parentID_Min, parentID_Max, isActive, createdOn_Values, createdOn_Min, createdOn_Max, createdBy, createdBy_Values, updatedOn_Values, updatedOn_Min, updatedOn_Max, updatedBy, updatedBy_Values, page_Size, page_Index, sort_Column, sort_Ascending, isBinaryRequired, isPrimaryIN);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<Role>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_Update")]
        public int spr_tb_UM_Role_Update([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Name", DbType = "NVarChar(250)")] string name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID", DbType = "Int")] System.Nullable<int> parentID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ProcessingDateTime", DbType = "DateTime2")] System.Nullable<System.DateTime> processingDateTime)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), roleID, name, parentID, isActive, createdOn, createdBy, updatedOn, updatedBy, processingDateTime);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_DropdwonHierarchy")]
        public ISingleResult<HierarchicalViewModel> spr_tb_UM_Role_DropdwonHierarchy([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ID", DbType = "Int")] System.Nullable<int> iD)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iD);
            return ((ISingleResult<HierarchicalViewModel>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_Delete")]
        public int spr_tb_UM_Role_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), roleID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_GetByID")]
        public ISingleResult<Role> spr_tb_UM_Role_GetByID([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), roleID);
            return ((ISingleResult<Role>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_SearchAll_V2")]
        public ISingleResult<Role> spr_tb_UM_Role_SearchAll_V2([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<Role>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_Hierarchy")]
        public ISingleResult<Role> spr_tb_UM_Role_Hierarchy([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ID", DbType = "Int")] System.Nullable<int> iD)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iD);
            return ((ISingleResult<Role>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Role_Select")]
        public ISingleResult<SelectResultViewModel> spr_tb_UM_Role_Select([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Search", DbType = "NVarChar(100)")] string search, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "NotIN", DbType = "VarChar(100)")] string notIN, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), search, page, pageSize, notIN, resultCount);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(4)));
            return ((ISingleResult<SelectResultViewModel>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Permission_Delete")]
        public int spr_tb_UM_Permission_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PermissionID", DbType = "Int")] System.Nullable<int> permissionID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), permissionID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Permission_GetByID")]
        public ISingleResult<Permission> spr_tb_UM_Permission_GetByID([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PermissionID", DbType = "Int")] System.Nullable<int> permissionID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), permissionID);
            return ((ISingleResult<Permission>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Permission_Insert")]
        public int spr_tb_UM_Permission_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Name", DbType = "NVarChar(250)")] string name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID", DbType = "Int")] System.Nullable<int> parentID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, name, roleID, parentID, isActive, createdOn, createdBy, updatedOn, updatedBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Permission_Search")]
        public ISingleResult<Permission> spr_tb_UM_Permission_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<Permission>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Permission_Update")]
        public int spr_tb_UM_Permission_Update([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PermissionID", DbType = "Int")] System.Nullable<int> permissionID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Name", DbType = "NVarChar(250)")] string name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID", DbType = "Int")] System.Nullable<int> parentID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), permissionID, name, roleID, parentID, isActive, createdOn, createdBy, updatedOn, updatedBy);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_RoleVsUser_Delete")]
        public int spr_tb_UM_RoleVsUser_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleVsUserID", DbType = "Int")] System.Nullable<int> roleVsUserID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), roleVsUserID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_RoleVsUser_Update")]
        public int spr_tb_UM_RoleVsUser_Update([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleVsUserID", DbType = "Int")] System.Nullable<int> roleVsUserID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "StartDate", DbType = "DateTime")] System.Nullable<System.DateTime> startDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ExpiryDate", DbType = "DateTime")] System.Nullable<System.DateTime> expiryDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), roleVsUserID, roleID, userID, startDate, expiryDate, createdOn, createdBy, updatedOn, updatedBy);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_RoleVsUser_GetByID")]
        public ISingleResult<RoleVsUser> spr_tb_UM_RoleVsUser_GetByID([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleVsUserID", DbType = "Int")] System.Nullable<int> roleVsUserID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), roleVsUserID);
            return ((ISingleResult<RoleVsUser>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_RoleVsUser_Insert")]
        public int spr_tb_UM_RoleVsUser_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "StartDate", DbType = "DateTime")] System.Nullable<System.DateTime> startDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ExpiryDate", DbType = "DateTime")] System.Nullable<System.DateTime> expiryDate, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, roleID, userID, startDate, expiryDate, createdOn, createdBy, updatedOn, updatedBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_RoleVsUser_Search")]
        public ISingleResult<RoleVsUser> spr_tb_UM_RoleVsUser_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<RoleVsUser>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_tblCustomers_AutoComplete")]
        public ISingleResult<AutoCompleteViewModel> spr_tb_tblCustomers_AutoComplete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Search", DbType = "NVarChar(100)")] string search, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "NotIn", DbType = "NVarChar(250)")] string notIn)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), search, notIn);
            return ((ISingleResult<AutoCompleteViewModel>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_tblCustomers_Select")]
        public ISingleResult<SelectResultViewModel> spr_tb_tblCustomers_Select([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Search", DbType = "NVarChar(100)")] string search, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), search, page, pageSize, resultCount);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(3)));
            return ((ISingleResult<SelectResultViewModel>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_RoleVsActivity_Delete")]
        public int spr_tb_UM_RoleVsActivity_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleVsActivityID", DbType = "Int")] System.Nullable<int> roleVsActivityID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), roleVsActivityID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_RoleVsActivity_Search")]
        public ISingleResult<RoleVsActivity> spr_tb_UM_RoleVsActivity_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<RoleVsActivity>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_RoleVsActivity_Insert")]
        public int spr_tb_UM_RoleVsActivity_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityID", DbType = "Int")] System.Nullable<int> activityID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, roleID, activityID, isActive, createdOn, createdBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        #endregion

        #region Menu
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_AreaManagement_Delete")]
        public int spr_tb_UM_AreaManagement_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "AreaID", DbType = "Int")] System.Nullable<int> areaID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), areaID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_AreaManagement_Update")]
        public int spr_tb_UM_AreaManagement_Update([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "AreaID", DbType = "Int")] System.Nullable<int> areaID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Name", DbType = "VarChar(250)")] string name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityName", DbType = "VarChar(250)")] string activityName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), areaID, name, activityName, isActive, createdOn, createdBy, updatedOn, updatedBy);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_AreaManagement_GetByID")]
        public ISingleResult<AreaManagement> spr_tb_UM_AreaManagement_GetByID([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "AreaID", DbType = "Int")] System.Nullable<int> areaID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), areaID);
            return ((ISingleResult<AreaManagement>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_AreaManagement_Insert")]
        public int spr_tb_UM_AreaManagement_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Name", DbType = "VarChar(250)")] string name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityName", DbType = "VarChar(250)")] string activityName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, name, activityName, isActive, createdOn, createdBy, updatedOn, updatedBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_AreaManagement_Search")]
        public ISingleResult<AreaManagement> spr_tb_UM_AreaManagement_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<AreaManagement>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Menu_Delete")]
        public int spr_tb_UM_Menu_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "MenuID", DbType = "Int")] System.Nullable<int> menuID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), menuID);
            return ((int)(result.ReturnValue));
        }
                
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Menu_GetByID")]
        public ISingleResult<Menu> spr_tb_UM_Menu_GetByID([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "MenuID", DbType = "Int")] System.Nullable<int> menuID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), menuID);
            return ((ISingleResult<Menu>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Menu_Update")]
        public int spr_tb_UM_Menu_Update([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "MenuID", DbType = "Int")] System.Nullable<int> menuID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "AreaID", DbType = "Int")] System.Nullable<int> areaID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "LinkText", DbType = "NVarChar(250)")] string linkText, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Description", DbType = "NVarChar(MAX)")] string description, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActionName", DbType = "VarChar(100)")] string actionName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ControllerName", DbType = "VarChar(100)")] string controllerName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "HtmlAttributes", DbType = "VarChar(MAX)")] string htmlAttributes, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RouteData", DbType = "VarChar(MAX)")] string routeData, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Sequance", DbType = "Int")] System.Nullable<int> sequance, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityName", DbType = "VarChar(250)")] string activityName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), menuID, areaID, linkText, description, isActive, actionName, controllerName, htmlAttributes, routeData, sequance, activityName, createdOn, createdBy, updatedOn, updatedBy);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Menu_Insert")]
        public int spr_tb_UM_Menu_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "AreaID", DbType = "Int")] System.Nullable<int> areaID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "LinkText", DbType = "NVarChar(250)")] string linkText, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Description", DbType = "NVarChar(MAX)")] string description, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActionName", DbType = "VarChar(100)")] string actionName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ControllerName", DbType = "VarChar(100)")] string controllerName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "HtmlAttributes", DbType = "VarChar(MAX)")] string htmlAttributes, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RouteData", DbType = "VarChar(MAX)")] string routeData, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Sequance", DbType = "Int")] System.Nullable<int> sequance, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityName", DbType = "VarChar(250)")] string activityName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, areaID, linkText, description, isActive, actionName, controllerName, htmlAttributes, routeData, sequance, activityName, createdOn, createdBy, updatedOn, updatedBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Menu_Search")]
        public ISingleResult<Menu> spr_tb_UM_Menu_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<Menu>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_Menu_UpdateSequance")]
        public int spr_tb_UM_Menu_UpdateSequance([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "MenuID", DbType = "Int")] System.Nullable<int> menuID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Sequance", DbType = "Int")] System.Nullable<int> sequance)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), menuID, sequance);
            return ((int)(result.ReturnValue));
        }

       
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ChildMenu_UpdateSequance")]
        public int spr_tb_UM_ChildMenu_UpdateSequance([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SubMenuID", DbType = "Int")] System.Nullable<int> subMenuID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Sequance", DbType = "Int")] System.Nullable<int> sequance)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), subMenuID, sequance);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ChildMenu_Delete")]
        public int spr_tb_UM_ChildMenu_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SubMenuID", DbType = "Int")] System.Nullable<int> subMenuID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), subMenuID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ChildMenu_Update")]
        public int spr_tb_UM_ChildMenu_Update(
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SubMenuID", DbType = "Int")] System.Nullable<int> subMenuID,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "MenuID", DbType = "Int")] System.Nullable<int> menuID,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID", DbType = "Int")] System.Nullable<int> parentID,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "LinkText", DbType = "NVarChar(250)")] string linkText,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Description", DbType = "NVarChar(MAX)")] string description,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActionName", DbType = "VarChar(100)")] string actionName,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ControllerName", DbType = "VarChar(100)")] string controllerName,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "HtmlAttributes", DbType = "VarChar(MAX)")] string htmlAttributes,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RouteData", DbType = "VarChar(MAX)")] string routeData,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Sequance", DbType = "Int")] System.Nullable<int> sequance,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityName", DbType = "VarChar(250)")] string activityName,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), subMenuID, menuID, parentID, linkText, description, actionName, controllerName, htmlAttributes, routeData, isActive, sequance, activityName, createdOn, createdBy, updatedOn, updatedBy);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ChildMenu_GetByID")]
        public ISingleResult<ChildMenu> spr_tb_UM_ChildMenu_GetByID([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SubMenuID", DbType = "Int")] System.Nullable<int> subMenuID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), subMenuID);
            return ((ISingleResult<ChildMenu>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ChildMenu_Insert")]
        public int spr_tb_UM_ChildMenu_Insert(
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "MenuID", DbType = "Int")] System.Nullable<int> menuID,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ParentID", DbType = "Int")] System.Nullable<int> parentID,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "LinkText", DbType = "NVarChar(250)")] string linkText,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Description", DbType = "NVarChar(MAX)")] string description,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActionName", DbType = "VarChar(100)")] string actionName,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ControllerName", DbType = "VarChar(100)")] string controllerName,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "HtmlAttributes", DbType = "VarChar(MAX)")] string htmlAttributes,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RouteData", DbType = "VarChar(MAX)")] string routeData,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Sequance", DbType = "Int")] System.Nullable<int> sequance,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityName", DbType = "VarChar(250)")] string activityName,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> updatedOn,
                    [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UpdatedBy", DbType = "NVarChar(50)")] string updatedBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, menuID, parentID, linkText, description, actionName, controllerName, htmlAttributes, routeData, isActive, sequance, activityName, createdOn, createdBy, updatedOn, updatedBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ChildMenu_Search")]
        public ISingleResult<ChildMenu> spr_tb_UM_ChildMenu_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<ChildMenu>)(result.ReturnValue));
        }
        #endregion

        #region PrimaryActivity
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_PrimaryActivity_Delete")]
        public int spr_tb_UM_PrimaryActivity_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PrimaryActivityID", DbType = "Int")] System.Nullable<int> primaryActivityID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), primaryActivityID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_PrimaryActivity_Insert")]
        public int spr_tb_UM_PrimaryActivity_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "RoleID", DbType = "Int")] System.Nullable<int> roleID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PermissionID", DbType = "Int")] System.Nullable<int> permissionID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityName", DbType = "NVarChar(250)")] string activityName, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, roleID, permissionID, activityName, isActive, createdOn, createdBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_SecondaryActivity_Delete")]
        public int spr_tb_UM_SecondaryActivity_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SecondaryActivityID", DbType = "Int")] System.Nullable<int> secondaryActivityID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), secondaryActivityID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_SecondaryActivity_Insert")]
        public int spr_tb_UM_SecondaryActivity_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PrimaryActivityID", DbType = "Int")] System.Nullable<int> primaryActivityID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityID", DbType = "Int")] System.Nullable<int> activityID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, primaryActivityID, activityID, createdOn, createdBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_SecondaryActivity_Search")]
        public ISingleResult<SecondaryActivity> spr_tb_UM_SecondaryActivity_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<SecondaryActivity>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_PrimaryActivity_Search")]
        public ISingleResult<PrimaryActivity> spr_tb_UM_PrimaryActivity_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<PrimaryActivity>)(result.ReturnValue));
        }
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_PrimaryActivity_Suggestion")]
        public ISingleResult<AutoCompleteViewModel> spr_tb_UM_PrimaryActivity_Suggestion([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Search", DbType = "VarChar(50)")] string search)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), search);
            return ((ISingleResult<AutoCompleteViewModel>)(result.ReturnValue));
        }
        
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_PrimaryActivity_Select")]
        public ISingleResult<SelectResultViewModel> spr_tb_UM_PrimaryActivity_Select([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Search", DbType = "NVarChar(100)")] string search, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "NotIN", DbType = "VarChar(100)")] string notIN, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), search, page, pageSize, notIN, resultCount);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(4)));
            return ((ISingleResult<SelectResultViewModel>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ActivityVsUser_Delete")]
        public int spr_tb_UM_ActivityVsUser_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserActivityID", DbType = "Int")] System.Nullable<int> userActivityID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userActivityID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ActivityVsUser_Search")]
        public ISingleResult<ActivityVsUser> spr_tb_UM_ActivityVsUser_Search([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultCount", DbType = "Int")] ref System.Nullable<int> resultCount, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Page", DbType = "Int")] System.Nullable<int> page, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "PageSize", DbType = "Int")] System.Nullable<int> pageSize, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Filter", DbType = "NVarChar(MAX)")] string filter, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SortOrder", DbType = "VarChar(MAX)")] string sortOrder)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultCount, page, pageSize, filter, sortOrder);
            resultCount = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((ISingleResult<ActivityVsUser>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_ActivityVsUser_Insert")]
        public int spr_tb_UM_ActivityVsUser_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ActivityID", DbType = "Int")] System.Nullable<int> activityID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsActive", DbType = "Bit")] System.Nullable<bool> isActive, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, activityID, userID, isActive, createdOn, createdBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }
        #endregion

        #region Favorite Menu
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_FavoriteMenu_GetBy")]
        public ISingleResult<FavoriteMenu> spr_tb_UM_FavoriteMenu_GetBy([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userID);
            return ((ISingleResult<FavoriteMenu>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_FavoriteMenu_Insert")]
        public int spr_tb_UM_FavoriteMenu_Insert([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "LinkText", DbType = "NVarChar(MAX)")] string linkText, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "LinkHref", DbType = "NVarChar(MAX)")] string linkHref, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "MenuID", DbType = "Int")] System.Nullable<int> menuID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SubMenuID", DbType = "Int")] System.Nullable<int> subMenuID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsFavorite", DbType = "Bit")] System.Nullable<bool> isFavorite, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, userID, linkText, linkHref, menuID, subMenuID, isFavorite, createdOn, createdBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_FavoriteMenu_GetByUserID")]
        public ISingleResult<FavoriteMenu> spr_tb_UM_FavoriteMenu_GetByUserID([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), userID);
            return ((ISingleResult<FavoriteMenu>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_FavoriteMenu_Delete")]
        public int spr_tb_UM_FavoriteMenu_Delete([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "FavoriteMenuID", DbType = "Int")] System.Nullable<int> favoriteMenuID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), favoriteMenuID, userID);
            return ((int)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.spr_tb_UM_FavoriteMenu_InsertRecent")]
        public int spr_tb_UM_FavoriteMenu_InsertRecent([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ResultID", DbType = "Int")] ref System.Nullable<int> resultID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "UserID", DbType = "Int")] System.Nullable<int> userID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "LinkText", DbType = "NVarChar(MAX)")] string linkText, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "LinkHref", DbType = "NVarChar(MAX)")] string linkHref, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "MenuID", DbType = "Int")] System.Nullable<int> menuID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "SubMenuID", DbType = "Int")] System.Nullable<int> subMenuID, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "IsFavorite", DbType = "Bit")] System.Nullable<bool> isFavorite, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedOn", DbType = "DateTime")] System.Nullable<System.DateTime> createdOn, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "CreatedBy", DbType = "NVarChar(50)")] string createdBy)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), resultID, userID, linkText, linkHref, menuID, subMenuID, isFavorite, createdOn, createdBy);
            resultID = ((System.Nullable<int>)(result.GetParameterValue(0)));
            return ((int)(result.ReturnValue));
        }
        #endregion
    }
}
