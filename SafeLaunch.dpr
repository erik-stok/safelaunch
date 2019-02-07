program SafeLaunch;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uCredentials in 'uCredentials.pas';

var
  UserName: String;
  Password: String;
  Credential: String;
begin
  if (ParamCount <> 2) or
     ((ParamStr(1) <> 'a') and (ParamStr(1) <> 'u') and (ParamStr(1) <> 'p')) then
  begin
    Writeln('Invalid parameters, use SafeLaunch.exe <a|u|p> <CredentialName>');
    Writeln('where a = all, u = username only, p=password only');
    ExitCode := -1;
  end
  else
  begin
    Credential := ParamStr(2);
    ReadCredentials(Credential, UserName, Password);

    if (ParamStr(1) = 'a') or (ParamStr(1) = 'u') then
      Writeln(UserName);

    if (ParamStr(1) = 'a') or (ParamStr(1) = 'p') then
      Writeln(Password);
  end;


end.
