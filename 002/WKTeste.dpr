program WKTeste;

uses
  Vcl.Forms,
  UCadPessoa in 'UCadPessoa.pas' {FrPessoa},
  UPesquisaPessoa in 'UPesquisaPessoa.pas' {frPesquisa},
  clConex in 'clConex.pas',
  DataSetConverter4D.Helper in 'DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in 'DataSetConverter4D.Impl.pas',
  DataSetConverter4D in 'DataSetConverter4D.pas',
  DataSetConverter4D.Util in 'DataSetConverter4D.Util.pas',
  UThread in 'UThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrPessoa, FrPessoa);
  Application.CreateForm(TfrPesquisa, frPesquisa);
  Application.Run;
end.
