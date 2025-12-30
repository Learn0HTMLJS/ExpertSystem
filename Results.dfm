object fmResults: TfmResults
  Left = 0
  Top = 0
  Caption = 'fmResults'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object GridPanel1: TGridPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = GroupBox1
        Row = 0
      end
      item
        Column = 1
        Control = GroupBox2
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 311
      Height = 439
      Align = alClient
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      TabOrder = 0
      object Memo1: TMemo
        Left = 2
        Top = 17
        Width = 307
        Height = 420
        Align = alClient
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
      end
    end
    object GroupBox2: TGroupBox
      Left = 312
      Top = 1
      Width = 311
      Height = 439
      Align = alClient
      Caption = #1040#1090#1088#1080#1073#1091#1090#1099
      TabOrder = 1
      object Memo2: TMemo
        Left = 2
        Top = 17
        Width = 307
        Height = 420
        Align = alClient
        Lines.Strings = (
          'Memo2')
        TabOrder = 0
      end
    end
  end
  object quRules: TADOQuery
    Connection = fmDmBase.dbConnection
    Parameters = <
      item
        Name = 'id'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'select * from [dbo].[ParamToAttrRules]'
      'where Attribute_ID = :id'
      'order by Paramrter_ID')
    Left = 448
    Top = 49
  end
  object quRAB: TADOQuery
    Connection = fmDmBase.dbConnection
    Parameters = <>
    Left = 536
    Top = 49
  end
end
