unit UEnderecoIntegracao;

interface

uses
System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TWsEnderecoIntegracao = class(TDSServerModule)
    QyEnderecoIntegracao: TFDQuery;
    FDUpdateSQL: TFDUpdateSQL;
    QyEnderecoIntegracaoidpessoa: TLargeintField;
    QyEnderecoIntegracaoflnatureza: TIntegerField;
    QyEnderecoIntegracaodsdocumento: TStringField;
    QyEnderecoIntegracaonmprimeiro: TStringField;
    QyEnderecoIntegracaonmsegundo: TStringField;
    QyEnderecoIntegracaodtregistro: TDateField;
    QyLast: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function EnderecoIntegracao(idendereco: integer): TJSONValue; ///GET
    function acceptEnderecoIntegracao(dados: TJSONObject): TJSONValue; //PUT
    function updateEnderecoIntegracao(idendereco: integer; dados: TJSONObject): TJSONValue;//POST
    function cancelEnderecoIntegracao(idendereco: integer): TJSONValue;//DELETE
  end;

var
  WsEnderecoIntegracao: TWsEnderecoIntegracao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UDMConexao, DataSetConverter4D.Helper;

{$R *.dfm}

{ TWsPessoa }

function TWsEnderecoIntegracao.acceptEnderecoIntegracao(dados: TJSONObject): TJSONValue;
var
  VDmConexao: TDmConexao;
  l: string;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyEnderecoIntegracao.Connection := VDmConexao.FdConexao;
    QyEnderecoIntegracao.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyEnderecoIntegracao.Connection;
    QyEnderecoIntegracao.Close;
    QyEnderecoIntegracao.SQL.Clear;
    QyLast.Close;
    QyLast.Open;
    L := (QyLast.FieldByName('NEW').AsInteger+1).ToString;
    QyEnderecoIntegracao.SQL.Add('SELECT * FROM ENDERECO_INTEGRACAO WHERE IDENDERECO = '+L);
    QyEnderecoIntegracao.Open;
    QyEnderecoIntegracao.FromJSONObject(dados);
    QyEnderecoIntegracao.Edit;
    QyEnderecoIntegracaoidpessoa.Value := l.ToInt64;
    QyEnderecoIntegracao.ApplyUpdates();
    Result := QyEnderecoIntegracao.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsEnderecoIntegracao.cancelEnderecoIntegracao(idendereco: integer): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyEnderecoIntegracao.Connection := VDmConexao.FdConexao;
    QyEnderecoIntegracao.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyEnderecoIntegracao.Connection;
    QyEnderecoIntegracao.Close;
    QyEnderecoIntegracao.SQL.Clear;
    QyEnderecoIntegracao.SQL.Add('SELECT * FROM ENDERECO_INTEGRACAO');
    QyEnderecoIntegracao.SQL.Add(' WHERE IDENDERECO = :endereco');
    QyEnderecoIntegracao.ParamByName('endereco').AsInteger := idendereco;
    QyEnderecoIntegracao.Open;
    QyEnderecoIntegracao.Delete;
    QyEnderecoIntegracao.ApplyUpdates();
    Result := QyEnderecoIntegracao.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsEnderecoIntegracao.EnderecoIntegracao(idendereco: integer): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyEnderecoIntegracao.Connection := VDmConexao.FdConexao;
    QyEnderecoIntegracao.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    QyEnderecoIntegracao.Close;
    QyEnderecoIntegracao.SQL.Clear;
    QyEnderecoIntegracao.SQL.Add('SELECT * FROM ENDERECO_INTEGRACAO');
    if idendereco > 0 then
    begin
      QyEnderecoIntegracao.SQL.Add(' WHERE IDENDERECO = :cd');
      QyEnderecoIntegracao.ParamByName('cd').AsInteger := idendereco;
    end;
    QyEnderecoIntegracao.SQL.Add('ORDER BY nmcidade');
    QyEnderecoIntegracao.Open;
    Result := QyEnderecoIntegracao.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsEnderecoIntegracao.updateEnderecoIntegracao(idendereco: integer;
  dados: TJSONObject): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyEnderecoIntegracao.Connection := VDmConexao.FdConexao;
    QyEnderecoIntegracao.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyEnderecoIntegracao.Connection;
    QyEnderecoIntegracao.Close;
    QyEnderecoIntegracao.SQL.Clear;
    QyEnderecoIntegracao.SQL.Add('SELECT * FROM ENDERECO_INTEGRACAO');
    QyEnderecoIntegracao.SQL.Add(' WHERE IDENDERECO = :endereco');
    QyEnderecoIntegracao.ParamByName('endereco').AsInteger := idendereco;
    QyEnderecoIntegracao.Open;
    QyEnderecoIntegracao.RecordFromJSONObject(dados);
    QyEnderecoIntegracao.ApplyUpdates();
    Result := QyEnderecoIntegracao.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

end.