unit Desktop.Icons;

interface

uses
  Winapi.Windows, Winapi.ActiveX,
  System.Classes,
  Versions.Helpers,
  Helpers.Images.Generator,
  GdiPlus;

type
  TIconStyle = (isOld, isWin8, isWin10);

  TIconParams = record
    OverlappedContent: Boolean;
    SkypeSharing: Boolean;
    constructor Create(OverlappedContent, SkypeSharing: Boolean);
  end;

  TIconHelper = class
  private type
    TIconIndexes = array of Integer;
  private
    class var FIconStyle: TIconStyle;

    class constructor Create;

    class function GetIconListName(Dpi: Integer): string;
    class function GetImageListName(Dpi: Integer): string;
    class procedure SetIconStyle(const Value: TIconStyle); static;

    class function IconParamsToIndexes(IconParams: TIconParams): TIconIndexes;
  public
    class function GetIcon(IconParams: TIconParams; Dpi: Integer): HICON;
    class function GetImage(IconParams: TIconParams; Dpi: Integer): HBITMAP;
    class function GetImageAsIcon(IconParams: TIconParams; Dpi: Integer): HICON;
    class function DefaultIconStyle: TIconStyle;
    class property IconStyle: TIconStyle read FIconStyle write SetIconStyle;
  end;

implementation

{ TIconHelper }

class function TIconHelper.GetIcon(IconParams: TIconParams; Dpi: Integer): HICON;
begin
  Result := GenerateGPBitmapFromRes(GetIconListName(Dpi),
    IconParamsToIndexes(IconParams), TPoint.Create(Dpi, Dpi)).GetHIcon;
end;

class function TIconHelper.GetImage(IconParams: TIconParams; Dpi: Integer): HBITMAP;
begin
  Result := GenerateGPBitmapFromRes(GetImageListName(Dpi),
    IconParamsToIndexes(IconParams), TPoint.Create(Dpi, Dpi)).GetHBitmap(TGPColor.Transparent);
end;

class function TIconHelper.GetImageAsIcon(IconParams: TIconParams;
  Dpi: Integer): HICON;
var
  hBmp: HBITMAP;
begin
  hBmp := GetImage(IconParams, Dpi);
  Result := HBitmapToHIcon(hBmp);
  DeleteObject(hBmp);
end;

class function TIconHelper.IconParamsToIndexes(IconParams: TIconParams): TIconIndexes;
const
  Desktop = 0;
  Background = 1;
  Frame = 2;
  Shape = 3;
begin
  Result := [Desktop];

  if FIconStyle = isOld then
  begin
    if IconParams.SkypeSharing then Result := Result + [Shape];
    if IconParams.OverlappedContent then Result := Result + [Background];
    if IconParams.SkypeSharing then Result := Result + [Frame];
    Exit;
  end;

  if IconParams.OverlappedContent then Result := Result + [Background];
  if IconParams.SkypeSharing then Result := Result + [Frame, Shape];
end;

class procedure TIconHelper.SetIconStyle(const Value: TIconStyle);
begin
  if Value in [Low(TIconStyle) .. High(TIconStyle)] then
    FIconStyle := Value
  else
    FIconStyle := DefaultIconStyle;
end;

class function TIconHelper.GetIconListName(Dpi: Integer): string;
begin
  case FIconStyle of
    isWin8:
    begin
      if Dpi <= 96  then Exit('Win8IconList16');
      if Dpi <= 120 then Exit('Win8IconList20');
      if Dpi <= 144 then Exit('Win8IconList24');
      Exit('Win8IconList32');
    end;
    isWin10:
    begin
      if Dpi <= 96  then Exit('Win10IconList16');
      if Dpi <= 120 then Exit('Win10IconList20');
      if Dpi <= 144 then Exit('Win10IconList24');
      Exit('Win10IconList32');
    end;
    {isWin7:
    begin
      if Dpi <= 96  then Exit('Win7IconList16');
      if Dpi <= 120 then Exit('Win7IconList20');
      if Dpi <= 144 then Exit('Win7IconList24');
      Exit('Win7IconList32');
    end;}
    else begin
      if Dpi <= 96  then Exit('OldIconList16');
      if Dpi <= 120 then Exit('OldIconList20');
      if Dpi <= 144 then Exit('OldIconList24');
      Exit('OldIconList32');
    end;
  end;
end;

class function TIconHelper.GetImageListName(Dpi: Integer): string;
begin
  case FIconStyle of
    isWin8:
    begin
      if Dpi <= 96  then Exit('Win8ImageList32');
      if Dpi <= 120 then Exit('Win8ImageList44');
      if Dpi <= 144 then Exit('Win8ImageList44');
      Exit('Win8ImageList44');
    end;
    isWin10:
    begin
      if Dpi <= 96  then Exit('Win10ImageList32');
      if Dpi <= 120 then Exit('Win10ImageList44');
      if Dpi <= 144 then Exit('Win10ImageList44');
      Exit('Win10ImageList44');
    end;
    {isWin7:
    begin
      if Dpi <= 96  then Exit('Win7ImageList32');
      if Dpi <= 120 then Exit('Win7ImageList40');
      if Dpi <= 144 then Exit('Win7ImageList40');
      Exit('Win7ImageList40');
    end;}
    else begin
      if Dpi <= 96  then Exit('OldImageList32');
      if Dpi <= 120 then Exit('OldImageList44');
      if Dpi <= 144 then Exit('OldImageList44');
      Exit('OldImageList44');
    end;
  end;
end;

class function TIconHelper.DefaultIconStyle: TIconStyle;
begin
  if IsWindows10OrGreater then
    Result := isWin10
  else if IsWindows8OrGreater then
    Result := isWin8
  else if IsWindows7OrGreater then
    Result := isWin8
  else
    Result := isWin8;
end;

class constructor TIconHelper.Create;
begin
  FIconStyle := isWin8;
end;

{ TIconParams }

constructor TIconParams.Create(OverlappedContent, SkypeSharing: Boolean);
begin
  Self.OverlappedContent := OverlappedContent;
  Self.SkypeSharing := SkypeSharing;
end;

end.
