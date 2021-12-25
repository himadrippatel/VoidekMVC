GO
/****** Object:  View [dbo].[VW_CrossRentalData]    Script Date: 15-05-2020 23:30:54 ******/

CREATE VIEW [dbo].[VW_CrossRentalData]
AS
SELECT QuoteResult.QuoteId, QuoteResult.QuoteStatus, QuoteResult.Client, QuoteResult.DeliveryDate, QuoteResult.ShowStart, QuoteResult.ShowEnd, QuoteResult.ReturnDate, QuoteResult.QuoteDescription, SUM(QuoteResult.Quantity) 
                  AS Quantity, ISNULL(ROUND(SUM(QuoteResult.DiscountRate * QuoteResult.Period * QuoteResult.Quantity) / NULLIF (SUM(QuoteResult.Quantity), 0), 2), 0) AS UnitPrice, 
                  SUM(QuoteResult.DiscountRate * QuoteResult.Period * QuoteResult.Quantity) AS ExtendedPrice, ISNULL(POResult.PurchaseID, 0) AS PurchaseID, ISNULL(POResult.Vendor, N'') AS Vendor, ISNULL(POResult.UnitCost, 0) AS UnitCost, 
                  ISNULL(POResult.ExtendedCost, 0) AS ExtendedCost, ISNULL(QuoteResult.Venue, N'') AS Venue, ISNULL(QuoteResult.ShipCity, N'') AS ShipCity, ISNULL(QuoteResult.State, N'') AS State, 
                  ROUND(ISNULL((SUM(QuoteResult.DiscountRate * QuoteResult.Period * QuoteResult.Quantity) / NULLIF (POResult.ExtendedCost, 0) - 1) * 100, 0), 2) AS Recovery, QuoteResult.CustID, ISNULL(POResult.VendorID, 0) AS VendorID, 
                  ISNULL(POResult.PurSubQty, 0) AS PurSubQty
FROM     (SELECT q.QuoteID AS QuoteId, q.CustID, q.QuoteOriginatingBranchId AS BranchID, qt.QuoteType AS QuoteStatus, c.CustName AS Client, q.DeliveryDate, q.ShowStart, q.ShowEnd, q.ReturnDate, qs.QuoteDescription, qs.Quantity, 
                                    qs.Period, q.SalesRep, q.ProjectLead, q.InterestType, ISNULL(qs.DiscountRate, 0) AS DiscountRate, NULLIF (qs.Quantity, 0) * NULLIF (qs.DiscountRate, 0) AS ExtendedPrice, q.ShipAddr AS Venue, q.ShipCity, 
                                    ts.DropValue AS State
                  FROM      dbo.tblQuote AS q WITH (NOLOCK) INNER JOIN
                                    dbo.tblQuoteSub AS qs WITH (NOLOCK) ON q.QuoteID = qs.QuoteId AND qs.CategoryID = 579 INNER JOIN
                                    dbo.tblQuoteTypes AS qt WITH (NOLOCK) ON q.InterestType = qt.QuoteTypeNo LEFT OUTER JOIN
                                    dbo.tblCustomers AS c WITH (NOLOCK) ON q.CustID = c.CustID LEFT OUTER JOIN
                                    dbo.tblEmployee AS eSalesRep WITH (NOLOCK) ON q.SalesRep = eSalesRep.EmployeeID LEFT OUTER JOIN
                                    dbo.tblStates AS ts WITH (NOLOCK) ON q.ShipState = ts.rDropAbbr LEFT OUTER JOIN
                                    dbo.tblEmployee AS eProjectLead WITH (NOLOCK) ON q.ProjectLead = eProjectLead.EmployeeID INNER JOIN
                                    dbo.tblBranch AS b WITH (NOLOCK) ON q.QuoteOriginatingBranchId = b.BranchID) AS QuoteResult LEFT OUTER JOIN
                      (SELECT p.PurchaseID, p.PurQuoteId, ps.PurSubQty, Vendor.CustID AS VendorID, Vendor.CustName AS Vendor, ps.PurSubCategoryDescription AS PurSubCatDescription, ps.PurAssignedCategoryId AS PurCatId, 
                                         NULLIF (ps.PurSubDiscTotal, 0) / NULLIF (ps.PurSubQty, 0) AS UnitCost, ps.PurSubDiscTotal AS ExtendedCost
                       FROM      dbo.tblPurchase AS p WITH (NOLOCK) INNER JOIN
                                         dbo.tblPurchaseSub AS ps WITH (NOLOCK) ON p.PurchaseID = ps.PurchaseID AND ps.PurAssignedCategoryId = 579 INNER JOIN
                                         dbo.tblCustomers AS Vendor WITH (NOLOCK) ON p.CustID = Vendor.CustID LEFT OUTER JOIN
                                         dbo.tblQuote AS q WITH (NOLOCK) ON p.PurQuoteId = q.QuoteID) AS POResult ON POResult.PurchaseID = QuoteResult.QuoteId AND QuoteResult.QuoteDescription = POResult.PurSubCatDescription
GROUP BY QuoteResult.QuoteId, QuoteResult.QuoteStatus, QuoteResult.Client, QuoteResult.DeliveryDate, QuoteResult.ShowStart, QuoteResult.ShowEnd, QuoteResult.ReturnDate, QuoteResult.QuoteDescription, QuoteResult.DiscountRate, 
                  POResult.PurchaseID, POResult.Vendor, POResult.UnitCost, POResult.ExtendedCost, QuoteResult.Venue, QuoteResult.ShipCity, QuoteResult.State, ISNULL((NULLIF (QuoteResult.ExtendedPrice, 0) / NULLIF (POResult.ExtendedCost, 0) 
                  - 1) * 100, 0), QuoteResult.CustID, POResult.VendorID, POResult.PurSubQty
GO


CREATE PROCEDURE [dbo].[spr_tb_VW_CrossRentalData_View_Search]

@ResultCount INT OUTPUT,
@QuoteId_Values nvarchar(max) = NULL,
@QuoteId_Min int = NULL,
@QuoteId_Max int = NULL,
@QuoteStatus nvarchar(50) = NULL,
@QuoteStatus_Values nvarchar(max) = NULL,
@Client nvarchar(255) = NULL,
@Client_Values nvarchar(max) = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@DeliveryDate_Min datetime = NULL,
@DeliveryDate_Max datetime = NULL,
@ShowStart_Values nvarchar(max) = NULL,
@ShowStart_Min datetime = NULL,
@ShowStart_Max datetime = NULL,
@ShowEnd_Values nvarchar(max) = NULL,
@ShowEnd_Min datetime = NULL,
@ShowEnd_Max datetime = NULL,
@ReturnDate_Values nvarchar(max) = NULL,
@ReturnDate_Min datetime = NULL,
@ReturnDate_Max datetime = NULL,
@QuoteDescription nvarchar(1024) = NULL,
@QuoteDescription_Values nvarchar(max) = NULL,
@Quantity float = NULL,
@UnitPrice float = NULL,
@ExtendedPrice float = NULL,
@PurchaseID_Values nvarchar(max) = NULL,
@PurchaseID_Min int = NULL,
@PurchaseID_Max int = NULL,
@Vendor nvarchar(255) = NULL,
@Vendor_Values nvarchar(max) = NULL,
@UnitCost_Values nvarchar(max) = NULL,
@UnitCost_Min money = NULL,
@UnitCost_Max money = NULL,
@ExtendedCost_Values nvarchar(max) = NULL,
@ExtendedCost_Min money = NULL,
@ExtendedCost_Max money = NULL,
@Venue nvarchar(100) = NULL,
@Venue_Values nvarchar(max) = NULL,
@ShipCity nvarchar(50) = NULL,
@ShipCity_Values nvarchar(max) = NULL,
@State nvarchar(25) = NULL,
@State_Values nvarchar(max) = NULL,
@Recovery float = NULL,
@CustID_Values nvarchar(max) = NULL,
@CustID_Min int = NULL,
@CustID_Max int = NULL,
@VendorID_Values nvarchar(max) = NULL,
@VendorID_Min int = NULL,
@VendorID_Max int = NULL,
@PurSubQty_Values nvarchar(max) = NULL,
@PurSubQty_Min smallint = NULL,
@PurSubQty_Max smallint = NULL,
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
SET @ResultCount = (SELECT COUNT(*) FROM VW_CrossRentalData (NOLOCK)
 WHERE (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND QuoteId IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND QuoteId IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteId_Values),','))))
 AND (@QuoteId_Min IS NULL OR QuoteId >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR QuoteId <=  @QuoteId_Max)
 AND (@QuoteStatus IS NULL OR (@QuoteStatus = '###NULL###' AND QuoteStatus IS NULL ) OR (@QuoteStatus <> '###NULL###' AND QuoteStatus LIKE '%'+@QuoteStatus+'%'))
 AND (@QuoteStatus_Values IS NULL OR (@QuoteStatus_Values = '###NULL###' AND QuoteStatus IS NULL ) OR (@QuoteStatus_Values <> '###NULL###' AND QuoteStatus IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteStatus_Values),','))))
 AND (@Client IS NULL OR (@Client = '###NULL###' AND Client IS NULL ) OR (@Client <> '###NULL###' AND Client LIKE '%'+@Client+'%'))
 AND (@Client_Values IS NULL OR (@Client_Values = '###NULL###' AND Client IS NULL ) OR (@Client_Values <> '###NULL###' AND Client IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Client_Values),','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@DeliveryDate_Values),','))))
 AND (@DeliveryDate_Min IS NULL OR DeliveryDate >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR DeliveryDate <=  @DeliveryDate_Max)
 AND (@ShowStart_Values IS NULL OR  (@ShowStart_Values = '###NULL###' AND ShowStart IS NULL ) OR (@ShowStart_Values <> '###NULL###' AND ShowStart IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShowStart_Values),','))))
 AND (@ShowStart_Min IS NULL OR ShowStart >=  @ShowStart_Min)
 AND (@ShowStart_Max IS NULL OR ShowStart <=  @ShowStart_Max)
 AND (@ShowEnd_Values IS NULL OR  (@ShowEnd_Values = '###NULL###' AND ShowEnd IS NULL ) OR (@ShowEnd_Values <> '###NULL###' AND ShowEnd IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShowEnd_Values),','))))
 AND (@ShowEnd_Min IS NULL OR ShowEnd >=  @ShowEnd_Min)
 AND (@ShowEnd_Max IS NULL OR ShowEnd <=  @ShowEnd_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ReturnDate_Values),','))))
 AND (@ReturnDate_Min IS NULL OR ReturnDate >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR ReturnDate <=  @ReturnDate_Max)
 AND (@QuoteDescription IS NULL OR (@QuoteDescription = '###NULL###' AND QuoteDescription IS NULL ) OR (@QuoteDescription <> '###NULL###' AND QuoteDescription LIKE '%'+@QuoteDescription+'%'))
 AND (@QuoteDescription_Values IS NULL OR (@QuoteDescription_Values = '###NULL###' AND QuoteDescription IS NULL ) OR (@QuoteDescription_Values <> '###NULL###' AND QuoteDescription IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteDescription_Values),','))))
 AND (@Quantity IS NULL OR Quantity =  @Quantity)
 AND (@UnitPrice IS NULL OR UnitPrice =  @UnitPrice)
 AND (@ExtendedPrice IS NULL OR ExtendedPrice =  @ExtendedPrice)
 AND (@PurchaseID_Values IS NULL OR  (@PurchaseID_Values = '###NULL###' AND PurchaseID IS NULL ) OR (@PurchaseID_Values <> '###NULL###' AND PurchaseID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@PurchaseID_Values),','))))
 AND (@PurchaseID_Min IS NULL OR PurchaseID >=  @PurchaseID_Min)
 AND (@PurchaseID_Max IS NULL OR PurchaseID <=  @PurchaseID_Max)
 AND (@Vendor IS NULL OR (@Vendor = '###NULL###' AND Vendor IS NULL ) OR (@Vendor <> '###NULL###' AND Vendor LIKE '%'+@Vendor+'%'))
 AND (@Vendor_Values IS NULL OR (@Vendor_Values = '###NULL###' AND Vendor IS NULL ) OR (@Vendor_Values <> '###NULL###' AND Vendor IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Vendor_Values),','))))
 AND (@UnitCost_Values IS NULL OR  (@UnitCost_Values = '###NULL###' AND UnitCost IS NULL ) OR (@UnitCost_Values <> '###NULL###' AND UnitCost IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@UnitCost_Values),','))))
 AND (@UnitCost_Min IS NULL OR UnitCost >=  @UnitCost_Min)
 AND (@UnitCost_Max IS NULL OR UnitCost <=  @UnitCost_Max)
 AND (@ExtendedCost_Values IS NULL OR  (@ExtendedCost_Values = '###NULL###' AND ExtendedCost IS NULL ) OR (@ExtendedCost_Values <> '###NULL###' AND ExtendedCost IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ExtendedCost_Values),','))))
 AND (@ExtendedCost_Min IS NULL OR ExtendedCost >=  @ExtendedCost_Min)
 AND (@ExtendedCost_Max IS NULL OR ExtendedCost <=  @ExtendedCost_Max)
 AND (@Venue IS NULL OR (@Venue = '###NULL###' AND Venue IS NULL ) OR (@Venue <> '###NULL###' AND Venue LIKE '%'+@Venue+'%'))
 AND (@Venue_Values IS NULL OR (@Venue_Values = '###NULL###' AND Venue IS NULL ) OR (@Venue_Values <> '###NULL###' AND Venue IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Venue_Values),','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShipCity_Values),','))))
 AND (@State IS NULL OR (@State = '###NULL###' AND State IS NULL ) OR (@State <> '###NULL###' AND State LIKE '%'+@State+'%'))
 AND (@State_Values IS NULL OR (@State_Values = '###NULL###' AND State IS NULL ) OR (@State_Values <> '###NULL###' AND State IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@State_Values),','))))
 AND (@Recovery IS NULL OR Recovery =  @Recovery)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@CustID_Values),','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@VendorID_Values IS NULL OR  (@VendorID_Values = '###NULL###' AND VendorID IS NULL ) OR (@VendorID_Values <> '###NULL###' AND VendorID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@VendorID_Values),','))))
 AND (@VendorID_Min IS NULL OR VendorID >=  @VendorID_Min)
 AND (@VendorID_Max IS NULL OR VendorID <=  @VendorID_Max)
 AND (@PurSubQty_Values IS NULL OR  (@PurSubQty_Values = '###NULL###' AND PurSubQty IS NULL ) OR (@PurSubQty_Values <> '###NULL###' AND PurSubQty IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@PurSubQty_Values),','))))
 AND (@PurSubQty_Min IS NULL OR PurSubQty >=  @PurSubQty_Min)
 AND (@PurSubQty_Max IS NULL OR PurSubQty <=  @PurSubQty_Max)
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT QuoteId,QuoteStatus,Client,DeliveryDate,ShowStart,ShowEnd,ReturnDate,QuoteDescription,Quantity,UnitPrice,ExtendedPrice,PurchaseID,Vendor,UnitCost,ExtendedCost,Venue,ShipCity,State,Recovery,CustID,VendorID,PurSubQty FROM  VW_CrossRentalData (NOLOCK)

 WHERE (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND QuoteId IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND QuoteId IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteId_Values),','))))
 AND (@QuoteId_Min IS NULL OR QuoteId >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR QuoteId <=  @QuoteId_Max)
 AND (@QuoteStatus IS NULL OR (@QuoteStatus = '###NULL###' AND QuoteStatus IS NULL ) OR (@QuoteStatus <> '###NULL###' AND QuoteStatus LIKE '%'+@QuoteStatus+'%'))
 AND (@QuoteStatus_Values IS NULL OR (@QuoteStatus_Values = '###NULL###' AND QuoteStatus IS NULL ) OR (@QuoteStatus_Values <> '###NULL###' AND QuoteStatus IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteStatus_Values),','))))
 AND (@Client IS NULL OR (@Client = '###NULL###' AND Client IS NULL ) OR (@Client <> '###NULL###' AND Client LIKE '%'+@Client+'%'))
 AND (@Client_Values IS NULL OR (@Client_Values = '###NULL###' AND Client IS NULL ) OR (@Client_Values <> '###NULL###' AND Client IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Client_Values),','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@DeliveryDate_Values),','))))
 AND (@DeliveryDate_Min IS NULL OR DeliveryDate >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR DeliveryDate <=  @DeliveryDate_Max)
 AND (@ShowStart_Values IS NULL OR  (@ShowStart_Values = '###NULL###' AND ShowStart IS NULL ) OR (@ShowStart_Values <> '###NULL###' AND ShowStart IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShowStart_Values),','))))
 AND (@ShowStart_Min IS NULL OR ShowStart >=  @ShowStart_Min)
 AND (@ShowStart_Max IS NULL OR ShowStart <=  @ShowStart_Max)
 AND (@ShowEnd_Values IS NULL OR  (@ShowEnd_Values = '###NULL###' AND ShowEnd IS NULL ) OR (@ShowEnd_Values <> '###NULL###' AND ShowEnd IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShowEnd_Values),','))))
 AND (@ShowEnd_Min IS NULL OR ShowEnd >=  @ShowEnd_Min)
 AND (@ShowEnd_Max IS NULL OR ShowEnd <=  @ShowEnd_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ReturnDate_Values),','))))
 AND (@ReturnDate_Min IS NULL OR ReturnDate >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR ReturnDate <=  @ReturnDate_Max)
 AND (@QuoteDescription IS NULL OR (@QuoteDescription = '###NULL###' AND QuoteDescription IS NULL ) OR (@QuoteDescription <> '###NULL###' AND QuoteDescription LIKE '%'+@QuoteDescription+'%'))
 AND (@QuoteDescription_Values IS NULL OR (@QuoteDescription_Values = '###NULL###' AND QuoteDescription IS NULL ) OR (@QuoteDescription_Values <> '###NULL###' AND QuoteDescription IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteDescription_Values),','))))
 AND (@Quantity IS NULL OR Quantity =  @Quantity)
 AND (@UnitPrice IS NULL OR UnitPrice =  @UnitPrice)
 AND (@ExtendedPrice IS NULL OR ExtendedPrice =  @ExtendedPrice)
 AND (@PurchaseID_Values IS NULL OR  (@PurchaseID_Values = '###NULL###' AND PurchaseID IS NULL ) OR (@PurchaseID_Values <> '###NULL###' AND PurchaseID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@PurchaseID_Values),','))))
 AND (@PurchaseID_Min IS NULL OR PurchaseID >=  @PurchaseID_Min)
 AND (@PurchaseID_Max IS NULL OR PurchaseID <=  @PurchaseID_Max)
 AND (@Vendor IS NULL OR (@Vendor = '###NULL###' AND Vendor IS NULL ) OR (@Vendor <> '###NULL###' AND Vendor LIKE '%'+@Vendor+'%'))
 AND (@Vendor_Values IS NULL OR (@Vendor_Values = '###NULL###' AND Vendor IS NULL ) OR (@Vendor_Values <> '###NULL###' AND Vendor IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Vendor_Values),','))))
 AND (@UnitCost_Values IS NULL OR  (@UnitCost_Values = '###NULL###' AND UnitCost IS NULL ) OR (@UnitCost_Values <> '###NULL###' AND UnitCost IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@UnitCost_Values),','))))
 AND (@UnitCost_Min IS NULL OR UnitCost >=  @UnitCost_Min)
 AND (@UnitCost_Max IS NULL OR UnitCost <=  @UnitCost_Max)
 AND (@ExtendedCost_Values IS NULL OR  (@ExtendedCost_Values = '###NULL###' AND ExtendedCost IS NULL ) OR (@ExtendedCost_Values <> '###NULL###' AND ExtendedCost IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ExtendedCost_Values),','))))
 AND (@ExtendedCost_Min IS NULL OR ExtendedCost >=  @ExtendedCost_Min)
 AND (@ExtendedCost_Max IS NULL OR ExtendedCost <=  @ExtendedCost_Max)
 AND (@Venue IS NULL OR (@Venue = '###NULL###' AND Venue IS NULL ) OR (@Venue <> '###NULL###' AND Venue LIKE '%'+@Venue+'%'))
 AND (@Venue_Values IS NULL OR (@Venue_Values = '###NULL###' AND Venue IS NULL ) OR (@Venue_Values <> '###NULL###' AND Venue IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Venue_Values),','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShipCity_Values),','))))
 AND (@State IS NULL OR (@State = '###NULL###' AND State IS NULL ) OR (@State <> '###NULL###' AND State LIKE '%'+@State+'%'))
 AND (@State_Values IS NULL OR (@State_Values = '###NULL###' AND State IS NULL ) OR (@State_Values <> '###NULL###' AND State IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@State_Values),','))))
 AND (@Recovery IS NULL OR Recovery =  @Recovery)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@CustID_Values),','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@VendorID_Values IS NULL OR  (@VendorID_Values = '###NULL###' AND VendorID IS NULL ) OR (@VendorID_Values <> '###NULL###' AND VendorID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@VendorID_Values),','))))
 AND (@VendorID_Min IS NULL OR VendorID >=  @VendorID_Min)
 AND (@VendorID_Max IS NULL OR VendorID <=  @VendorID_Max)
 AND (@PurSubQty_Values IS NULL OR  (@PurSubQty_Values = '###NULL###' AND PurSubQty IS NULL ) OR (@PurSubQty_Values <> '###NULL###' AND PurSubQty IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@PurSubQty_Values),','))))
 AND (@PurSubQty_Min IS NULL OR PurSubQty >=  @PurSubQty_Min)
 AND (@PurSubQty_Max IS NULL OR PurSubQty <=  @PurSubQty_Max)
 
