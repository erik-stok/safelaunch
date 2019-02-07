unit uCredentials;

interface

uses
  Windows;

const
  CRED_TYPE_GENERIC = 1;

type

  LPBYTE = ^Byte;

  PCREDENTIAL_ATTRIBUTEW = ^CREDENTIAL_ATTRIBUTEW;
  _CREDENTIAL_ATTRIBUTEW = record
    Keyword: LPWSTR;
    Flags: DWORD;
    ValueSize: DWORD;
    Value: LPBYTE;
  end;

  CREDENTIAL_ATTRIBUTEW = _CREDENTIAL_ATTRIBUTEW;

  TCredentialAttributeW = CREDENTIAL_ATTRIBUTEW;
  PCredentialAttributeW = PCREDENTIAL_ATTRIBUTEW;

  PCREDENTIALW = ^CREDENTIALW;

  _CREDENTIALW = record
    Flags: DWORD;
    Type_: DWORD;
    TargetName: LPWSTR;
    Comment: LPWSTR;
    LastWritten: FILETIME;
    CredentialBlobSize: DWORD;
    CredentialBlob: LPBYTE;
    Persist: DWORD;
    AttributeCount: DWORD;
    Attributes: PCREDENTIAL_ATTRIBUTEW;
    TargetAlias: LPWSTR;
    UserName: LPWSTR;
  end;

  CREDENTIALW = _CREDENTIALW;

  TCredentialW = CREDENTIALW;

  PCREDENTIAL_ATTRIBUTEA = ^CREDENTIAL_ATTRIBUTEA;
  _CREDENTIAL_ATTRIBUTEA = record
    Keyword: LPSTR;
    Flags: DWORD;
    ValueSize: DWORD;
    Value: LPBYTE;
  end;

  CREDENTIAL_ATTRIBUTEA = _CREDENTIAL_ATTRIBUTEA;

  TCredentialAttributeA = CREDENTIAL_ATTRIBUTEA;
  PCredentialAttributeA = PCREDENTIAL_ATTRIBUTEA;

  PCREDENTIALA = ^CREDENTIALA;

  _CREDENTIALA = record
    Flags: DWORD;
    Type_: DWORD;
    TargetName: LPSTR;
    Comment: LPSTR;
    LastWritten: FILETIME;
    CredentialBlobSize: DWORD;
    CredentialBlob: LPBYTE;
    Persist: DWORD;
    AttributeCount: DWORD;
    Attributes: PCREDENTIAL_ATTRIBUTEA;
    TargetAlias: LPSTR;
    UserName: LPSTR;
  end;

  CREDENTIALA = _CREDENTIALA;

  TCredentialA = CREDENTIALA;

  function CredReadW(TargetName: LPCWSTR; Type_: DWORD; Flags: DWORD; var Credential: PCREDENTIALW): BOOL; stdcall;
  function CredReadA(TargetName: LPCSTR; Type_: DWORD; Flags: DWORD; var Credential: PCREDENTIALA): BOOL; stdcall;

  function ReadCredentials(CredentialName: String; var UserName: String; var Password: String): Boolean;

implementation

{$WARN SYMBOL_PLATFORM OFF}
function CredReadW; external 'advapi32.dll' name 'CredReadW' delayed;
function CredReadA; external 'advapi32.dll' name 'CredReadA' delayed;
{$WARN SYMBOL_PLATFORM ON}

function ReadCredentials(CredentialName: String; var UserName: String; var Password: String): Boolean;
var
  Credential : PCREDENTIALW;
  Size       : Integer;
  s          : String;
  i          : Integer;
begin
  Result := CredReadW(PChar(CredentialName), CRED_TYPE_GENERIC, 0, Credential);

  if Result then
  begin
    UserName := Credential.UserName;

    Size := Credential.CredentialBlobSize div sizeof(Char);

    Password := '';

    i := 0;
    SetLength(s, Size);

    CopyMemory(@s[1], Credential.CredentialBlob, Credential.CredentialBlobSize);

    while i <= Size do
    begin
      if s[i] <> #0 then
        Password := Password + s[i];

      Inc(i);
    end;

  end;

end;

end.
