unit Results;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DMbase,
  Data.DB, Data.Win.ADODB, Questionnaire;

type
  RAttribute = record
    ID: Integer;
    Value :Variant;
    Name :String;
    dType :Integer;
  end;

  TfmResults = class(TForm)
    GridPanel1: TGridPanel;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    Memo2: TMemo;
    quRules: TADOQuery;
    quRAB: TADOQuery;
  private
    { Private declarations }
    procedure LoadAttributes;
    procedure SetAttr(attr: RAttribute);
    function GetAttr(id: Integer): RAttribute;
    function GetParam(ParameterID: integer): TParameterRecord;
    procedure SetParam(buff: TParameterRecord);
    procedure Interprit(AttrId: Integer; Condition, Value, ParamValue: String);
  public
    { Public declarations }
    procedure CalcAttributes(p: array of TParameterRecord; cnt: Integer);
  end;

var
  fmResults: TfmResults;

implementation

var
  Parameters: array of TParameterRecord;
  Attributes: array of RAttribute;
  aCnt, pCnt :Integer;

procedure TfmResults.SetAttr(attr: RAttribute);
var i: Integer;
begin
  for I := 0 to aCnt - 1 do
  begin
    if Attributes[i].ID = attr.ID then
    begin
      Attributes[i] := attr;
      Exit;
    end;
  end;
end;

function TfmResults.GetAttr(id: Integer): RAttribute;
var i: Integer;
begin
  for I := 0 to aCnt - 1 do
  begin
    if Attributes[i].ID = ID then
    begin
      Result := Attributes[i];
      Exit;
    end;
  end;
end;

procedure TfmResults.SetParam(buff: TParameterRecord);
var i: Integer;
begin
  for I := 0 to parCnt-1 do
  begin
    if paramsValues[i].ID = buff.ID then
    begin
      paramsValues[i] := buff;
      Exit;
    end;
  end;
end;

function TfmResults.GetParam(ParameterID: Integer): TParameterRecord;
var
  i: Integer;
  null: TParameterRecord;
begin
  for I := 0 to parCnt-1 do
  begin
    if paramsValues[i].ID = ParameterID then
    begin
      result := paramsValues[i];
      Exit;
    end;
  end;
  null.ID := -1;
  result := null;
end;

procedure TfmResults.LoadAttributes;
var i :Integer;
begin
  quRAB.Close;
  quRAB.SQL.Clear;
  quRAB.SQL.Add('select * from [dbo].[Attributes]');
  quRAB.Open;
  quRAB.First;
  aCnt := quRAB.RecordCount;
  i := 0;
  SetLength(Attributes, aCnt);
  while not quRAB.Eof do
  begin
    Attributes[i].ID := quRAB.FieldByName('Attribute_ID').AsInteger;
    Attributes[i].Name := quRAB.FieldByName('Name').AsString;
    Attributes[i].dType := quRAB.FieldByName('Type').AsInteger;
    INC(i);
    quRAB.Next;
  end;
end;

procedure TfmResults.Interprit(AttrId: Integer; Condition: string; Value: string; ParamValue: string);
var
  Attr :RAttribute;
  operation, i, c: Integer;
  sqlCondition :String;
begin
  ParamValue := trim(ParamValue);
  if ParamValue = '' then Exit;

  Condition := trim(Condition);
  Value := trim(Value);

  if Value[1] = '+' then operation := 0
  else if Value[1] = '-' then operation := 1
  else if Value[1] = '*' then operation := 2
  else if Value[1] = '/' then operation := 3
  else if Value[1] = '=' then operation := 4
  else begin
    ShowMessage('Критическая ошибка перед экраном!');
    Application.Terminate;
  end;
  Delete(Value, 1, 1);

  Attr := GetAttr(AttrId);
  if (attr.dType > 2) and (Attr.dType < 6) then
    ParamValue := Chr(39) + ParamValue + Chr(39);

  sqlCondition := StringReplace(Condition, 'P', VarToStr(ParamValue), [rfReplaceAll]);
  quRAB.Close;
  quRAB.SQL.Text := 'SELECT CASE WHEN ' + sqlCondition + ' THEN 1 ELSE 0 END as condition_result';
  quRAB.Open;
  // Если условие не выполняется, выходим
  if quRAB.FieldByName('condition_result').AsInteger = 0 then
    Exit;

  if (attr.dType > 2) and (Attr.dType < 6) then
  begin
    sqlCondition := Attr.Value;
  case operation of
    0: if not sqlCondition.contains(Value) then
          Attr.Value := Attr.Value + Value;
    1: if Attr.Value.contains(Value) then
       begin
         i := pos(Attr.Value, Value);
         c := length(value);
         Delete(sqlCondition, i, c);
         Attr.Value := sqlCondition;
       end;
    2: Attr.Value := Attr.Value + Value;
    //3: Attr.Value := Attr.Value - Value;
    4: Attr.Value := Value;
  end;
  end else
  case operation of
    0: Attr.Value := Attr.Value + Value;
    1: Attr.Value := Attr.Value - Value;
    2: Attr.Value := Attr.Value * Value;
    3: Attr.Value := Attr.Value / Value;
    4: Attr.Value := Value;
  end;

  SetAttr(Attr);
end;

procedure TfmResults.CalcAttributes(p: array of TParameterRecord; cnt: Integer);
var
  i, curId :Integer;
  Param :TParameterRecord;
  Condition, Value :String;
begin
  Memo2.Clear;
  SetLength(Parameters, cnt);
  for I := 0 to cnt-1 do
    Parameters[i] := p[i];
  LoadAttributes;
  for i := 0 to aCnt - 1 do
  begin
    quRules.Close;
    curId := Attributes[i].ID;
    quRules.Parameters.ParamByName('id').Value := curId;
    quRules.Open;
    quRules.First;
    curId := -1;
    while not quRules.Eof do
    begin
      curId := quRules.FieldByName('Paramrter_ID').AsInteger;
      if curId <> Param.ID then
        Param := GetParam(curId);
      Condition := quRules.FieldByName('Condition').AsString;
      Value := quRules.FieldByName('ParamValue').AsString;
      Interprit(Attributes[i].ID, Condition, Value, Param.Value);
      quRules.Next;
    end;

    Memo2.Lines.Add(Attributes[i].Name + ' = ' + Attributes[i].Value);
  end;
end;

{$R *.dfm}

end.
