unit UPesquisaPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, Vcl.StdCtrls, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.ExtCtrls, System.JSON,
  Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids;

type
  TfrPesquisa = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    EdPesquisa: TEdit;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    btnPesquisar: TButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure btnPesquisarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure JsonToDataset(aDataset : TDataSet; aJSON : string);
  public
    { Public declarations }
    codP, codEndInt : string;
  end;

var
  frPesquisa: TfrPesquisa;

implementation

uses
  System.JSON.Readers, REST.Response.Adapter;

resourcestring
  URL = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa';

{$R *.dfm}

procedure TfrPesquisa.btnPesquisarClick(Sender: TObject);
var
  retorno: string;
begin
  RESTClient1.BaseURL := URL+'/'+EdPesquisa.Text;
  RESTRequest1.Execute;
  retorno := RESTRequest1.Response.JSONText;
  Delete(retorno, pos('[', retorno), 1);
  Delete(retorno, pos(']', retorno), 1);
  JsonToDataset(ClientDataSet1, retorno);
end;

procedure TfrPesquisa.DBGrid1DblClick(Sender: TObject);
begin
  if(ClientDataSet1.Active)and(ClientDataSet1.RecordCount >= 1) then
  begin
    codP      := ClientDataSet1.FindField('idpessoa').AsString;
    codEndInt := ClientDataSet1.FindField('idendereco').AsString;
  end;
  Close;
end;

procedure TfrPesquisa.FormShow(Sender: TObject);
begin
  codP := '0';
  codEndInt := '0';
end;

procedure TfrPesquisa.JsonToDataset(aDataset: TDataSet; aJSON: string);
var
  JObj: TJSONArray;
  vConv : TCustomJSONDataSetAdapter;
begin
  if (aJSON = EmptyStr) then
  begin
    Exit;
  end;

  JObj := TJSONObject.ParseJSONValue(aJSON) as TJSONArray;
  vConv := TCustomJSONDataSetAdapter.Create(Nil);

  try
    vConv.Dataset := aDataset;
    vConv.UpdateDataSet(JObj);
  finally
    vConv.Free;
    JObj.Free;
  end;
end;

end.
