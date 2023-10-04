object DmGlobal: TDmGlobal
  OnCreate = DataModuleCreate
  Height = 605
  Width = 403
  object Conn: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = ConnAfterConnect
    BeforeConnect = ConnBeforeConnect
    Left = 64
    Top = 32
  end
  object TabUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 232
    Top = 32
  end
  object qryUsuario: TFDQuery
    Connection = Conn
    Left = 64
    Top = 112
  end
  object TabTreino: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 232
    Top = 112
  end
  object qryTreinoExercicio: TFDQuery
    Connection = Conn
    Left = 64
    Top = 184
  end
  object qryConsEstatistica: TFDQuery
    Connection = Conn
    Left = 64
    Top = 256
  end
  object qryConsTreino: TFDQuery
    Connection = Conn
    Left = 64
    Top = 336
  end
  object qryConsExercicio: TFDQuery
    Connection = Conn
    Left = 64
    Top = 408
  end
  object qryAtividade: TFDQuery
    Connection = Conn
    Left = 64
    Top = 480
  end
  object qryGeral: TFDQuery
    Connection = Conn
    Left = 240
    Top = 480
  end
end
