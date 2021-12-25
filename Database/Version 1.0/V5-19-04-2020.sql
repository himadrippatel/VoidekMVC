USE [alliant_mvc]
CREATE TABLE [dbo].[UM_RoleVsActivity](
	[RoleVsActivityID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[ActivityID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_UM_RoleVsActivity] PRIMARY KEY CLUSTERED 
(
	[RoleVsActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UM_RoleVsActivity] ADD  CONSTRAINT [DF_UM_RoleVsActivity_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO


/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-04-19-- Description : Delete Procedure for UM_RoleVsActivity-- Exec [dbo].[spr_tb_UM_RoleVsActivity_Delete] @RoleVsActivityID  int    -- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_UM_RoleVsActivity_Delete]     @RoleVsActivityID  int    ASBEGIN    DELETE FROM [dbo].[UM_RoleVsActivity]    WHERE [RoleVsActivityID] = @RoleVsActivityIDEND/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-04-19-- Description : Insert Procedure for UM_RoleVsActivity-- Exec [dbo].[spr_tb_UM_RoleVsActivity_Insert] [RoleID],[ActivityID],[IsActive],[CreatedOn],[CreatedBy]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_UM_RoleVsActivity_Insert]     @ResultID INT OUTPUT    ,@RoleID  int    ,@ActivityID  int    ,@IsActive  bit    ,@CreatedOn  datetime = NULL    ,@CreatedBy  nvarchar(50) = NULL    ASBEGIN    INSERT INTO [dbo].[UM_RoleVsActivity]    (          [RoleID]        ,[ActivityID]        ,[IsActive]        ,[CreatedOn]        ,[CreatedBy]            )    VALUES    (         @RoleID        ,@ActivityID        ,@IsActive        ,@CreatedOn        ,@CreatedBy            )    SELECT @ResultID=SCOPE_IDENTITY();END


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-04-19
-- Description : Select Procedure for UM_RoleVsActivity
-- Exec [dbo].[spr_tb_UM_RoleVsActivity_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_RoleVsActivity_Search]
     @ResultCount INT OUTPUT
    ,@Page INT = NULL
    ,@PageSize INT = NULL
    ,@Filter NVARCHAR(MAX) = NULL
    ,@SortOrder VARCHAR(MAX) = NULL
AS
BEGIN

    DECLARE @Query NVARCHAR(MAX)='', @TempQuery NVARCHAR(MAX)=''
    DECLARE @WhereClause NVARCHAR(MAX)=''

	SET @Query = 'SELECT [RA].*,[Role].[Name]  [RoleName],[PrimaryActivity].[ActivityName]
				FROM [dbo].[UM_RoleVsActivity] [RA] WITH(NOLOCK)
				INNER JOIN [dbo].[UM_Role] [Role] WITH(NOLOCK)
				ON [Role].[RoleID] = [RA].[RoleID]
				INNER JOIN [dbo].[UM_PrimaryActivity] [PrimaryActivity] WITH(NOLOCK)
				ON [PrimaryActivity].[PrimaryActivityID] = [RA].[ActivityID]'

    IF @Filter <> ''
    BEGIN
        SET @TempQuery=' WHERE '+@Filter
        SET @WhereClause = @TempQuery
    END

    IF @SortOrder <> ''
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' ORDER BY '+@SortOrder)
    END
    ELSE
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' ORDER BY 1 DESC')
    END

    IF NOT (@Page IS NULL OR @PageSize IS NULL)
    BEGIN
        DECLARE @ResultOutput TABLE (out int)
        DECLARE @CountQuery NVARCHAR(MAX)= CONCAT('SELECT COUNT(1) FROM(',@Query,') AS [ResultCount] ',@WhereClause)
        INSERT INTO @ResultOutput EXECUTE SP_EXECUTESQL @CountQuery
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END

    IF @TempQuery = ''
    BEGIN
    SET @Query=CONCAT('SELECT  * FROM (',@Query,') AS [Result]')
        EXECUTE SP_EXECUTESQL @Query
    END
    ELSE
    BEGIN
    SET @Query=CONCAT('SELECT * FROM (',@Query,') AS [Result] ',@TempQuery)
        
        EXECUTE SP_EXECUTESQL @Query
    END

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_RoleVsActivity]  (NOLOCK)  END
END

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,12-04-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UM_Role_Select]	
	@Search NVARCHAR(100),
	@Page INT = NULL,
	@PageSize INT = NULL,
	@NotIN VARCHAR(100) = NULL,
	@ResultCount INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
		SET @Page = ISNULL(@Page,1);
		SET @PageSize = ISNULL(@PageSize,10);

		SELECT 		
		CONVERT(VARCHAR,[Role].[RoleID]) [id]
		,[Role].[Name] [full_name]
		,[Role].[Name] [name]
		FROM [dbo].[UM_Role] [Role] WITH(NOLOCK) 
		WHERE [Role].[Name] LIKE '%'+@Search+'%'
		AND (ISNULL(@NotIN,'') = '' OR [Role].[RoleID] NOT IN(SELECT Item FROM [dbo].[CustomeSplit](@NotIN,',')))
		ORDER BY [Role].[Name] ASC
		OFFSET (@PageSize * (@Page - 1)) ROWS
		FETCH NEXT @PageSize ROWS ONLY

		SELECT  
		@ResultCount = COUNT(1)
		FROM [dbo].[UM_Role] [Role] WITH(NOLOCK) 
		WHERE [Role].[Name] LIKE '%'+@Search+'%'  
		AND (ISNULL(@NotIN,'') = '' OR [Role].[RoleID] NOT IN(SELECT Item FROM [dbo].[CustomeSplit](@NotIN,',')))
