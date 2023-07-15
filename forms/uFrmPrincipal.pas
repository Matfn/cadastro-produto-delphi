unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Data.DB, Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids;

type
  TfrmPrincipal = class(TForm)
    pnlCentral: TPanel;
    pnlOperacoes: TPanel;
    btnExcluir: TSpeedButton;
    btnAlterar: TSpeedButton;
    btnCadastrar: TSpeedButton;
    btnSair: TSpeedButton;
    queryProdutos: TADOQuery;
    DataSourceProdutos: TDataSource;
    grdProdutos: TDBGrid;
    queryProdutosCódProduto: TAutoIncField;
    queryProdutosCódBarras: TStringField;
    queryProdutosDescrição: TStringField;
    queryProdutosValorVenda: TFloatField;
    queryProdutosQtdEstoque: TFloatField;
    queryProdutosUnidade: TStringField;
    procedure btnSairClick(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    procedure AbrirCadastroProduto(aChProduto: Integer);
    function ValidarProduto: Boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uDataModulo, uFrmCadastroProduto;

{$R *.dfm}

procedure TfrmPrincipal.AbrirCadastroProduto(aChProduto: Integer);
var
  frmCadProduto: TfrmCadastroProduto;
begin
  frmCadProduto := TfrmCadastroProduto.Create(Self, aChProduto);
  try
    frmCadProduto.ShowModal;
  finally
    FreeAndNil(frmCadProduto);
  end;

  queryProdutos.Close;
  queryProdutos.Open;
end;

procedure TfrmPrincipal.btnAlterarClick(Sender: TObject);
begin
  if Self.ValidarProduto then
  begin
    Self.AbrirCadastroProduto(queryProdutos.Fields[0].AsInteger);
  end;
end;

procedure TfrmPrincipal.btnCadastrarClick(Sender: TObject);
begin
  Self.AbrirCadastroProduto(0);
end;

procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
var
  chProduto: Integer;
  queryDelete: TADOQuery;
begin
  if Self.ValidarProduto then
  begin
    chProduto := queryProdutos.Fields[0].AsInteger;

    if Application.MessageBox(PWideChar(Format('Deseja realmente excluir o produto de cód. %d?', [chProduto])), 'Excluir', MB_ICONWARNING + MB_YESNO) = mrYes then
    begin
      queryProdutos.Delete;

      Application.MessageBox(PWideChar(Format('Produto de cód. %d excluído com sucesso!', [chProduto])), 'Aviso', MB_ICONINFORMATION);
      queryProdutos.Close;
      queryProdutos.Open;
    end;
  end;
end;

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja sair da aplicação?', 'Sair', MB_ICONQUESTION + MB_YESNO) = mrYes then
  begin
    Self.Close;
  end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  queryProdutos.Close;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  queryProdutos.Open;
end;

function TfrmPrincipal.ValidarProduto: Boolean;
begin
  Result := True;

  if queryProdutos.Fields[0].AsInteger = 0 then
  begin
    Result := False;
    Application.MessageBox('Não foi possível completar a operação, nenhum produto foi selecionado.', 'Erro', MB_ICONERROR);
  end
end;

end.
