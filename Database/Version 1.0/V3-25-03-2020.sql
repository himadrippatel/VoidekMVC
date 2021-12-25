/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Delete]    Script Date: 25-03-2020 14:15:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-23
-- Description : Delete Procedure for UM_ColumnsVsSearchMaster
-- Exec [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Delete] @SearchColumnsID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Delete]
     @SearchColumnsID  int
    
AS
BEGIN

    DELETE FROM [dbo].[UM_ColumnsVsSearchMaster]
    WHERE [SearchColumnsID] = @SearchColumnsID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ColumnsVsSearchMaster_GetByID]    Script Date: 25-03-2020 14:15:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-23
-- Description : Select Procedure for UM_ColumnsVsSearchMaster
-- Exec [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ColumnsVsSearchMaster_GetByID]
     @SearchColumnsID  int
    
AS
BEGIN

    SELECT [SearchColumnsID]
        ,[SearchMasterID]
        ,[ColumnName]
        ,[OperationID]
        ,[Condition]
        ,[IsActive]
         FROM [dbo].[UM_ColumnsVsSearchMaster] WITH(NOLOCK)
    WHERE [SearchColumnsID] = @SearchColumnsID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Insert]    Script Date: 25-03-2020 14:15:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-23
-- Description : Insert Procedure for UM_ColumnsVsSearchMaster
-- Exec [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Insert] [SearchMasterID],[ColumnName],[OperationID],[Condition],[IsActive]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Insert]
     @ResultID INT OUTPUT
    ,@SearchMasterID  int
    ,@ColumnName  varchar(250)
    ,@OperationID  int = NULL
    ,@Condition  varchar(3) = NULL
    ,@IsActive  bit
    
AS
BEGIN

    INSERT INTO [dbo].[UM_ColumnsVsSearchMaster]
    ( 
         [SearchMasterID]
        ,[ColumnName]
        ,[OperationID]
        ,[Condition]
        ,[IsActive]
        
    )
    VALUES
    (
         @SearchMasterID
        ,@ColumnName
        ,@OperationID
        ,@Condition
        ,@IsActive
        
    )
    SELECT @ResultID=SCOPE_IDENTITY();
END



GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Search]    Script Date: 25-03-2020 14:15:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-23
-- Description : Select Procedure for UM_ColumnsVsSearchMaster
-- Exec [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Search]
     @ResultCount INT OUTPUT
    ,@Page INT = NULL
    ,@PageSize INT = NULL
    ,@Filter NVARCHAR(MAX) = NULL
    ,@SortOrder VARCHAR(MAX) = NULL
AS
BEGIN

    DECLARE @Query NVARCHAR(MAX)=NULL, @TempQuery NVARCHAR(MAX)=NULL
    DECLARE @WhereClause NVARCHAR(MAX)=NULL

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
        INSERT INTO @ResultOutput EXEC('SELECT COUNT(1) FROM [dbo].[UM_ColumnsVsSearchMaster]  (NOLOCK)  ' + @WhereClause)
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END

    SET @Query='SELECT [SearchColumnsID]
        ,[SearchMasterID]
        ,[ColumnName]
        ,[OperationID]
        ,[Condition]
        ,[IsActive]
         FROM [dbo].[UM_ColumnsVsSearchMaster] WITH(NOLOCK)'
        + @TempQuery
    EXEC(@Query)

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_ColumnsVsSearchMaster]  (NOLOCK)  END
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Update]    Script Date: 25-03-2020 14:15:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-23
-- Description : Update Procedure for UM_ColumnsVsSearchMaster
-- Exec [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Update] [SearchMasterID],[ColumnName],[OperationID],[Condition],[IsActive]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ColumnsVsSearchMaster_Update]
     @SearchColumnsID  int
    ,@SearchMasterID  int
    ,@ColumnName  varchar(250)
    ,@OperationID  int = NULL
    ,@Condition  varchar(3) = NULL
    ,@IsActive  bit
    
AS
BEGIN

    UPDATE [dbo].[UM_ColumnsVsSearchMaster]
    SET 
         [SearchMasterID] = @SearchMasterID
        ,[ColumnName] = @ColumnName
        ,[OperationID] = @OperationID
        ,[Condition] = @Condition
        ,[IsActive] = @IsActive
        
    WHERE [SearchColumnsID] = @SearchColumnsID

END


