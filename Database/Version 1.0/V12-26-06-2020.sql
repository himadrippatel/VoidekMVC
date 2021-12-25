CREATE PROCEDURE [dbo].[spr_at_UserSessionByToken]	
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
		--,[DonotContactDate] DATETIME
		,[DoNotContactBy] NVARCHAR(250)
		,[CustAccountRep] INT
		,[Email] NVARCHAR(250)
		,[Imageurl] NVARCHAR(250)
	) AS [Result]
	WHERE [US].[Token] = @Toekn
END