CREATE TABLE [dbo].[UM_ErrorLog](
	[ErrorLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[Route] [varchar](350) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[StatckTrace] [nvarchar](max) NOT NULL,
	[UserID] [int] NULL,
	[ConnectionID] [uniqueidentifier] NULL,
	[TransactionID] [uniqueidentifier] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_UM_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[UM_ErrorLog] ADD  CONSTRAINT [DF_UM_ErrorLog_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ErrorLog_Insert]    Script Date: 21-04-2020 09:22:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-04-21
-- Description : Insert Procedure for UM_ErrorLog
-- Exec [dbo].[spr_tb_UM_ErrorLog_Insert] [ErrorLogID],[Route],[Message],[StatckTrace],[UserID],[ConnectionID],[TransactionID],[CreatedOn]
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ErrorLog_Insert]
     @Route  varchar(350)
    ,@Message  nvarchar(max)
    ,@StatckTrace  nvarchar(max)
    ,@UserID  int = NULL
    ,@ConnectionID  uniqueidentifier = NULL
    ,@TransactionID  uniqueidentifier = NULL
    ,@CreatedOn  datetime = NULL
    
AS
BEGIN

    INSERT INTO [dbo].[UM_ErrorLog]
    (
	    [Route]
        ,[Message]
        ,[StatckTrace]
        ,[UserID]
        ,[ConnectionID]
        ,[TransactionID]
        ,[CreatedOn]
        
    )
    VALUES
    (
         @Route
        ,@Message
        ,@StatckTrace
        ,@UserID
        ,@ConnectionID
        ,@TransactionID
        ,@CreatedOn        
    ) 
END


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ErrorLog_Search]    Script Date: 21-04-2020 09:22:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-04-21
-- Description : Select Procedure for UM_ErrorLog
-- Exec [dbo].[spr_tb_UM_ErrorLog_Search] 
-- ============================================= */
CREATE PROCEDURE [dbo].[spr_tb_UM_ErrorLog_Search]
   
AS
BEGIN
	SELECT * FROM [dbo].[UM_ErrorLog] (NOLOCK)   
END


GO

ALTER PROCEDURE [dbo].[spr_at_GetUserActivity]
	@UserID INT
AS
BEGIN
	SELECT * INTO [#PrimaryActivity] FROM [dbo].[UM_PrimaryActivity] WITH(NOLOCK)
	SELECT * INTO [#SecondaryActivity] FROM [dbo].[UM_SecondaryActivity] WITH(NOLOCK)

	SET NOCOUNT ON;	
	;WITH activityCTE AS
	(
		SELECT [SA].*,[PA].ActivityName,[Parent].[ActivityName] [ParentActivity]
		FROM [#SecondaryActivity] [SA] (NOLOCK)
		INNER JOIN [#PrimaryActivity] [PA] (NOLOCK)
		ON [PA].[PrimaryActivityID] = [SA].[ActivityID] 
		AND [PA].[IsActive] = 1
		INNER JOIN [#PrimaryActivity] [Parent] (NOLOCK)
		ON [Parent].[PrimaryActivityID] = [SA].[PrimaryActivityID]
		AND [Parent].[IsActive] = 1
		INNER JOIN [dbo].[UM_Role] [R] (NOLOCK) ON ([R].[RoleID] = [PA].[RoleID] OR [R].[ParentID] = [PA].[RoleID])
		AND [R].[IsActive] = 1
		INNER JOIN [dbo].[UM_RoleVsUser] [RU] (NOLOCK) 
		ON [RU].[RoleID] = [R].[RoleID] AND [RU].[UserID] = @UserID
		UNION
		SELECT [SA].*,[PA].ActivityName,[Parent].[ActivityName] [ParentActivity]
		FROM [#SecondaryActivity] [SA] (NOLOCK)
		INNER JOIN [#PrimaryActivity] [PA] (NOLOCK)
		ON [PA].[PrimaryActivityID] = [SA].[ActivityID] 
		AND [PA].[IsActive] = 1
		INNER JOIN [#PrimaryActivity] [Parent] (NOLOCK)
		ON [Parent].[PrimaryActivityID] = [SA].[PrimaryActivityID]
		AND [Parent].[IsActive] = 1
		INNER JOIN [dbo].[UM_RoleVsActivity] [RA] (NOLOCK) 
		ON ([RA].[ActivityID] = [SA].[PrimaryActivityID] OR [RA].[ActivityID] = [SA].[ActivityID]) 
		AND [RA].[IsActive] = 1
		INNER JOIN [dbo].[UM_RoleVsUser] [RU] (NOLOCK) 
		ON [RU].[RoleID] = [RA].[RoleID]
		AND [RU].[UserID] = @UserID
		UNION
		SELECT [SA].*,[PA].ActivityName,[Parent].[ActivityName] [ParentActivity]
		FROM [#SecondaryActivity] [SA] (NOLOCK)
		INNER JOIN [#PrimaryActivity] [PA] (NOLOCK)
		ON [PA].[PrimaryActivityID] = [SA].[ActivityID] 
		AND [PA].[IsActive] = 1
		INNER JOIN [#PrimaryActivity] [Parent] (NOLOCK)
		ON [Parent].[PrimaryActivityID] = [SA].[PrimaryActivityID]
		AND [Parent].[IsActive] = 1
		INNER JOIN [dbo].[UM_ActivityVsUser] [AU] (NOLOCK)
		ON ([AU].[ActivityID] = [Parent].[PrimaryActivityID] OR [PA].[PrimaryActivityID] = [AU].[ActivityID])
		AND [AU].[IsActive] = 1
		AND [AU].[UserID] = @UserID
	)
	SELECT * FROM activityCTE [activity]	
	OPTION (MAXRECURSION 0)
	SET NOCOUNT OFF;
END




