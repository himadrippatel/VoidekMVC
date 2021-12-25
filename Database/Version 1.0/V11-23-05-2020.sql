CREATE PROCEDURE [dbo].[spr_tb_VW_DailyQuotesData_View_Search]

@ResultCount INT OUTPUT,
@CustName nvarchar(255) = NULL,
@CustName_Values nvarchar(max) = NULL,
@QuoteRentalID_Values nvarchar(max) = NULL,
@QuoteRentalID_Min int = NULL,
@QuoteRentalID_Max int = NULL,
@HasRentedBefore_Values nvarchar(max) = NULL,
@HasRentedBefore_Min int = NULL,
@HasRentedBefore_Max int = NULL,
@CustID_Values nvarchar(max) = NULL,
@CustID_Min int = NULL,
@CustID_Max int = NULL,
@OrderFrequency nvarchar(50) = NULL,
@OrderFrequency_Values nvarchar(max) = NULL,
@ProjectedRevenue_Values nvarchar(max) = NULL,
@ProjectedRevenue_Min money = NULL,
@ProjectedRevenue_Max money = NULL,
@custaccountrep nvarchar(50) = NULL,
@custaccountrep_Values nvarchar(max) = NULL,
@isShortage bit = NULL,
@ShortageQty_Values nvarchar(max) = NULL,
@ShortageQty_Min numeric(18,0) = NULL,
@ShortageQty_Max numeric(18,0) = NULL,
@InterestType_Values nvarchar(max) = NULL,
@InterestType_Min float = NULL,
@InterestType_Max float = NULL,
@QConfirmationDate_Values nvarchar(max) = NULL,
@QConfirmationDate_Min datetime = NULL,
@QConfirmationDate_Max datetime = NULL,
@QuoteConfirmationStatus nvarchar(100) = NULL,
@QuoteConfirmationStatus_Values nvarchar(max) = NULL,
@QuoteCancelNote nvarchar(1024) = NULL,
@QuoteCancelNote_Values nvarchar(max) = NULL,
@AvailabilityLastViewedBy nvarchar(100) = NULL,
@AvailabilityLastViewedBy_Values nvarchar(max) = NULL,
@AvailabilityLastViewedOn_Values nvarchar(max) = NULL,
@AvailabilityLastViewedOn_Min datetime = NULL,
@AvailabilityLastViewedOn_Max datetime = NULL,
@QuoteID_Values nvarchar(max) = NULL,
@QuoteID_Min int = NULL,
@QuoteID_Max int = NULL,
@Total_Values nvarchar(max) = NULL,
@Total_Min money = NULL,
@Total_Max money = NULL,
@EnteredDate_Values nvarchar(max) = NULL,
@EnteredDate_Min datetime = NULL,
@EnteredDate_Max datetime = NULL,
@LastModifiedDate_Values nvarchar(max) = NULL,
@LastModifiedDate_Min datetime = NULL,
@LastModifiedDate_Max datetime = NULL,
@DeliveryDate_Values nvarchar(max) = NULL,
@DeliveryDate_Min datetime = NULL,
@DeliveryDate_Max datetime = NULL,
@ReturnDate_Values nvarchar(max) = NULL,
@ReturnDate_Min datetime = NULL,
@ReturnDate_Max datetime = NULL,
@ShowDays_Values nvarchar(max) = NULL,
@ShowDays_Min int = NULL,
@ShowDays_Max int = NULL,
@SalesRep nvarchar(50) = NULL,
@SalesRep_Values nvarchar(max) = NULL,
@Employeeid_Values nvarchar(max) = NULL,
@Employeeid_Min int = NULL,
@Employeeid_Max int = NULL,
@ApprovedByEmp nvarchar(50) = NULL,
@ApprovedByEmp_Values nvarchar(max) = NULL,
@ReviewedBy nvarchar(50) = NULL,
@ReviewedBy_Values nvarchar(max) = NULL,
@ProjectLead nvarchar(50) = NULL,
@ProjectLead_Values nvarchar(max) = NULL,
@Activity nvarchar(50) = NULL,
@Activity_Values nvarchar(max) = NULL,
@Interest nvarchar(50) = NULL,
@Interest_Values nvarchar(max) = NULL,
@Branch nvarchar(50) = NULL,
@Branch_Values nvarchar(max) = NULL,
@ShipCity nvarchar(50) = NULL,
@ShipCity_Values nvarchar(max) = NULL,
@ShipState nvarchar(50) = NULL,
@ShipState_Values nvarchar(max) = NULL,
@approvedby_Values nvarchar(max) = NULL,
@approvedby_Min int = NULL,
@approvedby_Max int = NULL,
@approvedby2_Values nvarchar(max) = NULL,
@approvedby2_Min int = NULL,
@approvedby2_Max int = NULL,
@approvedby3_Values nvarchar(max) = NULL,
@approvedby3_Min int = NULL,
@approvedby3_Max int = NULL,
@QuoteJobCost_Values nvarchar(max) = NULL,
@QuoteJobCost_Min money = NULL,
@QuoteJobCost_Max money = NULL,
@PreJobCost_Values nvarchar(max) = NULL,
@PreJobCost_Min money = NULL,
@PreJobCost_Max money = NULL,
@PostJobCost_Values nvarchar(max) = NULL,
@PostJobCost_Min money = NULL,
@PostJobCost_Max money = NULL,
@Show nvarchar(255) = NULL,
@Show_Values nvarchar(max) = NULL,
@ProductionFlag varchar(1) = NULL,
@ProductionFlag_Values nvarchar(max) = NULL,
@QuoteTypeNo_Values nvarchar(max) = NULL,
@QuoteTypeNo_Min float = NULL,
@QuoteTypeNo_Max float = NULL,
@LastApprovedBy nvarchar(50) = NULL,
@LastApprovedBy_Values nvarchar(max) = NULL,
@QApprovedByDateTime_Values nvarchar(max) = NULL,
@QApprovedByDateTime_Min datetime = NULL,
@QApprovedByDateTime_Max datetime = NULL,
@LastReviewedBy nvarchar(50) = NULL,
@LastReviewedBy_Values nvarchar(max) = NULL,
@ReviewedDateTime_Values nvarchar(max) = NULL,
@ReviewedDateTime_Min datetime = NULL,
@ReviewedDateTime_Max datetime = NULL,
@LoadInDate_Values nvarchar(max) = NULL,
@LoadInDate_Min datetime = NULL,
@LoadInDate_Max datetime = NULL,
@LoadInTime nvarchar(50) = NULL,
@LoadInTime_Values nvarchar(max) = NULL,
@LoadOutDate_Values nvarchar(max) = NULL,
@LoadOutDate_Min datetime = NULL,
@LoadOutDate_Max datetime = NULL,
@LoadOutTime nvarchar(50) = NULL,
@LoadOutTime_Values nvarchar(max) = NULL,
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
SET @ResultCount = (SELECT COUNT(*) FROM VW_DailyQuotesData (NOLOCK)
 WHERE (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@QuoteRentalID_Values IS NULL OR  (@QuoteRentalID_Values = '###NULL###' AND QuoteRentalID IS NULL ) OR (@QuoteRentalID_Values <> '###NULL###' AND QuoteRentalID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteRentalID_Values,','))))
 AND (@QuoteRentalID_Min IS NULL OR QuoteRentalID >=  @QuoteRentalID_Min)
 AND (@QuoteRentalID_Max IS NULL OR QuoteRentalID <=  @QuoteRentalID_Max)
 AND (@HasRentedBefore_Values IS NULL OR  (@HasRentedBefore_Values = '###NULL###' AND HasRentedBefore IS NULL ) OR (@HasRentedBefore_Values <> '###NULL###' AND HasRentedBefore IN(SELECT Item FROM [dbo].CustomeSplit(@HasRentedBefore_Values,','))))
 AND (@HasRentedBefore_Min IS NULL OR HasRentedBefore >=  @HasRentedBefore_Min)
 AND (@HasRentedBefore_Max IS NULL OR HasRentedBefore <=  @HasRentedBefore_Max)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND OrderFrequency LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND OrderFrequency IN(SELECT Item FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@ProjectedRevenue_Values IS NULL OR  (@ProjectedRevenue_Values = '###NULL###' AND ProjectedRevenue IS NULL ) OR (@ProjectedRevenue_Values <> '###NULL###' AND ProjectedRevenue IN(SELECT Item FROM [dbo].CustomeSplit(@ProjectedRevenue_Values,','))))
 AND (@ProjectedRevenue_Min IS NULL OR ProjectedRevenue >=  @ProjectedRevenue_Min)
 AND (@ProjectedRevenue_Max IS NULL OR ProjectedRevenue <=  @ProjectedRevenue_Max)
 AND (@custaccountrep IS NULL OR (@custaccountrep = '###NULL###' AND custaccountrep IS NULL ) OR (@custaccountrep <> '###NULL###' AND custaccountrep LIKE '%'+@custaccountrep+'%'))
 AND (@custaccountrep_Values IS NULL OR (@custaccountrep_Values = '###NULL###' AND custaccountrep IS NULL ) OR (@custaccountrep_Values <> '###NULL###' AND custaccountrep IN(SELECT Item FROM [dbo].CustomeSplit(@custaccountrep_Values,','))))
 AND (@isShortage IS NULL OR isShortage =  @isShortage)
 AND (@ShortageQty_Values IS NULL OR  (@ShortageQty_Values = '###NULL###' AND ShortageQty IS NULL ) OR (@ShortageQty_Values <> '###NULL###' AND ShortageQty IN(SELECT Item FROM [dbo].CustomeSplit(@ShortageQty_Values,','))))
 AND (@ShortageQty_Min IS NULL OR ShortageQty >=  @ShortageQty_Min)
 AND (@ShortageQty_Max IS NULL OR ShortageQty <=  @ShortageQty_Max)
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND InterestType IS NULL ) OR (@InterestType_Values <> '###NULL###' AND InterestType IN(SELECT Item FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR InterestType >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR InterestType <=  @InterestType_Max)
 AND (@QConfirmationDate_Values IS NULL OR  (@QConfirmationDate_Values = '###NULL###' AND QConfirmationDate IS NULL ) OR (@QConfirmationDate_Values <> '###NULL###' AND QConfirmationDate IN(SELECT Item FROM [dbo].CustomeSplit(@QConfirmationDate_Values,','))))
 AND (@QConfirmationDate_Min IS NULL OR QConfirmationDate >=  @QConfirmationDate_Min)
 AND (@QConfirmationDate_Max IS NULL OR QConfirmationDate <=  @QConfirmationDate_Max)
 AND (@QuoteConfirmationStatus IS NULL OR (@QuoteConfirmationStatus = '###NULL###' AND QuoteConfirmationStatus IS NULL ) OR (@QuoteConfirmationStatus <> '###NULL###' AND QuoteConfirmationStatus LIKE '%'+@QuoteConfirmationStatus+'%'))
 AND (@QuoteConfirmationStatus_Values IS NULL OR (@QuoteConfirmationStatus_Values = '###NULL###' AND QuoteConfirmationStatus IS NULL ) OR (@QuoteConfirmationStatus_Values <> '###NULL###' AND QuoteConfirmationStatus IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteConfirmationStatus_Values,','))))
 AND (@QuoteCancelNote IS NULL OR (@QuoteCancelNote = '###NULL###' AND QuoteCancelNote IS NULL ) OR (@QuoteCancelNote <> '###NULL###' AND QuoteCancelNote LIKE '%'+@QuoteCancelNote+'%'))
 AND (@QuoteCancelNote_Values IS NULL OR (@QuoteCancelNote_Values = '###NULL###' AND QuoteCancelNote IS NULL ) OR (@QuoteCancelNote_Values <> '###NULL###' AND QuoteCancelNote IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteCancelNote_Values,','))))
 AND (@AvailabilityLastViewedBy IS NULL OR (@AvailabilityLastViewedBy = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy <> '###NULL###' AND AvailabilityLastViewedBy LIKE '%'+@AvailabilityLastViewedBy+'%'))
 AND (@AvailabilityLastViewedBy_Values IS NULL OR (@AvailabilityLastViewedBy_Values = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy_Values <> '###NULL###' AND AvailabilityLastViewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedBy_Values,','))))
 AND (@AvailabilityLastViewedOn_Values IS NULL OR  (@AvailabilityLastViewedOn_Values = '###NULL###' AND AvailabilityLastViewedOn IS NULL ) OR (@AvailabilityLastViewedOn_Values <> '###NULL###' AND AvailabilityLastViewedOn IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedOn_Values,','))))
 AND (@AvailabilityLastViewedOn_Min IS NULL OR AvailabilityLastViewedOn >=  @AvailabilityLastViewedOn_Min)
 AND (@AvailabilityLastViewedOn_Max IS NULL OR AvailabilityLastViewedOn <=  @AvailabilityLastViewedOn_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@EnteredDate_Values IS NULL OR  (@EnteredDate_Values = '###NULL###' AND EnteredDate IS NULL ) OR (@EnteredDate_Values <> '###NULL###' AND EnteredDate IN(SELECT Item FROM [dbo].CustomeSplit(@EnteredDate_Values,','))))
 AND (@EnteredDate_Min IS NULL OR EnteredDate >=  @EnteredDate_Min)
 AND (@EnteredDate_Max IS NULL OR EnteredDate <=  @EnteredDate_Max)
 AND (@LastModifiedDate_Values IS NULL OR  (@LastModifiedDate_Values = '###NULL###' AND LastModifiedDate IS NULL ) OR (@LastModifiedDate_Values <> '###NULL###' AND LastModifiedDate IN(SELECT Item FROM [dbo].CustomeSplit(@LastModifiedDate_Values,','))))
 AND (@LastModifiedDate_Min IS NULL OR LastModifiedDate >=  @LastModifiedDate_Min)
 AND (@LastModifiedDate_Max IS NULL OR LastModifiedDate <=  @LastModifiedDate_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR DeliveryDate >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR DeliveryDate <=  @DeliveryDate_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR ReturnDate >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR ReturnDate <=  @ReturnDate_Max)
 AND (@ShowDays_Values IS NULL OR  (@ShowDays_Values = '###NULL###' AND ShowDays IS NULL ) OR (@ShowDays_Values <> '###NULL###' AND ShowDays IN(SELECT Item FROM [dbo].CustomeSplit(@ShowDays_Values,','))))
 AND (@ShowDays_Min IS NULL OR ShowDays >=  @ShowDays_Min)
 AND (@ShowDays_Max IS NULL OR ShowDays <=  @ShowDays_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@Employeeid_Values IS NULL OR  (@Employeeid_Values = '###NULL###' AND Employeeid IS NULL ) OR (@Employeeid_Values <> '###NULL###' AND Employeeid IN(SELECT Item FROM [dbo].CustomeSplit(@Employeeid_Values,','))))
 AND (@Employeeid_Min IS NULL OR Employeeid >=  @Employeeid_Min)
 AND (@Employeeid_Max IS NULL OR Employeeid <=  @Employeeid_Max)
 AND (@ApprovedByEmp IS NULL OR (@ApprovedByEmp = '###NULL###' AND ApprovedByEmp IS NULL ) OR (@ApprovedByEmp <> '###NULL###' AND ApprovedByEmp LIKE '%'+@ApprovedByEmp+'%'))
 AND (@ApprovedByEmp_Values IS NULL OR (@ApprovedByEmp_Values = '###NULL###' AND ApprovedByEmp IS NULL ) OR (@ApprovedByEmp_Values <> '###NULL###' AND ApprovedByEmp IN(SELECT Item FROM [dbo].CustomeSplit(@ApprovedByEmp_Values,','))))
 AND (@ReviewedBy IS NULL OR (@ReviewedBy = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy <> '###NULL###' AND ReviewedBy LIKE '%'+@ReviewedBy+'%'))
 AND (@ReviewedBy_Values IS NULL OR (@ReviewedBy_Values = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy_Values <> '###NULL###' AND ReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedBy_Values,','))))
 AND (@ProjectLead IS NULL OR (@ProjectLead = '###NULL###' AND ProjectLead IS NULL ) OR (@ProjectLead <> '###NULL###' AND ProjectLead LIKE '%'+@ProjectLead+'%'))
 AND (@ProjectLead_Values IS NULL OR (@ProjectLead_Values = '###NULL###' AND ProjectLead IS NULL ) OR (@ProjectLead_Values <> '###NULL###' AND ProjectLead IN(SELECT Item FROM [dbo].CustomeSplit(@ProjectLead_Values,','))))
 AND (@Activity IS NULL OR (@Activity = '###NULL###' AND Activity IS NULL ) OR (@Activity <> '###NULL###' AND Activity LIKE '%'+@Activity+'%'))
 AND (@Activity_Values IS NULL OR (@Activity_Values = '###NULL###' AND Activity IS NULL ) OR (@Activity_Values <> '###NULL###' AND Activity IN(SELECT Item FROM [dbo].CustomeSplit(@Activity_Values,','))))
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND Interest LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND Interest IS NULL ) OR (@Interest_Values <> '###NULL###' AND Interest IN(SELECT Item FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@Branch IS NULL OR (@Branch = '###NULL###' AND Branch IS NULL ) OR (@Branch <> '###NULL###' AND Branch LIKE '%'+@Branch+'%'))
 AND (@Branch_Values IS NULL OR (@Branch_Values = '###NULL###' AND Branch IS NULL ) OR (@Branch_Values <> '###NULL###' AND Branch IN(SELECT Item FROM [dbo].CustomeSplit(@Branch_Values,','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCity_Values,','))))
 AND (@ShipState IS NULL OR (@ShipState = '###NULL###' AND ShipState IS NULL ) OR (@ShipState <> '###NULL###' AND ShipState LIKE '%'+@ShipState+'%'))
 AND (@ShipState_Values IS NULL OR (@ShipState_Values = '###NULL###' AND ShipState IS NULL ) OR (@ShipState_Values <> '###NULL###' AND ShipState IN(SELECT Item FROM [dbo].CustomeSplit(@ShipState_Values,','))))
 AND (@approvedby_Values IS NULL OR  (@approvedby_Values = '###NULL###' AND approvedby IS NULL ) OR (@approvedby_Values <> '###NULL###' AND approvedby IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby_Values,','))))
 AND (@approvedby_Min IS NULL OR approvedby >=  @approvedby_Min)
 AND (@approvedby_Max IS NULL OR approvedby <=  @approvedby_Max)
 AND (@approvedby2_Values IS NULL OR  (@approvedby2_Values = '###NULL###' AND approvedby2 IS NULL ) OR (@approvedby2_Values <> '###NULL###' AND approvedby2 IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby2_Values,','))))
 AND (@approvedby2_Min IS NULL OR approvedby2 >=  @approvedby2_Min)
 AND (@approvedby2_Max IS NULL OR approvedby2 <=  @approvedby2_Max)
 AND (@approvedby3_Values IS NULL OR  (@approvedby3_Values = '###NULL###' AND approvedby3 IS NULL ) OR (@approvedby3_Values <> '###NULL###' AND approvedby3 IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby3_Values,','))))
 AND (@approvedby3_Min IS NULL OR approvedby3 >=  @approvedby3_Min)
 AND (@approvedby3_Max IS NULL OR approvedby3 <=  @approvedby3_Max)
 AND (@QuoteJobCost_Values IS NULL OR  (@QuoteJobCost_Values = '###NULL###' AND QuoteJobCost IS NULL ) OR (@QuoteJobCost_Values <> '###NULL###' AND QuoteJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteJobCost_Values,','))))
 AND (@QuoteJobCost_Min IS NULL OR QuoteJobCost >=  @QuoteJobCost_Min)
 AND (@QuoteJobCost_Max IS NULL OR QuoteJobCost <=  @QuoteJobCost_Max)
 AND (@PreJobCost_Values IS NULL OR  (@PreJobCost_Values = '###NULL###' AND PreJobCost IS NULL ) OR (@PreJobCost_Values <> '###NULL###' AND PreJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@PreJobCost_Values,','))))
 AND (@PreJobCost_Min IS NULL OR PreJobCost >=  @PreJobCost_Min)
 AND (@PreJobCost_Max IS NULL OR PreJobCost <=  @PreJobCost_Max)
 AND (@PostJobCost_Values IS NULL OR  (@PostJobCost_Values = '###NULL###' AND PostJobCost IS NULL ) OR (@PostJobCost_Values <> '###NULL###' AND PostJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@PostJobCost_Values,','))))
 AND (@PostJobCost_Min IS NULL OR PostJobCost >=  @PostJobCost_Min)
 AND (@PostJobCost_Max IS NULL OR PostJobCost <=  @PostJobCost_Max)
 AND (@Show IS NULL OR (@Show = '###NULL###' AND Show IS NULL ) OR (@Show <> '###NULL###' AND Show LIKE '%'+@Show+'%'))
 AND (@Show_Values IS NULL OR (@Show_Values = '###NULL###' AND Show IS NULL ) OR (@Show_Values <> '###NULL###' AND Show IN(SELECT Item FROM [dbo].CustomeSplit(@Show_Values,','))))
 AND (@ProductionFlag IS NULL OR (@ProductionFlag = '###NULL###' AND ProductionFlag IS NULL ) OR (@ProductionFlag <> '###NULL###' AND ProductionFlag LIKE '%'+@ProductionFlag+'%'))
 AND (@ProductionFlag_Values IS NULL OR (@ProductionFlag_Values = '###NULL###' AND ProductionFlag IS NULL ) OR (@ProductionFlag_Values <> '###NULL###' AND ProductionFlag IN(SELECT Item FROM [dbo].CustomeSplit(@ProductionFlag_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND QuoteTypeNo IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND QuoteTypeNo IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR QuoteTypeNo >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR QuoteTypeNo <=  @QuoteTypeNo_Max)
 AND (@LastApprovedBy IS NULL OR (@LastApprovedBy = '###NULL###' AND LastApprovedBy IS NULL ) OR (@LastApprovedBy <> '###NULL###' AND LastApprovedBy LIKE '%'+@LastApprovedBy+'%'))
 AND (@LastApprovedBy_Values IS NULL OR (@LastApprovedBy_Values = '###NULL###' AND LastApprovedBy IS NULL ) OR (@LastApprovedBy_Values <> '###NULL###' AND LastApprovedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastApprovedBy_Values,','))))
 AND (@QApprovedByDateTime_Values IS NULL OR  (@QApprovedByDateTime_Values = '###NULL###' AND QApprovedByDateTime IS NULL ) OR (@QApprovedByDateTime_Values <> '###NULL###' AND QApprovedByDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@QApprovedByDateTime_Values,','))))
 AND (@QApprovedByDateTime_Min IS NULL OR QApprovedByDateTime >=  @QApprovedByDateTime_Min)
 AND (@QApprovedByDateTime_Max IS NULL OR QApprovedByDateTime <=  @QApprovedByDateTime_Max)
 AND (@LastReviewedBy IS NULL OR (@LastReviewedBy = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy <> '###NULL###' AND LastReviewedBy LIKE '%'+@LastReviewedBy+'%'))
 AND (@LastReviewedBy_Values IS NULL OR (@LastReviewedBy_Values = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy_Values <> '###NULL###' AND LastReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastReviewedBy_Values,','))))
 AND (@ReviewedDateTime_Values IS NULL OR  (@ReviewedDateTime_Values = '###NULL###' AND ReviewedDateTime IS NULL ) OR (@ReviewedDateTime_Values <> '###NULL###' AND ReviewedDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedDateTime_Values,','))))
 AND (@ReviewedDateTime_Min IS NULL OR ReviewedDateTime >=  @ReviewedDateTime_Min)
 AND (@ReviewedDateTime_Max IS NULL OR ReviewedDateTime <=  @ReviewedDateTime_Max)
 AND (@LoadInDate_Values IS NULL OR  (@LoadInDate_Values = '###NULL###' AND LoadInDate IS NULL ) OR (@LoadInDate_Values <> '###NULL###' AND LoadInDate IN(SELECT Item FROM [dbo].CustomeSplit(@LoadInDate_Values,','))))
 AND (@LoadInDate_Min IS NULL OR LoadInDate >=  @LoadInDate_Min)
 AND (@LoadInDate_Max IS NULL OR LoadInDate <=  @LoadInDate_Max)
 AND (@LoadInTime IS NULL OR (@LoadInTime = '###NULL###' AND LoadInTime IS NULL ) OR (@LoadInTime <> '###NULL###' AND LoadInTime LIKE '%'+@LoadInTime+'%'))
 AND (@LoadInTime_Values IS NULL OR (@LoadInTime_Values = '###NULL###' AND LoadInTime IS NULL ) OR (@LoadInTime_Values <> '###NULL###' AND LoadInTime IN(SELECT Item FROM [dbo].CustomeSplit(@LoadInTime_Values,','))))
 AND (@LoadOutDate_Values IS NULL OR  (@LoadOutDate_Values = '###NULL###' AND LoadOutDate IS NULL ) OR (@LoadOutDate_Values <> '###NULL###' AND LoadOutDate IN(SELECT Item FROM [dbo].CustomeSplit(@LoadOutDate_Values,','))))
 AND (@LoadOutDate_Min IS NULL OR LoadOutDate >=  @LoadOutDate_Min)
 AND (@LoadOutDate_Max IS NULL OR LoadOutDate <=  @LoadOutDate_Max)
 AND (@LoadOutTime IS NULL OR (@LoadOutTime = '###NULL###' AND LoadOutTime IS NULL ) OR (@LoadOutTime <> '###NULL###' AND LoadOutTime LIKE '%'+@LoadOutTime+'%'))
 AND (@LoadOutTime_Values IS NULL OR (@LoadOutTime_Values = '###NULL###' AND LoadOutTime IS NULL ) OR (@LoadOutTime_Values <> '###NULL###' AND LoadOutTime IN(SELECT Item FROM [dbo].CustomeSplit(@LoadOutTime_Values,','))))
 )
