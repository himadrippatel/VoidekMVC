/*Session related store procedure and table*/
USE [Alliant]
GO

/****** Object:  Table [dbo].[UM_UserSession]    Script Date: 3/5/2020 8:39:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UM_UserSession](
	[UserSessionID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[SessionData] [varchar](max) NOT NULL,
	[Token] [varchar](40) NULL,
	[CreatedOn] [datetime] NULL,
	[LastAccessOn] [datetime] NULL,
	[RequestIP] [varchar](50) NULL,
 CONSTRAINT [PK_UM_UserSession] PRIMARY KEY CLUSTERED 
(
	[UserSessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

USE [Alliant]
GO

/****** Object:  StoredProcedure [dbo].[spr_at_UserSession_Insert]    Script Date: 3/5/2020 8:39:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,04-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_at_UserSession_Insert]
	@UserID INT,
	@SessionData VARCHAR(MAX),
	@Token VARCHAR(40) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM [dbo].[UM_UserSession] WITH(NOLOCK) WHERE UserID = @UserID AND Token = @Token)
	BEGIN
		INSERT INTO [dbo].[UM_UserSession]
		(
			[UserID],
			[SessionData],
			[Token],
			[CreatedOn]
		)
		VALUES
		(
		 @UserID,
		 @SessionData,
		 @Token,
		 GETUTCDATE()
		)
	END
	ELSE
	BEGIN
		UPDATE [dbo].[UM_UserSession] 
		SET [SessionData] = @SessionData
		WHERE [UserID] = @UserID AND [Token] = @Token	
	END

	EXEC [dbo].[spr_at_UserSession] @UserID,@Token
END
GO
USE [Alliant]
GO

/****** Object:  StoredProcedure [dbo].[spr_at_UserSession]    Script Date: 3/5/2020 8:40:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,04-03-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_at_UserSession]
	@UserID INT = NULL,
	@Toekn VARCHAR(40) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT 
	 UserSessionID
	,UserID
	,SessionData
	,Token
	,CreatedOn
	,LastAccessOn
	,RequestIP
	FROM [dbo].[UM_UserSession] WITH(NOLOCK)
	WHERE ([UserID] = @UserID OR [Token] = @Toekn)
END
GO



