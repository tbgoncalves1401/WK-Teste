object WsPessoa: TWsPessoa
  OldCreateOrder = False
  Height = 326
  Width = 379
  object QyPessoa: TFDQuery
    CachedUpdates = True
    Connection = DmConexao.FdConexao
    SQL.Strings = (
      'SELECT * FROM PESSOA')
    Left = 40
    Top = 32
    object QyPessoaidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QyPessoaflnatureza: TIntegerField
      FieldName = 'flnatureza'
      Origin = 'flnatureza'
      Required = True
    end
    object QyPessoadsdocumento: TStringField
      FieldName = 'dsdocumento'
      Origin = 'dsdocumento'
      Required = True
    end
    object QyPessoanmprimeiro: TStringField
      FieldName = 'nmprimeiro'
      Origin = 'nmprimeiro'
      Required = True
      Size = 100
    end
    object QyPessoanmsegundo: TStringField
      FieldName = 'nmsegundo'
      Origin = 'nmsegundo'
      Required = True
      Size = 100
    end
    object QyPessoadtregistro: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'dtregistro'
      Origin = 'dtregistro'
    end
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      
        'INSERT INTO wk.pessoa(flnatureza, dsdocumento, nmprimeiro, nmseg' +
        'undo)'
      
        'VALUES (:new_flnatureza, :new_dsdocumento, :new_nmprimeiro, :new' +
        '_nmsegundo)')
    ModifySQL.Strings = (
      'UPDATE wk.pessoa'
      
        'SET flnatureza = :new_flnatureza, dsdocumento = :new_dsdocumento' +
        ', '
      '  nmprimeiro = :new_nmprimeiro, nmsegundo = :new_nmsegundo'
      'WHERE idpessoa = :old_idpessoa')
    DeleteSQL.Strings = (
      'DELETE FROM wk.pessoa'
      'WHERE idpessoa = :old_idpessoa')
    FetchRowSQL.Strings = (
      
        'SELECT LAST_INSERT_ID() AS idpessoa, flnatureza, dsdocumento, nm' +
        'primeiro, '
      '  nmsegundo, dtregistro'
      'FROM wk.pessoa'
      'WHERE idpessoa = :idpessoa')
    Left = 48
    Top = 88
  end
  object QyLast: TFDQuery
    Connection = DmConexao.FdConexao
    SQL.Strings = (
      'SELECT MAX(IDPESSOA)NEW FROM PESSOA')
    Left = 200
    Top = 168
  end
end
