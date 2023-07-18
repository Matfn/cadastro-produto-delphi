unit uObjProduto;

interface

uses
  System.SysUtils, uMensagens, uDataModulo, Data.DB;

type

  TProduto = class
  private
    FValorVenda: Extended;
    FDescricao: string;
    FQtdEstoque: Extended;
    FUnidade: string;
    FCodigoBarras: string;
    FControle: TControle;
    FChProduto: Integer;
    procedure SetCodigoBarras(const Value: string);
    procedure SetDescricao(const Value: string);
    procedure SetQtdEstoque(const Value: Extended);
    procedure SetUnidade(const Value: string);
    procedure SetValorVenda(const Value: Extended);
    procedure SetChProduto(const Value: Integer);

    class function ConsultarProduto(aChProduto: Integer): TProduto;
  public
    property ChProduto: Integer read FChProduto write SetChProduto;
    property CodigoBarras: string read FCodigoBarras write SetCodigoBarras;
    property Descricao: string read FDescricao write SetDescricao;
    property ValorVenda: Extended read FValorVenda write SetValorVenda;
    property QtdEstoque: Extended read FQtdEstoque write SetQtdEstoque;
    property Unidade: string read FUnidade write SetUnidade;

    function CadastrarProduto: Boolean;
    function ExcluirProduto: Boolean;
    function AlterarProduto: Boolean;

    constructor Create(aChProduto: Integer = 0);
    destructor Destroy; override;
  end;

implementation

{ TProduto }

function TProduto.AlterarProduto: Boolean;
const
  SQL_UPDATE = ' UPDATE dbo.TABPRODUTOS                 ' +
               '    SET TCODIGOBARRAS = :TCODIGOBARRAS, ' +
               '        TDESCRICAO = :TDESCRICAO,       ' +
               '        NVALORVENDA = :NVALORVENDA,     ' +
               '        NQTDESTOQUE = :NQTDESTOQUE,     ' +
               '        TUNIDADE = :TUNIDADE            ' +
               '  WHERE NCHPRODUTO = :NCHPRODUTO        ' ;
begin
  Result := False;

  try
    if Assigned(Self.FControle) then
    begin
      Self.FControle.SQLQuery.Close;
      Self.FControle.SQLQuery.SQL.Text := SQL_UPDATE;

      Self.FControle.SQLQuery.Parameters.ParamByName('TCODIGOBARRAS').DataType := ftString;
      Self.FControle.SQLQuery.Parameters.ParamByName('TCODIGOBARRAS').Value := Self.FCodigoBarras;

      Self.FControle.SQLQuery.Parameters.ParamByName('TDESCRICAO').DataType := ftString;
      Self.FControle.SQLQuery.Parameters.ParamByName('TDESCRICAO').Value := Self.FDescricao;

      Self.FControle.SQLQuery.Parameters.ParamByName('NVALORVENDA').DataType := ftExtended;
      Self.FControle.SQLQuery.Parameters.ParamByName('NVALORVENDA').Value := Self.FValorVenda;

      Self.FControle.SQLQuery.Parameters.ParamByName('NQTDESTOQUE').DataType := ftExtended;
      Self.FControle.SQLQuery.Parameters.ParamByName('NQTDESTOQUE').Value := Self.QtdEstoque;

      Self.FControle.SQLQuery.Parameters.ParamByName('TUNIDADE').DataType := ftString;
      Self.FControle.SQLQuery.Parameters.ParamByName('TUNIDADE').Value := Self.FUnidade;

      Self.FControle.SQLQuery.Parameters.ParamByName('NCHPRODUTO').DataType := ftInteger;
      Self.FControle.SQLQuery.Parameters.ParamByName('NCHPRODUTO').Value := Self.FChProduto;

      if Self.FControle.SQLQuery.ExecSQL > 0 then
      begin
        Result := True;
      end;
    end;
  except
    raise Exception.Create('Não foi possível efetuar a alteração do produto.');
  end;
end;

function TProduto.CadastrarProduto: Boolean;
const
  SQL_INSERT = 'INSERT INTO dbo.TABPRODUTOS (TCODIGOBARRAS, TDESCRICAO, NVALORVENDA, NQTDESTOQUE, TUNIDADE) ' +
               '     VALUES (:TCODIGOBARRAS, :TDESCRICAO, :NVALORVENDA, :NQTDESTOQUE, :TUNIDADE)            ' ;
