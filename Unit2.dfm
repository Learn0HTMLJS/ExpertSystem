object fmParameters: TfmParameters
  Left = 0
  Top = 0
  Caption = 'fmParameters'
  ClientHeight = 441
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
    Top = 408
    Width = 624
    Height = 33
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 1
      Top = 1
      Width = 73
      Height = 31
      Align = alLeft
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 550
      Top = 1
      Width = 73
      Height = 31
      Align = alRight
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 1
    end
    object Button3: TButton
      Left = 74
      Top = 1
      Width = 103
      Height = 31
      Margins.Left = 10
      Align = alLeft
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      ImageMargins.Left = 10
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object grParameters: TDBGrid
    Left = 0
    Top = 0
    Width = 624
    Height = 408
    Align = alClient
    DataSource = dsData
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Name'
        Title.Caption = #1048#1084#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        Width = 460
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TypeName'
        Title.Caption = #1058#1080#1087' '#1076#1072#1085#1085#1099#1093
        Width = 142
        Visible = True
      end>
  end
  object quRab: TADOQuery
    Parameters = <>
    Left = 472
    Top = 40
  end
  object quData: TADOQuery
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.Parameter_ID, A.Name, B.Name as TypeName FROM [dbo].[Pa' +
        'rameters] A'
      'INNER JOIN [dbo].[DataTypes] B ON (A.Type = B.DataType_ID)')
    Left = 392
    Top = 40
  end
  object dsData: TDataSource
    DataSet = quData
    Left = 392
    Top = 112
  end
end
