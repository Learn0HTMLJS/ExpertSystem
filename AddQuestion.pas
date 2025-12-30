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
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QText :String;
    isOpen: boolean;
  end;

var
  fmAddQuestion: TfmAddQuestion;

implementation

{$R *.dfm}

procedure TfmAddQuestion.Button1Click(Sender: TObject);
begin
  if trim(edText.Text) = '' then
    Exit;
  QText := trim(edText.Text);
  isOpen := cbOpen.Checked;
  tag := 1;
  Close;
end;

procedure TfmAddQuestion.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfmAddQuestion.FormActivate(Sender: TObject);
begin
  edText.Text := QText;
  cbOpen.Checked := isopen;
end;

procedure TfmAddQuestion.FormCreate(Sender: TObject);
begin
  tag := 0;
  QText := '';
  isOpen := false;
end;

end.
