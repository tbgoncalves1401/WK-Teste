unit ServerContainerUnit1;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSHTTPCommon, Datasnap.DSHTTP,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSAuth, IPPeerServer;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSHTTPService1: TDSHTTPService;
    Pessoa: TDSServerClass;
    EnderecoIntegracao: TDSServerClass;
    Endereco: TDSServerClass;
    procedure PessoaGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure EnderecoIntegracaoGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure EnderecoGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
  private
    { Private declarations }
  public
  end;

procedure RunDSServer;

implementation


{$R *.dfm}

uses Winapi.Windows, UPessoa, UEndereco, UEnderecoIntegracao;

procedure TServerContainer1.EnderecoGetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
  PersistentClass := UEndereco.TWsEndereco;
end;

procedure TServerContainer1.EnderecoIntegracaoGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := UEnderecoIntegracao.TWsEnderecoIntegracao;
end;

procedure TServerContainer1.PessoaGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := UPessoa.TWsPessoa;
end;


procedure RunDSServer;
var
  LModule: TServerContainer1;
  LInputRecord: TInputRecord;
  LEvent: DWord;
  LHandle: THandle;
begin
  Writeln(Format('Starting %s', [TServerContainer1.ClassName]));
  LModule := TServerContainer1.Create(nil);
  try
    LModule.DSServer1.Start;
    try
      Writeln('Press ESC to stop the server');
      LHandle := GetStdHandle(STD_INPUT_HANDLE);
      while True do
      begin
        ReadConsoleInput(LHandle, LInputRecord, 1, LEvent);
        if (LInputRecord.EventType = KEY_EVENT) and
        LInputRecord.Event.KeyEvent.bKeyDown and
        (LInputRecord.Event.KeyEvent.wVirtualKeyCode = VK_ESCAPE) then
          break;
      end;
    finally
      LModule.DSServer1.Stop;
    end;
  finally
    LModule.Free;
  end;
end;

end.

