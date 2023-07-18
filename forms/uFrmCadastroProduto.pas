unit uFrmCadastroProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus,
  Vcl.Buttons, Data.DB, Data.Win.ADODB, Vcl.Mask, Vcl.DBCtrls;

type
  TfrmCadastroProduto = class(TForm)
    pnlPrincipal: TPanel;
    pnlDados: TPanel;
    lblQtdEstoque: TLabel;
    lblValorVenda: TLabel;
    lblDescricao: TLabel;
    lblCodigoBarras: TLabel;
    pnlOperacoes: TPanel;
    btnCancelar: TSpeedButton;
    btnGravar: TSpeedButton;
    lblUnidade: TLabel;
    edtCodigoBarras: TEdit;
    edtDescricao: TEdit;
    edtQtdEstoque: TEdit;
    cboUnidade: TComboBox;
    edtValorVenda: TEdit;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure edtValorVendaExit(Sender: TObject);
    procedure edtQtdEstoqueExit(Sender: TObject);
    procedure cboUnidadeExit(Sender: TObject);
  private
    FChProduto: Integer;

    function ValidarDados: Boolean;
  public
    constructor Create(aOwner: TComponent; aChProduto: Integer); reintroduce; overload;
  end;

var
  frmCadastroProduto: TfrmCadastroProduto;

implementation

uses
  uDataModulo, uMensagens, uObjProduto;

{$R *.dfm}

{ TfrmCadastroProduto }

procedure TfrmCadastroProduto.btnCancelarClick(Sender: TObject);
begin
  if Mensagem.Confirma('Deseja realmente cancelar a operação?') then
  begin
    Self.Close;
  end;
end;

procedure TfrmCadastroProduto.btnGravarClick(Sender: TObject);
var
  produto: TProduto;
  valorVenda, qtdEstoque: Extended;
begin
  produto := nil;
  valorVenda := 0;
  qtdEstoque := 0;

  if Self.ValidarDados then
  begin
    produto := TProduto.Create;
    try
      produto.ChProduto := Self.FChProduto;
      produto.CodigoBarras :=  edtCodigoBarras.Text;
      produto.Descricao := edtDescricao.Text;
      produto.Unidade := cboUnidade.Items[cboUnidade.ItemIndex];

      if TryStrToFloat(edtValorVenda.Text, valorVenda) then
      begin
        produto.ValorVenda := valorVenda;
      end
      else
      begin
        produto.ValorVenda := 0;
      end;

      if TryStrToFloat(edtQtdEstoque.Text, qtdEstoque) then
      begin
        produto.QtdEstoque := qtdEstoque;
      end
      else
      begin
        produto.QtdEstoque := 0;
      end;

      if Self.FChProduto = 0 then
      begin
        if produto.CadastrarProduto then
        begin
          Mensagem.Aviso('Produto cadastrado com sucesso!');
        end;
      end
      else
      begin
        if produto.AlterarProduto then
        begin
          Mensagem.Aviso('Produto alterado com sucesso!');
        end;
      end;

      Self.Close;
    finally
      if Assigned(produto) then FreeAndNil(produto);
    end;
  end;
end;

procedure TfrmCadastroProduto.cboUnidadeExit(Sender: TObject);
begin
  if cboUnidade.ItemIndex = -1 then
  begin
    cboUnidade.ItemIndex := 0;
  end;
end;

constructor TfrmCadastroProduto.Create(aOwner: TComponent; aChProduto: Integer);
begin
  Self.FChProduto := aChProduto;

  inherited Create(aOwner);
end;

procedure TfrmCadastroProduto.edtQtdEstoqueExit(Sender: TObject);
var
  qtd: Extended;
begin
  if TryStrToFloat(edtQtdEstoque.Text, qtd) then
  begin
    edtQtdEstoque.Text := FormatFloat('#,##0.00', qtd);
  end
  else
  begin
    edtQtdEstoque.Text := '';
  end;
end;

procedure TfrmCadastroProduto.edtValorVendaExit(Sender: TObject);
var
  valor: Extended;
begin
  if TryStrToFloat(edtValorVenda.Text, valor) then
  begin
    edtValorVenda.Text := FormatFloat('#,##0.00', valor);
  end
  else
  begin
    edtValorVenda.Text := '';
  end;
end;

procedure TfrmCadastroProduto.FormShow(Sender: TObject);
var
  produto: TProduto;
begin
  produto := nil;

  if Self.FChProduto = 0 then
  begin
    cboUnidade.ItemIndex := 0;
  end
  else
  begin
    produto := TProduto.Create(Self.FChProduto);
    try
      if Assigned(produto) then
      begin
        edtCodigoBarras.Text := produto.CodigoBarras;
        edtDescricao.Text := produto.Descricao;
        cboUnidade.Text := produto.Unidade;
        edtValorVenda.Text := FormatFloat('#,##0.00', produto.ValorVenda);
        edtQtdEstoque.Text := FormatFloat('#,##0.00', produto.QtdEstoque);
      end;
    finally
      if Assigned(produto) then FreeAndNil(produto);
    end;
  end;
end;

function TfrmCadastroProduto.ValidarDados: Boolean;
var
  sCamposInv, sCodBarras: string;
  i: Integer;
  valorVenda, qtdEstoque: Extended;
begin
  Result := True;
  sCamposInv := '';
  sCodBarras := '';
  valorVenda := 0;
  qtdEstoque := 0;

  sCodBarras := edtCodigoBarras.Text;

  if sCodBarras.Equals('') then
  begin
    sCamposInv := sCamposInv + Copy(lblCodigoBarras.Caption, 1, (Length(lblCodigoBarras.Caption) - 1)) + #13;
  end
  else
  begin
    for i := 1 to Length(sCodBarras) do
    begin
      if not CharInSet(sCodBarras[i], ['0'..'9']) then
      begin
        sCamposInv := sCamposInv + Copy(lblCodigoBarras.Caption, 1, (Length(lblCodigoBarras.Caption) - 1)) + #13;
        Break;
      end;
    end;
  end;

  if string(edtDescricao.Text).Equals('') then
  begin
    sCamposInv := sCamposInv + Copy(lblDescricao.Caption, 1, (Length(lblDescricao.Caption) - 1)) + #13;
  end;

  if ((string(edtValorVenda.Text).Equals('')) or (not TryStrToFloat(edtValorVenda.Text, valorVenda))) then
  begin
    sCamposInv := sCamposInv + Copy(lblValorVenda.Caption, 1, (Length(lblValorVenda.Caption) - 1)) + #13;
  end;

  if ((string(edtQtdEstoque.Text).Equals('')) or (not TryStrToFloat(edtQtdEstoque.Text, qtdEstoque))) then
  begin
    sCamposInv := sCamposInv + Copy(lblQtdEstoque.Caption, 1, (Length(lblQtdEstoque.Caption) - 1)) + #13;
  end;

  if cboUnidade.Items[cboUnidade.ItemIndex].Equals('') then
  begin
    sCamposInv := sCamposInv + Copy(lblUnidade.Caption, 1, (Length(lblUnidade.Caption) - 1));
  end;

  if not sCamposInv.Equals('') then
  begin
    Mensagem.Erro('Não foi possível completar a operação, os seguintes campos estão inválidos:' + #13#13 + sCamposInv);
    Result := False;
  end;
end;

end.
