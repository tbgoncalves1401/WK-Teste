object DmConexao: TDmConexao
  OldCreateOrder = False
  Height = 150
  Width = 215
  object FdConexao: TFDConnection
    ConnectionName = 'WK'
    Params.Strings = (
      'Database=wk'
      'User_Name=root'
      'Password=bluegreen'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 71
    Top = 16
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'D:\BlueGreen\Fontes\WK\001\Win32\Debug\libmysql.dll'
    Left = 40
    Top = 80
  end
end