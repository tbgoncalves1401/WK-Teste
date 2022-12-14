unit UPessoa;

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
  TWsPessoa = class(TDSServerModule)
    QyPessoa: TFDQuery;
    FDUpdateSQL: TFDUpdateSQL;
    QyPessoaidpessoa: TLargeintField;
    QyPessoaflnatureza: TIntegerField;
    QyPessoadsdocumento: TStringField;
    QyPessoanmprimeiro: TStringField;
    QyPessoanmsegundo: TStringField;
    QyPessoadtregistro: TDateField;
    QyLast: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function Pessoa(idpessoa: integer): TJSONValue; //GET
    function PessoaLast: TJSONValue; //GET
    function acceptPessoa(dados: TJSONObject): TJSONValue; //PUT
    function updatePessoa(idpessoa: integer; dados: TJSONObject): TJSONValue;//POST
    function cancelPessoa(idpessoa: integer): TJSONValue;//DELETE
  end;

var
  WsPessoa: TWsPessoa;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UDMConexao, DataSetConverter4D.Helper;

{$R *.dfm}

{ TWsPessoa }

function TWsPessoa.acceptPessoa(dados: TJSONObject): TJSONValue;
var
  VDmConexao: TDmConexao;
  l: string;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyPessoa.Connection := VDmConexao.FdConexao;
    QyPessoa.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyPessoa.Connection;
    QyPessoa.Close;
    QyPessoa.SQL.Clear;
    QyLast.Close;
    QyLast.Open;
    L := (QyLast.FieldByName('NEW').AsInteger+1).ToString;
    QyPessoa.SQL.Add('SELECT * FROM PESSOA WHERE IDPESSOA = '+l);
    QyPessoa.Open;
    QyPessoa.FromJSONObject(dados);
    QyPessoa.Edit;
    QyPessoaidpessoa.Value := l.ToInt64;
    VDmConexao.FdConexao.StartTransaction;
    try
      QyPessoa.ApplyUpdates();
      VDmConexao.FdConexao.Commit
    Except
      VDmConexao.FdConexao.Rollback;
    end;
    Result := QyPessoa.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsPessoa.cancelPessoa(idpessoa: integer): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyPessoa.Connection := VDmConexao.FdConexao;
    QyPessoa.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyPessoa.Connection;
    QyPessoa.Close;
    QyPessoa.SQL.Clear;
    QyPessoa.SQL.Add('SELECT * FROM PESSOA WHERE IDPESSOA = :pessoa');
    QyPessoa.ParamByName('pessoa').AsInteger := idpessoa;
    QyPessoa.Open;
    if not(QyPessoa.IsEmpty) then
    begin
      QyPessoa.Delete;
      VDmConexao.FdConexao.StartTransaction;
      try
        QyPessoa.ApplyUpdates();
        VDmConexao.FdConexao.Commit
      Except
        VDmConexao.FdConexao.Rollback;
      end;
    end;
    Result := QyPessoa.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsPessoa.Pessoa(idpessoa: integer): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyPessoa.Connection := VDmConexao.FdConexao;
    QyPessoa.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    QyPessoa.Close;
    QyPessoa.SQL.Clear;
    QyPessoa.SQL.Add('SELECT PES.*, integ.idendereco FROM PESSOA PES '+
                     'left join endereco ender on ender.idpessoa = pes.idpessoa '+
                     'left join endereco_integracao integ on integ.idendereco = ender.idendereco ');
    if idpessoa > 0 then
    begin
      QyPessoa.SQL.Add(' WHERE PES.IDPESSOA = :cd');
      QyPessoa.ParamByName('cd').AsInteger := idpessoa;
    end;
    QyPessoa.SQL.Add('ORDER BY nmprimeiro');
    QyPessoa.Open;
    Result := QyPessoa.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

function TWsPessoa.PessoaLast: TJSONValue;
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

function TWsPessoa.updatePessoa(idpessoa: integer;
  dados: TJSONObject): TJSONValue;
var
  VDmConexao: TDmConexao;
begin
  VDmConexao := TDmConexao.Create(nil);
  try
    VDmConexao.FdConexao.Connected := True;
    QyPessoa.Connection := VDmConexao.FdConexao;
    QyPessoa.ConnectionName := VDmConexao.FdConexao.ConnectionName;
    FDUpdateSQL.Connection := QyPessoa.Connection;
    QyPessoa.Close;
    QyPessoa.SQL.Clear;
    QyPessoa.SQL.Add('SELECT * FROM PESSOA WHERE IDPESSOA = :pessoa');
    QyPessoa.ParamByName('pessoa').AsInteger := idpessoa;
    QyPessoa.Open;
    QyPessoa.RecordFromJSONObject(dados);
    VDmConexao.FdConexao.StartTransaction;
    try
      QyPessoa.ApplyUpdates();
      VDmConexao.FdConexao.Commit
    Except
      VDmConexao.FdConexao.Rollback;
    end;
    Result := QyPessoa.AsJSONArray;
  finally
    FreeAndNil(VDmConexao);
  end;
end;

end.
