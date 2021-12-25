﻿USE [alliant_mvc]
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_InActiveAccountFolloUpData_View_Search]    Script Date: 11-08-2020 22:52:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spr_tb_VW_InActiveAccountFolloUpData_View_Search]
GO


/****** Object:  View [dbo].[VW_InActiveAccountFolloUpData]    Script Date: 11-08-2020 22:57:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER   VIEW [dbo].[VW_InActiveAccountFolloUpData]
AS
SELECT 
	 [Branch].[BranchID]
	,[Branch].[Active]
	,[Customers].[CustName]
	,[Employee].[EmployeeID] [RepId]
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
	,[LastActivity].[LastActivityNote]
	,[LastActivity].[LastActivityDateTime]
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
GROUP BY 
	 [Branch].[BranchID]
	,[Branch].[Active]
	,[Customers].[CustName]
	,[Employee].[EmployeeID] 
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
	,[LastActivity].[LastActivityNote]
	,[LastActivity].[LastActivityDateTime]
GO


