GO
-- =============================================
-- Author:		<Author,Jishan Siddique>
-- Create date: <Create Date,26-04-2020>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spr_at_IsSuperAdmin]
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
		--,[DonotContactDate] DATETIME
		,[DoNotContactBy] NVARCHAR(250)
		,[CustAccountRep] INT
		,[Email] NVARCHAR(250)
		,[Imageurl] NVARCHAR(250)
	) AS [Result]
	WHERE ([US].[UserID] = @UserID OR [US].[Token] = @Toekn)
END

GO
ALTER PROCEDURE [dbo].[spr_at_UM_HeaderSearchTemplate_Customer]
	@Search NVARCHAR(250),
	@SecondrySearch NVARCHAR(250) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
		SELECT TOP 20 
		[CustID]		
		,REPLACE([Customer],'"','') AS [Customer]
		,[WebAddress]
		,[Address]		
		,[Phone]		
		,[Account_Rep]				
		,[CustAccountRep]
		,[Email]
		,[Imageurl]
		FROM [dbo].[fn_CustomerData]() [CustomerData]
		WHERE [CustomerData].[Customer] LIKE '%'+@Search+'%' 
		AND (ISNULL(@SecondrySearch,'')='' OR [CustomerData].[Customer] LIKE '%'+@SecondrySearch+'%' )
	SET NOCOUNT OFF;
END

GO