END
IF (@Sort_Ascending IS NULL OR @Sort_Column IS NULL) AND @Page_Size IS NULL
BEGIN
SELECT CustName,QuoteRentalID,HasRentedBefore,CustID,OrderFrequency,ProjectedRevenue,custaccountrep,isShortage,ShortageQty,InterestType,QConfirmationDate,QuoteConfirmationStatus,QuoteCancelNote,AvailabilityLastViewedBy,AvailabilityLastViewedOn,QuoteID,Total,EnteredDate,LastModifiedDate,DeliveryDate,ReturnDate,ShowDays,SalesRep,Employeeid,ApprovedByEmp,ReviewedBy,ProjectLead,Activity,Interest,Branch,ShipCity,ShipState,approvedby,approvedby2,approvedby3,QuoteJobCost,PreJobCost,PostJobCost,Show,ProductionFlag,QuoteTypeNo,LastApprovedBy,QApprovedByDateTime,LastReviewedBy,ReviewedDateTime,LoadInDate,LoadInTime,LoadOutDate,LoadOutTime FROM  VW_DailyQuotesData (NOLOCK)

 WHERE (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@QuoteRentalID_Values IS NULL OR  (@QuoteRentalID_Values = '###NULL###' AND QuoteRentalID IS NULL ) OR (@QuoteRentalID_Values <> '###NULL###' AND QuoteRentalID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteRentalID_Values,','))))
 AND (@QuoteRentalID_Min IS NULL OR QuoteRentalID >=  @QuoteRentalID_Min)
 AND (@QuoteRentalID_Max IS NULL OR QuoteRentalID <=  @QuoteRentalID_Max)
 AND (@HasRentedBefore_Values IS NULL OR  (@HasRentedBefore_Values = '###NULL###' AND HasRentedBefore IS NULL ) OR (@HasRentedBefore_Values <> '###NULL###' AND HasRentedBefore IN(SELECT Item FROM [dbo].CustomeSplit(@HasRentedBefore_Values,','))))
 AND (@HasRentedBefore_Min IS NULL OR HasRentedBefore >=  @HasRentedBefore_Min)
 AND (@HasRentedBefore_Max IS NULL OR HasRentedBefore <=  @HasRentedBefore_Max)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND OrderFrequency LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND OrderFrequency IN(SELECT Item FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@ProjectedRevenue_Values IS NULL OR  (@ProjectedRevenue_Values = '###NULL###' AND ProjectedRevenue IS NULL ) OR (@ProjectedRevenue_Values <> '###NULL###' AND ProjectedRevenue IN(SELECT Item FROM [dbo].CustomeSplit(@ProjectedRevenue_Values,','))))
 AND (@ProjectedRevenue_Min IS NULL OR ProjectedRevenue >=  @ProjectedRevenue_Min)
 AND (@ProjectedRevenue_Max IS NULL OR ProjectedRevenue <=  @ProjectedRevenue_Max)
 AND (@custaccountrep IS NULL OR (@custaccountrep = '###NULL###' AND custaccountrep IS NULL ) OR (@custaccountrep <> '###NULL###' AND custaccountrep LIKE '%'+@custaccountrep+'%'))
 AND (@custaccountrep_Values IS NULL OR (@custaccountrep_Values = '###NULL###' AND custaccountrep IS NULL ) OR (@custaccountrep_Values <> '###NULL###' AND custaccountrep IN(SELECT Item FROM [dbo].CustomeSplit(@custaccountrep_Values,','))))
 AND (@isShortage IS NULL OR isShortage =  @isShortage)
 AND (@ShortageQty_Values IS NULL OR  (@ShortageQty_Values = '###NULL###' AND ShortageQty IS NULL ) OR (@ShortageQty_Values <> '###NULL###' AND ShortageQty IN(SELECT Item FROM [dbo].CustomeSplit(@ShortageQty_Values,','))))
 AND (@ShortageQty_Min IS NULL OR ShortageQty >=  @ShortageQty_Min)
 AND (@ShortageQty_Max IS NULL OR ShortageQty <=  @ShortageQty_Max)
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND InterestType IS NULL ) OR (@InterestType_Values <> '###NULL###' AND InterestType IN(SELECT Item FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR InterestType >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR InterestType <=  @InterestType_Max)
 AND (@QConfirmationDate_Values IS NULL OR  (@QConfirmationDate_Values = '###NULL###' AND QConfirmationDate IS NULL ) OR (@QConfirmationDate_Values <> '###NULL###' AND QConfirmationDate IN(SELECT Item FROM [dbo].CustomeSplit(@QConfirmationDate_Values,','))))
 AND (@QConfirmationDate_Min IS NULL OR QConfirmationDate >=  @QConfirmationDate_Min)
 AND (@QConfirmationDate_Max IS NULL OR QConfirmationDate <=  @QConfirmationDate_Max)
 AND (@QuoteConfirmationStatus IS NULL OR (@QuoteConfirmationStatus = '###NULL###' AND QuoteConfirmationStatus IS NULL ) OR (@QuoteConfirmationStatus <> '###NULL###' AND QuoteConfirmationStatus LIKE '%'+@QuoteConfirmationStatus+'%'))
 AND (@QuoteConfirmationStatus_Values IS NULL OR (@QuoteConfirmationStatus_Values = '###NULL###' AND QuoteConfirmationStatus IS NULL ) OR (@QuoteConfirmationStatus_Values <> '###NULL###' AND QuoteConfirmationStatus IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteConfirmationStatus_Values,','))))
 AND (@QuoteCancelNote IS NULL OR (@QuoteCancelNote = '###NULL###' AND QuoteCancelNote IS NULL ) OR (@QuoteCancelNote <> '###NULL###' AND QuoteCancelNote LIKE '%'+@QuoteCancelNote+'%'))
 AND (@QuoteCancelNote_Values IS NULL OR (@QuoteCancelNote_Values = '###NULL###' AND QuoteCancelNote IS NULL ) OR (@QuoteCancelNote_Values <> '###NULL###' AND QuoteCancelNote IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteCancelNote_Values,','))))
 AND (@AvailabilityLastViewedBy IS NULL OR (@AvailabilityLastViewedBy = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy <> '###NULL###' AND AvailabilityLastViewedBy LIKE '%'+@AvailabilityLastViewedBy+'%'))
 AND (@AvailabilityLastViewedBy_Values IS NULL OR (@AvailabilityLastViewedBy_Values = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy_Values <> '###NULL###' AND AvailabilityLastViewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedBy_Values,','))))
 AND (@AvailabilityLastViewedOn_Values IS NULL OR  (@AvailabilityLastViewedOn_Values = '###NULL###' AND AvailabilityLastViewedOn IS NULL ) OR (@AvailabilityLastViewedOn_Values <> '###NULL###' AND AvailabilityLastViewedOn IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedOn_Values,','))))
 AND (@AvailabilityLastViewedOn_Min IS NULL OR AvailabilityLastViewedOn >=  @AvailabilityLastViewedOn_Min)
 AND (@AvailabilityLastViewedOn_Max IS NULL OR AvailabilityLastViewedOn <=  @AvailabilityLastViewedOn_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@EnteredDate_Values IS NULL OR  (@EnteredDate_Values = '###NULL###' AND EnteredDate IS NULL ) OR (@EnteredDate_Values <> '###NULL###' AND EnteredDate IN(SELECT Item FROM [dbo].CustomeSplit(@EnteredDate_Values,','))))
 AND (@EnteredDate_Min IS NULL OR EnteredDate >=  @EnteredDate_Min)
 AND (@EnteredDate_Max IS NULL OR EnteredDate <=  @EnteredDate_Max)
 AND (@LastModifiedDate_Values IS NULL OR  (@LastModifiedDate_Values = '###NULL###' AND LastModifiedDate IS NULL ) OR (@LastModifiedDate_Values <> '###NULL###' AND LastModifiedDate IN(SELECT Item FROM [dbo].CustomeSplit(@LastModifiedDate_Values,','))))
 AND (@LastModifiedDate_Min IS NULL OR LastModifiedDate >=  @LastModifiedDate_Min)
 AND (@LastModifiedDate_Max IS NULL OR LastModifiedDate <=  @LastModifiedDate_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR DeliveryDate >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR DeliveryDate <=  @DeliveryDate_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR ReturnDate >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR ReturnDate <=  @ReturnDate_Max)
 AND (@ShowDays_Values IS NULL OR  (@ShowDays_Values = '###NULL###' AND ShowDays IS NULL ) OR (@ShowDays_Values <> '###NULL###' AND ShowDays IN(SELECT Item FROM [dbo].CustomeSplit(@ShowDays_Values,','))))
 AND (@ShowDays_Min IS NULL OR ShowDays >=  @ShowDays_Min)
 AND (@ShowDays_Max IS NULL OR ShowDays <=  @ShowDays_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@Employeeid_Values IS NULL OR  (@Employeeid_Values = '###NULL###' AND Employeeid IS NULL ) OR (@Employeeid_Values <> '###NULL###' AND Employeeid IN(SELECT Item FROM [dbo].CustomeSplit(@Employeeid_Values,','))))
 AND (@Employeeid_Min IS NULL OR Employeeid >=  @Employeeid_Min)
 AND (@Employeeid_Max IS NULL OR Employeeid <=  @Employeeid_Max)
 AND (@ApprovedByEmp IS NULL OR (@ApprovedByEmp = '###NULL###' AND ApprovedByEmp IS NULL ) OR (@ApprovedByEmp <> '###NULL###' AND ApprovedByEmp LIKE '%'+@ApprovedByEmp+'%'))
 AND (@ApprovedByEmp_Values IS NULL OR (@ApprovedByEmp_Values = '###NULL###' AND ApprovedByEmp IS NULL ) OR (@ApprovedByEmp_Values <> '###NULL###' AND ApprovedByEmp IN(SELECT Item FROM [dbo].CustomeSplit(@ApprovedByEmp_Values,','))))
 AND (@ReviewedBy IS NULL OR (@ReviewedBy = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy <> '###NULL###' AND ReviewedBy LIKE '%'+@ReviewedBy+'%'))
 AND (@ReviewedBy_Values IS NULL OR (@ReviewedBy_Values = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy_Values <> '###NULL###' AND ReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedBy_Values,','))))
 AND (@ProjectLead IS NULL OR (@ProjectLead = '###NULL###' AND ProjectLead IS NULL ) OR (@ProjectLead <> '###NULL###' AND ProjectLead LIKE '%'+@ProjectLead+'%'))
 AND (@ProjectLead_Values IS NULL OR (@ProjectLead_Values = '###NULL###' AND ProjectLead IS NULL ) OR (@ProjectLead_Values <> '###NULL###' AND ProjectLead IN(SELECT Item FROM [dbo].CustomeSplit(@ProjectLead_Values,','))))
 AND (@Activity IS NULL OR (@Activity = '###NULL###' AND Activity IS NULL ) OR (@Activity <> '###NULL###' AND Activity LIKE '%'+@Activity+'%'))
 AND (@Activity_Values IS NULL OR (@Activity_Values = '###NULL###' AND Activity IS NULL ) OR (@Activity_Values <> '###NULL###' AND Activity IN(SELECT Item FROM [dbo].CustomeSplit(@Activity_Values,','))))
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND Interest LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND Interest IS NULL ) OR (@Interest_Values <> '###NULL###' AND Interest IN(SELECT Item FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@Branch IS NULL OR (@Branch = '###NULL###' AND Branch IS NULL ) OR (@Branch <> '###NULL###' AND Branch LIKE '%'+@Branch+'%'))
 AND (@Branch_Values IS NULL OR (@Branch_Values = '###NULL###' AND Branch IS NULL ) OR (@Branch_Values <> '###NULL###' AND Branch IN(SELECT Item FROM [dbo].CustomeSplit(@Branch_Values,','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCity_Values,','))))
 AND (@ShipState IS NULL OR (@ShipState = '###NULL###' AND ShipState IS NULL ) OR (@ShipState <> '###NULL###' AND ShipState LIKE '%'+@ShipState+'%'))
 AND (@ShipState_Values IS NULL OR (@ShipState_Values = '###NULL###' AND ShipState IS NULL ) OR (@ShipState_Values <> '###NULL###' AND ShipState IN(SELECT Item FROM [dbo].CustomeSplit(@ShipState_Values,','))))
 AND (@approvedby_Values IS NULL OR  (@approvedby_Values = '###NULL###' AND approvedby IS NULL ) OR (@approvedby_Values <> '###NULL###' AND approvedby IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby_Values,','))))
 AND (@approvedby_Min IS NULL OR approvedby >=  @approvedby_Min)
 AND (@approvedby_Max IS NULL OR approvedby <=  @approvedby_Max)
 AND (@approvedby2_Values IS NULL OR  (@approvedby2_Values = '###NULL###' AND approvedby2 IS NULL ) OR (@approvedby2_Values <> '###NULL###' AND approvedby2 IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby2_Values,','))))
 AND (@approvedby2_Min IS NULL OR approvedby2 >=  @approvedby2_Min)
 AND (@approvedby2_Max IS NULL OR approvedby2 <=  @approvedby2_Max)
 AND (@approvedby3_Values IS NULL OR  (@approvedby3_Values = '###NULL###' AND approvedby3 IS NULL ) OR (@approvedby3_Values <> '###NULL###' AND approvedby3 IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby3_Values,','))))
 AND (@approvedby3_Min IS NULL OR approvedby3 >=  @approvedby3_Min)
 AND (@approvedby3_Max IS NULL OR approvedby3 <=  @approvedby3_Max)
 AND (@QuoteJobCost_Values IS NULL OR  (@QuoteJobCost_Values = '###NULL###' AND QuoteJobCost IS NULL ) OR (@QuoteJobCost_Values <> '###NULL###' AND QuoteJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteJobCost_Values,','))))
 AND (@QuoteJobCost_Min IS NULL OR QuoteJobCost >=  @QuoteJobCost_Min)
 AND (@QuoteJobCost_Max IS NULL OR QuoteJobCost <=  @QuoteJobCost_Max)
 AND (@PreJobCost_Values IS NULL OR  (@PreJobCost_Values = '###NULL###' AND PreJobCost IS NULL ) OR (@PreJobCost_Values <> '###NULL###' AND PreJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@PreJobCost_Values,','))))
 AND (@PreJobCost_Min IS NULL OR PreJobCost >=  @PreJobCost_Min)
 AND (@PreJobCost_Max IS NULL OR PreJobCost <=  @PreJobCost_Max)
 AND (@PostJobCost_Values IS NULL OR  (@PostJobCost_Values = '###NULL###' AND PostJobCost IS NULL ) OR (@PostJobCost_Values <> '###NULL###' AND PostJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@PostJobCost_Values,','))))
 AND (@PostJobCost_Min IS NULL OR PostJobCost >=  @PostJobCost_Min)
 AND (@PostJobCost_Max IS NULL OR PostJobCost <=  @PostJobCost_Max)
 AND (@Show IS NULL OR (@Show = '###NULL###' AND Show IS NULL ) OR (@Show <> '###NULL###' AND Show LIKE '%'+@Show+'%'))
 AND (@Show_Values IS NULL OR (@Show_Values = '###NULL###' AND Show IS NULL ) OR (@Show_Values <> '###NULL###' AND Show IN(SELECT Item FROM [dbo].CustomeSplit(@Show_Values,','))))
 AND (@ProductionFlag IS NULL OR (@ProductionFlag = '###NULL###' AND ProductionFlag IS NULL ) OR (@ProductionFlag <> '###NULL###' AND ProductionFlag LIKE '%'+@ProductionFlag+'%'))
 AND (@ProductionFlag_Values IS NULL OR (@ProductionFlag_Values = '###NULL###' AND ProductionFlag IS NULL ) OR (@ProductionFlag_Values <> '###NULL###' AND ProductionFlag IN(SELECT Item FROM [dbo].CustomeSplit(@ProductionFlag_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND QuoteTypeNo IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND QuoteTypeNo IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR QuoteTypeNo >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR QuoteTypeNo <=  @QuoteTypeNo_Max)
 AND (@LastApprovedBy IS NULL OR (@LastApprovedBy = '###NULL###' AND LastApprovedBy IS NULL ) OR (@LastApprovedBy <> '###NULL###' AND LastApprovedBy LIKE '%'+@LastApprovedBy+'%'))
 AND (@LastApprovedBy_Values IS NULL OR (@LastApprovedBy_Values = '###NULL###' AND LastApprovedBy IS NULL ) OR (@LastApprovedBy_Values <> '###NULL###' AND LastApprovedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastApprovedBy_Values,','))))
 AND (@QApprovedByDateTime_Values IS NULL OR  (@QApprovedByDateTime_Values = '###NULL###' AND QApprovedByDateTime IS NULL ) OR (@QApprovedByDateTime_Values <> '###NULL###' AND QApprovedByDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@QApprovedByDateTime_Values,','))))
 AND (@QApprovedByDateTime_Min IS NULL OR QApprovedByDateTime >=  @QApprovedByDateTime_Min)
 AND (@QApprovedByDateTime_Max IS NULL OR QApprovedByDateTime <=  @QApprovedByDateTime_Max)
 AND (@LastReviewedBy IS NULL OR (@LastReviewedBy = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy <> '###NULL###' AND LastReviewedBy LIKE '%'+@LastReviewedBy+'%'))
 AND (@LastReviewedBy_Values IS NULL OR (@LastReviewedBy_Values = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy_Values <> '###NULL###' AND LastReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastReviewedBy_Values,','))))
 AND (@ReviewedDateTime_Values IS NULL OR  (@ReviewedDateTime_Values = '###NULL###' AND ReviewedDateTime IS NULL ) OR (@ReviewedDateTime_Values <> '###NULL###' AND ReviewedDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedDateTime_Values,','))))
 AND (@ReviewedDateTime_Min IS NULL OR ReviewedDateTime >=  @ReviewedDateTime_Min)
 AND (@ReviewedDateTime_Max IS NULL OR ReviewedDateTime <=  @ReviewedDateTime_Max)
 AND (@LoadInDate_Values IS NULL OR  (@LoadInDate_Values = '###NULL###' AND LoadInDate IS NULL ) OR (@LoadInDate_Values <> '###NULL###' AND LoadInDate IN(SELECT Item FROM [dbo].CustomeSplit(@LoadInDate_Values,','))))
 AND (@LoadInDate_Min IS NULL OR LoadInDate >=  @LoadInDate_Min)
 AND (@LoadInDate_Max IS NULL OR LoadInDate <=  @LoadInDate_Max)
 AND (@LoadInTime IS NULL OR (@LoadInTime = '###NULL###' AND LoadInTime IS NULL ) OR (@LoadInTime <> '###NULL###' AND LoadInTime LIKE '%'+@LoadInTime+'%'))
 AND (@LoadInTime_Values IS NULL OR (@LoadInTime_Values = '###NULL###' AND LoadInTime IS NULL ) OR (@LoadInTime_Values <> '###NULL###' AND LoadInTime IN(SELECT Item FROM [dbo].CustomeSplit(@LoadInTime_Values,','))))
 AND (@LoadOutDate_Values IS NULL OR  (@LoadOutDate_Values = '###NULL###' AND LoadOutDate IS NULL ) OR (@LoadOutDate_Values <> '###NULL###' AND LoadOutDate IN(SELECT Item FROM [dbo].CustomeSplit(@LoadOutDate_Values,','))))
 AND (@LoadOutDate_Min IS NULL OR LoadOutDate >=  @LoadOutDate_Min)
 AND (@LoadOutDate_Max IS NULL OR LoadOutDate <=  @LoadOutDate_Max)
 AND (@LoadOutTime IS NULL OR (@LoadOutTime = '###NULL###' AND LoadOutTime IS NULL ) OR (@LoadOutTime <> '###NULL###' AND LoadOutTime LIKE '%'+@LoadOutTime+'%'))
 AND (@LoadOutTime_Values IS NULL OR (@LoadOutTime_Values = '###NULL###' AND LoadOutTime IS NULL ) OR (@LoadOutTime_Values <> '###NULL###' AND LoadOutTime IN(SELECT Item FROM [dbo].CustomeSplit(@LoadOutTime_Values,','))))
 
