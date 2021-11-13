unit Icon.Renderers.Legacy;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  Icon.Renderers,
  Helpers.Images.Generator,
  GdiPlus;

type
  TLegacyIconRenderer = class(TInterfacedObject, IIconRenderer)
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

{ TLegacyIconRenderer }

constructor TLegacyIconRenderer.Create(Options: TIconsOptions);
begin
  inherited Create;

  FOptions := Options;
end;

function TLegacyIconRenderer.GenerateIcon(IconParams: TIconParams; Dpi: Integer): HICON;
begin
  Result := GenerateGPBitmapFromRes(GetIconListName(Dpi),
    IconParamsToIndexes(IconParams),
    1, 0,
    TPoint.Create(Dpi, Dpi)).GetHIcon;
end;

function TLegacyIconRenderer.GenerateImage(IconParams: TIconParams; Dpi: Integer): HBITMAP;
begin
  Result := GenerateGPBitmapFromRes(GetImageListName(Dpi),
    IconParamsToIndexes(IconParams),
    1, 0,
    TPoint.Create(Dpi, Dpi)).GetHBitmap(TGPColor.Transparent);
end;

function TLegacyIconRenderer.IconParamsToIndexes(
  IconParams: TIconParams): TIconIndexes;
const
  Desktop = 0;
  Background = 1;
  Frame = 2;
  Shape = 3;
begin
  Result := [Desktop];

  if IconParams.SkypeSharing then Result := Result + [Shape];
  if IconParams.OverlappedContent then Result := Result + [Background];
  if IconParams.SkypeSharing then Result := Result + [Frame];
end;

function TLegacyIconRenderer.GetIconListName(Dpi: Integer): string;
begin
  if Dpi <= 96  then Exit('OldIconList16');
  if Dpi <= 120 then Exit('OldIconList20');
  if Dpi <= 144 then Exit('OldIconList24');
  Exit('OldIconList32');
end;

function TLegacyIconRenderer.GetImageListName(Dpi: Integer): string;
begin
  if Dpi <= 96  then Exit('OldImageList32');
  if Dpi <= 120 then Exit('OldImageList44');
  if Dpi <= 144 then Exit('OldImageList44');
  Exit('OldImageList44');
end;

end.
