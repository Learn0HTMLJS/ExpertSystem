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
insert into [dbo].[DataTypes] ([Name]) values 
 ('int'),             -- 1
 ('float'),           -- 2
 ('varchar100'),      -- 3
 ('varchar200'),      -- 4
 ('varchar500'),      -- 5
 ('MONEY'),           -- 6
 ('DATETIME')         -- 7


--	Аттрибуты
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Attributes]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ParamToAttrRules]
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
	[Name] [varchar](200) UNIQUE NOT NULL,
	[Type] [int] NOT NULL FOREIGN KEY REFERENCES[DataTypes]([DataType_ID]),
)

--  Правила определения значений аттрибутов
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ParamToAttrRules]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ParamToAttrRules]
GO

CREATE TABLE [dbo].[ParamToAttrRules]
(
	[ParamToAttrRule_ID] [int] IDENTITY(1,1) PRIMARY KEY,
 	[Attribute_ID] [int] NOT NULL FOREIGN KEY REFERENCES[Attributes]([Attribute_ID]),
 	[Paramrter_ID] [int] NOT NULL FOREIGN KEY REFERENCES[Parameters]([Parameter_ID]),
	[Condition] [varchar](1000) DEFAULT NULL, -- P operator Value	//	P - keyword
	[ParamValue] [varchar](500) NOT NULL -- P = ...
)

--	Вопросы - ответы
--	ДУРАЦКОЕ ДОПУЩЕНИЕ: Все ответы одного типа 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Questions]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Questions]
GO
CREATE TABLE [dbo].[Questions]
(
	[Question_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Text] [varchar](500) NOT NULL,
	[IsOpen] [bit] NOT NULL DEFAULT 0,
	[Previos] [int],
	[Next] [int],
)

IF EXISTS(SELECT name FROM dbo.sysobjects WHERE name = 'Append_Question' AND type = 'P')
   DROP PROCEDURE [dbo].[Append_Question]
GO

CREATE PROCEDURE [dbo].[Append_Question] @psQuestion VARCHAR(500), @pbOpen bit, @piNewCod INT OUTPUT
AS
DECLARE @ErrCode INT
DECLARE @LastId INT
BEGIN
  begin transaction
  SELECT @LastId = Question_ID from [dbo].[Questions] WHERE [Next] is NULL
  INSERT INTO [dbo].[Questions] ([Text], [IsOpen], [Previos], [Next])
  VALUES(@psQuestion, @pbOpen, @LastId, NULL)
  SET @ErrCode = @@ERROR
  IF (@ErrCode <> 0)
  begin
    rollback transaction
	RETURN @ErrCode
  end
  SELECT @piNewCod = IDENT_CURRENT('Questions');
  UPDATE [dbo].[Questions] SET [Next] = @piNewCod WHERE [Question_ID] = @LastId
  SET @ErrCode = @@ERROR
  commit transaction
  RETURN @ErrCode
END
GO

IF EXISTS(SELECT name FROM dbo.sysobjects WHERE name = 'Replace_Question' AND type = 'P')
   DROP PROCEDURE [dbo].[Replace_Question]
GO

CREATE PROCEDURE [dbo].[Replace_Question] @piQuestionID int, @piNewPlaceID int
AS
DECLARE @ErrCode INT
DECLARE @Pre INT	-- текущего
DECLARE @Next INT	-- текущего
BEGIN
  IF (@piQuestionID = @piNewPlaceID)
	RETURN @@ERROR
  begin transaction
  SELECT @Pre = [Previos], @Next = [Next] from [dbo].[Questions] WHERE Question_ID = @piQuestionID
  UPDATE [dbo].[Questions] SET [Next] = @Next WHERE [Question_ID] = @Pre	-- Вытащили текущий из списка
  UPDATE [dbo].[Questions] SET [Previos] = @Pre WHERE [Question_ID] = @Next	-- Вытащили текущий из списка

  SELECT @Pre = [Previos] from [dbo].[Questions] WHERE Question_ID = @piNewPlaceID
  UPDATE [dbo].[Questions] SET [Next] = @piQuestionID WHERE [Question_ID] = @Pre	--	Предыдущему из нового метса поставили новsq туче
  UPDATE [dbo].[Questions] SET [Previos] = @Pre, [Next] = @piNewPlaceID WHERE [Question_ID] = @piQuestionID	--	Вставили на новое место
  SET @ErrCode = @@ERROR
  IF (@ErrCode <> 0)
  begin
    rollback transaction
	RETURN @ErrCode
  end
  SET @ErrCode = @@ERROR
  commit transaction
  RETURN @ErrCode
END
GO


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
	[Answ_ID] [int] NOT NULL FOREIGN KEY REFERENCES[Answers]([Answer_ID]),
)
GO

