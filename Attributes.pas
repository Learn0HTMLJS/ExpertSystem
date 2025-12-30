unit Attributes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, DMBase, AddParam;

type
  TfmAttributes = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    grAttributes: TDBGrid;
    quRab: TADOQuery;
    quData: TADOQuery;
    dsData: TDataSource;
    procedure doQuery(sql: TStrings);
    function AddAttr(npName: string; npType: Integer; var newVal: Integer): Boolean;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAttributes: TfmAttributes;

implementation

{$R *.dfm}

function TfmAttributes.AddAttr(npName: string; npType: Integer; var newVal: Integer): Boolean;
var
  error: integer;
  sql :TStrings;
begin
  sql := TStringList.Create;
  SQL.Add('insert into [dbo].[Attributes] ([Name], [Type]) values');
  SQL.Add('(''' + npName + ''' ' + ', ' + IntToStr(npType) + ')');
  SQL.Add('SELECT IDENT_CURRENT( + ''' + 'Attributes' + ''' ' + ') as cur, @@ERROR as Err');
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

procedure TfmAttributes.Button1Click(Sender: TObject);
var
  newName: String;
  npTypeId, cnt, id, mode: Integer;
  sql :TStringList;
begin
  //Self.Visible := False;
  if not Assigned (fmAddParam) then
    fmAddParam := TfmAddParam.Create(Self);
  fmAddParam.ParamName := '';
  fmAddParam.pType := 0;
  fmAddParam.ShowModal;
  newName := fmAddParam.ParamName;
  npTypeId := fmAddParam.pType;
  mode := fmAddParam.tag;
  fmAddParam.Free;
  fmAddParam := nil;
  if mode = 0 then Exit;
  if mode = 1 then
  begin
    sql := TStringList.Create;
    SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[Attributes] WHERE [Name] = ''' + newName + ''' ');
    doQuery(sql);
    cnt := quRab.FieldByName('cnt').AsInteger;
    if cnt <> 0 then
    begin
      ShowMessage('Такое уже существует');
      Exit;
    end;
    if AddAttr(newName, npTypeId, id) then
    begin
      quData.Close;
      quData.Open;
      grAttributes.Update;
      quData.Locate('Attribute_ID', id, []);
    end
    else
    begin
      ShowMessage('Ошибка при всавке');
      Exit;
    end;
  end;
  //Self.Visible := True;
end;

procedure TfmAttributes.doQuery(sql: TStrings);
begin
  quRab.Close;
  quRab.SQL.Clear;
  quRab.SQL := (sql);
  quRab.Open;
end;

procedure TfmAttributes.FormCreate(Sender: TObject);
begin
  quData.Open;
end;

end.
