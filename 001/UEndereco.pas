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
    QyLast: TFDQuery;
    QyEnderecoidendereco: TLargeintField;
    QyEnderecoidpessoa: TLargeintField;
    QyEnderecodscep: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Endereco(idendereco: integer): TJSONValue; //GET
    function EnderecoLast: TJSONValue; //GET
    function EnderecoP(idpessoa: string): TJSONValue; ///GET
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
    QyEndereco.SQL.Add('SELECT * FROM ENDERECO WHERE IDENDERECO = '+l);
    QyEndereco.Open;
    QyEndereco.FromJSONObject(dados);
    QyEndereco.Edit;
    QyEnderecoidendereco.Value := l.ToInt64;
    VDmConexao.FdConexao.StartTransaction;
    try
      QyEndereco.ApplyUpdates();
      VDmConexao.FdConexao.Commit
    Except
      VDmConexao.FdConexao.Rollback;
    end;
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
    QyEndereco.SQL.Add('SELECT * FROM ENDERECO WHERE IDENDERECO = :idendereco');
    QyEndereco.ParamByName('idendereco').AsInteger := idendereco;
    QyEndereco.Open;
    if not(QyEndereco.IsEmpty) then
    begin
      QyEndereco.Delete;
      VDmConexao.FdConexao.StartTransaction;
      try
        QyEndereco.ApplyUpdates();
        VDmConexao.FdConexao.Commit
      Except
        VDmConexao.FdConexao.Rollback;
      end;
    end;
    Result := QyEndereco.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsEndereco.EnderecoP(idpessoa: string): TJSONValue;
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
    QyEndereco.SQL.Add('SELECT * FROM ENDERECO WHERE IDPESSOA= :cd ORDER BY dscep');
    QyEndereco.ParamByName('cd').AsInteger := idpessoa.ToInteger;
    QyEndereco.Open;
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

function TWsEndereco.EnderecoLast: TJSONValue;
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
    QyEndereco.SQL.Add('SELECT * FROM ENDERECO WHERE IDENDERECO = :endereco');
    QyEndereco.ParamByName('endereco').AsInteger := idendereco;
    QyEndereco.Open;
    QyEndereco.RecordFromJSONObject(dados);
    VDmConexao.FdConexao.StartTransaction;
    try
      QyEndereco.ApplyUpdates();
      VDmConexao.FdConexao.Commit
    Except
      VDmConexao.FdConexao.Rollback;
    end;
    Result := QyEndereco.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

end.
