program WKTeste;

uses
  Vcl.Forms,
  UCadPessoa in 'UCadPessoa.pas' {FrPessoa},
  UPesquisaPessoa in 'UPesquisaPessoa.pas' {frPesquisa},
  UDmConexao in 'UDmConexao.pas' {DmConexao: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrPessoa, FrPessoa);
  Application.CreateForm(TfrPesquisa, frPesquisa);
  Application.CreateForm(TDmConexao, DmConexao);
  Application.Run;
end.
