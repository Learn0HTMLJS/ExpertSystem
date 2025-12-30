unit Questionnaire;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB,
  Data.Win.ADODB, Vcl.ExtCtrls, DMbase, System.Generics.Collections;

type
  TParameterRecord = record
    ID: Integer;
    Name: String;
    Value: Variant;
    DataType: Integer;
  end;

  TfmQuestionnaire = class(TForm)
    quData: TADOQuery;
    GroupBox1: TGroupBox;
    reQuest: TRichEdit;
    gbAnsw: TRadioGroup;
    gbOpenAnsw: TGroupBox;
    edOpen: TEdit;
    Panel1: TPanel;
    Button1: TButton;
    quRAB: TADOQuery;
    procedure LoadQuestion;
    procedure CreateControllers;
    procedure doQuery(sql: TStringList);
    function Interprit(isOpen: boolean; ParameterID, RuleId: integer; Condition, Value: String;
          UserAnswer: String = ''): TParameterRecord;
    function GetParam(ParameterID: integer): TParameterRecord;
    procedure SetParam(ParameterID: integer; buff: TParameterRecord);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EndQuest;
  private
    { Private declarations }
  public
    { Public declarations }
    created: boolean;
  end;

var
  ResultRecord: TParameterRecord;
  fmQuestionnaire: TfmQuestionnaire;
  paramsValues: array of TParameterRecord;
  parCnt :Integer;
  ExcludedQ: TList<integer>;

implementation

uses Results;

{$R *.dfm}

procedure TfmQuestionnaire.doQuery(sql: TStringList);
begin
  quRab.Close;
  quRab.SQL.Clear;
  quRab.SQL := (sql);
  quRab.Open;
end;

procedure TfmQuestionnaire.CreateControllers;
begin
  gbAnsw.Items.Clear;
  quRab.First;
  while not quRAB.Eof do
  begin
    gbAnsw.Items.Add(quRab.FieldByName('Text').AsString);
    gbAnsw.Items.Objects[gbAnsw.Items.Count - 1] :=
      TObject(quRab.FieldByName('Answer_ID').AsInteger);
    qurab.Next;
  end;
end;

procedure TfmQuestionnaire.LoadQuestion;
var
  id: Integer;
  isOpen: Boolean;
  sql : TStringList;
begin
   reQuest.Text := quData.FieldByName('Text').AsString;
   isOpen := quData.FieldByName('isOpen').AsBoolean;
   id := quData.FieldByName('Question_ID').AsInteger;
   if ExcludedQ.Contains(id) then
   begin
     quData.Next;
     if quData.Eof then
        EndQuest;
     LoadQuestion;
     Exit;
   end;

   if isOpen then
   begin
     gbAnsw.Enabled := false;
     gbAnsw.Visible := false;
     gbOpenAnsw.Visible := true;
     gbOpenAnsw.Enabled := true;
     edOpen.Text := '';
   end
   else
   begin
     gbOpenAnsw.Enabled := false;
     gbOpenAnsw.Visible := false;
     gbAnsw.Visible := true;
     gbAnsw.Enabled := true;
     sql := TStringList.Create;
     sql.clear;
     sql.Add('SELECT A.* FROM [dbo].[Answers] A');
     sql.Add('INNER JOIN [dbo].[QuestAnswers] B ON(A.Answer_ID = B.Answ_ID)');
     sql.Add('WHERE B.Question_ID = ' + IntToStr(id));
     doQuery(sql);
     sql.Free;
     CreateControllers;
   end;
end;

function TfmQuestionnaire.Interprit(isOpen: boolean; ParameterID, RuleId: integer; Condition, Value: String;
          UserAnswer: String = ''): TParameterRecord;
var
  quRab2, quEval: TADOQuery;
  res: Variant;
  dtype, operation: Integer;
  paramName, sqlCondition, sqlValue: String;
  paramValue: Variant;
  ResultRecord: TParameterRecord;
  addInResult :String;

begin
  Condition := trim(Condition);
  Value := trim(Value);

  // Получаем информацию о параметре
  quRab2 := TADOQuery.Create(Self);
  try
    quRab2.Connection := fmDmBase.dbConnection; // подключение
    quRab2.SQL.Text := 'SELECT * FROM [dbo].[Parameters] WHERE [Parameter_ID] = ' + IntToStr(ParameterID);
    quRab2.Open;

    if quRab2.RecordCount = 0 then
      raise Exception.Create('Параметр с ID ' + IntToStr(ParameterID) + ' не найден');

    dtype := quRab2.FieldByName('Type').AsInteger;
    paramName := quRab2.FieldByName('Name').AsString;

    quRab2.Close;

    if Value[1] = '+' then operation := 0
    else if Value[1] = '-' then operation := 1
    else if Value[1] = '*' then operation := 2
    else if Value[1] = '/' then operation := 3
    else if Value[1] = '=' then operation := 4
    else begin
      ShowMessage('Критическая ошибка перед экраном!');
      Application.Terminate;
    end;

    ResultRecord := GetParam(ParameterID);

    Delete(Value, 1, 1);
    if isOpen then
    begin
      addInResult := StringReplace(Value, 'P', VarToStr(UserAnswer), [rfReplaceAll]);;
    end
    else begin
      addInResult := Value;
    end;

    // Обрабатываем значение в зависимости от типа данных
    case operation of
      0: ResultRecord.Value := ResultRecord.Value + addInResult;
      1: ResultRecord.Value := ResultRecord.Value - addInResult;
      2: ResultRecord.Value := ResultRecord.Value * addInResult;
      3:  if dtype = 0 then
            ResultRecord.Value := ResultRecord.Value div addInResult
          else
            ResultRecord.Value := ResultRecord.Value / addInResult;
      4: ResultRecord.Value := addInResult;
    end;

    quEval := TADOQuery.Create(Self);
    quEval.Connection := fmDmBase.dbConnection;

    // Проверяем условие, если оно задано
    if isOpen and (Condition <> '') then
    begin
      // Заменяем плейсхолдеры в условии на реальные значения
      sqlCondition := StringReplace(Condition, 'P', VarToStr(UserAnswer), [rfReplaceAll]);

      try
        quEval.SQL.Text := 'SELECT CASE WHEN ' + sqlCondition + ' THEN 1 ELSE 0 END as condition_result';
        quEval.Open;

        // Если условие не выполняется, выходим
        if quEval.FieldByName('condition_result').AsInteger = 0 then
          Exit;
      finally
      end;
    end;

    //  Исключенные вопросы
    quEval.SQL.Text := 'select Question_ID from [dbo].[ExcludeRules] where QuestRule_ID = ' + inttostr(RuleId);
    quEval.Open;
    quEval.First;
    while not quEval.Eof do
    begin
      ExcludedQ.Add(quEval.FieldByName('Question_ID').AsInteger);
      quEval.next;
    end;

    // Создаем запись с результатом
    ResultRecord.ID := ParameterID;
    ResultRecord.Name := paramName;
    ResultRecord.DataType := dtype;
    result := ResultRecord;
  finally
    quRab2.Free;
    quEval.Free;
  end;
