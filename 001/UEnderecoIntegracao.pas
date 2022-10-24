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
    QyLast: TFDQuery;
    QyEnderecoIntegracaoidendereco: TLargeintField;
    QyEnderecoIntegracaodsuf: TStringField;
    QyEnderecoIntegracaonmcidade: TStringField;
    QyEnderecoIntegracaonmlogradouro: TStringField;
    QyEnderecoIntegracaodscomplemento: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function EnderecoIntegracao(idendereco: integer): TJSONValue; //GET
    function EnderecoIntegracaoLast: TJSONValue; //GET
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
    l := dados.GetValue('idendereco').Value;
    QyEnderecoIntegracao.SQL.Add('SELECT * FROM ENDERECO_INTEGRACAO WHERE IDENDERECO = '+L);
    QyEnderecoIntegracao.Open;
    QyEnderecoIntegracao.FromJSONObject(dados);
    QyEnderecoIntegracao.Edit;
    QyEnderecoIntegracaoidendereco.Value := l.ToInt64;
    VDmConexao.FdConexao.StartTransaction;
    try
      QyEnderecoIntegracao.ApplyUpdates();
      VDmConexao.FdConexao.Commit
    Except
      VDmConexao.FdConexao.Rollback;
    end;
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
    QyEnderecoIntegracao.SQL.Add('SELECT * FROM ENDERECO_INTEGRACAO WHERE IDENDERECO = :endereco');
    QyEnderecoIntegracao.ParamByName('endereco').AsInteger := idendereco;
    QyEnderecoIntegracao.Open;
    if not(QyEnderecoIntegracao.IsEmpty) then
    begin
      QyEnderecoIntegracao.Delete;
      VDmConexao.FdConexao.StartTransaction;
      try
        QyEnderecoIntegracao.ApplyUpdates();
        VDmConexao.FdConexao.Commit
      Except
        VDmConexao.FdConexao.Rollback;
      end;
    end;
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

function TWsEnderecoIntegracao.EnderecoIntegracaoLast: TJSONValue;
var
  VDmConexao: TDmConexao;
  l: string;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyLast.Close;
    QyLast.Open;
    Result := QyLast.AsJSONArray;
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
    QyEnderecoIntegracao.SQL.Add('SELECT * FROM ENDERECO_INTEGRACAO WHERE IDENDERECO = :endereco');
    QyEnderecoIntegracao.ParamByName('endereco').AsInteger := idendereco;
    QyEnderecoIntegracao.Open;
    QyEnderecoIntegracao.RecordFromJSONObject(dados);
    VDmConexao.FdConexao.StartTransaction;
    try
      QyEnderecoIntegracao.ApplyUpdates();
      VDmConexao.FdConexao.Commit
    Except
      VDmConexao.FdConexao.Rollback;
    end;
    Result := QyEnderecoIntegracao.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

end.
