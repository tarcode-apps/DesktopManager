unit Icon.Renderers.Default;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  Icon.Renderers,
  Helpers.Images.Generator,
  GdiPlus;

type
  TDefaultIconRenderer = class(TInterfacedObject, IIconRenderer)
  strict private type
    TIconIndexes = array of Integer;
  strict private
    FOptions: TIconsOptions;

    function IconParamsToIndexes(IconParams: TIconParams): TIconIndexes;
    function GetIconListName(Dpi: Integer): string;
    function GetImageListName(Dpi: Integer): string;
  public
    constructor Create(Options: TIconsOptions); reintroduce;

    function GenerateIcon(IconParams: TIconParams; Dpi: Integer): HICON;
    function GenerateImage(IconParams: TIconParams; Dpi: Integer): HBITMAP;
  end;

implementation

{ TDefaultIconRenderer }

constructor TDefaultIconRenderer.Create(Options: TIconsOptions);
begin
  inherited Create;

  FOptions := Options;
end;

function TDefaultIconRenderer.GenerateIcon(IconParams: TIconParams; Dpi: Integer): HICON;
var
  Line: Byte;
begin
  Line := 0;
  case FOptions.IconStyle of
    isWin10:
      if (FOptions.IconTheme = ithDark) or FOptions.TrayIconDark then Line := 1;
    else
      if FOptions.IconTheme = ithDark then Line := 1;
  end;

  Result := GenerateGPBitmapFromRes(GetIconListName(Dpi),
    IconParamsToIndexes(IconParams),
    2, Line,
    TPoint.Create(Dpi, Dpi)).GetHIcon;
end;

function TDefaultIconRenderer.GenerateImage(IconParams: TIconParams; Dpi: Integer): HBITMAP;
begin
  Result := GenerateGPBitmapFromRes(GetImageListName(Dpi),
    IconParamsToIndexes(IconParams),
    1, 0,
    TPoint.Create(Dpi, Dpi)).GetHBitmap(TGPColor.Transparent);
end;

function TDefaultIconRenderer.IconParamsToIndexes(
  IconParams: TIconParams): TIconIndexes;
const
  Desktop = 0;
  BackgroundOff = 1;
  BackgroundOn = 2;
  Frame = 3;
  Shape = 4;
begin
  Result := [Desktop];

  if IconParams.OverlappedContent then
    Result := Result + [BackgroundOn]
  else
    Result := Result + [BackgroundOff];

  if IconParams.SkypeSharing then Result := Result + [Frame, Shape];
end;

function TDefaultIconRenderer.GetIconListName(Dpi: Integer): string;
begin
  case FOptions.IconStyle of
    isWin11:
    begin
      if Dpi <= 96  then Exit('Win11Icons16');
      if Dpi <= 120 then Exit('Win11Icons20');
      if Dpi <= 144 then Exit('Win11Icons24');
      Exit('Win11Icons32');
    end;
    isWin10:
    begin
      if Dpi <= 96  then Exit('Win10IconList16');
      if Dpi <= 120 then Exit('Win10IconList20');
      if Dpi <= 144 then Exit('Win10IconList24');
      Exit('Win10IconList32');
    end;
    else begin
      if Dpi <= 96  then Exit('Win8IconList16');
      if Dpi <= 120 then Exit('Win8IconList20');
      if Dpi <= 144 then Exit('Win8IconList24');
      Exit('Win8IconList32');
    end;
  end;
end;

function TDefaultIconRenderer.GetImageListName(Dpi: Integer): string;
begin
  case FOptions.IconStyle of
    isWin11:
    begin
      if Dpi <= 96  then Exit('Win11Images32');
      if Dpi <= 120 then Exit('Win11Images44');
      if Dpi <= 144 then Exit('Win11Images44');
      Exit('Win11Images44');
    end;
    isWin10:
    begin
      if Dpi <= 96  then Exit('Win10ImageList32');
      if Dpi <= 120 then Exit('Win10ImageList44');
      if Dpi <= 144 then Exit('Win10ImageList44');
      Exit('Win10ImageList44');
    end;
    else begin
      if Dpi <= 96  then Exit('Win8ImageList32');
      if Dpi <= 120 then Exit('Win8ImageList44');
      if Dpi <= 144 then Exit('Win8ImageList44');
      Exit('Win8ImageList44');
    end;
  end;
end;

end.
