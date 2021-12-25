﻿CREATE TABLE [dbo].[AM_Icon](
	[IconID] [int] IDENTITY(1,1) NOT NULL,
	[ICon] [varchar](100) NOT NULL,
	[IconName] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_AM_Icon] PRIMARY KEY CLUSTERED 
(
	[IconID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AM_Icon] ADD  CONSTRAINT [DF_AM_Icon_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[AM_Icon] ADD  CONSTRAINT [DF_AM_Icon_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_ICon_GetByID]    Script Date: 25-04-2020 12:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_ICon_Insert]    Script Date: 25-04-2020 12:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_ICon_Search]    Script Date: 25-04-2020 12:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


GO

/****** Object:  StoredProcedure [dbo].[spr_tb_AM_ICon_Update]    Script Date: 25-04-2020 12:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


GO


