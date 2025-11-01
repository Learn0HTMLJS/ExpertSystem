unit DMbase;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TfmDmBase = class(TDataModule)
    dbConnection: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDmBase: TfmDmBase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
