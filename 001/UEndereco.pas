unit UEndereco;

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
  TWsEndereco = class(TDSServerModule)
    QyEndereco: TFDQuery;
    FDUpdateSQL: TFDUpdateSQL;
    QyEnderecoidpessoa: TLargeintField;
    QyEnderecoflnatureza: TIntegerField;
    QyEnderecodsdocumento: TStringField;
    QyEndereconmprimeiro: TStringField;
    QyEndereconmsegundo: TStringField;
    QyEnderecodtregistro: TDateField;
    QyLast: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function Endereco(idendereco: integer): TJSONValue; ///GET
    function acceptEndereco(dados: TJSONObject): TJSONValue; //PUT
    function updateEndereco(idendereco: integer; dados: TJSONObject): TJSONValue;//POST
    function cancelEndereco(idendereco: integer): TJSONValue;//DELETE
  end;

var
  WsEndereco: TWsEndereco;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UDMConexao, DataSetConverter4D.Helper;

{$R *.dfm}

{ TWsPessoa }

function TWsEndereco.acceptEndereco(dados: TJSONObject): TJSONValue;
var
  VDmConexao: TDmConexao;
  l: string;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyEndereco.Connection := VDmConexao.FdConexao;
    QyEndereco.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyEndereco.Connection;
    QyEndereco.Close;
    QyEndereco.SQL.Clear;
    QyLast.Close;
    QyLast.Open;
    L := (QyLast.FieldByName('NEW').AsInteger+1).ToString;
    QyEndereco.SQL.Add('SELECT * FROM ENDERECO WHERE IDENDERECO = -1');
    QyEndereco.Open;
    QyEndereco.FromJSONObject(dados);
    QyEndereco.Edit;
    QyEnderecoidpessoa.Value := l.ToInt64;
    QyEndereco.ApplyUpdates();
    Result := QyEndereco.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsEndereco.cancelEndereco(idendereco: integer): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyEndereco.Connection := VDmConexao.FdConexao;
    QyEndereco.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyEndereco.Connection;
    QyEndereco.Close;
    QyEndereco.SQL.Clear;
    QyEndereco.SQL.Add('SELECT * FROM ENDERECO');
    QyEndereco.SQL.Add(' WHERE IDENDERECO = :idendereco');
    QyEndereco.ParamByName('idendereco').AsInteger := idendereco;
    QyEndereco.Open;
    QyEndereco.Delete;
    QyEndereco.ApplyUpdates();
    Result := QyEndereco.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsEndereco.Endereco(idendereco: integer): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyEndereco.Connection := VDmConexao.FdConexao;
    QyEndereco.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    QyEndereco.Close;
    QyEndereco.SQL.Clear;
    QyEndereco.SQL.Add('SELECT * FROM ENDERECO');
    if idendereco > 0 then
    begin
      QyEndereco.SQL.Add(' WHERE IDENDERECO = :cd');
      QyEndereco.ParamByName('cd').AsInteger := idendereco;
    end;
    QyEndereco.SQL.Add('ORDER BY dscep');
    QyEndereco.Open;
    Result := QyEndereco.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsEndereco.updateEndereco(idendereco: integer;
  dados: TJSONObject): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyEndereco.Connection := VDmConexao.FdConexao;
    QyEndereco.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyEndereco.Connection;
    QyEndereco.Close;
    QyEndereco.SQL.Clear;
    QyEndereco.SQL.Add('SELECT * FROM PESSOA');
    QyEndereco.SQL.Add(' WHERE IDPESSOA = :pessoa');
    QyEndereco.ParamByName('pessoa').AsInteger := idendereco;
    QyEndereco.Open;
    QyEndereco.RecordFromJSONObject(dados);
    QyEndereco.ApplyUpdates();
    Result := QyEndereco.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

end.
