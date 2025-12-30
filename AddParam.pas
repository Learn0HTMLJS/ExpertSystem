unit AddParam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls,
  Data.DB, Data.Win.ADODB, DMbase;

type
  TfmAddParam = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    edName: TEdit;
    dsTypes: TDataSource;
    quTypes: TADOQuery;
    dbcbType: TDBLookupComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ParamName :String;
    pType :Integer;
  end;

var
  fmAddParam: TfmAddParam;

implementation

{$R *.dfm}

procedure TfmAddParam.Button1Click(Sender: TObject);
begin
  if Trim(edName.Text) = '' then Exit;
  ParamName := Trim(edName.Text);
  pType := dsTypes.DataSet.FieldByName('DataType_ID').AsInteger;
  tag := 1;
  Close;
end;

procedure TfmAddParam.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfmAddParam.FormCreate(Sender: TObject);
begin
  tag := 0;
  edName.Text := ParamName;
  quTypes.Open;
end;

end.
