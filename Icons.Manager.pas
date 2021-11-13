unit Icons.Manager;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes,
  System.Generics.Collections, System.Generics.Defaults,
  Icon.Renderers,
  Icon.Renderers.Default, Icon.Renderers.Legacy,
  Helpers.Images.Generator,
  Versions.Helpers;

type
  TIconsManager = class
  strict private
    class function IsFlag(b: Byte; Flag: Byte): Boolean; inline; static;
  strict private
    FRenderer: IIconRenderer;

    FOptions: TIconsOptions;

    function GetRenderer: IIconRenderer;
    procedure OptionsChange(Sender: TObject);

    property Renderer: IIconRenderer read GetRenderer;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    function GetIcon(IconParams: TIconParams; Dpi: Integer): HICON;
    function GetImage(IconParams: TIconParams; Dpi: Integer): HBITMAP;
    function GetImageAsIcon(IconParams: TIconParams; Dpi: Integer): HICON;

    property Options: TIconsOptions read FOptions;
  end;

implementation

{ TIconsManager }

class function TIconsManager.IsFlag(b, Flag: Byte): Boolean;
begin
  Result:= b and Flag = Flag;
end;

constructor TIconsManager.Create;
begin
  FOptions := TIconsOptions.Create;
  with FOptions do
  begin
    IconStyle := DefaultIconStyle;
    IconTheme := DefaultIconTheme;
    OnChange := OptionsChange;
  end;
end;

destructor TIconsManager.Destroy;
begin
  FOptions.Free;
end;

function TIconsManager.GetIcon(IconParams: TIconParams; Dpi: Integer): HICON;
begin
  Result := Renderer.GenerateIcon(IconParams, Dpi);
end;

function TIconsManager.GetImage(IconParams: TIconParams; Dpi: Integer): HBITMAP;
begin
  Result := Renderer.GenerateImage(IconParams, Dpi);
end;

function TIconsManager.GetImageAsIcon(IconParams: TIconParams; Dpi: Integer): HICON;
var
  hBmp: HBITMAP;
begin
  hBmp := GetImage(IconParams, Dpi);
  Result := HBitmapToHIcon(hBmp);
  DeleteObject(hBmp);
end;

function TIconsManager.GetRenderer: IIconRenderer;
begin
  if FRenderer <> nil then Exit(FRenderer);

  case FOptions.IconStyle of
    isOld: FRenderer := TLegacyIconRenderer.Create(FOptions);
    isWin8, isWin10: FRenderer := TDefaultIconRenderer.Create(FOptions);
    else raise Exception.Create('Not supported icon style');
  end;
  Result := FRenderer;
end;

procedure TIconsManager.OptionsChange(Sender: TObject);
begin
  FRenderer := nil;
end;

end.
