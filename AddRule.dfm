object fmAddRule: TfmAddRule
  Left = 0
  Top = 0
  Caption = 'fmAddRule'
  ClientHeight = 490
  ClientWidth = 488
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
    Top = 49
    Width = 488
    Height = 306
    Align = alClient
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088
    TabOrder = 0
    object grParam: TDBGrid
      Left = 2
      Top = 17
      Width = 484
      Height = 287
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
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 488
    Height = 49
    Align = alTop
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
    TabOrder = 1
    Visible = False
    object edResult: TEdit
      Left = 2
      Top = 17
      Width = 484
      Height = 30
      Align = alClient
      ReadOnly = True
      TabOrder = 0
      Text = 'edResult'
      ExplicitHeight = 23
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 355
    Width = 488
    Height = 47
    Align = alBottom
    Caption = #1051#1086#1075#1080#1095#1077#1089#1082#1086#1077' '#1091#1089#1083#1086#1074#1080#1077
    TabOrder = 2
    object edFx: TEdit
      Left = 2
      Top = 17
      Width = 484
      Height = 28
      Align = alClient
      TabOrder = 0
      Text = 'edFx'
      ExplicitHeight = 23
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 402
    Width = 488
    Height = 51
    Align = alBottom
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077
    TabOrder = 3
    object edVal: TEdit
      Left = 2
      Top = 17
      Width = 484
      Height = 32
      Align = alClient
      TabOrder = 0
      Text = 'edValue'
      ExplicitHeight = 23
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 453
    Width = 488
    Height = 37
    Align = alBottom
    TabOrder = 4
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
      Left = 412
      Top = 1
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Button2Click
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
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.Parameter_ID, A.Name, B.Name as TypeName FROM [dbo].[Pa' +
        'rameters] A'
      'INNER JOIN [dbo].[DataTypes] B ON (A.Type = B.DataType_ID)')
    Left = 392
    Top = 40
  end
end
