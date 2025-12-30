unit QuestionsAnswers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DMbase, Data.DB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Vcl.Menus, Vcl.Tabs, Vcl.ComCtrls, AddRule, AddExcludeRule,
  AddQuestion, SelectAnswer;

type
  TfmQuestionsAnswers = class(TForm)
    grQuestions: TDBGrid;
    grAnswers: TDBGrid;
    Splitter1: TSplitter;
    quRab: TADOQuery;
    quQuestions: TADOQuery;
    quAnswers: TADOQuery;
    dsQuests: TDataSource;
    dsAnsw: TDataSource;
    Panel1: TPanel;
    pmQuestions: TPopupMenu;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    mbtAddQuestion: TMenuItem;
    pmAnswers: TPopupMenu;
    pmbtAddAnsw: TMenuItem;
    pmbtAddExistsAnsw: TMenuItem;
    Splitter2: TSplitter;
    grRules: TDBGrid;
    quRules: TADOQuery;
    grExclude: TDBGrid;
    quExclude: TADOQuery;
    dsRules: TDataSource;
    dsExclude: TDataSource;
    pmRules: TPopupMenu;
    btAddRule: TMenuItem;
    spAddQuest: TADOStoredProc;
    pmExclude: TPopupMenu;
    btAddExclude: TMenuItem;
    spAddAnsw: TADOStoredProc;
    mbtEditQuestion: TMenuItem;
    mbtDeleteQuestion: TMenuItem;
    pmbtEditAnsw: TMenuItem;
    pmbtDeleteAnsw: TMenuItem;
    btEditRule: TMenuItem;
    btDeleteRule: TMenuItem;
    btDeleteExclude: TMenuItem;
    spDelQuest: TADOStoredProc;
    function AddQuestRule(isOpen: boolean; QuestAnswer_ID, Question_ID, Parameter_ID: Integer;
              Condition, ParamValue: string; var newVal: Integer): Boolean;
    function AddExcludeRule(QuestRule_ID: Integer; Question_ID: Integer; var newVal: Integer): Boolean;
    function AppendQuestion(const psQuestion: string; pbOpen: Boolean; var piNewCod: Integer): Boolean;
    function AddQuestAnswer(piQuestId: Integer; piAnswId: Integer; var piNewCod: Integer): Boolean;
    function DeleteQuestion(QuestionID: Integer): Boolean;
    function DeleteAnswer(AnswerID: Integer): Boolean;
    function DeleteQuestAnswer(QuestAnswerID: Integer): Boolean;
    function DeleteRule(RuleID: Integer): Boolean;
    function DeleteExcludeRule(ExcludeRuleID: Integer): Boolean;
    function UpdateQuestion(QuestionID: Integer; const NewText: string; IsOpen: Boolean): Boolean;
    function UpdateAnswer(AnswerID: Integer; const NewText: string): Boolean;
    function UpdateRule(RuleID: Integer; QuestAnswerID, ParameterID: Integer;
      const Condition, ParamValue: string): Boolean;
    procedure doQuery(sql: TStringList);
    procedure dsQuestsDataChange(Sender: TObject; Field: TField);
    procedure btAddRuleClick(Sender: TObject);
    procedure btAddExcludeClick(Sender: TObject);
    procedure dsRulesDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure mbtAddQuestionClick(Sender: TObject);
    procedure pmbtAddAnswClick(Sender: TObject);
    procedure pmbtAddExistsAnswClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dsAnswDataChange(Sender: TObject; Field: TField);
    procedure mbtEditQuestionClick(Sender: TObject);
    procedure mbtDeleteQuestionClick(Sender: TObject);
    procedure pmbtEditAnswClick(Sender: TObject);
    procedure pmbtDeleteAnswClick(Sender: TObject);
    procedure btEditRuleClick(Sender: TObject);
    procedure btDeleteRuleClick(Sender: TObject);
    procedure btDeleteExcludeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Created :boolean;
  end;

var
  fmQuestionsAnswers: TfmQuestionsAnswers;

implementation

{$R *.dfm}

procedure TfmQuestionsAnswers.doQuery(sql: TStringList);
begin
  quRab.Close;
  quRab.SQL.Clear;
  quRab.SQL := (sql);
  quRab.Open;
end;

function TfmQuestionsAnswers.AddQuestRule(isOpen: boolean; QuestAnswer_ID, Question_ID, Parameter_ID: Integer;
  Condition, ParamValue: string; var newVal: Integer): Boolean;
var
  error: integer;
  sql : TStringList;
