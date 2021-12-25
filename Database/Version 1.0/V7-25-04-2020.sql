CREATE TABLE [dbo].[AM_Icon](
	[IconID] [int] IDENTITY(1,1) NOT NULL,
	[ICon] [varchar](100) NOT NULL,
	[IconName] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_AM_Icon] PRIMARY KEY CLUSTERED 
(
	[IconID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AM_Icon] ADD  CONSTRAINT [DF_AM_Icon_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[AM_Icon] ADD  CONSTRAINT [DF_AM_Icon_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-04-25-- Description : Delete Procedure for AM_ICon-- Exec [dbo].[spr_tb_AM_ICon_Delete] @IconID  int    -- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_ICon_Delete]     @IconID  int    ASBEGIN    DELETE FROM [dbo].[AM_ICon]    WHERE [IconID] = @IconIDEND
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_ICon_GetByID]    Script Date: 25-04-2020 12:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-04-25-- Description : Select Procedure for AM_ICon-- Exec [dbo].[spr_tb_AM_ICon_Search]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_ICon_GetByID]     @IconID  int    ASBEGIN    SELECT [IconID]        ,[ICon]        ,[IconName]        ,[IsActive]        ,[CreatedOn]        ,[CreatedBy]         FROM [dbo].[AM_ICon] WITH(NOLOCK)    WHERE [IconID] = @IconIDEND
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_ICon_Insert]    Script Date: 25-04-2020 12:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-04-25-- Description : Insert Procedure for AM_ICon-- Exec [dbo].[spr_tb_AM_ICon_Insert] [ICon],[IconName],[IsActive],[CreatedOn],[CreatedBy]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_ICon_Insert]     @ResultID INT OUTPUT    ,@ICon  varchar(100)    ,@IconName  varchar(100)    ,@IsActive  bit    ,@CreatedOn  datetime = NULL    ,@CreatedBy  nvarchar(50) = NULL    ASBEGIN    INSERT INTO [dbo].[AM_ICon]    (          [ICon]        ,[IconName]        ,[IsActive]        ,[CreatedOn]        ,[CreatedBy]            )    VALUES    (         @ICon        ,@IconName        ,@IsActive        ,@CreatedOn        ,@CreatedBy            )    SELECT @ResultID=SCOPE_IDENTITY();END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_ICon_Search]    Script Date: 25-04-2020 12:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-04-25-- Description : Select Procedure for AM_ICon-- Exec [dbo].[spr_tb_AM_ICon_Search]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_ICon_Search]     @ResultCount INT OUTPUT    ,@Page INT = NULL    ,@PageSize INT = NULL    ,@Filter NVARCHAR(MAX) = NULL    ,@SortOrder VARCHAR(MAX) = NULLASBEGIN    DECLARE @Query NVARCHAR(MAX)='', @TempQuery NVARCHAR(MAX)=''    DECLARE @WhereClause NVARCHAR(MAX)=''    IF @Filter <> ''    BEGIN        SET @TempQuery=' WHERE '+@Filter        SET @WhereClause = @TempQuery    END    IF @SortOrder <> ''    BEGIN        SET @TempQuery = CONCAT(@TempQuery,' ORDER BY '+@SortOrder)    END    ELSE    BEGIN        SET @TempQuery = CONCAT(@TempQuery,' ORDER BY 1 DESC')    END    IF NOT (@Page IS NULL OR @PageSize IS NULL)    BEGIN        DECLARE @ResultOutput TABLE (out int)        DECLARE @CountQuery NVARCHAR(MAX)='SELECT COUNT(1) FROM [dbo].[AM_ICon]  (NOLOCK)  ' + @WhereClause        INSERT INTO @ResultOutput EXECUTE SP_EXECUTESQL @CountQuery        SET @ResultCount = (SELECT * from @ResultOutput)    END    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)    BEGIN        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')    END    IF @TempQuery = ''    BEGIN    SET @Query='SELECT [IconID]        ,[ICon]        ,[IconName]        ,[IsActive]        ,[CreatedOn]        ,[CreatedBy]         FROM [dbo].[AM_ICon] WITH(NOLOCK)'        EXECUTE SP_EXECUTESQL @Query    END    ELSE    BEGIN    SET @Query='SELECT [IconID]        ,[ICon]        ,[IconName]        ,[IsActive]        ,[CreatedOn]        ,[CreatedBy]         FROM [dbo].[AM_ICon] WITH(NOLOCK)'        + @TempQuery        EXECUTE SP_EXECUTESQL @Query    END    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[AM_ICon]  (NOLOCK)  ENDEND
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_ICon_Update]    Script Date: 25-04-2020 12:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================-- Author      : Jishan Siddique-- Create date : 2020-04-25-- Description : Update Procedure for AM_ICon-- Exec [dbo].[spr_tb_AM_ICon_Update] [ICon],[IconName],[IsActive],[CreatedOn],[CreatedBy]-- ============================================= */CREATE PROCEDURE [dbo].[spr_tb_AM_ICon_Update]     @IconID  int    ,@ICon  varchar(100)    ,@IconName  varchar(100)    ,@IsActive  bit    ,@CreatedOn  datetime = NULL    ,@CreatedBy  nvarchar(50) = NULL    ASBEGIN    UPDATE [dbo].[AM_ICon]    SET          [ICon] = @ICon        ,[IconName] = @IconName        ,[IsActive] = @IsActive        ,[CreatedOn] = @CreatedOn        ,[CreatedBy] = @CreatedBy            WHERE [IconID] = @IconIDEND
GO