begin
  Result := False;
  try
    if Assigned(Self.FControle) then
    begin
      Self.FControle.SQLQuery.Close;
      Self.FControle.SQLQuery.SQL.Text := SQL_INSERT;

      Self.FControle.SQLQuery.Parameters.ParamByName('TCODIGOBARRAS').DataType := ftString;
      Self.FControle.SQLQuery.Parameters.ParamByName('TCODIGOBARRAS').Value := Self.FCodigoBarras;

      Self.FControle.SQLQuery.Parameters.ParamByName('TDESCRICAO').DataType := ftString;
      Self.FControle.SQLQuery.Parameters.ParamByName('TDESCRICAO').Value := Self.FDescricao;

      Self.FControle.SQLQuery.Parameters.ParamByName('NVALORVENDA').DataType := ftExtended;
      Self.FControle.SQLQuery.Parameters.ParamByName('NVALORVENDA').Value := Self.FValorVenda;

      Self.FControle.SQLQuery.Parameters.ParamByName('NQTDESTOQUE').DataType := ftExtended;
      Self.FControle.SQLQuery.Parameters.ParamByName('NQTDESTOQUE').Value := Self.QtdEstoque;

      Self.FControle.SQLQuery.Parameters.ParamByName('TUNIDADE').DataType := ftString;
      Self.FControle.SQLQuery.Parameters.ParamByName('TUNIDADE').Value := Self.FUnidade;

      if Self.FControle.SQLQuery.ExecSQL > 0 then
      begin
        Result := True;
      end;
    end;
  except
    raise Exception.Create('Não foi possível efetuar o cadastro do produto.');
  end;
end;

class function TProduto.ConsultarProduto(aChProduto: Integer): TProduto;
const
  SQL_CONSULTA = ' SELECT NCHPRODUTO,              ' +
                 '        TCODIGOBARRAS,           ' +
                 '        TDESCRICAO,              ' +
                 '        NVALORVENDA,             ' +
                 '        NQTDESTOQUE,             ' +
                 '        TUNIDADE                 ' +
                 '   FROM dbo.TABPRODUTOS          ' +
                 '  WHERE NCHPRODUTO = :NCHPRODUTO ' ;
var
  controle: TControle;
begin
  Result := nil;

  controle := TControle.Create;
  try
    if Assigned(controle) then
    begin
      try
        controle.SQLQuery.SQL.Text := SQL_CONSULTA;
        controle.SQLQuery.Parameters.ParamByName('NCHPRODUTO').DataType := ftInteger;
        controle.SQLQuery.Parameters.ParamByName('NCHPRODUTO').Value := aChProduto;
        controle.SQLQuery.Open;

        if not controle.SQLQuery.IsEmpty then
        begin
          Result := TProduto.Create;
          Result.FChProduto := controle.SQLQuery.Fields[0].AsInteger;
          Result.FCodigoBarras := controle.SQLQuery.Fields[1].AsString;
          Result.FDescricao := controle.SQLQuery.Fields[2].AsString;
          Result.FValorVenda := controle.SQLQuery.Fields[3].AsExtended;
          Result.FQtdEstoque := controle.SQLQuery.Fields[4].AsExtended;
          Result.FUnidade := controle.SQLQuery.Fields[5].AsString;
        end;
      except
        raise Exception.Create('Não foi possível efetuar a consulta do produto.');
      end;
    end;
  finally
    if Assigned(controle) then FreeAndNil(controle);
  end;
end;

constructor TProduto.Create(aChProduto: Integer = 0);
var
  LProduto: TProduto;
begin
  Self.FControle := TControle.Create;

  if aChProduto <> 0 then
  begin
    LProduto := Self.ConsultarProduto(aChProduto);

    if Assigned(LProduto) then
    begin
      Self.FChProduto := LProduto.FChProduto;
      Self.FCodigoBarras := LProduto.FCodigoBarras;
      Self.FDescricao := LProduto.FDescricao;
      Self.FValorVenda := LProduto.FValorVenda;
      Self.FQtdEstoque := LProduto.FQtdEstoque;
      Self.FUnidade := LProduto.FUnidade;
    end;
  end
  else
  begin
    Self.FChProduto := aChProduto;
  end;
end;

destructor TProduto.Destroy;
begin
  if Assigned(Self.FControle) then
  begin
    FreeAndNil(Self.FControle);
  end;
  inherited;
end;

function TProduto.ExcluirProduto: Boolean;
const
  SQL_DELETE = 'DELETE FROM dbo.TABPRODUTOS WHERE NCHPRODUTO = :NCHPRODUTO';
begin
  Result := False;

  if Assigned(Self.FControle) then
  begin
    try
      Self.FControle.SQLQuery.Close;
      Self.FControle.SQLQuery.SQL.Text := SQL_DELETE;
      Self.FControle.SQLQuery.Parameters.ParamByName('NCHPRODUTO').DataType := ftInteger;
      Self.FControle.SQLQuery.Parameters.ParamByName('NCHPRODUTO').Value := Self.FChProduto;

      if Self.FControle.SQLQuery.ExecSQL > 0 then
      begin
        Result := True;
      end;
    except
      raise Exception.Create('Não foi possível efetuar a exclusão do produto.');
    end;
  end;
end;

procedure TProduto.SetChProduto(const Value: Integer);
begin
  FChProduto := Value;
end;

procedure TProduto.SetCodigoBarras(const Value: string);
begin
  FCodigoBarras := Value;
end;

procedure TProduto.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TProduto.SetQtdEstoque(const Value: Extended);
begin
  FQtdEstoque := Value;
end;

procedure TProduto.SetUnidade(const Value: string);
begin
  FUnidade := Value;
end;

procedure TProduto.SetValorVenda(const Value: Extended);
begin
  FValorVenda := Value;
end;

end.