IF EXISTS(SELECT name FROM dbo.sysobjects WHERE name = 'AddQuestAnswer' AND type = 'P')
   DROP PROCEDURE [dbo].[AddQuestAnswer]
GO

CREATE PROCEDURE [dbo].[AddQuestAnswer] @piQuestId int, @piAnswId int, @piNewCod INT OUTPUT
AS
DECLARE @ErrCode INT
DECLARE @Qopen bit
BEGIN
  SELECT @Qopen = IsOpen from [dbo].[Questions] WHERE [Question_ID] = @piQuestId
  if ((@Qopen > 0) OR (@piAnswId is NULL))
  begin
	  set @piNewCod = -1;
	  RETURN @ErrCode
  end
  begin transaction
    INSERT INTO [dbo].[QuestAnswers] ([Question_ID], [Answ_ID])
    VALUES(@piQuestId, @piAnswId)
    SET @ErrCode = @@ERROR
    IF (@ErrCode <> 0)
    begin
      rollback transaction
	    RETURN @ErrCode
    end
    SELECT @piNewCod = IDENT_CURRENT('QuestAnswers');
    SET @ErrCode = @@ERROR
  commit transaction
  RETURN @ErrCode
END
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[QuestRules]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[QuestRules]
GO
CREATE TABLE [dbo].[QuestRules]
(
	[QuestRule_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[QuestAnswer_ID] [int] FOREIGN KEY REFERENCES[QuestAnswers]([QuestAnswer_ID]) DEFAULT NULL,
	[Question_ID] [int]  FOREIGN KEY REFERENCES[Questions]([Question_ID]) DEFAULT NULL,
	[Paramrter_ID] [int] NOT NULL FOREIGN KEY REFERENCES[Parameters]([Parameter_ID]),
	[Condition] [varchar](1000) DEFAULT NULL, -- if () then //see on next string
	[ParamValue] [varchar](500) NOT NULL -- P =
)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ExcludeRules]') and
OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ExcludeRules]
GO
CREATE TABLE [dbo].[ExcludeRules]
(
	[ExcludeRules_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[QuestRule_ID] [int] FOREIGN KEY REFERENCES[QuestRules]([QuestRule_ID]),
	[Question_ID] [int] NOT NULL FOREIGN KEY REFERENCES[Questions]([Question_ID]) -- До какого пропустить
)
GO

-- Хранимая процедура для безопасного удаления вопроса
IF EXISTS(SELECT name FROM dbo.sysobjects WHERE name = 'DeleteQuestionSafe' AND type = 'P')
   DROP PROCEDURE [dbo].[DeleteQuestionSafe]
GO

CREATE PROCEDURE [dbo].[DeleteQuestionSafe] @piQuestionID INT
AS
DECLARE @ErrCode INT
BEGIN
  BEGIN TRANSACTION

  -- Удаляем правила исключения, связанные с этим вопросом
  DELETE FROM [dbo].[ExcludeRules]
  WHERE [Question_ID] = @piQuestionID;

  SET @ErrCode = @@ERROR
  IF @ErrCode <> 0
  BEGIN
    ROLLBACK TRANSACTION
    RETURN @ErrCode
  END

  -- Удаляем связи вопрос-ответ
  DELETE FROM [dbo].[QuestAnswers]
  WHERE [Question_ID] = @piQuestionID;

  SET @ErrCode = @@ERROR
  IF @ErrCode <> 0
  BEGIN
    ROLLBACK TRANSACTION
    RETURN @ErrCode
  END

  -- Обновляем связи в цепочке вопросов
  DECLARE @PrevID INT, @NextID INT
  SELECT @PrevID = [Previos], @NextID = [Next]
  FROM [dbo].[Questions]
  WHERE [Question_ID] = @piQuestionID;

  IF @PrevID IS NOT NULL
  BEGIN
    UPDATE [dbo].[Questions] SET [Next] = @NextID WHERE [Question_ID] = @PrevID;
    SET @ErrCode = @@ERROR
    IF @ErrCode <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RETURN @ErrCode
    END
  END

  IF @NextID IS NOT NULL
  BEGIN
    UPDATE [dbo].[Questions] SET [Previos] = @PrevID WHERE [Question_ID] = @NextID;
    SET @ErrCode = @@ERROR
    IF @ErrCode <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RETURN @ErrCode
    END
  END

  -- Удаляем сам вопрос
  DELETE FROM [dbo].[Questions]
  WHERE [Question_ID] = @piQuestionID;

  SET @ErrCode = @@ERROR
  IF @ErrCode <> 0
  BEGIN
    ROLLBACK TRANSACTION
    RETURN @ErrCode
  END

  COMMIT TRANSACTION
  RETURN 0
END
GO