END
ELSE
BEGIN
SELECT CustName,QuoteRentalID,HasRentedBefore,CustID,OrderFrequency,ProjectedRevenue,custaccountrep,isShortage,ShortageQty,InterestType,QConfirmationDate,QuoteConfirmationStatus,QuoteCancelNote,AvailabilityLastViewedBy,AvailabilityLastViewedOn,QuoteID,Total,EnteredDate,LastModifiedDate,DeliveryDate,ReturnDate,ShowDays,SalesRep,Employeeid,ApprovedByEmp,ReviewedBy,ProjectLead,Activity,Interest,Branch,ShipCity,ShipState,approvedby,approvedby2,approvedby3,QuoteJobCost,PreJobCost,PostJobCost,Show,ProductionFlag,QuoteTypeNo,LastApprovedBy,QApprovedByDateTime,LastReviewedBy,ReviewedDateTime,LoadInDate,LoadInTime,LoadOutDate,LoadOutTime FROM  (SELECT ROW_NUMBER() OVER 
 ( ORDER BY 
CASE WHEN (@Sort_Column='VW_DailyQuotesData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.CustName IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.CustName ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.CustName' OR @Sort_Column='CustName') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.CustName ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteRentalID' OR @Sort_Column='QuoteRentalID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.QuoteRentalID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteRentalID' OR @Sort_Column='QuoteRentalID') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.QuoteRentalID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteRentalID' OR @Sort_Column='QuoteRentalID') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.QuoteRentalID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.HasRentedBefore' OR @Sort_Column='HasRentedBefore') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.HasRentedBefore IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.HasRentedBefore' OR @Sort_Column='HasRentedBefore') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.HasRentedBefore ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.HasRentedBefore' OR @Sort_Column='HasRentedBefore') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.HasRentedBefore ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.CustID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.CustID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.CustID' OR @Sort_Column='CustID') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.CustID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.OrderFrequency IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.OrderFrequency ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.OrderFrequency' OR @Sort_Column='OrderFrequency') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.OrderFrequency ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProjectedRevenue' OR @Sort_Column='ProjectedRevenue') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ProjectedRevenue IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProjectedRevenue' OR @Sort_Column='ProjectedRevenue') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ProjectedRevenue ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProjectedRevenue' OR @Sort_Column='ProjectedRevenue') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ProjectedRevenue ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.custaccountrep' OR @Sort_Column='custaccountrep') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.custaccountrep IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.custaccountrep' OR @Sort_Column='custaccountrep') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.custaccountrep ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.custaccountrep' OR @Sort_Column='custaccountrep') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.custaccountrep ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.isShortage' OR @Sort_Column='isShortage') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.isShortage IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.isShortage' OR @Sort_Column='isShortage') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.isShortage ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.isShortage' OR @Sort_Column='isShortage') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.isShortage ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShortageQty' OR @Sort_Column='ShortageQty') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ShortageQty IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShortageQty' OR @Sort_Column='ShortageQty') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ShortageQty ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShortageQty' OR @Sort_Column='ShortageQty') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ShortageQty ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.InterestType IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.InterestType ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.InterestType' OR @Sort_Column='InterestType') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.InterestType ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QConfirmationDate' OR @Sort_Column='QConfirmationDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.QConfirmationDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QConfirmationDate' OR @Sort_Column='QConfirmationDate') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.QConfirmationDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QConfirmationDate' OR @Sort_Column='QConfirmationDate') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.QConfirmationDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteConfirmationStatus' OR @Sort_Column='QuoteConfirmationStatus') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.QuoteConfirmationStatus IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteConfirmationStatus' OR @Sort_Column='QuoteConfirmationStatus') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.QuoteConfirmationStatus ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteConfirmationStatus' OR @Sort_Column='QuoteConfirmationStatus') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.QuoteConfirmationStatus ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteCancelNote' OR @Sort_Column='QuoteCancelNote') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.QuoteCancelNote IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteCancelNote' OR @Sort_Column='QuoteCancelNote') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.QuoteCancelNote ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteCancelNote' OR @Sort_Column='QuoteCancelNote') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.QuoteCancelNote ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.AvailabilityLastViewedBy' OR @Sort_Column='AvailabilityLastViewedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.AvailabilityLastViewedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.AvailabilityLastViewedBy' OR @Sort_Column='AvailabilityLastViewedBy') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.AvailabilityLastViewedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.AvailabilityLastViewedBy' OR @Sort_Column='AvailabilityLastViewedBy') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.AvailabilityLastViewedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.AvailabilityLastViewedOn' OR @Sort_Column='AvailabilityLastViewedOn') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.AvailabilityLastViewedOn IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.AvailabilityLastViewedOn' OR @Sort_Column='AvailabilityLastViewedOn') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.AvailabilityLastViewedOn ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.AvailabilityLastViewedOn' OR @Sort_Column='AvailabilityLastViewedOn') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.AvailabilityLastViewedOn ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.QuoteID IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.QuoteID ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteID' OR @Sort_Column='QuoteID') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.QuoteID ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.Total IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.Total ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Total' OR @Sort_Column='Total') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.Total ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.EnteredDate' OR @Sort_Column='EnteredDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.EnteredDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.EnteredDate' OR @Sort_Column='EnteredDate') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.EnteredDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.EnteredDate' OR @Sort_Column='EnteredDate') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.EnteredDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastModifiedDate' OR @Sort_Column='LastModifiedDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.LastModifiedDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastModifiedDate' OR @Sort_Column='LastModifiedDate') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.LastModifiedDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastModifiedDate' OR @Sort_Column='LastModifiedDate') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.LastModifiedDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.DeliveryDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.DeliveryDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.DeliveryDate' OR @Sort_Column='DeliveryDate') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.DeliveryDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ReturnDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ReturnDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReturnDate' OR @Sort_Column='ReturnDate') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ReturnDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShowDays' OR @Sort_Column='ShowDays') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ShowDays IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShowDays' OR @Sort_Column='ShowDays') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ShowDays ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShowDays' OR @Sort_Column='ShowDays') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ShowDays ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.SalesRep IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.SalesRep ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.SalesRep' OR @Sort_Column='SalesRep') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.SalesRep ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Employeeid' OR @Sort_Column='Employeeid') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.Employeeid IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Employeeid' OR @Sort_Column='Employeeid') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.Employeeid ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Employeeid' OR @Sort_Column='Employeeid') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.Employeeid ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ApprovedByEmp' OR @Sort_Column='ApprovedByEmp') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ApprovedByEmp IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ApprovedByEmp' OR @Sort_Column='ApprovedByEmp') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ApprovedByEmp ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ApprovedByEmp' OR @Sort_Column='ApprovedByEmp') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ApprovedByEmp ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReviewedBy' OR @Sort_Column='ReviewedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ReviewedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReviewedBy' OR @Sort_Column='ReviewedBy') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ReviewedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReviewedBy' OR @Sort_Column='ReviewedBy') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ReviewedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProjectLead' OR @Sort_Column='ProjectLead') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ProjectLead IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProjectLead' OR @Sort_Column='ProjectLead') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ProjectLead ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProjectLead' OR @Sort_Column='ProjectLead') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ProjectLead ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Activity' OR @Sort_Column='Activity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.Activity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Activity' OR @Sort_Column='Activity') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.Activity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Activity' OR @Sort_Column='Activity') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.Activity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.Interest IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.Interest ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Interest' OR @Sort_Column='Interest') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.Interest ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Branch' OR @Sort_Column='Branch') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.Branch IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Branch' OR @Sort_Column='Branch') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.Branch ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Branch' OR @Sort_Column='Branch') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.Branch ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ShipCity IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ShipCity ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShipCity' OR @Sort_Column='ShipCity') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ShipCity ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShipState' OR @Sort_Column='ShipState') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ShipState IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShipState' OR @Sort_Column='ShipState') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ShipState ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ShipState' OR @Sort_Column='ShipState') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ShipState ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby' OR @Sort_Column='approvedby') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.approvedby IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby' OR @Sort_Column='approvedby') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.approvedby ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby' OR @Sort_Column='approvedby') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.approvedby ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby2' OR @Sort_Column='approvedby2') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.approvedby2 IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby2' OR @Sort_Column='approvedby2') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.approvedby2 ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby2' OR @Sort_Column='approvedby2') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.approvedby2 ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby3' OR @Sort_Column='approvedby3') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.approvedby3 IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby3' OR @Sort_Column='approvedby3') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.approvedby3 ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.approvedby3' OR @Sort_Column='approvedby3') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.approvedby3 ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteJobCost' OR @Sort_Column='QuoteJobCost') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.QuoteJobCost IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteJobCost' OR @Sort_Column='QuoteJobCost') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.QuoteJobCost ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteJobCost' OR @Sort_Column='QuoteJobCost') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.QuoteJobCost ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.PreJobCost' OR @Sort_Column='PreJobCost') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.PreJobCost IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.PreJobCost' OR @Sort_Column='PreJobCost') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.PreJobCost ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.PreJobCost' OR @Sort_Column='PreJobCost') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.PreJobCost ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.PostJobCost' OR @Sort_Column='PostJobCost') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.PostJobCost IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.PostJobCost' OR @Sort_Column='PostJobCost') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.PostJobCost ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.PostJobCost' OR @Sort_Column='PostJobCost') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.PostJobCost ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Show' OR @Sort_Column='Show') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.Show IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Show' OR @Sort_Column='Show') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.Show ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.Show' OR @Sort_Column='Show') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.Show ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProductionFlag' OR @Sort_Column='ProductionFlag') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ProductionFlag IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProductionFlag' OR @Sort_Column='ProductionFlag') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ProductionFlag ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ProductionFlag' OR @Sort_Column='ProductionFlag') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ProductionFlag ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.QuoteTypeNo IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.QuoteTypeNo ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QuoteTypeNo' OR @Sort_Column='QuoteTypeNo') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.QuoteTypeNo ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastApprovedBy' OR @Sort_Column='LastApprovedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.LastApprovedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastApprovedBy' OR @Sort_Column='LastApprovedBy') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.LastApprovedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastApprovedBy' OR @Sort_Column='LastApprovedBy') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.LastApprovedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QApprovedByDateTime' OR @Sort_Column='QApprovedByDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.QApprovedByDateTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QApprovedByDateTime' OR @Sort_Column='QApprovedByDateTime') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.QApprovedByDateTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.QApprovedByDateTime' OR @Sort_Column='QApprovedByDateTime') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.QApprovedByDateTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastReviewedBy' OR @Sort_Column='LastReviewedBy') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.LastReviewedBy IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastReviewedBy' OR @Sort_Column='LastReviewedBy') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.LastReviewedBy ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LastReviewedBy' OR @Sort_Column='LastReviewedBy') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.LastReviewedBy ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReviewedDateTime' OR @Sort_Column='ReviewedDateTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.ReviewedDateTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReviewedDateTime' OR @Sort_Column='ReviewedDateTime') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.ReviewedDateTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.ReviewedDateTime' OR @Sort_Column='ReviewedDateTime') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.ReviewedDateTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadInDate' OR @Sort_Column='LoadInDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.LoadInDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadInDate' OR @Sort_Column='LoadInDate') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.LoadInDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadInDate' OR @Sort_Column='LoadInDate') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.LoadInDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadInTime' OR @Sort_Column='LoadInTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.LoadInTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadInTime' OR @Sort_Column='LoadInTime') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.LoadInTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadInTime' OR @Sort_Column='LoadInTime') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.LoadInTime ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadOutDate' OR @Sort_Column='LoadOutDate') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.LoadOutDate IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadOutDate' OR @Sort_Column='LoadOutDate') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.LoadOutDate ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadOutDate' OR @Sort_Column='LoadOutDate') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.LoadOutDate ELSE NULL END DESC,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadOutTime' OR @Sort_Column='LoadOutTime') AND @Sort_Ascending=1 THEN (CASE WHEN VW_DailyQuotesData.LoadOutTime IS NULL THEN 1 ELSE 0 END) ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadOutTime' OR @Sort_Column='LoadOutTime') AND @Sort_Ascending=1 THEN VW_DailyQuotesData.LoadOutTime ELSE NULL END,
CASE WHEN (@Sort_Column='VW_DailyQuotesData.LoadOutTime' OR @Sort_Column='LoadOutTime') AND @Sort_Ascending=0 THEN VW_DailyQuotesData.LoadOutTime ELSE NULL END DESC
 ) AS RowNum, VW_DailyQuotesData.*
 FROM  VW_DailyQuotesData (NOLOCK)

 WHERE (@CustName IS NULL OR (@CustName = '###NULL###' AND CustName IS NULL ) OR (@CustName <> '###NULL###' AND CustName LIKE '%'+@CustName+'%'))
 AND (@CustName_Values IS NULL OR (@CustName_Values = '###NULL###' AND CustName IS NULL ) OR (@CustName_Values <> '###NULL###' AND CustName IN(SELECT Item FROM [dbo].CustomeSplit(@CustName_Values,','))))
 AND (@QuoteRentalID_Values IS NULL OR  (@QuoteRentalID_Values = '###NULL###' AND QuoteRentalID IS NULL ) OR (@QuoteRentalID_Values <> '###NULL###' AND QuoteRentalID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteRentalID_Values,','))))
 AND (@QuoteRentalID_Min IS NULL OR QuoteRentalID >=  @QuoteRentalID_Min)
 AND (@QuoteRentalID_Max IS NULL OR QuoteRentalID <=  @QuoteRentalID_Max)
 AND (@HasRentedBefore_Values IS NULL OR  (@HasRentedBefore_Values = '###NULL###' AND HasRentedBefore IS NULL ) OR (@HasRentedBefore_Values <> '###NULL###' AND HasRentedBefore IN(SELECT Item FROM [dbo].CustomeSplit(@HasRentedBefore_Values,','))))
 AND (@HasRentedBefore_Min IS NULL OR HasRentedBefore >=  @HasRentedBefore_Min)
 AND (@HasRentedBefore_Max IS NULL OR HasRentedBefore <=  @HasRentedBefore_Max)
 AND (@CustID_Values IS NULL OR  (@CustID_Values = '###NULL###' AND CustID IS NULL ) OR (@CustID_Values <> '###NULL###' AND CustID IN(SELECT Item FROM [dbo].CustomeSplit(@CustID_Values,','))))
 AND (@CustID_Min IS NULL OR CustID >=  @CustID_Min)
 AND (@CustID_Max IS NULL OR CustID <=  @CustID_Max)
 AND (@OrderFrequency IS NULL OR (@OrderFrequency = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency <> '###NULL###' AND OrderFrequency LIKE '%'+@OrderFrequency+'%'))
 AND (@OrderFrequency_Values IS NULL OR (@OrderFrequency_Values = '###NULL###' AND OrderFrequency IS NULL ) OR (@OrderFrequency_Values <> '###NULL###' AND OrderFrequency IN(SELECT Item FROM [dbo].CustomeSplit(@OrderFrequency_Values,','))))
 AND (@ProjectedRevenue_Values IS NULL OR  (@ProjectedRevenue_Values = '###NULL###' AND ProjectedRevenue IS NULL ) OR (@ProjectedRevenue_Values <> '###NULL###' AND ProjectedRevenue IN(SELECT Item FROM [dbo].CustomeSplit(@ProjectedRevenue_Values,','))))
 AND (@ProjectedRevenue_Min IS NULL OR ProjectedRevenue >=  @ProjectedRevenue_Min)
 AND (@ProjectedRevenue_Max IS NULL OR ProjectedRevenue <=  @ProjectedRevenue_Max)
 AND (@custaccountrep IS NULL OR (@custaccountrep = '###NULL###' AND custaccountrep IS NULL ) OR (@custaccountrep <> '###NULL###' AND custaccountrep LIKE '%'+@custaccountrep+'%'))
 AND (@custaccountrep_Values IS NULL OR (@custaccountrep_Values = '###NULL###' AND custaccountrep IS NULL ) OR (@custaccountrep_Values <> '###NULL###' AND custaccountrep IN(SELECT Item FROM [dbo].CustomeSplit(@custaccountrep_Values,','))))
 AND (@isShortage IS NULL OR isShortage =  @isShortage)
 AND (@ShortageQty_Values IS NULL OR  (@ShortageQty_Values = '###NULL###' AND ShortageQty IS NULL ) OR (@ShortageQty_Values <> '###NULL###' AND ShortageQty IN(SELECT Item FROM [dbo].CustomeSplit(@ShortageQty_Values,','))))
 AND (@ShortageQty_Min IS NULL OR ShortageQty >=  @ShortageQty_Min)
 AND (@ShortageQty_Max IS NULL OR ShortageQty <=  @ShortageQty_Max)
 AND (@InterestType_Values IS NULL OR  (@InterestType_Values = '###NULL###' AND InterestType IS NULL ) OR (@InterestType_Values <> '###NULL###' AND InterestType IN(SELECT Item FROM [dbo].CustomeSplit(@InterestType_Values,','))))
 AND (@InterestType_Min IS NULL OR InterestType >=  @InterestType_Min)
 AND (@InterestType_Max IS NULL OR InterestType <=  @InterestType_Max)
 AND (@QConfirmationDate_Values IS NULL OR  (@QConfirmationDate_Values = '###NULL###' AND QConfirmationDate IS NULL ) OR (@QConfirmationDate_Values <> '###NULL###' AND QConfirmationDate IN(SELECT Item FROM [dbo].CustomeSplit(@QConfirmationDate_Values,','))))
 AND (@QConfirmationDate_Min IS NULL OR QConfirmationDate >=  @QConfirmationDate_Min)
 AND (@QConfirmationDate_Max IS NULL OR QConfirmationDate <=  @QConfirmationDate_Max)
 AND (@QuoteConfirmationStatus IS NULL OR (@QuoteConfirmationStatus = '###NULL###' AND QuoteConfirmationStatus IS NULL ) OR (@QuoteConfirmationStatus <> '###NULL###' AND QuoteConfirmationStatus LIKE '%'+@QuoteConfirmationStatus+'%'))
 AND (@QuoteConfirmationStatus_Values IS NULL OR (@QuoteConfirmationStatus_Values = '###NULL###' AND QuoteConfirmationStatus IS NULL ) OR (@QuoteConfirmationStatus_Values <> '###NULL###' AND QuoteConfirmationStatus IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteConfirmationStatus_Values,','))))
 AND (@QuoteCancelNote IS NULL OR (@QuoteCancelNote = '###NULL###' AND QuoteCancelNote IS NULL ) OR (@QuoteCancelNote <> '###NULL###' AND QuoteCancelNote LIKE '%'+@QuoteCancelNote+'%'))
 AND (@QuoteCancelNote_Values IS NULL OR (@QuoteCancelNote_Values = '###NULL###' AND QuoteCancelNote IS NULL ) OR (@QuoteCancelNote_Values <> '###NULL###' AND QuoteCancelNote IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteCancelNote_Values,','))))
 AND (@AvailabilityLastViewedBy IS NULL OR (@AvailabilityLastViewedBy = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy <> '###NULL###' AND AvailabilityLastViewedBy LIKE '%'+@AvailabilityLastViewedBy+'%'))
 AND (@AvailabilityLastViewedBy_Values IS NULL OR (@AvailabilityLastViewedBy_Values = '###NULL###' AND AvailabilityLastViewedBy IS NULL ) OR (@AvailabilityLastViewedBy_Values <> '###NULL###' AND AvailabilityLastViewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedBy_Values,','))))
 AND (@AvailabilityLastViewedOn_Values IS NULL OR  (@AvailabilityLastViewedOn_Values = '###NULL###' AND AvailabilityLastViewedOn IS NULL ) OR (@AvailabilityLastViewedOn_Values <> '###NULL###' AND AvailabilityLastViewedOn IN(SELECT Item FROM [dbo].CustomeSplit(@AvailabilityLastViewedOn_Values,','))))
 AND (@AvailabilityLastViewedOn_Min IS NULL OR AvailabilityLastViewedOn >=  @AvailabilityLastViewedOn_Min)
 AND (@AvailabilityLastViewedOn_Max IS NULL OR AvailabilityLastViewedOn <=  @AvailabilityLastViewedOn_Max)
 AND (@QuoteID_Values IS NULL OR  (@QuoteID_Values = '###NULL###' AND QuoteID IS NULL ) OR (@QuoteID_Values <> '###NULL###' AND QuoteID IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteID_Values,','))))
 AND (@QuoteID_Min IS NULL OR QuoteID >=  @QuoteID_Min)
 AND (@QuoteID_Max IS NULL OR QuoteID <=  @QuoteID_Max)
 AND (@Total_Values IS NULL OR  (@Total_Values = '###NULL###' AND Total IS NULL ) OR (@Total_Values <> '###NULL###' AND Total IN(SELECT Item FROM [dbo].CustomeSplit(@Total_Values,','))))
 AND (@Total_Min IS NULL OR Total >=  @Total_Min)
 AND (@Total_Max IS NULL OR Total <=  @Total_Max)
 AND (@EnteredDate_Values IS NULL OR  (@EnteredDate_Values = '###NULL###' AND EnteredDate IS NULL ) OR (@EnteredDate_Values <> '###NULL###' AND EnteredDate IN(SELECT Item FROM [dbo].CustomeSplit(@EnteredDate_Values,','))))
 AND (@EnteredDate_Min IS NULL OR EnteredDate >=  @EnteredDate_Min)
 AND (@EnteredDate_Max IS NULL OR EnteredDate <=  @EnteredDate_Max)
 AND (@LastModifiedDate_Values IS NULL OR  (@LastModifiedDate_Values = '###NULL###' AND LastModifiedDate IS NULL ) OR (@LastModifiedDate_Values <> '###NULL###' AND LastModifiedDate IN(SELECT Item FROM [dbo].CustomeSplit(@LastModifiedDate_Values,','))))
 AND (@LastModifiedDate_Min IS NULL OR LastModifiedDate >=  @LastModifiedDate_Min)
 AND (@LastModifiedDate_Max IS NULL OR LastModifiedDate <=  @LastModifiedDate_Max)
 AND (@DeliveryDate_Values IS NULL OR  (@DeliveryDate_Values = '###NULL###' AND DeliveryDate IS NULL ) OR (@DeliveryDate_Values <> '###NULL###' AND DeliveryDate IN(SELECT Item FROM [dbo].CustomeSplit(@DeliveryDate_Values,','))))
 AND (@DeliveryDate_Min IS NULL OR DeliveryDate >=  @DeliveryDate_Min)
 AND (@DeliveryDate_Max IS NULL OR DeliveryDate <=  @DeliveryDate_Max)
 AND (@ReturnDate_Values IS NULL OR  (@ReturnDate_Values = '###NULL###' AND ReturnDate IS NULL ) OR (@ReturnDate_Values <> '###NULL###' AND ReturnDate IN(SELECT Item FROM [dbo].CustomeSplit(@ReturnDate_Values,','))))
 AND (@ReturnDate_Min IS NULL OR ReturnDate >=  @ReturnDate_Min)
 AND (@ReturnDate_Max IS NULL OR ReturnDate <=  @ReturnDate_Max)
 AND (@ShowDays_Values IS NULL OR  (@ShowDays_Values = '###NULL###' AND ShowDays IS NULL ) OR (@ShowDays_Values <> '###NULL###' AND ShowDays IN(SELECT Item FROM [dbo].CustomeSplit(@ShowDays_Values,','))))
 AND (@ShowDays_Min IS NULL OR ShowDays >=  @ShowDays_Min)
 AND (@ShowDays_Max IS NULL OR ShowDays <=  @ShowDays_Max)
 AND (@SalesRep IS NULL OR (@SalesRep = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep <> '###NULL###' AND SalesRep LIKE '%'+@SalesRep+'%'))
 AND (@SalesRep_Values IS NULL OR (@SalesRep_Values = '###NULL###' AND SalesRep IS NULL ) OR (@SalesRep_Values <> '###NULL###' AND SalesRep IN(SELECT Item FROM [dbo].CustomeSplit(@SalesRep_Values,','))))
 AND (@Employeeid_Values IS NULL OR  (@Employeeid_Values = '###NULL###' AND Employeeid IS NULL ) OR (@Employeeid_Values <> '###NULL###' AND Employeeid IN(SELECT Item FROM [dbo].CustomeSplit(@Employeeid_Values,','))))
 AND (@Employeeid_Min IS NULL OR Employeeid >=  @Employeeid_Min)
 AND (@Employeeid_Max IS NULL OR Employeeid <=  @Employeeid_Max)
 AND (@ApprovedByEmp IS NULL OR (@ApprovedByEmp = '###NULL###' AND ApprovedByEmp IS NULL ) OR (@ApprovedByEmp <> '###NULL###' AND ApprovedByEmp LIKE '%'+@ApprovedByEmp+'%'))
 AND (@ApprovedByEmp_Values IS NULL OR (@ApprovedByEmp_Values = '###NULL###' AND ApprovedByEmp IS NULL ) OR (@ApprovedByEmp_Values <> '###NULL###' AND ApprovedByEmp IN(SELECT Item FROM [dbo].CustomeSplit(@ApprovedByEmp_Values,','))))
 AND (@ReviewedBy IS NULL OR (@ReviewedBy = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy <> '###NULL###' AND ReviewedBy LIKE '%'+@ReviewedBy+'%'))
 AND (@ReviewedBy_Values IS NULL OR (@ReviewedBy_Values = '###NULL###' AND ReviewedBy IS NULL ) OR (@ReviewedBy_Values <> '###NULL###' AND ReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedBy_Values,','))))
 AND (@ProjectLead IS NULL OR (@ProjectLead = '###NULL###' AND ProjectLead IS NULL ) OR (@ProjectLead <> '###NULL###' AND ProjectLead LIKE '%'+@ProjectLead+'%'))
 AND (@ProjectLead_Values IS NULL OR (@ProjectLead_Values = '###NULL###' AND ProjectLead IS NULL ) OR (@ProjectLead_Values <> '###NULL###' AND ProjectLead IN(SELECT Item FROM [dbo].CustomeSplit(@ProjectLead_Values,','))))
 AND (@Activity IS NULL OR (@Activity = '###NULL###' AND Activity IS NULL ) OR (@Activity <> '###NULL###' AND Activity LIKE '%'+@Activity+'%'))
 AND (@Activity_Values IS NULL OR (@Activity_Values = '###NULL###' AND Activity IS NULL ) OR (@Activity_Values <> '###NULL###' AND Activity IN(SELECT Item FROM [dbo].CustomeSplit(@Activity_Values,','))))
 AND (@Interest IS NULL OR (@Interest = '###NULL###' AND Interest IS NULL ) OR (@Interest <> '###NULL###' AND Interest LIKE '%'+@Interest+'%'))
 AND (@Interest_Values IS NULL OR (@Interest_Values = '###NULL###' AND Interest IS NULL ) OR (@Interest_Values <> '###NULL###' AND Interest IN(SELECT Item FROM [dbo].CustomeSplit(@Interest_Values,','))))
 AND (@Branch IS NULL OR (@Branch = '###NULL###' AND Branch IS NULL ) OR (@Branch <> '###NULL###' AND Branch LIKE '%'+@Branch+'%'))
 AND (@Branch_Values IS NULL OR (@Branch_Values = '###NULL###' AND Branch IS NULL ) OR (@Branch_Values <> '###NULL###' AND Branch IN(SELECT Item FROM [dbo].CustomeSplit(@Branch_Values,','))))
 AND (@ShipCity IS NULL OR (@ShipCity = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity <> '###NULL###' AND ShipCity LIKE '%'+@ShipCity+'%'))
 AND (@ShipCity_Values IS NULL OR (@ShipCity_Values = '###NULL###' AND ShipCity IS NULL ) OR (@ShipCity_Values <> '###NULL###' AND ShipCity IN(SELECT Item FROM [dbo].CustomeSplit(@ShipCity_Values,','))))
 AND (@ShipState IS NULL OR (@ShipState = '###NULL###' AND ShipState IS NULL ) OR (@ShipState <> '###NULL###' AND ShipState LIKE '%'+@ShipState+'%'))
 AND (@ShipState_Values IS NULL OR (@ShipState_Values = '###NULL###' AND ShipState IS NULL ) OR (@ShipState_Values <> '###NULL###' AND ShipState IN(SELECT Item FROM [dbo].CustomeSplit(@ShipState_Values,','))))
 AND (@approvedby_Values IS NULL OR  (@approvedby_Values = '###NULL###' AND approvedby IS NULL ) OR (@approvedby_Values <> '###NULL###' AND approvedby IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby_Values,','))))
 AND (@approvedby_Min IS NULL OR approvedby >=  @approvedby_Min)
 AND (@approvedby_Max IS NULL OR approvedby <=  @approvedby_Max)
 AND (@approvedby2_Values IS NULL OR  (@approvedby2_Values = '###NULL###' AND approvedby2 IS NULL ) OR (@approvedby2_Values <> '###NULL###' AND approvedby2 IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby2_Values,','))))
 AND (@approvedby2_Min IS NULL OR approvedby2 >=  @approvedby2_Min)
 AND (@approvedby2_Max IS NULL OR approvedby2 <=  @approvedby2_Max)
 AND (@approvedby3_Values IS NULL OR  (@approvedby3_Values = '###NULL###' AND approvedby3 IS NULL ) OR (@approvedby3_Values <> '###NULL###' AND approvedby3 IN(SELECT Item FROM [dbo].CustomeSplit(@approvedby3_Values,','))))
 AND (@approvedby3_Min IS NULL OR approvedby3 >=  @approvedby3_Min)
 AND (@approvedby3_Max IS NULL OR approvedby3 <=  @approvedby3_Max)
 AND (@QuoteJobCost_Values IS NULL OR  (@QuoteJobCost_Values = '###NULL###' AND QuoteJobCost IS NULL ) OR (@QuoteJobCost_Values <> '###NULL###' AND QuoteJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteJobCost_Values,','))))
 AND (@QuoteJobCost_Min IS NULL OR QuoteJobCost >=  @QuoteJobCost_Min)
 AND (@QuoteJobCost_Max IS NULL OR QuoteJobCost <=  @QuoteJobCost_Max)
 AND (@PreJobCost_Values IS NULL OR  (@PreJobCost_Values = '###NULL###' AND PreJobCost IS NULL ) OR (@PreJobCost_Values <> '###NULL###' AND PreJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@PreJobCost_Values,','))))
 AND (@PreJobCost_Min IS NULL OR PreJobCost >=  @PreJobCost_Min)
 AND (@PreJobCost_Max IS NULL OR PreJobCost <=  @PreJobCost_Max)
 AND (@PostJobCost_Values IS NULL OR  (@PostJobCost_Values = '###NULL###' AND PostJobCost IS NULL ) OR (@PostJobCost_Values <> '###NULL###' AND PostJobCost IN(SELECT Item FROM [dbo].CustomeSplit(@PostJobCost_Values,','))))
 AND (@PostJobCost_Min IS NULL OR PostJobCost >=  @PostJobCost_Min)
 AND (@PostJobCost_Max IS NULL OR PostJobCost <=  @PostJobCost_Max)
 AND (@Show IS NULL OR (@Show = '###NULL###' AND Show IS NULL ) OR (@Show <> '###NULL###' AND Show LIKE '%'+@Show+'%'))
 AND (@Show_Values IS NULL OR (@Show_Values = '###NULL###' AND Show IS NULL ) OR (@Show_Values <> '###NULL###' AND Show IN(SELECT Item FROM [dbo].CustomeSplit(@Show_Values,','))))
 AND (@ProductionFlag IS NULL OR (@ProductionFlag = '###NULL###' AND ProductionFlag IS NULL ) OR (@ProductionFlag <> '###NULL###' AND ProductionFlag LIKE '%'+@ProductionFlag+'%'))
 AND (@ProductionFlag_Values IS NULL OR (@ProductionFlag_Values = '###NULL###' AND ProductionFlag IS NULL ) OR (@ProductionFlag_Values <> '###NULL###' AND ProductionFlag IN(SELECT Item FROM [dbo].CustomeSplit(@ProductionFlag_Values,','))))
 AND (@QuoteTypeNo_Values IS NULL OR  (@QuoteTypeNo_Values = '###NULL###' AND QuoteTypeNo IS NULL ) OR (@QuoteTypeNo_Values <> '###NULL###' AND QuoteTypeNo IN(SELECT Item FROM [dbo].CustomeSplit(@QuoteTypeNo_Values,','))))
 AND (@QuoteTypeNo_Min IS NULL OR QuoteTypeNo >=  @QuoteTypeNo_Min)
 AND (@QuoteTypeNo_Max IS NULL OR QuoteTypeNo <=  @QuoteTypeNo_Max)
 AND (@LastApprovedBy IS NULL OR (@LastApprovedBy = '###NULL###' AND LastApprovedBy IS NULL ) OR (@LastApprovedBy <> '###NULL###' AND LastApprovedBy LIKE '%'+@LastApprovedBy+'%'))
 AND (@LastApprovedBy_Values IS NULL OR (@LastApprovedBy_Values = '###NULL###' AND LastApprovedBy IS NULL ) OR (@LastApprovedBy_Values <> '###NULL###' AND LastApprovedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastApprovedBy_Values,','))))
 AND (@QApprovedByDateTime_Values IS NULL OR  (@QApprovedByDateTime_Values = '###NULL###' AND QApprovedByDateTime IS NULL ) OR (@QApprovedByDateTime_Values <> '###NULL###' AND QApprovedByDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@QApprovedByDateTime_Values,','))))
 AND (@QApprovedByDateTime_Min IS NULL OR QApprovedByDateTime >=  @QApprovedByDateTime_Min)
 AND (@QApprovedByDateTime_Max IS NULL OR QApprovedByDateTime <=  @QApprovedByDateTime_Max)
 AND (@LastReviewedBy IS NULL OR (@LastReviewedBy = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy <> '###NULL###' AND LastReviewedBy LIKE '%'+@LastReviewedBy+'%'))
 AND (@LastReviewedBy_Values IS NULL OR (@LastReviewedBy_Values = '###NULL###' AND LastReviewedBy IS NULL ) OR (@LastReviewedBy_Values <> '###NULL###' AND LastReviewedBy IN(SELECT Item FROM [dbo].CustomeSplit(@LastReviewedBy_Values,','))))
 AND (@ReviewedDateTime_Values IS NULL OR  (@ReviewedDateTime_Values = '###NULL###' AND ReviewedDateTime IS NULL ) OR (@ReviewedDateTime_Values <> '###NULL###' AND ReviewedDateTime IN(SELECT Item FROM [dbo].CustomeSplit(@ReviewedDateTime_Values,','))))
 AND (@ReviewedDateTime_Min IS NULL OR ReviewedDateTime >=  @ReviewedDateTime_Min)
 AND (@ReviewedDateTime_Max IS NULL OR ReviewedDateTime <=  @ReviewedDateTime_Max)
 AND (@LoadInDate_Values IS NULL OR  (@LoadInDate_Values = '###NULL###' AND LoadInDate IS NULL ) OR (@LoadInDate_Values <> '###NULL###' AND LoadInDate IN(SELECT Item FROM [dbo].CustomeSplit(@LoadInDate_Values,','))))
 AND (@LoadInDate_Min IS NULL OR LoadInDate >=  @LoadInDate_Min)
 AND (@LoadInDate_Max IS NULL OR LoadInDate <=  @LoadInDate_Max)
 AND (@LoadInTime IS NULL OR (@LoadInTime = '###NULL###' AND LoadInTime IS NULL ) OR (@LoadInTime <> '###NULL###' AND LoadInTime LIKE '%'+@LoadInTime+'%'))
 AND (@LoadInTime_Values IS NULL OR (@LoadInTime_Values = '###NULL###' AND LoadInTime IS NULL ) OR (@LoadInTime_Values <> '###NULL###' AND LoadInTime IN(SELECT Item FROM [dbo].CustomeSplit(@LoadInTime_Values,','))))
 AND (@LoadOutDate_Values IS NULL OR  (@LoadOutDate_Values = '###NULL###' AND LoadOutDate IS NULL ) OR (@LoadOutDate_Values <> '###NULL###' AND LoadOutDate IN(SELECT Item FROM [dbo].CustomeSplit(@LoadOutDate_Values,','))))
 AND (@LoadOutDate_Min IS NULL OR LoadOutDate >=  @LoadOutDate_Min)
 AND (@LoadOutDate_Max IS NULL OR LoadOutDate <=  @LoadOutDate_Max)
 AND (@LoadOutTime IS NULL OR (@LoadOutTime = '###NULL###' AND LoadOutTime IS NULL ) OR (@LoadOutTime <> '###NULL###' AND LoadOutTime LIKE '%'+@LoadOutTime+'%'))
 AND (@LoadOutTime_Values IS NULL OR (@LoadOutTime_Values = '###NULL###' AND LoadOutTime IS NULL ) OR (@LoadOutTime_Values <> '###NULL###' AND LoadOutTime IN(SELECT Item FROM [dbo].CustomeSplit(@LoadOutTime_Values,','))))
 
) AS RowConstrainedResult
WHERE (@Page_Size IS NULL) OR (RowNum >= @Page_Size*(ISNULL(@Page_Index,1)-1)+1 AND RowNum <= @Page_Size*ISNULL(@Page_Index,1))
ORDER BY RowNum
END
SET NOCOUNT OFF;
END

