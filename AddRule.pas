unit AddRule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Data.Win.ADODB, DMbase, Vcl.ExtCtrls;

type
  TfmAddRule = class(TForm)
    GroupBox1: TGroupBox;
    grParam: TDBGrid;
    dsData: TDataSource;
    quData: TADOQuery;
    GroupBox2: TGroupBox;
    edResult: TEdit;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    edFx: TEdit;
    edVal: TEdit;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Parameter_ID :Integer;
    Condition, value :String;
    isOpen :boolean;
  end;

var
  fmAddRule: TfmAddRule;

implementation

{$R *.dfm}

procedure TfmAddRule.Button1Click(Sender: TObject);
begin
  Parameter_ID := dsData.DataSet.FieldByName('Parameter_ID').AsInteger;
  Condition := edFx.Text;
  value := trim(edVal.Text);
  if value = '' then
    Exit;
  tag := 1;
  Close;
end;

procedure TfmAddRule.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfmAddRule.FormActivate(Sender: TObject);
begin
  if isOpen then
    edFx.Enabled := true
  else
    edFx.Enabled := false;
end;

procedure TfmAddRule.FormCreate(Sender: TObject);
begin
  tag := 0;
  edResult.Text := '';
  edFx.Text := '';
  edVal.Text := '';
  quData.Open;
end;

end.
