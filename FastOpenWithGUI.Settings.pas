unit FastOpenWithGUI.Settings;

interface

uses
  System.Classes, System.SysUtils, Rest.Json, Generics.Collections,
  System.Win.Registry, System.IOUtils, Vcl.Dialogs;

type

  TSettings = class(TObject)
  private
    fDefaultApp: string;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property DefaultApp: string read fDefaultApp write fDefaultApp;
  end;

  TSettingsHandler = class(TObject)
  public
    class function LoadSettings(fSettings: string = ''): TSettings;
    class procedure SaveSettings(aSettings: TSettings; fSettings: string = '');
  end;

implementation

const
  DEFAULT_SETTINGS = 'settings.json';

{ TSettingsHandler }

class function TSettingsHandler.LoadSettings(fSettings: string): TSettings;
var
  text: string;
begin

  if fSettings = '' then
    fSettings := ExtractFilePath(ParamStr(0)) + DEFAULT_SETTINGS;

  if FileExists(fSettings) then
  begin
    try
      text := TFile.ReadAllText(fSettings, TEncoding.UTF8);
      Result := TJson.JsonToObject<TSettings>(text);
    except
      on E: Exception do
      begin
        ShowMessage('Error reading settings file: ' + E.Message);
        Result := TSettings.Create;
      end;
    end;
  end
  else
    Result := TSettings.Create;
end;

class procedure TSettingsHandler.SaveSettings(aSettings: TSettings;
  fSettings: string);
var
  json: string;
begin
  if fSettings = '' then
    fSettings := ExtractFilePath(ParamStr(0)) + DEFAULT_SETTINGS;

  try
    json := TJson.ObjectToJsonString(aSettings);
    TFile.WriteAllText(fSettings, json, TEncoding.UTF8);
  except
    on E: Exception do
      ShowMessage('Error saving settings file: ' + E.Message);
  end;
end;

{ TSettings }

constructor TSettings.Create;
begin
  inherited;
end;

destructor TSettings.Destroy;
begin

  inherited;
end;

end.
