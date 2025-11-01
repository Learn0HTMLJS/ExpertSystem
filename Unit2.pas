unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, DMbase, AddParam;

type
  TfmParameters = class(TForm)
    Panel1: TPanel;
    grParameters: TDBGrid;
    quRab: TADOQuery;
    quData: TADOQuery;
    Button1: TButton;
    Button2: TButton;
    dsData: TDataSource;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    function AddPAram(npName: String; npType: integer; var newVal: Integer): boolean;
    procedure doQuery(sql: TStrings);
  public
    { Public declarations }
  end;

var
  fmParameters: TfmParameters;

implementation

{$R *.dfm}

procedure TfmParameters.doQuery(sql: TStrings);
begin
  quRab.Close;
  quRab.SQL.Clear;
  quRab.SQL := (sql);
  quRab.Open;
end;

function TfmParameters.AddPAram(npName: string; npType: Integer; var newVal: Integer): Boolean;
var
  error: integer;
  sql :TStrings;
begin
  sql := TStrings.Create;
  SQL.Add('insert into [dbo].[Parameters] ([Name], [Type]) values');
  SQL.Add('(''' + npName + '' + ', ' + IntToStr(npType) + ')');
  SQL.Add('SELECT IDENT_CURRENT(''Parameters'') as cur, @@ERROR as Err');
  doQuery(sql);
  error := quRab.FieldByName('Err').AsInteger;
  if Error <> 0 then
  begin
    Result := false;
    Exit;
  end;
  newVal := quRab.FieldByName('cur').AsInteger;
  Result := true;
end;

procedure TfmParameters.Button1Click(Sender: TObject);
var
  newParName: String;
  npTypeId, cnt, id, mode: Integer;
  sql :TStrings;
begin
  //Self.Visible := False;
  if not Assigned (fmAddParam) then
    fmAddParam := TfmAddParam.Create(Self);
  fmAddParam.ParamName := '';
  fmAddParam.pType := 0;
  fmAddParam.ShowModal;
  newParName := fmAddParam.ParamName;
  npTypeId := fmAddParam.pType;
  mode := fmAddParam.tag;
  fmAddParam.Free;
  fmAddParam := nil;
  if mode = 0 then Exit;
  if mode = 1 then
  begin
    sql := TStrings.Create;
    SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[Parameters] WHERE [Name] = ''' + newParName + '');
    doQuery(sql);
    cnt := quRab.FieldByName('cnt').AsInteger;
    if cnt <> 0 then
    begin
      ShowMessage('Такое уже существует');
      Exit;
    end;
    if AddPAram(newParName, npTypeId, id) then
    begin
      grParameters.Update;
      quData.Locate('Parameter_ID', id, []);
    end
    else
    begin
      ShowMessage('Ошибка при всавке');
      Exit;
    end;
  end;
  //Self.Visible := True;
end;

procedure TfmParameters.Button3Click(Sender: TObject);
var
  newParName: String;
  npTypeId, cnt, id, mode: Integer;
  sql :TStrings;
begin
  id := dsData.DataSet.FieldByName('Parameter_ID').AsInteger;
  if not Assigned (fmAddParam) then
    fmAddParam := TfmAddParam.Create(Self);
  fmAddParam.ShowModal;
  fmAddParam.ParamName := '';
  fmAddParam.pType := 0;
  fmAddParam.ShowModal;
  newParName := fmAddParam.ParamName;
  npTypeId := fmAddParam.pType;
  mode := fmAddParam.tag;
  fmAddParam.Free;
  fmAddParam := nil;
  if mode = 0 then Exit;

end;

procedure TfmParameters.FormCreate(Sender: TObject);
begin
  quData.Open;
end;

end.
