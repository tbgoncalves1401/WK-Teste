object WsEnderecoIntegracao: TWsEnderecoIntegracao
  OldCreateOrder = False
  Height = 206
  Width = 242
  object QyEnderecoIntegracao: TFDQuery
    CachedUpdates = True
    Connection = DmConexao.FdConexao
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'SELECT * FROM ENDERECO_INTEGRACAO')
    Left = 48
    Top = 32
    object QyEnderecoIntegracaoidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QyEnderecoIntegracaoflnatureza: TIntegerField
      FieldName = 'flnatureza'
      Origin = 'flnatureza'
      Required = True
    end
    object QyEnderecoIntegracaodsdocumento: TStringField
      FieldName = 'dsdocumento'
      Origin = 'dsdocumento'
      Required = True
    end
    object QyEnderecoIntegracaonmprimeiro: TStringField
      FieldName = 'nmprimeiro'
      Origin = 'nmprimeiro'
      Required = True
      Size = 100
    end
    object QyEnderecoIntegracaonmsegundo: TStringField
      FieldName = 'nmsegundo'
      Origin = 'nmsegundo'
      Required = True
      Size = 100
    end
    object QyEnderecoIntegracaodtregistro: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'dtregistro'
      Origin = 'dtregistro'
    end
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO wk.endereco_integracao'
      '(dsuf, nmcidade, nmlogradouro, dscomplemento)'
      
        'VALUES (:new_dsuf, :new_nmcidade, :new_nmlogradouro, :new_dscomp' +
        'lemento)')
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
      'SELECT MAX(IDPESSOA)NEW FROM ENDERECO_INTEGRACAO')
    Left = 152
    Top = 104
  end
end
