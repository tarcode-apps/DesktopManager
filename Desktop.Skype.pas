unit Desktop.Skype;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.Classes,
  Versions.Helpers;

type
  TEventStateChange = procedure(Sender: TObject; State: Boolean) of object;
  TEventSkypeSharingChange = procedure(Sender: TObject; Sharing: Boolean) of object;

  TSkypeVersion = (sv7, sv8, svSfb, svSfbApp);
  TSkypeWindow = record
    Wnd: HWND;
    Version: TSkypeVersion;
    class function Find: TSkypeWindow; static;
    constructor Create(aWnd: HWND; aVersion: TSkypeVersion);
    function IsAvailable: Boolean; inline;
    procedure Hide; inline;
  end;

  TSkypeCorners = class
  private const
    nIDEvent = $800;
    uElapse = UINT(4000);
    ulTolerance = ULONG(1000);
  private
    class var FEnable: Boolean;
    class var FSkypeSharing: Boolean;
    class var FOnStateChange: TEventStateChange;
    class var FOnSkypeSharingChange: TEventSkypeSharingChange;
    class var uIDEvent: UINT_PTR;

    class constructor Create;
    class destructor Destroy;

    class procedure CheckSkypeWindowState;
    class procedure TimerProc(wnd: HWND; uMsg: UINT; idEvent: UINT_PTR; dwTime: DWORD); stdcall; static;
    class procedure SetEnable(const Value: Boolean); static;
    class function GetEnable: Boolean; static;
    class procedure SetOnStateChange(const Value: TEventStateChange); static;
    class procedure SetOnSkypeSharingChange(const Value: TEventSkypeSharingChange); static;
  public
    class property Enable: Boolean read GetEnable write SetEnable;
    class property SkypeSharing: Boolean read FSkypeSharing;
    class property OnStateChange: TEventStateChange read FOnStateChange write SetOnStateChange;
    class property OnSkypeSharingChange: TEventSkypeSharingChange read FOnSkypeSharingChange write SetOnSkypeSharingChange;
  end;

{$EXTERNALSYM SetCoalescableTimer}
function SetCoalescableTimer(
  hWnd: HWND;
  nIDEvent: UIntPtr;
  uElapse: UINT;
  lpTimerFunc: TFNTimerProc;
  uToleranceDelay: ULONG): UIntPtr; stdcall;

implementation

{ TSkypeWindowInfo }

class function TSkypeWindow.Find: TSkypeWindow;
var
  Wnd: HWND;
begin
  // Skype 7 and earlier
  Wnd := FindWindow('TSimpleSelection', '');
  if Wnd <> 0 then Exit(TSkypeWindow.Create(Wnd, sv7));

  // Skype 8
  Wnd := FindWindow('ScreenBorderWindow', '');
  if Wnd <> 0 then Exit(TSkypeWindow.Create(Wnd, sv8));

  // Skype For Business Window Sharing
  Wnd := FindWindow('LyncAppSharingSharedWindowChrome', '');
  if Wnd <> 0 then Exit(TSkypeWindow.Create(Wnd, svSfbApp));

  // Skype For Business Desktop Sharing
  Wnd := FindWindow('AppSharing_TransparentFrame', '');
  Exit(TSkypeWindow.Create(Wnd, svSfb));
end;

constructor TSkypeWindow.Create(aWnd: HWND; aVersion: TSkypeVersion);
begin
  Wnd := aWnd;
  Version := aVersion;
end;

function TSkypeWindow.IsAvailable: Boolean;
begin
  Result := Wnd <> 0;
end;

procedure TSkypeWindow.Hide;
begin
  if not IsAvailable then Exit;
  case Version of
    sv7, sv8:
      if IsWindowVisible(Wnd) then ShowWindow(Wnd, SW_HIDE);
    svSfb, svSfbApp:
      begin
        SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) or WS_EX_LAYERED);
        SetLayeredWindowAttributes(Wnd, 0, 0, LWA_ALPHA);
      end;
  end;
end;

{ TSkypeCorners }

class procedure TSkypeCorners.CheckSkypeWindowState;
var
  SkypeWindow: TSkypeWindow;
  Sharing: Boolean;
begin
  SkypeWindow := TSkypeWindow.Find;
  Sharing := SkypeWindow.IsAvailable;

  if Sharing then SkypeWindow.Hide;

  if FSkypeSharing <> Sharing then begin
    FSkypeSharing := Sharing;
    if Assigned(FOnSkypeSharingChange) then FOnSkypeSharingChange(nil, FSkypeSharing);
  end;
end;

class procedure TSkypeCorners.SetEnable(const Value: Boolean);
begin
  if FEnable = Value then Exit;

  if Value then begin
    if IsWindows8OrGreater then
      uIDEvent := SetCoalescableTimer(0, nIDEvent, uElapse, @TimerProc, ulTolerance)
    else
      uIDEvent := SetTimer(0, nIDEvent, uElapse, @TimerProc);
    FEnable := uIDEvent <> 0;
    if FEnable then CheckSkypeWindowState;
  end else begin
    FEnable := FEnable and (not KillTimer(0, uIDEvent));
    FSkypeSharing := False;
    if Assigned(FOnSkypeSharingChange) then FOnSkypeSharingChange(nil, FSkypeSharing);
  end;

  if Assigned(FOnStateChange) then FOnStateChange(nil, FEnable);
end;

class function TSkypeCorners.GetEnable: Boolean;
begin
  Result := FEnable;
end;

class procedure TSkypeCorners.SetOnStateChange(
  const Value: TEventStateChange);
begin
  FOnStateChange := Value;
  if Assigned(FOnStateChange) then FOnStateChange(nil, GetEnable);
end;

class procedure TSkypeCorners.SetOnSkypeSharingChange(const Value: TEventSkypeSharingChange);
begin
  FOnSkypeSharingChange := Value;
  if Assigned(FOnSkypeSharingChange) then FOnSkypeSharingChange(nil, FSkypeSharing);
end;

class procedure TSkypeCorners.TimerProc(wnd: HWND; uMsg: UINT; idEvent: UINT_PTR; dwTime: DWORD);
begin
  CheckSkypeWindowState;
end;

class constructor TSkypeCorners.Create;
begin
  FEnable := False;
  FSkypeSharing := False;
  FOnStateChange := nil;
  FOnSkypeSharingChange := nil;
  uIDEvent := 0;
end;

class destructor TSkypeCorners.Destroy;
begin
  if uIDEvent <> 0 then KillTimer(0, uIDEvent);
end;

{$WARN SYMBOL_PLATFORM OFF}
function SetCoalescableTimer; external user32 delayed;
{$WARN SYMBOL_PLATFORM ON}

end.
