program ProjetoCadProduto;

uses
  Vcl.Forms,
  uDataModulo in 'conexaoBanco\uDataModulo.pas' {DataModulo: TDataModule},
  uFrmCadastroProduto in 'forms\uFrmCadastroProduto.pas' {frmCadastroProduto},
  uFrmPrincipal in 'forms\uFrmPrincipal.pas' {frmPrincipal},
  uObjProduto in 'objetos\uObjProduto.pas',
  uMensagens in 'objetos\uMensagens.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModulo, DataModulo);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
