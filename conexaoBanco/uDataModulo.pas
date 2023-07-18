unit uDataModulo;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModulo = class(TDataModule)
    ConexaoBanco: TADOConnection;
  end;

  TControle = class
  private
    FSQLQuery: TADOQuery;
    FConexaoBanco: TADOConnection;
    procedure SetSQLQuery(const Value: TADOQuery);
  public
    property SQLQuery: TADOQuery read FSQLQuery write SetSQLQuery;

    constructor Create;
    destructor Destroy; override;
  end;

var
  DataModulo: TDataModulo;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TControle }

constructor TControle.Create;
begin
  Self.FConexaoBanco := DataModulo.ConexaoBanco;

  Self.FSQLQuery := TADOQuery.Create(nil);
  Self.FSQLQuery.Connection := Self.FConexaoBanco;
  Self.FSQLQuery.Close;
end;

destructor TControle.Destroy;
begin
  if Assigned(Self.FSQLQuery) then
  begin
    Self.FSQLQuery.Close;
    FreeAndNil(Self.FSQLQuery);
  end;

  inherited;
end;

procedure TControle.SetSQLQuery(const Value: TADOQuery);
begin
  FSQLQuery := Value;
end;

end.
