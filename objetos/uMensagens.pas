unit uMensagens;

interface

uses
  System.SysUtils, Vcl.Forms, Vcl.Controls, Winapi.Windows;

type
  TMensagens = class
  strict private
    class var FMensagens: TMensagens;
  private
    class procedure ReleaseInstance;
    class function GetInstance: TMensagens; static;
  public
    function Mostrar(aMensagem, aTitulo: string;  aArgumentos: array of const; aTipoMensagem: Integer = MB_ICONINFORMATION; aConfirmacao: Boolean = False): Boolean;

    procedure Aviso(aMensagem: string; aArgumentos: array of const); overload;
    procedure Aviso(aMensagem: string); overload;

    procedure Alerta(aMensagem: string; aArgumentos: array of const); overload;
    procedure Alerta(aMensagem: string); overload;

    procedure Erro(aMensagem: string; aArgumentos: array of const); overload;
    procedure Erro(aMensagem: string); overload;

    function Confirma(aMensagem: string; aArgumentos: array of const): Boolean; overload;
    function Confirma(aMensagem: string): Boolean; overload;
  end;

function Mensagem: TMensagens;

implementation

function Mensagem: TMensagens;
begin
  Result := TMensagens.GetInstance;
end;

{ TMensagens }

procedure TMensagens.Alerta(aMensagem: string; aArgumentos: array of const);
begin
  Self.Mostrar(aMensagem, 'Alerta', aArgumentos, MB_ICONWARNING);
end;

procedure TMensagens.Alerta(aMensagem: string);
begin
  Self.Alerta(aMensagem, []);
end;

procedure TMensagens.Aviso(aMensagem: string; aArgumentos: array of const);
begin
  Self.Mostrar(aMensagem, 'Aviso', aArgumentos, MB_ICONINFORMATION);
end;

procedure TMensagens.Aviso(aMensagem: string);
begin
  Self.Aviso(aMensagem, [])
end;

function TMensagens.Confirma(aMensagem: string): Boolean;
begin
  Result := Self.Confirma(aMensagem, []);
end;

function TMensagens.Confirma(aMensagem: string; aArgumentos: array of const): Boolean;
begin
  Result := Self.Mostrar(aMensagem, 'Atenção', aArgumentos, MB_ICONWARNING, True);
end;

procedure TMensagens.Erro(aMensagem: string);
begin
  Self.Erro(aMensagem, []);
end;

procedure TMensagens.Erro(aMensagem: string; aArgumentos: array of const);
begin
  Self.Mostrar(aMensagem, 'Erro', aArgumentos, MB_ICONERROR);
end;

class function TMensagens.GetInstance: TMensagens;
begin
  if not Assigned(TMensagens.FMensagens) then
  begin
    TMensagens.FMensagens := TMensagens.Create;
  end;

  Result := TMensagens.FMensagens;
end;

function TMensagens.Mostrar(aMensagem, aTitulo: string; aArgumentos: array of const; aTipoMensagem: Integer = MB_ICONINFORMATION; aConfirmacao: Boolean = False): Boolean;
begin
  Result := True;

  if aMensagem.Equals('') or aTitulo.Equals('') then
  begin
    raise Exception.Create('O texto para a mensagem/título não foi definido.');
  end
  else
  begin
    if aConfirmacao then
    begin
      Result := (Application.MessageBox(PWideChar(Format(aMensagem, aArgumentos)), PWideChar(aTitulo), aTipoMensagem + MB_YESNO) = mrYes);
    end
    else
    begin
      Application.MessageBox(PWideChar(Format(aMensagem, aArgumentos)), PWideChar(aTitulo), aTipoMensagem);
    end;
  end;
end;

class procedure TMensagens.ReleaseInstance;
begin
  if Assigned(TMensagens.FMensagens) then
  begin
    FreeAndNil(TMensagens.FMensagens);
  end;
end;

initialization
finalization
  TMensagens.ReleaseInstance;
end.
