program FastOpenWithGUI;

uses
  Vcl.Forms,
  FastOpenWith.Main in 'FastOpenWith.Main.pas' {mainForm},
  Vcl.Themes,
  Vcl.Styles,
  FastOpenWithGUI.Settings in 'FastOpenWithGUI.Settings.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  TStyleManager.TrySetStyle('Windows11 Modern Dark');
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