GO

CREATE VIEW [dbo].[VW_DailyQuotesData]
AS
SELECT c.CustName, q.QuoteRentalID,
                      (SELECT TOP (1) InvoiceID
                       FROM      dbo.tblInvoice AS i WITH (NOLOCK)
                       WHERE   (CustID = c.CustID) AND (RentalID <> q.QuoteRentalID)) AS HasRentedBefore, c.CustID, c.OrderFrequency, c.ProjectedRevenue, e.EmployeeName AS custaccountrep, q.isShortage, q.ShortageQty, q.InterestType, 
                  q.QConfirmationDate, q.QuoteConfirmationStatus, q.QuoteCancelNote, q.AvailabilityLastViewedBy, q.AvailabilityLastViewedOn, q.QuoteID, ISNULL(q.QuoteEquipRented + q.QuoteLabor + q.QuoteDelivery + q.QuoteFreight, 0) AS Total, 
                  q.QuoteEnteredDate AS EnteredDate, q.QuoteLastModified AS LastModifiedDate, q.DeliveryDate, q.ReturnDate, ISNULL(DATEDIFF(DAY, q.LoadInDate, q.LoadOutDate) + 1, 0) AS ShowDays, e.EmployeeName AS SalesRep, 
                  ISNULL(e.EmployeeID, 0) AS Employeeid, e2.EmployeeName AS ApprovedByEmp, e4.EmployeeName AS ReviewedBy, CASE WHEN (q.ProjectLead = - 1) THEN '--N/A--' ELSE CASE WHEN (q.ProjectLead = - 2) 
                  THEN '--To Be Filled--' ELSE e1.employeename END END AS ProjectLead, q.ShippingID AS Activity, qt.QuoteType AS Interest, b.BranchCode AS Branch, q.ShipCity, q.ShipState, ISNULL(jc.ApprovedBy, 0) AS approvedby, 
                  ISNULL(jc.ApprovedBy2, 0) AS approvedby2, ISNULL(jc.ApprovedBy3, 0) AS approvedby3, CASE WHEN (jc.approvedby > 0) THEN (jc.totalprofit / CASE WHEN (ISNULL(jc.EquipTotal + jc.LaborTotal + jc.DeliveryTotal + jc.FreightTotal, 0)) 
                  = 0 THEN 1 ELSE (ISNULL(jc.EquipTotal + jc.LaborTotal + jc.DeliveryTotal + jc.FreightTotal, 0)) END) ELSE (jc.totalprofit / (CASE WHEN ISNULL(QuoteEquipRented + QuoteLabor + QuoteDelivery + QuoteFreight, 0) 
                  = 0 THEN 1 ELSE ISNULL(QuoteEquipRented + QuoteLabor + QuoteDelivery + QuoteFreight, 0) END)) END AS QuoteJobCost, CASE WHEN (jc.approvedby2 > 0) 
                  THEN (jc.totalprofit2 / CASE WHEN (ISNULL(jc.EquipTotal2 + jc.LaborTotal2 + jc.DeliveryTotal2 + jc.FreightTotal2, 0)) = 0 THEN 1 ELSE (ISNULL(jc.EquipTotal2 + jc.LaborTotal2 + jc.DeliveryTotal2 + jc.FreightTotal2, 0)) END) 
                  ELSE (jc.totalprofit2 / CASE WHEN (ISNULL(QuoteEquipRented + QuoteLabor + QuoteDelivery + QuoteFreight, 0)) = 0 THEN 1 ELSE (ISNULL(QuoteEquipRented + QuoteLabor + QuoteDelivery + QuoteFreight, 0)) END) END AS PreJobCost, 
                  jc.totalprofit3 / CASE WHEN ISNULL(q.QuoteEquipRented + q.QuoteLabor + q.QuoteDelivery + q.QuoteFreight, 0) = 0 THEN 1 ELSE ISNULL(q.QuoteEquipRented + q.QuoteLabor + q.QuoteDelivery + q.QuoteFreight, 0) END AS PostJobCost, 
                  q.QuoteShowname AS Show, '' AS ProductionFlag, qt.QuoteTypeNo, e3.EmployeeName AS LastApprovedBy, q.QApprovedByDateTime, e5.EmployeeName AS LastReviewedBy, q.ReviewedDateTime, ISNULL(q.LoadInDate, '') 
                  AS LoadInDate, ISNULL(q.LoadInTime, '') AS LoadInTime, ISNULL(q.LoadOutDate, '') AS LoadOutDate, ISNULL(q.LoadOutTime, '') AS LoadOutTime
