unit UDmConexao;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TDmConexao = class(TDataModule)
    RESTClientCEP: TRESTClient;
    RESTRequestCEP: TRESTRequest;
    RESTResponseCEP: TRESTResponse;
    RESTClientPUT: TRESTClient;
    RESTRequestPUT: TRESTRequest;
    RESTResponsePUT: TRESTResponse;
    RESTClientPOST: TRESTClient;
    RESTRequestPOST: TRESTRequest;
    RESTResponsePOST: TRESTResponse;
    RESTClientDELETE: TRESTClient;
    RESTRequestDELETE: TRESTRequest;
    RESTResponseDELETE: TRESTResponse;
    RESTClientPUTEndereco_INTEGRACAO: TRESTClient;
    RESTRequestPUTEnderecoIntegracao: TRESTRequest;
    RESTResponsePUTEnderecoIntegracao: TRESTResponse;
    RESTEnderecoIntegracaoPOST: TRESTClient;
    RESTRequestEnderecoIntegracaoPOST: TRESTRequest;
    RESTResponseEnderecoIntegracaoPOST: TRESTResponse;
    RESTClientEnderecoIntegracaoDelete: TRESTClient;
    RESTRequestEnderecoIntegracaoDelete: TRESTRequest;
    RESTResponseEnderecoIntegracaoDelete: TRESTResponse;
    RESTClientPUTEndereco: TRESTClient;
    RESTRequestPUTEndereco: TRESTRequest;
    RESTResponsePUTEndereco: TRESTResponse;
    RESTEnderecoPOST: TRESTClient;
    RESTRequestEnderecoPOST: TRESTRequest;
    RESTResponseEnderecoPOST: TRESTResponse;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmConexao: TDmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.