unit clConex;

interface

uses
  REST.Client, REST.Types, System.JSON;


type
  TtipoExecucao = (Consultar, Inserir, Alterar, Excluir);

  TComRest = class
    private
      jason, entradaV :TJSONObject;
      execucao: TtipoExecucao;
      Rest: TRESTClient;
      Response: TRESTResponse;
      Request: TRESTRequest;
      URL_V: string;

      property Presultado: TJSONObject read jason;

    public
      property metodo: TtipoExecucao read execucao write execucao;
      property entrada: TJSONObject read entradaV write entradaV;
      property URL: string read URL_V write URL_V;
      constructor create(url: string);
      function executar():TJSONObject;
  end;
  function remover(valor: string; remove:string):string;

implementation

{ TComRest }

resourcestring
  accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  charset = 'UTF-8, *;q=0.8';
  ContentType = 'application/json';


constructor TComRest.create(url: string);
begin
  Rest     := TRESTClient.Create(url);
  Response := TRESTResponse.Create(Nil);
  Request  := TRESTRequest.Create(Nil);
  URL_V    := url;
  with Rest do
  begin
    Accept := accept;
    AcceptCharset := charset;
    AcceptEncoding := '';
    AllowCookies := True;
    Authenticator := nil;
    AutoCreateParams := True;
    BindSource.AutoActivate := True;
    BindSource.AutoEdit := True;
    BindSource.AutoPost := True;
    ContentType := '';
    FallbackCharsetEncoding := 'UTF-8';
    HandleRedirects := True;
    IPImplementationID := '';
    Params.Clear;
    ProxyPassword := '';
    ProxyPort := 0;
    ProxyServer := '';
    ProxyUsername := '';
    RaiseExceptionOn500 := False;
    SynchronizedEvents := True;
    UserAgent := 'Embarcadero RESTClient/1.0';
  end;

  with Response do
  begin
    ContentEncoding := '';
    ContentType := '';
    BindSource.AutoActivate := True;
    BindSource.AutoEdit := True;
    BindSource.AutoPost := True;
  end;

  with Request do
  begin
    Accept := accept;
    AcceptCharset := charset;
    AcceptEncoding := '';
    AutoCreateParams := True;
    BindSource.AutoActivate := True;
    BindSource.AutoEdit := True;
    BindSource.AutoPost := True;
    Client := Rest;
    HandleRedirects := True;
    Params.Clear;
    Resource := '';
    ResourceSuffix := '';
    Response := Response;
    SynchronizedEvents := False;
    Timeout := 30000;
  end;
end;

function TComRest.executar: TJSONObject;
var
  str: string;
begin
  Rest.BaseURL  := URL_V;
  case execucao of
    Consultar: begin
                 Request.Method := rmGET;
    end;
    Inserir  : begin
                Rest.Accept := accept;
                Rest.AcceptCharset := charset;
                Rest.ContentType := ContentType;
                Rest.RaiseExceptionOn500 := False;

                Response.ContentType := 'text/html';
                Response.RootElement := 'result';

                Request.AcceptCharset := charset;
                Request.Method := rmPUT;
                with Request.Params.AddItem do
                begin
                  ContentType := ctAPPLICATION_JSON;
                  Kind := pkREQUESTBODY;
                  name := 'body';
                end;
                Request.Body.Add(entradaV.ToString);
    end;
    Alterar  : begin
                Rest.Accept := accept;
                Rest.AcceptCharset := charset;
                Rest.ContentType := ContentType;
                Rest.RaiseExceptionOn500 := False;

                Response.ContentType := 'text/html';
                Response.RootElement := 'result';

                Request.AcceptCharset := charset;
                Request.Method := rmPOST;
                with Request.Params.AddItem do
                begin
                  ContentType := ctAPPLICATION_JSON;
                  Kind := pkREQUESTBODY;
                  name := 'body';
                end;
                Request.Body.Add(entradaV.ToString);
    end;
    Excluir  : begin
                Rest.Accept := accept;
                Rest.AcceptCharset := charset;
                Rest.ContentType := ContentType;
                Rest.RaiseExceptionOn500 := False;

                Response.ContentType := 'text/html';
                Response.RootElement := 'result';

                Request.Method := rmDELETE;
                with Request.Params.AddItem do
                begin
                  ContentType := ctAPPLICATION_JSON;
                  Kind := pkREQUESTBODY;
                  name := 'body';
                end;
    end;
  end;
  Request.Execute;
  jason := TJSONObject.ParseJSONValue( Request.Response.JSONText ) as TJSONObject;
  str := jason.ToString;
  if (execucao = Consultar)and(pos('result', str)>0)and(pos('null', str)=0) then
  begin
    Delete(str, 1, 1);
    Delete(str, pos('result', str), 6);
    Delete(str, pos(':', str) , 1);
    Delete(str, pos('[', str), 1);
    Delete(str, pos(']', str), 1);
    Delete(str, pos('[', str), 1);
    Delete(str, pos(']', str), 1);
    Delete(str, length(str)  , 1);
    Delete(str, 1, 2);
    jason := TJsonObject.ParseJSONValue(str) as TJsonObject;
  end;
  Result := jason
end;

function remover(valor: string; remove:string):string;
var
  retorno: string;
begin
  retorno := valor;
  while pos(remove, retorno)>0 do
    Delete(retorno, pos(remove, retorno), length(remove));
  Result := retorno;
end;

end.
