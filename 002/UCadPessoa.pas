unit UCadPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.Buttons, System.JSON;

type
  TFrPessoa = class(TForm)
    Label1: TLabel;
    edNatureza: TEdit;
    edDocumento: TEdit;
    Label2: TLabel;
    edPrimNome: TEdit;
    Label3: TLabel;
    edSegNome: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edCEP: TEdit;
    BitBtn1: TBitBtn;
    Label6: TLabel;
    EdUF: TEdit;
    edCidade: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edLogradouro: TEdit;
    edComplemento: TEdit;
    Label9: TLabel;
    btGravar: TButton;
    btNovo: TButton;
    btnPesquisarPessoa: TButton;
    RESTResponseGet: TRESTResponse;
    RESTRequestGet: TRESTRequest;
    RESTGet: TRESTClient;
    btnDelete: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btGravarClick(Sender: TObject);
    procedure btnPesquisarPessoaClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    novoRegistro: Boolean;
    codP, codEnder: string;
    function removeChaves(valor: string):string;
  public
    { Public declarations }
  end;

var
  FrPessoa: TFrPessoa;

implementation

uses
  REST.Types, REST.Utils, System.JSON.Readers, UPesquisaPessoa, UDmConexao;

ResourceString
  URL_Pessoa = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa';
  URL_EnderecoIntegracao = 'http://127.0.0.1:8080/datasnap/rest/TWsEnderecoIntegracao/EnderecoIntegracao';
  URL_Endereco = 'http://127.0.0.1:8080/datasnap/rest/TWsEndereco/Endereco';

{$R *.dfm}

procedure TFrPessoa.BitBtn1Click(Sender: TObject);
var
  cep: string;
  jason: TJSONObject;
begin
  cep := edCEP.Text;
  if pos('-', CEP)>0 then
    Delete(cep, pos('-', CEP), 1);
  DmConexao.RESTClientCEP.BaseURL := 'viacep.com.br/ws/'+cep+'/json';
  DmConexao.RESTRequestCEP.Execute;
  jason := TJSONObject.ParseJSONValue( DmConexao.RESTRequestCEP.Response.JSONText ) as TJSONObject;
  EdUF.Clear;
  edCidade.Clear;
  edLogradouro.Clear;
  edComplemento.Clear;
  if(jason.GetValue('erro') <> nil)and (UpperCase(jason.GetValue('erro').Value) = 'TRUE') then
    Application.MessageBox('CEP n�o encontrado', 'Aviso', MB_ICONWARNING+MB_OK)
  else
  begin
    EdUF.Text := jason.GetValue('uf').Value;
    edCidade.Text := jason.GetValue('localidade').Value;
    edLogradouro.Text := jason.GetValue('logradouro').Value;
    edComplemento.Text := jason.GetValue('complemento').Value;
  end;
end;

procedure TFrPessoa.btNovoClick(Sender: TObject);
begin
  edNatureza.Clear;
  edDocumento.Clear;
  edPrimNome.Clear;
  edSegNome.Clear;
  EdUF.Clear;
  edCidade.Clear;
  edLogradouro.Clear;
  edComplemento.Clear;
  edNatureza.SetFocus;
  novoRegistro := True;
end;

procedure TFrPessoa.btnPesquisarPessoaClick(Sender: TObject);
var
  Pesquisa: TfrPesquisa;
  retorno: string;
  jason: TJSONObject;
begin
  pesquisa := TfrPesquisa.Create(nil);
  try
    Pesquisa.ShowModal;
    if (Pesquisa.codP.ToInteger > 0) then
    begin
      RESTGet.BaseURL := URL_Pessoa+'/'+Pesquisa.codP;
      RESTRequestGet.Execute;
      retorno := removeChaves(RESTRequestGet.Response.JSONText);
      jason := TJSONObject.ParseJSONValue( retorno ) as TJSONObject;

      novoRegistro := False;
      codP := Pesquisa.codP;
      codEnder := Pesquisa.codEndInt;

      edNatureza.Text  := jason.GetValue('flnatureza').Value;
      edDocumento.Text := jason.GetValue('dsdocumento').Value;
      edPrimNome.Text  := jason.GetValue('nmprimeiro').Value;
      edSegNome.Text   := jason.GetValue('nmsegundo').Value;
    end;
  finally
    FreeAndNil(Pesquisa);
  end;
end;

function TFrPessoa.removeChaves(valor: string): string;
var
  retorno: string;
begin
  retorno := valor;
  while pos('[', retorno)>0 do
    Delete(retorno, pos('[', retorno), 1);
  while pos(']', retorno)>0 do
    Delete(retorno, pos(']', retorno), 1);
  Result := retorno;
end;

