program Project1;

uses
  Vcl.Forms,
  AddParam in 'AddParam.pas' {fmAddParam},
  DMbase in 'DMbase.pas' {fmDmBase: TDataModule},
  QuestionsAnswers in 'QuestionsAnswers.pas' {fmQuestionsAnswers},
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {fmParameters},
  AddQuestion in 'AddQuestion.pas' {fmAddQuestion},
  AddRule in 'AddRule.pas' {fmAddRule},
  AddExcludeRule in 'AddExcludeRule.pas' {fmAddExcludeRule},
  SelectAnswer in 'SelectAnswer.pas' {fmSelectAnswer},
  Questionnaire in 'Questionnaire.pas' {fmQuestionnaire},
  Results in 'Results.pas' {fmResults},
  Attributes in 'Attributes.pas' {fmAttributes},
  AttrParRules in 'AttrParRules.pas' {fmAttrParRules};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmDmBase, fmDmBase);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfmAddQuestion, fmAddQuestion);
  Application.CreateForm(TfmAddRule, fmAddRule);
  Application.CreateForm(TfmAddExcludeRule, fmAddExcludeRule);
  Application.CreateForm(TfmSelectAnswer, fmSelectAnswer);
  Application.CreateForm(TfmQuestionnaire, fmQuestionnaire);
  Application.CreateForm(TfmResults, fmResults);
  Application.CreateForm(TfmAttributes, fmAttributes);
  Application.CreateForm(TfmAttrParRules, fmAttrParRules);
  Application.Run;
end.
