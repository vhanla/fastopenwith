library FastOpenWith;


{.$R *.dres}

uses
  ComServ,
  FastOpenWith_TLB in 'FastOpenWith_TLB.pas',
  FastOpenWithMenu in 'FastOpenWithMenu.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