END






/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-04-19
-- Description : Select Procedure for UM_RoleVsActivity
-- Exec [dbo].[spr_tb_UM_RoleVsActivity_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_RoleVsActivity_Search]
     @ResultCount INT OUTPUT
    ,@Page INT = NULL
    ,@PageSize INT = NULL
    ,@Filter NVARCHAR(MAX) = NULL
    ,@SortOrder VARCHAR(MAX) = NULL
AS
BEGIN

    DECLARE @Query NVARCHAR(MAX)='', @TempQuery NVARCHAR(MAX)=''
    DECLARE @WhereClause NVARCHAR(MAX)=''

	SET @Query = 'SELECT [RA].*,[Role].[Name]  [RoleName],[PrimaryActivity].[ActivityName]
				FROM [dbo].[UM_RoleVsActivity] [RA] WITH(NOLOCK)
				INNER JOIN [dbo].[UM_Role] [Role] WITH(NOLOCK)
				ON [Role].[RoleID] = [RA].[RoleID]
				INNER JOIN [dbo].[UM_PrimaryActivity] [PrimaryActivity] WITH(NOLOCK)
				ON [PrimaryActivity].[PrimaryActivityID] = [RA].[ActivityID]'

    IF @Filter <> ''
    BEGIN
        SET @TempQuery=' WHERE '+@Filter
        SET @WhereClause = @TempQuery
    END

    IF @SortOrder <> ''
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' ORDER BY '+@SortOrder)
    END
    ELSE
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' ORDER BY 1 DESC')
    END

    IF NOT (@Page IS NULL OR @PageSize IS NULL)
    BEGIN
        DECLARE @ResultOutput TABLE (out int)
        DECLARE @CountQuery NVARCHAR(MAX)= CONCAT('SELECT COUNT(1) FROM(',@Query,') AS [ResultCount] ',@WhereClause)
        INSERT INTO @ResultOutput EXECUTE SP_EXECUTESQL @CountQuery
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END

    IF @TempQuery = ''
    BEGIN
    SET @Query=CONCAT('SELECT  * FROM (',@Query,') AS [Result]')
        EXECUTE SP_EXECUTESQL @Query
    END
    ELSE
    BEGIN
    SET @Query=CONCAT('SELECT * FROM (',@Query,') AS [Result] ',@TempQuery)
        
        EXECUTE SP_EXECUTESQL @Query
    END

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_RoleVsActivity]  (NOLOCK)  END
END




/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-04-15
-- Description : Select Procedure for UM_ActivityVsUser
-- Exec [dbo].[spr_tb_UM_ActivityVsUser_Search]
-- ============================================= */
ALTER PROCEDURE [dbo].[spr_tb_UM_ActivityVsUser_Search]
     @ResultCount INT OUTPUT
    ,@Page INT = NULL
    ,@PageSize INT = NULL
    ,@Filter NVARCHAR(MAX) = NULL
    ,@SortOrder VARCHAR(MAX) = NULL
AS
BEGIN

    DECLARE @Query NVARCHAR(MAX)='', @TempQuery NVARCHAR(MAX)=''
    DECLARE @WhereClause NVARCHAR(MAX)=''

	SET @Query = 'SELECT [AU].[UserActivityID]
        ,[AU].[ActivityID]
        ,[AU].[UserID]
        ,[AU].[IsActive]
        ,[AU].[CreatedOn]
        ,[AU].[CreatedBy]
		,[PA].[ActivityName]
		,[Customer].[CustName] [CustomerName]
         FROM [dbo].[UM_ActivityVsUser] [AU] WITH(NOLOCK)
		INNER JOIN [dbo].[UM_PrimaryActivity] [PA] WITH(NOLOCK)
		ON [PA].[PrimaryActivityID] = [AU].[ActivityID]
		INNER JOIN [dbo].[tblCustomers] [Customer] WITH(NOLOCK)
		ON [Customer].[CustID] = [AU].[UserID]'

    IF @Filter <> ''
    BEGIN
        SET @TempQuery=' WHERE '+@Filter
        SET @WhereClause = @TempQuery
    END

    IF @SortOrder <> ''
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' ORDER BY '+@SortOrder)
    END
    ELSE
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' ORDER BY 1 DESC')
    END

    IF NOT (@Page IS NULL OR @PageSize IS NULL)
    BEGIN
        DECLARE @ResultOutput TABLE (out int)
        DECLARE @CountQuery NVARCHAR(MAX)='SELECT COUNT(1) FROM ('+@Query+') AS [ResultCount]' + @WhereClause
        INSERT INTO @ResultOutput EXECUTE SP_EXECUTESQL @CountQuery
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END

    IF @TempQuery = ''
    BEGIN
    SET @Query= CONCAT('SELECT * FROM (',@Query,') AS [Result]')
        EXECUTE SP_EXECUTESQL @Query
    END
    ELSE
    BEGIN
		SET @Query= CONCAT('SELECT * FROM (',@Query,') AS [Result] ',@TempQuery)
		EXECUTE SP_EXECUTESQL @Query
    END

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_ActivityVsUser]  (NOLOCK)  END
END