procedure TFrPessoa.btnDeleteClick(Sender: TObject);
begin
  if(Application.MessageBox('Deseja realmente excluir a pessoa?', 'Confirma��o', MB_YESNO+MB_ICONQUESTION)=ID_YES)then
  begin
    DmConexao.RESTClientDELETE.BaseURL := URL_Pessoa+'/'+codP;
    DmConexao.RESTRequestDELETE.Execute;
    btNovoClick(nil);
  end;
end;

procedure TFrPessoa.btGravarClick(Sender: TObject);
var
  JOPessoa, JOEnderecoIntegracao, JOEndereco: TJSONObject;
  retorno: string;
  Rest: TRESTClient;
  Request: TRESTRequest;
  Response: TRESTResponse;
begin
  JOPessoa := TJSONObject.Create;
  JOEnderecoIntegracao := TJSONObject.Create;
  JOEndereco := TJSONObject.Create;
  JOPessoa.AddPair('flnatureza', edNatureza.Text);
  JOPessoa.AddPair('dsdocumento', edDocumento.Text);
  JOPessoa.AddPair('nmprimeiro', edPrimNome.Text);
  JOPessoa.AddPair('nmsegundo', edSegNome.Text);

  JOEnderecoIntegracao.AddPair('dsuf', EdUF.Text);
  JOEnderecoIntegracao.AddPair('nmcidade', edCidade.Text);
  JOEnderecoIntegracao.AddPair('nmlogradouro', edLogradouro.Text);
  JOEnderecoIntegracao.AddPair('dscomplemento', edComplemento.Text);

  JOEndereco.AddPair('dscep', edCEP.Text);
  try
    if novoRegistro then
    begin
      JOPessoa.AddPair('idpessoa', '-1');

      DmConexao.RESTRequestPUT.Body.Add(JOPessoa.ToString);
      DmConexao.RESTRequestPUT.Execute;
      retorno := removeChaves(DmConexao.RESTRequestPUT.Response.JSONText);
      ShowMessage(retorno);

      JOEnderecoIntegracao.AddPair('idendereco', '-1');
      DmConexao.RESTRequestPUTEnderecoIntegracao.Body.Add(JOEnderecoIntegracao.ToString);
      DmConexao.RESTRequestPUTEnderecoIntegracao.Execute;

      JOEndereco.AddPair('idendereco', '-1');
      DmConexao.RESTRequestPUTEndereco.Body.Add(JOEndereco.ToString);
      DmConexao.RESTRequestPUTEndereco.Execute;

      btNovoClick(NIL);
    end
    else
    begin
      DmConexao.RESTClientPOST.BaseURL := URL_Pessoa+'/'+codP;
      DmConexao.RESTRequestPOST.Body.Add(JOPessoa.ToString);
      DmConexao.RESTRequestPOST.Execute;

      DmConexao.RESTEnderecoIntegracaoPOST.BaseURL := URL_EnderecoIntegracao+'/'+codEnder;
      DmConexao.RESTRequestEnderecoIntegracaoPOST.Body.Add(JOEnderecoIntegracao.ToString);
      DmConexao.RESTRequestEnderecoIntegracaoPOST.Execute;

      DmConexao.RESTEnderecoPOST.BaseURL := URL_Endereco+'/'+codEnder;
      DmConexao.RESTRequestEnderecoPOST.Body.Add(JOEndereco.ToString);
      DmConexao.RESTRequestEnderecoPOST.Execute;

    end;
  finally
    if novoRegistro then
    begin
      DmConexao.RESTRequestPUT.Body.ClearBody;
      DmConexao.RESTRequestPUT.ClearBody;
      DmConexao.RESTRequestPUT.ResetToDefaults;
      DmConexao.RESTRequestPUTEnderecoIntegracao.ClearBody;
      DmConexao.RESTRequestPUTEnderecoIntegracao.ResetToDefaults;
    end
    else
    begin
      DmConexao.RESTRequestPOST.ClearBody;
      DmConexao.RESTRequestPOST.ResetToDefaults;
      DmConexao.RESTClientPOST.ResetToDefaults;
      DmConexao.RESTResponsePOST.ResetToDefaults;

      DmConexao.RESTRequestEnderecoIntegracaoPOST.ClearBody;
      DmConexao.RESTRequestEnderecoIntegracaoPOST.ResetToDefaults;
      DmConexao.RESTEnderecoIntegracaoPOST.ResetToDefaults;
      DmConexao.RESTResponseEnderecoIntegracaoPOST.ResetToDefaults;

      DmConexao.RESTRequestEnderecoPOST.ClearBody;
      DmConexao.RESTRequestEnderecoPOST.ResetToDefaults;
      DmConexao.RESTEnderecoPOST.ResetToDefaults;
      DmConexao.RESTResponseEnderecoPOST.ResetToDefaults;

      novoRegistro := False;
      codP := codP;
      codEnder := codEnder;
    end;
  end;
end;

end.