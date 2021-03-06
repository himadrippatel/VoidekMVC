USE [master]
GO
/****** Object:  Database [Alliant]    Script Date: 3/1/2020 10:36:50 PM ******/
CREATE DATABASE [Alliant]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RFID', FILENAME = N'C:\Users\Mahendra Patel\RFID.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'RFID_log', FILENAME = N'C:\Users\Mahendra Patel\RFID_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Alliant] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Alliant].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Alliant] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Alliant] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Alliant] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Alliant] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Alliant] SET ARITHABORT OFF 
GO
ALTER DATABASE [Alliant] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Alliant] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Alliant] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Alliant] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Alliant] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Alliant] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Alliant] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Alliant] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Alliant] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Alliant] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Alliant] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Alliant] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Alliant] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Alliant] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Alliant] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Alliant] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Alliant] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Alliant] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Alliant] SET  MULTI_USER 
GO
ALTER DATABASE [Alliant] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Alliant] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Alliant] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Alliant] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Alliant] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Alliant] SET QUERY_STORE = OFF
GO
USE [Alliant]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [Alliant]
GO
/****** Object:  UserDefinedDataType [dbo].[CreatedBy]    Script Date: 3/1/2020 10:36:50 PM ******/
CREATE TYPE [dbo].[CreatedBy] FROM [varchar](50) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[CreatedOn]    Script Date: 3/1/2020 10:36:50 PM ******/
CREATE TYPE [dbo].[CreatedOn] FROM [datetime] NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UpdatedBy]    Script Date: 3/1/2020 10:36:50 PM ******/
CREATE TYPE [dbo].[UpdatedBy] FROM [varchar](50) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UpdatedOn]    Script Date: 3/1/2020 10:36:50 PM ******/
CREATE TYPE [dbo].[UpdatedOn] FROM [datetime] NULL
GO
/****** Object:  UserDefinedFunction [dbo].[CustomeSplit]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomeSplit] (
      @InputString                  NVARCHAR(MAX),
      @Delimiter                    nvarchar(50)
)
 
RETURNS @Items TABLE (
      Item                          NVARCHAR(MAX)
)
/*** WITH ENCRYPTION ***/
AS
BEGIN
  --    IF @InputString <> '' AND  @InputString IS NOT NULL
  --    BEGIN
		--RETURN
  --    END
 

      IF @Delimiter = ' '
      BEGIN
            SET @Delimiter = ','
            SET @InputString = REPLACE(@InputString, ' ', @Delimiter)
      END
 
      IF (@Delimiter IS NULL OR @Delimiter = '')
            SET @Delimiter = ','
 
--INSERT INTO @Items VALUES (@Delimiter) -- Diagnostic
--INSERT INTO @Items VALUES (@InputString) -- Diagnostic
 
      DECLARE @Item                 NVARCHAR(MAX)
      DECLARE @ItemList       NVARCHAR(MAX)
      DECLARE @DelimIndex     INT
 
      SET @ItemList = @InputString
      SET @DelimIndex = CHARINDEX(@Delimiter, @ItemList, 0)
      WHILE (@DelimIndex != 0)
      BEGIN
            SET @Item = SUBSTRING(@ItemList, 0, @DelimIndex)
			IF LEN(RTRIM(LTRIM(@Item)))>0
			BEGIN
				INSERT INTO @Items VALUES (@Item)
			END

            -- Set @ItemList = @ItemList minus one less item
            SET @ItemList = SUBSTRING(@ItemList, @DelimIndex+1, LEN(@ItemList)-@DelimIndex)
            SET @DelimIndex = CHARINDEX(@Delimiter, @ItemList, 0)
      END -- End WHILE
 
      IF @Item IS NOT NULL -- At least one delimiter was encountered in @InputString
      BEGIN
            SET @Item = @ItemList
			IF LEN(RTRIM(LTRIM(@Item)))>0
			BEGIN
				INSERT INTO @Items VALUES (@Item)
			END
      END
 
      -- No delimiters were encountered in @InputString, so just return @InputString
      ELSE 
		IF LEN(RTRIM(LTRIM(@InputString)))>0
		BEGIN
			INSERT INTO @Items VALUES (@InputString)
		END
 
      RETURN
 
END -- End Function
GO
/****** Object:  Table [dbo].[M_Branch]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M_Branch](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[CreatedOn] [dbo].[CreatedOn] NULL,
	[CreatedBy] [dbo].[CreatedBy] NULL,
	[UpdatedOn] [dbo].[UpdatedOn] NULL,
	[UpdatedBy] [dbo].[UpdatedBy] NULL,
 CONSTRAINT [PK_M_Branch] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UM_ChildMenu]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_UM_ChildMenu] PRIMARY KEY CLUSTERED 
(
	[SubMenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UM_Menu]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UM_Menu](
	[MenuID] [int] IDENTITY(1,1) NOT NULL,
	[LinkText] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_UM_Menu] PRIMARY KEY CLUSTERED 
(
	[MenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UM_UserLogin]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UM_UserLogin](
	[UserLoginID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[UserName] [nvarchar](250) NOT NULL,
	[Password] [varchar](250) NOT NULL,
 CONSTRAINT [PK_UM_UserLogin] PRIMARY KEY CLUSTERED 
(
	[UserLoginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[M_Branch] ON 

INSERT [dbo].[M_Branch] ([Id], [Name], [Code], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (2, N'B', N'B', NULL, NULL, NULL, NULL)
INSERT [dbo].[M_Branch] ([Id], [Name], [Code], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (4, N'A', N'a', NULL, NULL, NULL, NULL)
INSERT [dbo].[M_Branch] ([Id], [Name], [Code], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (1002, N'jishan', N'Test', CAST(N'2020-02-12T14:05:24.193' AS DateTime), NULL, CAST(N'2020-02-12T14:05:24.000' AS DateTime), N'')
INSERT [dbo].[M_Branch] ([Id], [Name], [Code], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (1003, N'New Test', N'Test', CAST(N'2020-02-12T14:06:00.563' AS DateTime), NULL, CAST(N'2020-02-12T14:06:02.767' AS DateTime), NULL)
INSERT [dbo].[M_Branch] ([Id], [Name], [Code], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (1004, N'New Test', N'Test', CAST(N'2020-02-12T14:07:15.510' AS DateTime), NULL, CAST(N'2020-02-12T14:07:15.510' AS DateTime), NULL)
INSERT [dbo].[M_Branch] ([Id], [Name], [Code], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (1005, N'Jishan', N'A', CAST(N'2020-02-12T19:38:56.633' AS DateTime), NULL, CAST(N'2020-02-12T19:38:56.633' AS DateTime), NULL)
INSERT [dbo].[M_Branch] ([Id], [Name], [Code], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (2002, N'JIshan', N'D', CAST(N'2020-02-12T22:06:20.957' AS DateTime), NULL, CAST(N'2020-02-12T22:06:20.000' AS DateTime), N'')
INSERT [dbo].[M_Branch] ([Id], [Name], [Code], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (2003, N'jishan', N'D4', CAST(N'2020-02-12T22:07:50.790' AS DateTime), NULL, CAST(N'2020-02-12T22:07:50.000' AS DateTime), N'')
SET IDENTITY_INSERT [dbo].[M_Branch] OFF
SET IDENTITY_INSERT [dbo].[UM_UserLogin] ON 

INSERT [dbo].[UM_UserLogin] ([UserLoginID], [UserID], [UserName], [Password]) VALUES (1, 1, N'admin', N'admin')
SET IDENTITY_INSERT [dbo].[UM_UserLogin] OFF
ALTER TABLE [dbo].[UM_ChildMenu] ADD  CONSTRAINT [DF_UM_ChildMenu_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UM_ChildMenu] ADD  CONSTRAINT [DF_UM_ChildMenu_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[UM_Menu] ADD  CONSTRAINT [DF_UM_Menu_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UM_Menu] ADD  CONSTRAINT [DF_UM_Menu_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO


/****** Object:  StoredProcedure [dbo].[spr_tb_M_Branch_Delete]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spr_tb_M_Branch_Delete]
@Id INT
AS
SET NOCOUNT ON;
BEGIN
	DELETE FROM [dbo].[M_Branch] 
	WHERE [Id] = @Id
END
--------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[spr_tb_M_Branch_GetByID]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_M_Branch_GetByID] 
	@Id INT
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT * FROM M_Branch WITH(NOLOCK)
	WHERE Id = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[spr_tb_M_Branch_Insert]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spr_tb_M_Branch_Insert]

@ResultID INT OUTPUT,
@Name nvarchar(250),
@Code nvarchar(50) = NULL,
@CreatedOn datetime = NULL,
@CreatedBy varchar(50) = NULL,
@UpdatedOn datetime = NULL,
@UpdatedBy varchar(50) = NULL,
@ProcessingDateTime datetime2 = NULL


AS

BEGIN

SET NOCOUNT ON;

INSERT INTO M_Branch
(
Name,
Code,
CreatedOn,
CreatedBy,
UpdatedOn,
UpdatedBy
)
VALUES 
(
LTRIM(RTRIM(@Name)),
LTRIM(RTRIM(@Code)),
@CreatedOn,
LTRIM(RTRIM(@CreatedBy)),
@UpdatedOn,
LTRIM(RTRIM(@CreatedBy))
)
SET @ResultID = SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[spr_tb_M_Branch_SearchAll]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spr_tb_M_Branch_SearchAll]

@ResultCount INT OUTPUT,
@Id_Values nvarchar(max) = NULL,
@Id_Min int = NULL,
@Id_Max int = NULL,
@Name nvarchar(250) = NULL,
@Name_Values nvarchar(max) = NULL,
@Code nvarchar(50) = NULL,
@Code_Values nvarchar(max) = NULL,
@CreatedOn_Values nvarchar(max) = NULL,
@CreatedOn_Min datetime = NULL,
@CreatedOn_Max datetime = NULL,
@CreatedBy varchar(50) = NULL,
@CreatedBy_Values nvarchar(max) = NULL,
@UpdatedOn_Values nvarchar(max) = NULL,
@UpdatedOn_Min datetime = NULL,
@UpdatedOn_Max datetime = NULL,
@UpdatedBy varchar(50) = NULL,
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

IF @Id_Values IS NOT NULL 
BEGIN
	IF @Id_Values  = '###NULL###' SET @WhereClause = @WhereClause + ' Id IS NULL AND ' 
	ELSE IF @Id_Values = '' SET @WhereClause = @WhereClause + ' Id = '''' AND '
	ELSE IF @Id_Values <> '###NULL###' AND @IsPrimaryIN = 1 
	BEGIN
		IF @Id_Values LIKE 'SPPARM#%'
		BEGIN
			SET @Id_Values = (@Id_Values)
			SET @WhereClause = @WhereClause + 'Id IN ('+@Id_Values+') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@Id_Values) > 0 SET @WhereClause = @WhereClause + 'Id IN ('+@Id_Values+') AND '
			ELSE SET @WhereClause = @WhereClause + ' Id = '+@Id_Values+' AND '
		END
	END
	ELSE IF @Id_Values <> '###NULL###' AND @IsPrimaryIN = 0 
	BEGIN
		IF @Id_Values LIKE 'SPPARM#%'
		BEGIN
			SET @Id_Values = (@Id_Values)
			SET @WhereClause = @WhereClause + 'Id NOT IN ('+@Id_Values+') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@Id_Values) > 0 SET @WhereClause = @WhereClause + 'Id NOT IN ('+@Id_Values+') AND '
			ELSE SET @WhereClause = @WhereClause + ' Id != '+@Id_Values+' AND '
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
IF @Code IS NOT NULL 
BEGIN
	IF @Code = '###NULL###' SET @WhereClause = @WhereClause + ' Code IS NULL AND ' 
	ELSE IF @Code_Values = '' SET @WhereClause = @WhereClause + ' Code = '''' AND '
	ELSE
	BEGIN
		IF @Code LIKE '%''%' SET @Code = REPLACE(@Code,'''','''''')
		SET @WhereClause = @WhereClause + 'Code LIKE ''%'+@Code+'%'' AND '
	END
END
IF @Code_Values IS NOT NULL 
BEGIN
	IF @Code_Values = '###NULL###' SET @WhereClause = @WhereClause + ' Code IS NULL AND ' 
	ELSE IF @Code_Values = '' SET @WhereClause = @WhereClause + ' Code = '''' AND '
	ELSE
	BEGIN
		IF @Code_Values LIKE '%''%' SET @Code_Values = REPLACE(@Code_Values,'''','''''')
		IF @Code_Values LIKE 'SPPARM#%'
		BEGIN
			SET @Code_Values = (@Code_Values)
			SET @Code_Values = REPLACE(@Code_Values,',',''',''')
			SET @WhereClause = @WhereClause + ' Code IN ('''+@Code_Values+''') AND '
		END
		ELSE
		BEGIN
			IF CHARINDEX(',',@Code_Values) > 0
			BEGIN
				SET @Code_Values = REPLACE(@Code_Values,',',''',''')
				SET @WhereClause = @WhereClause + ' Code IN ('''+@Code_Values+''') AND '
			END
			ELSE SET @WhereClause = @WhereClause + ' Code = '''+@Code_Values+''' AND '
		END
	END
END
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
	SET @Query = 'SELECT COUNT(1) FROM M_Branch  (NOLOCK)  ' + @WhereClause 

	INSERT INTO @ResultOutput EXEC(@Query)
	SET @ResultCount = (SELECT * from @ResultOutput)
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
	SET @Query = 'SELECT Id,Name,Code,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy FROM M_Branch  (NOLOCK)  ' + @WhereClause 
	EXEC(@Query)
END
ELSE
BEGIN
	IF @Page_Size IS NOT NULL AND @Page_Index IS NOT NULL
	BEGIN
	SET @Query = 'SELECT Id,Name,Code,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy FROM (SELECT ROW_NUMBER() OVER 
(ORDER BY '+ISNULL(@Sort_Column,'(SELECT NULL)') + ' ' + CASE WHEN CONVERT(NVARCHAR(MAX),@Sort_Ascending) = 0 THEN 'DESC' ELSE 'ASC' END + ') AS RowNum,M_Branch.* FROM M_Branch  (NOLOCK)  '+@WhereClause+' ) AS RowConstrainedResult
WHERE ('+CONVERT(NVARCHAR(MAX),@Page_Size)+' IS NULL) OR (RowNum >=  '+CONVERT(NVARCHAR(MAX),@Page_Size)+'*('+CONVERT(NVARCHAR(MAX),@Page_Index)+'-1)+1 AND  RowNum <= '+CONVERT(NVARCHAR(MAX),@Page_Size)+'*'+CONVERT(NVARCHAR(MAX),@Page_Index)+')
ORDER BY RowNum ' 
	END
	ELSE
	BEGIN
	SET @Query = 'SELECT Id,Name,Code,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy FROM (SELECT ROW_NUMBER() OVER 
(ORDER BY '+ISNULL(@Sort_Column,'(SELECT CreatedOn)') + ' ' + CASE WHEN CONVERT(NVARCHAR(MAX),@Sort_Ascending) = 0 THEN 'DESC' ELSE 'ASC' END + ') AS RowNum,M_Branch.* FROM M_Branch  (NOLOCK)  '+@WhereClause+' ) AS RowConstrainedResult
ORDER BY RowNum ' 
	END
	EXEC(@Query)
END
SET NOCOUNT OFF;
IF(1=0) BEGIN SELECT * FROM M_Branch  (NOLOCK)  END
--------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[spr_tb_M_Branch_Update]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spr_tb_M_Branch_Update]

@Id int,
@Name nvarchar(250),
@Code nvarchar(50) = NULL,
@CreatedOn datetime = NULL,
@CreatedBy varchar(50) = NULL,
@UpdatedOn datetime = NULL,
@UpdatedBy varchar(50) = NULL,
@ProcessingDateTime datetime2 = NULL


AS


SET NOCOUNT ON;


BEGIN
UPDATE  M_Branch
 SET 
Name = LTRIM(RTRIM(@Name)),
Code = LTRIM(RTRIM(@Code)),
UpdatedOn = @UpdatedOn,
UpdatedBy = LTRIM(RTRIM(@UpdatedBy))
 WHERE Id=@Id
END
SET NOCOUNT OFF;

--------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[spr_tb_M_Branch_Update_MO]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spr_tb_M_Branch_Update_MO]

@Id int,
@Name nvarchar(250) = NULL,
@Code nvarchar(50) = NULL,
@CreatedOn datetime = NULL,
@CreatedBy varchar(50) = NULL,
@UpdatedOn datetime = NULL,
@UpdatedBy varchar(50) = NULL,
@ProcessingDateTime datetime2 = NULL


AS
SET NOCOUNT ON;

IF (@UpdatedOn=(SELECT UpdatedOn FROM M_Branch (NOLOCK)  WHERE Id=@Id))
BEGIN
UPDATE  M_Branch
 SET 
Name = LTRIM(RTRIM(ISNULL(@Name,Name))),
Code = LTRIM(RTRIM(ISNULL(@Code,Code))),
UpdatedOn = @ProcessingDateTime,
UpdatedBy = LTRIM(RTRIM(ISNULL(@UpdatedBy,UpdatedBy)))


 WHERE Id=@Id
END
ELSE
BEGIN
DECLARE @LastUpdatedBy AS NVARCHAR(250) = ''
SELECT @LastUpdatedBy = UpdatedBy FROM M_Branch (NOLOCK)  WHERE Id=@Id
RAISERROR('Data which you want to modify already updated by %s. Please try again later.', 16, 1, @LastUpdatedBy)

END
SET NOCOUNT OFF;

--------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[spr_tb_UserLogin]    Script Date: 3/1/2020 10:36:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,01-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_UserLogin]
	@UserName NVARCHAR(250),
	@Password VARCHAR(250)
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT * FROM UM_UserLogin UL (NOLOCK)	 
	WHERE UL.[UserName] = @UserName 
	AND UL.[Password] = @Password
END
GO
USE [master]
GO
ALTER DATABASE [Alliant] SET  READ_WRITE 
GO
