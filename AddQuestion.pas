unit AddQuestion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Data.Win.ADODB, DMbase;

type
  TfmAddQuestion = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    cbOpen: TCheckBox;
    edText: TEdit;
    spAppendQuestion: TADOStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAddQuestion: TfmAddQuestion;

implementation

{$R *.dfm}

end.
