unit UThread;

interface

uses
  System.Classes, System.JSON, System.SysUtils, vcl.forms, Winapi.Windows;

type
  TMinhaThread = class(TThread)
  private
    { Private declarations }
    arquivo: string;
    JOPessoa, JOEnderecoIntegracao, JOEndereco: TJSONObject;

    procedure lerArquivo;
    function gravaPessoa(pessoa: TJSONObject):string;
    function gravaEndereco(endereco: TJSONObject; pessoa: string):string;
    function gravaEnderecoIntegracao(enderecoIntegracao: TJSONObject; endereco: string):string;
  protected
    procedure Execute; override;
  public
    property pArquivo: string read arquivo write arquivo;
    procedure sincronizar;
    constructor create;reintroduce;
  end;

implementation

uses clConex, UCadPessoa;

ResourceString
  URL_Pessoa = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa';
  URL_EnderecoIntegracao = 'http://127.0.0.1:8080/datasnap/rest/TWsEnderecoIntegracao/EnderecoIntegracao';
  URL_Endereco = 'http://127.0.0.1:8080/datasnap/rest/TWsEndereco/Endereco';

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure MinhaThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ TMinhaThread }


constructor TMinhaThread.create;
begin
  inherited Create(True);
  self.FreeOnTerminate := True;
end;

procedure TMinhaThread.Execute;
begin
  { Place thread code here }
  lerArquivo
end;

function TMinhaThread.gravaEndereco(endereco: TJSONObject; pessoa: string):string;
var
  RestEnder: TComRest;
  newEnder: string;
begin
  RestEnder := TComRest.create(URL_Endereco);
  try
    endereco.AddPair('idendereco', '-1');
    endereco.AddPair('idpessoa', pessoa);
    RestEnder.metodo := Inserir;
    RestEnder.entrada := endereco;
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
    Result := newEnder
  finally
    FreeAndNil(RestEnder);
  end;
end;

function TMinhaThread.gravaEnderecoIntegracao(
  enderecoIntegracao: TJSONObject; endereco: string):string;
var
  RestEnderInt: TComRest;
  newEnder: string;
begin
  RestEnderInt := TComRest.create(URL_EnderecoIntegracao);
  try
    enderecoIntegracao.AddPair('idendereco', endereco);
    RestEnderInt.metodo := Inserir;
    RestEnderInt.entrada := enderecoIntegracao;
    RestEnderInt.executar;
  finally
    FreeAndNil(RestEnderInt);
  end;
end;

function TMinhaThread.gravaPessoa(pessoa: TJSONObject): string;
var
  RestPess: TComRest;
  newPess: string;
begin
  RestPess := TComRest.create(URL_Pessoa);
  try
     RestPess.metodo := Inserir;
     pessoa.AddPair('idpessoa', '-1');
     RestPess.entrada := pessoa;
     RestPess.executar;
     RestPess.URL := URL_Pessoa+'Last';
     RestPess.metodo := Consultar;
     newPess := RestPess.executar.ToString;
     newPess := clConex.remover(newPess, '[');
     newPess := remover(newPess,']');
     newPess := remover(newPess,'{');
     newPess := remover(newPess,'}');
     newPess := remover(newPess,':');
     newPess := remover(newPess,'"result"');
     newPess := remover(newPess,'"NEW"');
     Result := newPess
  finally
    FreeAndNil(RestPess);
  end;
end;


procedure TMinhaThread.lerArquivo;
var
  Linhas, Colunas:TStringList;
  i,j: integer;
  Linha, cdPess, cdEnder: String;
  hri, hrf: TDateTime;
begin
  hri := Now;
  Linhas := TStringList.Create;
  Colunas := TStringList.Create;
  try
    Linhas.LoadFromFile(arquivo);
    FrPessoa.ProgressBar1.Max := Pred(Linhas.Count);
    for i := 1 to Pred(Linhas.Count) do
    begin
      Colunas.text := StringReplace(Linhas.Strings[i],';',#13,[rfReplaceAll]);
      JOPessoa := TJSONObject.Create;
      JOEndereco:= TJSONObject.Create;
      JOEnderecoIntegracao := TJSONObject.Create;

      JOPessoa.AddPair('flnatureza', Colunas.Strings[0]);
      JOPessoa.AddPair('dsdocumento',Colunas.Strings[1]);
      JOPessoa.AddPair('nmprimeiro', Colunas.Strings[2]);
      JOPessoa.AddPair('nmsegundo', Colunas.Strings[3]);

      JOEndereco.AddPair('dscep', Colunas.Strings[4]);

      JOEnderecoIntegracao.AddPair('dsuf', Colunas.Strings[5]);
      JOEnderecoIntegracao.AddPair('nmcidade', Colunas.Strings[6]);
      JOEnderecoIntegracao.AddPair('nmlogradouro', Colunas.Strings[7]);
      JOEnderecoIntegracao.AddPair('dscomplemento', Colunas.Strings[8]);

      Synchronize(sincronizar);
      FrPessoa.ProgressBar1.Position := FrPessoa.ProgressBar1.Position + 1;
    end;
  finally
    Linhas.Free;
    Colunas.Free;
  end;
  hrf := now;
  Application.MessageBox(pchar('Finalizada gravação em lote dos dados! Tempo de execução:'+TimeToStr(hrf-hri)), 'Aviso', MB_OK+MB_ICONINFORMATION);
  FrPessoa.ProgressBar1.Position := 0;
end;

procedure TMinhaThread.sincronizar;
var
  cdPess, cdEnder: String;
begin
  cdPess := gravaPessoa(JOPessoa);
  cdEnder:= gravaEndereco(JOEndereco, cdPess);
  gravaEnderecoIntegracao(JOEnderecoIntegracao, cdEnder);
end;

end.