FROM     dbo.tblQuote AS q INNER JOIN
                  dbo.tblCustomers AS c ON q.CustID = c.CustID LEFT OUTER JOIN
                  dbo.tblEmployee AS e WITH (NOLOCK) ON q.SalesRep = e.EmployeeID INNER JOIN
                  dbo.tblBranch AS b WITH (NOLOCK) ON q.QuoteOriginatingBranchId = b.BranchID LEFT OUTER JOIN
                  dbo.tblEmployee AS e6 WITH (NOLOCK) ON c.CustAccountRep = e6.EmployeeID LEFT OUTER JOIN
                  dbo.tblEmployee AS e5 WITH (NOLOCK) ON q.QLastReviewedBy = e5.EmployeeID LEFT OUTER JOIN
                  dbo.tblEmployee AS e4 WITH (NOLOCK) ON q.ReviewedBy = e4.EmployeeID LEFT OUTER JOIN
                  dbo.tblEmployee AS e3 WITH (NOLOCK) ON q.QLastApprovedBy = e3.EmployeeID LEFT OUTER JOIN
                  dbo.tblJobCost AS jc WITH (NOLOCK) ON q.QuoteID = jc.Quoteid LEFT OUTER JOIN
                  dbo.tblEmployee AS e1 WITH (NOLOCK) ON q.ProjectLead = e1.EmployeeID LEFT OUTER JOIN
                  dbo.tblEmployee AS e2 WITH (NOLOCK) ON q.QApprovedBy = e2.EmployeeID LEFT OUTER JOIN
                  dbo.tblQuoteTypes AS qt WITH (NOLOCK) ON q.InterestType = qt.QuoteTypeNo
GO

IF NOT EXISTS(SELECT 1 FROM [UM_ChildMenu] WITH(NOLOCK) WHERE [ActionName] = 'EquipmentSearchReport' AND [ControllerName] = 'Reports' )
BEGIN
	 BEGIN TRANSACTION  [UM_ChildMenu]
	 BEGIN TRY

		INSERT INTO [dbo].[UM_ChildMenu] ([MenuID],[ParentID],[LinkText],[Description],[ActionName],[ControllerName],[HtmlAttributes],[RouteData],[IsActive],[Sequance],[ActivityName],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy])
		VALUES(4,NULL,' Equipment Search',NULL,'EquipmentSearchReport','Reports',NULL,NULL,1,NULL,'activity_name',GETDATE(),NULL,GETDATE(),NULL)

	  COMMIT TRANSACTION  [UM_ChildMenu]
	  END TRY 
	  BEGIN CATCH
		 SELECT ERROR_MESSAGE() AS ErrorMessage
		 ROLLBACK TRANSACTION [UM_ChildMenu]
	 END CATCH 
END



