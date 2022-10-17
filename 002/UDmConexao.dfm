object DmConexao: TDmConexao
  OldCreateOrder = False
  Height = 392
  Width = 662
  object RESTClientCEP: TRESTClient
    BaseURL = 'http://viacep.com.br/ws'
    Params = <>
    HandleRedirects = True
    Left = 32
    Top = 16
  end
  object RESTRequestCEP: TRESTRequest
    Client = RESTClientCEP
    Params = <>
    Response = RESTResponseCEP
    SynchronizedEvents = False
    Left = 158
    Top = 16
  end
  object RESTResponseCEP: TRESTResponse
    Left = 96
    Top = 16
  end
  object RESTClientPUT: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa'
    ContentType = 'application/json'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 32
    Top = 72
  end
  object RESTRequestPUT: TRESTRequest
    Client = RESTClientPUT
    Method = rmPUT
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponsePUT
    SynchronizedEvents = False
    Left = 96
    Top = 72
  end
  object RESTResponsePUT: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 158
    Top = 72
  end
  object RESTClientPOST: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa'
    ContentType = 'application/json'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 32
    Top = 128
  end
  object RESTRequestPOST: TRESTRequest
    Client = RESTClientPOST
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponsePOST
    SynchronizedEvents = False
    Left = 96
    Top = 128
  end
  object RESTResponsePOST: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 158
    Top = 128
  end
  object RESTClientDELETE: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa/2'
    ContentType = 'application/json'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 32
    Top = 176
  end
  object RESTRequestDELETE: TRESTRequest
    Client = RESTClientDELETE
    Method = rmDELETE
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponseDELETE
    SynchronizedEvents = False
    Left = 96
    Top = 176
  end
  object RESTResponseDELETE: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 158
    Top = 176
  end
  object RESTClientPUTEndereco_INTEGRACAO: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 
      'http://127.0.0.1:8080/datasnap/rest/TWsEnderecoIntegracao/Endere' +
      'coIntegracao'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 376
    Top = 9
  end
  object RESTRequestPUTEnderecoIntegracao: TRESTRequest
    Client = RESTClientPUTEndereco_INTEGRACAO
    Method = rmPUT
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponsePUTEnderecoIntegracao
    SynchronizedEvents = False
    Left = 440
    Top = 9
  end
  object RESTResponsePUTEnderecoIntegracao: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 520
    Top = 9
  end
  object RESTEnderecoIntegracaoPOST: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 
      'http://127.0.0.1:8080/datasnap/rest/TWsEnderecoIntegracao/Endere' +
      'coIntegracao'
    ContentType = 'application/json'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 384
    Top = 57
  end
  object RESTRequestEnderecoIntegracaoPOST: TRESTRequest
    Client = RESTEnderecoIntegracaoPOST
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponseEnderecoIntegracaoPOST
    SynchronizedEvents = False
    Left = 440
    Top = 57
  end
  object RESTResponseEnderecoIntegracaoPOST: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 502
    Top = 57
  end
  object RESTClientEnderecoIntegracaoDelete: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa/2'
    ContentType = 'application/json'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 376
    Top = 113
  end
  object RESTRequestEnderecoIntegracaoDelete: TRESTRequest
    Client = RESTClientEnderecoIntegracaoDelete
    Method = rmDELETE
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponseEnderecoIntegracaoDelete
    SynchronizedEvents = False
    Left = 440
    Top = 113
  end
  object RESTResponseEnderecoIntegracaoDelete: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 502
    Top = 113
  end
  object RESTClientPUTEndereco: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://127.0.0.1:8080/datasnap/rest/TWsEndereco/Endereco'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 376
    Top = 169
  end
  object RESTRequestPUTEndereco: TRESTRequest
    Client = RESTClientPUTEndereco
    Method = rmPUT
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponsePUTEndereco
    SynchronizedEvents = False
    Left = 440
    Top = 169
  end
  object RESTResponsePUTEndereco: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 520
    Top = 169
  end
  object RESTEnderecoPOST: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://127.0.0.1:8080/datasnap/rest/TWsEndereco/Endereco'
    ContentType = 'application/json'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 376
    Top = 217
  end
  object RESTRequestEnderecoPOST: TRESTRequest
    Client = RESTEnderecoPOST
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponseEnderecoPOST
    SynchronizedEvents = False
    Left = 440
    Top = 217
  end
  object RESTResponseEnderecoPOST: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 526
    Top = 217
  end
end
