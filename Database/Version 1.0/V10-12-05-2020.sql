USE [alliant_mvc]
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_tblBranch_BranchDropDown]    Script Date: 11-05-2020 23:56:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,11-05-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_tblBranch_BranchDropDown]
	@IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [BranchID],
		   [BranchCode],
		   [BranchName],
		   [Active] 
		   FROM [dbo].[tblBranch] WITH(NOLOCK)
		   WHERE 1 = CASE WHEN @IsActive = 1 AND [Active] = 'YES' THEN 1 
				WHEN @IsActive = 0 AND [Active] = 'NO' THEN 1 
	        ELSE 1 END	
			ORDER BY [BranchCode]
	SET NOCOUNT OFF;
END
GO

/****** Object:  StoredProcedure [dbo].[spr_tb_tblEmployee_EmployeeDropDown]    Script Date: 11-05-2020 23:56:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,11-05-2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_tb_tblEmployee_EmployeeDropDown] 
	@IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT	 [EmployeeID]
			,[EmployeeName]		
			,[Active]
	FROM [dbo].[tblEmployee] WITH(NOLOCK)
	WHERE 1 = CASE WHEN @IsActive = 1 AND [Active] = 'YES' THEN 1 
				WHEN @IsActive = 0 AND [Active] = 'NO' THEN 1 
	        ELSE 1 END	
	ORDER BY [EmployeeName]
	SET NOCOUNT OFF;
END
GO

