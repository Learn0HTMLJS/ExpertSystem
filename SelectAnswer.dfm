object fmSelectAnswer: TfmSelectAnswer
  Left = 0
  Top = 0
  Caption = 'fmSelectAnswer'
  ClientHeight = 421
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object grAnswers: TDBGrid
    Left = 0
    Top = 0
    Width = 413
    Height = 384
    Align = alClient
    DataSource = dsAnswers
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 384
    Width = 413
    Height = 37
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 358
    ExplicitWidth = 435
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
      Left = 337
      Top = 1
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Button2Click
      ExplicitLeft = 338
      ExplicitTop = 6
    end
  end
  object quAnswers: TADOQuery
    Active = True
    Connection = fmDmBase.dbConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from [dbo].[Answers]')
    Left = 232
    Top = 72
  end
  object dsAnswers: TDataSource
    DataSet = quAnswers
    Left = 320
    Top = 72
  end
end
