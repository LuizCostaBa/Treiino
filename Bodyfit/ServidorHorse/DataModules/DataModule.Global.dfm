object DmGlobal: TDmGlobal
  OnCreate = DataModuleCreate
  Height = 369
  Width = 320
  object Conn: TFDConnection
    Params.Strings = (
      'Database=D:\Bodyfit\ServidorHorse\DB\BANCO.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost'
      'DriverID=FB')
    TxOptions.Isolation = xiDirtyRead
    ConnectedStoredUsage = []
    LoginPrompt = False
    BeforeConnect = ConnBeforeConnect
    Left = 56
    Top = 32
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 176
    Top = 32
  end
end
