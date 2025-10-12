--	Типы данных
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

--	Аттрибуты
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

--	Параметры
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Parameters]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Parameters]
GO

CREATE TABLE [dbo].[Parameters]
(
	[Parameter_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Name] [varchar](200) NOT NULL,
	[Type] [int] NOT NULL FOREIGN KEY REFERENCES[DataTypes]([DataType_ID]),
)

--	Вопросы - ответы
--	ДУРАЦКОЕ ДОПУЩЕНИЕ: Все ответы одного типа 
--	ДУРАЦКОЕ ДОПУЩЕНИЕ: Q -> P 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Questions]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Questions]
GO
CREATE TABLE [dbo].[Questions]
(
	[Question_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Text] [varchar](500) NOT NULL,
	[IsOpen] [bit] NOT NULL DEFAULT 0,
	[Order] [int] NOT NULL UNIQUE
)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Answers]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Answers]
GO
CREATE TABLE [dbo].[Answers]
(
	[Answer_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Text] [varchar](500) NOT NULL,
	--[Question_ID] [int] NOT NULL FOREIGN KEY REFERENCES[Questions]([Question_ID]),
)

--	Парвила
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[QuestAnswers]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[QuestAnswers]
GO
CREATE TABLE [dbo].[QuestAnswers]
(
	[QuestAnswer_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Question_ID] [int]  NOT NULL FOREIGN KEY REFERENCES[Questions]([Question_ID]),
	[Answ_ID] [int] FOREIGN KEY REFERENCES[Questions]([Question_ID]) default NULL, -- NULL - открытый вопрос
)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[QuestRules]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[QuestRules]
GO
CREATE TABLE [dbo].[QuestRules]
(
	[QuestRule_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[QuestAnswer_ID] [int]  NOT NULL FOREIGN KEY REFERENCES[QuestAnswers]([QuestAnswer_ID]),
	[Paramrter_ID] [int] NOT NULL FOREIGN KEY REFERENCES[Parameters]([Parameter_ID]),
	[Condition] [varchar](1000) NOT NULL, -- if () then //see on next string
	[ParamValue] [varchar](500) NOT NULL -- P = ...
)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ExcludeRules]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ExcludeRules]
GO
CREATE TABLE [dbo].[ExcludeRules]
(
	[ExcludeRules_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[QuestRule_ID] [int] FOREIGN KEY REFERENCES[QuestRules]([QuestRule_ID]),
	[Question_ID] [int] NOT NULL FOREIGN KEY REFERENCES[Questions]([Question_ID])
)
GO