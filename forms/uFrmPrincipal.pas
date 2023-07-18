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
  uDataModulo, uFrmCadastroProduto, uMensagens, uObjProduto;

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
  produto: TProduto;
begin
  if Self.ValidarProduto then
  begin
    chProduto := queryProdutos.Fields[0].AsInteger;

    if Mensagem.Confirma('Deseja realmente excluir o produto de cód. %d?', [chProduto]) then
    begin
      produto := TProduto.Create(chProduto);
      try
        if produto.ExcluirProduto then
        begin
          queryProdutos.Close;
          queryProdutos.Open;

          Mensagem.Aviso('Produto excluído com sucesso!');
        end;
      finally
        if Assigned(produto) then FreeAndNil(produto);
      end;
    end;
  end;
end;

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  if Mensagem.Confirma('Deseja sair da aplicação?') then
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
    Mensagem.Erro('Não foi possível completar a operação, nenhum produto foi selecionado.');
  end
end;

end.
