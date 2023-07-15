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
    tbProdutos: TADOTable;
    tbProdutosNCHPRODUTO: TAutoIncField;
    tbProdutosTDESCRICAO: TStringField;
    tbProdutosTCODIGOBARRAS: TStringField;
    tbProdutosNVALORVENDA: TFloatField;
    tbProdutosNQTDESTOQUE: TFloatField;
    tbProdutosTUNIDADE: TStringField;
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
  uDataModulo;

{$R *.dfm}

{ TfrmCadastroProduto }

procedure TfrmCadastroProduto.btnCancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja realmente cancelar a operação?', 'Cancelar', MB_ICONINFORMATION + MB_YESNO) = mrYes then
  begin
    tbProdutos.Cancel;
    Self.Close;
  end;
end;

procedure TfrmCadastroProduto.btnGravarClick(Sender: TObject);
var
  sOperacao: string;
begin
  sOperacao := '';
  edtCodigoBarras.SetFocus;

  if Self.ValidarDados then
  begin
    tbProdutos.Post;

    if Self.FChProduto = 0 then
    begin
      sOperacao := 'cadastrado'
    end
    else
    begin
      sOperacao := 'alterado';
    end;

    Application.MessageBox(PWideChar(Format('Produto %s com sucesso!', [sOperacao])), 'Aviso', MB_ICONINFORMATION);
    Self.Close;
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
begin
  tbProdutos.Close;
  tbProdutos.Open;

  if Self.FChProduto = 0 then
  begin
    tbProdutos.Append;
    cboUnidade.ItemIndex := 0;
  end
  else
  begin
    tbProdutos.Locate('NCHPRODUTO', Self.FChProduto, []);
    tbProdutos.Edit;

    edtCodigoBarras.Text := tbProdutos.FieldByName('TCODIGOBARRAS').AsString;
    edtDescricao.Text := tbProdutos.FieldByName('TDESCRICAO').AsString;
    cboUnidade.Text := tbProdutos.FieldByName('TUNIDADE').AsString;
    edtValorVenda.Text := FormatFloat('#,##0.00',tbProdutos.FieldByName('NVALORVENDA').AsExtended);
    edtQtdEstoque.Text := FormatFloat('#,##0.00',tbProdutos.FieldByName('NQTDESTOQUE').AsExtended);
  end;
end;

function TfrmCadastroProduto.ValidarDados: Boolean;

procedure CampoInvalido(aMensagemErro: string; aFocalizar: TDBEdit);
begin
  Application.MessageBox(PWideChar(aMensagemErro), 'Erro', MB_ICONERROR);
  aFocalizar.SetFocus;
end;

var
  sCamposInv, sCodBarras: string;
  i: Integer;
begin
  Result := True;
  sCamposInv := '';
  sCodBarras := '';

  tbProdutos.FieldByName('TCODIGOBARRAS').AsString := edtCodigoBarras.Text;
  tbProdutos.FieldByName('TDESCRICAO').AsString := edtDescricao.Text;
  tbProdutos.FieldByName('TUNIDADE').AsString := cboUnidade.Items[cboUnidade.ItemIndex];
  tbProdutos.FieldByName('NVALORVENDA').AsString := edtValorVenda.Text;
  tbProdutos.FieldByName('NQTDESTOQUE').AsString := edtQtdEstoque.Text;

  sCodBarras := tbProdutos.FieldByName('TCODIGOBARRAS').AsString;

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

  if tbProdutos.FieldByName('TDESCRICAO').AsString.Equals('') then
  begin
    sCamposInv := sCamposInv + Copy(lblDescricao.Caption, 1, (Length(lblDescricao.Caption) - 1)) + #13;
  end;

  if tbProdutos.FieldByName('NVALORVENDA').AsString.Equals('') then
  begin
    sCamposInv := sCamposInv + Copy(lblValorVenda.Caption, 1, (Length(lblValorVenda.Caption) - 1)) + #13;
  end;

  if tbProdutos.FieldByName('NQTDESTOQUE').AsString.Equals('') then
  begin
    sCamposInv := sCamposInv + Copy(lblQtdEstoque.Caption, 1, (Length(lblQtdEstoque.Caption) - 1)) + #13;
  end;

  if tbProdutos.FieldByName('TUNIDADE').AsString.Equals('') then
  begin
    sCamposInv := sCamposInv + Copy(lblUnidade.Caption, 1, (Length(lblUnidade.Caption) - 1));
  end;

  if not sCamposInv.Equals('') then
  begin
    Application.MessageBox(PWideChar('Não foi possível completar a operação, os seguintes campos estão inválidos:' + #13#13 + sCamposInv), 'Erro', MB_ICONERROR);
    Result := False;
  end;
end;

end.
