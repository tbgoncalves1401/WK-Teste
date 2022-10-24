unit UPesquisaPessoa;

interface

uses
  Winapi.Windows, Vcl.Forms, System.JSON, System.SysUtils,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Controls, System.Classes, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TfrPesquisa = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    EdPesquisa: TEdit;
    btnPesquisar: TButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure btnPesquisarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    codP, codEndInt : string;
  end;

var
  frPesquisa: TfrPesquisa;

implementation

uses
  System.JSON.Readers, clConex,  DataSetConverter4D.Helper;

resourcestring
  URL = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa';
  URL_Endereco = 'http://127.0.0.1:8080/datasnap/rest/TWsEndereco/Endereco';

{$R *.dfm}

procedure TfrPesquisa.btnPesquisarClick(Sender: TObject);
var
  pesquisa: TComRest;
  obj: TJSONObject;
  i: Integer;
begin
  if (EdPesquisa.Text <> '')and(StrToInt(EdPesquisa.Text)>0) then
  begin
    pesquisa := TComRest.create(URL+'/'+EdPesquisa.Text);
    try
      obj := pesquisa.executar;
      if pos('null', obj.ToString)>0 then
      begin
        if ClientDataSet1.Active then
          ClientDataSet1.EmptyDataSet;
        Application.MessageBox('Pessoa não encontrada na base de dados', 'Informação', MB_OK+MB_ICONINFORMATION)
      end
      else
      begin
        ClientDataSet1.Close;
        ClientDataSet1.FieldDefs.Clear; //Limpa os Campos Existentes

        for i := 0 to Pred(Obj.Size) do
        begin
          if (Length(Obj.Get(i).JsonValue.Value) > 250) then
          begin
            ClientDataSet1.FieldDefs.Add(Obj.Get(i).JsonString.Value, ftBlob);
          end
          else
          begin
            ClientDataSet1.FieldDefs.Add(Obj.Get(i).JsonString.Value, ftString, 255);
          end;
        end;
        ClientDataSet1.CreateDataSet;
        ClientDataSet1.FromJSONObject(obj);
      end;
    finally
      FreeAndNil(pesquisa);
    end;
  end
  else
  begin
    EdPesquisa.SetFocus;
    Application.MessageBox('Favor informar alguma informação para ser pesquisada.', 'Perigo', MB_OK+MB_ICONWARNING);
  end;
end;

procedure TfrPesquisa.DBGrid1DblClick(Sender: TObject);
var
  ender: TComRest;
  obj: TJSONObject;
begin
  if(ClientDataSet1.Active)and(ClientDataSet1.RecordCount >= 1) then
  begin
    codP        := ClientDataSet1.FindField('idpessoa').AsString;
    ender       := TComRest.create(URL_Endereco+'P/'+codP);
    try
      ender.metodo := Consultar;
      obj := ender.executar;
      codEndInt := obj.GetValue('idendereco').Value;
    finally
      FreeAndNil(ender);
    end;
  end;
  Close;
end;

procedure TfrPesquisa.FormShow(Sender: TObject);
begin
  codP := '0';
  codEndInt := '0';
end;


end.
