/*
Note : First  Remove  [UM_Menu],[UM_ChildMenu] related store procedure then run this scripts
*/

DROP TABLE [dbo].[UM_Menu]
DROP TABLE [dbo].[UM_ChildMenu]

CREATE TABLE [dbo].[UM_AreaManagement](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_UM_AreaManagement] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UM_AreaManagement] ADD  CONSTRAINT [DF_UM_AreaManagement_IsActive]  DEFAULT ((0)) FOR [IsActive]

ALTER TABLE [dbo].[UM_AreaManagement] ADD  CONSTRAINT [DF_UM_AreaManagement_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]

CREATE TABLE [dbo].[UM_Menu](
	[MenuID] [int] IDENTITY(1,1) NOT NULL,
	[AreaID] [int] NULL,
	[LinkText] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[ActionName] [varchar](100) NULL,
	[ControllerName] [varchar](100) NULL,
	[HtmlAttributes] [varchar](max) NULL,
	[RouteData] [varchar](max) NULL,
	[Sequance] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_UM_Menu] PRIMARY KEY CLUSTERED 
(
	[MenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[UM_Menu] ADD  CONSTRAINT [DF_UM_Menu_IsActive]  DEFAULT ((0)) FOR [IsActive]

ALTER TABLE [dbo].[UM_Menu] ADD  CONSTRAINT [DF_UM_Menu_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]

CREATE TABLE [dbo].[UM_ChildMenu](
	[SubMenuID] [int] IDENTITY(1,1) NOT NULL,
	[MenuID] [int] NOT NULL,
	[ParentID] [int] NULL,
	[LinkText] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ActionName] [varchar](100) NOT NULL,
	[ControllerName] [varchar](100) NOT NULL,
	[HtmlAttributes] [varchar](max) NULL,
	[RouteData] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[Sequance] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_UM_ChildMenu] PRIMARY KEY CLUSTERED 
(
	[SubMenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[UM_ChildMenu] ADD  CONSTRAINT [DF_UM_ChildMenu_IsActive]  DEFAULT ((0)) FOR [IsActive]

ALTER TABLE [dbo].[UM_ChildMenu] ADD  CONSTRAINT [DF_UM_ChildMenu_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_AreaManagement_Delete]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Delete Procedure for UM_AreaManagement
-- Exec [dbo].[spr_tb_UM_AreaManagement_Delete] @AreaID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_AreaManagement_Delete]
     @AreaID  int
    
AS
BEGIN

    DELETE FROM [dbo].[UM_AreaManagement]
    WHERE [AreaID] = @AreaID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_AreaManagement_GetByID]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Select Procedure for UM_AreaManagement
-- Exec [dbo].[spr_tb_UM_AreaManagement_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_AreaManagement_GetByID]
     @AreaID  int
    
AS
BEGIN

    SELECT [AreaID]
        ,[Name]
        ,[IsActive]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
         FROM [dbo].[UM_AreaManagement] WITH(NOLOCK)
    WHERE [AreaID] = @AreaID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_AreaManagement_Insert]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Insert Procedure for UM_AreaManagement
-- Exec [dbo].[spr_tb_UM_AreaManagement_Insert] [Name],[IsActive],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_AreaManagement_Insert]
     @ResultID INT OUTPUT
    ,@Name  varchar(250)
    ,@IsActive  bit
    ,@CreatedOn  datetime = NULL
    ,@CreatedBy  nvarchar(50) = NULL
    ,@UpdatedOn  datetime = NULL
    ,@UpdatedBy  nvarchar(50) = NULL
    
AS
BEGIN

    INSERT INTO [dbo].[UM_AreaManagement]
    ( 
         [Name]
        ,[IsActive]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
        
    )
    VALUES
    (
         @Name
        ,@IsActive
        ,@CreatedOn
        ,@CreatedBy
        ,@UpdatedOn
        ,@UpdatedBy
        
    )
    SELECT @ResultID=SCOPE_IDENTITY();
END



GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_AreaManagement_Search]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Select Procedure for UM_AreaManagement
-- Exec [dbo].[spr_tb_UM_AreaManagement_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_AreaManagement_Search]
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
        INSERT INTO @ResultOutput EXEC('SELECT COUNT(1) FROM [dbo].[UM_AreaManagement]  (NOLOCK)  ' + @WhereClause)
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END

    SET @Query='SELECT [AreaID]
        ,[Name]
        ,[IsActive]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
         FROM [dbo].[UM_AreaManagement] WITH(NOLOCK)'
        + @TempQuery
    EXEC(@Query)

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_AreaManagement]  (NOLOCK)  END
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_AreaManagement_Update]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Update Procedure for UM_AreaManagement
-- Exec [dbo].[spr_tb_UM_AreaManagement_Update] [Name],[IsActive],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_AreaManagement_Update]
     @AreaID  int
    ,@Name  varchar(250)
    ,@IsActive  bit
    ,@CreatedOn  datetime = NULL
    ,@CreatedBy  nvarchar(50) = NULL
    ,@UpdatedOn  datetime = NULL
    ,@UpdatedBy  nvarchar(50) = NULL
    
AS
BEGIN

    UPDATE [dbo].[UM_AreaManagement]
    SET 
         [Name] = @Name
        ,[IsActive] = @IsActive
        ,[CreatedOn] = @CreatedOn
        ,[CreatedBy] = @CreatedBy
        ,[UpdatedOn] = @UpdatedOn
        ,[UpdatedBy] = @UpdatedBy
        
    WHERE [AreaID] = @AreaID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ChildMenu_Delete]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Delete Procedure for UM_ChildMenu
-- Exec [dbo].[spr_tb_UM_ChildMenu_Delete] @SubMenuID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ChildMenu_Delete]
     @SubMenuID  int
    
AS
BEGIN

    DELETE FROM [dbo].[UM_ChildMenu]
    WHERE [SubMenuID] = @SubMenuID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ChildMenu_GetByID]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Select Procedure for UM_ChildMenu
-- Exec [dbo].[spr_tb_UM_ChildMenu_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ChildMenu_GetByID]
     @SubMenuID  int
    
AS
BEGIN

    SELECT [SubMenuID]
        ,[MenuID]
        ,[ParentID]
        ,[LinkText]
        ,[Description]
        ,[ActionName]
        ,[ControllerName]
        ,[HtmlAttributes]
        ,[RouteData]
        ,[IsActive]
        ,[Sequance]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
         FROM [dbo].[UM_ChildMenu] WITH(NOLOCK)
    WHERE [SubMenuID] = @SubMenuID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ChildMenu_Insert]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Insert Procedure for UM_ChildMenu
-- Exec [dbo].[spr_tb_UM_ChildMenu_Insert] [MenuID],[ParentID],[LinkText],[Description],[ActionName],[ControllerName],[HtmlAttributes],[RouteData],[IsActive],[Sequance],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ChildMenu_Insert]
     @ResultID INT OUTPUT
    ,@MenuID  int
    ,@ParentID  int = NULL
    ,@LinkText  nvarchar(250)
    ,@Description  nvarchar(max) = NULL
    ,@ActionName  varchar(100)
    ,@ControllerName  varchar(100)
    ,@HtmlAttributes  varchar(max) = NULL
    ,@RouteData  varchar(max) = NULL
    ,@IsActive  bit
    ,@Sequance  int = NULL
    ,@CreatedOn  datetime = NULL
    ,@CreatedBy  nvarchar(50) = NULL
    ,@UpdatedOn  datetime = NULL
    ,@UpdatedBy  nvarchar(50) = NULL
    
AS
BEGIN

    INSERT INTO [dbo].[UM_ChildMenu]
    ( 
         [MenuID]
        ,[ParentID]
        ,[LinkText]
        ,[Description]
        ,[ActionName]
        ,[ControllerName]
        ,[HtmlAttributes]
        ,[RouteData]
        ,[IsActive]
        ,[Sequance]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
        
    )
    VALUES
    (
         @MenuID
        ,@ParentID
        ,@LinkText
        ,@Description
        ,@ActionName
        ,@ControllerName
        ,@HtmlAttributes
        ,@RouteData
        ,@IsActive
        ,@Sequance
        ,@CreatedOn
        ,@CreatedBy
        ,@UpdatedOn
        ,@UpdatedBy
        
    )
    SELECT @ResultID=SCOPE_IDENTITY();
END



GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ChildMenu_Search]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Select Procedure for UM_ChildMenu
-- Exec [dbo].[spr_tb_UM_ChildMenu_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ChildMenu_Search]
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
        INSERT INTO @ResultOutput EXEC('SELECT COUNT(1) FROM [dbo].[UM_ChildMenu]  (NOLOCK)  ' + @WhereClause)
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END

    SET @Query='SELECT [SubMenuID]
        ,[MenuID]
        ,[ParentID]
        ,[LinkText]
        ,[Description]
        ,[ActionName]
        ,[ControllerName]
        ,[HtmlAttributes]
        ,[RouteData]
        ,[IsActive]
        ,[Sequance]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
         FROM [dbo].[UM_ChildMenu] WITH(NOLOCK)'
        + @TempQuery
    EXEC(@Query)

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_ChildMenu]  (NOLOCK)  END
END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ChildMenu_Update]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Update Procedure for UM_ChildMenu
-- Exec [dbo].[spr_tb_UM_ChildMenu_Update] [MenuID],[ParentID],[LinkText],[Description],[ActionName],[ControllerName],[HtmlAttributes],[RouteData],[IsActive],[Sequance],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ChildMenu_Update]
     @SubMenuID  int
    ,@MenuID  int
    ,@ParentID  int = NULL
    ,@LinkText  nvarchar(250)
    ,@Description  nvarchar(max) = NULL
    ,@ActionName  varchar(100)
    ,@ControllerName  varchar(100)
    ,@HtmlAttributes  varchar(max) = NULL
    ,@RouteData  varchar(max) = NULL
    ,@IsActive  bit
    ,@Sequance  int = NULL
    ,@CreatedOn  datetime = NULL
    ,@CreatedBy  nvarchar(50) = NULL
    ,@UpdatedOn  datetime = NULL
    ,@UpdatedBy  nvarchar(50) = NULL
    
AS
BEGIN

    UPDATE [dbo].[UM_ChildMenu]
    SET 
         [MenuID] = @MenuID
        ,[ParentID] = @ParentID
        ,[LinkText] = @LinkText
        ,[Description] = @Description
        ,[ActionName] = @ActionName
        ,[ControllerName] = @ControllerName
        ,[HtmlAttributes] = @HtmlAttributes
        ,[RouteData] = @RouteData
        ,[IsActive] = @IsActive
        ,[Sequance] = @Sequance
        ,[CreatedOn] = @CreatedOn
        ,[CreatedBy] = @CreatedBy
        ,[UpdatedOn] = @UpdatedOn
        ,[UpdatedBy] = @UpdatedBy
        
    WHERE [SubMenuID] = @SubMenuID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Menu_Delete]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Delete Procedure for UM_Menu
-- Exec [dbo].[spr_tb_UM_Menu_Delete] @MenuID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_Menu_Delete]
     @MenuID  int
    
AS
BEGIN

    DELETE FROM [dbo].[UM_Menu]
    WHERE [MenuID] = @MenuID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Menu_GetByID]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Select Procedure for UM_Menu
-- Exec [dbo].[spr_tb_UM_Menu_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_Menu_GetByID]
     @MenuID  int
    
AS
BEGIN

    SELECT [MenuID]
        ,[AreaID]
        ,[LinkText]
        ,[Description]
        ,[IsActive]
        ,[ActionName]
        ,[ControllerName]
        ,[HtmlAttributes]
        ,[RouteData]
        ,[Sequance]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
         FROM [dbo].[UM_Menu] WITH(NOLOCK)
    WHERE [MenuID] = @MenuID

END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Menu_Insert]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Insert Procedure for UM_Menu
-- Exec [dbo].[spr_tb_UM_Menu_Insert] [AreaID],[LinkText],[Description],[IsActive],[ActionName],[ControllerName],[HtmlAttributes],[RouteData],[Sequance],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_Menu_Insert]
     @ResultID INT OUTPUT
    ,@AreaID  int = NULL
    ,@LinkText  nvarchar(250)
    ,@Description  nvarchar(max) = NULL
    ,@IsActive  bit
    ,@ActionName  varchar(100)
    ,@ControllerName  varchar(100)
    ,@HtmlAttributes  varchar(max) = NULL
    ,@RouteData  varchar(max) = NULL
    ,@Sequance  int = NULL
    ,@CreatedOn  datetime = NULL
    ,@CreatedBy  nvarchar(50) = NULL
    ,@UpdatedOn  datetime = NULL
    ,@UpdatedBy  nvarchar(50) = NULL
    
