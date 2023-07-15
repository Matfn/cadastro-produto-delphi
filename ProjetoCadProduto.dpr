program ProjetoCadProduto;

uses
  Vcl.Forms,
  uDataModulo in 'conexaoBanco\uDataModulo.pas' {DataModulo: TDataModule},
  uFrmCadastroProduto in 'forms\uFrmCadastroProduto.pas' {frmCadastroProduto},
  uFrmPrincipal in 'forms\uFrmPrincipal.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModulo, DataModulo);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
