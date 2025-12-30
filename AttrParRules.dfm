object fmAttrParRules: TfmAttrParRules
  Left = 0
  Top = 0
  Caption = 'fmAttrParRules'
  ClientHeight = 701
  ClientWidth = 794
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
    Top = 312
    Width = 794
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 416
  end
  object grAttrParRules: TDBGrid
    Left = 0
    Top = 0
    Width = 794
    Height = 312
    Align = alClient
    DataSource = dsAttrParRules
    PopupMenu = pmAttrParRules
    ReadOnly = True
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
        Title.Caption = #1040#1090#1088#1080#1073#1091#1090
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name_1'
        Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Condition'
        Title.Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ParamValue'
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        Width = 200
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 315
    Width = 794
    Height = 386
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 1
    object GridPanel1: TGridPanel
      Left = 1
      Top = 1
      Width = 792
      Height = 351
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
          Control = GroupBox3
          Row = 0
        end
        item
          Column = 1
          Control = GroupBox4
          Row = 0
        end
        item
          Column = 0
          Control = GroupBox1
          Row = 1
        end
        item
          Column = 1
          Control = GroupBox2
          Row = 1
        end>
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 50.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      object GroupBox3: TGroupBox
        Left = 1
        Top = 1
        Width = 395
        Height = 50
        Align = alClient
        Caption = ' '#1059#1089#1083#1086#1074#1080#1077' '
        TabOrder = 0
        object edCondition: TEdit
          Left = 2
          Top = 17
          Width = 391
          Height = 31
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 23
        end
      end
      object GroupBox4: TGroupBox
        Left = 396
        Top = 1
        Width = 395
        Height = 50
        Align = alClient
        Caption = ' '#1047#1085#1072#1095#1077#1085#1080#1077' '
        TabOrder = 1
        object edValue: TEdit
          Left = 2
          Top = 17
          Width = 391
          Height = 31
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 23
        end
      end
      object GroupBox1: TGroupBox
        Left = 1
        Top = 51
        Width = 395
        Height = 299
        Align = alClient
        Caption = ' '#1040#1090#1088#1080#1073#1091#1090' ('#1089#1074#1086#1081#1089#1090#1074#1072') '
        TabOrder = 2
        object grAttribute: TDBGrid
          Left = 2
          Top = 17
          Width = 391
          Height = 280
          Align = alClient
          DataSource = dsAttribute
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
      object GroupBox2: TGroupBox
        Left = 396
        Top = 51
        Width = 395
        Height = 299
        Align = alClient
        Caption = ' '#1055#1072#1088#1072#1084#1077#1090#1088' '
        TabOrder = 3
        object grParam: TDBGrid
          Left = 2
          Top = 17
          Width = 391
          Height = 280
          Align = alClient
          DataSource = dsParam
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
    object Panel2: TPanel
      Left = 1
      Top = 352
      Width = 792
      Height = 33
      Align = alBottom
      TabOrder = 1
      object Button1: TButton
        Left = 1
        Top = 1
        Width = 75
        Height = 31
        Align = alLeft
        Caption = 'Ok'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 716
        Top = 1
        Width = 75
        Height = 31
        Align = alRight
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
  object quAttrParRules: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select A.[ParamToAttrRule_ID], B.[Name], C.Name, '
      'A.Condition, A.ParamValue, A.[Attribute_ID], A.Paramrter_ID'
      'from [dbo].[ParamToAttrRules] A'
      
        'inner join [dbo].[Attributes] B on (A.[Attribute_ID] = B.[Attrib' +
        'ute_ID])'
      
        'inner join [dbo].[Parameters] C on (C.Parameter_ID = A.Paramrter' +
        '_ID)')
    Left = 360
    Top = 48
  end
  object dsAttrParRules: TDataSource
    DataSet = quAttrParRules
    Left = 456
    Top = 48
  end
  object quAttribute: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from [dbo].[Attributes]')
    Left = 193
    Top = 483
  end
  object quParam: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from [dbo].[Parameters]')
    Left = 605
    Top = 491
  end
  object dsParam: TDataSource
    DataSet = quParam
    Left = 701
    Top = 491
  end
  object dsAttribute: TDataSource
    DataSet = quAttribute
    Left = 297
    Top = 475
  end
  object pmAttrParRules: TPopupMenu
    Left = 424
    Top = 168
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
  object quRAB: TADOQuery
    Connection = fmDmBase.dbConnection
    Parameters = <>
    Left = 592
    Top = 56
  end
end