END
ELSE
BEGIN
SELECT QuoteId,QuoteStatus,Client,DeliveryDate,ShowStart,ShowEnd,ReturnDate,QuoteDescription,Quantity,UnitPrice,ExtendedPrice,PurchaseID,Vendor,UnitCost,ExtendedCost,Venue,ShipCity,State,Recovery,CustID,VendorID,PurSubQty FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.QuoteId IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=1 THEN VW_CrossRentalData.QuoteId ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteId' OR @Sort_Column='QuoteId') AND @Sort_Ascending=0 THEN VW_CrossRentalData.QuoteId ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteStatus' OR @Sort_Column='QuoteStatus') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.QuoteStatus IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteStatus' OR @Sort_Column='QuoteStatus') AND @Sort_Ascending=1 THEN VW_CrossRentalData.QuoteStatus ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteStatus' OR @Sort_Column='QuoteStatus') AND @Sort_Ascending=0 THEN VW_CrossRentalData.QuoteStatus ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.Client IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=1 THEN VW_CrossRentalData.Client ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Client' OR @Sort_Column='Client') AND @Sort_Ascending=0 THEN VW_CrossRentalData.Client ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.DeliveryDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN VW_CrossRentalData.DeliveryDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN VW_CrossRentalData.DeliveryDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShowStart' OR @Sort_Column='ShowStart') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.ShowStart IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShowStart' OR @Sort_Column='ShowStart') AND @Sort_Ascending=1 THEN VW_CrossRentalData.ShowStart ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShowStart' OR @Sort_Column='ShowStart') AND @Sort_Ascending=0 THEN VW_CrossRentalData.ShowStart ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShowEnd' OR @Sort_Column='ShowEnd') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.ShowEnd IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShowEnd' OR @Sort_Column='ShowEnd') AND @Sort_Ascending=1 THEN VW_CrossRentalData.ShowEnd ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShowEnd' OR @Sort_Column='ShowEnd') AND @Sort_Ascending=0 THEN VW_CrossRentalData.ShowEnd ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.ReturnDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN VW_CrossRentalData.ReturnDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=0 THEN VW_CrossRentalData.ReturnDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteDescription' OR @Sort_Column='QuoteDescription') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.QuoteDescription IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteDescription' OR @Sort_Column='QuoteDescription') AND @Sort_Ascending=1 THEN VW_CrossRentalData.QuoteDescription ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.QuoteDescription' OR @Sort_Column='QuoteDescription') AND @Sort_Ascending=0 THEN VW_CrossRentalData.QuoteDescription ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Quantity' OR @Sort_Column='Quantity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.Quantity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Quantity' OR @Sort_Column='Quantity') AND @Sort_Ascending=1 THEN VW_CrossRentalData.Quantity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Quantity' OR @Sort_Column='Quantity') AND @Sort_Ascending=0 THEN VW_CrossRentalData.Quantity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.UnitPrice' OR @Sort_Column='UnitPrice') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.UnitPrice IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.UnitPrice' OR @Sort_Column='UnitPrice') AND @Sort_Ascending=1 THEN VW_CrossRentalData.UnitPrice ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.UnitPrice' OR @Sort_Column='UnitPrice') AND @Sort_Ascending=0 THEN VW_CrossRentalData.UnitPrice ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ExtendedPrice' OR @Sort_Column='ExtendedPrice') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.ExtendedPrice IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ExtendedPrice' OR @Sort_Column='ExtendedPrice') AND @Sort_Ascending=1 THEN VW_CrossRentalData.ExtendedPrice ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ExtendedPrice' OR @Sort_Column='ExtendedPrice') AND @Sort_Ascending=0 THEN VW_CrossRentalData.ExtendedPrice ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.PurchaseID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=1 THEN VW_CrossRentalData.PurchaseID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.PurchaseID' OR @Sort_Column='PurchaseID') AND @Sort_Ascending=0 THEN VW_CrossRentalData.PurchaseID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.Vendor IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=1 THEN VW_CrossRentalData.Vendor ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Vendor' OR @Sort_Column='Vendor') AND @Sort_Ascending=0 THEN VW_CrossRentalData.Vendor ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.UnitCost' OR @Sort_Column='UnitCost') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.UnitCost IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.UnitCost' OR @Sort_Column='UnitCost') AND @Sort_Ascending=1 THEN VW_CrossRentalData.UnitCost ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.UnitCost' OR @Sort_Column='UnitCost') AND @Sort_Ascending=0 THEN VW_CrossRentalData.UnitCost ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ExtendedCost' OR @Sort_Column='ExtendedCost') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.ExtendedCost IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ExtendedCost' OR @Sort_Column='ExtendedCost') AND @Sort_Ascending=1 THEN VW_CrossRentalData.ExtendedCost ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ExtendedCost' OR @Sort_Column='ExtendedCost') AND @Sort_Ascending=0 THEN VW_CrossRentalData.ExtendedCost ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Venue' OR @Sort_Column='Venue') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.Venue IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Venue' OR @Sort_Column='Venue') AND @Sort_Ascending=1 THEN VW_CrossRentalData.Venue ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Venue' OR @Sort_Column='Venue') AND @Sort_Ascending=0 THEN VW_CrossRentalData.Venue ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.ShipCity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=1 THEN VW_CrossRentalData.ShipCity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=0 THEN VW_CrossRentalData.ShipCity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.State' OR @Sort_Column='State') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.State IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.State' OR @Sort_Column='State') AND @Sort_Ascending=1 THEN VW_CrossRentalData.State ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.State' OR @Sort_Column='State') AND @Sort_Ascending=0 THEN VW_CrossRentalData.State ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Recovery' OR @Sort_Column='Recovery') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.Recovery IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Recovery' OR @Sort_Column='Recovery') AND @Sort_Ascending=1 THEN VW_CrossRentalData.Recovery ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.Recovery' OR @Sort_Column='Recovery') AND @Sort_Ascending=0 THEN VW_CrossRentalData.Recovery ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.CustID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN VW_CrossRentalData.CustID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN VW_CrossRentalData.CustID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.VendorID' OR @Sort_Column='VendorID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.VendorID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.VendorID' OR @Sort_Column='VendorID') AND @Sort_Ascending=1 THEN VW_CrossRentalData.VendorID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.VendorID' OR @Sort_Column='VendorID') AND @Sort_Ascending=0 THEN VW_CrossRentalData.VendorID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_CrossRentalData.PurSubQty' OR @Sort_Column='PurSubQty') AND @Sort_Ascending=1 THEN (CASE WHEN VW_CrossRentalData.PurSubQty IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.PurSubQty' OR @Sort_Column='PurSubQty') AND @Sort_Ascending=1 THEN VW_CrossRentalData.PurSubQty ELSE NULL END,
CASE WHEN (@Sort_Column='VW_CrossRentalData.PurSubQty' OR @Sort_Column='PurSubQty') AND @Sort_Ascending=0 THEN VW_CrossRentalData.PurSubQty ELSE NULL END DESC
 ) AS RowNum, VW_CrossRentalData.*
 FROM  VW_CrossRentalData (NOLOCK)

 WHERE (@QuoteId_Values IS NULL OR  (@QuoteId_Values = '###NULL###' AND QuoteId IS NULL ) OR (@QuoteId_Values <> '###NULL###' AND QuoteId IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteId_Values),','))))
 AND (@QuoteId_Min IS NULL OR QuoteId >=  @QuoteId_Min)
 AND (@QuoteId_Max IS NULL OR QuoteId <=  @QuoteId_Max)
 AND (@QuoteStatus IS NULL OR (@QuoteStatus = '###NULL###' AND QuoteStatus IS NULL ) OR (@QuoteStatus <> '###NULL###' AND QuoteStatus LIKE '%'+@QuoteStatus+'%'))
 AND (@QuoteStatus_Values IS NULL OR (@QuoteStatus_Values = '###NULL###' AND QuoteStatus IS NULL ) OR (@QuoteStatus_Values <> '###NULL###' AND QuoteStatus IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteStatus_Values),','))))
 AND (@Client IS NULL OR (@Client = '###NULL###' AND Client IS NULL ) OR (@Client <> '###NULL###' AND Client LIKE '%'+@Client+'%'))
 AND (@Client_Values IS NULL OR (@Client_Values = '###NULL###' AND Client IS NULL ) OR (@Client_Values <> '###NULL###' AND Client IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Client_Values),','))))
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@DeliveryDate_Values),','))))
 AND (@DeliveryDate_Min IS NULL OR DeliveryDate >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR DeliveryDate <=  @DeliveryDate_Max)
 AND (@ShowStart_Values IS NULL OR  (@ShowStart_Values = '###NULL###' AND ShowStart IS NULL ) OR (@ShowStart_Values <> '###NULL###' AND ShowStart IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShowStart_Values),','))))
 AND (@ShowStart_Min IS NULL OR ShowStart >=  @ShowStart_Min)
 AND (@ShowStart_Max IS NULL OR ShowStart <=  @ShowStart_Max)
 AND (@ShowEnd_Values IS NULL OR  (@ShowEnd_Values = '###NULL###' AND ShowEnd IS NULL ) OR (@ShowEnd_Values <> '###NULL###' AND ShowEnd IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShowEnd_Values),','))))
 AND (@ShowEnd_Min IS NULL OR ShowEnd >=  @ShowEnd_Min)
 AND (@ShowEnd_Max IS NULL OR ShowEnd <=  @ShowEnd_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ReturnDate_Values),','))))
 AND (@ReturnDate_Min IS NULL OR ReturnDate >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR ReturnDate <=  @ReturnDate_Max)
 AND (@QuoteDescription IS NULL OR (@QuoteDescription = '###NULL###' AND QuoteDescription IS NULL ) OR (@QuoteDescription <> '###NULL###' AND QuoteDescription LIKE '%'+@QuoteDescription+'%'))
 AND (@QuoteDescription_Values IS NULL OR (@QuoteDescription_Values = '###NULL###' AND QuoteDescription IS NULL ) OR (@QuoteDescription_Values <> '###NULL###' AND QuoteDescription IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@QuoteDescription_Values),','))))
 AND (@Quantity IS NULL OR Quantity =  @Quantity)
 AND (@UnitPrice IS NULL OR UnitPrice =  @UnitPrice)
 AND (@ExtendedPrice IS NULL OR ExtendedPrice =  @ExtendedPrice)
 AND (@PurchaseID_Values IS NULL OR  (@PurchaseID_Values = '###NULL###' AND PurchaseID IS NULL ) OR (@PurchaseID_Values <> '###NULL###' AND PurchaseID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@PurchaseID_Values),','))))
 AND (@PurchaseID_Min IS NULL OR PurchaseID >=  @PurchaseID_Min)
 AND (@PurchaseID_Max IS NULL OR PurchaseID <=  @PurchaseID_Max)
 AND (@Vendor IS NULL OR (@Vendor = '###NULL###' AND Vendor IS NULL ) OR (@Vendor <> '###NULL###' AND Vendor LIKE '%'+@Vendor+'%'))
 AND (@Vendor_Values IS NULL OR (@Vendor_Values = '###NULL###' AND Vendor IS NULL ) OR (@Vendor_Values <> '###NULL###' AND Vendor IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Vendor_Values),','))))
 AND (@UnitCost_Values IS NULL OR  (@UnitCost_Values = '###NULL###' AND UnitCost IS NULL ) OR (@UnitCost_Values <> '###NULL###' AND UnitCost IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@UnitCost_Values),','))))
 AND (@UnitCost_Min IS NULL OR UnitCost >=  @UnitCost_Min)
 AND (@UnitCost_Max IS NULL OR UnitCost <=  @UnitCost_Max)
 AND (@ExtendedCost_Values IS NULL OR  (@ExtendedCost_Values = '###NULL###' AND ExtendedCost IS NULL ) OR (@ExtendedCost_Values <> '###NULL###' AND ExtendedCost IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ExtendedCost_Values),','))))
 AND (@ExtendedCost_Min IS NULL OR ExtendedCost >=  @ExtendedCost_Min)
 AND (@ExtendedCost_Max IS NULL OR ExtendedCost <=  @ExtendedCost_Max)
 AND (@Venue IS NULL OR (@Venue = '###NULL###' AND Venue IS NULL ) OR (@Venue <> '###NULL###' AND Venue LIKE '%'+@Venue+'%'))
 AND (@Venue_Values IS NULL OR (@Venue_Values = '###NULL###' AND Venue IS NULL ) OR (@Venue_Values <> '###NULL###' AND Venue IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@Venue_Values),','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@ShipCity_Values),','))))
 AND (@State IS NULL OR (@State = '###NULL###' AND State IS NULL ) OR (@State <> '###NULL###' AND State LIKE '%'+@State+'%'))
 AND (@State_Values IS NULL OR (@State_Values = '###NULL###' AND State IS NULL ) OR (@State_Values <> '###NULL###' AND State IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@State_Values),','))))
 AND (@Recovery IS NULL OR Recovery =  @Recovery)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@CustID_Values),','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@VendorID_Values IS NULL OR  (@VendorID_Values = '###NULL###' AND VendorID IS NULL ) OR (@VendorID_Values <> '###NULL###' AND VendorID IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@VendorID_Values),','))))
 AND (@VendorID_Min IS NULL OR VendorID >=  @VendorID_Min)
 AND (@VendorID_Max IS NULL OR VendorID <=  @VendorID_Max)
 AND (@PurSubQty_Values IS NULL OR  (@PurSubQty_Values = '###NULL###' AND PurSubQty IS NULL ) OR (@PurSubQty_Values <> '###NULL###' AND PurSubQty IN(SELECT Item FROM [dbo].CustomeSplit([dbo].[AlliantSPParameterDecode](@PurSubQty_Values),','))))
 AND (@PurSubQty_Min IS NULL OR PurSubQty >=  @PurSubQty_Min)
 AND (@PurSubQty_Max IS NULL OR PurSubQty <=  @PurSubQty_Max)
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO



