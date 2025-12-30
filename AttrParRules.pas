unit AttrParRules;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, DMBase, Vcl.StdCtrls, Vcl.Menus;

type
  TfmAttrParRules = class(TForm)
    grAttrParRules: TDBGrid;
    quAttrParRules: TADOQuery;
    dsAttrParRules: TDataSource;
    Splitter1: TSplitter;
    quAttribute: TADOQuery;
    quParam: TADOQuery;
    dsParam: TDataSource;
    dsAttribute: TDataSource;
    Panel1: TPanel;
    GridPanel1: TGridPanel;
    GroupBox3: TGroupBox;
    edCondition: TEdit;
    GroupBox4: TGroupBox;
    edValue: TEdit;
    GroupBox1: TGroupBox;
    grAttribute: TDBGrid;
    GroupBox2: TGroupBox;
    grParam: TDBGrid;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    pmAttrParRules: TPopupMenu;
    btAddRule: TMenuItem;
    quRAB: TADOQuery;
    btEditRule: TMenuItem;
    btDeleteRule: TMenuItem;
    procedure doQuery(sql: TStrings);
    function AddRule(Attr_ID, Param_ID: Integer; Condition, Value: String; var newVal: Integer): Boolean;
    function EditRule(ParamToAttrRule_ID, Attr_ID, Param_ID: Integer; Condition, Value: String): Boolean;
    function DeleteRule(ParamToAttrRule_ID: Integer): Boolean;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btAddRuleClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btEditRuleClick(Sender: TObject);
    procedure btDeleteRuleClick(Sender: TObject);
  private
    { Private declarations }
    mode :Char;
  public
    { Public declarations }
    created: boolean;
  end;

var
  fmAttrParRules: TfmAttrParRules;

implementation

{$R *.dfm}

procedure TfmAttrParRules.doQuery(sql: TStrings);
begin
  quRab.Close;
  quRab.SQL.Clear;
  quRab.SQL := (sql);
  quRab.Open;
end;

function TfmAttrParRules.AddRule(Attr_ID: Integer; Param_ID: Integer; Condition: string; Value: string; var newVal: Integer): Boolean;
var
  error: integer;
  sql00 :TStringList;
begin
  result := false;
  if (trim(Condition) = '') or (trim(Value) = '') then
    Exit;
  sql00 := TStringList.Create;
  SQL00.Add('insert into [dbo].[ParamToAttrRules] ([Attribute_ID], [Paramrter_ID], [Condition], [ParamValue]) values');
  SQL00.Add('(' + IntToStr(Attr_ID) +  ',' + IntToStr(Param_ID) + ', ''' + Condition + ''', ''' + Value + ''')');
  SQL00.Add('SELECT IDENT_CURRENT( + ''' + 'ParamToAttrRules' + ''' ' + ') as cur, @@ERROR as Err');
  doQuery(sql00);
  error := quRab.FieldByName('Err').AsInteger;
  if Error <> 0 then
    Exit;
  newVal := quRab.FieldByName('cur').AsInteger;
  Result := true;
end;

function TfmAttrParRules.EditRule(ParamToAttrRule_ID, Attr_ID: Integer; Param_ID: Integer; Condition: string; Value: string): Boolean;
var
  error: integer;
  sql00 :TStringList;
begin
  result := false;
  if (trim(Condition) = '') or (trim(Value) = '') then
    Exit;
  sql00 := TStringList.Create;
  SQL00.Add('update [dbo].[ParamToAttrRules] set');
  SQL00.Add('Attribute_ID = ' + IntToStr(Attr_ID) + ',');
  SQL00.Add('Paramrter_ID = ' + IntToStr(Param_ID) + ',');
  SQL00.Add('Condition = ''' + Condition + ''',');
  SQL00.Add('ParamValue = ''' + Value + ''' ');
  SQL00.Add('WHERE ParamToAttrRule_ID = ' + IntToStr(ParamToAttrRule_ID));
  SQL00.Add('SELECT @@ERROR as Err');
  doQuery(sql00);
  error := quRab.FieldByName('Err').AsInteger;
  if Error <> 0 then
    Exit;
  Result := true;
end;

function TfmAttrParRules.DeleteRule(ParamToAttrRule_ID: Integer): Boolean;
var
  error: integer;
  sql00 :TStringList;
begin
  sql00 := TStringList.Create;
  SQL00.Add('delete from [dbo].[ParamToAttrRules] where ParamToAttrRule_ID = ' + IntToStr(ParamToAttrRule_ID));
  SQL00.Add('SELECT @@ERROR as Err');
  doQuery(sql00);
  error := quRab.FieldByName('Err').AsInteger;
  if Error <> 0 then
    result := false
  else
    Result := true;
end;

procedure TfmAttrParRules.btAddRuleClick(Sender: TObject);
begin
  Panel1.Visible := true;
  Panel1.Enabled := true;
  edCondition.Text := '';
  edValue.Text := '';
  quAttribute.First;
  quParam.First;
  mode := 'a';
end;

procedure TfmAttrParRules.btEditRuleClick(Sender: TObject);
var Att_ID, Par_ID :Integer;
begin
  Panel1.Visible := true;
  Panel1.Enabled := true;
  edCondition.Text := quAttrParRules.FieldByName('Condition').AsString;
  edValue.Text := quAttrParRules.FieldByName('ParamValue').AsString;
  Att_ID := quAttrParRules.FieldByName('Attribute_ID').AsInteger;
  Par_ID := quAttrParRules.FieldByName('Paramrter_ID').AsInteger;
  quAttribute.Locate('Attribute_ID', Att_ID, []);
  quParam.Locate('Paramrter_ID', Par_ID, []);
  grParam.Update;
  grAttribute.Update;
  mode := 'e';
end;

procedure TfmAttrParRules.btDeleteRuleClick(Sender: TObject);
var id: Integer;
begin
  id := quAttrParRules.FieldByName('ParamToAttrRule_ID').AsInteger;
  if MessageDlg('Вы уверены, что хотите удалить это правило?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if DeleteRule(id) then
      ShowMessage('Вопрос успешно удален')
    else
      ShowMessage('Ошибка при удалении вопроса');
  end;
end;

procedure TfmAttrParRules.Button1Click(Sender: TObject);
var
  Attribute_ID, Parameter_ID, cnt, ret, id :Integer;
  Condition, Value :String;
  sql : TStringList;
begin
  Condition := trim(edCondition.Text);
  Value := trim(edValue.Text);
  if (Condition = '') or (Value = '') then
    Exit;
  Attribute_ID := quAttribute.FieldByName('Attribute_ID').AsInteger;
  Parameter_ID := quParam.FieldByName('Parameter_ID').AsInteger;

  Condition := StringReplace(Condition, chr(39), chr(39) + chr(39), [rfReplaceAll]);

  sql := TStringList.Create;
  SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[ParamToAttrRules]');
  SQL.Add('WHERE [Attribute_ID] = ' + IntToStr(Attribute_ID));
  SQL.Add('AND [Paramrter_ID] = ' + IntToStr(Parameter_ID));
  SQL.Add('AND [Condition] = ''' + Condition + '''');
  SQL.Add('AND [ParamValue] = ''' + Value + '''');
  doQuery(sql);
  cnt := quRab.FieldByName('cnt').AsInteger;
  if cnt <> 0 then
  begin
    ShowMessage('Такое правило уже существует');
    Exit;
  end;

  if mode = 'a' then
  begin
    if AddRule(Attribute_ID, Parameter_ID, Condition, Value, ret) then
    begin
      quAttrParRules.Close;
      quAttrParRules.Open;
      grAttrParRules.Update;
      quAttrParRules.Locate('ParamToAttrRule_ID', ret, []);
    end
    else
    begin
      ShowMessage('Ошибка при добавлении записи');
    end;
  end
  else
  begin
    id := quAttrParRules.FieldByName('ParamToAttrRule_ID').AsInteger;
    if EditRule(id, Attribute_ID, Parameter_ID, Condition, Value) then
    begin
      quAttrParRules.Close;
      quAttrParRules.Open;
      grAttrParRules.Update;
    end
    else
    begin
      ShowMessage('Ошибка при редактировании записи');
    end;
  end;

  Panel1.Visible := false;
  Panel1.Enabled := false;
end;

procedure TfmAttrParRules.Button2Click(Sender: TObject);
begin
  Panel1.Visible := false;
  Panel1.Enabled := false;
end;

procedure TfmAttrParRules.FormActivate(Sender: TObject);
begin
  if not created then
  begin
    quAttrParRules.Open;
    quAttribute.Open;
    quParam.Open;
    Panel1.Visible := false;
    Panel1.Enabled := false;
    created := true;
  end;
end;

procedure TfmAttrParRules.FormCreate(Sender: TObject);
begin
  created := false;
end;

end.
