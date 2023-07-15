object DataModulo: TDataModulo
  Height = 170
  Width = 189
  object ConexaoBanco: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=sa;Init' +
      'ial Catalog=TESTE_ARECO;Data Source=NASCIMENTO-PC;Initial File N' +
      'ame="";Server SPN=""'
    Provider = 'SQLNCLI11.1'
    Left = 48
    Top = 40
  end
end
