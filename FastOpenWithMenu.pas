unit FastOpenWithMenu;

interface

uses
  ShellApi, Windows, Graphics, ActiveX, ComObj, ShlObj;

const
  MENU_ITEM_CAPTION = 'Fast Open &With';
  MENU_ITEM_SHIFTON = 'Fast Open &With Settings';
  MENU_ITEM_FOLDER  = 'Fast Open &With Folder';

type

  TFastOpenWithMenu = class(TComObject, IUnknown, IContextMenu, IShellExtInit)
  private
    fFileName: string;
    fOpenOnly: Boolean;
    fFastOpenWithPath: string;
  protected
    { IContextMenu }
    function QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast,
      uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd: UINT_PTR; uFlags: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
    { IShellExtInit }
    function IShellExtInit.Initialize = InitShellExt;
    function InitShellExt (pidlFolder: PItemIDList; lpdobj: IDataObject;
      hKeyProgID: HKEY): HResult; stdcall;
    function GetFastOpenWithDir: string;
  end;

  TFastOpenWithMenuFactory = class (TComObjectFactory)
  public
    procedure UpdateRegistry (ARegister: Boolean); override;
  end;

const
  Class_FastOpenWithMenuMenu: TGUID = '{E8F5FF52-2F10-4118-8635-7572F006CFE5}';

implementation

uses
  ComServ, Messages, SysUtils, Registry;

{ TFastOpenWithMenu }

function TFastOpenWithMenu.GetCommandString(idCmd: UINT_PTR; uFlags: UINT;
  pwReserved: PUINT; pszName: LPSTR; cchMax: UINT): HResult;
begin

end;

function TFastOpenWithMenu.GetFastOpenWithDir: string;
var
  szBuf: array of WideChar;
  szBuf2: WideString;
  dwBufLen: DWORD;
  dwRet: DWORD;
begin
  Result := '';
  dwBufLen := MAX_PATH;

  repeat
    SetLength(szBuf, dwBufLen);
    dwRet := GetModuleFileNameW(HInstance, PWideChar(szBuf), dwBufLen);

    if dwRet < dwBufLen then Break;

    dwBufLen := dwBufLen * 2;
  until False;

  if dwRet > 0 then
  begin
    SetLength(szBuf, dwRet + 1);
    szBuf2 := PWideChar(szBuf);
    Result := IncludeTrailingPathDelimiter(ExtractFileDir(szBuf2)) + 'FastOpenWith.exe';
  end;

end;

function TFastOpenWithMenu.InitShellExt(pidlFolder: PItemIDList;
  lpdobj: IDataObject; hKeyProgID: HKEY): HResult;
begin

end;

function TFastOpenWithMenu.InvokeCommand(
  var lpici: TCMInvokeCommandInfo): HResult;
begin

end;

function TFastOpenWithMenu.QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst,
  idCmdLast, uFlags: UINT): HResult;
begin

end;

{ TFastOpenWithMenuFactory }

procedure TFastOpenWithMenuFactory.UpdateRegistry(ARegister: Boolean);
begin
  inherited;

end;

end.
