unit Icon.Renderers;

interface

uses
  Winapi.Windows,
  System.Classes,
  Versions.Helpers;

type
  TIconStyle = (isOld, isWin8, isWin10);
  TIconTheme = (ithLight, ithDark);

  TIconParams = record
    OverlappedContent: Boolean;
    SkypeSharing: Boolean;
    constructor Create(aOverlappedContent, aSkypeSharing: Boolean);
  end;

  TIconsOptions = class
  private
    FIconStyle: TIconStyle;
    FIconTheme: TIconTheme;
    FTrayIconDark: Boolean;
    FOnChange: TNotifyEvent;
    FOnChange2: TNotifyEvent;

    procedure SetIconStyle(const Value: TIconStyle);
    procedure SetIconTheme(const Value: TIconTheme);
    procedure SetTrayIconDark(const Value: Boolean);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetOnChange2(const Value: TNotifyEvent);

    procedure DoChange;
  public
    class function DefaultIconStyle: TIconStyle;
    class function DefaultIconTheme: TIconTheme;

    property IconStyle: TIconStyle read FIconStyle write SetIconStyle;
    property IconTheme: TIconTheme read FIconTheme write SetIconTheme;
    property TrayIconDark: Boolean read FTrayIconDark write SetTrayIconDark;

    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property OnChange2: TNotifyEvent read FOnChange2 write SetOnChange2;
  end;

  IIconRenderer = interface
    function GenerateIcon(IconParams: TIconParams; Dpi: Integer): HICON;
    function GenerateImage(IconParams: TIconParams; Dpi: Integer): HBITMAP;
  end;

implementation

{ TIconsOptions }

class function TIconsOptions.DefaultIconStyle: TIconStyle;
begin
  if IsWindows10OrGreater then Exit(isWin10);

  Result := isWin8;
end;

class function TIconsOptions.DefaultIconTheme: TIconTheme;
begin
  Result := ithLight;
end;

procedure TIconsOptions.SetIconStyle(const Value: TIconStyle);
begin
  if Value in [Low(TIconStyle) .. High(TIconStyle)] then
    FIconStyle := Value
  else
    FIconStyle := DefaultIconStyle;

  DoChange;
end;

procedure TIconsOptions.SetIconTheme(const Value: TIconTheme);
begin
  if Value in [Low(TIconTheme) .. High(TIconTheme)] then
    FIconTheme := Value
  else
    FIconTheme := DefaultIconTheme;

  DoChange;
end;

procedure TIconsOptions.SetTrayIconDark(const Value: Boolean);
begin
  FTrayIconDark := Value;
  DoChange;
end;

procedure TIconsOptions.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TIconsOptions.SetOnChange2(const Value: TNotifyEvent);
begin
  FOnChange2 := Value;
end;

procedure TIconsOptions.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
  if Assigned(FOnChange2) then FOnChange2(Self);
end;

{ TIconParams }

constructor TIconParams.Create(aOverlappedContent, aSkypeSharing: Boolean);
begin
  OverlappedContent := aOverlappedContent;
  SkypeSharing := aSkypeSharing;
end;

end.