AS
BEGIN

    INSERT INTO [dbo].[UM_Menu]
    ( 
         [AreaID]
        ,[LinkText]
        ,[Description]
        ,[IsActive]
        ,[ActionName]
        ,[ControllerName]
        ,[HtmlAttributes]
        ,[RouteData]
        ,[Sequance]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
        
    )
    VALUES
    (
         @AreaID
        ,@LinkText
        ,@Description
        ,@IsActive
        ,@ActionName
        ,@ControllerName
        ,@HtmlAttributes
        ,@RouteData
        ,@Sequance
        ,@CreatedOn
        ,@CreatedBy
        ,@UpdatedOn
        ,@UpdatedBy
        
    )
    SELECT @ResultID=SCOPE_IDENTITY();
END



GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Menu_Search]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Select Procedure for UM_Menu
-- Exec [dbo].[spr_tb_UM_Menu_Search]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_Menu_Search]
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
        INSERT INTO @ResultOutput EXEC('SELECT COUNT(1) FROM [dbo].[UM_Menu]  (NOLOCK)  ' + @WhereClause)
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @TempQuery = CONCAT(@TempQuery,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END

    SET @Query='SELECT [MenuID]
        ,[AreaID]
        ,[LinkText]
        ,[Description]
        ,[IsActive]
        ,[ActionName]
        ,[ControllerName]
        ,[HtmlAttributes]
        ,[RouteData]
        ,[Sequance]
        ,[CreatedOn]
        ,[CreatedBy]
        ,[UpdatedOn]
        ,[UpdatedBy]
         FROM [dbo].[UM_Menu] WITH(NOLOCK)'
        + @TempQuery
    EXEC(@Query)

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_Menu]  (NOLOCK)  END
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Menu_Update]    Script Date: 22-03-2020 12:51:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-21
-- Description : Update Procedure for UM_Menu
-- Exec [dbo].[spr_tb_UM_Menu_Update] [AreaID],[LinkText],[Description],[IsActive],[ActionName],[ControllerName],[HtmlAttributes],[RouteData],[Sequance],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_Menu_Update]
     @MenuID  int
    ,@AreaID  int = NULL
    ,@LinkText  nvarchar(250)
    ,@Description  nvarchar(max) = NULL
    ,@IsActive  bit
    ,@ActionName  varchar(100)
    ,@ControllerName  varchar(100)
    ,@HtmlAttributes  varchar(max) = NULL
    ,@RouteData  varchar(max) = NULL
    ,@Sequance  int = NULL
    ,@CreatedOn  datetime = NULL
    ,@CreatedBy  nvarchar(50) = NULL
    ,@UpdatedOn  datetime = NULL
    ,@UpdatedBy  nvarchar(50) = NULL
    
AS
BEGIN

    UPDATE [dbo].[UM_Menu]
    SET 
         [AreaID] = @AreaID
        ,[LinkText] = @LinkText
        ,[Description] = @Description
        ,[IsActive] = @IsActive
        ,[ActionName] = @ActionName
        ,[ControllerName] = @ControllerName
        ,[HtmlAttributes] = @HtmlAttributes
        ,[RouteData] = @RouteData
        ,[Sequance] = @Sequance
        ,[CreatedOn] = @CreatedOn
        ,[CreatedBy] = @CreatedBy
        ,[UpdatedOn] = @UpdatedOn
        ,[UpdatedBy] = @UpdatedBy
        
    WHERE [MenuID] = @MenuID

END

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ChildMenu_UpdateSequance]    Script Date: 23-03-2020 07:16:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,22-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[spr_tb_UM_ChildMenu_UpdateSequance]
	@SubMenuID INT,
	@Sequance INT = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	UPDATE [dbo].[UM_ChildMenu]
		SET [Sequance] = @Sequance,
		[UpdatedOn] = GETDATE()
	WHERE [SubMenuID] = @SubMenuID
	SET NOCOUNT OFF;
END
GO


/****** Object:  StoredProcedure [dbo].[spr_tb_UM_Menu_UpdateSequance]    Script Date: 23-03-2020 07:16:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,22-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UM_Menu_UpdateSequance] 
	@MenuID INT,
	@Sequance INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE [dbo].[UM_Menu]
		SET [Sequance] = @Sequance,
		[UpdatedOn] = GETDATE()
	WHERE [MenuID] = @MenuID
	SET NOCOUNT OFF;
END
GO





