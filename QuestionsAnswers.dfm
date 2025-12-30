object fmQuestionsAnswers: TfmQuestionsAnswers
  Left = 0
  Top = 0
  Caption = 'fmQuestionsAnswers'
  ClientHeight = 755
  ClientWidth = 931
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 153
    Width = 931
    Height = 4
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 147
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 436
    Width = 931
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 161
  end
  object grQuestions: TDBGrid
    Left = 0
    Top = 0
    Width = 931
    Height = 153
    Align = alTop
    DataSource = dsQuests
    PopupMenu = pmQuestions
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object grAnswers: TDBGrid
    Left = 0
    Top = 157
    Width = 931
    Height = 279
    Align = alClient
    Color = clPowderblue
    DataSource = dsAnsw
    PopupMenu = pmAnswers
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 440
    Width = 931
    Height = 315
    Align = alBottom
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 929
      Height = 313
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #1055#1088#1072#1074#1080#1083#1072
        object grRules: TDBGrid
          Left = 0
          Top = 0
          Width = 921
          Height = 283
          Align = alClient
          DataSource = dsRules
          PopupMenu = pmRules
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'Name'
              Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088
              Width = 288
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Condition'
              Title.Caption = #1059#1089#1083#1086#1074#1080#1077
              Width = 265
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ParamValue'
              Title.Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
              Width = 317
              Visible = True
            end>
        end
      end
      object TabSheet2: TTabSheet
        Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100
        ImageIndex = 1
        object grExclude: TDBGrid
          Left = 0
          Top = 0
          Width = 921
          Height = 283
          Align = alClient
          DataSource = dsExclude
          PopupMenu = pmExclude
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
    end
  end
  object quRab: TADOQuery
    Connection = fmDmBase.dbConnection
    Parameters = <>
    Left = 856
    Top = 48
  end
  object quQuestions: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    Parameters = <>
    SQL.Strings = (
      
        'IF EXISTS(SELECT name FROM dbo.sysobjects WHERE name = '#39'#SQuesti' +
        'ons'#39' AND type = '#39'P'#39')'
      '   DROP table [dbo].[#SQuestions]'
      'declare @cur int, @end int, @open bit'
      'declare @cText varchar(500)'
      
        'select @cur = Question_ID, @cText = [Text], @end = [Next], @open' +
        ' = IsOpen from [dbo].[Questions] where Previos is NULL'
      
        'create table #SQuestions([Question_ID] int, [Text] varchar(500),' +
        ' [isOpen] bit)'
      'insert into #SQuestions values(@cur, @cText, @open)'
      'while @end is not null'
      'begin'
      #9'declare @next int'
      
        #9'select @cText = [Text], @cur = Question_ID, @next = [Next], @op' +
        'en = IsOpen from [dbo].[Questions] where Question_ID = @end'
      #9'set @end = @next'
      #9'insert into #SQuestions values(@cur, @cText, @open)'
      'end;'
      'select * from #SQuestions'
      'drop table #SQuestions')
    Left = 784
    Top = 48
  end
  object quAnswers: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
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
      'SELECT A.* FROM [dbo].[Answers] A'
      'INNER JOIN [dbo].[QuestAnswers] B ON(A.Answer_ID = B.Answ_ID)'
      'WHERE B.Question_ID = :id')
    Left = 800
    Top = 216
  end
  object dsQuests: TDataSource
    DataSet = quQuestions
    OnDataChange = dsQuestsDataChange
    Left = 712
    Top = 48
  end
  object dsAnsw: TDataSource
    DataSet = quAnswers
    OnDataChange = dsAnswDataChange
    Left = 728
    Top = 216
  end
  object pmQuestions: TPopupMenu
    Left = 592
    Top = 48
    object mbtAddQuestion: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = mbtAddQuestionClick
    end
    object mbtEditQuestion: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = mbtEditQuestionClick
    end
    object mbtDeleteQuestion: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = mbtDeleteQuestionClick
    end
  end
  object pmAnswers: TPopupMenu
    Left = 640
    Top = 216
    object pmbtAddAnsw: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = pmbtAddAnswClick
    end
    object pmbtAddExistsAnsw: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081
      OnClick = pmbtAddExistsAnswClick
    end
    object pmbtEditAnsw: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = pmbtEditAnswClick
    end
    object pmbtDeleteAnsw: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = pmbtDeleteAnswClick
    end
  end
  object quRules: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'questId'
        DataType = ftWideString
        Size = 1
        Value = '1'
      end
      item
        Name = 'answId'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 4
      end>
    SQL.Strings = (
      'declare @qId int, @open bit'
      'set @qId = :questId'
      
        'select @open = IsOpen from [dbo].[Questions] where Question_ID =' +
        ' @qId'
      'if @open = 0'
      'begin'
      
        #9'SELECT C.Name, A.Condition, A.ParamValue, A.QuestRule_ID FROM [' +
        'dbo].[QuestRules] A'
      
        #9'INNER JOIN [dbo].[Parameters] C ON (A.Paramrter_ID = C.Paramete' +
        'r_ID)'
      #9'WHERE A.QuestAnswer_ID = :answId'
      'end; '
      'else'
      'begin'
      
        #9'SELECT C.Name, A.Condition, A.ParamValue, A.QuestRule_ID FROM [' +
        'dbo].[QuestRules] A'
      
        #9'INNER JOIN [dbo].[Parameters] C ON (A.Paramrter_ID = C.Paramete' +
        'r_ID)'
      #9'WHERE A.Question_ID = @qId'
      'end;')
    Left = 53
    Top = 491
  end
  object quExclude: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'id'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'SELECT B.Text FROM [dbo].[ExcludeRules] A'
      
        'INNER JOIN [dbo].[Questions] B ON (A.Question_ID = B.Question_ID' +
        ')'
      'WHERE A.QuestRule_ID = :id')
    Left = 685
    Top = 499
  end
  object dsRules: TDataSource
    DataSet = quRules
    OnDataChange = dsRulesDataChange
    Left = 125
    Top = 491
  end
  object dsExclude: TDataSource
    DataSet = quExclude
    Left = 765
    Top = 499
  end
  object pmRules: TPopupMenu
    Left = 245
    Top = 563
    object btAddRule: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = btAddRuleClick
    end
    object btEditRule: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = btEditRuleClick
    end
    object btDeleteRule: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = btDeleteRuleClick
    end
  end
  object spAddQuest: TADOStoredProc
    Connection = fmDmBase.dbConnection
    ProcedureName = 'Append_Question;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@psQuestion'
        Attributes = [paNullable]
        DataType = ftString
        Size = 500
        Value = Null
      end
      item
        Name = '@pbOpen'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@piNewCod'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
        Value = Null
      end>
    Left = 712
    Top = 104
  end
  object pmExclude: TPopupMenu
    Left = 677
    Top = 571
    object btAddExclude: TMenuItem
      Caption = #1048#1089#1083#1102#1095#1080#1090#1100' '#1074#1086#1087#1088#1086#1089#1099'...'
      OnClick = btAddExcludeClick
    end
    object btDeleteExclude: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = btDeleteExcludeClick
    end
  end
  object spAddAnsw: TADOStoredProc
    Connection = fmDmBase.dbConnection
    ProcedureName = 'AddQuestAnswer;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@piQuestId'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@piAnswId'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@piNewCod'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
        Value = Null
      end>
    Left = 728
    Top = 296
  end
  object spDelQuest: TADOStoredProc
    Connection = fmDmBase.dbConnection
    ProcedureName = 'DeleteQuestionSafe;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@piQuestionID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 792
    Top = 104
  end
end
