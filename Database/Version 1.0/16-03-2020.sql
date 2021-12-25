USE [Alliant]
GO

/****** Object:  Table [dbo].[AM_Country]    Script Date: 16-03-2020 09:38:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AM_Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[ISO] [nvarchar](10) NULL,
	[ISO3] [nvarchar](15) NULL,
	[ISONumeric] [int] NULL,
	[CountryName] [nvarchar](250) NOT NULL,
	[Capital] [nvarchar](100) NOT NULL,
	[ContinentCode] [nvarchar](5) NULL,
	[CurrencyCode] [nvarchar](5) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AM_Country] ADD  CONSTRAINT [DF_AM_Country_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO

USE [Alliant]
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_Country_Delete]    Script Date: 16-03-2020 09:38:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-15-- Description : Delete Procedure for AM_Country-- Exec [dbo].[spr_tb_AM_Country_Delete] @CountryID  int    -- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_Country_Delete]     @CountryID  int    ASBEGIN    DELETE FROM [dbo].[AM_Country]    WHERE [CountryID] = @CountryIDEND
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_Country_GetByID]    Script Date: 16-03-2020 09:38:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-15-- Description : Select Procedure for AM_Country-- Exec [dbo].[spr_tb_AM_Country_Search]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_Country_GetByID]     @CountryID  int    ASBEGIN    SELECT [CountryID]        ,[ISO]        ,[ISO3]        ,[ISONumeric]        ,[CountryName]        ,[Capital]        ,[ContinentCode]        ,[CurrencyCode]        ,[CreatedOn]        ,[CreatedBy]        ,[UpdatedOn]        ,[UpdatedBy]         FROM [dbo].[AM_Country] WITH(NOLOCK)    WHERE [CountryID] = @CountryIDEND
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_Country_Insert]    Script Date: 16-03-2020 09:38:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-15-- Description : Insert Procedure for AM_Country-- Exec [dbo].[spr_tb_AM_Country_Insert] [ISO],[ISO3],[ISONumeric],[CountryName],[Capital],[ContinentCode],[CurrencyCode],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_Country_Insert]     @ResultID INT OUTPUT    ,@ISO  nvarchar(10) = NULL    ,@ISO3  nvarchar(15) = NULL    ,@ISONumeric  int = NULL    ,@CountryName  nvarchar(250)    ,@Capital  nvarchar(100)    ,@ContinentCode  nvarchar(5) = NULL    ,@CurrencyCode  nvarchar(5) = NULL    ,@CreatedOn  datetime = NULL    ,@CreatedBy  nvarchar(50) = NULL    ,@UpdatedOn  datetime = NULL    ,@UpdatedBy  nvarchar(50) = NULL    ASBEGIN    INSERT INTO [dbo].[AM_Country]    (          [ISO]        ,[ISO3]        ,[ISONumeric]        ,[CountryName]        ,[Capital]        ,[ContinentCode]        ,[CurrencyCode]        ,[CreatedOn]        ,[CreatedBy]        ,[UpdatedOn]        ,[UpdatedBy]            )    VALUES    (         @ISO        ,@ISO3        ,@ISONumeric        ,@CountryName        ,@Capital        ,@ContinentCode        ,@CurrencyCode        ,@CreatedOn        ,@CreatedBy        ,@UpdatedOn        ,@UpdatedBy            )    SELECT @ResultID=SCOPE_IDENTITY();END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_Country_Search]    Script Date: 16-03-2020 09:38:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-15
-- Description : Select Procedure for AM_Country
-- Exec [dbo].[spr_tb_AM_Country_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_AM_Country_Search]
     @ResultCount INT OUTPUT
    ,@Page INT = NULL
    ,@PageSize INT = NULL
    ,@Filter NVARCHAR(MAX) = NULL
    ,@SortOrder VARCHAR(MAX) = NULL
AS
BEGIN

    DECLARE @Query NVARCHAR(MAX)=NULL
    DECLARE @WhereClause NVARCHAR(MAX)=NULL
    SET @Query='SELECT [CountryID]
        ,[ISO]
        ,[ISO3]
        ,[ISONumeric]
        ,[CountryName]
        ,[Capital]
        ,[ContinentCode]
        ,[CurrencyCode]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
         FROM [dbo].[AM_Country] WITH(NOLOCK)'

    IF @Filter <> ''
    BEGIN
        SET @WhereClause=' WHERE '+@Filter
        SET @Query = CONCAT(@Query,@WhereClause)
    END

    IF @SortOrder <> ''
    BEGIN
        SET @Query = CONCAT(@Query,' ORDER BY '+@SortOrder)
    END
    ELSE
    BEGIN
        SET @Query = CONCAT(@Query,' ORDER BY 1 DESC')
    END

    IF NOT (@Page IS NULL OR @PageSize IS NULL)
    BEGIN
        DECLARE @ResultOutput TABLE (out int)
        INSERT INTO @ResultOutput EXEC('SELECT COUNT(1) FROM [dbo].[AM_Country]  (NOLOCK)  ' + @WhereClause)
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @Query = CONCAT(@Query,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY')
    END

    EXEC(@Query)

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[AM_Country]  (NOLOCK)  END
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_Country_Update]    Script Date: 16-03-2020 09:38:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-15-- Description : Update Procedure for AM_Country-- Exec [dbo].[spr_tb_AM_Country_Update] [ISO],[ISO3],[ISONumeric],[CountryName],[Capital],[ContinentCode],[CurrencyCode],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_Country_Update]     @CountryID  int    ,@ISO  nvarchar(10) = NULL    ,@ISO3  nvarchar(15) = NULL    ,@ISONumeric  int = NULL    ,@CountryName  nvarchar(250)    ,@Capital  nvarchar(100)    ,@ContinentCode  nvarchar(5) = NULL    ,@CurrencyCode  nvarchar(5) = NULL    ,@CreatedOn  datetime = NULL    ,@CreatedBy  nvarchar(50) = NULL    ,@UpdatedOn  datetime = NULL    ,@UpdatedBy  nvarchar(50) = NULL    ASBEGIN    UPDATE [dbo].[AM_Country]    SET          [ISO] = @ISO        ,[ISO3] = @ISO3        ,[ISONumeric] = @ISONumeric        ,[CountryName] = @CountryName        ,[Capital] = @Capital        ,[ContinentCode] = @ContinentCode        ,[CurrencyCode] = @CurrencyCode        ,[CreatedOn] = @CreatedOn        ,[CreatedBy] = @CreatedBy        ,[UpdatedOn] = @UpdatedOn        ,[UpdatedBy] = @UpdatedBy            WHERE [CountryID] = @CountryIDEND
USE [Alliant]
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Role_Delete]    Script Date: 16-03-2020 09:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[spr_tb_UM_Role_Delete]
@RoleID INT
AS
BEGIN 
SET NOCOUNT ON;

DELETE FROM UM_Role
 WHERE RoleID=@RoleID

SET NOCOUNT OFF;
END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Role_DropdwonHierarchy]    Script Date: 16-03-2020 09:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,14-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UM_Role_DropdwonHierarchy]
	@ID INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	;WITH TreeRole_CTE([ID], ParentID, Name,HasChildren) 
	AS (
		SELECT [RoleID], [ParentID],[Name],CONVERT(BIT,1) AS [HasChildren] 
		FROM [UM_Role] WITH(NOLOCK)
		WHERE [ParentID] IS NULL
		UNION ALL
		SELECT [UL].[RoleID],[UL].[ParentID],[UL].[Name],CONVERT(BIT,0) AS [HasChildren] 
		FROM [UM_Role] [UL] WITH(NOLOCK)
		JOIN TreeRole_CTE TREE ON [TREE].[ID] = [UL].[ParentID]
	)
	SELECT *
	FROM TreeRole_CTE
	WHERE ISNULL(ParentID,0) = ISNULL(@ID,0)
	ORDER BY [name]
END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Role_GetByID]    Script Date: 16-03-2020 09:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-15-- Description : Select Procedure for UM_Role-- Exec [dbo].[spr_tb_UM_Role_Search]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_UM_Role_GetByID]     @RoleID  int    ASBEGIN    SELECT [Name]        ,[ParentID]        ,[IsActive]        ,[CreatedOn]        ,[CreatedBy]        ,[UpdatedOn]        ,[UpdatedBy]        ,[RoleID]         FROM [dbo].[UM_Role] WITH(NOLOCK)    WHERE [RoleID] = @RoleIDEND
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Role_Insert]    Script Date: 16-03-2020 09:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[spr_tb_UM_Role_Insert]

@ResultID INT OUTPUT,
@Name nvarchar(250),
@ParentID int = NULL,
@IsActive bit= 1,
@CreatedOn datetime = NULL,
@CreatedBy nvarchar(50) = NULL,
@UpdatedOn datetime = NULL,
@UpdatedBy nvarchar(50) = NULL,
@ProcessingDateTime datetime2 = NULL


AS



SET NOCOUNT ON;

INSERT INTO UM_Role
(
Name,
ParentID,
IsActive,
CreatedOn,
CreatedBy,
UpdatedOn,
UpdatedBy
)
VALUES 
(
LTRIM(RTRIM(@Name)),
@ParentID,
@IsActive,
@ProcessingDateTime,
LTRIM(RTRIM(@CreatedBy)),
@ProcessingDateTime,
LTRIM(RTRIM(@CreatedBy))
)

 SELECT @ResultID=SCOPE_IDENTITY(); 
SET NOCOUNT OFF;

--------------------------------------------------

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Role_SearchAll]    Script Date: 16-03-2020 09:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[spr_tb_UM_Role_SearchAll]

@ResultCount INT OUTPUT,
@RoleID_Values nvarchar(max) = NULL,
@RoleID_Min int = NULL,
@RoleID_Max int = NULL,
@Name nvarchar(250) = NULL,
@Name_Values nvarchar(max) = NULL,
@ParentID_Values nvarchar(max) = NULL,
@ParentID_Min int = NULL,
@ParentID_Max int = NULL,
@IsActive bit = NULL,
@CreatedOn_Values nvarchar(max) = NULL,
@CreatedOn_Min datetime = NULL,
@CreatedOn_Max datetime = NULL,
@CreatedBy nvarchar(50) = NULL,
@CreatedBy_Values nvarchar(max) = NULL,
@UpdatedOn_Values nvarchar(max) = NULL,
@UpdatedOn_Min datetime = NULL,
@UpdatedOn_Max datetime = NULL,
@UpdatedBy nvarchar(50) = NULL,
@UpdatedBy_Values nvarchar(max) = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1



AS
DECLARE @WhereClause NVARCHAR(MAX)=''
DECLARE @Query NVARCHAR(MAX)=NULL
SET NOCOUNT ON;
SET @ResultCount = 0

IF @RoleID_Values IS NOT NULL 
BEGIN
	IF @RoleID_Values  = '###NULL###' SET @WhereClause = @WhereClause + ' RoleID IS NULL AND ' 
	ELSE IF @RoleID_Values = '' SET @WhereClause = @WhereClause + ' RoleID = '''' AND '
	ELSE IF @RoleID_Values <> '###NULL###' AND @IsPrimaryIN = 1 
	BEGIN
		IF @RoleID_Values LIKE 'SPPARM#%'
		BEGIN
			SET @RoleID_Values = (@RoleID_Values)
			SET @WhereClause = @WhereClause + 'RoleID IN ('+@RoleID_Values+') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@RoleID_Values) > 0 SET @WhereClause = @WhereClause + 'RoleID IN ('+@RoleID_Values+') AND '
			ELSE SET @WhereClause = @WhereClause + ' RoleID = '+@RoleID_Values+' AND '
		END
	END
	ELSE IF @RoleID_Values <> '###NULL###' AND @IsPrimaryIN = 0 
	BEGIN
		IF @RoleID_Values LIKE 'SPPARM#%'
		BEGIN
			SET @RoleID_Values = (@RoleID_Values)
			SET @WhereClause = @WhereClause + 'RoleID NOT IN ('+@RoleID_Values+') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@RoleID_Values) > 0 SET @WhereClause = @WhereClause + 'RoleID NOT IN ('+@RoleID_Values+') AND '
			ELSE SET @WhereClause = @WhereClause + ' RoleID != '+@RoleID_Values+' AND '
		END
	END
END
IF @Name IS NOT NULL 
BEGIN
	IF @Name = '###NULL###' SET @WhereClause = @WhereClause + ' Name IS NULL AND ' 
	ELSE IF @Name_Values = '' SET @WhereClause = @WhereClause + ' Name = '''' AND '
	ELSE
	BEGIN
		IF @Name LIKE '%''%' SET @Name = REPLACE(@Name,'''','''''')
		SET @WhereClause = @WhereClause + 'Name LIKE ''%'+@Name+'%'' AND '
	END
END
IF @Name_Values IS NOT NULL 
BEGIN
	IF @Name_Values = '###NULL###' SET @WhereClause = @WhereClause + ' Name IS NULL AND ' 
	ELSE IF @Name_Values = '' SET @WhereClause = @WhereClause + ' Name = '''' AND '
	ELSE
	BEGIN
		IF @Name_Values LIKE '%''%' SET @Name_Values = REPLACE(@Name_Values,'''','''''')
		IF @Name_Values LIKE 'SPPARM#%'
		BEGIN
			SET @Name_Values = (@Name_Values)
			SET @Name_Values = REPLACE(@Name_Values,',',''',''')
			SET @WhereClause = @WhereClause + ' Name IN ('''+@Name_Values+''') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@Name_Values) > 0
			BEGIN
				SET @Name_Values = REPLACE(@Name_Values,',',''',''')
				SET @WhereClause = @WhereClause + ' Name IN ('''+@Name_Values+''') AND '
			END
			ELSE SET @WhereClause = @WhereClause + ' Name = '''+@Name_Values+''' AND '
		END
	END
END
IF @ParentID_Values IS NOT NULL 
BEGIN
	IF @ParentID_Values = '###NULL###' SET @WhereClause = @WhereClause + ' ParentID IS NULL AND ' 
	ELSE IF @ParentID_Values = '' SET @WhereClause = @WhereClause + ' ParentID = '''' AND '
	ELSE
	BEGIN
		IF @ParentID_Values LIKE 'SPPARM#%'
		BEGIN
			SET @ParentID_Values = (@ParentID_Values)
			SET @WhereClause = @WhereClause + ' ParentID IN ('+@ParentID_Values+') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@ParentID_Values) > 0 SET @WhereClause = @WhereClause + ' ParentID IN ('+@ParentID_Values+') AND '
			ELSE SET @WhereClause = @WhereClause + ' ParentID = '+@ParentID_Values+' AND '
		END
	END
END
IF @ParentID_Min IS NOT NULL SET @WhereClause = @WhereClause + '(ParentID >= '+CONVERT(NVARCHAR(MAX),@ParentID_Min)+') AND '
IF @ParentID_Max IS NOT NULL SET @WhereClause = @WhereClause + '(ParentID <= '+CONVERT(NVARCHAR(MAX),@ParentID_Max)+') AND '
IF @IsActive IS NOT NULL SET @WhereClause = @WhereClause + ' IsActive = '+CONVERT(NVARCHAR(MAX),@IsActive)+'  AND ' 
IF @CreatedOn_Values IS NOT NULL 
BEGIN
	IF @CreatedOn_Values = '###NULL###' SET @WhereClause = @WhereClause + ' CreatedOn IS NULL AND ' 
	ELSE IF @CreatedOn_Values = '' SET @WhereClause = @WhereClause + ' CreatedOn = '''' AND '
	ELSE
	BEGIN
		IF @CreatedOn_Values LIKE 'SPPARM#%'
		BEGIN
			SET @CreatedOn_Values = (@CreatedOn_Values)
			SET @CreatedOn_Values = REPLACE(@CreatedOn_Values,',',''',''')
			SET @WhereClause = @WhereClause + ' CreatedOn IN ('''+@CreatedOn_Values+''') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@CreatedOn_Values) > 0
			BEGIN
				SET @CreatedOn_Values = REPLACE(@CreatedOn_Values,',',''',''')
				SET @WhereClause = @WhereClause + ' CreatedOn IN ('''+@CreatedOn_Values+''') AND '
			END
			ELSE SET @WhereClause = @WhereClause + ' CreatedOn = '''+@CreatedOn_Values+''' AND '
		END
	END
END
IF @CreatedOn_Min IS NOT NULL SET @WhereClause = @WhereClause + '(CreatedOn >= '''+CONVERT(NVARCHAR(MAX),@CreatedOn_Min,121)+''') AND '
IF @CreatedOn_Max IS NOT NULL SET @WhereClause = @WhereClause + '(CreatedOn <= '''+CONVERT(NVARCHAR(MAX),@CreatedOn_Max,121)+''') AND '
IF @CreatedBy IS NOT NULL 
BEGIN
	IF @CreatedBy = '###NULL###' SET @WhereClause = @WhereClause + ' CreatedBy IS NULL AND ' 
	ELSE IF @CreatedBy_Values = '' SET @WhereClause = @WhereClause + ' CreatedBy = '''' AND '
	ELSE
	BEGIN
		IF @CreatedBy LIKE '%''%' SET @CreatedBy = REPLACE(@CreatedBy,'''','''''')
		SET @WhereClause = @WhereClause + 'CreatedBy LIKE ''%'+@CreatedBy+'%'' AND '
	END
END
IF @CreatedBy_Values IS NOT NULL 
BEGIN
	IF @CreatedBy_Values = '###NULL###' SET @WhereClause = @WhereClause + ' CreatedBy IS NULL AND ' 
	ELSE IF @CreatedBy_Values = '' SET @WhereClause = @WhereClause + ' CreatedBy = '''' AND '
	ELSE
	BEGIN
		IF @CreatedBy_Values LIKE '%''%' SET @CreatedBy_Values = REPLACE(@CreatedBy_Values,'''','''''')
		IF @CreatedBy_Values LIKE 'SPPARM#%'
		BEGIN
			SET @CreatedBy_Values = (@CreatedBy_Values)
			SET @CreatedBy_Values = REPLACE(@CreatedBy_Values,',',''',''')
			SET @WhereClause = @WhereClause + ' CreatedBy IN ('''+@CreatedBy_Values+''') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@CreatedBy_Values) > 0
			BEGIN
				SET @CreatedBy_Values = REPLACE(@CreatedBy_Values,',',''',''')
				SET @WhereClause = @WhereClause + ' CreatedBy IN ('''+@CreatedBy_Values+''') AND '
			END
			ELSE SET @WhereClause = @WhereClause + ' CreatedBy = '''+@CreatedBy_Values+''' AND '
		END
	END
END
IF @UpdatedOn_Values IS NOT NULL 
BEGIN
	IF @UpdatedOn_Values = '###NULL###' SET @WhereClause = @WhereClause + ' UpdatedOn IS NULL AND ' 
	ELSE IF @UpdatedOn_Values = '' SET @WhereClause = @WhereClause + ' UpdatedOn = '''' AND '
	ELSE
	BEGIN
		IF @UpdatedOn_Values LIKE 'SPPARM#%'
		BEGIN
			SET @UpdatedOn_Values = (@UpdatedOn_Values)
			SET @UpdatedOn_Values = REPLACE(@UpdatedOn_Values,',',''',''')
			SET @WhereClause = @WhereClause + ' UpdatedOn IN ('''+@UpdatedOn_Values+''') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@UpdatedOn_Values) > 0
			BEGIN
				SET @UpdatedOn_Values = REPLACE(@UpdatedOn_Values,',',''',''')
				SET @WhereClause = @WhereClause + ' UpdatedOn IN ('''+@UpdatedOn_Values+''') AND '
			END
			ELSE SET @WhereClause = @WhereClause + ' UpdatedOn = '''+@UpdatedOn_Values+''' AND '
		END
	END
END
IF @UpdatedOn_Min IS NOT NULL SET @WhereClause = @WhereClause + '(UpdatedOn >= '''+CONVERT(NVARCHAR(MAX),@UpdatedOn_Min,121)+''') AND '
IF @UpdatedOn_Max IS NOT NULL SET @WhereClause = @WhereClause + '(UpdatedOn <= '''+CONVERT(NVARCHAR(MAX),@UpdatedOn_Max,121)+''') AND '
IF @UpdatedBy IS NOT NULL 
BEGIN
	IF @UpdatedBy = '###NULL###' SET @WhereClause = @WhereClause + ' UpdatedBy IS NULL AND ' 
	ELSE IF @UpdatedBy_Values = '' SET @WhereClause = @WhereClause + ' UpdatedBy = '''' AND '
	ELSE
	BEGIN
		IF @UpdatedBy LIKE '%''%' SET @UpdatedBy = REPLACE(@UpdatedBy,'''','''''')
		SET @WhereClause = @WhereClause + 'UpdatedBy LIKE ''%'+@UpdatedBy+'%'' AND '
	END
END
IF @UpdatedBy_Values IS NOT NULL 
BEGIN
	IF @UpdatedBy_Values = '###NULL###' SET @WhereClause = @WhereClause + ' UpdatedBy IS NULL AND ' 
	ELSE IF @UpdatedBy_Values = '' SET @WhereClause = @WhereClause + ' UpdatedBy = '''' AND '
	ELSE
	BEGIN
		IF @UpdatedBy_Values LIKE '%''%' SET @UpdatedBy_Values = REPLACE(@UpdatedBy_Values,'''','''''')
		IF @UpdatedBy_Values LIKE 'SPPARM#%'
		BEGIN
			SET @UpdatedBy_Values = (@UpdatedBy_Values)
			SET @UpdatedBy_Values = REPLACE(@UpdatedBy_Values,',',''',''')
			SET @WhereClause = @WhereClause + ' UpdatedBy IN ('''+@UpdatedBy_Values+''') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@UpdatedBy_Values) > 0
			BEGIN
				SET @UpdatedBy_Values = REPLACE(@UpdatedBy_Values,',',''',''')
				SET @WhereClause = @WhereClause + ' UpdatedBy IN ('''+@UpdatedBy_Values+''') AND '
			END
			ELSE SET @WhereClause = @WhereClause + ' UpdatedBy = '''+@UpdatedBy_Values+''' AND '
		END
	END
END


IF @WhereClause <> ''
BEGIN
	SET @WhereClause=SUBSTRING(@WhereClause,0,LEN(@WhereClause) - 2)
	SET @WhereClause='WHERE '+@WhereClause
END

IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
	DECLARE @ResultOutput TABLE (out int)
	SET @Query = 'SELECT COUNT(1) FROM UM_Role  (NOLOCK)  ' + @WhereClause 

	INSERT INTO @ResultOutput EXEC(@Query)
	SET @ResultCount = (SELECT * from @ResultOutput)
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
	SET @Query = 'SELECT RoleID,Name,ParentID,IsActive,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy FROM UM_Role  (NOLOCK)  ' + @WhereClause 
	EXEC(@Query)
END
ELSE
BEGIN
	IF @Page_Size IS NOT NULL AND @Page_Index IS NOT NULL
	BEGIN
	SET @Query = 'SELECT RoleID,Name,ParentID,IsActive,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy FROM (SELECT ROW_NUMBER() OVER 
(ORDER BY '+ISNULL(@Sort_Column,'(SELECT NULL)') + ' ' + CASE WHEN CONVERT(NVARCHAR(MAX),@Sort_Ascending) = 0 THEN 'DESC' ELSE 'ASC' END + ') AS RowNum,UM_Role.* FROM UM_Role  (NOLOCK)  '+@WhereClause+' ) AS RowConstrainedResult
WHERE ('+CONVERT(NVARCHAR(MAX),@Page_Size)+' IS NULL) OR (RowNum >=  '+CONVERT(NVARCHAR(MAX),@Page_Size)+'*('+CONVERT(NVARCHAR(MAX),@Page_Index)+'-1)+1 AND  RowNum <= '+CONVERT(NVARCHAR(MAX),@Page_Size)+'*'+CONVERT(NVARCHAR(MAX),@Page_Index)+')
ORDER BY RowNum ' 
	END
	ELSE
	BEGIN
	SET @Query = 'SELECT RoleID,Name,ParentID,IsActive,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy FROM (SELECT ROW_NUMBER() OVER 
(ORDER BY '+ISNULL(@Sort_Column,'(SELECT CreatedOn)') + ' ' + CASE WHEN CONVERT(NVARCHAR(MAX),@Sort_Ascending) = 0 THEN 'DESC' ELSE 'ASC' END + ') AS RowNum,UM_Role.* FROM UM_Role  (NOLOCK)  '+@WhereClause+' ) AS RowConstrainedResult
ORDER BY RowNum ' 
	END
	EXEC(@Query)
END
SET NOCOUNT OFF;
IF(1=0) BEGIN SELECT * FROM UM_Role  (NOLOCK)  END
--------------------------------------------------

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Role_SearchAll_V2]    Script Date: 16-03-2020 09:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-03-15-- Description : Select Procedure for UM_Role-- Exec [dbo].[spr_tb_UM_Role_Search]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_UM_Role_SearchAll_V2]     @ResultCount INT OUTPUT    ,@Page INT = NULL    ,@PageSize INT = NULL    ,@Filter NVARCHAR(MAX) = NULL    ,@SortOrder VARCHAR(MAX) = NULLASBEGIN    DECLARE @Query NVARCHAR(MAX)=NULL    DECLARE @WhereClause NVARCHAR(MAX)=NULL    SET @Query='SELECT [Name]        ,[ParentID]        ,[IsActive]        ,[CreatedOn]        ,[CreatedBy]        ,[UpdatedOn]        ,[UpdatedBy]        ,[RoleID]         FROM [dbo].[UM_Role] WITH(NOLOCK)'    IF @Filter <> ''    BEGIN        SET @WhereClause=' WHERE '+@Filter        SET @Query = CONCAT(@Query,@WhereClause)    END    IF @SortOrder <> ''    BEGIN        SET @Query = CONCAT(@Query,' ORDER BY '+@SortOrder)    END    ELSE    BEGIN        SET @Query = CONCAT(@Query,' ORDER BY 1 DESC')    END    IF NOT (@Page IS NULL OR @PageSize IS NULL)    BEGIN        DECLARE @ResultOutput TABLE (out int)        INSERT INTO @ResultOutput EXEC('SELECT COUNT(1) FROM UM_Role  (NOLOCK)  ' + @WhereClause)        SET @ResultCount = (SELECT * from @ResultOutput)    END    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)    BEGIN        SET @Query = CONCAT(@Query,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')    END    EXEC(@Query)    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_Role]  (NOLOCK)  ENDEND
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Role_Update]    Script Date: 16-03-2020 09:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[spr_tb_UM_Role_Update]

@RoleID int,
@Name nvarchar(250),
@ParentID int = NULL,
@IsActive bit= 1,
@CreatedOn datetime = NULL,
@CreatedBy nvarchar(50) = NULL,
@UpdatedOn datetime = NULL,
@UpdatedBy nvarchar(50) = NULL,
@ProcessingDateTime datetime2 = NULL
AS

SET NOCOUNT ON;
UPDATE  UM_Role
 SET 
Name = LTRIM(RTRIM(@Name)),
ParentID = @ParentID,
IsActive = @IsActive,
UpdatedOn = @ProcessingDateTime,
UpdatedBy = LTRIM(RTRIM(@UpdatedBy))
 WHERE RoleID=@RoleID


GO

