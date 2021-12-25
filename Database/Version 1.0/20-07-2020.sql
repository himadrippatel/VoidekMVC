USE [alliant_mvc]
GO

/****** Object:  View [dbo].[VW_BranchTransferData]    Script Date: 20-07-2020 09:09:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER VIEW [dbo].[VW_BranchTransferData]
AS
SELECT 
	[Customers_2].[CustID]
	,[Customers_2].[CustName]
	,[Rental].[RentalID] [ContractID]
	,[Rental].[RentQuoteid]
	,[Branch_1].[BranchCode] [TransferFrom]
	,CONCAT(CONVERT(VARCHAR,[Rental].[RentStart],101),' ',[Rental].[RentStartTime]) [RentStart]
	,CONCAT(CONVERT(VARCHAR,[Rental].[RentEnd],101),' ',[Rental].[RentEndTime]) [RentEnd]
	,[Rental].[RentStart] [RentStartDate]
	,[Rental].[RentEnd] [RentEndDate]
	,[Rental].[RentCheckedOutDate] [CheckedOut]
	,[Employee].[EmployeeName] [SalesRep]
	,[Quote].[QuoteID] [RefQuoteID]
	,[Customers_1].[CustName] [RefCustName]
	,[Rental].[RentShippingID]
	,UPPER([RentalStatus].[RentStatusDesc]) [RentStatus]
	,[Employee_1].[EmployeeName] [CheckedInBy]
	,[CheckInTime].[CheckInTime]
	,ISNULL([Quote].[QuoteTotal], 0) Total
	,[Branch].[BranchCode] 
	,[Branch].[BranchID] 
	,[Quote_1].[QuoteID] [RefQuote_1ID]
	,[CheckedIn_By].[CheckedIn] [CheckedIn_By] 
	,[Employee].[EmployeeID]
FROM [dbo].[tblQuote] [Quote_1] (NOLOCK)
INNER JOIN [dbo].[tblRentalStatus] [RentalStatus] (NOLOCK)
RIGHT JOIN [dbo].[tblCustomers] [Customers_2] (NOLOCK)
INNER JOIN [dbo].[tblRental] [Rental](NOLOCK)
	ON [Rental].[CustID] = [Customers_2].[CustID]
INNER JOIN [dbo].[tblEmployee] [Employee] (NOLOCK)
	ON [Employee].[EmployeeID] = [Rental].[RentAccountRep]
    ON [RentalStatus].[autoRentStatusID] = [Rental].[RentStatusID]
INNER JOIN [dbo].[tblBranch] [Branch] WITH(NOLOCK)
	ON [Branch].[BranchID] = [Rental].[OriginatingBranchID]
	ON [Quote_1].[QuoteID] = [Rental].[RentQuoteID]
LEFT JOIN [dbo].[tblCustomers] [Customers_1] (NOLOCK)
LEFT JOIN [dbo].[tblQuote] [Quote] (NOLOCK)
	ON [Quote].[CustID] = [Customers_1].[CustID]
	ON [Rental].[RentReferenceQuoteId] = [Quote].[QuoteID]
LEFT JOIN [dbo].[tblBranch] [Branch_1] (NOLOCK)
	ON [Branch_1].[BranchID] = [Rental].[RentalBranchID]
LEFT JOIN [dbo].[tblEmployee] [Employee_1] (NOLOCK)
	ON [Employee_1].[EmployeeID] = [Quote_1].[QuoteCheckInBy]
LEFT JOIN 
(
	 SELECT 
		SUM(ISNULL((CASE WHEN ([tblCat].[SearchLetter] IN('D','F','L')) THEN '' 
		ELSE [Quantity] * ROUND((ISNULL([CheckInTime],0)) * 60,-1) END),0)) AS [CheckInTime]
		,[tblQuoteSub].[QuoteId]
	FROM [dbo].[tblQuoteSub] (NOLOCK) 
	INNER JOIN [dbo].[SubGroupMaster] (NOLOCK) 
	ON [tblQuoteSub].[nSubGroupID] = [SubGroupMaster].[nSubGroupID]  
	AND ISNULL([tblquotesub].[QuoteKitParentId],0) = 0
	AND NOT [tblQuoteSub].[QuoteHeaderFooterId] > 0
	LEFT JOIN tblCat (NOLOCK) 
		ON tblQuoteSub.CategoryID = tblCat.CatId  
	LEFT JOIN [dbo].[TblCatDescription] (NOLOCK) 
	ON [tblCat].[SearchLetter] = [TblCatDescription].[SearchLetter]  
	GROUP BY [tblQuoteSub].[QuoteId]	
) AS [CheckInTime]
ON [CheckInTime].[QuoteId] = [Rental].[RentQuoteid]
LEFT JOIN 
(
	SELECT STRING_AGG([tblEmployee].[EmployeeName],',') [CheckedIn],
	[QuoteReps].[QuoteID] FROM [dbo].[tblQuoteReps] [QuoteReps](NOLOCK) 
	INNER JOIN [dbo].[tblEmployee] (NOLOCK) 
	ON [QuoteReps].[SalesRepID] = [tblEmployee].[EmployeeID] 	
	WHERE [QuoteReps].[WhatType]='CheckedInBy'
	GROUP BY [QuoteReps].[QuoteID]
) AS [CheckedIn_By]
ON [CheckedIn_By].[QuoteID] = [Rental].[RentQuoteid]
GO

/****** Object:  View [dbo].[VW_EquipmentDeliveryData]    Script Date: 20-07-2020 09:09:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [dbo].[VW_EquipmentDeliveryData]
AS
SELECT 	 
	[Rental].[RentBillable]
	,[Customers].[CustID]
	,[Customers].[CustName]
	,[Rental].[RentalID] [ContractID]
	,CONCAT(CONVERT(DATE,[Rental].[RentStart]),' ',[Rental].[RentStartTime]) [RentStart]
	,CONCAT(CONVERT(DATE,[Rental].[RentEnd]),' ',[Rental].[RentEndTime]) [RentEnd]
	,[Rental].[RentStart] [RentStartDate]
	,[Rental].[RentEnd] [RentEndDate]
	,[Employee].[EmployeeName] [SalesRep]
	,[Employee_1].[EmployeeName] [ShippedBy]
	,[Rental].[RentShippingID]
	,[Rental].[RentShowname] [ShowName]
	,[Rental].[RentShipAddr2] [RentAddress2]
	,[Rental].[RentShipAddr]
	,[Rental].[RentShipCity]
	,[Rental].[RentShipState] [RentState]
	,UPPER([RentalStatus].[RentStatusDesc]) [RentStatus]
	,[Rental].[Variances] [Variances]
	,[Employee_2].[EmployeeName] [ApproverName]
	,ISNULL(CONCAT(CONVERT(VARCHAR(10),[Rental].[VarApprovedTime], 101),RIGHT(CONVERT(VARCHAR(30),[Rental].[VarApprovedTime], 100), 8)), '')
	 [ApprovedTime]
	,[Quote].[QuoteTotal] [Total]
	,[Branch].[BranchCode]
	,[Branch].[BranchID]
	,IIF([Quote].[QuoteTotal] <> [QuoteTotals].[QuoteTotal], 'ALERT','CHECK') [CheckFileImage]
	,CONCAT([Rental].[RentShowname],CHAR(13),[Rental].[RentShipAddr],CHAR(13),[Rental].[RentShipAddr2])[RentStateTooltip] 
	,[Employee].[EmployeeID]
FROM [dbo].[tblQuote] [Quote] WITH(NOLOCK)
INNER JOIN [dbo].[tblCustomers] [Customers] WITH(NOLOCK)
INNER JOIN [dbo].[tblRental] [Rental] WITH(NOLOCK)
	ON [Rental].[CustID] = [Customers].[CustID]  
INNER JOIN [dbo].[tblEmployee] [Employee] WITH(NOLOCK)
	ON [Employee].[EmployeeID] = [Rental].[RentAccountRep]
	ON [Quote].[QuoteID] = [Rental].[RentQuoteID] 
LEFT JOIN [dbo].[tblBranch] [Branch] WITH(NOLOCK)
	ON [Branch].[BranchID] = [Rental].[OriginatingBranchID]
LEFT JOIN [dbo].[tblRentalStatus] [RentalStatus] WITH(NOLOCK)          
         ON [RentalStatus].[autoRentStatusID]  = [Rental].[RentStatusID]
LEFT JOIN [dbo].[tblEmployee] [Employee_1] WITH (NOLOCK) 
         ON [Employee_1].[EmployeeID] = [Rental].[RentShippedBy]
LEFT JOIN [dbo].[tblEmployee] [Employee_2] WITH (NOLOCK) 
         ON [Employee_2].[EmployeeID] = [Rental].[VarApprovedBy]
LEFT JOIN (
	SELECT [QuoteTotal],[QuoteRentalID]
	FROM [dbo].[tblQuote](NOLOCK)
) [QuoteTotals]
ON [QuoteTotals].[QuoteRentalID] = [Rental].[RentalID]
GO

/****** Object:  View [dbo].[VW_EquipmentReturnsData]    Script Date: 20-07-2020 09:09:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [dbo].[VW_EquipmentReturnsData]
AS

 SELECT 
	[Rental].[RentBillable]
	,[Customers].[CustID]
	,[Customers].[CustName]
	,[Rental].[RentalID] [ContractID]
	,CONCAT(CONVERT(DATE,[Rental].[RentStart]),' ',[Rental].[RentStartTime]) [RentStart]
	,CONCAT(CONVERT(DATE,[Rental].[RentEnd]),' ',[Rental].[RentEndTime]) [RentEnd]
	,[Rental].[RentStart] [RentStartDate]
	,[Rental].[RentEnd] [RentEndDate]
	,[Employee].[EmployeeName] [SalesRep]
	,[Employee_1].[EmployeeName] [ReceivedBy]
	,[Rental].[RentShippingID]
	,[Rental].[RentShowname] [ShowName]
	,[Rental].[RentShipAddr2] [RentAddress2]
	,[Rental].[RentShipAddr] 
	,[Rental].[RentShipCity]
	,[Rental].[RentShipState] [RentState]
	,UPPER([RentalStatus].[RentStatusDesc]) [RentStatus]
	,[Employee_2].[EmployeeName] [CheckedInBy]
	,[CheckInTime].[CheckInTime]
	,[QCTime].[QCTime]
	,[Quote].[QuoteID]
	,[Quote].[quotetotal] [Total]
	,[Employee].[EmployeeID]
	,[Branch].[BranchID]
	,[Branch].[BranchCode]
	--,CASE WHEN   
	--	(  tblQuote.quotetotal  <> Total THEN 'alert' else 'CHECK' end
	--	) AS [CheckFileImage] 
,IIF([Quote].[QuoteTotal] <> [QuoteTotals].[QuoteTotal], 'ALERT','CHECK') [CheckFileImage]
,CONCAT([Rental].[RentShowname],CHAR(13),[Rental].[RentShipAddr],CHAR(13),[Rental].[RentShipAddr2])[RentStateTooltip] 
FROM [dbo].[tblQuote] [Quote] WITH(NOLOCK)
INNER JOIN [dbo].[tblCustomers] [Customers] WITH(NOLOCK)
INNER JOIN [dbo].[tblRental] [Rental] WITH(NOLOCK)
	ON [Rental].[CustID] = [Customers].[CustID]  
INNER JOIN [dbo].[tblEmployee] [Employee] WITH(NOLOCK)
	ON [Employee].[EmployeeID] = [Rental].[RentAccountRep]
	ON [Quote].[QuoteID] = [Rental].[RentQuoteID] 
LEFT JOIN [dbo].[tblBranch] [Branch] WITH(NOLOCK)
	ON [Branch].[BranchID] = [Rental].[OriginatingBranchID]
LEFT JOIN [dbo].[tblRentalStatus] [RentalStatus] WITH(NOLOCK)          
         ON [RentalStatus].[autoRentStatusID]  = [Rental].[RentStatusID]
LEFT JOIN [dbo].[tblEmployee] [Employee_1] WITH (NOLOCK) 
         ON [Employee_1].[EmployeeID] = [Rental].[RentShippedBy]
LEFT JOIN [dbo].[tblEmployee] [Employee_2] WITH (NOLOCK) 
         ON [Employee_2].[EmployeeID] = [Rental].[VarApprovedBy]
LEFT JOIN 
(
	 SELECT 
		SUM(ISNULL((CASE WHEN ([tblCat].[SearchLetter] IN('D','F','L')) THEN '' 
		ELSE [Quantity] * ROUND((ISNULL([CheckInTime],0)) * 60,-1) END),0)) AS [CheckInTime]
		,[tblQuoteSub].[QuoteId]
	FROM [dbo].[tblQuoteSub] (NOLOCK) 
	INNER JOIN [dbo].[SubGroupMaster] (NOLOCK) 
	ON [tblQuoteSub].[nSubGroupID] = [SubGroupMaster].[nSubGroupID]  
	AND ISNULL([tblquotesub].[QuoteKitParentId],0) = 0
	AND NOT [tblQuoteSub].[QuoteHeaderFooterId] > 0
	LEFT JOIN tblCat (NOLOCK) 
		ON tblQuoteSub.CategoryID = tblCat.CatId  
	LEFT JOIN [dbo].[TblCatDescription] (NOLOCK) 
	ON [tblCat].[SearchLetter] = [TblCatDescription].[SearchLetter]  
	GROUP BY [tblQuoteSub].[QuoteId]	
) AS [CheckInTime]
ON [CheckInTime].[QuoteId] = [Rental].[RentQuoteid]
LEFT JOIN(
	SELECT 
		SUM(ISNULL((CASE WHEN ([tblCat].[SearchLetter] IN('D','F','L')) THEN ''
		ELSE [Quantity] * ROUND((ISNULL([QCTime],0)) * 60,-1) END),0)) AS [QCTime]
		,[tblQuoteSub].[QuoteId]
		FROM [dbo].[tblQuoteSub] WITH (NOLOCK) 
		INNER JOIN [dbo].[SubGroupMaster] WITH (NOLOCK) 
		ON [tblQuoteSub].[nSubGroupID] = [SubGroupMaster].[nSubGroupID]  
		LEFT JOIN tblCat WITH (NOLOCK) 
		ON tblQuoteSub.CategoryID = tblCat.CatId  
		LEFT JOIN [dbo].[TblCatDescription] WITH (NOLOCK)
		ON [tblCat].[SearchLetter] = [TblCatDescription].[SearchLetter]  
		GROUP BY [tblQuoteSub].[QuoteId]  
) AS [QCTime]
ON [QCTime].[QuoteId] = [Rental].[RentQuoteid]
LEFT JOIN (
	SELECT [QuoteTotal],[QuoteRentalID]
	FROM [dbo].[tblQuote](NOLOCK)
) [QuoteTotals]
ON [QuoteTotals].[QuoteRentalID] = [Rental].[RentalID]
GO

/****** Object:  View [dbo].[VW_OrderPullData]    Script Date: 20-07-2020 09:09:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER VIEW [dbo].[VW_OrderPullData]
AS
SELECT	 [Customers].[CustName]
		,[Customers].[CustID]
		,[Quote].[QuoteEnteredDate]
		,[Quote].[QuoteLastModified]
		,[Quote].[QConfirmationDate]
		,ISNULL([Quote].[QuoteRelease],0) [Rel_Short]
		,ISNULL([Quote].[ShortageQty],0) [ShortageQty]
		,[Quote].[AvailabilityLastViewedBy]
		,[Quote].[AvailabilityLastViewedOn]
		,[Quote].[QuoteID]
		,CONCAT(CONVERT(DATE,[Quote].[DeliveryDate]),' ',[Quote].[DeliveryTime]) [DeliveryDate]
		,CONCAT(CONVERT(DATE,[Quote].[ReturnDate]),' ',[Quote].[ReturnTime]) [ReturnDate]
		,[Employee].[EmployeeName] [SalesRep]
		,[Employee_2].[EmployeeName] [ReviewedBy]
		,CASE WHEN [Employee_2].[EmployeeName] IS NULL 
		 THEN CONCAT([Employee_4].[EmployeeName],' ',CONVERT(NVARCHAR,[Quote].[ReviewedDateTime], 22)) 
		 ELSE '' END Reviewed_By
		,[Employee_1].[EmployeeName] [PulledBy]
		,[Employee_3].[EmployeeName] [ShippedBy]
		,[Quote].[ShippingID]
		,CONCAT([Quote].[ShipCity],', ',[Quote].[ShipState]) [ShipCityState]
		,[QuoteTypes].[QuoteType] [ClientInterest]
		--,ISNULL(dbo.GetCheckOutTimeForQuote_Customize([Quote].[QuoteID], 'Orders To Pull'), '0:00')  CheckOutTime		
		,[CheckOutTime].[CheckOutTime]
		,[Quote].[InterestType]
		,[Branch].[BranchCode]
		,[Branch].[BranchID]
		,SUM(ISNULL([QuoteSub].[Period] * 
					[QuoteSub].[SuggestedRate] * 
					[QuoteSub].[billquantity] - 
					[QuoteSub].[Period] * 
					[QuoteSub].[SuggestedRate] * 
					[QuoteSub].[billquantity] * 
					[QuoteSub].[DiscountPercent] / 100,0)) [Total]
		,[QuoteTypes].[QuoteTypeNo]
		,[Employee_4].[EmployeeName] [LastReviewedBy]
		,[Quote].[ReviewedDateTime]
		,[Employee].[EmployeeID]
		,CONCAT([Quote].[QuoteShowname],',',[Quote].[ShipAddr],',',[Quote].[ShipAddr2]) [Address]
		,CONCAT([Quote].[isShortage],',',[Quote].[InterestType]) [RelCondition]
		,'' Activity 
		,'' ActivityToolTip
		,'' PRODUCTIONFLAG
FROM
[dbo].[tblCustomers] [Customers] WITH(NOLOCK)
INNER JOIN [dbo].[tblQuote] [Quote] WITH(NOLOCK)
	ON [Quote].[CustID] = [Customers].[CustID]	AND
		[Quote].[InterestType] <> 1 AND
		[Quote].[QuoteRentalID] = 0
INNER JOIN [dbo].[tblEmployee] [Employee] WITH(NOLOCK)
	ON [Employee].[EmployeeID] = [Quote].[SalesRep]
INNER JOIN [dbo].[tblBranch] [Branch] WITH(NOLOCK)
	ON [Branch].[BranchID] = [Quote].[QuoteOriginatingBranchId]
LEFT JOIN [dbo].[tblEmployee] [Employee_4] WITH(NOLOCK)
	ON [Employee_4].[EmployeeID] = [Quote].[QLastReviewedBy]
LEFT JOIN [dbo].[tblEmployee] [Employee_3] WITH(NOLOCK)
	ON [Employee_3].[EmployeeID] = [Quote].[ShippedBy]
LEFT JOIN [dbo].[tblEmployee] [Employee_2] WITH(NOLOCK)
	ON [Employee_2].[EmployeeID] = [Quote].[ReviewedBy]
LEFT JOIN [dbo].[tblQuoteTypes] [QuoteTypes] WITH(NOLOCK)
	ON [QuoteTypes].[QuoteTypeNo] = [Quote].[InterestType]
LEFT JOIN [dbo].[tblQuoteSub] [QuoteSub] WITH(NOLOCK)
	ON [QuoteSub].[QuoteId] = [Quote].[QuoteID]
LEFT JOIN [dbo].[tblEmployee] [Employee_1] WITH(NOLOCK)
	ON [Employee_1].[EmployeeID] = [Quote].[QuotePulledBy]
LEFT JOIN (
	SELECT 
		CONVERT(FLOAT,SUM(ISNULL((CASE WHEN ([tblCat].[SearchLetter] IN('D','F','L')) THEN ''
		ELSE [Quantity] * ROUND((ISNULL([CheckOutTime],0)) * 60,-1) END),0))) AS [CheckOutTime]
		,[tblQuoteSub].[QuoteId]
	FROM [dbo].[tblQuoteSub] WITH (NOLOCK) 
	INNER JOIN [dbo].[SubGroupMaster] WITH (NOLOCK)
	ON [tblQuoteSub].[nSubGroupID] = [SubGroupMaster].[nSubGroupID]  
	AND ISNULL([tblQuoteSub].[QuoteKitParentId],0) = 0
	AND NOT [tblQuoteSub].[QuoteHeaderFooterId] > 0
	LEFT OUTER JOIN [dbo].[tblCat] WITH (NOLOCK)
	ON [tblQuoteSub].[CategoryID] = [tblCat].[CatId]
	LEFT OUTER JOIN [dbo].[TblCatDescription] WITH (NOLOCK)
	ON [tblCat].[SearchLetter] = [TblCatDescription].[SearchLetter]
	GROUP BY [tblQuoteSub].[QuoteId] 
) AS [CheckOutTime]
ON [CheckOutTime].[QuoteId] = [Quote].[QuoteID]

GROUP BY
		 [Customers].[CustName]
		,[Customers].[CustID]
		,[Quote].[QuoteEnteredDate]
		,[Quote].[QuoteLastModified]
		,[Quote].[QConfirmationDate]
		,ISNULL([Quote].[QuoteRelease],0)
		,ISNULL([Quote].[ShortageQty],0)
		,[Quote].[AvailabilityLastViewedBy]
		,[Quote].[AvailabilityLastViewedOn]
		,[Quote].[QuoteID]
		,CONCAT(CONVERT(DATE,[Quote].[DeliveryDate]),' ',[Quote].[DeliveryTime])
		,CONCAT(CONVERT(DATE,[Quote].[ReturnDate]),' ',[Quote].[ReturnTime])
		,[Employee].[EmployeeName]
		,[Employee_2].[EmployeeName]
		,CONCAT([Employee_4].[EmployeeName],' ',CONVERT(NVARCHAR,[Quote].[ReviewedDateTime], 22)) 
		,[Employee_1].[EmployeeName]
		,[Employee_3].[EmployeeName]
		,[Quote].[ShippingID]
		,CONCAT([Quote].[ShipCity],', ',[Quote].[ShipState])
		,[QuoteTypes].[QuoteType]
		,[CheckOutTime].[CheckOutTime]
		,[Quote].[InterestType]
		,[Branch].[BranchCode]
		,[Branch].[BranchID]
		,[QuoteTypes].[QuoteTypeNo]
		,[Employee_4].[EmployeeName] 
		,[Quote].[ReviewedDateTime]
		,[Employee].[EmployeeID]
		,CONCAT([Quote].[QuoteShowname],',',[Quote].[ShipAddr],',',[Quote].[ShipAddr2])
		,CONCAT([Quote].[isShortage],',',[Quote].[InterestType])
GO

/****** Object:  View [dbo].[VW_PODeliveryData]    Script Date: 20-07-2020 09:09:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW  [dbo].[VW_PODeliveryData]
AS
SELECT 
	 [Branch].[BranchID]
	,[Branch].[BranchName]
	,[Branch].[BranchCode]
	,[Customers].[CustID]
	,[Customers].[CustName] [Vendor]
	,[Purchase].[PurchaseID]
	,CONCAT(CONVERT(VARCHAR,[Purchase].[PurDeliveryDate],101),' ',[Purchase].[PurDeliveryTime]) [DeliveryDate]
	,CONCAT(CONVERT(VARCHAR,[Purchase].[PurReturnDate], 101),' ',[Purchase].[PurReturnTime]) [ReturnDate]
	,[Purchase].[PurDeliveryDate]
	,[Purchase].[PurReturnDate]
	,[Employee].[EmployeeName] [IssuedBy]
	,[Employee_Shipping].[EmployeeName] [PickupBy]
	,CASE WHEN [Purchase].[PurQuoteId] IS NULL AND [CustomersQuote].[CustName] IS NULL
			THEN [CustomersQuote].[CustName] 
			ELSE CONCAT([Purchase].[PurQuoteId],'-',[CustomersQuote].[CustName])
	 END [Client]
	,[Purchase].[PurShippingId] [ShippingID]
	,[Purchase].[PurShipAdd] [ShipAddr]
	,[Purchase].[PurShipCity] [ShipCity]
	,[Purchase].[PurShowName] [ShowName]
	,[Purchase].[PurShipContact]
	,[Purchase].[PurShipAdd2]
	,[Purchase].[PurShipState] [State]
	,CASE WHEN ISNULL([Purchase].[PurApprovedBy],0) = 0 
		THEN CONCAT([PurchaseStatus].[PurStatusDesc],'/NOT APP') 
		ELSE CONCAT([PurchaseStatus].[PurStatusDesc],'/APPROVED')
		END [POStatus]
	,[Purchase].[PurApprovedBy]
	,CASE WHEN ([Purchase].[PurTax] * [Purchase].[PurTaxRate] / 100) IS NULL THEN
			ISNULL([Purchase].[PurDiscTotal],0) 
		ELSE
			(ISNULL(([Purchase].[PurTax] * [Purchase].[PurTaxRate] / 100), 0) + ISNULL([Purchase].[PurDiscTotal], 0))
		END Total
	,[CustomersQuote].[CustName] [QuoteCustName]
	,CONCAT([Purchase].[PurShowName],CHAR(13),
			[Purchase].[PurShipContact],CHAR(13),
			[Purchase].[PurShipAdd],CHAR(13),
			[Purchase].[PurShipAdd2],CHAR(13)
			)[StateTooltip]
	,[Employee].[EmployeeID]
FROM [dbo].[tblBranch] [Branch](NOLOCK)
RIGHT JOIN [dbo].[tblEmployee] [Employee_Receiving] (NOLOCK)
RIGHT JOIN [dbo].[tblEmployee] [Employee] (NOLOCK)
INNER JOIN [dbo].[tblPurchase] [Purchase] (NOLOCK)
	ON [Purchase].[PurSalesRep] = [Employee].[EmployeeID]
	ON [Purchase].[PurReceivedBy] = [Employee_Receiving].[EmployeeID]
LEFT JOIN [dbo].[tblEmployee] [Employee_Shipping] (NOLOCK)
	ON [Employee_Shipping].[EmployeeID] = [Purchase].[PurShippedBy]
LEFT JOIN [dbo].[tblPurchaseStatus] [PurchaseStatus] (NOLOCK)
	ON [PurchaseStatus].[PurStatusAutoID] = [Purchase].[PurStatus]
	ON [Branch].[BranchID] = [Purchase].[PurBranchId]
LEFT JOIN [dbo].[tblCustomers] [Customers] (NOLOCK)
	ON [Customers].[CustID] = [Purchase].[CustID]
LEFT JOIN [dbo].[tblPurchaseSub] [PurchaseSub] (NOLOCK)
	ON [PurchaseSub].[PurchaseID] = [Purchase].[PurchaseID]
LEFT JOIN [dbo].[tblQuote] [Quote] (NOLOCK)
	ON [Quote].[QuoteID] = [Purchase].[PurQuoteId]
LEFT JOIN [dbo].[tblCustomers] [CustomersQuote] (NOLOCK)
	ON [CustomersQuote].[CustID] = [Quote].[CustID]
GROUP BY
	[Branch].[BranchID]
	,[Branch].[BranchName]
	,[Branch].[BranchCode]
	,[Customers].[CustID]
	,[Customers].[CustName] 
	,[Purchase].[PurchaseID]
	,CONCAT(CONVERT(VARCHAR,[Purchase].[PurDeliveryDate],101),' ',[Purchase].[PurDeliveryTime]) 
	,CONCAT(CONVERT(VARCHAR,[Purchase].[PurReturnDate], 101),' ',[Purchase].[PurReturnTime]) 
	,[Purchase].[PurDeliveryDate]
	,[Purchase].[PurReturnDate]
	,[Employee].[EmployeeName] 
	,[Employee_Shipping].[EmployeeName] 
	,[Purchase].[PurQuoteId] 
	,[Purchase].[PurShippingId] 
	,[Purchase].[PurShipAdd] 
	,[Purchase].[PurShipCity] 
	,[Purchase].[PurShowName] 
	,[Purchase].[PurShipContact]
	,[Purchase].[PurShipAdd2]
	,[Purchase].[PurShipState] 
	,[PurchaseStatus].[PurStatusDesc] 
	,[Purchase].[PurApprovedBy]
	,CASE WHEN ([Purchase].[PurTax] * [Purchase].[PurTaxRate] / 100) IS NULL THEN
			ISNULL([Purchase].[PurDiscTotal],0) 
		ELSE
			(ISNULL(([Purchase].[PurTax] * [Purchase].[PurTaxRate] / 100), 0) + ISNULL([Purchase].[PurDiscTotal], 0))
	 END
	,[CustomersQuote].[CustName]
	,[Employee].[EmployeeID]
GO


USE [alliant_mvc]
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_BranchTransferData_View_Search]    Script Date: 20-07-2020 09:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[spr_tb_VW_BranchTransferData_View_Search]

@ResultCount INT OUTPUT,
@CustID_Values nvarchar(max) = NULL,
@CustID_Min int = NULL,
@CustID_Max int = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@ContractID_Values nvarchar(max) = NULL,
@ContractID_Min int = NULL,
@ContractID_Max int = NULL,
@RentQuoteid_Values nvarchar(max) = NULL,
@RentQuoteid_Min int = NULL,
@RentQuoteid_Max int = NULL,
@TransferFrom nvarchar(50) = NULL,
@TransferFrom_Values nvarchar(max) = NULL,
@RentStart nvarchar(56) = NULL,
@RentStart_Values nvarchar(max) = NULL,
@RentEnd nvarchar(56) = NULL,
@RentEnd_Values nvarchar(max) = NULL,
@RentStartDate_Values nvarchar(max) = NULL,
@RentStartDate_Min datetime = NULL,
@RentStartDate_Max datetime = NULL,
@RentEndDate_Values nvarchar(max) = NULL,
@RentEndDate_Min datetime = NULL,
@RentEndDate_Max datetime = NULL,
@CheckedOut_Values nvarchar(max) = NULL,
@CheckedOut_Min datetime = NULL,
@CheckedOut_Max datetime = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@RefQuoteID_Values nvarchar(max) = NULL,
@RefQuoteID_Min int = NULL,
@RefQuoteID_Max int = NULL,
@RefCustName nvarchar(255) = NULL,
@RefCustName_Values nvarchar(max) = NULL,
@RentShippingID nvarchar(50) = NULL,
@RentShippingID_Values nvarchar(max) = NULL,
@RentStatus nvarchar(35) = NULL,
@RentStatus_Values nvarchar(max) = NULL,
@CheckedInBy nvarchar(50) = NULL,
@CheckedInBy_Values nvarchar(max) = NULL,
@CheckInTime_Values nvarchar(max) = NULL,
@CheckInTime_Min float = NULL,
@CheckInTime_Max float = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@BranchCode nvarchar(50) = NULL,
@BranchCode_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@RefQuote_1ID_Values nvarchar(max) = NULL,
@RefQuote_1ID_Min int = NULL,
@RefQuote_1ID_Max int = NULL,
@CheckedIn_By nvarchar(4000) = NULL,
@CheckedIn_By_Values nvarchar(max) = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
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
SET @ResultCount = (SELECT COUNT(*) FROM VW_BranchTransferData (NOLOCK)
 WHERE (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentQuoteid_Values IS NULL OR  (@RentQuoteid_Values = '###NULL###' AND RentQuoteid IS NULL ) OR (@RentQuoteid_Values <> '###NULL###' AND RentQuoteid IN(SELECT Item FROM [dbo].CustomeSplit(@RentQuoteid_Values,','))))
 AND (@RentQuoteid_Min IS NULL OR RentQuoteid >=  @RentQuoteid_Min)
 AND (@RentQuoteid_Max IS NULL OR RentQuoteid <=  @RentQuoteid_Max)
 AND (@TransferFrom IS NULL OR (@TransferFrom = '###NULL###' AND TransferFrom IS NULL ) OR (@TransferFrom <> '###NULL###' AND TransferFrom LIKE '%'+@TransferFrom+'%'))
 AND (@TransferFrom_Values IS NULL OR (@TransferFrom_Values = '###NULL###' AND TransferFrom IS NULL ) OR (@TransferFrom_Values <> '###NULL###' AND TransferFrom IN(SELECT Item FROM [dbo].CustomeSplit(@TransferFrom_Values,','))))
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@CheckedOut_Values IS NULL OR  (@CheckedOut_Values = '###NULL###' AND CheckedOut IS NULL ) OR (@CheckedOut_Values <> '###NULL###' AND CheckedOut IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedOut_Values,','))))
 AND (@CheckedOut_Min IS NULL OR CheckedOut >=  @CheckedOut_Min)
 AND (@CheckedOut_Max IS NULL OR CheckedOut <=  @CheckedOut_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@RefQuoteID_Values IS NULL OR  (@RefQuoteID_Values = '###NULL###' AND RefQuoteID IS NULL ) OR (@RefQuoteID_Values <> '###NULL###' AND RefQuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@RefQuoteID_Values,','))))
 AND (@RefQuoteID_Min IS NULL OR RefQuoteID >=  @RefQuoteID_Min)
 AND (@RefQuoteID_Max IS NULL OR RefQuoteID <=  @RefQuoteID_Max)
 AND (@RefCustName IS NULL OR (@RefCustName = '###NULL###' AND RefCustName IS NULL ) OR (@RefCustName <> '###NULL###' AND RefCustName LIKE '%'+@RefCustName+'%'))
 AND (@RefCustName_Values IS NULL OR (@RefCustName_Values = '###NULL###' AND RefCustName IS NULL ) OR (@RefCustName_Values <> '###NULL###' AND RefCustName IN(SELECT Item FROM [dbo].CustomeSplit(@RefCustName_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@CheckedInBy IS NULL OR (@CheckedInBy = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy <> '###NULL###' AND CheckedInBy LIKE '%'+@CheckedInBy+'%'))
 AND (@CheckedInBy_Values IS NULL OR (@CheckedInBy_Values = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy_Values <> '###NULL###' AND CheckedInBy IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedInBy_Values,','))))
 AND (@CheckInTime_Values IS NULL OR  (@CheckInTime_Values = '###NULL###' AND CheckInTime IS NULL ) OR (@CheckInTime_Values <> '###NULL###' AND CheckInTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckInTime_Values,','))))
 AND (@CheckInTime_Min IS NULL OR CheckInTime >=  @CheckInTime_Min)
 AND (@CheckInTime_Max IS NULL OR CheckInTime <=  @CheckInTime_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@RefQuote_1ID_Values IS NULL OR  (@RefQuote_1ID_Values = '###NULL###' AND RefQuote_1ID IS NULL ) OR (@RefQuote_1ID_Values <> '###NULL###' AND RefQuote_1ID IN(SELECT Item FROM [dbo].CustomeSplit(@RefQuote_1ID_Values,','))))
 AND (@RefQuote_1ID_Min IS NULL OR RefQuote_1ID >=  @RefQuote_1ID_Min)
 AND (@RefQuote_1ID_Max IS NULL OR RefQuote_1ID <=  @RefQuote_1ID_Max)
 AND (@CheckedIn_By IS NULL OR (@CheckedIn_By = '###NULL###' AND CheckedIn_By IS NULL ) OR (@CheckedIn_By <> '###NULL###' AND CheckedIn_By LIKE '%'+@CheckedIn_By+'%'))
 AND (@CheckedIn_By_Values IS NULL OR (@CheckedIn_By_Values = '###NULL###' AND CheckedIn_By IS NULL ) OR (@CheckedIn_By_Values <> '###NULL###' AND CheckedIn_By IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedIn_By_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT CustID,CustName,ContractID,RentQuoteid,TransferFrom,RentStart,RentEnd,RentStartDate,RentEndDate,CheckedOut,SalesRep,RefQuoteID,RefCustName,RentShippingID,RentStatus,CheckedInBy,CheckInTime,Total,BranchCode,BranchID,RefQuote_1ID,CheckedIn_By,EmployeeID FROM  VW_BranchTransferData (NOLOCK)

 WHERE (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentQuoteid_Values IS NULL OR  (@RentQuoteid_Values = '###NULL###' AND RentQuoteid IS NULL ) OR (@RentQuoteid_Values <> '###NULL###' AND RentQuoteid IN(SELECT Item FROM [dbo].CustomeSplit(@RentQuoteid_Values,','))))
 AND (@RentQuoteid_Min IS NULL OR RentQuoteid >=  @RentQuoteid_Min)
 AND (@RentQuoteid_Max IS NULL OR RentQuoteid <=  @RentQuoteid_Max)
 AND (@TransferFrom IS NULL OR (@TransferFrom = '###NULL###' AND TransferFrom IS NULL ) OR (@TransferFrom <> '###NULL###' AND TransferFrom LIKE '%'+@TransferFrom+'%'))
 AND (@TransferFrom_Values IS NULL OR (@TransferFrom_Values = '###NULL###' AND TransferFrom IS NULL ) OR (@TransferFrom_Values <> '###NULL###' AND TransferFrom IN(SELECT Item FROM [dbo].CustomeSplit(@TransferFrom_Values,','))))
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@CheckedOut_Values IS NULL OR  (@CheckedOut_Values = '###NULL###' AND CheckedOut IS NULL ) OR (@CheckedOut_Values <> '###NULL###' AND CheckedOut IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedOut_Values,','))))
 AND (@CheckedOut_Min IS NULL OR CheckedOut >=  @CheckedOut_Min)
 AND (@CheckedOut_Max IS NULL OR CheckedOut <=  @CheckedOut_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@RefQuoteID_Values IS NULL OR  (@RefQuoteID_Values = '###NULL###' AND RefQuoteID IS NULL ) OR (@RefQuoteID_Values <> '###NULL###' AND RefQuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@RefQuoteID_Values,','))))
 AND (@RefQuoteID_Min IS NULL OR RefQuoteID >=  @RefQuoteID_Min)
 AND (@RefQuoteID_Max IS NULL OR RefQuoteID <=  @RefQuoteID_Max)
 AND (@RefCustName IS NULL OR (@RefCustName = '###NULL###' AND RefCustName IS NULL ) OR (@RefCustName <> '###NULL###' AND RefCustName LIKE '%'+@RefCustName+'%'))
 AND (@RefCustName_Values IS NULL OR (@RefCustName_Values = '###NULL###' AND RefCustName IS NULL ) OR (@RefCustName_Values <> '###NULL###' AND RefCustName IN(SELECT Item FROM [dbo].CustomeSplit(@RefCustName_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@CheckedInBy IS NULL OR (@CheckedInBy = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy <> '###NULL###' AND CheckedInBy LIKE '%'+@CheckedInBy+'%'))
 AND (@CheckedInBy_Values IS NULL OR (@CheckedInBy_Values = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy_Values <> '###NULL###' AND CheckedInBy IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedInBy_Values,','))))
 AND (@CheckInTime_Values IS NULL OR  (@CheckInTime_Values = '###NULL###' AND CheckInTime IS NULL ) OR (@CheckInTime_Values <> '###NULL###' AND CheckInTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckInTime_Values,','))))
 AND (@CheckInTime_Min IS NULL OR CheckInTime >=  @CheckInTime_Min)
 AND (@CheckInTime_Max IS NULL OR CheckInTime <=  @CheckInTime_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@RefQuote_1ID_Values IS NULL OR  (@RefQuote_1ID_Values = '###NULL###' AND RefQuote_1ID IS NULL ) OR (@RefQuote_1ID_Values <> '###NULL###' AND RefQuote_1ID IN(SELECT Item FROM [dbo].CustomeSplit(@RefQuote_1ID_Values,','))))
 AND (@RefQuote_1ID_Min IS NULL OR RefQuote_1ID >=  @RefQuote_1ID_Min)
 AND (@RefQuote_1ID_Max IS NULL OR RefQuote_1ID <=  @RefQuote_1ID_Max)
 AND (@CheckedIn_By IS NULL OR (@CheckedIn_By = '###NULL###' AND CheckedIn_By IS NULL ) OR (@CheckedIn_By <> '###NULL###' AND CheckedIn_By LIKE '%'+@CheckedIn_By+'%'))
 AND (@CheckedIn_By_Values IS NULL OR (@CheckedIn_By_Values = '###NULL###' AND CheckedIn_By IS NULL ) OR (@CheckedIn_By_Values <> '###NULL###' AND CheckedIn_By IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedIn_By_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 
END
ELSE
BEGIN
SELECT CustID,CustName,ContractID,RentQuoteid,TransferFrom,RentStart,RentEnd,RentStartDate,RentEndDate,CheckedOut,SalesRep,RefQuoteID,RefCustName,RentShippingID,RentStatus,CheckedInBy,CheckInTime,Total,BranchCode,BranchID,RefQuote_1ID,CheckedIn_By,EmployeeID FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_BranchTransferData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.CustID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN VW_BranchTransferData.CustID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN VW_BranchTransferData.CustID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.CustName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN VW_BranchTransferData.CustName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN VW_BranchTransferData.CustName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.ContractID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=1 THEN VW_BranchTransferData.ContractID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=0 THEN VW_BranchTransferData.ContractID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentQuoteid' OR @Sort_Column='RentQuoteid') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RentQuoteid IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentQuoteid' OR @Sort_Column='RentQuoteid') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RentQuoteid ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentQuoteid' OR @Sort_Column='RentQuoteid') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RentQuoteid ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.TransferFrom' OR @Sort_Column='TransferFrom') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.TransferFrom IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.TransferFrom' OR @Sort_Column='TransferFrom') AND @Sort_Ascending=1 THEN VW_BranchTransferData.TransferFrom ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.TransferFrom' OR @Sort_Column='TransferFrom') AND @Sort_Ascending=0 THEN VW_BranchTransferData.TransferFrom ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RentStart IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RentStart ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RentStart ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RentEnd IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RentEnd ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RentEnd ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RentStartDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RentStartDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RentStartDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RentEndDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RentEndDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RentEndDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedOut' OR @Sort_Column='CheckedOut') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.CheckedOut IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedOut' OR @Sort_Column='CheckedOut') AND @Sort_Ascending=1 THEN VW_BranchTransferData.CheckedOut ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedOut' OR @Sort_Column='CheckedOut') AND @Sort_Ascending=0 THEN VW_BranchTransferData.CheckedOut ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.SalesRep IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN VW_BranchTransferData.SalesRep ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN VW_BranchTransferData.SalesRep ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefQuoteID' OR @Sort_Column='RefQuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RefQuoteID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefQuoteID' OR @Sort_Column='RefQuoteID') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RefQuoteID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefQuoteID' OR @Sort_Column='RefQuoteID') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RefQuoteID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefCustName' OR @Sort_Column='RefCustName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RefCustName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefCustName' OR @Sort_Column='RefCustName') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RefCustName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefCustName' OR @Sort_Column='RefCustName') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RefCustName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RentShippingID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RentShippingID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RentShippingID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RentStatus IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RentStatus ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RentStatus ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedInBy' OR @Sort_Column='CheckedInBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.CheckedInBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedInBy' OR @Sort_Column='CheckedInBy') AND @Sort_Ascending=1 THEN VW_BranchTransferData.CheckedInBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedInBy' OR @Sort_Column='CheckedInBy') AND @Sort_Ascending=0 THEN VW_BranchTransferData.CheckedInBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckInTime' OR @Sort_Column='CheckInTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.CheckInTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckInTime' OR @Sort_Column='CheckInTime') AND @Sort_Ascending=1 THEN VW_BranchTransferData.CheckInTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckInTime' OR @Sort_Column='CheckInTime') AND @Sort_Ascending=0 THEN VW_BranchTransferData.CheckInTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.Total IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN VW_BranchTransferData.Total ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN VW_BranchTransferData.Total ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.BranchCode IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN VW_BranchTransferData.BranchCode ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=0 THEN VW_BranchTransferData.BranchCode ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.BranchID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN VW_BranchTransferData.BranchID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN VW_BranchTransferData.BranchID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefQuote_1ID' OR @Sort_Column='RefQuote_1ID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.RefQuote_1ID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefQuote_1ID' OR @Sort_Column='RefQuote_1ID') AND @Sort_Ascending=1 THEN VW_BranchTransferData.RefQuote_1ID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.RefQuote_1ID' OR @Sort_Column='RefQuote_1ID') AND @Sort_Ascending=0 THEN VW_BranchTransferData.RefQuote_1ID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedIn_By' OR @Sort_Column='CheckedIn_By') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.CheckedIn_By IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedIn_By' OR @Sort_Column='CheckedIn_By') AND @Sort_Ascending=1 THEN VW_BranchTransferData.CheckedIn_By ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.CheckedIn_By' OR @Sort_Column='CheckedIn_By') AND @Sort_Ascending=0 THEN VW_BranchTransferData.CheckedIn_By ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_BranchTransferData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_BranchTransferData.EmployeeID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN VW_BranchTransferData.EmployeeID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_BranchTransferData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN VW_BranchTransferData.EmployeeID ELSE NULL END DESC
 ) AS RowNum, VW_BranchTransferData.*
 FROM  VW_BranchTransferData (NOLOCK)

 WHERE (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentQuoteid_Values IS NULL OR  (@RentQuoteid_Values = '###NULL###' AND RentQuoteid IS NULL ) OR (@RentQuoteid_Values <> '###NULL###' AND RentQuoteid IN(SELECT Item FROM [dbo].CustomeSplit(@RentQuoteid_Values,','))))
 AND (@RentQuoteid_Min IS NULL OR RentQuoteid >=  @RentQuoteid_Min)
 AND (@RentQuoteid_Max IS NULL OR RentQuoteid <=  @RentQuoteid_Max)
 AND (@TransferFrom IS NULL OR (@TransferFrom = '###NULL###' AND TransferFrom IS NULL ) OR (@TransferFrom <> '###NULL###' AND TransferFrom LIKE '%'+@TransferFrom+'%'))
 AND (@TransferFrom_Values IS NULL OR (@TransferFrom_Values = '###NULL###' AND TransferFrom IS NULL ) OR (@TransferFrom_Values <> '###NULL###' AND TransferFrom IN(SELECT Item FROM [dbo].CustomeSplit(@TransferFrom_Values,','))))
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@CheckedOut_Values IS NULL OR  (@CheckedOut_Values = '###NULL###' AND CheckedOut IS NULL ) OR (@CheckedOut_Values <> '###NULL###' AND CheckedOut IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedOut_Values,','))))
 AND (@CheckedOut_Min IS NULL OR CheckedOut >=  @CheckedOut_Min)
 AND (@CheckedOut_Max IS NULL OR CheckedOut <=  @CheckedOut_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@RefQuoteID_Values IS NULL OR  (@RefQuoteID_Values = '###NULL###' AND RefQuoteID IS NULL ) OR (@RefQuoteID_Values <> '###NULL###' AND RefQuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@RefQuoteID_Values,','))))
 AND (@RefQuoteID_Min IS NULL OR RefQuoteID >=  @RefQuoteID_Min)
 AND (@RefQuoteID_Max IS NULL OR RefQuoteID <=  @RefQuoteID_Max)
 AND (@RefCustName IS NULL OR (@RefCustName = '###NULL###' AND RefCustName IS NULL ) OR (@RefCustName <> '###NULL###' AND RefCustName LIKE '%'+@RefCustName+'%'))
 AND (@RefCustName_Values IS NULL OR (@RefCustName_Values = '###NULL###' AND RefCustName IS NULL ) OR (@RefCustName_Values <> '###NULL###' AND RefCustName IN(SELECT Item FROM [dbo].CustomeSplit(@RefCustName_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@CheckedInBy IS NULL OR (@CheckedInBy = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy <> '###NULL###' AND CheckedInBy LIKE '%'+@CheckedInBy+'%'))
 AND (@CheckedInBy_Values IS NULL OR (@CheckedInBy_Values = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy_Values <> '###NULL###' AND CheckedInBy IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedInBy_Values,','))))
 AND (@CheckInTime_Values IS NULL OR  (@CheckInTime_Values = '###NULL###' AND CheckInTime IS NULL ) OR (@CheckInTime_Values <> '###NULL###' AND CheckInTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckInTime_Values,','))))
 AND (@CheckInTime_Min IS NULL OR CheckInTime >=  @CheckInTime_Min)
 AND (@CheckInTime_Max IS NULL OR CheckInTime <=  @CheckInTime_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@RefQuote_1ID_Values IS NULL OR  (@RefQuote_1ID_Values = '###NULL###' AND RefQuote_1ID IS NULL ) OR (@RefQuote_1ID_Values <> '###NULL###' AND RefQuote_1ID IN(SELECT Item FROM [dbo].CustomeSplit(@RefQuote_1ID_Values,','))))
 AND (@RefQuote_1ID_Min IS NULL OR RefQuote_1ID >=  @RefQuote_1ID_Min)
 AND (@RefQuote_1ID_Max IS NULL OR RefQuote_1ID <=  @RefQuote_1ID_Max)
 AND (@CheckedIn_By IS NULL OR (@CheckedIn_By = '###NULL###' AND CheckedIn_By IS NULL ) OR (@CheckedIn_By <> '###NULL###' AND CheckedIn_By LIKE '%'+@CheckedIn_By+'%'))
 AND (@CheckedIn_By_Values IS NULL OR (@CheckedIn_By_Values = '###NULL###' AND CheckedIn_By IS NULL ) OR (@CheckedIn_By_Values <> '###NULL###' AND CheckedIn_By IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedIn_By_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_EquipmentDeliveryData_View_Search]    Script Date: 20-07-2020 09:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[spr_tb_VW_EquipmentDeliveryData_View_Search]

@ResultCount INT OUTPUT,
@RentBillable bit = NULL,
@CustID_Values nvarchar(max) = NULL,
@CustID_Min int = NULL,
@CustID_Max int = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@ContractID_Values nvarchar(max) = NULL,
@ContractID_Min int = NULL,
@ContractID_Max int = NULL,
@RentStart nvarchar(66) = NULL,
@RentStart_Values nvarchar(max) = NULL,
@RentEnd nvarchar(66) = NULL,
@RentEnd_Values nvarchar(max) = NULL,
@RentStartDate_Values nvarchar(max) = NULL,
@RentStartDate_Min datetime = NULL,
@RentStartDate_Max datetime = NULL,
@RentEndDate_Values nvarchar(max) = NULL,
@RentEndDate_Min datetime = NULL,
@RentEndDate_Max datetime = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@ShippedBy nvarchar(50) = NULL,
@ShippedBy_Values nvarchar(max) = NULL,
@RentShippingID nvarchar(50) = NULL,
@RentShippingID_Values nvarchar(max) = NULL,
@ShowName nvarchar(255) = NULL,
@ShowName_Values nvarchar(max) = NULL,
@RentAddress2 nvarchar(50) = NULL,
@RentAddress2_Values nvarchar(max) = NULL,
@RentShipAddr nvarchar(100) = NULL,
@RentShipAddr_Values nvarchar(max) = NULL,
@RentShipCity nvarchar(50) = NULL,
@RentShipCity_Values nvarchar(max) = NULL,
@RentState nvarchar(50) = NULL,
@RentState_Values nvarchar(max) = NULL,
@RentStatus nvarchar(35) = NULL,
@RentStatus_Values nvarchar(max) = NULL,
@Variances_Values nvarchar(max) = NULL,
@Variances_Min int = NULL,
@Variances_Max int = NULL,
@ApproverName nvarchar(50) = NULL,
@ApproverName_Values nvarchar(max) = NULL,
@ApprovedTime varchar(18) = NULL,
@ApprovedTime_Values nvarchar(max) = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@BranchCode nvarchar(50) = NULL,
@BranchCode_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@CheckFileImage varchar(5) = NULL,
@CheckFileImage_Values nvarchar(max) = NULL,
@RentStateTooltip nvarchar(407) = NULL,
@RentStateTooltip_Values nvarchar(max) = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
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
SET @ResultCount = (SELECT COUNT(*) FROM VW_EquipmentDeliveryData (NOLOCK)
 WHERE (@RentBillable IS NULL OR RentBillable =  @RentBillable)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ShippedBy IS NULL OR (@ShippedBy = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy <> '###NULL###' AND ShippedBy LIKE '%'+@ShippedBy+'%'))
 AND (@ShippedBy_Values IS NULL OR (@ShippedBy_Values = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy_Values <> '###NULL###' AND ShippedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ShippedBy_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@RentAddress2 IS NULL OR (@RentAddress2 = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2 <> '###NULL###' AND RentAddress2 LIKE '%'+@RentAddress2+'%'))
 AND (@RentAddress2_Values IS NULL OR (@RentAddress2_Values = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2_Values <> '###NULL###' AND RentAddress2 IN(SELECT Item FROM [dbo].CustomeSplit(@RentAddress2_Values,','))))
 AND (@RentShipAddr IS NULL OR (@RentShipAddr = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr <> '###NULL###' AND RentShipAddr LIKE '%'+@RentShipAddr+'%'))
 AND (@RentShipAddr_Values IS NULL OR (@RentShipAddr_Values = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr_Values <> '###NULL###' AND RentShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipAddr_Values,','))))
 AND (@RentShipCity IS NULL OR (@RentShipCity = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity <> '###NULL###' AND RentShipCity LIKE '%'+@RentShipCity+'%'))
 AND (@RentShipCity_Values IS NULL OR (@RentShipCity_Values = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity_Values <> '###NULL###' AND RentShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipCity_Values,','))))
 AND (@RentState IS NULL OR (@RentState = '###NULL###' AND RentState IS NULL ) OR (@RentState <> '###NULL###' AND RentState LIKE '%'+@RentState+'%'))
 AND (@RentState_Values IS NULL OR (@RentState_Values = '###NULL###' AND RentState IS NULL ) OR (@RentState_Values <> '###NULL###' AND RentState IN(SELECT Item FROM [dbo].CustomeSplit(@RentState_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@Variances_Values IS NULL OR  (@Variances_Values = '###NULL###' AND Variances IS NULL ) OR (@Variances_Values <> '###NULL###' AND Variances IN(SELECT Item FROM [dbo].CustomeSplit(@Variances_Values,','))))
 AND (@Variances_Min IS NULL OR Variances >=  @Variances_Min)
 AND (@Variances_Max IS NULL OR Variances <=  @Variances_Max)
 AND (@ApproverName IS NULL OR (@ApproverName = '###NULL###' AND ApproverName IS NULL ) OR (@ApproverName <> '###NULL###' AND ApproverName LIKE '%'+@ApproverName+'%'))
 AND (@ApproverName_Values IS NULL OR (@ApproverName_Values = '###NULL###' AND ApproverName IS NULL ) OR (@ApproverName_Values <> '###NULL###' AND ApproverName IN(SELECT Item FROM [dbo].CustomeSplit(@ApproverName_Values,','))))
 AND (@ApprovedTime IS NULL OR (@ApprovedTime = '###NULL###' AND ApprovedTime IS NULL ) OR (@ApprovedTime <> '###NULL###' AND ApprovedTime LIKE '%'+@ApprovedTime+'%'))
 AND (@ApprovedTime_Values IS NULL OR (@ApprovedTime_Values = '###NULL###' AND ApprovedTime IS NULL ) OR (@ApprovedTime_Values <> '###NULL###' AND ApprovedTime IN(SELECT Item FROM [dbo].CustomeSplit(@ApprovedTime_Values,','))))
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@CheckFileImage IS NULL OR (@CheckFileImage = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage <> '###NULL###' AND CheckFileImage LIKE '%'+@CheckFileImage+'%'))
 AND (@CheckFileImage_Values IS NULL OR (@CheckFileImage_Values = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage_Values <> '###NULL###' AND CheckFileImage IN(SELECT Item FROM [dbo].CustomeSplit(@CheckFileImage_Values,','))))
 AND (@RentStateTooltip IS NULL OR (@RentStateTooltip = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip <> '###NULL###' AND RentStateTooltip LIKE '%'+@RentStateTooltip+'%'))
 AND (@RentStateTooltip_Values IS NULL OR (@RentStateTooltip_Values = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip_Values <> '###NULL###' AND RentStateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@RentStateTooltip_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT RentBillable,CustID,CustName,ContractID,RentStart,RentEnd,RentStartDate,RentEndDate,SalesRep,ShippedBy,RentShippingID,ShowName,RentAddress2,RentShipAddr,RentShipCity,RentState,RentStatus,Variances,ApproverName,ApprovedTime,Total,BranchCode,BranchID,CheckFileImage,RentStateTooltip,EmployeeID FROM  VW_EquipmentDeliveryData (NOLOCK)

 WHERE (@RentBillable IS NULL OR RentBillable =  @RentBillable)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ShippedBy IS NULL OR (@ShippedBy = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy <> '###NULL###' AND ShippedBy LIKE '%'+@ShippedBy+'%'))
 AND (@ShippedBy_Values IS NULL OR (@ShippedBy_Values = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy_Values <> '###NULL###' AND ShippedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ShippedBy_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@RentAddress2 IS NULL OR (@RentAddress2 = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2 <> '###NULL###' AND RentAddress2 LIKE '%'+@RentAddress2+'%'))
 AND (@RentAddress2_Values IS NULL OR (@RentAddress2_Values = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2_Values <> '###NULL###' AND RentAddress2 IN(SELECT Item FROM [dbo].CustomeSplit(@RentAddress2_Values,','))))
 AND (@RentShipAddr IS NULL OR (@RentShipAddr = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr <> '###NULL###' AND RentShipAddr LIKE '%'+@RentShipAddr+'%'))
 AND (@RentShipAddr_Values IS NULL OR (@RentShipAddr_Values = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr_Values <> '###NULL###' AND RentShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipAddr_Values,','))))
 AND (@RentShipCity IS NULL OR (@RentShipCity = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity <> '###NULL###' AND RentShipCity LIKE '%'+@RentShipCity+'%'))
 AND (@RentShipCity_Values IS NULL OR (@RentShipCity_Values = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity_Values <> '###NULL###' AND RentShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipCity_Values,','))))
 AND (@RentState IS NULL OR (@RentState = '###NULL###' AND RentState IS NULL ) OR (@RentState <> '###NULL###' AND RentState LIKE '%'+@RentState+'%'))
 AND (@RentState_Values IS NULL OR (@RentState_Values = '###NULL###' AND RentState IS NULL ) OR (@RentState_Values <> '###NULL###' AND RentState IN(SELECT Item FROM [dbo].CustomeSplit(@RentState_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@Variances_Values IS NULL OR  (@Variances_Values = '###NULL###' AND Variances IS NULL ) OR (@Variances_Values <> '###NULL###' AND Variances IN(SELECT Item FROM [dbo].CustomeSplit(@Variances_Values,','))))
 AND (@Variances_Min IS NULL OR Variances >=  @Variances_Min)
 AND (@Variances_Max IS NULL OR Variances <=  @Variances_Max)
 AND (@ApproverName IS NULL OR (@ApproverName = '###NULL###' AND ApproverName IS NULL ) OR (@ApproverName <> '###NULL###' AND ApproverName LIKE '%'+@ApproverName+'%'))
 AND (@ApproverName_Values IS NULL OR (@ApproverName_Values = '###NULL###' AND ApproverName IS NULL ) OR (@ApproverName_Values <> '###NULL###' AND ApproverName IN(SELECT Item FROM [dbo].CustomeSplit(@ApproverName_Values,','))))
 AND (@ApprovedTime IS NULL OR (@ApprovedTime = '###NULL###' AND ApprovedTime IS NULL ) OR (@ApprovedTime <> '###NULL###' AND ApprovedTime LIKE '%'+@ApprovedTime+'%'))
 AND (@ApprovedTime_Values IS NULL OR (@ApprovedTime_Values = '###NULL###' AND ApprovedTime IS NULL ) OR (@ApprovedTime_Values <> '###NULL###' AND ApprovedTime IN(SELECT Item FROM [dbo].CustomeSplit(@ApprovedTime_Values,','))))
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@CheckFileImage IS NULL OR (@CheckFileImage = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage <> '###NULL###' AND CheckFileImage LIKE '%'+@CheckFileImage+'%'))
 AND (@CheckFileImage_Values IS NULL OR (@CheckFileImage_Values = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage_Values <> '###NULL###' AND CheckFileImage IN(SELECT Item FROM [dbo].CustomeSplit(@CheckFileImage_Values,','))))
 AND (@RentStateTooltip IS NULL OR (@RentStateTooltip = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip <> '###NULL###' AND RentStateTooltip LIKE '%'+@RentStateTooltip+'%'))
 AND (@RentStateTooltip_Values IS NULL OR (@RentStateTooltip_Values = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip_Values <> '###NULL###' AND RentStateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@RentStateTooltip_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 
END
ELSE
BEGIN
SELECT RentBillable,CustID,CustName,ContractID,RentStart,RentEnd,RentStartDate,RentEndDate,SalesRep,ShippedBy,RentShippingID,ShowName,RentAddress2,RentShipAddr,RentShipCity,RentState,RentStatus,Variances,ApproverName,ApprovedTime,Total,BranchCode,BranchID,CheckFileImage,RentStateTooltip,EmployeeID FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentBillable' OR @Sort_Column='RentBillable') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentBillable IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentBillable' OR @Sort_Column='RentBillable') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentBillable ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentBillable' OR @Sort_Column='RentBillable') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentBillable ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.CustID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.CustID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.CustID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.CustName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.CustName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.CustName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.ContractID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.ContractID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.ContractID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentStart IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentStart ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentStart ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentEnd IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentEnd ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentEnd ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentStartDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentStartDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentStartDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentEndDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentEndDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentEndDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.SalesRep IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.SalesRep ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.SalesRep ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ShippedBy' OR @Sort_Column='ShippedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.ShippedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ShippedBy' OR @Sort_Column='ShippedBy') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.ShippedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ShippedBy' OR @Sort_Column='ShippedBy') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.ShippedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentShippingID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentShippingID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentShippingID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.ShowName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.ShowName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.ShowName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentAddress2' OR @Sort_Column='RentAddress2') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentAddress2 IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentAddress2' OR @Sort_Column='RentAddress2') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentAddress2 ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentAddress2' OR @Sort_Column='RentAddress2') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentAddress2 ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShipAddr' OR @Sort_Column='RentShipAddr') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentShipAddr IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShipAddr' OR @Sort_Column='RentShipAddr') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentShipAddr ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShipAddr' OR @Sort_Column='RentShipAddr') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentShipAddr ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShipCity' OR @Sort_Column='RentShipCity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentShipCity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShipCity' OR @Sort_Column='RentShipCity') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentShipCity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentShipCity' OR @Sort_Column='RentShipCity') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentShipCity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentState' OR @Sort_Column='RentState') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentState IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentState' OR @Sort_Column='RentState') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentState ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentState' OR @Sort_Column='RentState') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentState ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentStatus IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentStatus ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentStatus ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.Variances' OR @Sort_Column='Variances') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.Variances IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.Variances' OR @Sort_Column='Variances') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.Variances ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.Variances' OR @Sort_Column='Variances') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.Variances ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ApproverName' OR @Sort_Column='ApproverName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.ApproverName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ApproverName' OR @Sort_Column='ApproverName') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.ApproverName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ApproverName' OR @Sort_Column='ApproverName') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.ApproverName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ApprovedTime' OR @Sort_Column='ApprovedTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.ApprovedTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ApprovedTime' OR @Sort_Column='ApprovedTime') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.ApprovedTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.ApprovedTime' OR @Sort_Column='ApprovedTime') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.ApprovedTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.Total IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.Total ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.Total ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.BranchCode IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.BranchCode ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.BranchCode ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.BranchID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.BranchID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.BranchID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CheckFileImage' OR @Sort_Column='CheckFileImage') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.CheckFileImage IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CheckFileImage' OR @Sort_Column='CheckFileImage') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.CheckFileImage ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.CheckFileImage' OR @Sort_Column='CheckFileImage') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.CheckFileImage ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStateTooltip' OR @Sort_Column='RentStateTooltip') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.RentStateTooltip IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStateTooltip' OR @Sort_Column='RentStateTooltip') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.RentStateTooltip ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.RentStateTooltip' OR @Sort_Column='RentStateTooltip') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.RentStateTooltip ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentDeliveryData.EmployeeID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN VW_EquipmentDeliveryData.EmployeeID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentDeliveryData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN VW_EquipmentDeliveryData.EmployeeID ELSE NULL END DESC
 ) AS RowNum, VW_EquipmentDeliveryData.*
 FROM  VW_EquipmentDeliveryData (NOLOCK)

 WHERE (@RentBillable IS NULL OR RentBillable =  @RentBillable)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ShippedBy IS NULL OR (@ShippedBy = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy <> '###NULL###' AND ShippedBy LIKE '%'+@ShippedBy+'%'))
 AND (@ShippedBy_Values IS NULL OR (@ShippedBy_Values = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy_Values <> '###NULL###' AND ShippedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ShippedBy_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@RentAddress2 IS NULL OR (@RentAddress2 = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2 <> '###NULL###' AND RentAddress2 LIKE '%'+@RentAddress2+'%'))
 AND (@RentAddress2_Values IS NULL OR (@RentAddress2_Values = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2_Values <> '###NULL###' AND RentAddress2 IN(SELECT Item FROM [dbo].CustomeSplit(@RentAddress2_Values,','))))
 AND (@RentShipAddr IS NULL OR (@RentShipAddr = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr <> '###NULL###' AND RentShipAddr LIKE '%'+@RentShipAddr+'%'))
 AND (@RentShipAddr_Values IS NULL OR (@RentShipAddr_Values = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr_Values <> '###NULL###' AND RentShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipAddr_Values,','))))
 AND (@RentShipCity IS NULL OR (@RentShipCity = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity <> '###NULL###' AND RentShipCity LIKE '%'+@RentShipCity+'%'))
 AND (@RentShipCity_Values IS NULL OR (@RentShipCity_Values = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity_Values <> '###NULL###' AND RentShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipCity_Values,','))))
 AND (@RentState IS NULL OR (@RentState = '###NULL###' AND RentState IS NULL ) OR (@RentState <> '###NULL###' AND RentState LIKE '%'+@RentState+'%'))
 AND (@RentState_Values IS NULL OR (@RentState_Values = '###NULL###' AND RentState IS NULL ) OR (@RentState_Values <> '###NULL###' AND RentState IN(SELECT Item FROM [dbo].CustomeSplit(@RentState_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@Variances_Values IS NULL OR  (@Variances_Values = '###NULL###' AND Variances IS NULL ) OR (@Variances_Values <> '###NULL###' AND Variances IN(SELECT Item FROM [dbo].CustomeSplit(@Variances_Values,','))))
 AND (@Variances_Min IS NULL OR Variances >=  @Variances_Min)
 AND (@Variances_Max IS NULL OR Variances <=  @Variances_Max)
 AND (@ApproverName IS NULL OR (@ApproverName = '###NULL###' AND ApproverName IS NULL ) OR (@ApproverName <> '###NULL###' AND ApproverName LIKE '%'+@ApproverName+'%'))
 AND (@ApproverName_Values IS NULL OR (@ApproverName_Values = '###NULL###' AND ApproverName IS NULL ) OR (@ApproverName_Values <> '###NULL###' AND ApproverName IN(SELECT Item FROM [dbo].CustomeSplit(@ApproverName_Values,','))))
 AND (@ApprovedTime IS NULL OR (@ApprovedTime = '###NULL###' AND ApprovedTime IS NULL ) OR (@ApprovedTime <> '###NULL###' AND ApprovedTime LIKE '%'+@ApprovedTime+'%'))
 AND (@ApprovedTime_Values IS NULL OR (@ApprovedTime_Values = '###NULL###' AND ApprovedTime IS NULL ) OR (@ApprovedTime_Values <> '###NULL###' AND ApprovedTime IN(SELECT Item FROM [dbo].CustomeSplit(@ApprovedTime_Values,','))))
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@CheckFileImage IS NULL OR (@CheckFileImage = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage <> '###NULL###' AND CheckFileImage LIKE '%'+@CheckFileImage+'%'))
 AND (@CheckFileImage_Values IS NULL OR (@CheckFileImage_Values = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage_Values <> '###NULL###' AND CheckFileImage IN(SELECT Item FROM [dbo].CustomeSplit(@CheckFileImage_Values,','))))
 AND (@RentStateTooltip IS NULL OR (@RentStateTooltip = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip <> '###NULL###' AND RentStateTooltip LIKE '%'+@RentStateTooltip+'%'))
 AND (@RentStateTooltip_Values IS NULL OR (@RentStateTooltip_Values = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip_Values <> '###NULL###' AND RentStateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@RentStateTooltip_Values,','))))
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_EquipmentReturnsData_View_Search]    Script Date: 20-07-2020 09:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[spr_tb_VW_EquipmentReturnsData_View_Search]

@ResultCount INT OUTPUT,
@RentBillable bit = NULL,
@CustID_Values nvarchar(max) = NULL,
@CustID_Min int = NULL,
@CustID_Max int = NULL,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@ContractID_Values nvarchar(max) = NULL,
@ContractID_Min int = NULL,
@ContractID_Max int = NULL,
@RentStart nvarchar(66) = NULL,
@RentStart_Values nvarchar(max) = NULL,
@RentEnd nvarchar(66) = NULL,
@RentEnd_Values nvarchar(max) = NULL,
@RentStartDate_Values nvarchar(max) = NULL,
@RentStartDate_Min datetime = NULL,
@RentStartDate_Max datetime = NULL,
@RentEndDate_Values nvarchar(max) = NULL,
@RentEndDate_Min datetime = NULL,
@RentEndDate_Max datetime = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@ReceivedBy nvarchar(50) = NULL,
@ReceivedBy_Values nvarchar(max) = NULL,
@RentShippingID nvarchar(50) = NULL,
@RentShippingID_Values nvarchar(max) = NULL,
@ShowName nvarchar(255) = NULL,
@ShowName_Values nvarchar(max) = NULL,
@RentAddress2 nvarchar(50) = NULL,
@RentAddress2_Values nvarchar(max) = NULL,
@RentShipAddr nvarchar(100) = NULL,
@RentShipAddr_Values nvarchar(max) = NULL,
@RentShipCity nvarchar(50) = NULL,
@RentShipCity_Values nvarchar(max) = NULL,
@RentState nvarchar(50) = NULL,
@RentState_Values nvarchar(max) = NULL,
@RentStatus nvarchar(35) = NULL,
@RentStatus_Values nvarchar(max) = NULL,
@CheckedInBy nvarchar(50) = NULL,
@CheckedInBy_Values nvarchar(max) = NULL,
@CheckInTime_Values nvarchar(max) = NULL,
@CheckInTime_Min float = NULL,
@CheckInTime_Max float = NULL,
@QCTime_Values nvarchar(max) = NULL,
@QCTime_Min float = NULL,
@QCTime_Max float = NULL,
@QuoteID_Values nvarchar(max) = NULL,
@QuoteID_Min int = NULL,
@QuoteID_Max int = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@BranchCode nvarchar(50) = NULL,
@BranchCode_Values nvarchar(max) = NULL,
@CheckFileImage varchar(5) = NULL,
@CheckFileImage_Values nvarchar(max) = NULL,
@RentStateTooltip nvarchar(407) = NULL,
@RentStateTooltip_Values nvarchar(max) = NULL,
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
SET @ResultCount = (SELECT COUNT(*) FROM VW_EquipmentReturnsData (NOLOCK)
 WHERE (@RentBillable IS NULL OR RentBillable =  @RentBillable)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ReceivedBy IS NULL OR (@ReceivedBy = '###NULL###' AND ReceivedBy IS NULL ) OR (@ReceivedBy <> '###NULL###' AND ReceivedBy LIKE '%'+@ReceivedBy+'%'))
 AND (@ReceivedBy_Values IS NULL OR (@ReceivedBy_Values = '###NULL###' AND ReceivedBy IS NULL ) OR (@ReceivedBy_Values <> '###NULL###' AND ReceivedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReceivedBy_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@RentAddress2 IS NULL OR (@RentAddress2 = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2 <> '###NULL###' AND RentAddress2 LIKE '%'+@RentAddress2+'%'))
 AND (@RentAddress2_Values IS NULL OR (@RentAddress2_Values = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2_Values <> '###NULL###' AND RentAddress2 IN(SELECT Item FROM [dbo].CustomeSplit(@RentAddress2_Values,','))))
 AND (@RentShipAddr IS NULL OR (@RentShipAddr = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr <> '###NULL###' AND RentShipAddr LIKE '%'+@RentShipAddr+'%'))
 AND (@RentShipAddr_Values IS NULL OR (@RentShipAddr_Values = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr_Values <> '###NULL###' AND RentShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipAddr_Values,','))))
 AND (@RentShipCity IS NULL OR (@RentShipCity = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity <> '###NULL###' AND RentShipCity LIKE '%'+@RentShipCity+'%'))
 AND (@RentShipCity_Values IS NULL OR (@RentShipCity_Values = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity_Values <> '###NULL###' AND RentShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipCity_Values,','))))
 AND (@RentState IS NULL OR (@RentState = '###NULL###' AND RentState IS NULL ) OR (@RentState <> '###NULL###' AND RentState LIKE '%'+@RentState+'%'))
 AND (@RentState_Values IS NULL OR (@RentState_Values = '###NULL###' AND RentState IS NULL ) OR (@RentState_Values <> '###NULL###' AND RentState IN(SELECT Item FROM [dbo].CustomeSplit(@RentState_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@CheckedInBy IS NULL OR (@CheckedInBy = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy <> '###NULL###' AND CheckedInBy LIKE '%'+@CheckedInBy+'%'))
 AND (@CheckedInBy_Values IS NULL OR (@CheckedInBy_Values = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy_Values <> '###NULL###' AND CheckedInBy IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedInBy_Values,','))))
 AND (@CheckInTime_Values IS NULL OR  (@CheckInTime_Values = '###NULL###' AND CheckInTime IS NULL ) OR (@CheckInTime_Values <> '###NULL###' AND CheckInTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckInTime_Values,','))))
 AND (@CheckInTime_Min IS NULL OR CheckInTime >=  @CheckInTime_Min)
 AND (@CheckInTime_Max IS NULL OR CheckInTime <=  @CheckInTime_Max)
 AND (@QCTime_Values IS NULL OR  (@QCTime_Values = '###NULL###' AND QCTime IS NULL ) OR (@QCTime_Values <> '###NULL###' AND QCTime IN(SELECT Item FROM [dbo].CustomeSplit(@QCTime_Values,','))))
 AND (@QCTime_Min IS NULL OR QCTime >=  @QCTime_Min)
 AND (@QCTime_Max IS NULL OR QCTime <=  @QCTime_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@CheckFileImage IS NULL OR (@CheckFileImage = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage <> '###NULL###' AND CheckFileImage LIKE '%'+@CheckFileImage+'%'))
 AND (@CheckFileImage_Values IS NULL OR (@CheckFileImage_Values = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage_Values <> '###NULL###' AND CheckFileImage IN(SELECT Item FROM [dbo].CustomeSplit(@CheckFileImage_Values,','))))
 AND (@RentStateTooltip IS NULL OR (@RentStateTooltip = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip <> '###NULL###' AND RentStateTooltip LIKE '%'+@RentStateTooltip+'%'))
 AND (@RentStateTooltip_Values IS NULL OR (@RentStateTooltip_Values = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip_Values <> '###NULL###' AND RentStateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@RentStateTooltip_Values,','))))
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT RentBillable,CustID,CustName,ContractID,RentStart,RentEnd,RentStartDate,RentEndDate,SalesRep,ReceivedBy,RentShippingID,ShowName,RentAddress2,RentShipAddr,RentShipCity,RentState,RentStatus,CheckedInBy,CheckInTime,QCTime,QuoteID,Total,EmployeeID,BranchID,BranchCode,CheckFileImage,RentStateTooltip FROM  VW_EquipmentReturnsData (NOLOCK)

 WHERE (@RentBillable IS NULL OR RentBillable =  @RentBillable)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ReceivedBy IS NULL OR (@ReceivedBy = '###NULL###' AND ReceivedBy IS NULL ) OR (@ReceivedBy <> '###NULL###' AND ReceivedBy LIKE '%'+@ReceivedBy+'%'))
 AND (@ReceivedBy_Values IS NULL OR (@ReceivedBy_Values = '###NULL###' AND ReceivedBy IS NULL ) OR (@ReceivedBy_Values <> '###NULL###' AND ReceivedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReceivedBy_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@RentAddress2 IS NULL OR (@RentAddress2 = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2 <> '###NULL###' AND RentAddress2 LIKE '%'+@RentAddress2+'%'))
 AND (@RentAddress2_Values IS NULL OR (@RentAddress2_Values = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2_Values <> '###NULL###' AND RentAddress2 IN(SELECT Item FROM [dbo].CustomeSplit(@RentAddress2_Values,','))))
 AND (@RentShipAddr IS NULL OR (@RentShipAddr = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr <> '###NULL###' AND RentShipAddr LIKE '%'+@RentShipAddr+'%'))
 AND (@RentShipAddr_Values IS NULL OR (@RentShipAddr_Values = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr_Values <> '###NULL###' AND RentShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipAddr_Values,','))))
 AND (@RentShipCity IS NULL OR (@RentShipCity = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity <> '###NULL###' AND RentShipCity LIKE '%'+@RentShipCity+'%'))
 AND (@RentShipCity_Values IS NULL OR (@RentShipCity_Values = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity_Values <> '###NULL###' AND RentShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipCity_Values,','))))
 AND (@RentState IS NULL OR (@RentState = '###NULL###' AND RentState IS NULL ) OR (@RentState <> '###NULL###' AND RentState LIKE '%'+@RentState+'%'))
 AND (@RentState_Values IS NULL OR (@RentState_Values = '###NULL###' AND RentState IS NULL ) OR (@RentState_Values <> '###NULL###' AND RentState IN(SELECT Item FROM [dbo].CustomeSplit(@RentState_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@CheckedInBy IS NULL OR (@CheckedInBy = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy <> '###NULL###' AND CheckedInBy LIKE '%'+@CheckedInBy+'%'))
 AND (@CheckedInBy_Values IS NULL OR (@CheckedInBy_Values = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy_Values <> '###NULL###' AND CheckedInBy IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedInBy_Values,','))))
 AND (@CheckInTime_Values IS NULL OR  (@CheckInTime_Values = '###NULL###' AND CheckInTime IS NULL ) OR (@CheckInTime_Values <> '###NULL###' AND CheckInTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckInTime_Values,','))))
 AND (@CheckInTime_Min IS NULL OR CheckInTime >=  @CheckInTime_Min)
 AND (@CheckInTime_Max IS NULL OR CheckInTime <=  @CheckInTime_Max)
 AND (@QCTime_Values IS NULL OR  (@QCTime_Values = '###NULL###' AND QCTime IS NULL ) OR (@QCTime_Values <> '###NULL###' AND QCTime IN(SELECT Item FROM [dbo].CustomeSplit(@QCTime_Values,','))))
 AND (@QCTime_Min IS NULL OR QCTime >=  @QCTime_Min)
 AND (@QCTime_Max IS NULL OR QCTime <=  @QCTime_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@CheckFileImage IS NULL OR (@CheckFileImage = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage <> '###NULL###' AND CheckFileImage LIKE '%'+@CheckFileImage+'%'))
 AND (@CheckFileImage_Values IS NULL OR (@CheckFileImage_Values = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage_Values <> '###NULL###' AND CheckFileImage IN(SELECT Item FROM [dbo].CustomeSplit(@CheckFileImage_Values,','))))
 AND (@RentStateTooltip IS NULL OR (@RentStateTooltip = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip <> '###NULL###' AND RentStateTooltip LIKE '%'+@RentStateTooltip+'%'))
 AND (@RentStateTooltip_Values IS NULL OR (@RentStateTooltip_Values = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip_Values <> '###NULL###' AND RentStateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@RentStateTooltip_Values,','))))
 
END
ELSE
BEGIN
SELECT RentBillable,CustID,CustName,ContractID,RentStart,RentEnd,RentStartDate,RentEndDate,SalesRep,ReceivedBy,RentShippingID,ShowName,RentAddress2,RentShipAddr,RentShipCity,RentState,RentStatus,CheckedInBy,CheckInTime,QCTime,QuoteID,Total,EmployeeID,BranchID,BranchCode,CheckFileImage,RentStateTooltip FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentBillable' OR @Sort_Column='RentBillable') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentBillable IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentBillable' OR @Sort_Column='RentBillable') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentBillable ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentBillable' OR @Sort_Column='RentBillable') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentBillable ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.CustID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.CustID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.CustID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.CustName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.CustName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.CustName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.ContractID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.ContractID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ContractID' OR @Sort_Column='ContractID') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.ContractID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentStart IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentStart ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStart' OR @Sort_Column='RentStart') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentStart ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentEnd IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentEnd ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentEnd' OR @Sort_Column='RentEnd') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentEnd ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentStartDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentStartDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStartDate' OR @Sort_Column='RentStartDate') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentStartDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentEndDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentEndDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentEndDate' OR @Sort_Column='RentEndDate') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentEndDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.SalesRep IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.SalesRep ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.SalesRep ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ReceivedBy' OR @Sort_Column='ReceivedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.ReceivedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ReceivedBy' OR @Sort_Column='ReceivedBy') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.ReceivedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ReceivedBy' OR @Sort_Column='ReceivedBy') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.ReceivedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentShippingID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentShippingID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShippingID' OR @Sort_Column='RentShippingID') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentShippingID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.ShowName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.ShowName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.ShowName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentAddress2' OR @Sort_Column='RentAddress2') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentAddress2 IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentAddress2' OR @Sort_Column='RentAddress2') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentAddress2 ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentAddress2' OR @Sort_Column='RentAddress2') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentAddress2 ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShipAddr' OR @Sort_Column='RentShipAddr') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentShipAddr IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShipAddr' OR @Sort_Column='RentShipAddr') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentShipAddr ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShipAddr' OR @Sort_Column='RentShipAddr') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentShipAddr ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShipCity' OR @Sort_Column='RentShipCity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentShipCity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShipCity' OR @Sort_Column='RentShipCity') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentShipCity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentShipCity' OR @Sort_Column='RentShipCity') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentShipCity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentState' OR @Sort_Column='RentState') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentState IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentState' OR @Sort_Column='RentState') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentState ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentState' OR @Sort_Column='RentState') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentState ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentStatus IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentStatus ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStatus' OR @Sort_Column='RentStatus') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentStatus ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckedInBy' OR @Sort_Column='CheckedInBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.CheckedInBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckedInBy' OR @Sort_Column='CheckedInBy') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.CheckedInBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckedInBy' OR @Sort_Column='CheckedInBy') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.CheckedInBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckInTime' OR @Sort_Column='CheckInTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.CheckInTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckInTime' OR @Sort_Column='CheckInTime') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.CheckInTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckInTime' OR @Sort_Column='CheckInTime') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.CheckInTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.QCTime' OR @Sort_Column='QCTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.QCTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.QCTime' OR @Sort_Column='QCTime') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.QCTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.QCTime' OR @Sort_Column='QCTime') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.QCTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.QuoteID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.QuoteID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.QuoteID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.Total IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.Total ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.Total ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.EmployeeID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.EmployeeID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.EmployeeID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.BranchID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.BranchID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.BranchID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.BranchCode IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.BranchCode ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.BranchCode ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckFileImage' OR @Sort_Column='CheckFileImage') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.CheckFileImage IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckFileImage' OR @Sort_Column='CheckFileImage') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.CheckFileImage ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.CheckFileImage' OR @Sort_Column='CheckFileImage') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.CheckFileImage ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStateTooltip' OR @Sort_Column='RentStateTooltip') AND @Sort_Ascending=1 THEN (CASE WHEN VW_EquipmentReturnsData.RentStateTooltip IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStateTooltip' OR @Sort_Column='RentStateTooltip') AND @Sort_Ascending=1 THEN VW_EquipmentReturnsData.RentStateTooltip ELSE NULL END,
CASE WHEN (@Sort_Column='VW_EquipmentReturnsData.RentStateTooltip' OR @Sort_Column='RentStateTooltip') AND @Sort_Ascending=0 THEN VW_EquipmentReturnsData.RentStateTooltip ELSE NULL END DESC
 ) AS RowNum, VW_EquipmentReturnsData.*
 FROM  VW_EquipmentReturnsData (NOLOCK)

 WHERE (@RentBillable IS NULL OR RentBillable =  @RentBillable)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@ContractID_Values IS NULL OR  (@ContractID_Values = '###NULL###' AND ContractID IS NULL ) OR (@ContractID_Values <> '###NULL###' AND ContractID IN(SELECT Item FROM [dbo].CustomeSplit(@ContractID_Values,','))))
 AND (@ContractID_Min IS NULL OR ContractID >=  @ContractID_Min)
 AND (@ContractID_Max IS NULL OR ContractID <=  @ContractID_Max)
 AND (@RentStart IS NULL OR (@RentStart = '###NULL###' AND RentStart IS NULL ) OR (@RentStart <> '###NULL###' AND RentStart LIKE '%'+@RentStart+'%'))
 AND (@RentStart_Values IS NULL OR (@RentStart_Values = '###NULL###' AND RentStart IS NULL ) OR (@RentStart_Values <> '###NULL###' AND RentStart IN(SELECT Item FROM [dbo].CustomeSplit(@RentStart_Values,','))))
 AND (@RentEnd IS NULL OR (@RentEnd = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd <> '###NULL###' AND RentEnd LIKE '%'+@RentEnd+'%'))
 AND (@RentEnd_Values IS NULL OR (@RentEnd_Values = '###NULL###' AND RentEnd IS NULL ) OR (@RentEnd_Values <> '###NULL###' AND RentEnd IN(SELECT Item FROM [dbo].CustomeSplit(@RentEnd_Values,','))))
 AND (@RentStartDate_Values IS NULL OR  (@RentStartDate_Values = '###NULL###' AND RentStartDate IS NULL ) OR (@RentStartDate_Values <> '###NULL###' AND RentStartDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentStartDate_Values,','))))
 AND (@RentStartDate_Min IS NULL OR RentStartDate >=  @RentStartDate_Min)
 AND (@RentStartDate_Max IS NULL OR RentStartDate <=  @RentStartDate_Max)
 AND (@RentEndDate_Values IS NULL OR  (@RentEndDate_Values = '###NULL###' AND RentEndDate IS NULL ) OR (@RentEndDate_Values <> '###NULL###' AND RentEndDate IN(SELECT Item FROM [dbo].CustomeSplit(@RentEndDate_Values,','))))
 AND (@RentEndDate_Min IS NULL OR RentEndDate >=  @RentEndDate_Min)
 AND (@RentEndDate_Max IS NULL OR RentEndDate <=  @RentEndDate_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ReceivedBy IS NULL OR (@ReceivedBy = '###NULL###' AND ReceivedBy IS NULL ) OR (@ReceivedBy <> '###NULL###' AND ReceivedBy LIKE '%'+@ReceivedBy+'%'))
 AND (@ReceivedBy_Values IS NULL OR (@ReceivedBy_Values = '###NULL###' AND ReceivedBy IS NULL ) OR (@ReceivedBy_Values <> '###NULL###' AND ReceivedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReceivedBy_Values,','))))
 AND (@RentShippingID IS NULL OR (@RentShippingID = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID <> '###NULL###' AND RentShippingID LIKE '%'+@RentShippingID+'%'))
 AND (@RentShippingID_Values IS NULL OR (@RentShippingID_Values = '###NULL###' AND RentShippingID IS NULL ) OR (@RentShippingID_Values <> '###NULL###' AND RentShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@RentShippingID_Values,','))))
 AND (@ShowName IS NULL OR (@ShowName = '###NULL###' AND ShowName IS NULL ) OR (@ShowName <> '###NULL###' AND ShowName LIKE '%'+@ShowName+'%'))
 AND (@ShowName_Values IS NULL OR (@ShowName_Values = '###NULL###' AND ShowName IS NULL ) OR (@ShowName_Values <> '###NULL###' AND ShowName IN(SELECT Item FROM [dbo].CustomeSplit(@ShowName_Values,','))))
 AND (@RentAddress2 IS NULL OR (@RentAddress2 = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2 <> '###NULL###' AND RentAddress2 LIKE '%'+@RentAddress2+'%'))
 AND (@RentAddress2_Values IS NULL OR (@RentAddress2_Values = '###NULL###' AND RentAddress2 IS NULL ) OR (@RentAddress2_Values <> '###NULL###' AND RentAddress2 IN(SELECT Item FROM [dbo].CustomeSplit(@RentAddress2_Values,','))))
 AND (@RentShipAddr IS NULL OR (@RentShipAddr = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr <> '###NULL###' AND RentShipAddr LIKE '%'+@RentShipAddr+'%'))
 AND (@RentShipAddr_Values IS NULL OR (@RentShipAddr_Values = '###NULL###' AND RentShipAddr IS NULL ) OR (@RentShipAddr_Values <> '###NULL###' AND RentShipAddr IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipAddr_Values,','))))
 AND (@RentShipCity IS NULL OR (@RentShipCity = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity <> '###NULL###' AND RentShipCity LIKE '%'+@RentShipCity+'%'))
 AND (@RentShipCity_Values IS NULL OR (@RentShipCity_Values = '###NULL###' AND RentShipCity IS NULL ) OR (@RentShipCity_Values <> '###NULL###' AND RentShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@RentShipCity_Values,','))))
 AND (@RentState IS NULL OR (@RentState = '###NULL###' AND RentState IS NULL ) OR (@RentState <> '###NULL###' AND RentState LIKE '%'+@RentState+'%'))
 AND (@RentState_Values IS NULL OR (@RentState_Values = '###NULL###' AND RentState IS NULL ) OR (@RentState_Values <> '###NULL###' AND RentState IN(SELECT Item FROM [dbo].CustomeSplit(@RentState_Values,','))))
 AND (@RentStatus IS NULL OR (@RentStatus = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus <> '###NULL###' AND RentStatus LIKE '%'+@RentStatus+'%'))
 AND (@RentStatus_Values IS NULL OR (@RentStatus_Values = '###NULL###' AND RentStatus IS NULL ) OR (@RentStatus_Values <> '###NULL###' AND RentStatus IN(SELECT Item FROM [dbo].CustomeSplit(@RentStatus_Values,','))))
 AND (@CheckedInBy IS NULL OR (@CheckedInBy = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy <> '###NULL###' AND CheckedInBy LIKE '%'+@CheckedInBy+'%'))
 AND (@CheckedInBy_Values IS NULL OR (@CheckedInBy_Values = '###NULL###' AND CheckedInBy IS NULL ) OR (@CheckedInBy_Values <> '###NULL###' AND CheckedInBy IN(SELECT Item FROM [dbo].CustomeSplit(@CheckedInBy_Values,','))))
 AND (@CheckInTime_Values IS NULL OR  (@CheckInTime_Values = '###NULL###' AND CheckInTime IS NULL ) OR (@CheckInTime_Values <> '###NULL###' AND CheckInTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckInTime_Values,','))))
 AND (@CheckInTime_Min IS NULL OR CheckInTime >=  @CheckInTime_Min)
 AND (@CheckInTime_Max IS NULL OR CheckInTime <=  @CheckInTime_Max)
 AND (@QCTime_Values IS NULL OR  (@QCTime_Values = '###NULL###' AND QCTime IS NULL ) OR (@QCTime_Values <> '###NULL###' AND QCTime IN(SELECT Item FROM [dbo].CustomeSplit(@QCTime_Values,','))))
 AND (@QCTime_Min IS NULL OR QCTime >=  @QCTime_Min)
 AND (@QCTime_Max IS NULL OR QCTime <=  @QCTime_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@CheckFileImage IS NULL OR (@CheckFileImage = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage <> '###NULL###' AND CheckFileImage LIKE '%'+@CheckFileImage+'%'))
 AND (@CheckFileImage_Values IS NULL OR (@CheckFileImage_Values = '###NULL###' AND CheckFileImage IS NULL ) OR (@CheckFileImage_Values <> '###NULL###' AND CheckFileImage IN(SELECT Item FROM [dbo].CustomeSplit(@CheckFileImage_Values,','))))
 AND (@RentStateTooltip IS NULL OR (@RentStateTooltip = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip <> '###NULL###' AND RentStateTooltip LIKE '%'+@RentStateTooltip+'%'))
 AND (@RentStateTooltip_Values IS NULL OR (@RentStateTooltip_Values = '###NULL###' AND RentStateTooltip IS NULL ) OR (@RentStateTooltip_Values <> '###NULL###' AND RentStateTooltip IN(SELECT Item FROM [dbo].CustomeSplit(@RentStateTooltip_Values,','))))
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_OrderPullData_View_Search]    Script Date: 20-07-2020 09:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[spr_tb_VW_OrderPullData_View_Search]

@ResultCount INT OUTPUT,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@CustID_Values nvarchar(max) = NULL,
@CustID_Min int = NULL,
@CustID_Max int = NULL,
@QuoteEnteredDate_Values nvarchar(max) = NULL,
@QuoteEnteredDate_Min datetime = NULL,
@QuoteEnteredDate_Max datetime = NULL,
@QuoteLastModified_Values nvarchar(max) = NULL,
@QuoteLastModified_Min datetime = NULL,
@QuoteLastModified_Max datetime = NULL,
@QConfirmationDate_Values nvarchar(max) = NULL,
@QConfirmationDate_Min datetime = NULL,
@QConfirmationDate_Max datetime = NULL,
@Rel_Short bit = NULL,
@ShortageQty_Values nvarchar(max) = NULL,
@ShortageQty_Min numeric(18,0) = NULL,
@ShortageQty_Max numeric(18,0) = NULL,
@AvailabilityLastViewedBy nvarchar(100) = NULL,
@AvailabilityLastViewedBy_Values nvarchar(max) = NULL,
@AvailabilityLastViewedOn_Values nvarchar(max) = NULL,
@AvailabilityLastViewedOn_Min datetime = NULL,
@AvailabilityLastViewedOn_Max datetime = NULL,
@QuoteID_Values nvarchar(max) = NULL,
@QuoteID_Min int = NULL,
@QuoteID_Max int = NULL,
@DeliveryDate nvarchar(66) = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@ReturnDate nvarchar(66) = NULL,
@ReturnDate_Values nvarchar(max) = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@ReviewedBy nvarchar(50) = NULL,
@ReviewedBy_Values nvarchar(max) = NULL,
@Reviewed_By nvarchar(81) = NULL,
@Reviewed_By_Values nvarchar(max) = NULL,
@PulledBy nvarchar(50) = NULL,
@PulledBy_Values nvarchar(max) = NULL,
@ShippedBy nvarchar(50) = NULL,
@ShippedBy_Values nvarchar(max) = NULL,
@ShippingID nvarchar(50) = NULL,
@ShippingID_Values nvarchar(max) = NULL,
@ShipCityState nvarchar(102) = NULL,
@ShipCityState_Values nvarchar(max) = NULL,
@ClientInterest nvarchar(50) = NULL,
@ClientInterest_Values nvarchar(max) = NULL,
@CheckOutTime_Values nvarchar(max) = NULL,
@CheckOutTime_Min float = NULL,
@CheckOutTime_Max float = NULL,
@InterestType_Values nvarchar(max) = NULL,
@InterestType_Min float = NULL,
@InterestType_Max float = NULL,
@BranchCode nvarchar(50) = NULL,
@BranchCode_Values nvarchar(max) = NULL,
@BranchID_Values nvarchar(max) = NULL,
@BranchID_Min int = NULL,
@BranchID_Max int = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min float = NULL,
@Total_Max float = NULL,
@QuoteTypeNo_Values nvarchar(max) = NULL,
@QuoteTypeNo_Min float = NULL,
@QuoteTypeNo_Max float = NULL,
@LastReviewedBy nvarchar(50) = NULL,
@LastReviewedBy_Values nvarchar(max) = NULL,
@ReviewedDateTime_Values nvarchar(max) = NULL,
@ReviewedDateTime_Min datetime = NULL,
@ReviewedDateTime_Max datetime = NULL,
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
@Address nvarchar(407) = NULL,
@Address_Values nvarchar(max) = NULL,
@RelCondition varchar(25) = NULL,
@RelCondition_Values nvarchar(max) = NULL,
@Activity varchar(1) = NULL,
@Activity_Values nvarchar(max) = NULL,
@ActivityToolTip varchar(1) = NULL,
@ActivityToolTip_Values nvarchar(max) = NULL,
@PRODUCTIONFLAG varchar(1) = NULL,
@PRODUCTIONFLAG_Values nvarchar(max) = NULL,
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
SET @ResultCount = (SELECT COUNT(*) FROM VW_OrderPullData (NOLOCK)
 WHERE (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@QuoteEnteredDate_Values IS NULL OR  (@QuoteEnteredDate_Values = '###NULL###' AND QuoteEnteredDate IS NULL ) OR (@QuoteEnteredDate_Values <> '###NULL###' AND QuoteEnteredDate IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteEnteredDate_Values,','))))
 AND (@QuoteEnteredDate_Min IS NULL OR QuoteEnteredDate >=  @QuoteEnteredDate_Min)
 AND (@QuoteEnteredDate_Max IS NULL OR QuoteEnteredDate <=  @QuoteEnteredDate_Max)
 AND (@QuoteLastModified_Values IS NULL OR  (@QuoteLastModified_Values = '###NULL###' AND QuoteLastModified IS NULL ) OR (@QuoteLastModified_Values <> '###NULL###' AND QuoteLastModified IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteLastModified_Values,','))))
 AND (@QuoteLastModified_Min IS NULL OR QuoteLastModified >=  @QuoteLastModified_Min)
 AND (@QuoteLastModified_Max IS NULL OR QuoteLastModified <=  @QuoteLastModified_Max)
 AND (@QConfirmationDate_Values IS NULL OR  (@QConfirmationDate_Values = '###NULL###' AND QConfirmationDate IS NULL ) OR (@QConfirmationDate_Values <> '###NULL###' AND QConfirmationDate IN(SELECT Item FROM [dbo].CustomeSplit(@QConfirmationDate_Values,','))))
 AND (@QConfirmationDate_Min IS NULL OR QConfirmationDate >=  @QConfirmationDate_Min)
 AND (@QConfirmationDate_Max IS NULL OR QConfirmationDate <=  @QConfirmationDate_Max)
 AND (@Rel_Short IS NULL OR Rel_Short =  @Rel_Short)
 AND (@ShortageQty_Values IS NULL OR  (@ShortageQty_Values = '###NULL###' AND ShortageQty IS NULL ) OR (@ShortageQty_Values <> '###NULL###' AND ShortageQty IN(SELECT Item FROM [dbo].CustomeSplit(@ShortageQty_Values,','))))
 AND (@ShortageQty_Min IS NULL OR ShortageQty >=  @ShortageQty_Min)
 AND (@ShortageQty_Max IS NULL OR ShortageQty <=  @ShortageQty_Max)
 AND (@AvailabilityLastViewedBy IS NULL OR (@AvailabilityLastViewedBy = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy <> '###NULL###' AND AvailabilityLastViewedBy LIKE '%'+@AvailabilityLastViewedBy+'%'))
 AND (@AvailabilityLastViewedBy_Values IS NULL OR (@AvailabilityLastViewedBy_Values = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy_Values <> '###NULL###' AND AvailabilityLastViewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedBy_Values,','))))
 AND (@AvailabilityLastViewedOn_Values IS NULL OR  (@AvailabilityLastViewedOn_Values = '###NULL###' AND AvailabilityLastViewedOn IS NULL ) OR (@AvailabilityLastViewedOn_Values <> '###NULL###' AND AvailabilityLastViewedOn IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedOn_Values,','))))
 AND (@AvailabilityLastViewedOn_Min IS NULL OR AvailabilityLastViewedOn >=  @AvailabilityLastViewedOn_Min)
 AND (@AvailabilityLastViewedOn_Max IS NULL OR AvailabilityLastViewedOn <=  @AvailabilityLastViewedOn_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@DeliveryDate IS NULL OR (@DeliveryDate = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate <> '###NULL###' AND DeliveryDate LIKE '%'+@DeliveryDate+'%'))
 AND (@DeliveryDate_Values IS NULL OR (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@ReturnDate IS NULL OR (@ReturnDate = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate <> '###NULL###' AND ReturnDate LIKE '%'+@ReturnDate+'%'))
 AND (@ReturnDate_Values IS NULL OR (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ReviewedBy IS NULL OR (@ReviewedBy = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy <> '###NULL###' AND ReviewedBy LIKE '%'+@ReviewedBy+'%'))
 AND (@ReviewedBy_Values IS NULL OR (@ReviewedBy_Values = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy_Values <> '###NULL###' AND ReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedBy_Values,','))))
 AND (@Reviewed_By IS NULL OR (@Reviewed_By = '###NULL###' AND Reviewed_By IS NULL ) OR (@Reviewed_By <> '###NULL###' AND Reviewed_By LIKE '%'+@Reviewed_By+'%'))
 AND (@Reviewed_By_Values IS NULL OR (@Reviewed_By_Values = '###NULL###' AND Reviewed_By IS NULL ) OR (@Reviewed_By_Values <> '###NULL###' AND Reviewed_By IN(SELECT Item FROM [dbo].CustomeSplit(@Reviewed_By_Values,','))))
 AND (@PulledBy IS NULL OR (@PulledBy = '###NULL###' AND PulledBy IS NULL ) OR (@PulledBy <> '###NULL###' AND PulledBy LIKE '%'+@PulledBy+'%'))
 AND (@PulledBy_Values IS NULL OR (@PulledBy_Values = '###NULL###' AND PulledBy IS NULL ) OR (@PulledBy_Values <> '###NULL###' AND PulledBy IN(SELECT Item FROM [dbo].CustomeSplit(@PulledBy_Values,','))))
 AND (@ShippedBy IS NULL OR (@ShippedBy = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy <> '###NULL###' AND ShippedBy LIKE '%'+@ShippedBy+'%'))
 AND (@ShippedBy_Values IS NULL OR (@ShippedBy_Values = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy_Values <> '###NULL###' AND ShippedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ShippedBy_Values,','))))
 AND (@ShippingID IS NULL OR (@ShippingID = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID <> '###NULL###' AND ShippingID LIKE '%'+@ShippingID+'%'))
 AND (@ShippingID_Values IS NULL OR (@ShippingID_Values = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID_Values <> '###NULL###' AND ShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@ShippingID_Values,','))))
 AND (@ShipCityState IS NULL OR (@ShipCityState = '###NULL###' AND ShipCityState IS NULL ) OR (@ShipCityState <> '###NULL###' AND ShipCityState LIKE '%'+@ShipCityState+'%'))
 AND (@ShipCityState_Values IS NULL OR (@ShipCityState_Values = '###NULL###' AND ShipCityState IS NULL ) OR (@ShipCityState_Values <> '###NULL###' AND ShipCityState IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCityState_Values,','))))
 AND (@ClientInterest IS NULL OR (@ClientInterest = '###NULL###' AND ClientInterest IS NULL ) OR (@ClientInterest <> '###NULL###' AND ClientInterest LIKE '%'+@ClientInterest+'%'))
 AND (@ClientInterest_Values IS NULL OR (@ClientInterest_Values = '###NULL###' AND ClientInterest IS NULL ) OR (@ClientInterest_Values <> '###NULL###' AND ClientInterest IN(SELECT Item FROM [dbo].CustomeSplit(@ClientInterest_Values,','))))
 AND (@CheckOutTime_Values IS NULL OR  (@CheckOutTime_Values = '###NULL###' AND CheckOutTime IS NULL ) OR (@CheckOutTime_Values <> '###NULL###' AND CheckOutTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckOutTime_Values,','))))
 AND (@CheckOutTime_Min IS NULL OR CheckOutTime >=  @CheckOutTime_Min)
 AND (@CheckOutTime_Max IS NULL OR CheckOutTime <=  @CheckOutTime_Max)
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND InterestType IS NULL ) OR (@InterestType_Values <> '###NULL###' AND InterestType IN(SELECT Item FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR InterestType >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR InterestType <=  @InterestType_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND QuoteTypeNo IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND QuoteTypeNo IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR QuoteTypeNo >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR QuoteTypeNo <=  @QuoteTypeNo_Max)
 AND (@LastReviewedBy IS NULL OR (@LastReviewedBy = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy <> '###NULL###' AND LastReviewedBy LIKE '%'+@LastReviewedBy+'%'))
 AND (@LastReviewedBy_Values IS NULL OR (@LastReviewedBy_Values = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy_Values <> '###NULL###' AND LastReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastReviewedBy_Values,','))))
 AND (@ReviewedDateTime_Values IS NULL OR  (@ReviewedDateTime_Values = '###NULL###' AND ReviewedDateTime IS NULL ) OR (@ReviewedDateTime_Values <> '###NULL###' AND ReviewedDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedDateTime_Values,','))))
 AND (@ReviewedDateTime_Min IS NULL OR ReviewedDateTime >=  @ReviewedDateTime_Min)
 AND (@ReviewedDateTime_Max IS NULL OR ReviewedDateTime <=  @ReviewedDateTime_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 AND (@Address IS NULL OR (@Address = '###NULL###' AND Address IS NULL ) OR (@Address <> '###NULL###' AND Address LIKE '%'+@Address+'%'))
 AND (@Address_Values IS NULL OR (@Address_Values = '###NULL###' AND Address IS NULL ) OR (@Address_Values <> '###NULL###' AND Address IN(SELECT Item FROM [dbo].CustomeSplit(@Address_Values,','))))
 AND (@RelCondition IS NULL OR (@RelCondition = '###NULL###' AND RelCondition IS NULL ) OR (@RelCondition <> '###NULL###' AND RelCondition LIKE '%'+@RelCondition+'%'))
 AND (@RelCondition_Values IS NULL OR (@RelCondition_Values = '###NULL###' AND RelCondition IS NULL ) OR (@RelCondition_Values <> '###NULL###' AND RelCondition IN(SELECT Item FROM [dbo].CustomeSplit(@RelCondition_Values,','))))
 AND (@Activity IS NULL OR (@Activity = '###NULL###' AND Activity IS NULL ) OR (@Activity <> '###NULL###' AND Activity LIKE '%'+@Activity+'%'))
 AND (@Activity_Values IS NULL OR (@Activity_Values = '###NULL###' AND Activity IS NULL ) OR (@Activity_Values <> '###NULL###' AND Activity IN(SELECT Item FROM [dbo].CustomeSplit(@Activity_Values,','))))
 AND (@ActivityToolTip IS NULL OR (@ActivityToolTip = '###NULL###' AND ActivityToolTip IS NULL ) OR (@ActivityToolTip <> '###NULL###' AND ActivityToolTip LIKE '%'+@ActivityToolTip+'%'))
 AND (@ActivityToolTip_Values IS NULL OR (@ActivityToolTip_Values = '###NULL###' AND ActivityToolTip IS NULL ) OR (@ActivityToolTip_Values <> '###NULL###' AND ActivityToolTip IN(SELECT Item FROM [dbo].CustomeSplit(@ActivityToolTip_Values,','))))
 AND (@PRODUCTIONFLAG IS NULL OR (@PRODUCTIONFLAG = '###NULL###' AND PRODUCTIONFLAG IS NULL ) OR (@PRODUCTIONFLAG <> '###NULL###' AND PRODUCTIONFLAG LIKE '%'+@PRODUCTIONFLAG+'%'))
 AND (@PRODUCTIONFLAG_Values IS NULL OR (@PRODUCTIONFLAG_Values = '###NULL###' AND PRODUCTIONFLAG IS NULL ) OR (@PRODUCTIONFLAG_Values <> '###NULL###' AND PRODUCTIONFLAG IN(SELECT Item FROM [dbo].CustomeSplit(@PRODUCTIONFLAG_Values,','))))
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT CustName,CustID,QuoteEnteredDate,QuoteLastModified,QConfirmationDate,Rel_Short,ShortageQty,AvailabilityLastViewedBy,AvailabilityLastViewedOn,QuoteID,DeliveryDate,ReturnDate,SalesRep,ReviewedBy,Reviewed_By,PulledBy,ShippedBy,ShippingID,ShipCityState,ClientInterest,CheckOutTime,InterestType,BranchCode,BranchID,Total,QuoteTypeNo,LastReviewedBy,ReviewedDateTime,EmployeeID,Address,RelCondition,Activity,ActivityToolTip,PRODUCTIONFLAG FROM  VW_OrderPullData (NOLOCK)

 WHERE (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@QuoteEnteredDate_Values IS NULL OR  (@QuoteEnteredDate_Values = '###NULL###' AND QuoteEnteredDate IS NULL ) OR (@QuoteEnteredDate_Values <> '###NULL###' AND QuoteEnteredDate IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteEnteredDate_Values,','))))
 AND (@QuoteEnteredDate_Min IS NULL OR QuoteEnteredDate >=  @QuoteEnteredDate_Min)
 AND (@QuoteEnteredDate_Max IS NULL OR QuoteEnteredDate <=  @QuoteEnteredDate_Max)
 AND (@QuoteLastModified_Values IS NULL OR  (@QuoteLastModified_Values = '###NULL###' AND QuoteLastModified IS NULL ) OR (@QuoteLastModified_Values <> '###NULL###' AND QuoteLastModified IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteLastModified_Values,','))))
 AND (@QuoteLastModified_Min IS NULL OR QuoteLastModified >=  @QuoteLastModified_Min)
 AND (@QuoteLastModified_Max IS NULL OR QuoteLastModified <=  @QuoteLastModified_Max)
 AND (@QConfirmationDate_Values IS NULL OR  (@QConfirmationDate_Values = '###NULL###' AND QConfirmationDate IS NULL ) OR (@QConfirmationDate_Values <> '###NULL###' AND QConfirmationDate IN(SELECT Item FROM [dbo].CustomeSplit(@QConfirmationDate_Values,','))))
 AND (@QConfirmationDate_Min IS NULL OR QConfirmationDate >=  @QConfirmationDate_Min)
 AND (@QConfirmationDate_Max IS NULL OR QConfirmationDate <=  @QConfirmationDate_Max)
 AND (@Rel_Short IS NULL OR Rel_Short =  @Rel_Short)
 AND (@ShortageQty_Values IS NULL OR  (@ShortageQty_Values = '###NULL###' AND ShortageQty IS NULL ) OR (@ShortageQty_Values <> '###NULL###' AND ShortageQty IN(SELECT Item FROM [dbo].CustomeSplit(@ShortageQty_Values,','))))
 AND (@ShortageQty_Min IS NULL OR ShortageQty >=  @ShortageQty_Min)
 AND (@ShortageQty_Max IS NULL OR ShortageQty <=  @ShortageQty_Max)
 AND (@AvailabilityLastViewedBy IS NULL OR (@AvailabilityLastViewedBy = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy <> '###NULL###' AND AvailabilityLastViewedBy LIKE '%'+@AvailabilityLastViewedBy+'%'))
 AND (@AvailabilityLastViewedBy_Values IS NULL OR (@AvailabilityLastViewedBy_Values = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy_Values <> '###NULL###' AND AvailabilityLastViewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedBy_Values,','))))
 AND (@AvailabilityLastViewedOn_Values IS NULL OR  (@AvailabilityLastViewedOn_Values = '###NULL###' AND AvailabilityLastViewedOn IS NULL ) OR (@AvailabilityLastViewedOn_Values <> '###NULL###' AND AvailabilityLastViewedOn IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedOn_Values,','))))
 AND (@AvailabilityLastViewedOn_Min IS NULL OR AvailabilityLastViewedOn >=  @AvailabilityLastViewedOn_Min)
 AND (@AvailabilityLastViewedOn_Max IS NULL OR AvailabilityLastViewedOn <=  @AvailabilityLastViewedOn_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@DeliveryDate IS NULL OR (@DeliveryDate = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate <> '###NULL###' AND DeliveryDate LIKE '%'+@DeliveryDate+'%'))
 AND (@DeliveryDate_Values IS NULL OR (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@ReturnDate IS NULL OR (@ReturnDate = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate <> '###NULL###' AND ReturnDate LIKE '%'+@ReturnDate+'%'))
 AND (@ReturnDate_Values IS NULL OR (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ReviewedBy IS NULL OR (@ReviewedBy = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy <> '###NULL###' AND ReviewedBy LIKE '%'+@ReviewedBy+'%'))
 AND (@ReviewedBy_Values IS NULL OR (@ReviewedBy_Values = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy_Values <> '###NULL###' AND ReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedBy_Values,','))))
 AND (@Reviewed_By IS NULL OR (@Reviewed_By = '###NULL###' AND Reviewed_By IS NULL ) OR (@Reviewed_By <> '###NULL###' AND Reviewed_By LIKE '%'+@Reviewed_By+'%'))
 AND (@Reviewed_By_Values IS NULL OR (@Reviewed_By_Values = '###NULL###' AND Reviewed_By IS NULL ) OR (@Reviewed_By_Values <> '###NULL###' AND Reviewed_By IN(SELECT Item FROM [dbo].CustomeSplit(@Reviewed_By_Values,','))))
 AND (@PulledBy IS NULL OR (@PulledBy = '###NULL###' AND PulledBy IS NULL ) OR (@PulledBy <> '###NULL###' AND PulledBy LIKE '%'+@PulledBy+'%'))
 AND (@PulledBy_Values IS NULL OR (@PulledBy_Values = '###NULL###' AND PulledBy IS NULL ) OR (@PulledBy_Values <> '###NULL###' AND PulledBy IN(SELECT Item FROM [dbo].CustomeSplit(@PulledBy_Values,','))))
 AND (@ShippedBy IS NULL OR (@ShippedBy = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy <> '###NULL###' AND ShippedBy LIKE '%'+@ShippedBy+'%'))
 AND (@ShippedBy_Values IS NULL OR (@ShippedBy_Values = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy_Values <> '###NULL###' AND ShippedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ShippedBy_Values,','))))
 AND (@ShippingID IS NULL OR (@ShippingID = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID <> '###NULL###' AND ShippingID LIKE '%'+@ShippingID+'%'))
 AND (@ShippingID_Values IS NULL OR (@ShippingID_Values = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID_Values <> '###NULL###' AND ShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@ShippingID_Values,','))))
 AND (@ShipCityState IS NULL OR (@ShipCityState = '###NULL###' AND ShipCityState IS NULL ) OR (@ShipCityState <> '###NULL###' AND ShipCityState LIKE '%'+@ShipCityState+'%'))
 AND (@ShipCityState_Values IS NULL OR (@ShipCityState_Values = '###NULL###' AND ShipCityState IS NULL ) OR (@ShipCityState_Values <> '###NULL###' AND ShipCityState IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCityState_Values,','))))
 AND (@ClientInterest IS NULL OR (@ClientInterest = '###NULL###' AND ClientInterest IS NULL ) OR (@ClientInterest <> '###NULL###' AND ClientInterest LIKE '%'+@ClientInterest+'%'))
 AND (@ClientInterest_Values IS NULL OR (@ClientInterest_Values = '###NULL###' AND ClientInterest IS NULL ) OR (@ClientInterest_Values <> '###NULL###' AND ClientInterest IN(SELECT Item FROM [dbo].CustomeSplit(@ClientInterest_Values,','))))
 AND (@CheckOutTime_Values IS NULL OR  (@CheckOutTime_Values = '###NULL###' AND CheckOutTime IS NULL ) OR (@CheckOutTime_Values <> '###NULL###' AND CheckOutTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckOutTime_Values,','))))
 AND (@CheckOutTime_Min IS NULL OR CheckOutTime >=  @CheckOutTime_Min)
 AND (@CheckOutTime_Max IS NULL OR CheckOutTime <=  @CheckOutTime_Max)
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND InterestType IS NULL ) OR (@InterestType_Values <> '###NULL###' AND InterestType IN(SELECT Item FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR InterestType >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR InterestType <=  @InterestType_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND QuoteTypeNo IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND QuoteTypeNo IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR QuoteTypeNo >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR QuoteTypeNo <=  @QuoteTypeNo_Max)
 AND (@LastReviewedBy IS NULL OR (@LastReviewedBy = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy <> '###NULL###' AND LastReviewedBy LIKE '%'+@LastReviewedBy+'%'))
 AND (@LastReviewedBy_Values IS NULL OR (@LastReviewedBy_Values = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy_Values <> '###NULL###' AND LastReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastReviewedBy_Values,','))))
 AND (@ReviewedDateTime_Values IS NULL OR  (@ReviewedDateTime_Values = '###NULL###' AND ReviewedDateTime IS NULL ) OR (@ReviewedDateTime_Values <> '###NULL###' AND ReviewedDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedDateTime_Values,','))))
 AND (@ReviewedDateTime_Min IS NULL OR ReviewedDateTime >=  @ReviewedDateTime_Min)
 AND (@ReviewedDateTime_Max IS NULL OR ReviewedDateTime <=  @ReviewedDateTime_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 AND (@Address IS NULL OR (@Address = '###NULL###' AND Address IS NULL ) OR (@Address <> '###NULL###' AND Address LIKE '%'+@Address+'%'))
 AND (@Address_Values IS NULL OR (@Address_Values = '###NULL###' AND Address IS NULL ) OR (@Address_Values <> '###NULL###' AND Address IN(SELECT Item FROM [dbo].CustomeSplit(@Address_Values,','))))
 AND (@RelCondition IS NULL OR (@RelCondition = '###NULL###' AND RelCondition IS NULL ) OR (@RelCondition <> '###NULL###' AND RelCondition LIKE '%'+@RelCondition+'%'))
 AND (@RelCondition_Values IS NULL OR (@RelCondition_Values = '###NULL###' AND RelCondition IS NULL ) OR (@RelCondition_Values <> '###NULL###' AND RelCondition IN(SELECT Item FROM [dbo].CustomeSplit(@RelCondition_Values,','))))
 AND (@Activity IS NULL OR (@Activity = '###NULL###' AND Activity IS NULL ) OR (@Activity <> '###NULL###' AND Activity LIKE '%'+@Activity+'%'))
 AND (@Activity_Values IS NULL OR (@Activity_Values = '###NULL###' AND Activity IS NULL ) OR (@Activity_Values <> '###NULL###' AND Activity IN(SELECT Item FROM [dbo].CustomeSplit(@Activity_Values,','))))
 AND (@ActivityToolTip IS NULL OR (@ActivityToolTip = '###NULL###' AND ActivityToolTip IS NULL ) OR (@ActivityToolTip <> '###NULL###' AND ActivityToolTip LIKE '%'+@ActivityToolTip+'%'))
 AND (@ActivityToolTip_Values IS NULL OR (@ActivityToolTip_Values = '###NULL###' AND ActivityToolTip IS NULL ) OR (@ActivityToolTip_Values <> '###NULL###' AND ActivityToolTip IN(SELECT Item FROM [dbo].CustomeSplit(@ActivityToolTip_Values,','))))
 AND (@PRODUCTIONFLAG IS NULL OR (@PRODUCTIONFLAG = '###NULL###' AND PRODUCTIONFLAG IS NULL ) OR (@PRODUCTIONFLAG <> '###NULL###' AND PRODUCTIONFLAG LIKE '%'+@PRODUCTIONFLAG+'%'))
 AND (@PRODUCTIONFLAG_Values IS NULL OR (@PRODUCTIONFLAG_Values = '###NULL###' AND PRODUCTIONFLAG IS NULL ) OR (@PRODUCTIONFLAG_Values <> '###NULL###' AND PRODUCTIONFLAG IN(SELECT Item FROM [dbo].CustomeSplit(@PRODUCTIONFLAG_Values,','))))
 
END
ELSE
BEGIN
SELECT CustName,CustID,QuoteEnteredDate,QuoteLastModified,QConfirmationDate,Rel_Short,ShortageQty,AvailabilityLastViewedBy,AvailabilityLastViewedOn,QuoteID,DeliveryDate,ReturnDate,SalesRep,ReviewedBy,Reviewed_By,PulledBy,ShippedBy,ShippingID,ShipCityState,ClientInterest,CheckOutTime,InterestType,BranchCode,BranchID,Total,QuoteTypeNo,LastReviewedBy,ReviewedDateTime,EmployeeID,Address,RelCondition,Activity,ActivityToolTip,PRODUCTIONFLAG FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_OrderPullData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.CustName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN VW_OrderPullData.CustName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN VW_OrderPullData.CustName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.CustID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN VW_OrderPullData.CustID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN VW_OrderPullData.CustID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteEnteredDate' OR @Sort_Column='QuoteEnteredDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.QuoteEnteredDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteEnteredDate' OR @Sort_Column='QuoteEnteredDate') AND @Sort_Ascending=1 THEN VW_OrderPullData.QuoteEnteredDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteEnteredDate' OR @Sort_Column='QuoteEnteredDate') AND @Sort_Ascending=0 THEN VW_OrderPullData.QuoteEnteredDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteLastModified' OR @Sort_Column='QuoteLastModified') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.QuoteLastModified IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteLastModified' OR @Sort_Column='QuoteLastModified') AND @Sort_Ascending=1 THEN VW_OrderPullData.QuoteLastModified ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteLastModified' OR @Sort_Column='QuoteLastModified') AND @Sort_Ascending=0 THEN VW_OrderPullData.QuoteLastModified ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.QConfirmationDate' OR @Sort_Column='QConfirmationDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.QConfirmationDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QConfirmationDate' OR @Sort_Column='QConfirmationDate') AND @Sort_Ascending=1 THEN VW_OrderPullData.QConfirmationDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QConfirmationDate' OR @Sort_Column='QConfirmationDate') AND @Sort_Ascending=0 THEN VW_OrderPullData.QConfirmationDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.Rel_Short' OR @Sort_Column='Rel_Short') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.Rel_Short IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Rel_Short' OR @Sort_Column='Rel_Short') AND @Sort_Ascending=1 THEN VW_OrderPullData.Rel_Short ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Rel_Short' OR @Sort_Column='Rel_Short') AND @Sort_Ascending=0 THEN VW_OrderPullData.Rel_Short ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShortageQty' OR @Sort_Column='ShortageQty') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ShortageQty IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShortageQty' OR @Sort_Column='ShortageQty') AND @Sort_Ascending=1 THEN VW_OrderPullData.ShortageQty ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShortageQty' OR @Sort_Column='ShortageQty') AND @Sort_Ascending=0 THEN VW_OrderPullData.ShortageQty ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.AvailabilityLastViewedBy' OR @Sort_Column='AvailabilityLastViewedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.AvailabilityLastViewedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.AvailabilityLastViewedBy' OR @Sort_Column='AvailabilityLastViewedBy') AND @Sort_Ascending=1 THEN VW_OrderPullData.AvailabilityLastViewedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.AvailabilityLastViewedBy' OR @Sort_Column='AvailabilityLastViewedBy') AND @Sort_Ascending=0 THEN VW_OrderPullData.AvailabilityLastViewedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.AvailabilityLastViewedOn' OR @Sort_Column='AvailabilityLastViewedOn') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.AvailabilityLastViewedOn IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.AvailabilityLastViewedOn' OR @Sort_Column='AvailabilityLastViewedOn') AND @Sort_Ascending=1 THEN VW_OrderPullData.AvailabilityLastViewedOn ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.AvailabilityLastViewedOn' OR @Sort_Column='AvailabilityLastViewedOn') AND @Sort_Ascending=0 THEN VW_OrderPullData.AvailabilityLastViewedOn ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.QuoteID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN VW_OrderPullData.QuoteID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=0 THEN VW_OrderPullData.QuoteID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.DeliveryDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN VW_OrderPullData.DeliveryDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN VW_OrderPullData.DeliveryDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ReturnDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN VW_OrderPullData.ReturnDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=0 THEN VW_OrderPullData.ReturnDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.SalesRep IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN VW_OrderPullData.SalesRep ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN VW_OrderPullData.SalesRep ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReviewedBy' OR @Sort_Column='ReviewedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ReviewedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReviewedBy' OR @Sort_Column='ReviewedBy') AND @Sort_Ascending=1 THEN VW_OrderPullData.ReviewedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReviewedBy' OR @Sort_Column='ReviewedBy') AND @Sort_Ascending=0 THEN VW_OrderPullData.ReviewedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.Reviewed_By' OR @Sort_Column='Reviewed_By') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.Reviewed_By IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Reviewed_By' OR @Sort_Column='Reviewed_By') AND @Sort_Ascending=1 THEN VW_OrderPullData.Reviewed_By ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Reviewed_By' OR @Sort_Column='Reviewed_By') AND @Sort_Ascending=0 THEN VW_OrderPullData.Reviewed_By ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.PulledBy' OR @Sort_Column='PulledBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.PulledBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.PulledBy' OR @Sort_Column='PulledBy') AND @Sort_Ascending=1 THEN VW_OrderPullData.PulledBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.PulledBy' OR @Sort_Column='PulledBy') AND @Sort_Ascending=0 THEN VW_OrderPullData.PulledBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShippedBy' OR @Sort_Column='ShippedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ShippedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShippedBy' OR @Sort_Column='ShippedBy') AND @Sort_Ascending=1 THEN VW_OrderPullData.ShippedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShippedBy' OR @Sort_Column='ShippedBy') AND @Sort_Ascending=0 THEN VW_OrderPullData.ShippedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ShippingID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=1 THEN VW_OrderPullData.ShippingID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=0 THEN VW_OrderPullData.ShippingID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShipCityState' OR @Sort_Column='ShipCityState') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ShipCityState IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShipCityState' OR @Sort_Column='ShipCityState') AND @Sort_Ascending=1 THEN VW_OrderPullData.ShipCityState ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ShipCityState' OR @Sort_Column='ShipCityState') AND @Sort_Ascending=0 THEN VW_OrderPullData.ShipCityState ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ClientInterest' OR @Sort_Column='ClientInterest') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ClientInterest IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ClientInterest' OR @Sort_Column='ClientInterest') AND @Sort_Ascending=1 THEN VW_OrderPullData.ClientInterest ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ClientInterest' OR @Sort_Column='ClientInterest') AND @Sort_Ascending=0 THEN VW_OrderPullData.ClientInterest ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.CheckOutTime' OR @Sort_Column='CheckOutTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.CheckOutTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.CheckOutTime' OR @Sort_Column='CheckOutTime') AND @Sort_Ascending=1 THEN VW_OrderPullData.CheckOutTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.CheckOutTime' OR @Sort_Column='CheckOutTime') AND @Sort_Ascending=0 THEN VW_OrderPullData.CheckOutTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.InterestType IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=1 THEN VW_OrderPullData.InterestType ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=0 THEN VW_OrderPullData.InterestType ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.BranchCode IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN VW_OrderPullData.BranchCode ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=0 THEN VW_OrderPullData.BranchCode ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.BranchID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN VW_OrderPullData.BranchID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN VW_OrderPullData.BranchID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.Total IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN VW_OrderPullData.Total ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN VW_OrderPullData.Total ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.QuoteTypeNo IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=1 THEN VW_OrderPullData.QuoteTypeNo ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=0 THEN VW_OrderPullData.QuoteTypeNo ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.LastReviewedBy' OR @Sort_Column='LastReviewedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.LastReviewedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.LastReviewedBy' OR @Sort_Column='LastReviewedBy') AND @Sort_Ascending=1 THEN VW_OrderPullData.LastReviewedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.LastReviewedBy' OR @Sort_Column='LastReviewedBy') AND @Sort_Ascending=0 THEN VW_OrderPullData.LastReviewedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReviewedDateTime' OR @Sort_Column='ReviewedDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ReviewedDateTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReviewedDateTime' OR @Sort_Column='ReviewedDateTime') AND @Sort_Ascending=1 THEN VW_OrderPullData.ReviewedDateTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ReviewedDateTime' OR @Sort_Column='ReviewedDateTime') AND @Sort_Ascending=0 THEN VW_OrderPullData.ReviewedDateTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.EmployeeID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN VW_OrderPullData.EmployeeID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN VW_OrderPullData.EmployeeID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.Address' OR @Sort_Column='Address') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.Address IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Address' OR @Sort_Column='Address') AND @Sort_Ascending=1 THEN VW_OrderPullData.Address ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Address' OR @Sort_Column='Address') AND @Sort_Ascending=0 THEN VW_OrderPullData.Address ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.RelCondition' OR @Sort_Column='RelCondition') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.RelCondition IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.RelCondition' OR @Sort_Column='RelCondition') AND @Sort_Ascending=1 THEN VW_OrderPullData.RelCondition ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.RelCondition' OR @Sort_Column='RelCondition') AND @Sort_Ascending=0 THEN VW_OrderPullData.RelCondition ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.Activity' OR @Sort_Column='Activity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.Activity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Activity' OR @Sort_Column='Activity') AND @Sort_Ascending=1 THEN VW_OrderPullData.Activity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.Activity' OR @Sort_Column='Activity') AND @Sort_Ascending=0 THEN VW_OrderPullData.Activity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.ActivityToolTip' OR @Sort_Column='ActivityToolTip') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.ActivityToolTip IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ActivityToolTip' OR @Sort_Column='ActivityToolTip') AND @Sort_Ascending=1 THEN VW_OrderPullData.ActivityToolTip ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.ActivityToolTip' OR @Sort_Column='ActivityToolTip') AND @Sort_Ascending=0 THEN VW_OrderPullData.ActivityToolTip ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_OrderPullData.PRODUCTIONFLAG' OR @Sort_Column='PRODUCTIONFLAG') AND @Sort_Ascending=1 THEN (CASE WHEN VW_OrderPullData.PRODUCTIONFLAG IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.PRODUCTIONFLAG' OR @Sort_Column='PRODUCTIONFLAG') AND @Sort_Ascending=1 THEN VW_OrderPullData.PRODUCTIONFLAG ELSE NULL END,
CASE WHEN (@Sort_Column='VW_OrderPullData.PRODUCTIONFLAG' OR @Sort_Column='PRODUCTIONFLAG') AND @Sort_Ascending=0 THEN VW_OrderPullData.PRODUCTIONFLAG ELSE NULL END DESC
 ) AS RowNum, VW_OrderPullData.*
 FROM  VW_OrderPullData (NOLOCK)

 WHERE (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@QuoteEnteredDate_Values IS NULL OR  (@QuoteEnteredDate_Values = '###NULL###' AND QuoteEnteredDate IS NULL ) OR (@QuoteEnteredDate_Values <> '###NULL###' AND QuoteEnteredDate IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteEnteredDate_Values,','))))
 AND (@QuoteEnteredDate_Min IS NULL OR QuoteEnteredDate >=  @QuoteEnteredDate_Min)
 AND (@QuoteEnteredDate_Max IS NULL OR QuoteEnteredDate <=  @QuoteEnteredDate_Max)
 AND (@QuoteLastModified_Values IS NULL OR  (@QuoteLastModified_Values = '###NULL###' AND QuoteLastModified IS NULL ) OR (@QuoteLastModified_Values <> '###NULL###' AND QuoteLastModified IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteLastModified_Values,','))))
 AND (@QuoteLastModified_Min IS NULL OR QuoteLastModified >=  @QuoteLastModified_Min)
 AND (@QuoteLastModified_Max IS NULL OR QuoteLastModified <=  @QuoteLastModified_Max)
 AND (@QConfirmationDate_Values IS NULL OR  (@QConfirmationDate_Values = '###NULL###' AND QConfirmationDate IS NULL ) OR (@QConfirmationDate_Values <> '###NULL###' AND QConfirmationDate IN(SELECT Item FROM [dbo].CustomeSplit(@QConfirmationDate_Values,','))))
 AND (@QConfirmationDate_Min IS NULL OR QConfirmationDate >=  @QConfirmationDate_Min)
 AND (@QConfirmationDate_Max IS NULL OR QConfirmationDate <=  @QConfirmationDate_Max)
 AND (@Rel_Short IS NULL OR Rel_Short =  @Rel_Short)
 AND (@ShortageQty_Values IS NULL OR  (@ShortageQty_Values = '###NULL###' AND ShortageQty IS NULL ) OR (@ShortageQty_Values <> '###NULL###' AND ShortageQty IN(SELECT Item FROM [dbo].CustomeSplit(@ShortageQty_Values,','))))
 AND (@ShortageQty_Min IS NULL OR ShortageQty >=  @ShortageQty_Min)
 AND (@ShortageQty_Max IS NULL OR ShortageQty <=  @ShortageQty_Max)
 AND (@AvailabilityLastViewedBy IS NULL OR (@AvailabilityLastViewedBy = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy <> '###NULL###' AND AvailabilityLastViewedBy LIKE '%'+@AvailabilityLastViewedBy+'%'))
 AND (@AvailabilityLastViewedBy_Values IS NULL OR (@AvailabilityLastViewedBy_Values = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy_Values <> '###NULL###' AND AvailabilityLastViewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedBy_Values,','))))
 AND (@AvailabilityLastViewedOn_Values IS NULL OR  (@AvailabilityLastViewedOn_Values = '###NULL###' AND AvailabilityLastViewedOn IS NULL ) OR (@AvailabilityLastViewedOn_Values <> '###NULL###' AND AvailabilityLastViewedOn IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedOn_Values,','))))
 AND (@AvailabilityLastViewedOn_Min IS NULL OR AvailabilityLastViewedOn >=  @AvailabilityLastViewedOn_Min)
 AND (@AvailabilityLastViewedOn_Max IS NULL OR AvailabilityLastViewedOn <=  @AvailabilityLastViewedOn_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@DeliveryDate IS NULL OR (@DeliveryDate = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate <> '###NULL###' AND DeliveryDate LIKE '%'+@DeliveryDate+'%'))
 AND (@DeliveryDate_Values IS NULL OR (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@ReturnDate IS NULL OR (@ReturnDate = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate <> '###NULL###' AND ReturnDate LIKE '%'+@ReturnDate+'%'))
 AND (@ReturnDate_Values IS NULL OR (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@ReviewedBy IS NULL OR (@ReviewedBy = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy <> '###NULL###' AND ReviewedBy LIKE '%'+@ReviewedBy+'%'))
 AND (@ReviewedBy_Values IS NULL OR (@ReviewedBy_Values = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy_Values <> '###NULL###' AND ReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedBy_Values,','))))
 AND (@Reviewed_By IS NULL OR (@Reviewed_By = '###NULL###' AND Reviewed_By IS NULL ) OR (@Reviewed_By <> '###NULL###' AND Reviewed_By LIKE '%'+@Reviewed_By+'%'))
 AND (@Reviewed_By_Values IS NULL OR (@Reviewed_By_Values = '###NULL###' AND Reviewed_By IS NULL ) OR (@Reviewed_By_Values <> '###NULL###' AND Reviewed_By IN(SELECT Item FROM [dbo].CustomeSplit(@Reviewed_By_Values,','))))
 AND (@PulledBy IS NULL OR (@PulledBy = '###NULL###' AND PulledBy IS NULL ) OR (@PulledBy <> '###NULL###' AND PulledBy LIKE '%'+@PulledBy+'%'))
 AND (@PulledBy_Values IS NULL OR (@PulledBy_Values = '###NULL###' AND PulledBy IS NULL ) OR (@PulledBy_Values <> '###NULL###' AND PulledBy IN(SELECT Item FROM [dbo].CustomeSplit(@PulledBy_Values,','))))
 AND (@ShippedBy IS NULL OR (@ShippedBy = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy <> '###NULL###' AND ShippedBy LIKE '%'+@ShippedBy+'%'))
 AND (@ShippedBy_Values IS NULL OR (@ShippedBy_Values = '###NULL###' AND ShippedBy IS NULL ) OR (@ShippedBy_Values <> '###NULL###' AND ShippedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ShippedBy_Values,','))))
 AND (@ShippingID IS NULL OR (@ShippingID = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID <> '###NULL###' AND ShippingID LIKE '%'+@ShippingID+'%'))
 AND (@ShippingID_Values IS NULL OR (@ShippingID_Values = '###NULL###' AND ShippingID IS NULL ) OR (@ShippingID_Values <> '###NULL###' AND ShippingID IN(SELECT Item FROM [dbo].CustomeSplit(@ShippingID_Values,','))))
 AND (@ShipCityState IS NULL OR (@ShipCityState = '###NULL###' AND ShipCityState IS NULL ) OR (@ShipCityState <> '###NULL###' AND ShipCityState LIKE '%'+@ShipCityState+'%'))
 AND (@ShipCityState_Values IS NULL OR (@ShipCityState_Values = '###NULL###' AND ShipCityState IS NULL ) OR (@ShipCityState_Values <> '###NULL###' AND ShipCityState IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCityState_Values,','))))
 AND (@ClientInterest IS NULL OR (@ClientInterest = '###NULL###' AND ClientInterest IS NULL ) OR (@ClientInterest <> '###NULL###' AND ClientInterest LIKE '%'+@ClientInterest+'%'))
 AND (@ClientInterest_Values IS NULL OR (@ClientInterest_Values = '###NULL###' AND ClientInterest IS NULL ) OR (@ClientInterest_Values <> '###NULL###' AND ClientInterest IN(SELECT Item FROM [dbo].CustomeSplit(@ClientInterest_Values,','))))
 AND (@CheckOutTime_Values IS NULL OR  (@CheckOutTime_Values = '###NULL###' AND CheckOutTime IS NULL ) OR (@CheckOutTime_Values <> '###NULL###' AND CheckOutTime IN(SELECT Item FROM [dbo].CustomeSplit(@CheckOutTime_Values,','))))
 AND (@CheckOutTime_Min IS NULL OR CheckOutTime >=  @CheckOutTime_Min)
 AND (@CheckOutTime_Max IS NULL OR CheckOutTime <=  @CheckOutTime_Max)
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND InterestType IS NULL ) OR (@InterestType_Values <> '###NULL###' AND InterestType IN(SELECT Item FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR InterestType >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR InterestType <=  @InterestType_Max)
 AND (@BranchCode IS NULL OR (@BranchCode = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode <> '###NULL###' AND BranchCode LIKE '%'+@BranchCode+'%'))
 AND (@BranchCode_Values IS NULL OR (@BranchCode_Values = '###NULL###' AND BranchCode IS NULL ) OR (@BranchCode_Values <> '###NULL###' AND BranchCode IN(SELECT Item FROM [dbo].CustomeSplit(@BranchCode_Values,','))))
 AND (@BranchID_Values IS NULL OR  (@BranchID_Values = '###NULL###' AND BranchID IS NULL ) OR (@BranchID_Values <> '###NULL###' AND BranchID IN(SELECT Item FROM [dbo].CustomeSplit(@BranchID_Values,','))))
 AND (@BranchID_Min IS NULL OR BranchID >=  @BranchID_Min)
 AND (@BranchID_Max IS NULL OR BranchID <=  @BranchID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND QuoteTypeNo IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND QuoteTypeNo IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR QuoteTypeNo >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR QuoteTypeNo <=  @QuoteTypeNo_Max)
 AND (@LastReviewedBy IS NULL OR (@LastReviewedBy = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy <> '###NULL###' AND LastReviewedBy LIKE '%'+@LastReviewedBy+'%'))
 AND (@LastReviewedBy_Values IS NULL OR (@LastReviewedBy_Values = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy_Values <> '###NULL###' AND LastReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastReviewedBy_Values,','))))
 AND (@ReviewedDateTime_Values IS NULL OR  (@ReviewedDateTime_Values = '###NULL###' AND ReviewedDateTime IS NULL ) OR (@ReviewedDateTime_Values <> '###NULL###' AND ReviewedDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedDateTime_Values,','))))
 AND (@ReviewedDateTime_Min IS NULL OR ReviewedDateTime >=  @ReviewedDateTime_Min)
 AND (@ReviewedDateTime_Max IS NULL OR ReviewedDateTime <=  @ReviewedDateTime_Max)
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 AND (@Address IS NULL OR (@Address = '###NULL###' AND Address IS NULL ) OR (@Address <> '###NULL###' AND Address LIKE '%'+@Address+'%'))
 AND (@Address_Values IS NULL OR (@Address_Values = '###NULL###' AND Address IS NULL ) OR (@Address_Values <> '###NULL###' AND Address IN(SELECT Item FROM [dbo].CustomeSplit(@Address_Values,','))))
 AND (@RelCondition IS NULL OR (@RelCondition = '###NULL###' AND RelCondition IS NULL ) OR (@RelCondition <> '###NULL###' AND RelCondition LIKE '%'+@RelCondition+'%'))
 AND (@RelCondition_Values IS NULL OR (@RelCondition_Values = '###NULL###' AND RelCondition IS NULL ) OR (@RelCondition_Values <> '###NULL###' AND RelCondition IN(SELECT Item FROM [dbo].CustomeSplit(@RelCondition_Values,','))))
 AND (@Activity IS NULL OR (@Activity = '###NULL###' AND Activity IS NULL ) OR (@Activity <> '###NULL###' AND Activity LIKE '%'+@Activity+'%'))
 AND (@Activity_Values IS NULL OR (@Activity_Values = '###NULL###' AND Activity IS NULL ) OR (@Activity_Values <> '###NULL###' AND Activity IN(SELECT Item FROM [dbo].CustomeSplit(@Activity_Values,','))))
 AND (@ActivityToolTip IS NULL OR (@ActivityToolTip = '###NULL###' AND ActivityToolTip IS NULL ) OR (@ActivityToolTip <> '###NULL###' AND ActivityToolTip LIKE '%'+@ActivityToolTip+'%'))
 AND (@ActivityToolTip_Values IS NULL OR (@ActivityToolTip_Values = '###NULL###' AND ActivityToolTip IS NULL ) OR (@ActivityToolTip_Values <> '###NULL###' AND ActivityToolTip IN(SELECT Item FROM [dbo].CustomeSplit(@ActivityToolTip_Values,','))))
 AND (@PRODUCTIONFLAG IS NULL OR (@PRODUCTIONFLAG = '###NULL###' AND PRODUCTIONFLAG IS NULL ) OR (@PRODUCTIONFLAG <> '###NULL###' AND PRODUCTIONFLAG LIKE '%'+@PRODUCTIONFLAG+'%'))
 AND (@PRODUCTIONFLAG_Values IS NULL OR (@PRODUCTIONFLAG_Values = '###NULL###' AND PRODUCTIONFLAG IS NULL ) OR (@PRODUCTIONFLAG_Values <> '###NULL###' AND PRODUCTIONFLAG IN(SELECT Item FROM [dbo].CustomeSplit(@PRODUCTIONFLAG_Values,','))))
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

/****** Object:  StoredProcedure [dbo].[spr_tb_VW_PODeliveryData_View_Search]    Script Date: 20-07-2020 09:11:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[spr_tb_VW_PODeliveryData_View_Search]

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
@PurDeliveryDate_Values nvarchar(max) = NULL,
@PurDeliveryDate_Min datetime = NULL,
@PurDeliveryDate_Max datetime = NULL,
@PurReturnDate_Values nvarchar(max) = NULL,
@PurReturnDate_Min datetime = NULL,
@PurReturnDate_Max datetime = NULL,
@IssuedBy nvarchar(50) = NULL,
@IssuedBy_Values nvarchar(max) = NULL,
@PickupBy nvarchar(50) = NULL,
@PickupBy_Values nvarchar(max) = NULL,
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
@EmployeeID_Values nvarchar(max) = NULL,
@EmployeeID_Min int = NULL,
@EmployeeID_Max int = NULL,
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
SET @ResultCount = (SELECT COUNT(*) FROM VW_PODeliveryData (NOLOCK)
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
 AND (@PurDeliveryDate_Values IS NULL OR  (@PurDeliveryDate_Values = '###NULL###' AND PurDeliveryDate IS NULL ) OR (@PurDeliveryDate_Values <> '###NULL###' AND PurDeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@PurDeliveryDate_Values,','))))
 AND (@PurDeliveryDate_Min IS NULL OR PurDeliveryDate >=  @PurDeliveryDate_Min)
 AND (@PurDeliveryDate_Max IS NULL OR PurDeliveryDate <=  @PurDeliveryDate_Max)
 AND (@PurReturnDate_Values IS NULL OR  (@PurReturnDate_Values = '###NULL###' AND PurReturnDate IS NULL ) OR (@PurReturnDate_Values <> '###NULL###' AND PurReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@PurReturnDate_Values,','))))
 AND (@PurReturnDate_Min IS NULL OR PurReturnDate >=  @PurReturnDate_Min)
 AND (@PurReturnDate_Max IS NULL OR PurReturnDate <=  @PurReturnDate_Max)
 AND (@IssuedBy IS NULL OR (@IssuedBy = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy <> '###NULL###' AND IssuedBy LIKE '%'+@IssuedBy+'%'))
 AND (@IssuedBy_Values IS NULL OR (@IssuedBy_Values = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy_Values <> '###NULL###' AND IssuedBy IN(SELECT Item FROM [dbo].CustomeSplit(@IssuedBy_Values,','))))
 AND (@PickupBy IS NULL OR (@PickupBy = '###NULL###' AND PickupBy IS NULL ) OR (@PickupBy <> '###NULL###' AND PickupBy LIKE '%'+@PickupBy+'%'))
 AND (@PickupBy_Values IS NULL OR (@PickupBy_Values = '###NULL###' AND PickupBy IS NULL ) OR (@PickupBy_Values <> '###NULL###' AND PickupBy IN(SELECT Item FROM [dbo].CustomeSplit(@PickupBy_Values,','))))
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
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT BranchID,BranchName,BranchCode,CustID,Vendor,PurchaseID,DeliveryDate,ReturnDate,PurDeliveryDate,PurReturnDate,IssuedBy,PickupBy,Client,ShippingID,ShipAddr,ShipCity,ShowName,PurShipContact,PurShipAdd2,State,POStatus,PurApprovedBy,Total,QuoteCustName,StateTooltip,EmployeeID FROM  VW_PODeliveryData (NOLOCK)

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
 AND (@PurDeliveryDate_Values IS NULL OR  (@PurDeliveryDate_Values = '###NULL###' AND PurDeliveryDate IS NULL ) OR (@PurDeliveryDate_Values <> '###NULL###' AND PurDeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@PurDeliveryDate_Values,','))))
 AND (@PurDeliveryDate_Min IS NULL OR PurDeliveryDate >=  @PurDeliveryDate_Min)
 AND (@PurDeliveryDate_Max IS NULL OR PurDeliveryDate <=  @PurDeliveryDate_Max)
 AND (@PurReturnDate_Values IS NULL OR  (@PurReturnDate_Values = '###NULL###' AND PurReturnDate IS NULL ) OR (@PurReturnDate_Values <> '###NULL###' AND PurReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@PurReturnDate_Values,','))))
 AND (@PurReturnDate_Min IS NULL OR PurReturnDate >=  @PurReturnDate_Min)
 AND (@PurReturnDate_Max IS NULL OR PurReturnDate <=  @PurReturnDate_Max)
 AND (@IssuedBy IS NULL OR (@IssuedBy = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy <> '###NULL###' AND IssuedBy LIKE '%'+@IssuedBy+'%'))
 AND (@IssuedBy_Values IS NULL OR (@IssuedBy_Values = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy_Values <> '###NULL###' AND IssuedBy IN(SELECT Item FROM [dbo].CustomeSplit(@IssuedBy_Values,','))))
 AND (@PickupBy IS NULL OR (@PickupBy = '###NULL###' AND PickupBy IS NULL ) OR (@PickupBy <> '###NULL###' AND PickupBy LIKE '%'+@PickupBy+'%'))
 AND (@PickupBy_Values IS NULL OR (@PickupBy_Values = '###NULL###' AND PickupBy IS NULL ) OR (@PickupBy_Values <> '###NULL###' AND PickupBy IN(SELECT Item FROM [dbo].CustomeSplit(@PickupBy_Values,','))))
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
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 
END
ELSE
BEGIN
SELECT BranchID,BranchName,BranchCode,CustID,Vendor,PurchaseID,DeliveryDate,ReturnDate,PurDeliveryDate,PurReturnDate,IssuedBy,PickupBy,Client,ShippingID,ShipAddr,ShipCity,ShowName,PurShipContact,PurShipAdd2,State,POStatus,PurApprovedBy,Total,QuoteCustName,StateTooltip,EmployeeID FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.BranchID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=1 THEN VW_PODeliveryData.BranchID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchID' OR @Sort_Column='BranchID') AND @Sort_Ascending=0 THEN VW_PODeliveryData.BranchID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.BranchName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=1 THEN VW_PODeliveryData.BranchName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchName' OR @Sort_Column='BranchName') AND @Sort_Ascending=0 THEN VW_PODeliveryData.BranchName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.BranchCode IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=1 THEN VW_PODeliveryData.BranchCode ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.BranchCode' OR @Sort_Column='BranchCode') AND @Sort_Ascending=0 THEN VW_PODeliveryData.BranchCode ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.CustID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN VW_PODeliveryData.CustID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN VW_PODeliveryData.CustID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.Vendor IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=1 THEN VW_PODeliveryData.Vendor ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=0 THEN VW_PODeliveryData.Vendor ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.PurchaseID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=1 THEN VW_PODeliveryData.PurchaseID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=0 THEN VW_PODeliveryData.PurchaseID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.DeliveryDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN VW_PODeliveryData.DeliveryDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN VW_PODeliveryData.DeliveryDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.ReturnDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN VW_PODeliveryData.ReturnDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=0 THEN VW_PODeliveryData.ReturnDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurDeliveryDate' OR @Sort_Column='PurDeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.PurDeliveryDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurDeliveryDate' OR @Sort_Column='PurDeliveryDate') AND @Sort_Ascending=1 THEN VW_PODeliveryData.PurDeliveryDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurDeliveryDate' OR @Sort_Column='PurDeliveryDate') AND @Sort_Ascending=0 THEN VW_PODeliveryData.PurDeliveryDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurReturnDate' OR @Sort_Column='PurReturnDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.PurReturnDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurReturnDate' OR @Sort_Column='PurReturnDate') AND @Sort_Ascending=1 THEN VW_PODeliveryData.PurReturnDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurReturnDate' OR @Sort_Column='PurReturnDate') AND @Sort_Ascending=0 THEN VW_PODeliveryData.PurReturnDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.IssuedBy' OR @Sort_Column='IssuedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.IssuedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.IssuedBy' OR @Sort_Column='IssuedBy') AND @Sort_Ascending=1 THEN VW_PODeliveryData.IssuedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.IssuedBy' OR @Sort_Column='IssuedBy') AND @Sort_Ascending=0 THEN VW_PODeliveryData.IssuedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PickupBy' OR @Sort_Column='PickupBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.PickupBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PickupBy' OR @Sort_Column='PickupBy') AND @Sort_Ascending=1 THEN VW_PODeliveryData.PickupBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PickupBy' OR @Sort_Column='PickupBy') AND @Sort_Ascending=0 THEN VW_PODeliveryData.PickupBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.Client IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=1 THEN VW_PODeliveryData.Client ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=0 THEN VW_PODeliveryData.Client ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.ShippingID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=1 THEN VW_PODeliveryData.ShippingID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShippingID' OR @Sort_Column='ShippingID') AND @Sort_Ascending=0 THEN VW_PODeliveryData.ShippingID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShipAddr' OR @Sort_Column='ShipAddr') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.ShipAddr IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShipAddr' OR @Sort_Column='ShipAddr') AND @Sort_Ascending=1 THEN VW_PODeliveryData.ShipAddr ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShipAddr' OR @Sort_Column='ShipAddr') AND @Sort_Ascending=0 THEN VW_PODeliveryData.ShipAddr ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.ShipCity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=1 THEN VW_PODeliveryData.ShipCity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=0 THEN VW_PODeliveryData.ShipCity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.ShowName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=1 THEN VW_PODeliveryData.ShowName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.ShowName' OR @Sort_Column='ShowName') AND @Sort_Ascending=0 THEN VW_PODeliveryData.ShowName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurShipContact' OR @Sort_Column='PurShipContact') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.PurShipContact IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurShipContact' OR @Sort_Column='PurShipContact') AND @Sort_Ascending=1 THEN VW_PODeliveryData.PurShipContact ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurShipContact' OR @Sort_Column='PurShipContact') AND @Sort_Ascending=0 THEN VW_PODeliveryData.PurShipContact ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurShipAdd2' OR @Sort_Column='PurShipAdd2') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.PurShipAdd2 IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurShipAdd2' OR @Sort_Column='PurShipAdd2') AND @Sort_Ascending=1 THEN VW_PODeliveryData.PurShipAdd2 ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurShipAdd2' OR @Sort_Column='PurShipAdd2') AND @Sort_Ascending=0 THEN VW_PODeliveryData.PurShipAdd2 ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.State' OR @Sort_Column='State') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.State IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.State' OR @Sort_Column='State') AND @Sort_Ascending=1 THEN VW_PODeliveryData.State ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.State' OR @Sort_Column='State') AND @Sort_Ascending=0 THEN VW_PODeliveryData.State ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.POStatus' OR @Sort_Column='POStatus') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.POStatus IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.POStatus' OR @Sort_Column='POStatus') AND @Sort_Ascending=1 THEN VW_PODeliveryData.POStatus ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.POStatus' OR @Sort_Column='POStatus') AND @Sort_Ascending=0 THEN VW_PODeliveryData.POStatus ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurApprovedBy' OR @Sort_Column='PurApprovedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.PurApprovedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurApprovedBy' OR @Sort_Column='PurApprovedBy') AND @Sort_Ascending=1 THEN VW_PODeliveryData.PurApprovedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.PurApprovedBy' OR @Sort_Column='PurApprovedBy') AND @Sort_Ascending=0 THEN VW_PODeliveryData.PurApprovedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.Total IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN VW_PODeliveryData.Total ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN VW_PODeliveryData.Total ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.QuoteCustName' OR @Sort_Column='QuoteCustName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.QuoteCustName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.QuoteCustName' OR @Sort_Column='QuoteCustName') AND @Sort_Ascending=1 THEN VW_PODeliveryData.QuoteCustName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.QuoteCustName' OR @Sort_Column='QuoteCustName') AND @Sort_Ascending=0 THEN VW_PODeliveryData.QuoteCustName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.StateTooltip' OR @Sort_Column='StateTooltip') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.StateTooltip IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.StateTooltip' OR @Sort_Column='StateTooltip') AND @Sort_Ascending=1 THEN VW_PODeliveryData.StateTooltip ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.StateTooltip' OR @Sort_Column='StateTooltip') AND @Sort_Ascending=0 THEN VW_PODeliveryData.StateTooltip ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_PODeliveryData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_PODeliveryData.EmployeeID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=1 THEN VW_PODeliveryData.EmployeeID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_PODeliveryData.EmployeeID' OR @Sort_Column='EmployeeID') AND @Sort_Ascending=0 THEN VW_PODeliveryData.EmployeeID ELSE NULL END DESC
 ) AS RowNum, VW_PODeliveryData.*
 FROM  VW_PODeliveryData (NOLOCK)

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
 AND (@PurDeliveryDate_Values IS NULL OR  (@PurDeliveryDate_Values = '###NULL###' AND PurDeliveryDate IS NULL ) OR (@PurDeliveryDate_Values <> '###NULL###' AND PurDeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@PurDeliveryDate_Values,','))))
 AND (@PurDeliveryDate_Min IS NULL OR PurDeliveryDate >=  @PurDeliveryDate_Min)
 AND (@PurDeliveryDate_Max IS NULL OR PurDeliveryDate <=  @PurDeliveryDate_Max)
 AND (@PurReturnDate_Values IS NULL OR  (@PurReturnDate_Values = '###NULL###' AND PurReturnDate IS NULL ) OR (@PurReturnDate_Values <> '###NULL###' AND PurReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@PurReturnDate_Values,','))))
 AND (@PurReturnDate_Min IS NULL OR PurReturnDate >=  @PurReturnDate_Min)
 AND (@PurReturnDate_Max IS NULL OR PurReturnDate <=  @PurReturnDate_Max)
 AND (@IssuedBy IS NULL OR (@IssuedBy = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy <> '###NULL###' AND IssuedBy LIKE '%'+@IssuedBy+'%'))
 AND (@IssuedBy_Values IS NULL OR (@IssuedBy_Values = '###NULL###' AND IssuedBy IS NULL ) OR (@IssuedBy_Values <> '###NULL###' AND IssuedBy IN(SELECT Item FROM [dbo].CustomeSplit(@IssuedBy_Values,','))))
 AND (@PickupBy IS NULL OR (@PickupBy = '###NULL###' AND PickupBy IS NULL ) OR (@PickupBy <> '###NULL###' AND PickupBy LIKE '%'+@PickupBy+'%'))
 AND (@PickupBy_Values IS NULL OR (@PickupBy_Values = '###NULL###' AND PickupBy IS NULL ) OR (@PickupBy_Values <> '###NULL###' AND PickupBy IN(SELECT Item FROM [dbo].CustomeSplit(@PickupBy_Values,','))))
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
 AND (@EmployeeID_Values IS NULL OR  (@EmployeeID_Values = '###NULL###' AND EmployeeID IS NULL ) OR (@EmployeeID_Values <> '###NULL###' AND EmployeeID IN(SELECT Item FROM [dbo].CustomeSplit(@EmployeeID_Values,','))))
 AND (@EmployeeID_Min IS NULL OR EmployeeID >=  @EmployeeID_Min)
 AND (@EmployeeID_Max IS NULL OR EmployeeID <=  @EmployeeID_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO


