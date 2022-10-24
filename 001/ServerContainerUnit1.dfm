object ServerContainer1: TServerContainer1
  OldCreateOrder = False
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    Left = 96
    Top = 11
  end
  object DSHTTPService1: TDSHTTPService
    HttpPort = 8080
    Server = DSServer1
    Filters = <>
    Left = 96
    Top = 135
  end
  object Pessoa: TDSServerClass
    OnGetClass = PessoaGetClass
    Server = DSServer1
    Left = 200
    Top = 11
  end
  object EnderecoIntegracao: TDSServerClass
    OnGetClass = EnderecoIntegracaoGetClass
    Server = DSServer1
    Left = 232
    Top = 83
  end
  object Endereco: TDSServerClass
    OnGetClass = EnderecoGetClass
    Server = DSServer1
    Left = 248
    Top = 187
  end
end
