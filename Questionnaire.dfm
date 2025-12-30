object fmQuestionnaire: TfmQuestionnaire
  Left = 0
  Top = 0
  Caption = 'fmQuestionnaire'
  ClientHeight = 346
  ClientWidth = 494
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnCreate = FormCreate
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 494
    Height = 89
    Align = alTop
    Caption = #1042#1086#1087#1088#1086#1089
    TabOrder = 0
    object reQuest: TRichEdit
      Left = 2
      Top = 17
      Width = 490
      Height = 70
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        'RichEdit1')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object gbAnsw: TRadioGroup
    Left = 0
    Top = 136
    Width = 494
    Height = 176
    Align = alClient
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1090#1074#1077#1090
    TabOrder = 1
  end
  object gbOpenAnsw: TGroupBox
    Left = 0
    Top = 89
    Width = 494
    Height = 47
    Align = alTop
    Caption = #1054#1090#1074#1077#1090'  '
    TabOrder = 2
    object edOpen: TEdit
      Left = 2
      Top = 17
      Width = 490
      Height = 28
      Align = alClient
      TabOrder = 0
      Text = 'edOpen'
      ExplicitHeight = 23
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 494
    Height = 34
    Align = alBottom
    TabOrder = 3
    object Button1: TButton
      Left = 418
      Top = 1
      Width = 75
      Height = 32
      Align = alRight
      Caption = #1044#1072#1083#1077#1077
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object quData: TADOQuery
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    Parameters = <>
    SQL.Strings = (
      'declare @cur int, @end int'
      'declare @cText varchar(500)'
      'declare @isOpen bit'
      
        'select @cur = Question_ID, @cText = [Text], @end = [Next], @isOp' +
        'en = IsOpen from [dbo].[Questions] where Previos is NULL'
      
        'create table #SQuestions([Question_ID] int, [Text] varchar(500),' +
        ' [isOpen] bit)'
      'insert into #SQuestions values(@cur, @cText, @isOpen)'
      'while @end is not null'
      'begin'
      #9'declare @next int'
      
        #9'select @cText = [Text], @cur = Question_ID, @next = [Next], @is' +
        'Open = IsOpen from [dbo].[Questions] where Question_ID = @end'
      #9'set @end = @next'
      #9'insert into #SQuestions values(@cur, @cText, @isOpen)'
      'end;'
      'select * from #SQuestions'
      'drop table #SQuestions')
    Left = 360
    Top = 24
  end
  object quRAB: TADOQuery
    Connection = fmDmBase.dbConnection
    Parameters = <>
    Left = 432
    Top = 24
  end
end