GO
/****** Object:  StoredProcedure [dbo].[spr_at_UM_HeaderSearchTemplate_Menu]    Script Date: 25-03-2020 14:16:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,25-03-2020>
-- Description:	<Description,-,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_at_UM_HeaderSearchTemplate_Menu]
	@Search NVARCHAR(250)
AS
BEGIN	
	SET NOCOUNT ON;
		SELECT 
		 [M].LinkText AS [ParentMenu]
		,dbo.fn_ParseHtmlText([M].LinkText) AS [ParentMenuText]
		,[CM].MenuID
		,[CM].ParentID
		,[CM].LinkText
		,dbo.fn_ParseHtmlText([CM].LinkText) AS [ChildLinkText]
		,[CM].Description
		,[CM].ActionName
		,[CM].ControllerName
		,[CM].IsActive
		,[CM].Sequance
		FROM [dbo].[UM_ChildMenu] [CM] WITH(NOLOCK)
		INNER JOIN [dbo].[UM_Menu] [M] WITH(NOLOCK) ON 
		[M].[MenuID] = [CM].[MenuID] 
		AND [M].[IsActive] = 1 
		AND [CM].[IsActive] = 1
		WHERE ( [M].LinkText  LIKE '%'+@Search+'%' OR 
				[CM].LinkText LIKE '%'+@Search+'%' OR 
				[CM].[ControllerName] LIKE '%'+@Search+'%' OR
				[CM].[ActionName] LIKE '%'+@Search+'%'
			  )
	SET NOCOUNT OFF;
END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_Delete]    Script Date: 25-03-2020 14:16:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-19
-- Description : Delete Procedure for UM_SearchMaster
-- Exec [dbo].[spr_tb_UM_SearchMaster_Delete] @SearchMasterID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_Delete]
     @SearchMasterID  int
    
AS
BEGIN
	BEGIN TRANSACTION [SearchMaster]
	BEGIN TRY
			
			DELETE FROM [dbo].[UM_ColumnsVsSearchMaster] 
			WHERE SearchMasterID = @SearchMasterID
			
			DELETE FROM [dbo].[UM_SearchMaster]
			WHERE [SearchMasterID] = @SearchMasterID
		
		COMMIT TRANSACTION [SearchMaster]
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION [SearchMaster]
		DECLARE @Message NVARCHAR(MAX)
		SELECT @Message = ERROR_MESSAGE()
		RAISERROR(@Message, 16, 1)
	END CATCH
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_SearchHeader]    Script Date: 25-03-2020 14:16:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,24-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_SearchHeader]
	@TableName VARCHAR(250) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	
	SELECT 
		SM.SearchMasterID,
		Sm.TableName,
		SM.DisplayName,
		CVSM.ColumnName,
		CVSM.SearchColumnsID,
		CVSM.Condition,
		CVSM.OperationID,
		OP.Expression,
		OP.OperationName,
		OP.SupportDataType
		FROM [dbo].[UM_SearchMaster] SM (NOLOCK)
		INNER JOIN [dbo].[UM_ColumnsVsSearchMaster] CVSM (NOLOCK)
		ON [CVSM].[SearchMasterID] = SM.SearchMasterID
		LEFT JOIN [dbo].[UM_Operation] OP (NOLOCK)
		ON [CVSM].OperationID = OP.OperationID
	WHERE (ISNULL(@TableName,'1') ='1' OR SM.TableName = @TableName)
	ORDER BY SM.TableName ASC
    
	SET NOCOUNT OFF;
END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_SearchHeaderText]    Script Date: 25-03-2020 14:16:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,24-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_SearchHeaderText]
	@Query NVARCHAR(MAX),
	@SearchText NVARCHAR(MAX) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	EXEC(@Query)
	SET NOCOUNT OFF;
END
GO


/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Operation_GetAll]    Script Date: 25-03-2020 14:17:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,23-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UM_Operation_GetAll]
	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT  
	 OperationID
	,OperationName
	,Expression
	,SupportDataType
	,IsActive
	,CreatedOn
	FROM [dbo].[UM_Operation] WITH(NOLOCK)
	SET NOCOUNT OFF;
END
GO

/****** Object:  UserDefinedFunction [dbo].[fn_ParseHtmlText]    Script Date: 25-03-2020 14:18:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_ParseHtmlText]
(
	@HtmlText NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @first INT, @last INT,@len INT
	SET @first = CHARINDEX('<',@HtmlText)
	SET @last = CHARINDEX('>',@HtmlText,CHARINDEX('<',@HtmlText))
	SET @len = (@last - @first) + 1
	
	WHILE @first > 0 AND @last > 0 AND @len > 0
	BEGIN
		SET @HtmlText = STUFF(@HtmlText,@first,@len,'')
		SET @first = CHARINDEX('<',@HtmlText)
		SET @last = CHARINDEX('>',@HtmlText,CHARINDEX('<',@HtmlText))
		SET @len = (@last - @first) + 1
	END
	
	RETURN LTRIM(RTRIM(@HtmlText))
END
GO

USE [Alliant]
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_Delete]    Script Date: 25-03-2020 19:55:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-19
-- Description : Delete Procedure for UM_SearchMaster
-- Exec [dbo].[spr_tb_UM_SearchMaster_Delete] @SearchMasterID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_Delete]
     @SearchMasterID  int
    
AS
BEGIN
	BEGIN TRANSACTION [SearchMaster]
	BEGIN TRY
			
			DELETE FROM [dbo].[UM_ColumnsVsSearchMaster] 
			WHERE SearchMasterID = @SearchMasterID
			
			DELETE FROM [dbo].[UM_SearchMaster]
			WHERE [SearchMasterID] = @SearchMasterID
		
		COMMIT TRANSACTION [SearchMaster]
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION [SearchMaster]
		DECLARE @Message NVARCHAR(MAX)
		SELECT @Message = ERROR_MESSAGE()
		RAISERROR(@Message, 16, 1)
	END CATCH
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_GetByID]    Script Date: 25-03-2020 19:55:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-19-- Description : Select Procedure for UM_SearchMaster-- Exec [dbo].[spr_tb_UM_SearchMaster_Search]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_GetByID]     @SearchMasterID  int    ASBEGIN    SELECT [SearchMasterID]        ,[TableName]        ,[DisplayName]        ,[Description]        ,[CreatedOn]        ,[CreatedBy]        ,[UpdatedOn]        ,[UpdatedBy]         FROM [dbo].[UM_SearchMaster] WITH(NOLOCK)    WHERE [SearchMasterID] = @SearchMasterIDEND
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_Insert]    Script Date: 25-03-2020 19:55:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-19-- Description : Insert Procedure for UM_SearchMaster-- Exec [dbo].[spr_tb_UM_SearchMaster_Insert] [TableName],[DisplayName],[Description],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_Insert]     @ResultID INT OUTPUT    ,@TableName  varchar(max)    ,@DisplayName  nvarchar(max)    ,@Description  nvarchar(max) = NULL    ,@CreatedOn  datetime = NULL    ,@CreatedBy  nvarchar(50) = NULL    ,@UpdatedOn  datetime = NULL    ,@UpdatedBy  nvarchar(50) = NULL    ASBEGIN    INSERT INTO [dbo].[UM_SearchMaster]    (          [TableName]        ,[DisplayName]        ,[Description]        ,[CreatedOn]        ,[CreatedBy]        ,[UpdatedOn]        ,[UpdatedBy]            )    VALUES    (         @TableName        ,@DisplayName        ,@Description        ,@CreatedOn        ,@CreatedBy        ,@UpdatedOn        ,@UpdatedBy            )    SELECT @ResultID=SCOPE_IDENTITY();END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_Search]    Script Date: 25-03-2020 19:55:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-19
-- Description : Select Procedure for UM_SearchMaster
-- Exec [dbo].[spr_tb_UM_SearchMaster_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_Search]
     @ResultCount INT OUTPUT
    ,@Page INT = NULL
    ,@PageSize INT = NULL
    ,@Filter NVARCHAR(MAX) = NULL
    ,@SortOrder VARCHAR(MAX) = NULL
AS
BEGIN
	  SET NOCOUNT ON;
	  DECLARE @Query NVARCHAR(MAX)=NULL, @TempQuery NVARCHAR(MAX)=NULL
	  DECLARE @WhereClause NVARCHAR(MAX)=NULL

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
        INSERT INTO @ResultOutput EXEC('SELECT COUNT(1) FROM [dbo].[UM_SearchMaster]  (NOLOCK)  ' + @WhereClause)
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END

	IF @TempQuery <> ''
	BEGIN
		 SET @Query='SELECT [SearchMasterID],[TableName],[DisplayName],[Description],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]
         FROM [dbo].[UM_SearchMaster] WITH(NOLOCK) ' + @TempQuery
    END
	ELSE
	BEGIN
	
		 SET @Query='SELECT [SearchMasterID],[TableName],[DisplayName],[Description],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]
         FROM [dbo].[UM_SearchMaster] WITH(NOLOCK) '
	END

	EXEC(@Query)
    --EXECUTE sp_executesql @Query

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_SearchMaster]  (NOLOCK)  END
	SET NOCOUNT OFF;

	--DECLARE @ID INT  = 1;
	--DECLARE @SQLQuery AS NVARCHAR(500);
	--SET @SQLQuery = 'SELECT * FROM [dbo].[UM_SearchMaster] WHERE SearchMasterID ='+ CAST(@ID AS NVARCHAR(10))
	--EXECUTE(@SQLQuery)

	--DECLARE @SQLQuery AS NVARCHAR(500)
	--DECLARE @ParameterDefinition AS NVARCHAR(100)	
	--SET @SQLQuery = 'SELECT * FROM [dbo].[UM_SearchMaster] WHERE  SearchMasterID = @p_Filter'
	--SET @ParameterDefinition =  '@p_Filter NVARCHAR(MAX)'
	--EXECUTE sp_executesql @SQLQuery, @ParameterDefinition, @Filter

	--IF (@SortOrder IS NULL) AND @PageSize IS NULL
	--BEGIN
	--	SET @Query = 'SELECT Id,Name,Code,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy FROM M_Branch  (NOLOCK)  ' + @WhereClause 
	--	EXEC(@Query)
	--END
	--ELSE
	--BEGIN
	--	SET @Query = 'SELECT Id,Name,Code,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy FROM M_Branch  (NOLOCK)  ' 
	--	EXEC(@Query)
	--END	
END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_SearchHeader]    Script Date: 25-03-2020 19:55:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,24-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_SearchHeader]
	@TableName VARCHAR(250) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	
	SELECT 
		SM.SearchMasterID,
		Sm.TableName,
		SM.DisplayName,
		CVSM.ColumnName,
		CVSM.SearchColumnsID,
		CVSM.Condition,
		CVSM.OperationID,
		OP.Expression,
		OP.OperationName,
		OP.SupportDataType
		FROM [dbo].[UM_SearchMaster] SM (NOLOCK)
		INNER JOIN [dbo].[UM_ColumnsVsSearchMaster] CVSM (NOLOCK)
		ON [CVSM].[SearchMasterID] = SM.SearchMasterID
		LEFT JOIN [dbo].[UM_Operation] OP (NOLOCK)
		ON [CVSM].OperationID = OP.OperationID
	WHERE (ISNULL(@TableName,'1') ='1' OR SM.TableName = @TableName)
	ORDER BY SM.TableName ASC
    
	SET NOCOUNT OFF;
END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_SearchMaster_SearchHeaderText]    Script Date: 25-03-2020 19:55:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,24-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_SearchHeaderText]
	@Query NVARCHAR(MAX),
	@SearchText NVARCHAR(MAX) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	EXEC(@Query)
	SET NOCOUNT OFF;
END
GO


SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-19-- Description : Update Procedure for UM_SearchMaster-- Exec [dbo].[spr_tb_UM_SearchMaster_Update] [TableName],[DisplayName],[Description],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_UM_SearchMaster_Update]     @SearchMasterID  int    ,@TableName  varchar(max)    ,@DisplayName  nvarchar(max)    ,@Description  nvarchar(max) = NULL    ,@CreatedOn  datetime = NULL    ,@CreatedBy  nvarchar(50) = NULL    ,@UpdatedOn  datetime = NULL    ,@UpdatedBy  nvarchar(50) = NULL    ASBEGIN    UPDATE [dbo].[UM_SearchMaster]    SET          [TableName] = @TableName        ,[DisplayName] = @DisplayName        ,[Description] = @Description        ,[CreatedOn] = @CreatedOn        ,[CreatedBy] = @CreatedBy        ,[UpdatedOn] = @UpdatedOn        ,[UpdatedBy] = @UpdatedBy            WHERE [SearchMasterID] = @SearchMasterIDEND
GO

/****** Object:  Table [dbo].[UM_ColumnsVsSearchMaster]    Script Date: 25-03-2020 19:59:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UM_ColumnsVsSearchMaster](
	[SearchColumnsID] [int] IDENTITY(1,1) NOT NULL,
	[SearchMasterID] [int] NOT NULL,
	[ColumnName] [varchar](250) NOT NULL,
	[OperationID] [int] NULL,
	[Condition] [varchar](3) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_UM_ColumnsVsSearchMaster] PRIMARY KEY CLUSTERED 
(
	[SearchColumnsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[UM_SearchMaster]    Script Date: 25-03-2020 19:59:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UM_SearchMaster](
	[SearchMasterID] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](max) NOT NULL,
	[DisplayName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_UM_SearchMaster] PRIMARY KEY CLUSTERED 
(
	[SearchMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[UM_ColumnsVsSearchMaster] ADD  CONSTRAINT [DF_UM_ColumnsVsSearchMaster_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[UM_SearchMaster] ADD  CONSTRAINT [DF_UM_SearchMaster_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO

