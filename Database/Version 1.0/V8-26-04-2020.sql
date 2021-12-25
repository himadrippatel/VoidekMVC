-- =============================================  
-- Author:  <Author,Jishan Siddique>  
-- Create date: <Create Date,26-04-2020>  
-- Description: <Description,->  
-- =============================================  
CREATE PROCEDURE spr_at_UserSession_Delete  
 @UserID INT,  
 @Token VARCHAR(40) = NULL  
AS  
BEGIN  
 DELETE FROM [dbo].[UM_UserSession]   
 WHERE [UserID] = @UserID AND [Token] = @Token  
END  
GO

ALTER PROCEDURE [dbo].[spr_at_UserSession_Insert]  
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
   [CreatedOn],  
   [LastAccessOn]  
  )  
  VALUES  
  (  
   @UserID,  
   @SessionData,  
   @Token,  
   GETDATE(),  
   GETDATE()  
  )  
 END  
 ELSE  
 BEGIN  
  UPDATE [dbo].[UM_UserSession]   
  SET [SessionData] = @SessionData,  
  LastAccessOn = GETDATE()  
  WHERE [UserID] = @UserID AND [Token] = @Token   
 END  
  
 EXEC [dbo].[spr_at_UserSession] @UserID,@Token  
END  
GO

ALTER PROCEDURE [dbo].[spr_at_UserSession]
	@UserID INT = NULL,
	@Toekn VARCHAR(40) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT 
	 [US].[UserSessionID]
	,[US].[UserID]
	,[US].[SessionData]
	,[US].[Token]
	,[US].[CreatedOn]
	,[US].[LastAccessOn]
	,[US].[RequestIP]
	,[Result].*
	FROM [dbo].[UM_UserSession] [US] WITH(NOLOCK)
	CROSS APPLY OPENJSON([US].[SessionData])
	WITH
	(		 
		 [CustID] INT
		,[Inactive] NVARCHAR(10)
		,[OnHold] NVARCHAR(10)
		,[IsVendor] NVARCHAR(10)
		,[VendorType] NVARCHAR(50)
		,[Customer] NVARCHAR(250)
		,[WebAddress] NVARCHAR(250)
		,[Address] NVARCHAR(250)
		,[AddrCity] NVARCHAR(100)
		,[AddrState] NVARCHAR(100)
		,[AddrZip] NVARCHAR(10)
		,[Phone] NVARCHAR(20)
		,[creditauth] NVARCHAR(10)
		,[creditapp] NVARCHAR(10)
		,[Account_Rep] NVARCHAR(100)
		,[UrgentNotes] NVARCHAR(100)
		,[donotcontact] BIT
		,[DonotContactDate] DATETIME
		,[DoNotContactBy] NVARCHAR(250)
		,[CustAccountRep] INT
		,[Email] NVARCHAR(250)
		,[Imageurl] NVARCHAR(250)
	) AS [Result]
	WHERE ([US].[UserID] = @UserID OR [US].[Token] = @Toekn)
END
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,26-04-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spr_at_IsSuperAdmin
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;
		SELECT CONVERT(BIT,1) AS IsSuperAdminLoggedIn 
		FROM [dbo].[UM_RoleVsUser] WITH(NOLOCK)
		WHERE [UserID] = @UserID 
		AND [RoleID] = 1
	SET NOCOUNT OFF;
END
GO