object WsEndereco: TWsEndereco
  OldCreateOrder = False
  Height = 206
  Width = 242
  object QyEndereco: TFDQuery
    CachedUpdates = True
    Connection = DmConexao.FdConexao
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'SELECT * FROM ENDERECO'
      '')
    Left = 48
    Top = 32
    object QyEnderecoidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QyEnderecoflnatureza: TIntegerField
      FieldName = 'flnatureza'
      Origin = 'flnatureza'
      Required = True
    end
    object QyEnderecodsdocumento: TStringField
      FieldName = 'dsdocumento'
      Origin = 'dsdocumento'
      Required = True
    end
    object QyEndereconmprimeiro: TStringField
      FieldName = 'nmprimeiro'
      Origin = 'nmprimeiro'
      Required = True
      Size = 100
    end
    object QyEndereconmsegundo: TStringField
      FieldName = 'nmsegundo'
      Origin = 'nmsegundo'
      Required = True
      Size = 100
    end
    object QyEnderecodtregistro: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'dtregistro'
      Origin = 'dtregistro'
    end
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO wk.endereco'
      '(idpessoa, dscep)'
      'VALUES (:new_idpessoa, :new_dscep)')
    ModifySQL.Strings = (
      'UPDATE wk.endereco'
      'SET idpessoa = :new_idpessoa, dscep = :new_dscep'
      'WHERE idendereco = :old_idendereco')
    DeleteSQL.Strings = (
      'DELETE FROM wk.endereco'
      'WHERE idendereco = :old_idendereco')
    FetchRowSQL.Strings = (
      'SELECT idendereco, idpessoa, dscep'
      'FROM wk.endereco'
      'WHERE idendereco = :idendereco')
    Left = 48
    Top = 88
  end
  object QyLast: TFDQuery
    Connection = DmConexao.FdConexao
    SQL.Strings = (
      'SELECT MAX(IDENDERECO)NEW FROM ENDERECO')
    Left = 152
    Top = 104
  end
end