ALTER PROCEDURE [dbo].[spr_at_UM_HeaderSearchTemplate_CDESCRIPTION]
	@Search NVARCHAR(250),
	@SecondrySearch NVARCHAR(250) = NULL,
	@MISInKitItemsOnly NVARCHAR(250) = NULL,
	@MISIncAccessories NVARCHAR(250) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX)
		SET @SQL = N'SELECT TOP 20 CatId,CDescription as Category,Price,Cat1,Cat2,Cat3,Cat4,Cat5,DefaultFile,CatType as Type,CatFeatures
		FROM [dbo].[tblcat]
		WHERE [CDescription] LIKE ''%''+@Search+''%'' 
		AND (ISNULL(@SecondrySearch,'''')='''' OR [CDescription] LIKE ''%''+@SecondrySearch+''%'' )'
	IF @MISInKitItemsOnly IS NOT NULL        
            BEGIN        
                SET @SQL = @SQL + N' AND [PartOfKitOnly] <> 1'    
            END    
	ELSE
		BEGIN
			SET @SQL = @SQL + N' AND [PartOfKitOnly] = 1'
		END
	IF @MISIncAccessories IS NOT NULL        
            BEGIN        
                SET @SQL = @SQL + N' cattype<>''accessory'''    
            END    
	 EXECUTE SP_EXECUTESQL @SQL,        
            N'@Search NVARCHAR(250),
			@SecondrySearch NVARCHAR(250),
			@MISInKitItemsOnly NVARCHAR(250),
			@MISIncAccessories NVARCHAR(250)'
            ,@Search = @Search
            ,@SecondrySearch = @SecondrySearch
            ,@MISInKitItemsOnly = @MISInKitItemsOnly
			,@MISIncAccessories = @MISIncAccessories
	SET NOCOUNT OFF;
END

GO
ALTER PROCEDURE [dbo].[spr_at_UM_HeaderSearchTemplate_Email]
	@Search NVARCHAR(250)
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT 
	TOP 20 [CustomerData].*
	,ISNULL([wqrycontactcust].[ContactEmail],'') [CEmail]
	FROM [dbo].[fn_CustomerData] () [CustomerData]
	LEFT JOIN
	(
		SELECT [contactemail],[CustId] 
	   FROM
		  [dbo].[wqrycontactcust] WITH(NOLOCK)
	) AS [wqrycontactcust]
		ON [CustomerData].[custid] = [wqrycontactcust].[custid] 
	LEFT JOIN [dbo].[tblEmployee] [tblEmployee] WITH(NOLOCK)       
		ON [CustomerData].[CustAccountRep] = [tblEmployee].[EmployeeID] 
	WHERE CONCAT([wqrycontactcust].[ContactEmail],' ',[CustomerData].[Email]) LIKE '%'+@Search+'%'

	SET NOCOUNT OFF;
END

GO


/*-- =============================================
-- Author      : Jishan Siddique
-- Create date : 2020-03-15
-- Description : Select Procedure for UM_Role
-- Exec [dbo].[spr_tb_UM_Role_Search]
-- ============================================= */
ALTER PROCEDURE [dbo].[spr_tb_UM_Role_SearchAll_V2]
     @ResultCount INT OUTPUT
    ,@Page INT = NULL
    ,@PageSize INT = NULL
    ,@Filter NVARCHAR(MAX) = NULL
    ,@SortOrder VARCHAR(MAX) = NULL
AS
BEGIN

    DECLARE @Query NVARCHAR(MAX)=NULL,@CountQuery NVARCHAR(MAX) = NULL;
    DECLARE @WhereClause NVARCHAR(MAX)=NULL
    SET @Query=';with RoleTree AS
		(
			SELECT 
			[RoleID]
			,[Name]
			,[ParentID]
			,[IsActive]
			,[CreatedOn]
			,[CreatedBy]
			,[UpdatedOn]
			,[UpdatedBy]
			,[Level] = 1
			,[Path] = CAST('''' AS VARCHAR(100)) 
			,[Name] AS [ParentName]
			FROM [dbo].[UM_Role] [ParentRole] WITH(NOLOCK)
			WHERE [ParentID] IS NULL
				UNION ALL
			SELECT 
			 [ChildRole].[RoleID]
			,[ChildRole].[Name]
			,[ChildRole].[ParentID]
			,[ChildRole].[IsActive]
			,[ChildRole].[CreatedOn]
			,[ChildRole].[CreatedBy]
			,[ChildRole].[UpdatedOn]
			,[ChildRole].[UpdatedBy]
			,[Level] = [RT].[Level] + 1
			,[Path] =  CAST([RT].[Path]+''>>''+[RT].[Name] AS VARCHAR(100))
			,[RT].[Name] AS [ParentName]
			FROM [dbo].[UM_Role] [ChildRole] WITH(NOLOCK) 
			INNER JOIN RoleTree [RT] ON [RT].[RoleID] = [ChildRole].[ParentID]
		)
		SELECT [RoleID]
			,[ParentID]
			,[IsActive]
			,[CreatedOn]
			,[CreatedBy]
			,[UpdatedOn]
			,[UpdatedBy]
			,[Level]
			,[Path]
			,CASE WHEN [ParentID] IS NOT NULL THEN CONCAT(SUBSTRING([Path], 3, LEN([Path])),''>>'',[Name]) ELSE [Name] END [Name]
			,CASE WHEN [ParentID] IS NULL THEN NULL ELSE [ParentName] END [ParentName]
		FROM RoleTree'
    
	IF @Filter <> ''
    BEGIN
        SET @WhereClause=' WHERE '+@Filter
        SET @Query = CONCAT(@Query,@WhereClause)
    END

    IF @SortOrder <> ''
    BEGIN
        SET @Query = CONCAT(@Query,' ORDER BY '+@SortOrder)
    END
    ELSE
    BEGIN
        SET @Query = CONCAT(@Query,' ORDER BY 1 DESC')
    END

    IF NOT (@Page IS NULL OR @PageSize IS NULL)
    BEGIN
        DECLARE @ResultOutput TABLE (out int)
		SET @CountQuery  = ';with RoleTree AS
		(
			SELECT 
			[RoleID]
			,[Name]
			,[ParentID]
			,[IsActive]
			,[CreatedOn]
			,[CreatedBy]
			,[UpdatedOn]
			,[UpdatedBy]
			,[Level] = 1
			,[Path] = CAST('''' AS VARCHAR(100)) 
			,[Name] AS [ParentName]
			FROM [dbo].[UM_Role] [ParentRole] WITH(NOLOCK)
			WHERE [ParentID] IS NULL
				UNION ALL
			SELECT 
			 [ChildRole].[RoleID]
			,[ChildRole].[Name]
			,[ChildRole].[ParentID]
			,[ChildRole].[IsActive]
			,[ChildRole].[CreatedOn]
			,[ChildRole].[CreatedBy]
			,[ChildRole].[UpdatedOn]
			,[ChildRole].[UpdatedBy]
			,[Level] = [RT].[Level] + 1
			,[Path] =  CAST([RT].[Path]+''>>''+[RT].[Name] AS VARCHAR(100))
			,[RT].[Name] AS [ParentName]
			FROM [dbo].[UM_Role] [ChildRole] WITH(NOLOCK) 
			INNER JOIN RoleTree [RT] ON [RT].[RoleID] = [ChildRole].[ParentID]
		)
		SELECT COUNT(1)
		FROM RoleTree'
        INSERT INTO @ResultOutput EXEC(@CountQuery + @WhereClause)
        SET @ResultCount = (SELECT * from @ResultOutput)
    END

    IF (@Page IS NOT NULL AND @PageSize IS NOT NULL)
    BEGIN
        SET @Query = CONCAT(@Query,' OFFSET ',(@PageSize * (@Page - 1)),' ROWS  FETCH NEXT ',@PageSize,' ROWS ONLY;')
    END
	EXEC(@Query)

    IF(1=0) BEGIN SELECT TOP 1 * FROM [dbo].[UM_Role]  (NOLOCK)  END
END

GO
ALTER PROCEDURE [dbo].[spr_at_UM_HeaderSearchTemplate_CLIENTPOId]
		@Search VARCHAR(250)
AS
BEGIN
	SET NOCOUNT ON;	
		DECLARE @operator VARCHAR(10) = IIF(ISNUMERIC(@Search)=1,'eq','contain')
		SELECT  TOP 20		
		  [tblQuote].[quoteid] AS [QuoteNo]
		 ,[CustomerData].[CustID]		 
		 ,REPLACE([CustomerData].[Customer]	,'"','') [Customer]	 
		 ,[CustomerData].[WebAddress]
		 ,[CustomerData].[Address]		
		 ,[CustomerData].[Phone] 		
		FROM [dbo].[fn_CustomerData]() [CustomerData]
		INNER JOIN [dbo].[tblQuote] [tblQuote] WITH(NOLOCK) 		
		ON [tblQuote].[CustID] = [CustomerData].[CustID]
		WHERE
		(
			(
				(@operator='contain') AND 
				CASE WHEN  ISNUMERIC(@Search) = 0 
					THEN [CustomerData].[Customer]
				ELSE '1'	
				END LIKE
				CASE WHEN ISNUMERIC(@Search) = 0
					THEN '%'+@Search+'%'
				ELSE '1'
				END
			)
			OR
			(
				(@operator='eq') And CASE WHEN ISNUMERIC(@Search) = 1
					THEN  [tblQuote].[quoteid] 
				ELSE '1'
				END =
				CASE WHEN ISNUMERIC(@Search) = 1
					THEN @Search
				ELSE '1' 
				End
			)
		)
	SET NOCOUNT OFF;
END

GO
ALTER PROCEDURE [dbo].[spr_at_UM_HeaderSearchTemplate_POID]
	@Search VARCHAR(250)
AS
BEGIN	
	SET NOCOUNT ON;	
		DECLARE @operator VARCHAR(10) = IIF(ISNUMERIC(@Search)=1,'eq','contain')
		SELECT  TOP 20		
		  [tblPurchase].[PurchaseID] AS [PONo]
		 ,[CustomerData].[CustID]		 
		 ,REPLACE([CustomerData].[Customer]	,'"','') [Customer]	 
		 ,[CustomerData].[WebAddress]
		 ,[CustomerData].[Address]		
		 ,[CustomerData].[Phone] 		
		FROM [dbo].[fn_CustomerData]() [CustomerData]
		INNER JOIN [dbo].[tblpurchase] [tblPurchase] WITH(NOLOCK) 		
		ON [tblPurchase].[CustID] = [CustomerData].[CustID]
		WHERE
		(
			(
				(@operator='contain') AND 
				CASE WHEN  ISNUMERIC(@Search) = 0 
					THEN [CustomerData].[Customer]
				ELSE '1'	
				END LIKE
				CASE WHEN ISNUMERIC(@Search) = 0
					THEN '%'+@Search+'%'
				ELSE '1'
				END
			)
			OR
			(
				(@operator='eq') And CASE WHEN ISNUMERIC(@Search) = 1
					THEN  [tblPurchase].[PurchaseID] 
				ELSE '1'
				END =
				CASE WHEN ISNUMERIC(@Search) = 1
					THEN @Search
				ELSE '1' 
				End
			)
		)
	SET NOCOUNT OFF;
END

GO
ALTER PROCEDURE [dbo].[spr_at_UM_HeaderSearchTemplate_First_LastName]
	@Search NVARCHAR(250),
	@SecondrySearch NVARCHAR(250) = NULL
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT TOP 20
	 CONCAT(REPLACE([tblContact].[ContactFirstName],'"',''),' ',REPLACE([tblContact].[ContactLastName],'"','')) [FirstLastName]
	,[CustomerData].[CustID]	
	,REPLACE([CustomerData].[Customer],'"','') [Customer]
	,[CustomerData].[WebAddress]
	,[CustomerData].[Address]	
	,[CustomerData].[Phone]	
	FROM [dbo].[fn_CustomerData]() [CustomerData]
	INNER JOIN [dbo].[tblContact] WITH(NOLOCK) ON [CustomerData].[CustID] = [tblContact].[CustId] 
	WHERE CONCAT([tblContact].[ContactFirstName],' ',[tblContact].[ContactLastName]) 
	LIKE '%'+@Search+'%'
	AND (ISNULL(@SecondrySearch,'')='' OR CONCAT([tblContact].[ContactFirstName],' ',[tblContact].[ContactLastName])  LIKE '%'+@SecondrySearch+'%' )
	SET NOCOUNT OFF;
END