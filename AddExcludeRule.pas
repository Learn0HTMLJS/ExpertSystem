unit AddExcludeRule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DMbase, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids;

type
  TfmAddExcludeRule = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    grQuest: TDBGrid;
    dsData: TDataSource;
    quData: TADOQuery;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QuestRule_ID, Question_ID :Integer;
  end;

var
  fmAddExcludeRule: TfmAddExcludeRule;

implementation

{$R *.dfm}

procedure TfmAddExcludeRule.Button1Click(Sender: TObject);
begin
  Question_ID := dsData.DataSet.FieldByName('Question_ID').AsInteger;
  tag := 1;
  Close;
end;

procedure TfmAddExcludeRule.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfmAddExcludeRule.FormCreate(Sender: TObject);
begin
  tag := 0;
  quData.Open;
end;

end.
