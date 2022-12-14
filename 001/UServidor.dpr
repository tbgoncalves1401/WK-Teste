program UServidor;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  ServerContainerUnit1 in 'ServerContainerUnit1.pas' {ServerContainer1: TDataModule},
  UEnderecoIntegracao in 'UEnderecoIntegracao.pas' {WsEnderecoIntegracao: TDataModule},
  UEndereco in 'UEndereco.pas' {WsEndereco: TDataModule},
  UPessoa in 'UPessoa.pas' {WsPessoa: TDataModule},
  UDMConexao in 'UDMConexao.pas' {DmConexao: TDataModule},
  DataSetConverter4D.Helper in '..\..\..\..\Componentes\DataSetConverter4Delphi-master\src\DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in '..\..\..\..\Componentes\DataSetConverter4Delphi-master\src\DataSetConverter4D.Impl.pas',
  DataSetConverter4D in '..\..\..\..\Componentes\DataSetConverter4Delphi-master\src\DataSetConverter4D.pas',
  DataSetConverter4D.Util in '..\..\..\..\Componentes\DataSetConverter4Delphi-master\src\DataSetConverter4D.Util.pas';

begin
  try
    RunDSServer;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.

