unit SelectAnswer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Data.Win.ADODB, Vcl.StdCtrls, Vcl.ExtCtrls, DMbase;

type
  TfmSelectAnswer = class(TForm)
    grAnswers: TDBGrid;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    quAnswers: TADOQuery;
    dsAnswers: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SelectedAnswerID :Integer;
  end;

var
  fmSelectAnswer: TfmSelectAnswer;

implementation

{$R *.dfm}

procedure TfmSelectAnswer.Button1Click(Sender: TObject);
begin
  SelectedAnswerID := quAnswers.FieldByName('Answer_ID').AsInteger;
  tag := 1;
  Close;
end;

procedure TfmSelectAnswer.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfmSelectAnswer.FormCreate(Sender: TObject);
begin
  tag := 0;
  quAnswers.Open;
end;

end.
