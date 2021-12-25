USE [alliant_mvc]
GO

/****** Object:  View [dbo].[VW_CancelQuoteFollowUpData]    Script Date: 29-07-2020 09:39:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VW_CancelQuoteFollowUpData]
AS
SELECT * FROM
(
	SELECT DISTINCT
	 [Employee].[EmployeeName] [SalesRep]
	,[Customers].[CustName]
	,[Branch].[BranchCode] [QuoteBranchCode]
	,[Branch].[BranchID]
	,[Quote].[QInternalNote] [Note]
	,[Quote].[QuoteID]
	,[Quote].[ReturnDate]
	,([Quote].[QuoteFreight] + [Quote].[QuoteDelivery] + [Quote].[QuoteLabor] + [Quote].[QuoteEquipRented]) [Total]
	,[Quote].[CustID] [CustomerId]
	,[Employee].[EmployeeID]
	,[Interest].[Interest]
	,[Interest].[QuoteTypeNo]
	,[LastActivity].[LastActivityDateTime]
	,[LastActivity].[LastActivityNote]
	,[LastActivity].[DepartmentID]
	,[LastActivity].[DepartmentDescription]
	,DENSE_RANK() OVER(PARTITION BY [Quote].[CustID] ORDER BY [Quote].[ReturnDate] DESC) [Rank] 
FROM
[dbo].[tblQuote] [Quote] (NOLOCK)
INNER JOIN [dbo].[tblCustomers] [Customers] (NOLOCK)
	ON [Customers].[CustID] = [Quote].[CustID]
	AND [Quote].[SalesRep] = [Customers].[CustAccountRep]
INNER JOIN [dbo].[tblBranch] [Branch] (NOLOCK)
	ON [Branch].[BranchID] = [Quote].[QuoteOriginatingBranchId]
LEFT JOIN [dbo].[tblEmployee] [Employee] (NOLOCK)
	ON [Employee].[EmployeeID] = [Quote].[SalesRep]
LEFT JOIN [dbo].[tblSalesActivity] [SalesActivity] (NOLOCK)
	ON [SalesActivity].[QuoteId] = [Quote].[QuoteID]
LEFT JOIN(
	SELECT
		[SalesActivity].[DateTime] [LastActivityDateTime]
		,LEFT([SalesActivity].[Note], 150) [LastActivityNote]
		,[SalesActivityDepartment].[DepartmentDescription] 
		,[SalesActivity].[DepartmentID]
		,[SalesActivity].[QuoteId]
	FROM [dbo].[tblSalesActivity] [SalesActivity] (NOLOCK)
	INNER JOIN [dbo].[tblSalesActivityDepartment] [SalesActivityDepartment] (NOLOCK)
	  	ON [SalesActivityDepartment].[DepartmentId] = [SalesActivity].[DepartmentID]  
		AND [SalesActivityDepartment].[DepartmentDescription] = 'Sales'
) AS [LastActivity]
ON [LastActivity].[QuoteID] = [Quote].[QuoteID] 
INNER JOIN
(
      SELECT
         [QuoteTypes].[QuoteType] [Interest],[QuoteTypes].[QuoteTypeNo]  
      FROM
         [dbo].[tblQuoteTypes] [QuoteTypes] (NOLOCK)      
)
AS [Interest]
ON [Interest].[QuoteTypeNo] = [Quote].[InterestType]
) AS [Result]
WHERE [Rank] = 1 






GO

/****** Object:  View [dbo].[VW_ConfirmedQuoteFollowdata]    Script Date: 29-07-2020 09:39:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER  VIEW [dbo].[VW_ConfirmedQuoteFollowdata]
AS
SELECT  DISTINCT
	   [Quote].[QuoteID]
	  ,[Quote].[QInternalNote] [Note]
	  ,[Quote].[ReturnDate]
	  ,([Quote].[QuoteFreight] + [Quote].[QuoteDelivery] + [Quote].[QuoteLabor] + [Quote].[QuoteEquipRented]) [Total]
	  ,[Interest].[Interest]
	  ,[Quote].[InterestType]
	  ,[Customers].[CustName]
	  ,[Branch].[BranchID]
	  ,[Branch].[BranchCode] [QuoteBranchCode]
	  ,[Employee].[EmployeeID]
	  ,[Employee].[EmployeeName] [SalesRep]
	  ,[Customers].[CustID] [CustomerId]
	  ,[LastActivity].[LastActivityDateTime]
	  ,[LastActivity].[LastActivityNote]
	  ,[LastActivity].[DepartmentDescription]
	  ,[LastActivity].[DepartmentID]
FROM [dbo].[tblQuote] [Quote] (NOLOCK)
INNER JOIN [dbo].[tblCustomers] [Customers] (NOLOCK)
	ON [Customers].[CustID] = [Quote].[CustID]
INNER JOIN [dbo].[tblBranch] [Branch] (NOLOCK)
	ON [Branch].[BranchID] = [Quote].[QuoteOriginatingBranchId]
LEFT JOIN [dbo].[tblEmployee] [Employee] ON
	[Employee].[EmployeeID] = [Quote].[SalesRep]
LEFT JOIN(
	SELECT
         [SalesActivity].[DateTime] [LastActivityDateTime]
		 ,LEFT([SalesActivity].[Note], 150) [LastActivityNote]
		 ,[SalesActivityDepartment].[DepartmentDescription] 
		 ,[SalesActivity].[DepartmentID]
		 ,[SalesActivity].[QuoteId]
      FROM [dbo].[tblSalesActivity] [SalesActivity] (NOLOCK)
	  INNER JOIN [dbo].[tblSalesActivityDepartment] [SalesActivityDepartment] (NOLOCK)
	  	   ON [SalesActivityDepartment].[DepartmentId] = [SalesActivity].[DepartmentID]  
		   AND [SalesActivityDepartment].[DepartmentDescription] = 'Sales'
) AS [LastActivity]
ON [LastActivity].[QuoteId] = [Quote].[QuoteID]
LEFT JOIN
(
      SELECT
         [QuoteTypes].[QuoteType] [Interest],[QuoteTypes].[QuoteTypeNo]  
      FROM
         [dbo].[tblQuoteTypes] [QuoteTypes] (NOLOCK)      
)
AS [Interest]
ON [Interest].[QuoteTypeNo] = [Quote].[InterestType]
GO

/****** Object:  View [dbo].[VW_FollowUpRemindersData]    Script Date: 29-07-2020 09:39:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--Method name KendoMvcproject FollowUpListReminders_Read
-- VW_FollowUpRemindersData
ALTER VIEW [dbo].[VW_FollowUpRemindersData]
AS
SELECT 
	 [Customers].[CustID]
	,[Customers].[CustName]
	,[Branch].[BranchID]
	,[Branch].[BranchCode] [CustBranchCode]
	,[Branch].[BranchName]
	,[SalesActivity].[SalesActivityID]
	,[SalesActivity].[CustomerId]
	,[SalesActivity].[QuoteId]
	,[SalesActivity].[DepartmentID]
	,[SalesActivity].[UserId]
	,[SalesActivity].[DateTime] [CreatedDateTime]
	,[SalesActivity].[ActivityType]
	,[ActivityFlags].[FlagDescription]
	,LEFT([SalesActivity].[Note], 2000) [Note]
	,[SalesActivity].[FollowUpDate]
	,[SalesActivity].[FollowUpTime]
	,[Employee].[EmployeeName] [SalesRep]
	,[Employee].[EmployeeID]
	,[QuoteBranch].[BranchCode] [QuoteBranchCode]
	,CASE WHEN ISNULL([SalesActivity].[QuoteId], '') = '' THEN
		(SELECT TOP 1 [BranchCode] FROM [dbo].[tblbranch](NOLOCK) WHERE [Branch].[BranchID] = [Customers].[CustBranchID]) 
	 ELSE (SELECT TOP 1 [tblBranch].[BranchCode] FROM [dbo].[tblQuote] (NOLOCK) 
			INNER JOIN [dbo].[tblBranch] (NOLOCK)
			ON [tblQuote].[QuoteOriginatingBranchId] 
			= [tblBranch].[BranchID] WHERE [tblQuote].[QuoteID] = [SalesActivity].[QuoteId]) 
	 END [Branch]
	,[Quote].[DeliveryDate]
	,[InterestType].[Interest]	
	,([Quote].[QuoteEquipRented] + [Quote].[QuoteLabor] + [Quote].[QuoteDelivery] + [Quote].[QuoteFreight]) [Total]
	,IIF([SalesActivity].[FollowUpDate] < GETDATE(),1,0) [FollowUpDateFlag]	
	FROM 
[dbo].[tblCustomers] [Customers] (NOLOCK)
INNER JOIN [dbo].[tblBranch] [Branch] (NOLOCK) ON
	[Branch].[BranchID] = [Customers].[CustBranchID] 
RIGHT JOIN [dbo].[tblSalesActivity] [SalesActivity] (NOLOCK) ON
	[SalesActivity].[CustomerId] = [Customers].[CustID]
LEFT JOIN [dbo].[tblEmployee] [Employee] (NOLOCK) ON
	[Employee].[EmployeeID] = [SalesActivity].[UserId]
LEFT JOIN [dbo].[tblSalesActivityDepartment] [SalesActivityDepartment] (NOLOCK) ON
	[SalesActivityDepartment].[DepartmentId] = [SalesActivity].[DepartmentID]
LEFT JOIN [dbo].[tblActivityFlags] [ActivityFlags] (NOLOCK) ON
	[ActivityFlags].[FlagId] = [SalesActivity].[FlagId]
LEFT JOIN [dbo].[tblSalesActivityTypes] [SalesActivityTypes] (NOLOCK) ON
	[SalesActivityTypes].[ActivityId] = [SalesActivity].[ActivityType]
LEFT JOIN [dbo].[tblQuote] [Quote] (NOLOCK)
	ON [Quote].[QuoteID] = [SalesActivity].[QuoteId]
LEFT JOIN(
	SELECT
           DISTINCT tblBranch.BranchCode,tblQuote.QuoteID 
         FROM
            [dbo].[tblQuote] (NOLOCK) 
            INNER JOIN
               [dbo].[tblBranch] (NOLOCK) 
               ON tblQuote.QuoteOriginatingBranchId = tblBranch.BranchID 
        
) AS [QuoteBranch]
ON [QuoteBranch].[QuoteID] = [SalesActivity].[QuoteId]
LEFT JOIN(
	SELECT
          DISTINCT [tblQuoteTypes].[QuoteType] [Interest],
		  [tblQuote].[QuoteID]
         FROM
            [dbo].[tblQuote] (NOLOCK) 
            INNER JOIN
               [dbo].[tblQuoteTypes] (NOLOCK) 
               ON [tblQuote].[InterestType] = [tblQuoteTypes].[QuoteTypeNo] 
) AS [InterestType]
ON [InterestType].[QuoteID] = [SalesActivity].[QuoteId]
WHERE [Employee].[Active] = 'YES' 
AND [SalesActivity].[Dismiss] <> 1	
GO

/****** Object:  View [dbo].[VW_FutureBusinessFollowUpData]    Script Date: 29-07-2020 09:39:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [dbo].[VW_FutureBusinessFollowUpData]
AS

SELECT 
	[Quote].[QuoteID]
   ,[Employee].[EmployeeName]
   ,[Customers].[CustName]
   ,[Branch].[BranchID]
   ,[Branch].[BranchName]
   ,[Branch].[BranchCode]
   ,[Quote].[QInternalNote] [Note]
   ,[Quote].[DeliveryDate]
   ,([Quote].[QuoteFreight] + [Quote].[QuoteDelivery] + [Quote].[QuoteLabor] + [Quote].[QuoteEquipRented]) [Total]
   ,[Quote].[CustID] [CustomerId]
   ,[Employee].[EmployeeID]
   ,[InterestType].[QuoteType] [Interest]
   ,[LastActivity].[LastActivityDateTime]
   ,[LastActivity].[LastActivityNote]
   ,[LastActivity].[DepartmentDescription]
   ,[LastActivity].[DepartmentID]
FROM [dbo].[tblQuote] [Quote] (NOLOCK)
INNER JOIN [dbo].[tblCustomers] [Customers] (NOLOCK)
	ON [Customers].[CustID] = [Quote].[CustID]
	AND [Quote].[InterestType] NOT IN(1,2,3,5)
INNER JOIN [dbo].[tblBranch] [Branch] (NOLOCK)
	ON [Branch].[BranchID] = [Quote].[QuoteOriginatingBranchId]
LEFT JOIN [dbo].[tblEmployee] [Employee] (NOLOCK)
	ON [Employee].[EmployeeID] = [Quote].[SalesRep]
LEFT JOIN(
	SELECT
         [SalesActivity].[DateTime] [LastActivityDateTime]
		 ,LEFT([SalesActivity].[Note], 150) [LastActivityNote]
		 ,[SalesActivityDepartment].[DepartmentDescription] 
		 ,[SalesActivity].[DepartmentID]
		 ,[SalesActivity].[QuoteId]
      FROM [dbo].[tblSalesActivity] [SalesActivity] (NOLOCK)
	  INNER JOIN [dbo].[tblSalesActivityDepartment] [SalesActivityDepartment] (NOLOCK)
	  	   ON [SalesActivityDepartment].[DepartmentId] = [SalesActivity].[DepartmentID]  
		   AND [SalesActivityDepartment].[DepartmentDescription] = 'Sales'
) AS [LastActivity]
ON [LastActivity].[QuoteId] = [Quote].[QuoteID]
LEFT JOIN(
	SELECT
         [tblQuoteTypes].[QuoteType],[tblQuoteTypes].[QuoteTypeNo]
      FROM [dbo].[tblQuoteTypes] (NOLOCK)         
) [InterestType]
ON [InterestType].[QuoteTypeNo] = [Quote].[InterestType]
GO

/****** Object:  View [dbo].[VW_InActiveAccountFolloUpData]    Script Date: 29-07-2020 09:39:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VW_InActiveAccountFolloUpData]
AS
SELECT 
	 [Branch].[BranchID]
	,[Branch].[Active]
	,[Customers].[CustName]
	,[Employee].[EmployeeName] [SalesRep]
	,[Customers].[OrderFrequency]
	,[Customers].[DoNotContact]
	,[Customers].[DoNotContactDate]
	,[Customers].[DoNotContactBy]
	,[Customers].[CustID] [CustomerId]
	,MAX(ISNULL([Quote].[QuoteEnteredDate], CONVERT(DATETIME, '1990-01-01 00:00:00', 102))) [EnterDate]
	,MAX([Quote].[QuoteID]) [QuoteId]
	,MAX([Quote].[DeliveryDate]) [DeliveryDate]
	,[QuoteTypes].[QuoteType] [Interest]
	,[Branch].[BranchCode] [CustBranchCode]
	,NULL [QuoteBranchCode]
	,NULL [Note]
	,[SalesActivity].[MaxDateTime]
	,([Quote].[QuoteFreight] + [Quote].[QuoteDelivery] + [Quote].[QuoteLabor] + [Quote].[QuoteEquipRented]) [Total]
FROM [dbo].[tblBranch] [Branch] (NOLOCK)
INNER JOIN [dbo].[tblCustomers] [Customers] (NOLOCK)
	ON [Customers].[CustBranchID] = [Branch].[BranchID]
INNER JOIN [dbo].[tblEmployee] [Employee] (NOLOCK)
	ON [Employee].[EmployeeID] = [Customers].[CustAccountRep]
LEFT JOIN [dbo].[tblQuoteTypes] [QuoteTypes] (NOLOCK)
INNER JOIN [dbo].[tblQuote] [Quote] (NOLOCK)
	ON [Quote].[InterestType] = [QuoteTypes].[QuoteTypeNo]
	ON [Quote].[CustID] = [Customers].[CustID]
INNER JOIN(
	SELECT MAX(DateTime) [MaxDateTime],[CustomerId]
	FROM [dbo].[tblSalesActivity] (NOLOCK)
	GROUP BY [CustomerId]
)[SalesActivity]
ON [SalesActivity].[CustomerId] = [Customers].[CustID]
GROUP BY 
	 [Branch].[BranchID]
	,[Branch].[Active]
	,[Customers].[CustName]
	,[Employee].[EmployeeName]
	,[Customers].[OrderFrequency]
	,[Customers].[DoNotContact]
	,[Customers].[DoNotContactDate]
	,[Customers].[DoNotContactBy]
	,[Customers].[CustID]
	,ISNULL([Quote].[QuoteEnteredDate], CONVERT(DATETIME, '1990-01-01 00:00:00', 102))
	,[Quote].[QuoteID]
	,[Quote].[DeliveryDate]
	,[QuoteTypes].[QuoteType]
	,[Branch].[BranchCode]
	,[SalesActivity].[MaxDateTime]
	,[SalesActivity].[MaxDateTime]
	,([Quote].[QuoteFreight] + [Quote].[QuoteDelivery] + [Quote].[QuoteLabor] + [Quote].[QuoteEquipRented])
GO

/****** Object:  View [dbo].[VW_PotentialRepeatBusinessFollowUpData]    Script Date: 29-07-2020 09:39:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VW_PotentialRepeatBusinessFollowUpData]
AS
SELECT
	 [Employee].[EmployeeID]
	,[Employee].[EmployeeName] [SalesRep]
	,[Customers].[CustName]
	,[Interest].[Interest]
	,[Interest].[QuoteTypeNo]
	,[Customers].[OrderFrequency]
	,[Customers].[DoNotContact]
	,[Customers].[DoNotContactDate]
	,[Customers].[DoNotContactBy]
	,[Branch].[BranchID]
	,[Branch].[BranchCode] [QuoteBranchCode]
	,[Branch].[BranchName]
	,'' [Note]
	,[Quote].[QuoteID]
	,[Quote].[DeliveryDate]
	,[Quote].[QuoteEnteredDate] [EnterDate]
	,([Quote].[QuoteFreight] + [Quote].[QuoteDelivery] + [Quote].[QuoteLabor] + [Quote].[QuoteEquipRented]) [Total]
	,[Quote].[CustID] [CustomerId]
	,[Customers].[CustCode]
	,[LastActivity].[LastActivityDateTime] 
	,[LastActivity].[LastActivityNote] 
	,[LastActivity].[DepartmentID]
	,[LastActivity].[DepartmentDescription]
	,[Customers].[Inactive]
	,[SalesActivity].[MaxDateTime]
FROM [dbo].[tblQuote] [Quote] (NOLOCK)
INNER JOIN [dbo].[tblCustomers] [Customers] (NOLOCK)
	ON [Customers].[CustID] = [Quote].[CustID]
INNER JOIN [dbo].[tblBranch] [Branch] (NOLOCK)
	ON [Branch].[BranchID] = [Quote].[QuoteOriginatingBranchId]
LEFT JOIN [dbo].[tblEmployee] [Employee] (NOLOCK)
	ON [Employee].[EmployeeID] = [Customers].[CustAccountRep]
LEFT JOIN(
	SELECT
		[SalesActivity].[DateTime] [LastActivityDateTime]
		,LEFT([SalesActivity].[Note], 150) [LastActivityNote]
		,[SalesActivityDepartment].[DepartmentDescription] 
		,[SalesActivity].[DepartmentID]
		,[SalesActivity].[QuoteId]
	FROM [dbo].[tblSalesActivity] [SalesActivity] (NOLOCK)
	INNER JOIN [dbo].[tblSalesActivityDepartment] [SalesActivityDepartment] (NOLOCK)
	  	ON [SalesActivityDepartment].[DepartmentId] = [SalesActivity].[DepartmentID]  
		AND [SalesActivityDepartment].[DepartmentDescription] = 'Sales'
)[LastActivity]
ON [LastActivity].[QuoteID] = [Quote].[QuoteID] 
INNER JOIN
(
      SELECT
         [QuoteTypes].[QuoteType] [Interest],[QuoteTypes].[QuoteTypeNo]  
      FROM
         [dbo].[tblQuoteTypes] [QuoteTypes] (NOLOCK)      
)[Interest]
ON [Interest].[QuoteTypeNo] = [Quote].[InterestType]
INNER JOIN(
	SELECT MAX(DateTime) [MaxDateTime],[CustomerId]
	FROM [dbo].[tblSalesActivity] (NOLOCK)
	GROUP BY [CustomerId]
)[SalesActivity]
ON [SalesActivity].[CustomerId] = [Quote].[CustID]
GO

/****** Object:  View [dbo].[VW_QuoteNeedingFollowUpData]    Script Date: 29-07-2020 09:39:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[VW_QuoteNeedingFollowUpData]
AS
SELECT 
	[Employee].[EmployeeName] [SalesRep]
	,[Customers].[CustName]
	,[Branch].[BranchID]
	,[Branch].[BranchCode] [QuoteBranchCode]
	,[Quote].[QInternalNote] [Note]
	,[Quote].[QuoteID]
	,[Quote].[DeliveryDate]
	,([Quote].[QuoteFreight] + [Quote].[QuoteDelivery] + [Quote].[QuoteLabor] + [Quote].[QuoteEquipRented]) [Total]
	,[Quote].[CustID] [CustomerId]
	,[Employee].[EmployeeID]
	,[InterestType].[QuoteType] [Interest]	
	,[Quote].[InterestType]
	,[LastActivity].[LastActivityDateTime]
	,[LastActivity].[LastActivityNote]
FROM 
[dbo].[tblQuote] [Quote] (NOLOCK)
INNER JOIN [dbo].[tblCustomers] [Customers] (NOLOCK)
	ON [Customers].[CustID] = [Quote].[CustID]
	AND [Quote].[InterestType] NOT IN(1,5.2,6)
INNER JOIN [dbo].[tblBranch] [Branch]  (NOLOCK)
	ON [Branch].[BranchID] = [Quote].[QuoteOriginatingBranchId]
LEFT JOIN [dbo].[tblEmployee] [Employee] (NOLOCK)
	ON [Employee].[EmployeeID] = [Quote].[SalesRep]
LEFT JOIN(
	SELECT
         [SalesActivity].[DateTime] [LastActivityDateTime]
		 ,LEFT([SalesActivity].[Note], 150) [LastActivityNote]
		 ,[SalesActivityDepartment].[DepartmentDescription] 
		 ,[SalesActivity].[DepartmentID]
		 ,[SalesActivity].[QuoteId]
      FROM [dbo].[tblSalesActivity] [SalesActivity] (NOLOCK)
	  INNER JOIN [dbo].[tblSalesActivityDepartment] [SalesActivityDepartment] (NOLOCK)
	  	   ON [SalesActivityDepartment].[DepartmentId] = [SalesActivity].[DepartmentID]  
		   AND [SalesActivityDepartment].[DepartmentDescription] = 'Sales'
) AS [LastActivity]
ON [LastActivity].[QuoteId] = [Quote].[QuoteID]
LEFT JOIN(
	 SELECT
         [tblQuoteTypes].[QuoteType],[tblQuoteTypes].[QuoteTypeNo] 
      FROM
         [dbo].[tblQuoteTypes] (NOLOCK)    
) [InterestType]
ON [InterestType].[QuoteTypeNo] = [Quote].[InterestType]
GO


/****** Object:  StoredProcedure [dbo].[spr_tb_VW_CancelQuoteFollowUpData_View_Search]    Script Date: 29-07-2020 09:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_CancelQuoteFollowUpData_View_Search]

@ResultCount INT OUTPUT,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@QuoteBranchCode nvarchar(50) = NULL,
@QuoteBranchCode_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@Note nvarchar(1024) = NULL,
@Note_Values nvarchar(max) = NULL,
@QuoteID_Values nvarchar(max) = NULL,
@QuoteID_Min int = NULL,
@QuoteID_Max int = NULL,
@ReturnDate_Values nvarchar(max) = NULL,
@ReturnDate_Min datetime = NULL,
@ReturnDate_Max datetime = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@CustomerId_Values nvarchar(max) = NULL,
@CustomerId_Min int = NULL,
@CustomerId_Max int = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
@Interest nvarchar(50) = NULL,
@Interest_Values nvarchar(max) = NULL,
@QuoteTypeNo_Values nvarchar(max) = NULL,
@QuoteTypeNo_Min float = NULL,
@QuoteTypeNo_Max float = NULL,
@LastActivityDateTime_Values nvarchar(max) = NULL,
@LastActivityDateTime_Min datetime = NULL,
@LastActivityDateTime_Max datetime = NULL,
@LastActivityNote nvarchar(150) = NULL,
@LastActivityNote_Values nvarchar(max) = NULL,
@DepartmentID_Values nvarchar(max) = NULL,
@DepartmentID_Min int = NULL,
@DepartmentID_Max int = NULL,
@DepartmentDescription nvarchar(50) = NULL,
@DepartmentDescription_Values nvarchar(max) = NULL,
@Rank_Values nvarchar(max) = NULL,
@Rank_Min bigint = NULL,
@Rank_Max bigint = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1

AS
BEGIN
SET NOCOUNT ON;
SET @ResultCount = 0
IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
SET @ResultCount = (SELECT COUNT(1) FROM [dbo].[VW_CancelQuoteFollowUpData] (NOLOCK)
 WHERE (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND [ReturnDate] IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND [ReturnDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR [ReturnDate] >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR [ReturnDate] <=  @ReturnDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND [QuoteTypeNo] IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND [QuoteTypeNo] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR [QuoteTypeNo] >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR [QuoteTypeNo] <=  @QuoteTypeNo_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@Rank_Values IS NULL OR  (@Rank_Values = '###NULL###' AND [Rank] IS NULL ) OR (@Rank_Values <> '###NULL###' AND [Rank] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Rank_Values,','))))
 AND (@Rank_Min IS NULL OR [Rank] >=  @Rank_Min)
 AND (@Rank_Max IS NULL OR [Rank] <=  @Rank_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT SalesRep,CustName,QuoteBranchCode,BranchID,Note,QuoteID,ReturnDate,Total,CustomerId,EmployeeID,Interest,QuoteTypeNo,LastActivityDateTime,LastActivityNote,DepartmentID,DepartmentDescription,Rank FROM  [dbo].[VW_CancelQuoteFollowUpData] (NOLOCK)

 WHERE (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND [ReturnDate] IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND [ReturnDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR [ReturnDate] >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR [ReturnDate] <=  @ReturnDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND [QuoteTypeNo] IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND [QuoteTypeNo] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR [QuoteTypeNo] >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR [QuoteTypeNo] <=  @QuoteTypeNo_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@Rank_Values IS NULL OR  (@Rank_Values = '###NULL###' AND [Rank] IS NULL ) OR (@Rank_Values <> '###NULL###' AND [Rank] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Rank_Values,','))))
 AND (@Rank_Min IS NULL OR [Rank] >=  @Rank_Min)
 AND (@Rank_Max IS NULL OR [Rank] <=  @Rank_Max)
 
END
ELSE
BEGIN
SELECT SalesRep,CustName,QuoteBranchCode,BranchID,Note,QuoteID,ReturnDate,Total,CustomerId,EmployeeID,Interest,QuoteTypeNo,LastActivityDateTime,LastActivityNote,DepartmentID,DepartmentDescription,Rank FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[SalesRep] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[SalesRep] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[SalesRep] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[CustName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[CustName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[CustName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[QuoteBranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[QuoteBranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[QuoteBranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[BranchID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[BranchID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[BranchID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[Note] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[Note] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[Note] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[QuoteID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[QuoteID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[QuoteID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[ReturnDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[ReturnDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[ReturnDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[Total] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[Total] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[Total] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[CustomerId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[CustomerId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[CustomerId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[EmployeeID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[EmployeeID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[EmployeeID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[Interest] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[Interest] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[Interest] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[QuoteTypeNo] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[QuoteTypeNo] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[QuoteTypeNo] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[LastActivityDateTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[LastActivityDateTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[LastActivityDateTime] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[LastActivityNote] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[LastActivityNote] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[LastActivityNote] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[DepartmentID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[DepartmentID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[DepartmentID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[DepartmentDescription] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[DepartmentDescription] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[DepartmentDescription] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Rank' OR @Sort_Column='Rank') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_CancelQuoteFollowUpData].[Rank] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Rank' OR @Sort_Column='Rank') AND @Sort_Ascending=1 THEN [VW_CancelQuoteFollowUpData].[Rank] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CancelQuoteFollowUpData.Rank' OR @Sort_Column='Rank') AND @Sort_Ascending=0 THEN [VW_CancelQuoteFollowUpData].[Rank] ELSE NULL END DESC
 ) AS RowNum, [VW_CancelQuoteFollowUpData].*
 FROM  [dbo].[VW_CancelQuoteFollowUpData] (NOLOCK)

 WHERE (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND [ReturnDate] IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND [ReturnDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR [ReturnDate] >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR [ReturnDate] <=  @ReturnDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND [QuoteTypeNo] IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND [QuoteTypeNo] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR [QuoteTypeNo] >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR [QuoteTypeNo] <=  @QuoteTypeNo_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@Rank_Values IS NULL OR  (@Rank_Values = '###NULL###' AND [Rank] IS NULL ) OR (@Rank_Values <> '###NULL###' AND [Rank] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Rank_Values,','))))
 AND (@Rank_Min IS NULL OR [Rank] >=  @Rank_Min)
 AND (@Rank_Max IS NULL OR [Rank] <=  @Rank_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_ConfirmedQuoteFollowdata_View_Search]    Script Date: 29-07-2020 09:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_ConfirmedQuoteFollowdata_View_Search]

@ResultCount INT OUTPUT,
@QuoteID_Values nvarchar(max) = NULL,
@QuoteID_Min int = NULL,
@QuoteID_Max int = NULL,
@Note nvarchar(1024) = NULL,
@Note_Values nvarchar(max) = NULL,
@ReturnDate_Values nvarchar(max) = NULL,
@ReturnDate_Min datetime = NULL,
@ReturnDate_Max datetime = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@Interest nvarchar(50) = NULL,
@Interest_Values nvarchar(max) = NULL,
@InterestType_Values nvarchar(max) = NULL,
@InterestType_Min float = NULL,
@InterestType_Max float = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@QuoteBranchCode nvarchar(50) = NULL,
@QuoteBranchCode_Values nvarchar(max) = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@CustomerId_Values nvarchar(max) = NULL,
@CustomerId_Min int = NULL,
@CustomerId_Max int = NULL,
@LastActivityDateTime_Values nvarchar(max) = NULL,
@LastActivityDateTime_Min datetime = NULL,
@LastActivityDateTime_Max datetime = NULL,
@LastActivityNote nvarchar(150) = NULL,
@LastActivityNote_Values nvarchar(max) = NULL,
@DepartmentDescription nvarchar(50) = NULL,
@DepartmentDescription_Values nvarchar(max) = NULL,
@DepartmentID_Values nvarchar(max) = NULL,
@DepartmentID_Min int = NULL,
@DepartmentID_Max int = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1

AS
BEGIN
SET NOCOUNT ON;
SET @ResultCount = 0
IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
SET @ResultCount = (SELECT COUNT(1) FROM [dbo].[VW_ConfirmedQuoteFollowdata] (NOLOCK)
 WHERE (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND [ReturnDate] IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND [ReturnDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR [ReturnDate] >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR [ReturnDate] <=  @ReturnDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND [InterestType] IS NULL ) OR (@InterestType_Values <> '###NULL###' AND [InterestType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR [InterestType] >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR [InterestType] <=  @InterestType_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT QuoteID,Note,ReturnDate,Total,Interest,InterestType,CustName,BranchID,QuoteBranchCode,EmployeeID,SalesRep,CustomerId,LastActivityDateTime,LastActivityNote,DepartmentDescription,DepartmentID FROM  [dbo].[VW_ConfirmedQuoteFollowdata] (NOLOCK)

 WHERE (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND [ReturnDate] IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND [ReturnDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR [ReturnDate] >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR [ReturnDate] <=  @ReturnDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND [InterestType] IS NULL ) OR (@InterestType_Values <> '###NULL###' AND [InterestType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR [InterestType] >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR [InterestType] <=  @InterestType_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 
END
ELSE
BEGIN
SELECT QuoteID,Note,ReturnDate,Total,Interest,InterestType,CustName,BranchID,QuoteBranchCode,EmployeeID,SalesRep,CustomerId,LastActivityDateTime,LastActivityNote,DepartmentDescription,DepartmentID FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[QuoteID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[QuoteID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[QuoteID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[Note] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[Note] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Note' OR @Sort_Column='Note') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[Note] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[ReturnDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[ReturnDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[ReturnDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[Total] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[Total] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[Total] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[Interest] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[Interest] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[Interest] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[InterestType] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[InterestType] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[InterestType] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[CustName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[CustName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[CustName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[BranchID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[BranchID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[BranchID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[QuoteBranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[QuoteBranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[QuoteBranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[EmployeeID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[EmployeeID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[EmployeeID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[SalesRep] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[SalesRep] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[SalesRep] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[CustomerId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[CustomerId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[CustomerId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[LastActivityDateTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[LastActivityDateTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[LastActivityDateTime] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[LastActivityNote] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[LastActivityNote] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[LastActivityNote] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[DepartmentDescription] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[DepartmentDescription] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[DepartmentDescription] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_ConfirmedQuoteFollowdata].[DepartmentID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN [VW_ConfirmedQuoteFollowdata].[DepartmentID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_ConfirmedQuoteFollowdata.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=0 THEN [VW_ConfirmedQuoteFollowdata].[DepartmentID] ELSE NULL END DESC
 ) AS RowNum, [VW_ConfirmedQuoteFollowdata].*
 FROM  [dbo].[VW_ConfirmedQuoteFollowdata] (NOLOCK)

 WHERE (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND [ReturnDate] IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND [ReturnDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR [ReturnDate] >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR [ReturnDate] <=  @ReturnDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND [InterestType] IS NULL ) OR (@InterestType_Values <> '###NULL###' AND [InterestType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR [InterestType] >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR [InterestType] <=  @InterestType_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_FollowUpRemindersData_View_Search]    Script Date: 29-07-2020 09:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_FollowUpRemindersData_View_Search]

@ResultCount INT OUTPUT,
@CustID_Values nvarchar(max) = NULL,
@CustID_Min int = NULL,
@CustID_Max int = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@CustBranchCode nvarchar(50) = NULL,
@CustBranchCode_Values nvarchar(max) = NULL,
@BranchName nvarchar(50) = NULL,
@BranchName_Values nvarchar(max) = NULL,
@SalesActivityID_Values nvarchar(max) = NULL,
@SalesActivityID_Min int = NULL,
@SalesActivityID_Max int = NULL,
@CustomerId_Values nvarchar(max) = NULL,
@CustomerId_Min int = NULL,
@CustomerId_Max int = NULL,
@QuoteId_Values nvarchar(max) = NULL,
@QuoteId_Min int = NULL,
@QuoteId_Max int = NULL,
@DepartmentID_Values nvarchar(max) = NULL,
@DepartmentID_Min int = NULL,
@DepartmentID_Max int = NULL,
@UserId_Values nvarchar(max) = NULL,
@UserId_Min int = NULL,
@UserId_Max int = NULL,
@CreatedDateTime_Values nvarchar(max) = NULL,
@CreatedDateTime_Min datetime = NULL,
@CreatedDateTime_Max datetime = NULL,
@ActivityType nvarchar(50) = NULL,
@ActivityType_Values nvarchar(max) = NULL,
@FlagDescription nvarchar(255) = NULL,
@FlagDescription_Values nvarchar(max) = NULL,
@Note nvarchar(2000) = NULL,
@Note_Values nvarchar(max) = NULL,
@FollowUpDate_Values nvarchar(max) = NULL,
@FollowUpDate_Min datetime = NULL,
@FollowUpDate_Max datetime = NULL,
@FollowUpTime nvarchar(20) = NULL,
@FollowUpTime_Values nvarchar(max) = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
@QuoteBranchCode nvarchar(50) = NULL,
@QuoteBranchCode_Values nvarchar(max) = NULL,
@Branch nvarchar(50) = NULL,
@Branch_Values nvarchar(max) = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@DeliveryDate_Min datetime = NULL,
@DeliveryDate_Max datetime = NULL,
@Interest nvarchar(50) = NULL,
@Interest_Values nvarchar(max) = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@FollowUpDateFlag_Values nvarchar(max) = NULL,
@FollowUpDateFlag_Min int = NULL,
@FollowUpDateFlag_Max int = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1

AS
BEGIN
SET NOCOUNT ON;
SET @ResultCount = 0
IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
SET @ResultCount = (SELECT COUNT(1) FROM [dbo].[VW_FollowUpRemindersData] (NOLOCK)
 WHERE (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND [CustID] IS NULL ) OR (@CustID_Values <> '###NULL###' AND [CustID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR [CustID] >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR [CustID] <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@CustBranchCode IS NULL OR (@CustBranchCode = '###NULL###' AND CustBranchCode IS NULL ) OR (@CustBranchCode <> '###NULL###' AND [CustBranchCode] LIKE '%'+@CustBranchCode+'%'))
 AND (@CustBranchCode_Values IS NULL OR (@CustBranchCode_Values = '###NULL###' AND [CustBranchCode] IS NULL ) OR (@CustBranchCode_Values <> '###NULL###' AND [CustBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustBranchCode_Values,','))))
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@SalesActivityID_Values IS NULL OR  (@SalesActivityID_Values = '###NULL###' AND [SalesActivityID] IS NULL ) OR (@SalesActivityID_Values <> '###NULL###' AND [SalesActivityID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesActivityID_Values,','))))
 AND (@SalesActivityID_Min IS NULL OR [SalesActivityID] >=  @SalesActivityID_Min)
 AND (@SalesActivityID_Max IS NULL OR [SalesActivityID] <=  @SalesActivityID_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND [QuoteId] IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND [QuoteId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteId_Values,','))))
 AND (@QuoteId_Min IS NULL OR [QuoteId] >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR [QuoteId] <=  @QuoteId_Max)
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@UserId_Values IS NULL OR  (@UserId_Values = '###NULL###' AND [UserId] IS NULL ) OR (@UserId_Values <> '###NULL###' AND [UserId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@UserId_Values,','))))
 AND (@UserId_Min IS NULL OR [UserId] >=  @UserId_Min)
 AND (@UserId_Max IS NULL OR [UserId] <=  @UserId_Max)
 AND (@CreatedDateTime_Values IS NULL OR  (@CreatedDateTime_Values = '###NULL###' AND [CreatedDateTime] IS NULL ) OR (@CreatedDateTime_Values <> '###NULL###' AND [CreatedDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CreatedDateTime_Values,','))))
 AND (@CreatedDateTime_Min IS NULL OR [CreatedDateTime] >=  @CreatedDateTime_Min)
 AND (@CreatedDateTime_Max IS NULL OR [CreatedDateTime] <=  @CreatedDateTime_Max)
 AND (@ActivityType IS NULL OR (@ActivityType = '###NULL###' AND ActivityType IS NULL ) OR (@ActivityType <> '###NULL###' AND [ActivityType] LIKE '%'+@ActivityType+'%'))
 AND (@ActivityType_Values IS NULL OR (@ActivityType_Values = '###NULL###' AND [ActivityType] IS NULL ) OR (@ActivityType_Values <> '###NULL###' AND [ActivityType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ActivityType_Values,','))))
 AND (@FlagDescription IS NULL OR (@FlagDescription = '###NULL###' AND FlagDescription IS NULL ) OR (@FlagDescription <> '###NULL###' AND [FlagDescription] LIKE '%'+@FlagDescription+'%'))
 AND (@FlagDescription_Values IS NULL OR (@FlagDescription_Values = '###NULL###' AND [FlagDescription] IS NULL ) OR (@FlagDescription_Values <> '###NULL###' AND [FlagDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FlagDescription_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@FollowUpDate_Values IS NULL OR  (@FollowUpDate_Values = '###NULL###' AND [FollowUpDate] IS NULL ) OR (@FollowUpDate_Values <> '###NULL###' AND [FollowUpDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpDate_Values,','))))
 AND (@FollowUpDate_Min IS NULL OR [FollowUpDate] >=  @FollowUpDate_Min)
 AND (@FollowUpDate_Max IS NULL OR [FollowUpDate] <=  @FollowUpDate_Max)
 AND (@FollowUpTime IS NULL OR (@FollowUpTime = '###NULL###' AND FollowUpTime IS NULL ) OR (@FollowUpTime <> '###NULL###' AND [FollowUpTime] LIKE '%'+@FollowUpTime+'%'))
 AND (@FollowUpTime_Values IS NULL OR (@FollowUpTime_Values = '###NULL###' AND [FollowUpTime] IS NULL ) OR (@FollowUpTime_Values <> '###NULL###' AND [FollowUpTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpTime_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@Branch IS NULL OR (@Branch = '###NULL###' AND Branch IS NULL ) OR (@Branch <> '###NULL###' AND [Branch] LIKE '%'+@Branch+'%'))
 AND (@Branch_Values IS NULL OR (@Branch_Values = '###NULL###' AND [Branch] IS NULL ) OR (@Branch_Values <> '###NULL###' AND [Branch] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Branch_Values,','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@FollowUpDateFlag_Values IS NULL OR  (@FollowUpDateFlag_Values = '###NULL###' AND [FollowUpDateFlag] IS NULL ) OR (@FollowUpDateFlag_Values <> '###NULL###' AND [FollowUpDateFlag] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpDateFlag_Values,','))))
 AND (@FollowUpDateFlag_Min IS NULL OR [FollowUpDateFlag] >=  @FollowUpDateFlag_Min)
 AND (@FollowUpDateFlag_Max IS NULL OR [FollowUpDateFlag] <=  @FollowUpDateFlag_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT CustID,CustName,BranchID,CustBranchCode,BranchName,SalesActivityID,CustomerId,QuoteId,DepartmentID,UserId,CreatedDateTime,ActivityType,FlagDescription,Note,FollowUpDate,FollowUpTime,SalesRep,EmployeeID,QuoteBranchCode,Branch,DeliveryDate,Interest,Total,FollowUpDateFlag FROM  [dbo].[VW_FollowUpRemindersData] (NOLOCK)

 WHERE (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND [CustID] IS NULL ) OR (@CustID_Values <> '###NULL###' AND [CustID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR [CustID] >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR [CustID] <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@CustBranchCode IS NULL OR (@CustBranchCode = '###NULL###' AND CustBranchCode IS NULL ) OR (@CustBranchCode <> '###NULL###' AND [CustBranchCode] LIKE '%'+@CustBranchCode+'%'))
 AND (@CustBranchCode_Values IS NULL OR (@CustBranchCode_Values = '###NULL###' AND [CustBranchCode] IS NULL ) OR (@CustBranchCode_Values <> '###NULL###' AND [CustBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustBranchCode_Values,','))))
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@SalesActivityID_Values IS NULL OR  (@SalesActivityID_Values = '###NULL###' AND [SalesActivityID] IS NULL ) OR (@SalesActivityID_Values <> '###NULL###' AND [SalesActivityID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesActivityID_Values,','))))
 AND (@SalesActivityID_Min IS NULL OR [SalesActivityID] >=  @SalesActivityID_Min)
 AND (@SalesActivityID_Max IS NULL OR [SalesActivityID] <=  @SalesActivityID_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND [QuoteId] IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND [QuoteId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteId_Values,','))))
 AND (@QuoteId_Min IS NULL OR [QuoteId] >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR [QuoteId] <=  @QuoteId_Max)
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@UserId_Values IS NULL OR  (@UserId_Values = '###NULL###' AND [UserId] IS NULL ) OR (@UserId_Values <> '###NULL###' AND [UserId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@UserId_Values,','))))
 AND (@UserId_Min IS NULL OR [UserId] >=  @UserId_Min)
 AND (@UserId_Max IS NULL OR [UserId] <=  @UserId_Max)
 AND (@CreatedDateTime_Values IS NULL OR  (@CreatedDateTime_Values = '###NULL###' AND [CreatedDateTime] IS NULL ) OR (@CreatedDateTime_Values <> '###NULL###' AND [CreatedDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CreatedDateTime_Values,','))))
 AND (@CreatedDateTime_Min IS NULL OR [CreatedDateTime] >=  @CreatedDateTime_Min)
 AND (@CreatedDateTime_Max IS NULL OR [CreatedDateTime] <=  @CreatedDateTime_Max)
 AND (@ActivityType IS NULL OR (@ActivityType = '###NULL###' AND ActivityType IS NULL ) OR (@ActivityType <> '###NULL###' AND [ActivityType] LIKE '%'+@ActivityType+'%'))
 AND (@ActivityType_Values IS NULL OR (@ActivityType_Values = '###NULL###' AND [ActivityType] IS NULL ) OR (@ActivityType_Values <> '###NULL###' AND [ActivityType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ActivityType_Values,','))))
 AND (@FlagDescription IS NULL OR (@FlagDescription = '###NULL###' AND FlagDescription IS NULL ) OR (@FlagDescription <> '###NULL###' AND [FlagDescription] LIKE '%'+@FlagDescription+'%'))
 AND (@FlagDescription_Values IS NULL OR (@FlagDescription_Values = '###NULL###' AND [FlagDescription] IS NULL ) OR (@FlagDescription_Values <> '###NULL###' AND [FlagDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FlagDescription_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@FollowUpDate_Values IS NULL OR  (@FollowUpDate_Values = '###NULL###' AND [FollowUpDate] IS NULL ) OR (@FollowUpDate_Values <> '###NULL###' AND [FollowUpDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpDate_Values,','))))
 AND (@FollowUpDate_Min IS NULL OR [FollowUpDate] >=  @FollowUpDate_Min)
 AND (@FollowUpDate_Max IS NULL OR [FollowUpDate] <=  @FollowUpDate_Max)
 AND (@FollowUpTime IS NULL OR (@FollowUpTime = '###NULL###' AND FollowUpTime IS NULL ) OR (@FollowUpTime <> '###NULL###' AND [FollowUpTime] LIKE '%'+@FollowUpTime+'%'))
 AND (@FollowUpTime_Values IS NULL OR (@FollowUpTime_Values = '###NULL###' AND [FollowUpTime] IS NULL ) OR (@FollowUpTime_Values <> '###NULL###' AND [FollowUpTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpTime_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@Branch IS NULL OR (@Branch = '###NULL###' AND Branch IS NULL ) OR (@Branch <> '###NULL###' AND [Branch] LIKE '%'+@Branch+'%'))
 AND (@Branch_Values IS NULL OR (@Branch_Values = '###NULL###' AND [Branch] IS NULL ) OR (@Branch_Values <> '###NULL###' AND [Branch] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Branch_Values,','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@FollowUpDateFlag_Values IS NULL OR  (@FollowUpDateFlag_Values = '###NULL###' AND [FollowUpDateFlag] IS NULL ) OR (@FollowUpDateFlag_Values <> '###NULL###' AND [FollowUpDateFlag] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpDateFlag_Values,','))))
 AND (@FollowUpDateFlag_Min IS NULL OR [FollowUpDateFlag] >=  @FollowUpDateFlag_Min)
 AND (@FollowUpDateFlag_Max IS NULL OR [FollowUpDateFlag] <=  @FollowUpDateFlag_Max)
 
END
ELSE
BEGIN
SELECT CustID,CustName,BranchID,CustBranchCode,BranchName,SalesActivityID,CustomerId,QuoteId,DepartmentID,UserId,CreatedDateTime,ActivityType,FlagDescription,Note,FollowUpDate,FollowUpTime,SalesRep,EmployeeID,QuoteBranchCode,Branch,DeliveryDate,Interest,Total,FollowUpDateFlag FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[CustID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[CustID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[CustID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[CustName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[CustName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[CustName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[BranchID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[BranchID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[BranchID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustBranchCode' OR @Sort_Column='CustBranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[CustBranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustBranchCode' OR @Sort_Column='CustBranchCode') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[CustBranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustBranchCode' OR @Sort_Column='CustBranchCode') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[CustBranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[BranchName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[BranchName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[BranchName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.SalesActivityID' OR @Sort_Column='SalesActivityID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[SalesActivityID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.SalesActivityID' OR @Sort_Column='SalesActivityID') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[SalesActivityID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.SalesActivityID' OR @Sort_Column='SalesActivityID') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[SalesActivityID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[CustomerId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[CustomerId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[CustomerId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[QuoteId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[QuoteId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[QuoteId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[DepartmentID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[DepartmentID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[DepartmentID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.UserId' OR @Sort_Column='UserId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[UserId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.UserId' OR @Sort_Column='UserId') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[UserId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.UserId' OR @Sort_Column='UserId') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[UserId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CreatedDateTime' OR @Sort_Column='CreatedDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[CreatedDateTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CreatedDateTime' OR @Sort_Column='CreatedDateTime') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[CreatedDateTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.CreatedDateTime' OR @Sort_Column='CreatedDateTime') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[CreatedDateTime] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.ActivityType' OR @Sort_Column='ActivityType') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[ActivityType] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.ActivityType' OR @Sort_Column='ActivityType') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[ActivityType] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.ActivityType' OR @Sort_Column='ActivityType') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[ActivityType] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FlagDescription' OR @Sort_Column='FlagDescription') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[FlagDescription] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FlagDescription' OR @Sort_Column='FlagDescription') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[FlagDescription] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FlagDescription' OR @Sort_Column='FlagDescription') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[FlagDescription] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[Note] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[Note] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[Note] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpDate' OR @Sort_Column='FollowUpDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[FollowUpDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpDate' OR @Sort_Column='FollowUpDate') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[FollowUpDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpDate' OR @Sort_Column='FollowUpDate') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[FollowUpDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpTime' OR @Sort_Column='FollowUpTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[FollowUpTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpTime' OR @Sort_Column='FollowUpTime') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[FollowUpTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpTime' OR @Sort_Column='FollowUpTime') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[FollowUpTime] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[SalesRep] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[SalesRep] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[SalesRep] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[EmployeeID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[EmployeeID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[EmployeeID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[QuoteBranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[QuoteBranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[QuoteBranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Branch' OR @Sort_Column='Branch') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[Branch] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Branch' OR @Sort_Column='Branch') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[Branch] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Branch' OR @Sort_Column='Branch') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[Branch] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[DeliveryDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[DeliveryDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[DeliveryDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[Interest] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[Interest] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[Interest] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[Total] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[Total] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[Total] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpDateFlag' OR @Sort_Column='FollowUpDateFlag') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FollowUpRemindersData].[FollowUpDateFlag] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpDateFlag' OR @Sort_Column='FollowUpDateFlag') AND @Sort_Ascending=1 THEN [VW_FollowUpRemindersData].[FollowUpDateFlag] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FollowUpRemindersData.FollowUpDateFlag' OR @Sort_Column='FollowUpDateFlag') AND @Sort_Ascending=0 THEN [VW_FollowUpRemindersData].[FollowUpDateFlag] ELSE NULL END DESC
 ) AS RowNum, [VW_FollowUpRemindersData].*
 FROM  [dbo].[VW_FollowUpRemindersData] (NOLOCK)

 WHERE (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND [CustID] IS NULL ) OR (@CustID_Values <> '###NULL###' AND [CustID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR [CustID] >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR [CustID] <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@CustBranchCode IS NULL OR (@CustBranchCode = '###NULL###' AND CustBranchCode IS NULL ) OR (@CustBranchCode <> '###NULL###' AND [CustBranchCode] LIKE '%'+@CustBranchCode+'%'))
 AND (@CustBranchCode_Values IS NULL OR (@CustBranchCode_Values = '###NULL###' AND [CustBranchCode] IS NULL ) OR (@CustBranchCode_Values <> '###NULL###' AND [CustBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustBranchCode_Values,','))))
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@SalesActivityID_Values IS NULL OR  (@SalesActivityID_Values = '###NULL###' AND [SalesActivityID] IS NULL ) OR (@SalesActivityID_Values <> '###NULL###' AND [SalesActivityID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesActivityID_Values,','))))
 AND (@SalesActivityID_Min IS NULL OR [SalesActivityID] >=  @SalesActivityID_Min)
 AND (@SalesActivityID_Max IS NULL OR [SalesActivityID] <=  @SalesActivityID_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND [QuoteId] IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND [QuoteId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteId_Values,','))))
 AND (@QuoteId_Min IS NULL OR [QuoteId] >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR [QuoteId] <=  @QuoteId_Max)
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@UserId_Values IS NULL OR  (@UserId_Values = '###NULL###' AND [UserId] IS NULL ) OR (@UserId_Values <> '###NULL###' AND [UserId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@UserId_Values,','))))
 AND (@UserId_Min IS NULL OR [UserId] >=  @UserId_Min)
 AND (@UserId_Max IS NULL OR [UserId] <=  @UserId_Max)
 AND (@CreatedDateTime_Values IS NULL OR  (@CreatedDateTime_Values = '###NULL###' AND [CreatedDateTime] IS NULL ) OR (@CreatedDateTime_Values <> '###NULL###' AND [CreatedDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CreatedDateTime_Values,','))))
 AND (@CreatedDateTime_Min IS NULL OR [CreatedDateTime] >=  @CreatedDateTime_Min)
 AND (@CreatedDateTime_Max IS NULL OR [CreatedDateTime] <=  @CreatedDateTime_Max)
 AND (@ActivityType IS NULL OR (@ActivityType = '###NULL###' AND ActivityType IS NULL ) OR (@ActivityType <> '###NULL###' AND [ActivityType] LIKE '%'+@ActivityType+'%'))
 AND (@ActivityType_Values IS NULL OR (@ActivityType_Values = '###NULL###' AND [ActivityType] IS NULL ) OR (@ActivityType_Values <> '###NULL###' AND [ActivityType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@ActivityType_Values,','))))
 AND (@FlagDescription IS NULL OR (@FlagDescription = '###NULL###' AND FlagDescription IS NULL ) OR (@FlagDescription <> '###NULL###' AND [FlagDescription] LIKE '%'+@FlagDescription+'%'))
 AND (@FlagDescription_Values IS NULL OR (@FlagDescription_Values = '###NULL###' AND [FlagDescription] IS NULL ) OR (@FlagDescription_Values <> '###NULL###' AND [FlagDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FlagDescription_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@FollowUpDate_Values IS NULL OR  (@FollowUpDate_Values = '###NULL###' AND [FollowUpDate] IS NULL ) OR (@FollowUpDate_Values <> '###NULL###' AND [FollowUpDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpDate_Values,','))))
 AND (@FollowUpDate_Min IS NULL OR [FollowUpDate] >=  @FollowUpDate_Min)
 AND (@FollowUpDate_Max IS NULL OR [FollowUpDate] <=  @FollowUpDate_Max)
 AND (@FollowUpTime IS NULL OR (@FollowUpTime = '###NULL###' AND FollowUpTime IS NULL ) OR (@FollowUpTime <> '###NULL###' AND [FollowUpTime] LIKE '%'+@FollowUpTime+'%'))
 AND (@FollowUpTime_Values IS NULL OR (@FollowUpTime_Values = '###NULL###' AND [FollowUpTime] IS NULL ) OR (@FollowUpTime_Values <> '###NULL###' AND [FollowUpTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpTime_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@Branch IS NULL OR (@Branch = '###NULL###' AND Branch IS NULL ) OR (@Branch <> '###NULL###' AND [Branch] LIKE '%'+@Branch+'%'))
 AND (@Branch_Values IS NULL OR (@Branch_Values = '###NULL###' AND [Branch] IS NULL ) OR (@Branch_Values <> '###NULL###' AND [Branch] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Branch_Values,','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@FollowUpDateFlag_Values IS NULL OR  (@FollowUpDateFlag_Values = '###NULL###' AND [FollowUpDateFlag] IS NULL ) OR (@FollowUpDateFlag_Values <> '###NULL###' AND [FollowUpDateFlag] IN(SELECT [Item] FROM [dbo].CustomeSplit(@FollowUpDateFlag_Values,','))))
 AND (@FollowUpDateFlag_Min IS NULL OR [FollowUpDateFlag] >=  @FollowUpDateFlag_Min)
 AND (@FollowUpDateFlag_Max IS NULL OR [FollowUpDateFlag] <=  @FollowUpDateFlag_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_FutureBusinessFollowUpData_View_Search]    Script Date: 29-07-2020 09:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_FutureBusinessFollowUpData_View_Search]

@ResultCount INT OUTPUT,
@QuoteID_Values nvarchar(max) = NULL,
@QuoteID_Min int = NULL,
@QuoteID_Max int = NULL,
@EmployeeName nvarchar(50) = NULL,
@EmployeeName_Values nvarchar(max) = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@BranchName nvarchar(50) = NULL,
@BranchName_Values nvarchar(max) = NULL,
@BranchCode nvarchar(50) = NULL,
@BranchCode_Values nvarchar(max) = NULL,
@Note nvarchar(1024) = NULL,
@Note_Values nvarchar(max) = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@DeliveryDate_Min datetime = NULL,
@DeliveryDate_Max datetime = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@CustomerId_Values nvarchar(max) = NULL,
@CustomerId_Min int = NULL,
@CustomerId_Max int = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
@Interest nvarchar(50) = NULL,
@Interest_Values nvarchar(max) = NULL,
@LastActivityDateTime_Values nvarchar(max) = NULL,
@LastActivityDateTime_Min datetime = NULL,
@LastActivityDateTime_Max datetime = NULL,
@LastActivityNote nvarchar(150) = NULL,
@LastActivityNote_Values nvarchar(max) = NULL,
@DepartmentDescription nvarchar(50) = NULL,
@DepartmentDescription_Values nvarchar(max) = NULL,
@DepartmentID_Values nvarchar(max) = NULL,
@DepartmentID_Min int = NULL,
@DepartmentID_Max int = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1

AS
BEGIN
SET NOCOUNT ON;
SET @ResultCount = 0
IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
SET @ResultCount = (SELECT COUNT(1) FROM [dbo].[VW_FutureBusinessFollowUpData] (NOLOCK)
 WHERE (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@EmployeeName IS NULL OR (@EmployeeName = '###NULL###' AND EmployeeName IS NULL ) OR (@EmployeeName <> '###NULL###' AND [EmployeeName] LIKE '%'+@EmployeeName+'%'))
 AND (@EmployeeName_Values IS NULL OR (@EmployeeName_Values = '###NULL###' AND [EmployeeName] IS NULL ) OR (@EmployeeName_Values <> '###NULL###' AND [EmployeeName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeName_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND [BranchCode] LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND [BranchCode] IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND [BranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT QuoteID,EmployeeName,CustName,BranchID,BranchName,BranchCode,Note,DeliveryDate,Total,CustomerId,EmployeeID,Interest,LastActivityDateTime,LastActivityNote,DepartmentDescription,DepartmentID FROM  [dbo].[VW_FutureBusinessFollowUpData] (NOLOCK)

 WHERE (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@EmployeeName IS NULL OR (@EmployeeName = '###NULL###' AND EmployeeName IS NULL ) OR (@EmployeeName <> '###NULL###' AND [EmployeeName] LIKE '%'+@EmployeeName+'%'))
 AND (@EmployeeName_Values IS NULL OR (@EmployeeName_Values = '###NULL###' AND [EmployeeName] IS NULL ) OR (@EmployeeName_Values <> '###NULL###' AND [EmployeeName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeName_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND [BranchCode] LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND [BranchCode] IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND [BranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 
END
ELSE
BEGIN
SELECT QuoteID,EmployeeName,CustName,BranchID,BranchName,BranchCode,Note,DeliveryDate,Total,CustomerId,EmployeeID,Interest,LastActivityDateTime,LastActivityNote,DepartmentDescription,DepartmentID FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[QuoteID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[QuoteID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[QuoteID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.EmployeeName' OR @Sort_Column='EmployeeName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[EmployeeName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.EmployeeName' OR @Sort_Column='EmployeeName') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[EmployeeName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.EmployeeName' OR @Sort_Column='EmployeeName') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[EmployeeName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[CustName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[CustName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[CustName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[BranchID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[BranchID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[BranchID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[BranchName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[BranchName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[BranchName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[BranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[BranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[BranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[Note] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[Note] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[Note] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[DeliveryDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[DeliveryDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[DeliveryDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[Total] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[Total] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[Total] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[CustomerId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[CustomerId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[CustomerId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[EmployeeID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[EmployeeID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[EmployeeID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[Interest] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[Interest] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[Interest] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[LastActivityDateTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[LastActivityDateTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[LastActivityDateTime] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[LastActivityNote] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[LastActivityNote] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[LastActivityNote] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[DepartmentDescription] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[DepartmentDescription] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[DepartmentDescription] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_FutureBusinessFollowUpData].[DepartmentID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN [VW_FutureBusinessFollowUpData].[DepartmentID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_FutureBusinessFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=0 THEN [VW_FutureBusinessFollowUpData].[DepartmentID] ELSE NULL END DESC
 ) AS RowNum, [VW_FutureBusinessFollowUpData].*
 FROM  [dbo].[VW_FutureBusinessFollowUpData] (NOLOCK)

 WHERE (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@EmployeeName IS NULL OR (@EmployeeName = '###NULL###' AND EmployeeName IS NULL ) OR (@EmployeeName <> '###NULL###' AND [EmployeeName] LIKE '%'+@EmployeeName+'%'))
 AND (@EmployeeName_Values IS NULL OR (@EmployeeName_Values = '###NULL###' AND [EmployeeName] IS NULL ) OR (@EmployeeName_Values <> '###NULL###' AND [EmployeeName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeName_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND [BranchCode] LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND [BranchCode] IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND [BranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_InActiveAccountFolloUpData_View_Search]    Script Date: 29-07-2020 09:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_InActiveAccountFolloUpData_View_Search]

@ResultCount INT OUTPUT,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@Active nvarchar(3) = NULL,
@Active_Values nvarchar(max) = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@OrderFrequency nvarchar(50) = NULL,
@OrderFrequency_Values nvarchar(max) = NULL,
@DoNotContact bit = NULL,
@DoNotContactDate_Values nvarchar(max) = NULL,
@DoNotContactDate_Min datetime = NULL,
@DoNotContactDate_Max datetime = NULL,
@DoNotContactBy nvarchar(100) = NULL,
@DoNotContactBy_Values nvarchar(max) = NULL,
@CustomerId_Values nvarchar(max) = NULL,
@CustomerId_Min int = NULL,
@CustomerId_Max int = NULL,
@EnterDate_Values nvarchar(max) = NULL,
@EnterDate_Min datetime = NULL,
@EnterDate_Max datetime = NULL,
@QuoteId_Values nvarchar(max) = NULL,
@QuoteId_Min int = NULL,
@QuoteId_Max int = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@DeliveryDate_Min datetime = NULL,
@DeliveryDate_Max datetime = NULL,
@Interest nvarchar(50) = NULL,
@Interest_Values nvarchar(max) = NULL,
@CustBranchCode nvarchar(50) = NULL,
@CustBranchCode_Values nvarchar(max) = NULL,
@QuoteBranchCode_Values nvarchar(max) = NULL,
@QuoteBranchCode_Min int = NULL,
@QuoteBranchCode_Max int = NULL,
@Note_Values nvarchar(max) = NULL,
@Note_Min int = NULL,
@Note_Max int = NULL,
@MaxDateTime_Values nvarchar(max) = NULL,
@MaxDateTime_Min datetime = NULL,
@MaxDateTime_Max datetime = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1

AS
BEGIN
SET NOCOUNT ON;
SET @ResultCount = 0
IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
SET @ResultCount = (SELECT COUNT(1) FROM [dbo].[VW_InActiveAccountFolloUpData] (NOLOCK)
 WHERE (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@Active IS NULL OR (@Active = '###NULL###' AND Active IS NULL ) OR (@Active <> '###NULL###' AND [Active] LIKE '%'+@Active+'%'))
 AND (@Active_Values IS NULL OR (@Active_Values = '###NULL###' AND [Active] IS NULL ) OR (@Active_Values <> '###NULL###' AND [Active] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Active_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND [OrderFrequency] LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND [OrderFrequency] IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND [OrderFrequency] IN(SELECT [Item] FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@DoNotContact IS NULL OR [DoNotContact] =  @DoNotContact)
 AND (@DoNotContactDate_Values IS NULL OR  (@DoNotContactDate_Values = '###NULL###' AND [DoNotContactDate] IS NULL ) OR (@DoNotContactDate_Values <> '###NULL###' AND [DoNotContactDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactDate_Values,','))))
 AND (@DoNotContactDate_Min IS NULL OR [DoNotContactDate] >=  @DoNotContactDate_Min)
 AND (@DoNotContactDate_Max IS NULL OR [DoNotContactDate] <=  @DoNotContactDate_Max)
 AND (@DoNotContactBy IS NULL OR (@DoNotContactBy = '###NULL###' AND DoNotContactBy IS NULL ) OR (@DoNotContactBy <> '###NULL###' AND [DoNotContactBy] LIKE '%'+@DoNotContactBy+'%'))
 AND (@DoNotContactBy_Values IS NULL OR (@DoNotContactBy_Values = '###NULL###' AND [DoNotContactBy] IS NULL ) OR (@DoNotContactBy_Values <> '###NULL###' AND [DoNotContactBy] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactBy_Values,','))))
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EnterDate_Values IS NULL OR  (@EnterDate_Values = '###NULL###' AND [EnterDate] IS NULL ) OR (@EnterDate_Values <> '###NULL###' AND [EnterDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EnterDate_Values,','))))
 AND (@EnterDate_Min IS NULL OR [EnterDate] >=  @EnterDate_Min)
 AND (@EnterDate_Max IS NULL OR [EnterDate] <=  @EnterDate_Max)
 AND (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND [QuoteId] IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND [QuoteId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteId_Values,','))))
 AND (@QuoteId_Min IS NULL OR [QuoteId] >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR [QuoteId] <=  @QuoteId_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@CustBranchCode IS NULL OR (@CustBranchCode = '###NULL###' AND CustBranchCode IS NULL ) OR (@CustBranchCode <> '###NULL###' AND [CustBranchCode] LIKE '%'+@CustBranchCode+'%'))
 AND (@CustBranchCode_Values IS NULL OR (@CustBranchCode_Values = '###NULL###' AND [CustBranchCode] IS NULL ) OR (@CustBranchCode_Values <> '###NULL###' AND [CustBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustBranchCode_Values,','))))
 AND (@QuoteBranchCode_Values IS NULL OR  (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@QuoteBranchCode_Min IS NULL OR [QuoteBranchCode] >=  @QuoteBranchCode_Min)
 AND (@QuoteBranchCode_Max IS NULL OR [QuoteBranchCode] <=  @QuoteBranchCode_Max)
 AND (@Note_Values IS NULL OR  (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@Note_Min IS NULL OR [Note] >=  @Note_Min)
 AND (@Note_Max IS NULL OR [Note] <=  @Note_Max)
 AND (@MaxDateTime_Values IS NULL OR  (@MaxDateTime_Values = '###NULL###' AND [MaxDateTime] IS NULL ) OR (@MaxDateTime_Values <> '###NULL###' AND [MaxDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@MaxDateTime_Values,','))))
 AND (@MaxDateTime_Min IS NULL OR [MaxDateTime] >=  @MaxDateTime_Min)
 AND (@MaxDateTime_Max IS NULL OR [MaxDateTime] <=  @MaxDateTime_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT BranchID,Active,CustName,SalesRep,OrderFrequency,DoNotContact,DoNotContactDate,DoNotContactBy,CustomerId,EnterDate,QuoteId,DeliveryDate,Interest,CustBranchCode,QuoteBranchCode,Note,MaxDateTime,Total FROM  [dbo].[VW_InActiveAccountFolloUpData] (NOLOCK)

 WHERE (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@Active IS NULL OR (@Active = '###NULL###' AND Active IS NULL ) OR (@Active <> '###NULL###' AND [Active] LIKE '%'+@Active+'%'))
 AND (@Active_Values IS NULL OR (@Active_Values = '###NULL###' AND [Active] IS NULL ) OR (@Active_Values <> '###NULL###' AND [Active] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Active_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND [OrderFrequency] LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND [OrderFrequency] IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND [OrderFrequency] IN(SELECT [Item] FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@DoNotContact IS NULL OR [DoNotContact] =  @DoNotContact)
 AND (@DoNotContactDate_Values IS NULL OR  (@DoNotContactDate_Values = '###NULL###' AND [DoNotContactDate] IS NULL ) OR (@DoNotContactDate_Values <> '###NULL###' AND [DoNotContactDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactDate_Values,','))))
 AND (@DoNotContactDate_Min IS NULL OR [DoNotContactDate] >=  @DoNotContactDate_Min)
 AND (@DoNotContactDate_Max IS NULL OR [DoNotContactDate] <=  @DoNotContactDate_Max)
 AND (@DoNotContactBy IS NULL OR (@DoNotContactBy = '###NULL###' AND DoNotContactBy IS NULL ) OR (@DoNotContactBy <> '###NULL###' AND [DoNotContactBy] LIKE '%'+@DoNotContactBy+'%'))
 AND (@DoNotContactBy_Values IS NULL OR (@DoNotContactBy_Values = '###NULL###' AND [DoNotContactBy] IS NULL ) OR (@DoNotContactBy_Values <> '###NULL###' AND [DoNotContactBy] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactBy_Values,','))))
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EnterDate_Values IS NULL OR  (@EnterDate_Values = '###NULL###' AND [EnterDate] IS NULL ) OR (@EnterDate_Values <> '###NULL###' AND [EnterDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EnterDate_Values,','))))
 AND (@EnterDate_Min IS NULL OR [EnterDate] >=  @EnterDate_Min)
 AND (@EnterDate_Max IS NULL OR [EnterDate] <=  @EnterDate_Max)
 AND (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND [QuoteId] IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND [QuoteId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteId_Values,','))))
 AND (@QuoteId_Min IS NULL OR [QuoteId] >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR [QuoteId] <=  @QuoteId_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@CustBranchCode IS NULL OR (@CustBranchCode = '###NULL###' AND CustBranchCode IS NULL ) OR (@CustBranchCode <> '###NULL###' AND [CustBranchCode] LIKE '%'+@CustBranchCode+'%'))
 AND (@CustBranchCode_Values IS NULL OR (@CustBranchCode_Values = '###NULL###' AND [CustBranchCode] IS NULL ) OR (@CustBranchCode_Values <> '###NULL###' AND [CustBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustBranchCode_Values,','))))
 AND (@QuoteBranchCode_Values IS NULL OR  (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@QuoteBranchCode_Min IS NULL OR [QuoteBranchCode] >=  @QuoteBranchCode_Min)
 AND (@QuoteBranchCode_Max IS NULL OR [QuoteBranchCode] <=  @QuoteBranchCode_Max)
 AND (@Note_Values IS NULL OR  (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@Note_Min IS NULL OR [Note] >=  @Note_Min)
 AND (@Note_Max IS NULL OR [Note] <=  @Note_Max)
 AND (@MaxDateTime_Values IS NULL OR  (@MaxDateTime_Values = '###NULL###' AND [MaxDateTime] IS NULL ) OR (@MaxDateTime_Values <> '###NULL###' AND [MaxDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@MaxDateTime_Values,','))))
 AND (@MaxDateTime_Min IS NULL OR [MaxDateTime] >=  @MaxDateTime_Min)
 AND (@MaxDateTime_Max IS NULL OR [MaxDateTime] <=  @MaxDateTime_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 
END
ELSE
BEGIN
SELECT BranchID,Active,CustName,SalesRep,OrderFrequency,DoNotContact,DoNotContactDate,DoNotContactBy,CustomerId,EnterDate,QuoteId,DeliveryDate,Interest,CustBranchCode,QuoteBranchCode,Note,MaxDateTime,Total FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[BranchID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[BranchID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[BranchID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Active' OR @Sort_Column='Active') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[Active] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Active' OR @Sort_Column='Active') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[Active] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Active' OR @Sort_Column='Active') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[Active] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[CustName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[CustName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[CustName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[SalesRep] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[SalesRep] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[SalesRep] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[OrderFrequency] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[OrderFrequency] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[OrderFrequency] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContact' OR @Sort_Column='DoNotContact') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[DoNotContact] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContact' OR @Sort_Column='DoNotContact') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[DoNotContact] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContact' OR @Sort_Column='DoNotContact') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[DoNotContact] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContactDate' OR @Sort_Column='DoNotContactDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[DoNotContactDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContactDate' OR @Sort_Column='DoNotContactDate') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[DoNotContactDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContactDate' OR @Sort_Column='DoNotContactDate') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[DoNotContactDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContactBy' OR @Sort_Column='DoNotContactBy') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[DoNotContactBy] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContactBy' OR @Sort_Column='DoNotContactBy') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[DoNotContactBy] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DoNotContactBy' OR @Sort_Column='DoNotContactBy') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[DoNotContactBy] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[CustomerId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[CustomerId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[CustomerId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.EnterDate' OR @Sort_Column='EnterDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[EnterDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.EnterDate' OR @Sort_Column='EnterDate') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[EnterDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.EnterDate' OR @Sort_Column='EnterDate') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[EnterDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[QuoteId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[QuoteId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[QuoteId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[DeliveryDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[DeliveryDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[DeliveryDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[Interest] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[Interest] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[Interest] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustBranchCode' OR @Sort_Column='CustBranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[CustBranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustBranchCode' OR @Sort_Column='CustBranchCode') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[CustBranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.CustBranchCode' OR @Sort_Column='CustBranchCode') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[CustBranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[QuoteBranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[QuoteBranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[QuoteBranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[Note] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[Note] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[Note] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.MaxDateTime' OR @Sort_Column='MaxDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[MaxDateTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.MaxDateTime' OR @Sort_Column='MaxDateTime') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[MaxDateTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.MaxDateTime' OR @Sort_Column='MaxDateTime') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[MaxDateTime] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_InActiveAccountFolloUpData].[Total] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN [VW_InActiveAccountFolloUpData].[Total] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_InActiveAccountFolloUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN [VW_InActiveAccountFolloUpData].[Total] ELSE NULL END DESC
 ) AS RowNum, [VW_InActiveAccountFolloUpData].*
 FROM  [dbo].[VW_InActiveAccountFolloUpData] (NOLOCK)

 WHERE (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@Active IS NULL OR (@Active = '###NULL###' AND Active IS NULL ) OR (@Active <> '###NULL###' AND [Active] LIKE '%'+@Active+'%'))
 AND (@Active_Values IS NULL OR (@Active_Values = '###NULL###' AND [Active] IS NULL ) OR (@Active_Values <> '###NULL###' AND [Active] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Active_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND [OrderFrequency] LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND [OrderFrequency] IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND [OrderFrequency] IN(SELECT [Item] FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@DoNotContact IS NULL OR [DoNotContact] =  @DoNotContact)
 AND (@DoNotContactDate_Values IS NULL OR  (@DoNotContactDate_Values = '###NULL###' AND [DoNotContactDate] IS NULL ) OR (@DoNotContactDate_Values <> '###NULL###' AND [DoNotContactDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactDate_Values,','))))
 AND (@DoNotContactDate_Min IS NULL OR [DoNotContactDate] >=  @DoNotContactDate_Min)
 AND (@DoNotContactDate_Max IS NULL OR [DoNotContactDate] <=  @DoNotContactDate_Max)
 AND (@DoNotContactBy IS NULL OR (@DoNotContactBy = '###NULL###' AND DoNotContactBy IS NULL ) OR (@DoNotContactBy <> '###NULL###' AND [DoNotContactBy] LIKE '%'+@DoNotContactBy+'%'))
 AND (@DoNotContactBy_Values IS NULL OR (@DoNotContactBy_Values = '###NULL###' AND [DoNotContactBy] IS NULL ) OR (@DoNotContactBy_Values <> '###NULL###' AND [DoNotContactBy] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactBy_Values,','))))
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EnterDate_Values IS NULL OR  (@EnterDate_Values = '###NULL###' AND [EnterDate] IS NULL ) OR (@EnterDate_Values <> '###NULL###' AND [EnterDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EnterDate_Values,','))))
 AND (@EnterDate_Min IS NULL OR [EnterDate] >=  @EnterDate_Min)
 AND (@EnterDate_Max IS NULL OR [EnterDate] <=  @EnterDate_Max)
 AND (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND [QuoteId] IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND [QuoteId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteId_Values,','))))
 AND (@QuoteId_Min IS NULL OR [QuoteId] >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR [QuoteId] <=  @QuoteId_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@CustBranchCode IS NULL OR (@CustBranchCode = '###NULL###' AND CustBranchCode IS NULL ) OR (@CustBranchCode <> '###NULL###' AND [CustBranchCode] LIKE '%'+@CustBranchCode+'%'))
 AND (@CustBranchCode_Values IS NULL OR (@CustBranchCode_Values = '###NULL###' AND [CustBranchCode] IS NULL ) OR (@CustBranchCode_Values <> '###NULL###' AND [CustBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustBranchCode_Values,','))))
 AND (@QuoteBranchCode_Values IS NULL OR  (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@QuoteBranchCode_Min IS NULL OR [QuoteBranchCode] >=  @QuoteBranchCode_Min)
 AND (@QuoteBranchCode_Max IS NULL OR [QuoteBranchCode] <=  @QuoteBranchCode_Max)
 AND (@Note_Values IS NULL OR  (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@Note_Min IS NULL OR [Note] >=  @Note_Min)
 AND (@Note_Max IS NULL OR [Note] <=  @Note_Max)
 AND (@MaxDateTime_Values IS NULL OR  (@MaxDateTime_Values = '###NULL###' AND [MaxDateTime] IS NULL ) OR (@MaxDateTime_Values <> '###NULL###' AND [MaxDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@MaxDateTime_Values,','))))
 AND (@MaxDateTime_Min IS NULL OR [MaxDateTime] >=  @MaxDateTime_Min)
 AND (@MaxDateTime_Max IS NULL OR [MaxDateTime] <=  @MaxDateTime_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_POReturnData_View_Search]    Script Date: 29-07-2020 09:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_POReturnData_View_Search]

@ResultCount INT OUTPUT,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@BranchName nvarchar(50) = NULL,
@BranchName_Values nvarchar(max) = NULL,
@BranchCode nvarchar(50) = NULL,
@BranchCode_Values nvarchar(max) = NULL,
@CustID_Values nvarchar(max) = NULL,
@CustID_Min int = NULL,
@CustID_Max int = NULL,
@Vendor nvarchar(255) = NULL,
@Vendor_Values nvarchar(max) = NULL,
@PurchaseID_Values nvarchar(max) = NULL,
@PurchaseID_Min int = NULL,
@PurchaseID_Max int = NULL,
@DeliveryDate nvarchar(81) = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@ReturnDate nvarchar(81) = NULL,
@ReturnDate_Values nvarchar(max) = NULL,
@IssuedBy nvarchar(50) = NULL,
@IssuedBy_Values nvarchar(max) = NULL,
@ReturnBy nvarchar(50) = NULL,
@ReturnBy_Values nvarchar(max) = NULL,
@Client nvarchar(268) = NULL,
@Client_Values nvarchar(max) = NULL,
@ShippingID nvarchar(50) = NULL,
@ShippingID_Values nvarchar(max) = NULL,
@ShipAddr nvarchar(50) = NULL,
@ShipAddr_Values nvarchar(max) = NULL,
@ShipCity nvarchar(50) = NULL,
@ShipCity_Values nvarchar(max) = NULL,
@ShowName nvarchar(150) = NULL,
@ShowName_Values nvarchar(max) = NULL,
@PurShipContact nvarchar(50) = NULL,
@PurShipContact_Values nvarchar(max) = NULL,
@PurShipAdd2 nvarchar(50) = NULL,
@PurShipAdd2_Values nvarchar(max) = NULL,
@State nvarchar(20) = NULL,
@State_Values nvarchar(max) = NULL,
@POStatus nvarchar(39) = NULL,
@POStatus_Values nvarchar(max) = NULL,
@PurApprovedBy_Values nvarchar(max) = NULL,
@PurApprovedBy_Min int = NULL,
@PurApprovedBy_Max int = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@QuoteCustName nvarchar(255) = NULL,
@QuoteCustName_Values nvarchar(max) = NULL,
@StateTooltip nvarchar(304) = NULL,
@StateTooltip_Values nvarchar(max) = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1

AS
BEGIN
SET NOCOUNT ON;
SET @ResultCount = 0
IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
SET @ResultCount = (SELECT COUNT(*) FROM VW_POReturnData (NOLOCK)
 WHERE (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND BranchName LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND BranchName IS NULL ) OR (@BranchName_Values <> '###NULL###' AND BranchName IN(SELECT Item FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@Vendor IS NULL OR (@Vendor = '###NULL###' AND Vendor IS NULL ) OR (@Vendor <> '###NULL###' AND Vendor LIKE '%'+@Vendor+'%'))
 AND (@Vendor_Values IS NULL OR (@Vendor_Values = '###NULL###' AND Vendor IS NULL ) OR (@Vendor_Values <> '###NULL###' AND Vendor IN(SELECT Item FROM [dbo].CustomeSplit(@Vendor_Values,','))))
 AND (@PurchaseID_Values IS NULL OR  (@PurchaseID_Values = '###NULL###' AND PurchaseID IS NULL ) OR (@PurchaseID_Values <> '###NULL###' AND PurchaseID IN(SELECT Item FROM [dbo].CustomeSplit(@PurchaseID_Values,','))))
 AND (@PurchaseID_Min IS NULL OR PurchaseID >=  @PurchaseID_Min)
 AND (@PurchaseID_Max IS NULL OR PurchaseID <=  @PurchaseID_Max)
 AND (@DeliveryDate IS NULL OR (@DeliveryDate = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate <> '###NULL###' AND DeliveryDate LIKE '%'+@DeliveryDate+'%'))
 AND (@DeliveryDate_Values IS NULL OR (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@ReturnDate IS NULL OR (@ReturnDate = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate <> '###NULL###' AND ReturnDate LIKE '%'+@ReturnDate+'%'))
 AND (@ReturnDate_Values IS NULL OR (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@IssuedBy IS NULL OR (@IssuedBy = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy <> '###NULL###' AND IssuedBy LIKE '%'+@IssuedBy+'%'))
 AND (@IssuedBy_Values IS NULL OR (@IssuedBy_Values = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy_Values <> '###NULL###' AND IssuedBy IN(SELECT Item FROM [dbo].CustomeSplit(@IssuedBy_Values,','))))
 AND (@ReturnBy IS NULL OR (@ReturnBy = '###NULL###' AND ReturnBy IS NULL ) OR (@ReturnBy <> '###NULL###' AND ReturnBy LIKE '%'+@ReturnBy+'%'))
 AND (@ReturnBy_Values IS NULL OR (@ReturnBy_Values = '###NULL###' AND ReturnBy IS NULL ) OR (@ReturnBy_Values <> '###NULL###' AND ReturnBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnBy_Values,','))))
 AND (@Client IS NULL OR (@Client = '###NULL###' AND Client IS NULL ) OR (@Client <> '###NULL###' AND Client LIKE '%'+@Client+'%'))
 AND (@Client_Values IS NULL OR (@Client_Values = '###NULL###' AND Client IS NULL ) OR (@Client_Values <> '###NULL###' AND Client IN(SELECT Item FROM [dbo].CustomeSplit(@Client_Values,','))))
 AND (@ShippingID IS NULL OR (@ShippingID = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID <> '###NULL###' AND ShippingID LIKE '%'+@ShippingID+'%'))
 AND (@ShippingID_Values IS NULL OR (@ShippingID_Values = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID_Values <> '###NULL###' AND ShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@ShippingID_Values,','))))
 AND (@ShipAddr IS NULL OR (@ShipAddr = '###NULL###' AND ShipAddr IS NULL ) OR (@ShipAddr <> '###NULL###' AND ShipAddr LIKE '%'+@ShipAddr+'%'))
 AND (@ShipAddr_Values IS NULL OR (@ShipAddr_Values = '###NULL###' AND ShipAddr IS NULL ) OR (@ShipAddr_Values <> '###NULL###' AND ShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@ShipAddr_Values,','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCity_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@PurShipContact IS NULL OR (@PurShipContact = '###NULL###' AND PurShipContact IS NULL ) OR (@PurShipContact <> '###NULL###' AND PurShipContact LIKE '%'+@PurShipContact+'%'))
 AND (@PurShipContact_Values IS NULL OR (@PurShipContact_Values = '###NULL###' AND PurShipContact IS NULL ) OR (@PurShipContact_Values <> '###NULL###' AND PurShipContact IN(SELECT Item FROM [dbo].CustomeSplit(@PurShipContact_Values,','))))
 AND (@PurShipAdd2 IS NULL OR (@PurShipAdd2 = '###NULL###' AND PurShipAdd2 IS NULL ) OR (@PurShipAdd2 <> '###NULL###' AND PurShipAdd2 LIKE '%'+@PurShipAdd2+'%'))
 AND (@PurShipAdd2_Values IS NULL OR (@PurShipAdd2_Values = '###NULL###' AND PurShipAdd2 IS NULL ) OR (@PurShipAdd2_Values <> '###NULL###' AND PurShipAdd2 IN(SELECT Item FROM [dbo].CustomeSplit(@PurShipAdd2_Values,','))))
 AND (@State IS NULL OR (@State = '###NULL###' AND State IS NULL ) OR (@State <> '###NULL###' AND State LIKE '%'+@State+'%'))
 AND (@State_Values IS NULL OR (@State_Values = '###NULL###' AND State IS NULL ) OR (@State_Values <> '###NULL###' AND State IN(SELECT Item FROM [dbo].CustomeSplit(@State_Values,','))))
 AND (@POStatus IS NULL OR (@POStatus = '###NULL###' AND POStatus IS NULL ) OR (@POStatus <> '###NULL###' AND POStatus LIKE '%'+@POStatus+'%'))
 AND (@POStatus_Values IS NULL OR (@POStatus_Values = '###NULL###' AND POStatus IS NULL ) OR (@POStatus_Values <> '###NULL###' AND POStatus IN(SELECT Item FROM [dbo].CustomeSplit(@POStatus_Values,','))))
 AND (@PurApprovedBy_Values IS NULL OR  (@PurApprovedBy_Values = '###NULL###' AND PurApprovedBy IS NULL ) OR (@PurApprovedBy_Values <> '###NULL###' AND PurApprovedBy IN(SELECT Item FROM [dbo].CustomeSplit(@PurApprovedBy_Values,','))))
 AND (@PurApprovedBy_Min IS NULL OR PurApprovedBy >=  @PurApprovedBy_Min)
 AND (@PurApprovedBy_Max IS NULL OR PurApprovedBy <=  @PurApprovedBy_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@QuoteCustName IS NULL OR (@QuoteCustName = '###NULL###' AND QuoteCustName IS NULL ) OR (@QuoteCustName <> '###NULL###' AND QuoteCustName LIKE '%'+@QuoteCustName+'%'))
 AND (@QuoteCustName_Values IS NULL OR (@QuoteCustName_Values = '###NULL###' AND QuoteCustName IS NULL ) OR (@QuoteCustName_Values <> '###NULL###' AND QuoteCustName IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteCustName_Values,','))))
 AND (@StateTooltip IS NULL OR (@StateTooltip = '###NULL###' AND StateTooltip IS NULL ) OR (@StateTooltip <> '###NULL###' AND StateTooltip LIKE '%'+@StateTooltip+'%'))
 AND (@StateTooltip_Values IS NULL OR (@StateTooltip_Values = '###NULL###' AND StateTooltip IS NULL ) OR (@StateTooltip_Values <> '###NULL###' AND StateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@StateTooltip_Values,','))))
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT BranchID,BranchName,BranchCode,CustID,Vendor,PurchaseID,DeliveryDate,ReturnDate,IssuedBy,ReturnBy,Client,ShippingID,ShipAddr,ShipCity,ShowName,PurShipContact,PurShipAdd2,State,POStatus,PurApprovedBy,Total,QuoteCustName,StateTooltip FROM  VW_POReturnData (NOLOCK)

 WHERE (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND BranchName LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND BranchName IS NULL ) OR (@BranchName_Values <> '###NULL###' AND BranchName IN(SELECT Item FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@Vendor IS NULL OR (@Vendor = '###NULL###' AND Vendor IS NULL ) OR (@Vendor <> '###NULL###' AND Vendor LIKE '%'+@Vendor+'%'))
 AND (@Vendor_Values IS NULL OR (@Vendor_Values = '###NULL###' AND Vendor IS NULL ) OR (@Vendor_Values <> '###NULL###' AND Vendor IN(SELECT Item FROM [dbo].CustomeSplit(@Vendor_Values,','))))
 AND (@PurchaseID_Values IS NULL OR  (@PurchaseID_Values = '###NULL###' AND PurchaseID IS NULL ) OR (@PurchaseID_Values <> '###NULL###' AND PurchaseID IN(SELECT Item FROM [dbo].CustomeSplit(@PurchaseID_Values,','))))
 AND (@PurchaseID_Min IS NULL OR PurchaseID >=  @PurchaseID_Min)
 AND (@PurchaseID_Max IS NULL OR PurchaseID <=  @PurchaseID_Max)
 AND (@DeliveryDate IS NULL OR (@DeliveryDate = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate <> '###NULL###' AND DeliveryDate LIKE '%'+@DeliveryDate+'%'))
 AND (@DeliveryDate_Values IS NULL OR (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@ReturnDate IS NULL OR (@ReturnDate = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate <> '###NULL###' AND ReturnDate LIKE '%'+@ReturnDate+'%'))
 AND (@ReturnDate_Values IS NULL OR (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@IssuedBy IS NULL OR (@IssuedBy = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy <> '###NULL###' AND IssuedBy LIKE '%'+@IssuedBy+'%'))
 AND (@IssuedBy_Values IS NULL OR (@IssuedBy_Values = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy_Values <> '###NULL###' AND IssuedBy IN(SELECT Item FROM [dbo].CustomeSplit(@IssuedBy_Values,','))))
 AND (@ReturnBy IS NULL OR (@ReturnBy = '###NULL###' AND ReturnBy IS NULL ) OR (@ReturnBy <> '###NULL###' AND ReturnBy LIKE '%'+@ReturnBy+'%'))
 AND (@ReturnBy_Values IS NULL OR (@ReturnBy_Values = '###NULL###' AND ReturnBy IS NULL ) OR (@ReturnBy_Values <> '###NULL###' AND ReturnBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnBy_Values,','))))
 AND (@Client IS NULL OR (@Client = '###NULL###' AND Client IS NULL ) OR (@Client <> '###NULL###' AND Client LIKE '%'+@Client+'%'))
 AND (@Client_Values IS NULL OR (@Client_Values = '###NULL###' AND Client IS NULL ) OR (@Client_Values <> '###NULL###' AND Client IN(SELECT Item FROM [dbo].CustomeSplit(@Client_Values,','))))
 AND (@ShippingID IS NULL OR (@ShippingID = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID <> '###NULL###' AND ShippingID LIKE '%'+@ShippingID+'%'))
 AND (@ShippingID_Values IS NULL OR (@ShippingID_Values = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID_Values <> '###NULL###' AND ShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@ShippingID_Values,','))))
 AND (@ShipAddr IS NULL OR (@ShipAddr = '###NULL###' AND ShipAddr IS NULL ) OR (@ShipAddr <> '###NULL###' AND ShipAddr LIKE '%'+@ShipAddr+'%'))
 AND (@ShipAddr_Values IS NULL OR (@ShipAddr_Values = '###NULL###' AND ShipAddr IS NULL ) OR (@ShipAddr_Values <> '###NULL###' AND ShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@ShipAddr_Values,','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCity_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@PurShipContact IS NULL OR (@PurShipContact = '###NULL###' AND PurShipContact IS NULL ) OR (@PurShipContact <> '###NULL###' AND PurShipContact LIKE '%'+@PurShipContact+'%'))
 AND (@PurShipContact_Values IS NULL OR (@PurShipContact_Values = '###NULL###' AND PurShipContact IS NULL ) OR (@PurShipContact_Values <> '###NULL###' AND PurShipContact IN(SELECT Item FROM [dbo].CustomeSplit(@PurShipContact_Values,','))))
 AND (@PurShipAdd2 IS NULL OR (@PurShipAdd2 = '###NULL###' AND PurShipAdd2 IS NULL ) OR (@PurShipAdd2 <> '###NULL###' AND PurShipAdd2 LIKE '%'+@PurShipAdd2+'%'))
 AND (@PurShipAdd2_Values IS NULL OR (@PurShipAdd2_Values = '###NULL###' AND PurShipAdd2 IS NULL ) OR (@PurShipAdd2_Values <> '###NULL###' AND PurShipAdd2 IN(SELECT Item FROM [dbo].CustomeSplit(@PurShipAdd2_Values,','))))
 AND (@State IS NULL OR (@State = '###NULL###' AND State IS NULL ) OR (@State <> '###NULL###' AND State LIKE '%'+@State+'%'))
 AND (@State_Values IS NULL OR (@State_Values = '###NULL###' AND State IS NULL ) OR (@State_Values <> '###NULL###' AND State IN(SELECT Item FROM [dbo].CustomeSplit(@State_Values,','))))
 AND (@POStatus IS NULL OR (@POStatus = '###NULL###' AND POStatus IS NULL ) OR (@POStatus <> '###NULL###' AND POStatus LIKE '%'+@POStatus+'%'))
 AND (@POStatus_Values IS NULL OR (@POStatus_Values = '###NULL###' AND POStatus IS NULL ) OR (@POStatus_Values <> '###NULL###' AND POStatus IN(SELECT Item FROM [dbo].CustomeSplit(@POStatus_Values,','))))
 AND (@PurApprovedBy_Values IS NULL OR  (@PurApprovedBy_Values = '###NULL###' AND PurApprovedBy IS NULL ) OR (@PurApprovedBy_Values <> '###NULL###' AND PurApprovedBy IN(SELECT Item FROM [dbo].CustomeSplit(@PurApprovedBy_Values,','))))
 AND (@PurApprovedBy_Min IS NULL OR PurApprovedBy >=  @PurApprovedBy_Min)
 AND (@PurApprovedBy_Max IS NULL OR PurApprovedBy <=  @PurApprovedBy_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@QuoteCustName IS NULL OR (@QuoteCustName = '###NULL###' AND QuoteCustName IS NULL ) OR (@QuoteCustName <> '###NULL###' AND QuoteCustName LIKE '%'+@QuoteCustName+'%'))
 AND (@QuoteCustName_Values IS NULL OR (@QuoteCustName_Values = '###NULL###' AND QuoteCustName IS NULL ) OR (@QuoteCustName_Values <> '###NULL###' AND QuoteCustName IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteCustName_Values,','))))
 AND (@StateTooltip IS NULL OR (@StateTooltip = '###NULL###' AND StateTooltip IS NULL ) OR (@StateTooltip <> '###NULL###' AND StateTooltip LIKE '%'+@StateTooltip+'%'))
 AND (@StateTooltip_Values IS NULL OR (@StateTooltip_Values = '###NULL###' AND StateTooltip IS NULL ) OR (@StateTooltip_Values <> '###NULL###' AND StateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@StateTooltip_Values,','))))
 
END
ELSE
BEGIN
SELECT BranchID,BranchName,BranchCode,CustID,Vendor,PurchaseID,DeliveryDate,ReturnDate,IssuedBy,ReturnBy,Client,ShippingID,ShipAddr,ShipCity,ShowName,PurShipContact,PurShipAdd2,State,POStatus,PurApprovedBy,Total,QuoteCustName,StateTooltip FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_POReturnData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.BranchID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN VW_POReturnData.BranchID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN VW_POReturnData.BranchID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.BranchName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN VW_POReturnData.BranchName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=0 THEN VW_POReturnData.BranchName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.BranchCode IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN VW_POReturnData.BranchCode ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=0 THEN VW_POReturnData.BranchCode ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.CustID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN VW_POReturnData.CustID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN VW_POReturnData.CustID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.Vendor IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=1 THEN VW_POReturnData.Vendor ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=0 THEN VW_POReturnData.Vendor ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.PurchaseID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=1 THEN VW_POReturnData.PurchaseID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=0 THEN VW_POReturnData.PurchaseID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.DeliveryDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN VW_POReturnData.DeliveryDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN VW_POReturnData.DeliveryDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.ReturnDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN VW_POReturnData.ReturnDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=0 THEN VW_POReturnData.ReturnDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.IssuedBy' OR @Sort_Column='IssuedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.IssuedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.IssuedBy' OR @Sort_Column='IssuedBy') AND @Sort_Ascending=1 THEN VW_POReturnData.IssuedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.IssuedBy' OR @Sort_Column='IssuedBy') AND @Sort_Ascending=0 THEN VW_POReturnData.IssuedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.ReturnBy' OR @Sort_Column='ReturnBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.ReturnBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ReturnBy' OR @Sort_Column='ReturnBy') AND @Sort_Ascending=1 THEN VW_POReturnData.ReturnBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ReturnBy' OR @Sort_Column='ReturnBy') AND @Sort_Ascending=0 THEN VW_POReturnData.ReturnBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.Client IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=1 THEN VW_POReturnData.Client ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=0 THEN VW_POReturnData.Client ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.ShippingID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=1 THEN VW_POReturnData.ShippingID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=0 THEN VW_POReturnData.ShippingID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.ShipAddr' OR @Sort_Column='ShipAddr') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.ShipAddr IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ShipAddr' OR @Sort_Column='ShipAddr') AND @Sort_Ascending=1 THEN VW_POReturnData.ShipAddr ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ShipAddr' OR @Sort_Column='ShipAddr') AND @Sort_Ascending=0 THEN VW_POReturnData.ShipAddr ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.ShipCity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=1 THEN VW_POReturnData.ShipCity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=0 THEN VW_POReturnData.ShipCity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.ShowName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=1 THEN VW_POReturnData.ShowName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=0 THEN VW_POReturnData.ShowName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.PurShipContact' OR @Sort_Column='PurShipContact') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.PurShipContact IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.PurShipContact' OR @Sort_Column='PurShipContact') AND @Sort_Ascending=1 THEN VW_POReturnData.PurShipContact ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.PurShipContact' OR @Sort_Column='PurShipContact') AND @Sort_Ascending=0 THEN VW_POReturnData.PurShipContact ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.PurShipAdd2' OR @Sort_Column='PurShipAdd2') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.PurShipAdd2 IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.PurShipAdd2' OR @Sort_Column='PurShipAdd2') AND @Sort_Ascending=1 THEN VW_POReturnData.PurShipAdd2 ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.PurShipAdd2' OR @Sort_Column='PurShipAdd2') AND @Sort_Ascending=0 THEN VW_POReturnData.PurShipAdd2 ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.State' OR @Sort_Column='State') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.State IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.State' OR @Sort_Column='State') AND @Sort_Ascending=1 THEN VW_POReturnData.State ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.State' OR @Sort_Column='State') AND @Sort_Ascending=0 THEN VW_POReturnData.State ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.POStatus' OR @Sort_Column='POStatus') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.POStatus IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.POStatus' OR @Sort_Column='POStatus') AND @Sort_Ascending=1 THEN VW_POReturnData.POStatus ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.POStatus' OR @Sort_Column='POStatus') AND @Sort_Ascending=0 THEN VW_POReturnData.POStatus ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.PurApprovedBy' OR @Sort_Column='PurApprovedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.PurApprovedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.PurApprovedBy' OR @Sort_Column='PurApprovedBy') AND @Sort_Ascending=1 THEN VW_POReturnData.PurApprovedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.PurApprovedBy' OR @Sort_Column='PurApprovedBy') AND @Sort_Ascending=0 THEN VW_POReturnData.PurApprovedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.Total IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN VW_POReturnData.Total ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN VW_POReturnData.Total ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.QuoteCustName' OR @Sort_Column='QuoteCustName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.QuoteCustName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.QuoteCustName' OR @Sort_Column='QuoteCustName') AND @Sort_Ascending=1 THEN VW_POReturnData.QuoteCustName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.QuoteCustName' OR @Sort_Column='QuoteCustName') AND @Sort_Ascending=0 THEN VW_POReturnData.QuoteCustName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_POReturnData.StateTooltip' OR @Sort_Column='StateTooltip') AND @Sort_Ascending=1 THEN (CASE WHEN VW_POReturnData.StateTooltip IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.StateTooltip' OR @Sort_Column='StateTooltip') AND @Sort_Ascending=1 THEN VW_POReturnData.StateTooltip ELSE NULL END,
CASE WHEN (@Sort_Column='VW_POReturnData.StateTooltip' OR @Sort_Column='StateTooltip') AND @Sort_Ascending=0 THEN VW_POReturnData.StateTooltip ELSE NULL END DESC
 ) AS RowNum, VW_POReturnData.*
 FROM  VW_POReturnData (NOLOCK)

 WHERE (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND BranchName LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND BranchName IS NULL ) OR (@BranchName_Values <> '###NULL###' AND BranchName IN(SELECT Item FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@Vendor IS NULL OR (@Vendor = '###NULL###' AND Vendor IS NULL ) OR (@Vendor <> '###NULL###' AND Vendor LIKE '%'+@Vendor+'%'))
 AND (@Vendor_Values IS NULL OR (@Vendor_Values = '###NULL###' AND Vendor IS NULL ) OR (@Vendor_Values <> '###NULL###' AND Vendor IN(SELECT Item FROM [dbo].CustomeSplit(@Vendor_Values,','))))
 AND (@PurchaseID_Values IS NULL OR  (@PurchaseID_Values = '###NULL###' AND PurchaseID IS NULL ) OR (@PurchaseID_Values <> '###NULL###' AND PurchaseID IN(SELECT Item FROM [dbo].CustomeSplit(@PurchaseID_Values,','))))
 AND (@PurchaseID_Min IS NULL OR PurchaseID >=  @PurchaseID_Min)
 AND (@PurchaseID_Max IS NULL OR PurchaseID <=  @PurchaseID_Max)
 AND (@DeliveryDate IS NULL OR (@DeliveryDate = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate <> '###NULL###' AND DeliveryDate LIKE '%'+@DeliveryDate+'%'))
 AND (@DeliveryDate_Values IS NULL OR (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@ReturnDate IS NULL OR (@ReturnDate = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate <> '###NULL###' AND ReturnDate LIKE '%'+@ReturnDate+'%'))
 AND (@ReturnDate_Values IS NULL OR (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@IssuedBy IS NULL OR (@IssuedBy = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy <> '###NULL###' AND IssuedBy LIKE '%'+@IssuedBy+'%'))
 AND (@IssuedBy_Values IS NULL OR (@IssuedBy_Values = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy_Values <> '###NULL###' AND IssuedBy IN(SELECT Item FROM [dbo].CustomeSplit(@IssuedBy_Values,','))))
 AND (@ReturnBy IS NULL OR (@ReturnBy = '###NULL###' AND ReturnBy IS NULL ) OR (@ReturnBy <> '###NULL###' AND ReturnBy LIKE '%'+@ReturnBy+'%'))
 AND (@ReturnBy_Values IS NULL OR (@ReturnBy_Values = '###NULL###' AND ReturnBy IS NULL ) OR (@ReturnBy_Values <> '###NULL###' AND ReturnBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnBy_Values,','))))
 AND (@Client IS NULL OR (@Client = '###NULL###' AND Client IS NULL ) OR (@Client <> '###NULL###' AND Client LIKE '%'+@Client+'%'))
 AND (@Client_Values IS NULL OR (@Client_Values = '###NULL###' AND Client IS NULL ) OR (@Client_Values <> '###NULL###' AND Client IN(SELECT Item FROM [dbo].CustomeSplit(@Client_Values,','))))
 AND (@ShippingID IS NULL OR (@ShippingID = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID <> '###NULL###' AND ShippingID LIKE '%'+@ShippingID+'%'))
 AND (@ShippingID_Values IS NULL OR (@ShippingID_Values = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID_Values <> '###NULL###' AND ShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@ShippingID_Values,','))))
 AND (@ShipAddr IS NULL OR (@ShipAddr = '###NULL###' AND ShipAddr IS NULL ) OR (@ShipAddr <> '###NULL###' AND ShipAddr LIKE '%'+@ShipAddr+'%'))
 AND (@ShipAddr_Values IS NULL OR (@ShipAddr_Values = '###NULL###' AND ShipAddr IS NULL ) OR (@ShipAddr_Values <> '###NULL###' AND ShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@ShipAddr_Values,','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCity_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@PurShipContact IS NULL OR (@PurShipContact = '###NULL###' AND PurShipContact IS NULL ) OR (@PurShipContact <> '###NULL###' AND PurShipContact LIKE '%'+@PurShipContact+'%'))
 AND (@PurShipContact_Values IS NULL OR (@PurShipContact_Values = '###NULL###' AND PurShipContact IS NULL ) OR (@PurShipContact_Values <> '###NULL###' AND PurShipContact IN(SELECT Item FROM [dbo].CustomeSplit(@PurShipContact_Values,','))))
 AND (@PurShipAdd2 IS NULL OR (@PurShipAdd2 = '###NULL###' AND PurShipAdd2 IS NULL ) OR (@PurShipAdd2 <> '###NULL###' AND PurShipAdd2 LIKE '%'+@PurShipAdd2+'%'))
 AND (@PurShipAdd2_Values IS NULL OR (@PurShipAdd2_Values = '###NULL###' AND PurShipAdd2 IS NULL ) OR (@PurShipAdd2_Values <> '###NULL###' AND PurShipAdd2 IN(SELECT Item FROM [dbo].CustomeSplit(@PurShipAdd2_Values,','))))
 AND (@State IS NULL OR (@State = '###NULL###' AND State IS NULL ) OR (@State <> '###NULL###' AND State LIKE '%'+@State+'%'))
 AND (@State_Values IS NULL OR (@State_Values = '###NULL###' AND State IS NULL ) OR (@State_Values <> '###NULL###' AND State IN(SELECT Item FROM [dbo].CustomeSplit(@State_Values,','))))
 AND (@POStatus IS NULL OR (@POStatus = '###NULL###' AND POStatus IS NULL ) OR (@POStatus <> '###NULL###' AND POStatus LIKE '%'+@POStatus+'%'))
 AND (@POStatus_Values IS NULL OR (@POStatus_Values = '###NULL###' AND POStatus IS NULL ) OR (@POStatus_Values <> '###NULL###' AND POStatus IN(SELECT Item FROM [dbo].CustomeSplit(@POStatus_Values,','))))
 AND (@PurApprovedBy_Values IS NULL OR  (@PurApprovedBy_Values = '###NULL###' AND PurApprovedBy IS NULL ) OR (@PurApprovedBy_Values <> '###NULL###' AND PurApprovedBy IN(SELECT Item FROM [dbo].CustomeSplit(@PurApprovedBy_Values,','))))
 AND (@PurApprovedBy_Min IS NULL OR PurApprovedBy >=  @PurApprovedBy_Min)
 AND (@PurApprovedBy_Max IS NULL OR PurApprovedBy <=  @PurApprovedBy_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@QuoteCustName IS NULL OR (@QuoteCustName = '###NULL###' AND QuoteCustName IS NULL ) OR (@QuoteCustName <> '###NULL###' AND QuoteCustName LIKE '%'+@QuoteCustName+'%'))
 AND (@QuoteCustName_Values IS NULL OR (@QuoteCustName_Values = '###NULL###' AND QuoteCustName IS NULL ) OR (@QuoteCustName_Values <> '###NULL###' AND QuoteCustName IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteCustName_Values,','))))
 AND (@StateTooltip IS NULL OR (@StateTooltip = '###NULL###' AND StateTooltip IS NULL ) OR (@StateTooltip <> '###NULL###' AND StateTooltip LIKE '%'+@StateTooltip+'%'))
 AND (@StateTooltip_Values IS NULL OR (@StateTooltip_Values = '###NULL###' AND StateTooltip IS NULL ) OR (@StateTooltip_Values <> '###NULL###' AND StateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@StateTooltip_Values,','))))
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_PotentialRepeatBusinessFollowUpData_View_Search]    Script Date: 29-07-2020 09:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_PotentialRepeatBusinessFollowUpData_View_Search]

@ResultCount INT OUTPUT,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@Interest nvarchar(50) = NULL,
@Interest_Values nvarchar(max) = NULL,
@QuoteTypeNo_Values nvarchar(max) = NULL,
@QuoteTypeNo_Min float = NULL,
@QuoteTypeNo_Max float = NULL,
@OrderFrequency nvarchar(50) = NULL,
@OrderFrequency_Values nvarchar(max) = NULL,
@DoNotContact bit = NULL,
@DoNotContactDate_Values nvarchar(max) = NULL,
@DoNotContactDate_Min datetime = NULL,
@DoNotContactDate_Max datetime = NULL,
@DoNotContactBy nvarchar(100) = NULL,
@DoNotContactBy_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@QuoteBranchCode nvarchar(50) = NULL,
@QuoteBranchCode_Values nvarchar(max) = NULL,
@BranchName nvarchar(50) = NULL,
@BranchName_Values nvarchar(max) = NULL,
@Note varchar(1) = NULL,
@Note_Values nvarchar(max) = NULL,
@QuoteID_Values nvarchar(max) = NULL,
@QuoteID_Min int = NULL,
@QuoteID_Max int = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@DeliveryDate_Min datetime = NULL,
@DeliveryDate_Max datetime = NULL,
@EnterDate_Values nvarchar(max) = NULL,
@EnterDate_Min datetime = NULL,
@EnterDate_Max datetime = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@CustomerId_Values nvarchar(max) = NULL,
@CustomerId_Min int = NULL,
@CustomerId_Max int = NULL,
@CustCode nvarchar(50) = NULL,
@CustCode_Values nvarchar(max) = NULL,
@LastActivityDateTime_Values nvarchar(max) = NULL,
@LastActivityDateTime_Min datetime = NULL,
@LastActivityDateTime_Max datetime = NULL,
@LastActivityNote nvarchar(150) = NULL,
@LastActivityNote_Values nvarchar(max) = NULL,
@DepartmentID_Values nvarchar(max) = NULL,
@DepartmentID_Min int = NULL,
@DepartmentID_Max int = NULL,
@DepartmentDescription nvarchar(50) = NULL,
@DepartmentDescription_Values nvarchar(max) = NULL,
@Inactive nvarchar(3) = NULL,
@Inactive_Values nvarchar(max) = NULL,
@MaxDateTime_Values nvarchar(max) = NULL,
@MaxDateTime_Min datetime = NULL,
@MaxDateTime_Max datetime = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1

AS
BEGIN
SET NOCOUNT ON;
SET @ResultCount = 0
IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
SET @ResultCount = (SELECT COUNT(1) FROM [dbo].[VW_PotentialRepeatBusinessFollowUpData] (NOLOCK)
 WHERE (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND [QuoteTypeNo] IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND [QuoteTypeNo] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR [QuoteTypeNo] >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR [QuoteTypeNo] <=  @QuoteTypeNo_Max)
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND [OrderFrequency] LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND [OrderFrequency] IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND [OrderFrequency] IN(SELECT [Item] FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@DoNotContact IS NULL OR [DoNotContact] =  @DoNotContact)
 AND (@DoNotContactDate_Values IS NULL OR  (@DoNotContactDate_Values = '###NULL###' AND [DoNotContactDate] IS NULL ) OR (@DoNotContactDate_Values <> '###NULL###' AND [DoNotContactDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactDate_Values,','))))
 AND (@DoNotContactDate_Min IS NULL OR [DoNotContactDate] >=  @DoNotContactDate_Min)
 AND (@DoNotContactDate_Max IS NULL OR [DoNotContactDate] <=  @DoNotContactDate_Max)
 AND (@DoNotContactBy IS NULL OR (@DoNotContactBy = '###NULL###' AND DoNotContactBy IS NULL ) OR (@DoNotContactBy <> '###NULL###' AND [DoNotContactBy] LIKE '%'+@DoNotContactBy+'%'))
 AND (@DoNotContactBy_Values IS NULL OR (@DoNotContactBy_Values = '###NULL###' AND [DoNotContactBy] IS NULL ) OR (@DoNotContactBy_Values <> '###NULL###' AND [DoNotContactBy] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactBy_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@EnterDate_Values IS NULL OR  (@EnterDate_Values = '###NULL###' AND [EnterDate] IS NULL ) OR (@EnterDate_Values <> '###NULL###' AND [EnterDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EnterDate_Values,','))))
 AND (@EnterDate_Min IS NULL OR [EnterDate] >=  @EnterDate_Min)
 AND (@EnterDate_Max IS NULL OR [EnterDate] <=  @EnterDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@CustCode IS NULL OR (@CustCode = '###NULL###' AND CustCode IS NULL ) OR (@CustCode <> '###NULL###' AND [CustCode] LIKE '%'+@CustCode+'%'))
 AND (@CustCode_Values IS NULL OR (@CustCode_Values = '###NULL###' AND [CustCode] IS NULL ) OR (@CustCode_Values <> '###NULL###' AND [CustCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustCode_Values,','))))
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@Inactive IS NULL OR (@Inactive = '###NULL###' AND Inactive IS NULL ) OR (@Inactive <> '###NULL###' AND [Inactive] LIKE '%'+@Inactive+'%'))
 AND (@Inactive_Values IS NULL OR (@Inactive_Values = '###NULL###' AND [Inactive] IS NULL ) OR (@Inactive_Values <> '###NULL###' AND [Inactive] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Inactive_Values,','))))
 AND (@MaxDateTime_Values IS NULL OR  (@MaxDateTime_Values = '###NULL###' AND [MaxDateTime] IS NULL ) OR (@MaxDateTime_Values <> '###NULL###' AND [MaxDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@MaxDateTime_Values,','))))
 AND (@MaxDateTime_Min IS NULL OR [MaxDateTime] >=  @MaxDateTime_Min)
 AND (@MaxDateTime_Max IS NULL OR [MaxDateTime] <=  @MaxDateTime_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT EmployeeID,SalesRep,CustName,Interest,QuoteTypeNo,OrderFrequency,DoNotContact,DoNotContactDate,DoNotContactBy,BranchID,QuoteBranchCode,BranchName,Note,QuoteID,DeliveryDate,EnterDate,Total,CustomerId,CustCode,LastActivityDateTime,LastActivityNote,DepartmentID,DepartmentDescription,Inactive,MaxDateTime FROM  [dbo].[VW_PotentialRepeatBusinessFollowUpData] (NOLOCK)

 WHERE (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND [QuoteTypeNo] IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND [QuoteTypeNo] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR [QuoteTypeNo] >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR [QuoteTypeNo] <=  @QuoteTypeNo_Max)
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND [OrderFrequency] LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND [OrderFrequency] IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND [OrderFrequency] IN(SELECT [Item] FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@DoNotContact IS NULL OR [DoNotContact] =  @DoNotContact)
 AND (@DoNotContactDate_Values IS NULL OR  (@DoNotContactDate_Values = '###NULL###' AND [DoNotContactDate] IS NULL ) OR (@DoNotContactDate_Values <> '###NULL###' AND [DoNotContactDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactDate_Values,','))))
 AND (@DoNotContactDate_Min IS NULL OR [DoNotContactDate] >=  @DoNotContactDate_Min)
 AND (@DoNotContactDate_Max IS NULL OR [DoNotContactDate] <=  @DoNotContactDate_Max)
 AND (@DoNotContactBy IS NULL OR (@DoNotContactBy = '###NULL###' AND DoNotContactBy IS NULL ) OR (@DoNotContactBy <> '###NULL###' AND [DoNotContactBy] LIKE '%'+@DoNotContactBy+'%'))
 AND (@DoNotContactBy_Values IS NULL OR (@DoNotContactBy_Values = '###NULL###' AND [DoNotContactBy] IS NULL ) OR (@DoNotContactBy_Values <> '###NULL###' AND [DoNotContactBy] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactBy_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@EnterDate_Values IS NULL OR  (@EnterDate_Values = '###NULL###' AND [EnterDate] IS NULL ) OR (@EnterDate_Values <> '###NULL###' AND [EnterDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EnterDate_Values,','))))
 AND (@EnterDate_Min IS NULL OR [EnterDate] >=  @EnterDate_Min)
 AND (@EnterDate_Max IS NULL OR [EnterDate] <=  @EnterDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@CustCode IS NULL OR (@CustCode = '###NULL###' AND CustCode IS NULL ) OR (@CustCode <> '###NULL###' AND [CustCode] LIKE '%'+@CustCode+'%'))
 AND (@CustCode_Values IS NULL OR (@CustCode_Values = '###NULL###' AND [CustCode] IS NULL ) OR (@CustCode_Values <> '###NULL###' AND [CustCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustCode_Values,','))))
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@Inactive IS NULL OR (@Inactive = '###NULL###' AND Inactive IS NULL ) OR (@Inactive <> '###NULL###' AND [Inactive] LIKE '%'+@Inactive+'%'))
 AND (@Inactive_Values IS NULL OR (@Inactive_Values = '###NULL###' AND [Inactive] IS NULL ) OR (@Inactive_Values <> '###NULL###' AND [Inactive] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Inactive_Values,','))))
 AND (@MaxDateTime_Values IS NULL OR  (@MaxDateTime_Values = '###NULL###' AND [MaxDateTime] IS NULL ) OR (@MaxDateTime_Values <> '###NULL###' AND [MaxDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@MaxDateTime_Values,','))))
 AND (@MaxDateTime_Min IS NULL OR [MaxDateTime] >=  @MaxDateTime_Min)
 AND (@MaxDateTime_Max IS NULL OR [MaxDateTime] <=  @MaxDateTime_Max)
 
END
ELSE
BEGIN
SELECT EmployeeID,SalesRep,CustName,Interest,QuoteTypeNo,OrderFrequency,DoNotContact,DoNotContactDate,DoNotContactBy,BranchID,QuoteBranchCode,BranchName,Note,QuoteID,DeliveryDate,EnterDate,Total,CustomerId,CustCode,LastActivityDateTime,LastActivityNote,DepartmentID,DepartmentDescription,Inactive,MaxDateTime FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[EmployeeID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[EmployeeID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[EmployeeID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[SalesRep] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[SalesRep] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[SalesRep] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[CustName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[CustName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[CustName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[Interest] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[Interest] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[Interest] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteTypeNo] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteTypeNo] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteTypeNo] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[OrderFrequency] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[OrderFrequency] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[OrderFrequency] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContact' OR @Sort_Column='DoNotContact') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContact] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContact' OR @Sort_Column='DoNotContact') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContact] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContact' OR @Sort_Column='DoNotContact') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContact] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContactDate' OR @Sort_Column='DoNotContactDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContactDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContactDate' OR @Sort_Column='DoNotContactDate') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContactDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContactDate' OR @Sort_Column='DoNotContactDate') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContactDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContactBy' OR @Sort_Column='DoNotContactBy') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContactBy] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContactBy' OR @Sort_Column='DoNotContactBy') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContactBy] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DoNotContactBy' OR @Sort_Column='DoNotContactBy') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[DoNotContactBy] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[BranchID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[BranchID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[BranchID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteBranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteBranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteBranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[BranchName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[BranchName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[BranchName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[Note] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[Note] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[Note] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[QuoteID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[DeliveryDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[DeliveryDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[DeliveryDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.EnterDate' OR @Sort_Column='EnterDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[EnterDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.EnterDate' OR @Sort_Column='EnterDate') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[EnterDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.EnterDate' OR @Sort_Column='EnterDate') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[EnterDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[Total] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[Total] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[Total] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[CustomerId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[CustomerId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[CustomerId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustCode' OR @Sort_Column='CustCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[CustCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustCode' OR @Sort_Column='CustCode') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[CustCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.CustCode' OR @Sort_Column='CustCode') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[CustCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[LastActivityDateTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[LastActivityDateTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[LastActivityDateTime] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[LastActivityNote] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[LastActivityNote] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[LastActivityNote] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[DepartmentID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[DepartmentID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DepartmentID' OR @Sort_Column='DepartmentID') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[DepartmentID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[DepartmentDescription] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[DepartmentDescription] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.DepartmentDescription' OR @Sort_Column='DepartmentDescription') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[DepartmentDescription] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Inactive' OR @Sort_Column='Inactive') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[Inactive] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Inactive' OR @Sort_Column='Inactive') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[Inactive] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.Inactive' OR @Sort_Column='Inactive') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[Inactive] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.MaxDateTime' OR @Sort_Column='MaxDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_PotentialRepeatBusinessFollowUpData].[MaxDateTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.MaxDateTime' OR @Sort_Column='MaxDateTime') AND @Sort_Ascending=1 THEN [VW_PotentialRepeatBusinessFollowUpData].[MaxDateTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PotentialRepeatBusinessFollowUpData.MaxDateTime' OR @Sort_Column='MaxDateTime') AND @Sort_Ascending=0 THEN [VW_PotentialRepeatBusinessFollowUpData].[MaxDateTime] ELSE NULL END DESC
 ) AS RowNum, [VW_PotentialRepeatBusinessFollowUpData].*
 FROM  [dbo].[VW_PotentialRepeatBusinessFollowUpData] (NOLOCK)

 WHERE (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND [QuoteTypeNo] IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND [QuoteTypeNo] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR [QuoteTypeNo] >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR [QuoteTypeNo] <=  @QuoteTypeNo_Max)
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND [OrderFrequency] LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND [OrderFrequency] IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND [OrderFrequency] IN(SELECT [Item] FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@DoNotContact IS NULL OR [DoNotContact] =  @DoNotContact)
 AND (@DoNotContactDate_Values IS NULL OR  (@DoNotContactDate_Values = '###NULL###' AND [DoNotContactDate] IS NULL ) OR (@DoNotContactDate_Values <> '###NULL###' AND [DoNotContactDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactDate_Values,','))))
 AND (@DoNotContactDate_Min IS NULL OR [DoNotContactDate] >=  @DoNotContactDate_Min)
 AND (@DoNotContactDate_Max IS NULL OR [DoNotContactDate] <=  @DoNotContactDate_Max)
 AND (@DoNotContactBy IS NULL OR (@DoNotContactBy = '###NULL###' AND DoNotContactBy IS NULL ) OR (@DoNotContactBy <> '###NULL###' AND [DoNotContactBy] LIKE '%'+@DoNotContactBy+'%'))
 AND (@DoNotContactBy_Values IS NULL OR (@DoNotContactBy_Values = '###NULL###' AND [DoNotContactBy] IS NULL ) OR (@DoNotContactBy_Values <> '###NULL###' AND [DoNotContactBy] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DoNotContactBy_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@BranchName IS NULL OR (@BranchName = '###NULL###' AND BranchName IS NULL ) OR (@BranchName <> '###NULL###' AND [BranchName] LIKE '%'+@BranchName+'%'))
 AND (@BranchName_Values IS NULL OR (@BranchName_Values = '###NULL###' AND [BranchName] IS NULL ) OR (@BranchName_Values <> '###NULL###' AND [BranchName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchName_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@EnterDate_Values IS NULL OR  (@EnterDate_Values = '###NULL###' AND [EnterDate] IS NULL ) OR (@EnterDate_Values <> '###NULL###' AND [EnterDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EnterDate_Values,','))))
 AND (@EnterDate_Min IS NULL OR [EnterDate] >=  @EnterDate_Min)
 AND (@EnterDate_Max IS NULL OR [EnterDate] <=  @EnterDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@CustCode IS NULL OR (@CustCode = '###NULL###' AND CustCode IS NULL ) OR (@CustCode <> '###NULL###' AND [CustCode] LIKE '%'+@CustCode+'%'))
 AND (@CustCode_Values IS NULL OR (@CustCode_Values = '###NULL###' AND [CustCode] IS NULL ) OR (@CustCode_Values <> '###NULL###' AND [CustCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustCode_Values,','))))
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 AND (@DepartmentID_Values IS NULL OR  (@DepartmentID_Values = '###NULL###' AND [DepartmentID] IS NULL ) OR (@DepartmentID_Values <> '###NULL###' AND [DepartmentID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentID_Values,','))))
 AND (@DepartmentID_Min IS NULL OR [DepartmentID] >=  @DepartmentID_Min)
 AND (@DepartmentID_Max IS NULL OR [DepartmentID] <=  @DepartmentID_Max)
 AND (@DepartmentDescription IS NULL OR (@DepartmentDescription = '###NULL###' AND DepartmentDescription IS NULL ) OR (@DepartmentDescription <> '###NULL###' AND [DepartmentDescription] LIKE '%'+@DepartmentDescription+'%'))
 AND (@DepartmentDescription_Values IS NULL OR (@DepartmentDescription_Values = '###NULL###' AND [DepartmentDescription] IS NULL ) OR (@DepartmentDescription_Values <> '###NULL###' AND [DepartmentDescription] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DepartmentDescription_Values,','))))
 AND (@Inactive IS NULL OR (@Inactive = '###NULL###' AND Inactive IS NULL ) OR (@Inactive <> '###NULL###' AND [Inactive] LIKE '%'+@Inactive+'%'))
 AND (@Inactive_Values IS NULL OR (@Inactive_Values = '###NULL###' AND [Inactive] IS NULL ) OR (@Inactive_Values <> '###NULL###' AND [Inactive] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Inactive_Values,','))))
 AND (@MaxDateTime_Values IS NULL OR  (@MaxDateTime_Values = '###NULL###' AND [MaxDateTime] IS NULL ) OR (@MaxDateTime_Values <> '###NULL###' AND [MaxDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@MaxDateTime_Values,','))))
 AND (@MaxDateTime_Min IS NULL OR [MaxDateTime] >=  @MaxDateTime_Min)
 AND (@MaxDateTime_Max IS NULL OR [MaxDateTime] <=  @MaxDateTime_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_QuoteNeedingFollowUpData_View_Search]    Script Date: 29-07-2020 09:37:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_QuoteNeedingFollowUpData_View_Search]

@ResultCount INT OUTPUT,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@QuoteBranchCode nvarchar(50) = NULL,
@QuoteBranchCode_Values nvarchar(max) = NULL,
@Note nvarchar(1024) = NULL,
@Note_Values nvarchar(max) = NULL,
@QuoteID_Values nvarchar(max) = NULL,
@QuoteID_Min int = NULL,
@QuoteID_Max int = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@DeliveryDate_Min datetime = NULL,
@DeliveryDate_Max datetime = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@CustomerId_Values nvarchar(max) = NULL,
@CustomerId_Min int = NULL,
@CustomerId_Max int = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
@Interest nvarchar(50) = NULL,
@Interest_Values nvarchar(max) = NULL,
@InterestType_Values nvarchar(max) = NULL,
@InterestType_Min float = NULL,
@InterestType_Max float = NULL,
@LastActivityDateTime_Values nvarchar(max) = NULL,
@LastActivityDateTime_Min datetime = NULL,
@LastActivityDateTime_Max datetime = NULL,
@LastActivityNote nvarchar(150) = NULL,
@LastActivityNote_Values nvarchar(max) = NULL,
@Page_Size int  = NULL,
@Page_Index int = NULL,
@Sort_Column nvarchar(250) = NULL,
@Sort_Ascending bit  = NULL,
@IsBinaryRequired bit = 0,
@IsPrimaryIN bit = 1

AS
BEGIN
SET NOCOUNT ON;
SET @ResultCount = 0
IF NOT (@Page_Size IS NULL OR @Page_Index IS NULL)
BEGIN
SET @ResultCount = (SELECT COUNT(1) FROM [dbo].[VW_QuoteNeedingFollowUpData] (NOLOCK)
 WHERE (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND [InterestType] IS NULL ) OR (@InterestType_Values <> '###NULL###' AND [InterestType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR [InterestType] >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR [InterestType] <=  @InterestType_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT SalesRep,CustName,BranchID,QuoteBranchCode,Note,QuoteID,DeliveryDate,Total,CustomerId,EmployeeID,Interest,InterestType,LastActivityDateTime,LastActivityNote FROM  [dbo].[VW_QuoteNeedingFollowUpData] (NOLOCK)

 WHERE (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND [InterestType] IS NULL ) OR (@InterestType_Values <> '###NULL###' AND [InterestType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR [InterestType] >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR [InterestType] <=  @InterestType_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 
END
ELSE
BEGIN
SELECT SalesRep,CustName,BranchID,QuoteBranchCode,Note,QuoteID,DeliveryDate,Total,CustomerId,EmployeeID,Interest,InterestType,LastActivityDateTime,LastActivityNote FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[SalesRep] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[SalesRep] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[SalesRep] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[CustName] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[CustName] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[CustName] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[BranchID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[BranchID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[BranchID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[QuoteBranchCode] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[QuoteBranchCode] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.QuoteBranchCode' OR @Sort_Column='QuoteBranchCode') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[QuoteBranchCode] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[Note] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[Note] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Note' OR @Sort_Column='Note') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[Note] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[QuoteID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[QuoteID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[QuoteID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[DeliveryDate] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[DeliveryDate] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[DeliveryDate] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[Total] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[Total] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[Total] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[CustomerId] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[CustomerId] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.CustomerId' OR @Sort_Column='CustomerId') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[CustomerId] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[EmployeeID] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[EmployeeID] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[EmployeeID] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[Interest] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[Interest] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[Interest] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[InterestType] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[InterestType] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[InterestType] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[LastActivityDateTime] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[LastActivityDateTime] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.LastActivityDateTime' OR @Sort_Column='LastActivityDateTime') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[LastActivityDateTime] ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN (CASE WHEN [VW_QuoteNeedingFollowUpData].[LastActivityNote] IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=1 THEN [VW_QuoteNeedingFollowUpData].[LastActivityNote] ELSE NULL END,
CASE WHEN (@Sort_Column='VW_QuoteNeedingFollowUpData.LastActivityNote' OR @Sort_Column='LastActivityNote') AND @Sort_Ascending=0 THEN [VW_QuoteNeedingFollowUpData].[LastActivityNote] ELSE NULL END DESC
 ) AS RowNum, [VW_QuoteNeedingFollowUpData].*
 FROM  [dbo].[VW_QuoteNeedingFollowUpData] (NOLOCK)

 WHERE (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND [SalesRep] LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND [SalesRep] IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND [SalesRep] IN(SELECT [Item] FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND [CustName] LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND [CustName] IS NULL ) OR (@CustName_Values <> '###NULL###' AND [CustName] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND [BranchID] IS NULL ) OR (@BranchID_Values <> '###NULL###' AND [BranchID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR [BranchID] >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR [BranchID] <=  @BranchID_Max)
 AND (@QuoteBranchCode IS NULL OR (@QuoteBranchCode = '###NULL###' AND QuoteBranchCode IS NULL ) OR (@QuoteBranchCode <> '###NULL###' AND [QuoteBranchCode] LIKE '%'+@QuoteBranchCode+'%'))
 AND (@QuoteBranchCode_Values IS NULL OR (@QuoteBranchCode_Values = '###NULL###' AND [QuoteBranchCode] IS NULL ) OR (@QuoteBranchCode_Values <> '###NULL###' AND [QuoteBranchCode] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteBranchCode_Values,','))))
 AND (@Note IS NULL OR (@Note = '###NULL###' AND Note IS NULL ) OR (@Note <> '###NULL###' AND [Note] LIKE '%'+@Note+'%'))
 AND (@Note_Values IS NULL OR (@Note_Values = '###NULL###' AND [Note] IS NULL ) OR (@Note_Values <> '###NULL###' AND [Note] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Note_Values,','))))
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND [QuoteID] IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND [QuoteID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR [QuoteID] >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR [QuoteID] <=  @QuoteID_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND [DeliveryDate] IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND [DeliveryDate] IN(SELECT [Item] FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR [DeliveryDate] >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR [DeliveryDate] <=  @DeliveryDate_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND [Total] IS NULL ) OR (@Total_Values <> '###NULL###' AND [Total] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR [Total] >=  @Total_Min)
 AND (@Total_Max IS NULL OR [Total] <=  @Total_Max)
 AND (@CustomerId_Values IS NULL OR  (@CustomerId_Values = '###NULL###' AND [CustomerId] IS NULL ) OR (@CustomerId_Values <> '###NULL###' AND [CustomerId] IN(SELECT [Item] FROM [dbo].CustomeSplit(@CustomerId_Values,','))))
 AND (@CustomerId_Min IS NULL OR [CustomerId] >=  @CustomerId_Min)
 AND (@CustomerId_Max IS NULL OR [CustomerId] <=  @CustomerId_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND [EmployeeID] IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND [EmployeeID] IN(SELECT [Item] FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR [EmployeeID] >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR [EmployeeID] <=  @EmployeeID_Max)
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND [Interest] LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND [Interest] IS NULL ) OR (@Interest_Values <> '###NULL###' AND [Interest] IN(SELECT [Item] FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND [InterestType] IS NULL ) OR (@InterestType_Values <> '###NULL###' AND [InterestType] IN(SELECT [Item] FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR [InterestType] >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR [InterestType] <=  @InterestType_Max)
 AND (@LastActivityDateTime_Values IS NULL OR  (@LastActivityDateTime_Values = '###NULL###' AND [LastActivityDateTime] IS NULL ) OR (@LastActivityDateTime_Values <> '###NULL###' AND [LastActivityDateTime] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityDateTime_Values,','))))
 AND (@LastActivityDateTime_Min IS NULL OR [LastActivityDateTime] >=  @LastActivityDateTime_Min)
 AND (@LastActivityDateTime_Max IS NULL OR [LastActivityDateTime] <=  @LastActivityDateTime_Max)
 AND (@LastActivityNote IS NULL OR (@LastActivityNote = '###NULL###' AND LastActivityNote IS NULL ) OR (@LastActivityNote <> '###NULL###' AND [LastActivityNote] LIKE '%'+@LastActivityNote+'%'))
 AND (@LastActivityNote_Values IS NULL OR (@LastActivityNote_Values = '###NULL###' AND [LastActivityNote] IS NULL ) OR (@LastActivityNote_Values <> '###NULL###' AND [LastActivityNote] IN(SELECT [Item] FROM [dbo].CustomeSplit(@LastActivityNote_Values,','))))
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO


GO
/****** Object:  StoredProcedure [dbo].[spr_tb_UM_AutoReportDropDown]    Script Date: 29-07-2020 09:43:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Jishan siddique>
-- Create date: <Create Date,23-07-2020>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spr_tb_UM_AutoReportDropDown]
	@UserID INT
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT * FROM 
	[dbo].[UM_AutoReport] [Report] (NOLOCK)
	WHERE [Report].[UserID] = @UserID AND
	[Report].[IsActive] = 1
   END

   GO
/****** Object:  StoredProcedure [dbo].[spr_tb_UM_ReportFilter_GridConfiguration]    Script Date: 29-07-2020 09:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,25-07-2020>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spr_tb_UM_ReportFilter_GridConfiguration]
	 @ReportName VARCHAR(200)
	,@UserID	INT
	,@GridConfiguration NVARCHAR(MAX)
AS
BEGIN
	UPDATE [dbo].[UM_ReportFilter] SET
	[GridConfiguration] = @GridConfiguration
	WHERE [ReportName] = @ReportName AND
	[UserID] = @UserID
END

GO
/****** Object:  StoredProcedure [dbo].[spr_tb_UM_AutoReport_GetByID]    Script Date: 29-07-2020 09:44:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,23-07-2020>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spr_tb_UM_AutoReport_GetByID]
	@AutoReportID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
	[AutoReportID]
	,[ReportName]
	,[SqlQuery]
	,[UserID]
	,[IsActive]
	,[CreatedOn]
	,[CreatedBy]
	,[UpdatedOn]
	,[UpdatedBy]
	FROM [dbo].[UM_AutoReport] (NOLOCK)
	WHERE [AutoReportID] = @AutoReportID
END

GO
/****** Object:  Table [dbo].[UM_AutoReport]    Script Date: 29-07-2020 09:44:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [dbo].[UM_AutoReport] (
	[AutoReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [nvarchar](250) NOT NULL,
	[SqlQuery] [varchar](max) NOT NULL,
	[UserID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_UM_AutoReport] PRIMARY KEY CLUSTERED 
(
	[AutoReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[UM_AutoReport] ADD  CONSTRAINT [DF_UM_AutoReport_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO


IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'GridConfiguration' AND Object_ID = Object_ID(N'UM_ReportFilter'))
BEGIN
	 BEGIN TRANSACTION [UM_ReportFilter]
	 BEGIN TRY
		 ALTER TABLE [dbo].[UM_ReportFilter]
		 ADD GridConfiguration NVARCHAR(MAX) NULL 
	 COMMIT TRANSACTION [UM_ReportFilter]
	 END TRY
	 BEGIN CATCH
		 SELECT ERROR_MESSAGE() AS ErrorMessage
		 ROLLBACK TRANSACTION [UM_ReportFilter]
	 END CATCH
END