end;

procedure TfmQuestionnaire.FormActivate(Sender: TObject);
begin
  quData.Open;
  if not created then
  begin
    ExcludedQ := TList<integer>.Create;
    quData.First;
    LoadQuestion;
  end;
end;

procedure TfmQuestionnaire.SetParam(ParameterID: Integer; buff: TParameterRecord);
var i: Integer;
begin
  for I := 0 to parCnt-1 do
  begin
    if paramsValues[i].ID = ParameterID then
    begin
      paramsValues[i] := buff;
      Exit;
    end;
  end;
end;

function TfmQuestionnaire.GetParam(ParameterID: Integer): TParameterRecord;
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

procedure TfmQuestionnaire.FormCreate(Sender: TObject);
var
  sql : TStringList;
  buff: TParameterRecord;
  cnt,i :Integer;
begin
  sql := TStringList.Create;
  sql.Add('select * from [dbo].[Parameters]');
  doQuery(sql);
  sql.Free;
  cnt := quRAB.RecordCount;
  parCnt := cnt;
  SetLength(paramsValues, cnt);
  quRAB.First;
  i := 0;
  while not quRAB.Eof do
  begin
    buff.ID := quRAB.FieldByName('Parameter_ID').AsInteger;
    buff.Name := quRAB.FieldByName('Name').AsString;
    buff.DataType := quRAB.FieldByName('Type').AsInteger;
    paramsValues[i] := buff;
    INC(i);
    qurab.Next;
  end;
  created := true;
end;

procedure TfmQuestionnaire.Button1Click(Sender: TObject);
var
  i, cnt, answId, questId, paramId, ruleId: Integer;
  rb: TRadioButton;
  answer, Condition, Value, sCols :String;
  sql : TStringList;
  buff: TParameterRecord;
  open: Boolean;
begin
  questId := quData.FieldByName('Question_ID').AsInteger;
  open := gbOpenAnsw.Enabled;
  if open then // if open
  begin
    answer := trim(edOpen.Text);
    if answer = '' then Exit;
  end
  else
  begin
    answer := '';
    cnt := gbAnsw.ControlCount;
    answId := -1;
    i := gbAnsw.ItemIndex;
    if (i < 0) or (i >= gbAnsw.Items.Count) then Exit;
    answId := Integer(gbAnsw.Items.Objects[i]);
  end;
  sql := TStringList.Create;
  sql.Add('declare @qId int, @open bit');
  sql.Add('set @qId = ' + inttostr(questId));
  sql.Add('select @open = IsOpen from [dbo].[Questions] where Question_ID = @qId');
  sql.Add('if @open = 0');
  sql.Add('begin');
  sCols := '	SELECT Paramrter_ID, Condition, ParamValue, QuestRule_ID FROM [dbo].[QuestRules]';
  sql.Add(sCols);
  sql.Add('	WHERE QuestAnswer_ID = ' + inttostr(answId));
  sql.Add('end;');
  sql.Add('else');
  sql.Add('begin');
  sql.Add(sCols);
  sql.Add('	WHERE Question_ID = @qId');
  sql.Add('end;');
  doQuery(sql);
  quRab.First;
  while not quRab.Eof do
  begin
    Condition := quRab.FieldByName('Condition').AsString;
    Value := quRab.FieldByName('ParamValue').AsString;
    paramId := quRab.FieldByName('Paramrter_ID').AsInteger;
    ruleId := quRab.FieldByName('QuestRule_ID').AsInteger;
    buff := Interprit(open, paramId, ruleId, Condition, Value, answer);
    SetParam(paramId, buff);
    quRAB.Next;
  end;
  quData.Next;
  if quData.Eof then
  begin
    EndQuest;
  end;
  LoadQuestion;
end;

procedure TfmQuestionnaire.EndQuest;
var i :Integer;
begin
  ShowMessage('Поздравляем, это был последний вопрос!');

  Self.Visible := False;
  if not Assigned (fmResults) then
    fmResults := TfmResults.Create(Self);
  fmResults.Memo1.Lines.Clear;
  for I := 0 to parCnt - 1 do
    fmResults.Memo1.Lines.Add(paramsValues[i].Name + ' = ' + paramsValues[i].Value);
  fmResults.CalcAttributes(paramsValues, parCnt);
  fmResults.ShowModal;
  fmResults.Free;
  fmResults := nil;

  Close;
end;

end.
