unit FastOpenWithMenu;

interface

uses
  ShellApi, Windows, Graphics, ActiveX, ComObj, ShlObj;

const
  MENU_ITEM_CAPTION = 'Fast Open &With';
  MENU_ITEM_SHIFTON = 'Fast Open &With Settings';
  MENU_ITEM_FOLDER  = 'Fast Open &With Folder';
  FAST_OPEN_WITH_EXE = 'FastOpenWithGUI.exe';

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
  if (idCmd = 0) and (uFlags = GCS_HELPTEXT) then
  begin
    StrLCopy(pszName, 'Fast Open With', cchMax);
    Result := NOERROR;
  end
  else
    Result := E_INVALIDARG;
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
    Result := IncludeTrailingPathDelimiter(ExtractFileDir(szBuf2)) + FAST_OPEN_WITH_EXE;
  end;

end;

function TFastOpenWithMenu.InitShellExt(pidlFolder: PItemIDList;
  lpdobj: IDataObject; hKeyProgID: HKEY): HResult;
var
  medium: TStgMedium;
  fe: TFormatEtc;
begin
  Result := E_FAIL;

  if Assigned(lpdobj) then
  begin
    with fe do
    begin
      cfFormat := CF_HDROP;
      ptd := nil;
      dwAspect := DVASPECT_CONTENT;
      lindex := -1;
      tymed := TYMED_HGLOBAL;
    end;

    Result := lpdobj.GetData(fe, medium);
    if not Failed(Result) then
    begin
      // check if only one file is selected
      if DragQueryFile(medium.hGlobal, $FFFFFFFF, nil, 0) = 1 then
      begin
        SetLength(fFileName, 1000);
        DragQueryFile(medium.hGlobal, 0, PChar(fFileName), 1000);
        // realign string
        fFileName := PChar(fFileName);
        Result := NOERROR;
      end
      else
        Result := E_FAIL;
    end;
    ReleaseStgMedium(medium);
  end;
end;

function TFastOpenWithMenu.InvokeCommand(
  var lpici: TCMInvokeCommandInfo): HResult;
var
  hwnd: THandle;
  cds: COPYDATASTRUCT;
  fowexe: string;
begin
  Result := NOERROR;
  // Make sure is not being called by an application
  if HiWord(Integer(lpici.lpVerb)) <> 0 then
  begin
    Result := E_FAIL;
    Exit;
  end;
  // Make sure it is not passed an invalid argument number
  if LoWord(NativeInt(lpici.lpVerb)) > 0 then
  begin
    Result := E_INVALIDARG;
    Exit;
  end;
  // Execute the command specified by lpici.lpverb
  if LoWord(NativeInt(lpici.lpVerb)) = 0 then
  begin
    fowexe := GetFastOpenWithDir;
    if FileExists(fowexe) then
    begin
      if fOpenOnly then
        ShellExecuteW(0, 'OPEN', PWideChar(fowexe), nil, nil, SW_SHOWNORMAL)
      else if not fOpenOnly and DirectoryExists(fFileName) then
        ShellExecuteW(0, 'OPEN', PWideChar(fowexe), PWideChar('/d "'+fFileName+'"'), nil, SW_SHOWNORMAL)
      else if not fOpenOnly then
        ShellExecuteW(0, 'OPEN', PWideChar(fowexe), PWideChar('/f "'+fFileName+'"'), nil, SW_SHOWNORMAL);
    end
    else
    begin
      MessageBox(lpici.hwnd, 'Fast Open With executable was not found, make sure the FastOpenWith.exe is next to the Shell Extension DLL',
      'Error',
      MB_ICONERROR or MB_OK);
    end;
  end;
end;

function TFastOpenWithMenu.QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst,
  idCmdLast, uFlags: UINT): HResult;
var
  ContextMenuItem: TMenuItemInfoW;
  MenuCaption: WideString;
  Reg: TRegistry;
begin
  fOpenOnly := (GetAsyncKeyState(VK_SHIFT) < 0);

  if not fOpenOnly  then
  begin
    reg := TRegistry.Create;
    try
      reg.RootKey := HKEY_CURRENT_USER;
      if reg.OpenKeyReadOnly('Software\FastOpenWith') then
      begin
        if reg.ValueExists('MenuLabel') then
          MenuCaption := reg.ReadString('MenuLabel');

        reg.CloseKey;
      end;

    finally
      reg.Free;
    end;

    if not DirectoryExists(fFileName) then
    begin
      if MenuCaption <> '' then
        InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdFirst,
          PWideChar(MenuCaption))
      else
        InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdFirst,
          MENU_ITEM_CAPTION);
      Result := 1; // number of menu items added
    end
    else
    begin
      InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdFirst,
        MENU_ITEM_FOLDER);
      Result := 1;
    end;
  end
  else if fOpenOnly then
  begin
    InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdFirst,
      MENU_ITEM_SHIFTON);
    Result := 1;
  end
  else
    Result := 0;
end;

{ TFastOpenWithMenuFactory }

procedure TFastOpenWithMenuFactory.UpdateRegistry(ARegister: Boolean);
var
  reg: TRegistry;
begin
  inherited UpdateRegistry(ARegister);

  reg := TRegistry.Create;
  reg.RootKey := HKEY_CLASSES_ROOT;
  try
    if ARegister then
      if reg.OpenKey('\*\ShellEx\ContextMenuHandlers\FastOpenWith', True) then
        reg.WriteString('', GUIDToString(Class_FastOpenWithMenuMenu))
    else
      if reg.OpenKey('\*\ShellEx\ContextMenuHandlers\FastOpenWith', False) then
        reg.DeleteKey('\*\ShellEx\ContextMenuHandlers\FastOpenWith');
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

initialization
  TFastOpenWithMenuFactory.Create (
    ComServer, TFastOpenWithMenu, Class_FastOpenWithMenuMenu,
    'FastOpenWithMenu', 'FastOpenWithMenu Shell Extension',
    ciMultiInstance, tmApartment);
end.
