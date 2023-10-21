unit FastOpenWith.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ControlList, Vcl.VirtualImage,
  Vcl.StdCtrls, Vcl.WinXPanels, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, FastOpenWithGUI.Settings, System.Actions, Vcl.ActnList,
  Winapi.ShellAPI;

type
  TmainForm = class(TForm)
    ControlList1: TControlList;
    Label1: TLabel;
    VirtualImage1: TVirtualImage;
    Label2: TLabel;
    ControlListButton1: TControlListButton;
    ControlListButton2: TControlListButton;
    CardPanel1: TCardPanel;
    Card1: TCard;
    Card2: TCard;
    VirtualImageList1: TVirtualImageList;
    ActionList1: TActionList;
    actEscape: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actEscapeExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Settings: TSettings;
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

procedure TmainForm.actEscapeExecute(Sender: TObject);
begin
  Close;
end;

procedure TmainForm.FormCreate(Sender: TObject);
begin
  KeyPreview := True;

  Settings := TSettingsHandler.LoadSettings();

  if (ParamCount > 1) and (ParamStr(1) = '/f') then
  begin
    Caption := ParamStr(2);
    //ShellExecute(0, 'OPEN', 'rundll32.exe', PChar('shell32.dll,OpenAs_RunDLL ' + ParamStr(2)), '', SW_SHOWNORMAL);
    // it might also be c:\windows\system32\OpenWith.exe "filepath\filename.fileext"
    ShellExecute(0, 'OPEN', 'OpenWith.exe', PChar('"' + ParamStr(2) +  '"'), '', SW_SHOWNORMAL);
    // OpenWith.exe classname is "Open With"
  end;

  Application.Terminate;
end;

procedure TmainForm.FormDestroy(Sender: TObject);
begin
  Settings.Free;
end;

end.
