unit UDMConexao;

interface

uses
  VCL.FORMS, System.IniFiles,
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TDmConexao = class(TDataModule)
    FdConexao: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmConexao: TDmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmConexao.DataModuleCreate(Sender: TObject);
Var
  IniFile  : String ;
  Ini     : TIniFile ;
  yy,mm,dd,hh,min,seg,mseg: word;
begin
  IniFile := ChangeFileExt( Application.ExeName, '.ini') ;
  Ini := TIniFile.Create( IniFile );
  try
    FdConexao.Connected := False;
    FdConexao.ConnectionName  := Ini.ReadString('CONEXAO','DATABASE', '') ;
    FdConexao.Params.Database := Ini.ReadString('CONEXAO','DATABASE', '') ;
    FdConexao.Params.DriverID := Ini.ReadString('CONEXAO','DRIVEID', '') ;
    FdConexao.Params.Password := Ini.ReadString('CONEXAO','SENHA', '') ;
    FdConexao.Params.UserName := Ini.ReadString('CONEXAO','USER', 'root') ;
    FdConexao.Params.Add('port='+Ini.ReadString('CONEXAO','PORTA', '3306'));
    FDPhysMySQLDriverLink1.VendorLib := '..\libmysql.dll';
  finally
     FreeAndNil(ini);
  end;
end;

end.
