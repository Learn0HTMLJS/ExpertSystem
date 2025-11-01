unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Unit2, DMBase, QuestionsAnswers;

type
  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Button2: TButton;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
  Self.Visible := False;
  if not Assigned (fmParameters) then
    fmParameters := TfmParameters.Create(Self);
  fmParameters.ShowModal;
  fmParameters.Free;
  fmParameters := nil;
  Self.Visible := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Self.Visible := False;
  if not Assigned (fmQuestionsAnswers) then
    fmQuestionsAnswers := TfmQuestionsAnswers.Create(Self);
  fmQuestionsAnswers.ShowModal;
  fmQuestionsAnswers.Free;
  fmQuestionsAnswers := nil;
  Self.Visible := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
var con: String;
begin
  DMBase.fmDmBase.dbConnection.Connected := false;
  con := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ComputerLinguistics;Data Source=ROMAN\MSSQLSERVER2019';
  DMBase.fmDmBase.dbConnection.ConnectionString := con;
  DMBase.fmDmBase.dbConnection.Connected := true;
end;

end.
