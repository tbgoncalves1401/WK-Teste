object WsEnderecoIntegracao: TWsEnderecoIntegracao
  OldCreateOrder = False
  Height = 206
  Width = 242
  object QyEnderecoIntegracao: TFDQuery
    CachedUpdates = True
    Connection = DmConexao.FdConexao
    SQL.Strings = (
      'SELECT * FROM ENDERECO_INTEGRACAO')
    Left = 48
    Top = 32
    object QyEnderecoIntegracaoidendereco: TLargeintField
      FieldName = 'idendereco'
      Origin = 'idendereco'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QyEnderecoIntegracaodsuf: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'dsuf'
      Origin = 'dsuf'
      Size = 50
    end
    object QyEnderecoIntegracaonmcidade: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nmcidade'
      Origin = 'nmcidade'
      Size = 100
    end
    object QyEnderecoIntegracaonmlogradouro: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nmlogradouro'
      Origin = 'nmlogradouro'
      Size = 50
    end
    object QyEnderecoIntegracaodscomplemento: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'dscomplemento'
      Origin = 'dscomplemento'
      Size = 100
    end
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO wk.endereco_integracao'
      '(:idendereco, dsuf, nmcidade, nmlogradouro, dscomplemento)'
      
        'VALUES (:new_idendereco, :new_dsuf, :new_nmcidade, :new_nmlograd' +
        'ouro, :new_dscomplemento)')
    ModifySQL.Strings = (
      'UPDATE wk.endereco_integracao'
      
        'SET dsuf = :new_dsuf, nmcidade = :new_nmcidade, nmlogradouro = :' +
        'new_nmlogradouro, '
      '  dscomplemento = :new_dscomplemento'
      'WHERE idendereco = :old_idendereco')
    DeleteSQL.Strings = (
      'DELETE FROM wk.endereco_integracao'
      'WHERE idendereco = :old_idendereco')
    FetchRowSQL.Strings = (
      'SELECT idendereco, dsuf, nmcidade, nmlogradouro, dscomplemento'
      'FROM wk.endereco_integracao'
      'WHERE idendereco = :idendereco')
    Left = 48
    Top = 88
  end
  object QyLast: TFDQuery
    Connection = DmConexao.FdConexao
    SQL.Strings = (
      'SELECT MAX(idendereco)NEW FROM ENDERECO_INTEGRACAO')
    Left = 152
    Top = 104
  end
end
