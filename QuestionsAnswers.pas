unit QuestionsAnswers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DMbase, Data.DB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Vcl.Menus, Vcl.Tabs, Vcl.ComCtrls;

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
    DBGrid1: TDBGrid;
    quExclude: TADOQuery;
    procedure dsQuestsDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmQuestionsAnswers: TfmQuestionsAnswers;

implementation

{$R *.dfm}

procedure TfmQuestionsAnswers.dsQuestsDataChange(Sender: TObject;
  Field: TField);
var
  param :TParameter;
  id :Integer;
begin
  id := dsQuests.DataSet.FieldByName('Question_ID').AsInteger;
  quAnswers.Close;
  param := quAnswers.Parameters.FindParam(':id');
  param.Value := id;
  quAnswers.Open;
  grAnswers.Update;
end;

end.
