object fmAddExcludeRule: TfmAddExcludeRule
  Left = 0
  Top = 0
  Caption = 'fmAddExcludeRule'
  ClientHeight = 391
  ClientWidth = 435
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 354
    Width = 435
    Height = 37
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 1
      Top = 1
      Width = 80
      Height = 35
      Align = alLeft
      Caption = 'Ok'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 359
      Top = 1
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 435
    Height = 354
    Align = alClient
    Caption = #1044#1086' '#1082#1072#1082#1082#1086#1075#1086' '#1074#1086#1087#1088#1086#1089#1072' '#1087#1088#1086#1087#1091#1089#1090#1080#1090#1100'?'
    TabOrder = 1
    object grQuest: TDBGrid
      Left = 2
      Top = 17
      Width = 431
      Height = 335
      Align = alClient
      DataSource = dsData
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object dsData: TDataSource
    DataSet = quData
    Left = 392
    Top = 112
  end
  object quData: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    Parameters = <
      item
        Name = 'id'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 1
      end>
    SQL.Strings = (
      'declare @cur int, @end int'
      'declare @cText varchar(500)'
      
        'select @cur = Question_ID, @cText = [Text], @end = [Next] from [' +
        'dbo].[Questions] where Question_ID = :id'
      'create table #SQuestions([Question_ID] int, [Text] varchar(500))'
      'while @end is not null'
      'begin'
      #9'declare @next int'
      
        #9'select @cText = [Text], @cur = Question_ID, @next = [Next] from' +
        ' [dbo].[Questions] where Question_ID = @end'
      #9'set @end = @next'
      #9'insert into #SQuestions values(@cur, @cText)'
      'end;'
      'select * from #SQuestions'
      'drop table #SQuestions')
    Left = 392
    Top = 40
  end
end
