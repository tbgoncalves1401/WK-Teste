object WsEndereco: TWsEndereco
  OldCreateOrder = False
  Height = 206
  Width = 242
  object QyEndereco: TFDQuery
    CachedUpdates = True
    Connection = DmConexao.FdConexao
    SQL.Strings = (
      'SELECT * FROM ENDERECO'
      '')
    Left = 48
    Top = 32
    object QyEnderecoidendereco: TLargeintField
      FieldName = 'idendereco'
      Origin = 'idendereco'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QyEnderecoidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
      Required = True
    end
    object QyEnderecodscep: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'dscep'
      Origin = 'dscep'
      Size = 15
    end
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO wk.endereco'
      '(idpessoa, dscep, idendereco)'
      'VALUES (:new_idpessoa, :new_dscep, :new_idendereco)')
    ModifySQL.Strings = (
      'UPDATE wk.endereco'
      'SET idpessoa =  dscep = :new_dscep'
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
      'SELECT MAX(idendereco)NEW FROM ENDERECO')
    Left = 152
    Top = 104
  end
end
