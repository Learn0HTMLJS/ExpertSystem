object fmAddQuestion: TfmAddQuestion
  Left = 0
  Top = 0
  Caption = 'fmAddQuestion'
  ClientHeight = 83
  ClientWidth = 709
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 54
    Width = 709
    Height = 29
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 1
      Top = 1
      Width = 73
      Height = 27
      Align = alLeft
      Caption = 'Ok'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 619
      Top = 1
      Width = 89
      Height = 27
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 609
    Height = 54
    Align = alLeft
    Caption = #1058#1077#1082#1089#1090' '#1074#1086#1087#1088#1086#1089#1072
    TabOrder = 1
    object edText: TEdit
      Left = 2
      Top = 17
      Width = 605
      Height = 35
      Align = alClient
      TabOrder = 0
      Text = 'edText'
      ExplicitHeight = 23
    end
  end
  object GroupBox2: TGroupBox
    Left = 609
    Top = 0
    Width = 100
    Height = 54
    Align = alClient
    Caption = #1058#1080#1087' '#1074#1086#1087#1088#1086#1089#1072
    TabOrder = 2
    object cbOpen: TCheckBox
      Left = 2
      Top = 17
      Width = 96
      Height = 35
      Align = alClient
      Caption = #1054#1090#1082#1088#1099#1090#1099#1081' '
      TabOrder = 0
    end
  end
end
