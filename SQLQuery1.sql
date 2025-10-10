if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DataTypes]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DataTypes]
GO

CREATE TABLE [dbo].[DataTypes]
(
	[DataType_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Name] [varchar](100) NOT NULL UNIQUE,
)
GO
insert into [dbo].[DataTypes] values 
(
('int'), ('float'), ('varchar100'), ('varchar200'), ('varchar500'), ('MONEY'), ('DATETIME')
)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Attributes]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Attributes]
GO

CREATE TABLE [dbo].[Attributes]
(
	[Attribute_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Name] [varchar](200) NOT NULL,
	[Type] [int] NOT NULL FOREIGN KEY REFERENCES[DataTypes]([DataType_ID]),
)
GO