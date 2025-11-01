object fmAddParam: TfmAddParam
  Left = 0
  Top = 0
  Caption = 'fmAddParam'
  ClientHeight = 75
  ClientWidth = 624
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
    Top = 43
    Width = 624
    Height = 32
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 1
      Top = 1
      Width = 73
      Height = 30
      Align = alLeft
      Caption = 'Ok'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 550
      Top = 1
      Width = 73
      Height = 30
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 345
    Height = 43
    Align = alLeft
    Caption = #1048#1084#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
    TabOrder = 1
    object edName: TEdit
      Left = 2
      Top = 17
      Width = 341
      Height = 24
      Align = alClient
      TabOrder = 0
      Text = 'edName'
      ExplicitHeight = 23
    end
  end
  object GroupBox2: TGroupBox
    Left = 345
    Top = 0
    Width = 279
    Height = 43
    Align = alClient
    Caption = #1058#1080#1087' '#1076#1072#1085#1085#1099#1093
    TabOrder = 2
    object dbcbType: TDBComboBox
      Left = 2
      Top = 17
      Width = 275
      Height = 23
      Align = alClient
      DataField = 'Name'
      DataSource = dsTypes
      TabOrder = 0
    end
  end
  object dsTypes: TDataSource
    DataSet = quTypes
    Left = 336
    Top = 25
  end
  object quTypes: TADOQuery
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM [dbo].[DataTypes] ')
    Left = 384
    Top = 25
  end
end
