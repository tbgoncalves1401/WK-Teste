unit UCadPessoa;

interface

uses Winapi.Windows, Vcl.Forms, System.JSON, System.SysUtils,
Vcl.StdCtrls, Vcl.Buttons, Vcl.Controls, System.Classes, Vcl.Dialogs,
  Vcl.ComCtrls;

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
    btnPesquisar: TBitBtn;
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
    btnDelete: TButton;
    btnLote: TButton;
    OpenDialog1: TOpenDialog;
    ProgressBar1: TProgressBar;
    procedure btnPesquisarClick(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btGravarClick(Sender: TObject);
    procedure btnPesquisarPessoaClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLoteClick(Sender: TObject);
  private
    { Private declarations }
    novoRegistro: Boolean;
    codP, codEnder: string;

  public
    { Public declarations }
  end;

var
  FrPessoa: TFrPessoa;

implementation

uses
  REST.Types, REST.Utils, System.JSON.Readers, UPesquisaPessoa, UDmConexao,
  clConex, UThread;

ResourceString
  URL_Pessoa = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa';
  URL_EnderecoIntegracao = 'http://127.0.0.1:8080/datasnap/rest/TWsEnderecoIntegracao/EnderecoIntegracao';
  URL_Endereco = 'http://127.0.0.1:8080/datasnap/rest/TWsEndereco/Endereco';

{$R *.dfm}

procedure TFrPessoa.btnPesquisarClick(Sender: TObject);
var
  cep: string;
  jason: TJSONObject;
  rest: TComRest;
begin
  cep := edCEP.Text;
  if pos('-', CEP)>0 then
    Delete(cep, pos('-', CEP), 1);
  rest := TComRest.create('viacep.com.br/ws/'+cep+'/json');
  try
    rest.metodo := Consultar;
    jason := rest.executar;
  finally
    FreeAndNil(rest);
  end;
  EdUF.Clear;
  edCidade.Clear;
  edLogradouro.Clear;
  edComplemento.Clear;
  if(jason.GetValue('erro') <> nil)and (UpperCase(jason.GetValue('erro').Value) = 'TRUE') then
    Application.MessageBox('CEP não encontrado', 'Aviso', MB_ICONWARNING+MB_OK)
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
  edCEP.Clear;
  edNatureza.SetFocus;
  novoRegistro := True;
end;

procedure TFrPessoa.btnPesquisarPessoaClick(Sender: TObject);
var
  Pesquisa: TfrPesquisa;
  retorno: string;
  jason: TJSONObject;
  RestRetPess, RestRetEnder, RestRetEnderInt: TComRest;
begin
  pesquisa := TfrPesquisa.Create(nil);
  try
    Pesquisa.ShowModal;
    if (Pesquisa.codP.ToInteger > 0) then
    begin
      RestRetPess := TComRest.create(URL_Pessoa+'/'+Pesquisa.codP);
      RestRetEnderInt := TComRest.create(URL_EnderecoIntegracao+'/'+Pesquisa.codEndInt);
      RestRetEnder := TComRest.create(URL_Endereco+'/'+Pesquisa.codEndInt);
      try
        RestRetPess.metodo := Consultar;
        jason := RestRetPess.executar;
        retorno := remover(jason.ToString, '[');
        retorno := remover(retorno,']');

        novoRegistro := False;
        codP := Pesquisa.codP;
        codEnder := Pesquisa.codEndInt;

        edNatureza.Text  := jason.GetValue('flnatureza').Value;
        edDocumento.Text := jason.GetValue('dsdocumento').Value;
        edPrimNome.Text  := jason.GetValue('nmprimeiro').Value;
        edSegNome.Text   := jason.GetValue('nmsegundo').Value;

        RestRetEnder.metodo := Consultar;
        jason := RestRetEnder.executar;
        retorno := remover(jason.ToString, '[');
        retorno := remover(retorno, ']');

        edCEP.Text := jason.GetValue('dscep').Value;


        RestRetEnderInt.metodo := Consultar;
        jason := RestRetEnderInt.executar;
        retorno := remover(jason.ToString, '[');
        retorno := remover(retorno,']');

        EdUF.Text := jason.GetValue('dsuf').Value;
        edCidade.Text := jason.GetValue('nmcidade').Value;
        edLogradouro.Text := jason.GetValue('nmlogradouro').Value;
        edComplemento.Text := jason.GetValue('dscomplemento').Value;

      finally
        FreeAndNil(RestRetPess);
        FreeAndNil(RestRetEnder);
        FreeAndNil(RestRetEnderInt);
      end;
    end;
  finally
    FreeAndNil(Pesquisa);
  end;
end;

procedure TFrPessoa.FormShow(Sender: TObject);
begin
  btNovoClick(nil);
end;

procedure TFrPessoa.btnDeleteClick(Sender: TObject);
var
  exclPes: TComRest;
begin
  if(Application.MessageBox('Deseja realmente excluir a pessoa?', 'Confirmação', MB_YESNO+MB_ICONQUESTION)=ID_YES)then
  begin
    exclPes := TComRest.create(URL_Pessoa+'/'+codP);
    try
      exclPes.metodo := Excluir;
      exclPes.executar;
    finally
      FreeAndNil(exclPes);
    end;
    btNovoClick(nil);
  end;
end;

procedure TFrPessoa.btnLoteClick(Sender: TObject);
var
  thread: TMinhaThread;
begin
  if OpenDialog1.Execute then
  begin
    thread := TMinhaThread.create;
    thread.pArquivo := OpenDialog1.FileName;
    thread.Start;
  end;
end;

procedure TFrPessoa.btGravarClick(Sender: TObject);
var
  JOPessoa, JOEnderecoIntegracao, JOEndereco: TJSONObject;
  newPess, newEnder: string;
  RestPess, RestEnderInt, RestEnder: TComRest;
begin
  if (edCEP.Text = EmptyStr) then
  begin
    Application.MessageBox('O campo CEP é obrigatório?', 'Cuidado', MB_OK+MB_ICONWARNING);
    edCEP.SetFocus;
    Exit;
  end;
  JOPessoa := TJSONObject.Create;
  JOEnderecoIntegracao := TJSONObject.Create;
  JOEndereco := TJSONObject.Create;

  JOPessoa.AddPair('flnatureza', edNatureza.Text);
  JOPessoa.AddPair('dsdocumento', edDocumento.Text);
  JOPessoa.AddPair('nmprimeiro', edPrimNome.Text);
  JOPessoa.AddPair('nmsegundo', edSegNome.Text);

  JOEndereco.AddPair('dscep', edCEP.Text);

  JOEnderecoIntegracao.AddPair('dsuf', EdUF.Text);
  JOEnderecoIntegracao.AddPair('nmcidade', edCidade.Text);
  JOEnderecoIntegracao.AddPair('nmlogradouro', edLogradouro.Text);
  JOEnderecoIntegracao.AddPair('dscomplemento', edComplemento.Text);

  RestPess := TComRest.create(URL_Pessoa);
  RestEnderInt := TComRest.create(URL_EnderecoIntegracao);
  RestEnder := TComRest.create(URL_Endereco);
  try
    if novoRegistro then
    begin
      RestPess.metodo := Inserir;
      RestEnderInt.metodo := Inserir;
      RestEnder.metodo := Inserir;
      //Persistindo pessoa
      JOPessoa.AddPair('idpessoa', '-1');
      RestPess.entrada := JOPessoa;
      RestPess.executar;
      RestPess.URL := URL_Pessoa+'Last';
      RestPess.metodo := Consultar;
      newPess := RestPess.executar.ToString;
      newPess := remover(newPess, '[');
      newPess := remover(newPess,']');
      newPess := remover(newPess,'{');
      newPess := remover(newPess,'}');
      newPess := remover(newPess,':');
      newPess := remover(newPess,'"result"');
      newPess := remover(newPess,'"NEW"');

      //Persistindo endereço
      JOEndereco.AddPair('idendereco', '-1');
      JOEndereco.AddPair('idpessoa', newPess);
      RestEnder.entrada := JOEndereco;
      RestEnder.executar;
      RestEnder.URL := URL_Endereco+'Last';
      RestEnder.metodo := Consultar;
      newEnder := remover(RestEnder.executar.ToString, '[');
      newEnder := remover(newEnder,']');
      newEnder := remover(newEnder,'{');
      newEnder := remover(newEnder,'}');
      newEnder := remover(newEnder,':');
      newEnder := remover(newEnder,'"result"');
      newEnder := remover(newEnder,'"NEW"');

      //Persistindo integração
      JOEnderecoIntegracao.AddPair('idendereco', newEnder);
      RestEnderInt.entrada := JOEnderecoIntegracao;
      RestEnderInt.executar;

      btNovoClick(NIL);
    end
    else
    begin
      RestPess.metodo := Alterar;
      RestPess.URL := URL_Pessoa+'/'+codP;
      RestEnderInt.metodo := Alterar;
      RestEnderInt.URL := URL_EnderecoIntegracao+'/'+codEnder;
      RestEnder.metodo := Alterar;
      RestEnder.URL := URL_Endereco+'/'+codEnder;

      RestPess.entrada := JOPessoa;
      RestPess.executar;

      JOEndereco.AddPair('idpessoa', codP);
      RestEnder.entrada := JOEndereco;
      RestEnder.executar;

      RestEnderInt.entrada := JOEnderecoIntegracao;
      RestEnderInt.executar;

    end;
  finally
    FreeAndNil(RestPess);
    FreeAndNil(RestEnder);
    FreeAndNil(RestEnderInt);
    if NOT novoRegistro then
    begin
      novoRegistro := False;
      codP := codP;
      codEnder := codEnder;
    end;
  end;
end;

end.
