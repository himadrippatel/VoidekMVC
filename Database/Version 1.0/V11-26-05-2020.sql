GO
CREATE VIEW [dbo].[VW_DailyQuotesData]
AS
	SELECT ISNULL(c.CustName,'') AS CustName,q.QuoteID,(isnull(q.QuoteEquipRented + q.QuoteLabor + q.QuoteDelivery+ q.QuoteFreight ,0)) AS Total, ISNULL(q.QuoteEnteredDate,'') AS EnteredDate,  ISNULL(q.QuoteLastModified,'' )AS LastModifiedDate, q.DeliveryDate AS DeliveryDate, q.ReturnDate AS ReturnDate,
			 CASE WHEN (jc.approvedby > 0) THEN (jc.totalprofit / CASE WHEN (ISNULL(jc.EquipTotal + jc.LaborTotal + jc.DeliveryTotal + jc.FreightTotal,  0)) = 0 THEN 1 ELSE (ISNULL(jc.EquipTotal + jc.LaborTotal + jc.DeliveryTotal + jc.FreightTotal, 0)) END) 
				 ELSE (jc.totalprofit / (CASE WHEN ISNULL(QuoteEquipRented + QuoteLabor + QuoteDelivery + QuoteFreight, 0) = 0 THEN 1 ELSE ISNULL(QuoteEquipRented + QuoteLabor + QuoteDelivery + QuoteFreight, 0) END)) END AS QuoteJobCost, 
				CASE WHEN (jc.approvedby2 > 0)  THEN (jc.totalprofit2 / CASE WHEN (ISNULL(jc.EquipTotal2 + jc.LaborTotal2 + jc.DeliveryTotal2 + jc.FreightTotal2, 0)) = 0 THEN 1 ELSE (ISNULL(jc.EquipTotal2 + jc.LaborTotal2 + jc.DeliveryTotal2 + jc.FreightTotal2, 0)) END)
				ELSE (jc.totalprofit2 / CASE WHEN (ISNULL(QuoteEquipRented + QuoteLabor + QuoteDelivery + QuoteFreight, 0))  = 0 THEN 1 ELSE (ISNULL(QuoteEquipRented + QuoteLabor + QuoteDelivery + QuoteFreight, 0)) END) END AS PreJobCost,
				jc.totalprofit3 / CASE WHEN ISNULL(q.QuoteEquipRented + q.QuoteLabor + q.QuoteDelivery + q.QuoteFreight,  0) = 0 THEN 1 ELSE ISNULL(q.QuoteEquipRented + q.QuoteLabor + q.QuoteDelivery + q.QuoteFreight, 0) END AS PostJobCost,
                ISNULL((DATEDIFF(DAY, LoadInDate, LoadOutDate) + 1),0) AS ShowDays, e.EmployeeName AS SalesRep, ISNULL(e4.EmployeeName, '') AS ReviewedBy , ISNULL(CASE WHEN (q.ProjectLead = - 1) THEN '--N/A--' ELSE CASE WHEN (q.ProjectLead = - 2) THEN '--To Be Filled--' ELSE e1.employeename END END ,'')AS ProjectLead, 
				b.BranchCode AS Branch, q.ShippingID AS Activity, qt.QuoteType AS Interest, (q.ShipCity +', '+ q.ShipState) AS [ShipCity/State], ISNULL(q.QuoteShowname,'') AS Show
				FROM      dbo.tblQuote AS q INNER JOIN 
                          dbo.tblCustomers AS c  ON q.CustID = c.CustID LEFT OUTER JOIN
                          dbo.tblEmployee AS e  WITH (NOLOCK) ON q.SalesRep = e.EmployeeID INNER JOIN
                          dbo.tblBranch AS b WITH (NOLOCK) ON q.QuoteOriginatingBranchId = b.BranchID LEFT JOIN 
						  --dbo.tblEmployee AS e6 WITH (NOLOCK) ON c.CustAccountRep = e6.EmployeeID  LEFT JOIN 
						  --dbo.tblEmployee AS e5 WITH (NOLOCK) ON q.QLastReviewedBy = e5.EmployeeID LEFT JOIN
                          dbo.tblEmployee AS e4 WITH (NOLOCK) ON q.ReviewedBy = e4.EmployeeID LEFT JOIN 
						  --dbo.tblEmployee AS e3 WITH (NOLOCK) ON q.QLastApprovedBy = e3.EmployeeID LEFT JOIN 
						  dbo.tblJobCost AS jc WITH (NOLOCK) ON q.QuoteID = jc.Quoteid LEFT JOIN
						  dbo.tblEmployee AS e1 WITH (NOLOCK) ON q.ProjectLead = e1.EmployeeID LEFT JOIN 
						  --dbo.tblEmployee AS e2 WITH (NOLOCK) ON q.QApprovedBy = e2.EmployeeID   LEFT JOIN 
						  dbo.tblQuoteTypes AS qt WITH (NOLOCK) ON q.InterestType = qt.QuoteTypeNo 			
--	          ORDER BY ProjectLead, LoadInDate, ShowDays DESC 
GO

