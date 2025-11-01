program Project1;

uses
  Vcl.Forms,
  AddParam in 'AddParam.pas' {fmAddParam},
  DMbase in 'DMbase.pas' {fmDmBase: TDataModule},
  QuestionsAnswers in 'QuestionsAnswers.pas' {fmQuestionsAnswers},
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {fmParameters},
  AddQuestion in 'AddQuestion.pas' {fmAddQuestion};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmDmBase, fmDmBase);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfmAddQuestion, fmAddQuestion);
  Application.Run;
end.
