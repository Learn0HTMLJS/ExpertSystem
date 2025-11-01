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
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 2
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        object grRules: TDBGrid
          Left = 0
          Top = 0
          Width = 921
          Height = 283
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'TabSheet2'
        ImageIndex = 1
        object DBGrid1: TDBGrid
          Left = 16
          Top = 16
          Width = 849
          Height = 241
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
    Parameters = <>
    Left = 872
    Top = 16
  end
  object quQuestions: TADOQuery
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM [dbo].[Questions]')
    Left = 784
    Top = 48
  end
  object quAnswers: TADOQuery
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
    Left = 728
    Top = 216
  end
  object pmQuestions: TPopupMenu
    Left = 592
    Top = 48
    object mbtAddQuestion: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    end
  end
  object pmAnswers: TPopupMenu
    Left = 640
    Top = 216
    object pmbtAddAnsw: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    end
    object pmbtAddExistsAnsw: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081
    end
  end
  object quRules: TADOQuery
    Connection = fmDmBase.dbConnection
    Parameters = <
      item
        Name = 'answId'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      
        'SELECT C.Name, A.Condition, A.ParamValue FROM [dbo].[QuestRules]' +
        ' A'
      
        'INNER JOIN [dbo].[QuestAnswers] B ON (B.QuestAnswer_ID = A.Quest' +
        'Answer_ID)'
      
        'INNER JOIN [dbo].[Parameters] C ON (A.Paramrter_ID = C.Parameter' +
        '_ID)'
      'WHERE B.Answ_ID = :answId')
    Left = 53
    Top = 491
  end
  object quExclude: TADOQuery
    Connection = fmDmBase.dbConnection
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
end