begin
  sql := TStringList.Create;
  try
    if not isOpen then
    begin
      SQL.Add('insert into [dbo].[QuestRules] ([QuestAnswer_ID], [Paramrter_ID], [Condition], [ParamValue], [Question_ID]) values');
      SQL.Add('(' + IntToStr(QuestAnswer_ID) + ', ' + IntToStr(Parameter_ID) + ', NULL, ''' + ParamValue + ''', NULL)');
      SQL.Add('SELECT IDENT_CURRENT(''QuestRules'') as cur, @@ERROR as Err');
    end
    else
    begin
      SQL.Add('insert into [dbo].[QuestRules] ([QuestAnswer_ID], [Paramrter_ID], [Condition], [ParamValue], [Question_ID]) values');
      SQL.Add('(NULL, ' + IntToStr(Parameter_ID) + ', ''' + Condition + ''', ''' + ParamValue + ''', ' + inttostr(Question_ID) + ')');
      SQL.Add('SELECT IDENT_CURRENT(''QuestRules'') as cur, @@ERROR as Err');
    end;
    doQuery(sql);
    error := quRab.FieldByName('Err').AsInteger;
    if Error <> 0 then
    begin
      Result := false;
      Exit;
    end;
    newVal := quRab.FieldByName('cur').AsInteger;
    Result := true;
  finally
    sql.Free;
  end;
end;

function TfmQuestionsAnswers.AddExcludeRule(QuestRule_ID: Integer; Question_ID: Integer; var newVal: Integer): Boolean;
var
  error: integer;
  sql : TStringList;
begin
  sql := TStringList.Create;
  try
    SQL.Add('insert into [dbo].[ExcludeRules] ([QuestRule_ID], [Question_ID]) values');
    SQL.Add('(' + IntToStr(QuestRule_ID) + ', ' + IntToStr(Question_ID) + ')');
    SQL.Add('SELECT IDENT_CURRENT(''ExcludeRules'') as cur, @@ERROR as Err');
    doQuery(sql);
    error := quRab.FieldByName('Err').AsInteger;
    if Error <> 0 then
    begin
      Result := false;
      Exit;
    end;
    newVal := quRab.FieldByName('cur').AsInteger;
    Result := true;
  finally
    sql.Free;
  end;
end;

// Функция обновления вопроса
function TfmQuestionsAnswers.UpdateQuestion(QuestionID: Integer; const NewText: string; IsOpen: Boolean): Boolean;
var
  sql: TStringList;
begin
  Result := False;
  sql := TStringList.Create;
  try
    SQL.Add('UPDATE [dbo].[Questions]');
    SQL.Add('SET [Text] = ''' + NewText + ''', [IsOpen] = ' + IntToStr(Ord(IsOpen)));
    SQL.Add('WHERE [Question_ID] = ' + IntToStr(QuestionID));

    doQuery(sql);
    Result := True;

    // Обновляем интерфейс
    quQuestions.Requery;
  finally
    sql.Free;
  end;
end;

// Функция удаления вопроса
function TfmQuestionsAnswers.DeleteQuestion(QuestionID: Integer): Boolean;
var
  sql: TStringList;
  res :Integer;
begin
  Result := False;

  // Проверяем, есть ли связанные записи
  sql := TStringList.Create;
  try
    // Проверяем QuestAnswers
    SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[QuestAnswers]');
    SQL.Add('WHERE [Question_ID] = ' + IntToStr(QuestionID));
    doQuery(sql);

    if quRab.FieldByName('cnt').AsInteger > 0 then
    begin
      ShowMessage('Нельзя удалить вопрос: существуют связанные ответы');
      Exit;
    end;

    // Проверяем ExcludeRules
    SQL.Clear;
    SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[ExcludeRules]');
    SQL.Add('WHERE [Question_ID] = ' + IntToStr(QuestionID));
    doQuery(sql);

    if quRab.FieldByName('cnt').AsInteger > 0 then
    begin
      ShowMessage('Нельзя удалить вопрос: существуют правила исключения');
      Exit;
    end;

    // Удаляем вопрос
    spDelQuest.Parameters.ParamByName('@piQuestionID').Value := QuestionID;
    spDelQuest.ExecProc;
    res := spDelQuest.FieldByName('@RETURN_VALUE').AsInteger;
    if res <> 0 then
      Result := false
    else
      Result := True;

    // Обновляем интерфейс
    quQuestions.Requery;
  finally
    sql.Free;
  end;
end;

// Функция обновления ответа
function TfmQuestionsAnswers.UpdateAnswer(AnswerID: Integer; const NewText: string): Boolean;
var
  sql: TStringList;
begin
  Result := False;
  sql := TStringList.Create;
  try
    SQL.Add('UPDATE [dbo].[Answers]');
    SQL.Add('SET [Text] = ''' + NewText + '''');
    SQL.Add('WHERE [Answer_ID] = ' + IntToStr(AnswerID));

    doQuery(sql);
    Result := True;

    // Обновляем интерфейс
    quAnswers.Requery;
  finally
    sql.Free;
  end;
end;

// Функция удаления ответа
function TfmQuestionsAnswers.DeleteAnswer(AnswerID: Integer): Boolean;
var
  sql: TStringList;
begin
  Result := False;

  // Проверяем, есть ли связанные записи в QuestAnswers
  sql := TStringList.Create;
  try
    SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[QuestAnswers]');
    SQL.Add('WHERE [Answ_ID] = ' + IntToStr(AnswerID));
    doQuery(sql);

    if quRab.FieldByName('cnt').AsInteger > 0 then
    begin
      ShowMessage('Нельзя удалить ответ: он связан с вопросами');
      Exit;
    end;

    // Удаляем ответ
    SQL.Clear;
    SQL.Add('DELETE FROM [dbo].[Answers]');
    SQL.Add('WHERE [Answer_ID] = ' + IntToStr(AnswerID));
    doQuery(sql);

    Result := True;

    // Обновляем интерфейс
    quAnswers.Requery;
  finally
    sql.Free;
  end;
end;

// Функция удаления связи вопроса и ответа
function TfmQuestionsAnswers.DeleteQuestAnswer(QuestAnswerID: Integer): Boolean;
var
  sql: TStringList;
begin
  Result := False;
  sql := TStringList.Create;
  try
    // Проверяем, есть ли связанные правила
    SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[QuestRules]');
    SQL.Add('WHERE [QuestAnswer_ID] = ' + IntToStr(QuestAnswerID));
    doQuery(sql);

    if quRab.FieldByName('cnt').AsInteger > 0 then
    begin
      ShowMessage('Нельзя удалить связь: существуют связанные правила');
      Exit;
    end;

    // Удаляем связь
    SQL.Clear;
    SQL.Add('DELETE FROM [dbo].[QuestAnswers]');
    SQL.Add('WHERE [QuestAnswer_ID] = ' + IntToStr(QuestAnswerID));
    doQuery(sql);

    Result := True;

    // Обновляем интерфейс
    quAnswers.Requery;
  finally
    sql.Free;
  end;
end;

// Функция обновления правила
function TfmQuestionsAnswers.UpdateRule(RuleID: Integer; QuestAnswerID, ParameterID: Integer;
  const Condition, ParamValue: string): Boolean;
var
  UpdateQuery: TADOQuery;
begin
  Result := False;
  UpdateQuery := TADOQuery.Create(nil);
  try
    try
      UpdateQuery.Connection := quRab.Connection; // Используем то же соединение
      UpdateQuery.SQL.Text :=
        'UPDATE [dbo].[QuestRules] ' +
        'SET [QuestAnswer_ID] = :QuestAnswerID, ' +
        '    [Paramrter_ID] = :ParameterID, ' +
        '    [Condition] = :Condition, ' +
        '    [ParamValue] = :ParamValue ' +
        'WHERE [QuestRule_ID] = :RuleID';

      // Параметры
      if QuestAnswerID > 0 then
        UpdateQuery.Parameters.ParamByName('QuestAnswerID').Value := QuestAnswerID
      else
        UpdateQuery.Parameters.ParamByName('QuestAnswerID').Value := Null;

      UpdateQuery.Parameters.ParamByName('ParameterID').Value := ParameterID;

      if Trim(Condition) <> '' then
        UpdateQuery.Parameters.ParamByName('Condition').Value := Condition
      else
        UpdateQuery.Parameters.ParamByName('Condition').Value := Null;

      UpdateQuery.Parameters.ParamByName('ParamValue').Value := ParamValue;
      UpdateQuery.Parameters.ParamByName('RuleID').Value := RuleID;

      UpdateQuery.ExecSQL;
      Result := True;

      // Обновляем интерфейс
      quRules.Requery;
      if Assigned(quRules) then
        quRules.Locate('QuestRule_ID', RuleID, []);

    except
      on E: Exception do
      begin
        ShowMessage('Ошибка при обновлении правила: ' + E.Message);
        Result := False;
      end;
    end;
  finally
    UpdateQuery.Free;
  end;
end;

// Функция удаления правила
function TfmQuestionsAnswers.DeleteRule(RuleID: Integer): Boolean;
var
  sql: TStringList;
begin
  Result := False;

  // Проверяем, есть ли связанные правила исключения
  sql := TStringList.Create;
  try
    SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[ExcludeRules]');
    SQL.Add('WHERE [QuestRule_ID] = ' + IntToStr(RuleID));
    doQuery(sql);

    if quRab.FieldByName('cnt').AsInteger > 0 then
    begin
      // Удаляем связанные правила исключения сначала
      SQL.Clear;
      SQL.Add('DELETE FROM [dbo].[ExcludeRules]');
      SQL.Add('WHERE [QuestRule_ID] = ' + IntToStr(RuleID));
      doQuery(sql);
    end;

    // Удаляем правило
    SQL.Clear;
    SQL.Add('DELETE FROM [dbo].[QuestRules]');
    SQL.Add('WHERE [QuestRule_ID] = ' + IntToStr(RuleID));
    doQuery(sql);

    Result := True;

    // Обновляем интерфейс
    quRules.Requery;
    quExclude.Requery;
  finally
    sql.Free;
  end;
end;

// Функция удаления правила исключения
function TfmQuestionsAnswers.DeleteExcludeRule(ExcludeRuleID: Integer): Boolean;
var
  sql: TStringList;
begin
  Result := False;
  sql := TStringList.Create;
  try
    SQL.Add('DELETE FROM [dbo].[ExcludeRules]');
    SQL.Add('WHERE [ExcludeRules_ID] = ' + IntToStr(ExcludeRuleID));
    doQuery(sql);

    Result := True;

    // Обновляем интерфейс
    quExclude.Requery;
  finally
    sql.Free;
  end;
end;

procedure TfmQuestionsAnswers.btAddExcludeClick(Sender: TObject);
var
  QuestRule_ID, Question_ID, mode, id, cnt: Integer;
  sql : TStringList;
begin
  if not Assigned(fmAddExcludeRule) then
    fmAddExcludeRule := TfmAddExcludeRule.Create(Self);

  fmAddExcludeRule.Question_ID := 0;
  fmAddExcludeRule.ShowModal;

  QuestRule_ID := quRules.FieldByName('QuestRule_ID').AsInteger;
  Question_ID := fmAddExcludeRule.Question_ID;
  mode := fmAddExcludeRule.tag;

  fmAddExcludeRule.Free;
  fmAddExcludeRule := nil;

  if mode = 0 then Exit;

  if mode = 1 then
  begin
    // Проверка существования QuestRule_ID
    sql := TStringList.Create;
    try
      SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[QuestRules]');
      SQL.Add('WHERE [QuestRule_ID] = ' + IntToStr(QuestRule_ID));
      doQuery(sql);
      cnt := quRab.FieldByName('cnt').AsInteger;

      if cnt = 0 then
      begin
        ShowMessage('Указанный QuestRule_ID не существует');
        Exit;
      end;

      // Проверка существования Question_ID
      SQL.Clear;
      SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[Questions]');
      SQL.Add('WHERE [Question_ID] = ' + IntToStr(Question_ID));
      doQuery(sql);
      cnt := quRab.FieldByName('cnt').AsInteger;

      if cnt = 0 then
      begin
        ShowMessage('Указанный Question_ID не существует');
        Exit;
      end;

      // Проверка на дубликат правила исключения
      SQL.Clear;
      SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[ExcludeRules]');
      SQL.Add('WHERE [QuestRule_ID] = ' + IntToStr(QuestRule_ID));
      SQL.Add('AND [Question_ID] = ' + IntToStr(Question_ID));
      doQuery(sql);
      cnt := quRab.FieldByName('cnt').AsInteger;

      if cnt <> 0 then
      begin
        ShowMessage('Такое правило исключения уже существует');
        Exit;
      end;
    finally
      sql.Free;
    end;

    // Добавление нового правила исключения
    if AddExcludeRule(QuestRule_ID, Question_ID, id) then
    begin
      quExclude.Close;
      quExclude.Open;
      grExclude.Update;
      //if Assigned(quExclude) then
      //  quExclude.Locate('ExcludeRules_ID', id, []);
    end
    else
    begin
      ShowMessage('Ошибка при вставке правила исключения');
      Exit;
    end;
  end;
end;

procedure TfmQuestionsAnswers.btAddRuleClick(Sender: TObject);
var
  QuestAnswer_ID, Parameter_ID, mode, id, cnt, QuestID: Integer;
  Condition, ParamValue: string;
  sql : TStringList;
  openQuest :Boolean;
begin
  if not Assigned(fmAddRule) then
    fmAddRule := TfmAddRule.Create(Self);

  // Инициализация формы значениями по умолчанию
  openQuest := dsQuests.DataSet.FieldByName('IsOpen').AsBoolean;
  QuestID := dsQuests.DataSet.FieldByName('Question_ID').AsInteger;
//  quAnswers.RecordCount = 0
  if not openQuest then
  begin
    if quAnswers.RecordCount <> 0 then
      QuestAnswer_ID := quAnswers.FieldByName('Answer_ID').AsInteger
    else begin
      ShowMessage('Для начала добавьте вариант ответа');
      Exit;
    end;
  end;

  fmAddRule.isOpen := openQuest;
  fmAddRule.Parameter_ID := 0;
  fmAddRule.Condition := '';
  fmAddRule.Value := '';

  fmAddRule.ShowModal;

  Parameter_ID := fmAddRule.Parameter_ID;
  Condition := fmAddRule.Condition;
  ParamValue := fmAddRule.Value;
  mode := fmAddRule.tag;

  fmAddRule.Free;
  fmAddRule := nil;

  if mode = 0 then Exit;

  if mode = 1 then
  begin
    // Проверка на существование подобного правила (опционально)
    sql := TStringList.Create;
    try
      SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[QuestRules]');
      SQL.Add('WHERE [QuestAnswer_ID] = ' + IntToStr(QuestAnswer_ID));
      SQL.Add('AND [Paramrter_ID] = ' + IntToStr(Parameter_ID));
      SQL.Add('AND [Condition] = ''' + Condition + '''');
      SQL.Add('AND [ParamValue] = ''' + ParamValue + '''');
      doQuery(sql);
      cnt := quRab.FieldByName('cnt').AsInteger;

      if cnt <> 0 then
      begin
        ShowMessage('Такое правило уже существует');
        Exit;
      end;
    finally
      sql.Free;
    end;

    // Добавление нового правила
    if AddQuestRule(openQuest, QuestAnswer_ID, QuestId, Parameter_ID, Condition, ParamValue, id) then
    begin
      // Обновление интерфейса
      quRules.Close;
      quRules.Open;
      grRules.Update;
      // Если есть компонент для отображения данных - обновить позицию
      if Assigned(quRules) then
        quRules.Locate('QuestRule_ID', id, []);
    end
    else
    begin
      ShowMessage('Ошибка при вставке правила');
      Exit;
    end;
  end;
end;

procedure TfmQuestionsAnswers.dsAnswDataChange(Sender: TObject; Field: TField);
var
  id :Integer;
begin
  if created then
  begin
    id := dsAnsw.DataSet.FieldByName('Answer_ID').AsInteger;
    quRules.Close;
    quRules.Parameters.ParamByName('answId').Value := id;
    quRules.Open;
    grRules.Update;
  end;
end;

procedure TfmQuestionsAnswers.dsQuestsDataChange(Sender: TObject;
  Field: TField);
var
  param :TParameter;
  id :Integer;
begin
  if Created then
  begin
    id := dsQuests.DataSet.FieldByName('Question_ID').AsInteger;
    quAnswers.Close;
    quAnswers.Parameters.ParamByName('id').Value := id;
    quAnswers.Open;
    grAnswers.Update;
    quRules.Close;
    quRules.Parameters.ParamByName('questId').Value := id;
    quRules.Open;
    grRules.Update;
  end;
end;

procedure TfmQuestionsAnswers.dsRulesDataChange(Sender: TObject; Field: TField);
var
  id :Integer;
begin
  if created then
  begin
    id := dsRules.DataSet.FieldByName('QuestRule_ID').AsInteger;
    quExclude.Close;
    quExclude.Parameters.ParamByName('id').Value := id;
    quExclude.Open;
    grExclude.Update;
  end;
end;

procedure TfmQuestionsAnswers.FormActivate(Sender: TObject);
begin
  quQuestions.Open;
  quAnswers.Open;
  quRules.Open;
  quExclude.Open;
  created := true;
end;

procedure TfmQuestionsAnswers.FormCreate(Sender: TObject);
begin
  quQuestions.Open;
  quAnswers.Open;
  quRules.Open;
  quExclude.Open;
end;

function TfmQuestionsAnswers.AppendQuestion(const psQuestion: string; pbOpen: Boolean; var piNewCod: Integer): Boolean;
begin
  Result := False;
  piNewCod := 0;
  try
    // Установка параметров через ParamByName
    spAddQuest.Parameters.ParamByName('@psQuestion').Value := psQuestion;
    spAddQuest.Parameters.ParamByName('@pbOpen').Value := pbOpen;

    // Указание направления параметров
    {spAddQuest.Parameters.ParamByName('@psQuestion').Direction := pdInput;
    spAddQuest.Parameters.ParamByName('@pbOpen').Direction := pdInput;
    spAddQuest.Parameters.ParamByName('@piNewCod').Direction := pdOutput;}

    // Выполнение процедуры
    spAddQuest.ExecProc;

    // Получение выходного параметра
    piNewCod := spAddQuest.Parameters.ParamByName('@piNewCod').Value;

    Result := True;

  except
    on E: Exception do
    begin
      ShowMessage('Ошибка выполнения Append_Question: ' + E.Message);
      Result := False;
    end;
  end;
end;

procedure TfmQuestionsAnswers.mbtAddQuestionClick(Sender: TObject);
var
  QuestionText: string;
  IsOpen: Boolean;
  mode, NewQuestionID: Integer;
begin
  Self.Visible := False;

  if not Assigned(fmAddQuestion) then
    fmAddQuestion := TfmAddQuestion.Create(Self);

  // Инициализация формы значениями по умолчанию
  fmAddQuestion.QText := '';
  fmAddQuestion.IsOpen := False;

  fmAddQuestion.ShowModal;

  // Получение данных из формы
  QuestionText := fmAddQuestion.QText;
  IsOpen := fmAddQuestion.IsOpen;
  mode := fmAddQuestion.tag;

  fmAddQuestion.Free;
  fmAddQuestion := nil;

  Self.Visible := True;

  if mode = 0 then Exit;

  if mode = 1 then
  begin
    // Проверка на существование подобного вопроса
    var sql := TStringList.Create;
    try
      SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[Questions]');
      SQL.Add('WHERE [Text] = ''' + QuestionText + '''');
      doQuery(sql);
      var cnt := quRab.FieldByName('cnt').AsInteger;

      if cnt <> 0 then
      begin
        ShowMessage('Такой вопрос уже существует');
        Exit;
      end;
    finally
      sql.Free;
    end;

    // Добавление нового вопроса через хранимую процедуру
    if AppendQuestion(QuestionText, IsOpen, NewQuestionID) then
    begin
      // Обновление интерфейса
      quQuestions.Close;
      quQuestions.Open;
      grQuestions.Update;
      // Если есть компонент для отображения данных - обновить позицию
      if Assigned(quQuestions) then
        quQuestions.Locate('Question_ID', NewQuestionID, []);
    end
    else
    begin
      ShowMessage('Ошибка при добавлении вопроса');
      Exit;
    end;
  end;
end;

procedure TfmQuestionsAnswers.mbtDeleteQuestionClick(Sender: TObject);
var
  QuestionID: Integer;
begin
  if quQuestions.IsEmpty then Exit;

  QuestionID := quQuestions.FieldByName('Question_ID').AsInteger;

  if MessageDlg('Вы уверены, что хотите удалить этот вопрос?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if DeleteQuestion(QuestionID) then
      ShowMessage('Вопрос успешно удален')
    else
      ShowMessage('Ошибка при удалении вопроса');
  end;
end;

procedure TfmQuestionsAnswers.mbtEditQuestionClick(Sender: TObject);
var
  QuestionID: Integer;
  CurrentText: string;
  IsOpen: Boolean;
begin
  if quQuestions.IsEmpty then Exit;

  QuestionID := quQuestions.FieldByName('Question_ID').AsInteger;
  CurrentText := quQuestions.FieldByName('Text').AsString;
  IsOpen := quQuestions.FieldByName('IsOpen').AsBoolean;

  // Используем существующую форму добавления вопроса для редактирования
  if not Assigned(fmAddQuestion) then
    fmAddQuestion := TfmAddQuestion.Create(Self);

  fmAddQuestion.QText := CurrentText;
  fmAddQuestion.IsOpen := IsOpen;
  fmAddQuestion.Caption := 'Редактирование вопроса';

  fmAddQuestion.ShowModal;

  if fmAddQuestion.Tag = 1 then
  begin
    if UpdateQuestion(QuestionID, fmAddQuestion.QText, fmAddQuestion.IsOpen) then
      ShowMessage('Вопрос успешно обновлен')
    else
      ShowMessage('Ошибка при обновлении вопроса');
  end;

  fmAddQuestion.Free;
  fmAddQuestion := nil;
end;

function TfmQuestionsAnswers.AddQuestAnswer(piQuestId: Integer; piAnswId: Integer; var piNewCod: Integer): Boolean;
var
  ErrCode: Integer;
begin
  Result := False;
  piNewCod := 0;
  try
      // Установка значений
      spAddAnsw.Parameters.ParamByName('@piQuestId').Value := piQuestId;
      spAddAnsw.Parameters.ParamByName('@piAnswId').Value := piAnswId;

      // Выполнение процедуры
      spAddAnsw.ExecProc;

      // Получение результатов
      ErrCode := spAddAnsw.Parameters.ParamByName('@RETURN_VALUE').Value;
      piNewCod := spAddAnsw.Parameters.ParamByName('@piNewCod').Value;

      // Проверка на ошибки
      if (ErrCode <> 0) or (piNewCod = -1) then
      begin
        ShowMessage('Ошибка при добавлении ответа на вопрос: ' + IntToStr(ErrCode));
        Result := False;
      end
      else
      begin
        Result := True;
      end;

    except
     on E: Exception do
    begin
      ShowMessage('Исключение при выполнении AddQuestAnswer: ' + E.Message);
      Result := False;
    end;
  end;
end;

procedure TfmQuestionsAnswers.pmbtAddAnswClick(Sender: TObject);
var
  AnswerText: string;
  mode, NewAnswerID, QuestAnswerID: Integer;
  sql: TStringList;
  CurrentQuestionID: Integer;
begin
  // Получаем ID текущего вопроса
  if quQuestions.IsEmpty then
  begin
    ShowMessage('Сначала выберите вопрос');
    Exit;
  end;

  CurrentQuestionID := quQuestions.FieldByName('Question_ID').AsInteger;

  // Проверяем, не является ли вопрос открытым
  if quQuestions.FieldByName('IsOpen').AsBoolean then
  begin
    ShowMessage('Нельзя добавлять ответы к открытому вопросу');
    Exit;
  end;

  AnswerText := InputBox('', 'Текст ответа', '');

  if AnswerText = '' then Exit
  else
  begin
    // Проверка на существование подобного ответа
    sql := TStringList.Create;
    try
      SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[Answers]');
      SQL.Add('WHERE [Text] = ''' + AnswerText + '''');
      doQuery(sql);
      var cnt := quRab.FieldByName('cnt').AsInteger;

      if cnt <> 0 then
      begin
        ShowMessage('Такой ответ уже существует');
        Exit;
      end;
    finally
      sql.Free;
    end;

    // Сначала добавляем ответ в таблицу Answers
    sql := TStringList.Create;
    try
      SQL.Add('INSERT INTO [dbo].[Answers] ([Text])');
      SQL.Add('VALUES (''' + AnswerText + ''')');
      SQL.Add('SELECT IDENT_CURRENT(''Answers'') as NewID, @@ERROR as Err');
      doQuery(sql);

      var Err := quRab.FieldByName('Err').AsInteger;
      if Err <> 0 then
      begin
        ShowMessage('Ошибка при создании ответа');
        Exit;
      end;

      NewAnswerID := quRab.FieldByName('NewID').AsInteger;
    finally
      sql.Free;
    end;

    // Теперь связываем ответ с вопросом через хранимую процедуру
    if AddQuestAnswer(CurrentQuestionID, NewAnswerID, QuestAnswerID) then
    begin
      // Обновление интерфейса
      quAnswers.Requery;
      grAnswers.Update;

      ShowMessage(Format('Ответ успешно добавлен! ID связи: %d', [QuestAnswerID]));
    end
    else
    begin
      ShowMessage('Ошибка при связывании ответа с вопросом');
      Exit;
    end;
  end;
end;

procedure TfmQuestionsAnswers.pmbtAddExistsAnswClick(Sender: TObject);
var
  SelectedAnswerID, CurrentQuestionID, QuestAnswerID: Integer;
  mode: Integer;
  sql: TStringList;
begin
  // Получаем ID текущего вопроса
  if quQuestions.IsEmpty then
  begin
    ShowMessage('Сначала выберите вопрос');
    Exit;
  end;

  CurrentQuestionID := quQuestions.FieldByName('Question_ID').AsInteger;

  // Проверяем, не является ли вопрос открытым
  if quQuestions.FieldByName('IsOpen').AsBoolean then
  begin
    ShowMessage('Нельзя добавлять ответы к открытому вопросу');
    Exit;
  end;

  if not Assigned(fmSelectAnswer) then
    fmSelectAnswer := TfmSelectAnswer.Create(Self);

  // Инициализация формы выбора существующего ответа
  fmSelectAnswer.SelectedAnswerID := 0;
  fmSelectAnswer.ShowModal;

  SelectedAnswerID := fmSelectAnswer.SelectedAnswerID;
  mode := fmSelectAnswer.tag;

  fmSelectAnswer.Free;
  fmSelectAnswer := nil;

  if mode = 0 then Exit;

  if mode = 1 then
  begin
    if SelectedAnswerID = 0 then
    begin
      ShowMessage('Ответ не выбран');
      Exit;
    end;

    // Проверяем, не добавлен ли уже этот ответ к вопросу
    sql := TStringList.Create;
    try
      SQL.Add('SELECT COUNT(*) as cnt FROM [dbo].[QuestAnswers]');
      SQL.Add('WHERE [Question_ID] = ' + IntToStr(CurrentQuestionID));
      SQL.Add('AND [Answ_ID] = ' + IntToStr(SelectedAnswerID));
      doQuery(sql);
      var cnt := quRab.FieldByName('cnt').AsInteger;

      if cnt <> 0 then
      begin
        ShowMessage('Этот ответ уже добавлен к данному вопросу');
        Exit;
      end;
    finally
      sql.Free;
    end;

    // Связываем существующий ответ с вопросом
    if AddQuestAnswer(CurrentQuestionID, SelectedAnswerID, QuestAnswerID) then
    begin
      // Обновление интерфейса
      quAnswers.Requery;
      grAnswers.Update;

      ShowMessage(Format('Ответ успешно связан с вопросом! ID связи: %d', [QuestAnswerID]));
    end
    else
    begin
      ShowMessage('Ошибка при связывании ответа с вопросом');
      Exit;
    end;
  end;
end;

procedure TfmQuestionsAnswers.pmbtEditAnswClick(Sender: TObject);
var
  AnswerID: Integer;
  CurrentText: string;
begin
  if quAnswers.IsEmpty then Exit;

  AnswerID := quAnswers.FieldByName('Answer_ID').AsInteger;
  CurrentText := quAnswers.FieldByName('Text').AsString;

  // Редактирование ответа через InputBox
  CurrentText := InputBox('Редактирование ответа', 'Текст ответа:', CurrentText);

  if (CurrentText <> '') and (CurrentText <> quAnswers.FieldByName('Text').AsString) then
  begin
    if UpdateAnswer(AnswerID, CurrentText) then
      ShowMessage('Ответ успешно обновлен')
    else
      ShowMessage('Ошибка при обновлении ответа');
  end;
end;

procedure TfmQuestionsAnswers.pmbtDeleteAnswClick(Sender: TObject);
var
  AnswerID: Integer;
begin
  if quAnswers.IsEmpty then Exit;

  AnswerID := quAnswers.FieldByName('Answer_ID').AsInteger;

  if MessageDlg('Вы уверены, что хотите удалить этот ответ?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if DeleteAnswer(AnswerID) then
      ShowMessage('Ответ успешно удален')
    else
      ShowMessage('Ошибка при удалении ответа');
  end;
end;

procedure TfmQuestionsAnswers.btEditRuleClick(Sender: TObject);
var
  RuleID, QuestAnswerID, ParameterID: Integer;
  Condition, ParamValue: string;
  open :boolean;
begin
  if quRules.IsEmpty then Exit;

  RuleID := quRules.FieldByName('QuestRule_ID').AsInteger;
  QuestAnswerID := quRules.FieldByName('QuestAnswer_ID').AsInteger;
  ParameterID := quRules.FieldByName('Paramrter_ID').AsInteger;
  Condition := quRules.FieldByName('Condition').AsString;
  ParamValue := quRules.FieldByName('ParamValue').AsString;

  open := dsQuests.DataSet.FieldByName('IsOpen').AsBoolean;

  // Используем существующую форму добавления правила для редактирования
  if not Assigned(fmAddRule) then
    fmAddRule := TfmAddRule.Create(Self);

  fmAddRule.isOpen := open;
  fmAddRule.Parameter_ID := ParameterID;
  fmAddRule.Condition := Condition;
  fmAddRule.Value := ParamValue;
  fmAddRule.Caption := 'Редактирование правила';

  fmAddRule.ShowModal;

  if fmAddRule.Tag = 1 then
  begin
    if UpdateRule(RuleID, QuestAnswerID, fmAddRule.Parameter_ID,
                  fmAddRule.Condition, fmAddRule.Value) then
      ShowMessage('Правило успешно обновлено')
    else
      ShowMessage('Ошибка при обновлении правила');
  end;

  fmAddRule.Free;
  fmAddRule := nil;
end;

procedure TfmQuestionsAnswers.btDeleteRuleClick(Sender: TObject);
var
  RuleID: Integer;
begin
  if quRules.IsEmpty then Exit;

  RuleID := quRules.FieldByName('QuestRule_ID').AsInteger;

  if MessageDlg('Вы уверены, что хотите удалить это правило?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if DeleteRule(RuleID) then
      ShowMessage('Правило успешно удалено')
    else
      ShowMessage('Ошибка при удалении правила');
  end;
end;

procedure TfmQuestionsAnswers.btDeleteExcludeClick(Sender: TObject);
var
  ExcludeRuleID: Integer;
begin
  if quExclude.IsEmpty then Exit;

  ExcludeRuleID := quExclude.FieldByName('ExcludeRules_ID').AsInteger;

  if MessageDlg('Вы уверены, что хотите удалить это правило исключения?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if DeleteExcludeRule(ExcludeRuleID) then
      ShowMessage('Правило исключения успешно удалено')
    else
      ShowMessage('Ошибка при удалении правила исключения');
  end;
end;

end.
