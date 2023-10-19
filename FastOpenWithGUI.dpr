program FastOpenWithGUI;

uses
  Vcl.Forms,
  FastOpenWith.Main in 'FastOpenWith.Main.pas' {mainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
