object FrPessoa: TFrPessoa
  Left = 0
  Top = 0
  Caption = 'Cadastro de pessoa'
  ClientHeight = 335
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 4
    Width = 44
    Height = 13
    Caption = 'Natureza'
  end
  object Label2: TLabel
    Left = 137
    Top = 4
    Width = 54
    Height = 13
    Caption = 'Documento'
  end
  object Label3: TLabel
    Left = 327
    Top = 4
    Width = 68
    Height = 13
    Caption = 'Primeiro Nome'
  end
  object Label4: TLabel
    Left = 517
    Top = 4
    Width = 72
    Height = 13
    Caption = 'Segundo Nome'
  end
  object Label5: TLabel
    Left = 10
    Top = 49
    Width = 19
    Height = 13
    Caption = 'CEP'
  end
  object Label6: TLabel
    Left = 218
    Top = 48
    Width = 13
    Height = 13
    Caption = 'UF'
  end
  object Label7: TLabel
    Left = 351
    Top = 45
    Width = 33
    Height = 13
    Caption = 'Cidade'
  end
  object Label8: TLabel
    Left = 539
    Top = 48
    Width = 55
    Height = 13
    Caption = 'Logradouro'
  end
  object Label9: TLabel
    Left = 10
    Top = 93
    Width = 65
    Height = 13
    Caption = 'Complemento'
  end
  object edNatureza: TEdit
    Left = 10
    Top = 23
    Width = 121
    Height = 21
    BiDiMode = bdLeftToRight
    MaxLength = 11
    NumbersOnly = True
    ParentBiDiMode = False
    TabOrder = 0
  end
  object edDocumento: TEdit
    Left = 137
    Top = 23
    Width = 184
    Height = 21
    MaxLength = 20
    TabOrder = 1
  end
  object edPrimNome: TEdit
    Left = 327
    Top = 23
    Width = 184
    Height = 21
    MaxLength = 100
    TabOrder = 2
  end
  object edSegNome: TEdit
    Left = 517
    Top = 23
    Width = 206
    Height = 21
    MaxLength = 100
    TabOrder = 3
  end
  object edCEP: TEdit
    Left = 10
    Top = 64
    Width = 121
    Height = 21
    BiDiMode = bdLeftToRight
    MaxLength = 9
    ParentBiDiMode = False
    TabOrder = 4
  end
  object BitBtn1: TBitBtn
    Left = 137
    Top = 62
    Width = 75
    Height = 25
    Caption = 'Pesquisar'
    TabOrder = 5
    OnClick = BitBtn1Click
  end
  object EdUF: TEdit
    Left = 218
    Top = 64
    Width = 127
    Height = 21
    MaxLength = 50
    TabOrder = 6
  end
  object edCidade: TEdit
    Left = 351
    Top = 64
    Width = 184
    Height = 21
    MaxLength = 100
    TabOrder = 7
  end
  object edLogradouro: TEdit
    Left = 539
    Top = 64
    Width = 184
    Height = 21
    MaxLength = 50
    TabOrder = 8
  end
  object edComplemento: TEdit
    Left = 10
    Top = 112
    Width = 184
    Height = 21
    MaxLength = 100
    TabOrder = 9
  end
  object btGravar: TButton
    Left = 105
    Top = 176
    Width = 75
    Height = 25
    Caption = '&Gravar'
    TabOrder = 11
    OnClick = btGravarClick
  end
  object btNovo: TButton
    Left = 24
    Top = 176
    Width = 75
    Height = 25
    Caption = '&Novo'
    TabOrder = 10
    OnClick = btNovoClick
  end
  object btnPesquisarPessoa: TButton
    Left = 186
    Top = 176
    Width = 75
    Height = 25
    Caption = '&Pesquisar'
    TabOrder = 12
    OnClick = btnPesquisarPessoaClick
  end
  object btnDelete: TButton
    Left = 267
    Top = 176
    Width = 75
    Height = 25
    Caption = '&Excluir'
    TabOrder = 13
    OnClick = btnDeleteClick
  end
  object RESTResponseGet: TRESTResponse
    ContentType = 'text/html'
    RootElement = 'result'
    Left = 144
    Top = 216
  end
  object RESTRequestGet: TRESTRequest
    Client = RESTGet
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponseGet
    SynchronizedEvents = False
    Left = 88
    Top = 216
  end
  object RESTGet: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://127.0.0.1:8080/datasnap/rest/TWsPessoa/Pessoa'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 40
    Top = 216
  end
end
