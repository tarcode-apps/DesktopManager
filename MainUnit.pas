unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.Classes, System.Win.Registry,
  System.Generics.Collections, System.Generics.Defaults,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons,
  Autorun.Manager,
  AutoUpdate, AutoUpdate.Scheduler,
  Core.Startup,
  Core.Language, Core.Language.Controls,
  Core.UI, Core.UI.Controls, Core.UI.Notifications,
  Desktop, Desktop.Skype,
  Tray.Notify.Window, Tray.Notify.Controls,
  Icon.Renderers, Icons.Manager,
  Versions, Versions.Info, Versions.Helpers,
  HotKey, HotKey.Handler;

const
  REG_Key = 'Software\Desktop Manager';
  REG_ID = 'ID';
  REG_Version = 'Version';
  REG_IconStyle = 'Icon Style';
  REG_SkypeCorners = 'SkypeCorners';
  REG_AutoUpdateEnable = 'AutoUpdateEnable';
  REG_AutoUpdateLastCheck = 'AutoUpdateLastCheck';
  REG_AutoUpdateSkipVersion = 'AutoUpdateSkipVersion';
  REG_SystemBorder = 'SystemBorder';
  REG_Language = 'Language';
  REG_LanguageId = 'LanguageId';

  HotKeyDesktopBackground = 10;
  HotKeyAnimations = 20;

type
  TConfig = record
    ID: TAppID;
    IconStyle: TIconStyle;
    SkypeCorners: Boolean;
    AutoUpdateEnable: Boolean;
    AutoUpdateLastCheck: TDateTime;
    AutoUpdateSkipVersion: TVersion;
    SystemBorder: TSystemBorder;
  end;

  TUIInfo = (UIInfoHide, UIInfoSN);

type
  TDesktopManagerForm = class(TTrayNotifyWindow)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelConfig: TPanel;
    LabelAppName: TLabel;
    CheckBoxBackground: TCheckBox;
    CheckBoxAnimation: TCheckBox;
    CheckBoxUIEffects: TCheckBox;
    CheckBoxListboxSmoothScrolling: TCheckBox;
    CheckBoxSkypeCorners: TCheckBox;
    LabelConfig: TLabel;
    PopupMenuTray: TPopupMenu;
    TrayMenuPersonalization: TMenuItem;
    TrayMenuBackground: TMenuItem;
    TrayMenuAnimation: TMenuItem;
    TrayMenuUIEffects: TMenuItem;
    TrayMenuListboxSmoothScrolling: TMenuItem;
    TrayMenuSkypeCorners: TMenuItem;
    TrayMenuAutorun: TMenuItem;
    TrayMenuAutoUpdate: TMenuItem;
    TrayMenuAutoUpdateEnable: TMenuItem;
    TrayMenuAutoUpdateCheck: TMenuItem;
    TrayMenuWebsite: TMenuItem;
    TrayMenuSeparator1: TMenuItem;
    TrayMenuSeparator2: TMenuItem;
    TrayMenuSeparator3: TMenuItem;
    TrayMenuClose: TMenuItem;
    ImageIcon: TImage;
    LabelAppInfo: TLabel;
    LinkGridPanel: TGridPanel;
    Link: TStaticText;
    TrayMenuIconStyle: TMenuItem;
    TrayMenuIconStyleOld: TMenuItem;
    TrayMenuIconStyleWin8: TMenuItem;
    TrayMenuIconStyleWin10: TMenuItem;
    TrayMenuIconStyleWin11: TMenuItem;
    TrayMenuLanguage: TMenuItem;
    TrayMenuLanguageSystem: TMenuItem;
    TrayMenuSeparator5: TMenuItem;
    TrayMenuDisableSystemBorder: TMenuItem;
    TrayMenuSeparator4: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure LinkClick(Sender: TObject);

    procedure TrayMenuPersonalizationClick(Sender: TObject);
    procedure TrayMenuBackgroundClick(Sender: TObject);
    procedure TrayMenuAnimationClick(Sender: TObject);
    procedure TrayMenuSkypeCornersClick(Sender: TObject);
    procedure TrayMenuAutorunClick(Sender: TObject);
    procedure TrayMenuAutoUpdateEnableClick(Sender: TObject);
    procedure TrayMenuAutoUpdateCheckClick(Sender: TObject);
    procedure TrayMenuWebsiteClick(Sender: TObject);
    procedure TrayMenuCloseClick(Sender: TObject);

    procedure CheckBoxBackgroundClick(Sender: TObject);
    procedure CheckBoxAnimationClick(Sender: TObject);
    procedure CheckBoxUIEffectsClick(Sender: TObject);
    procedure CheckBoxListboxSmoothScrollingClick(Sender: TObject);
    procedure CheckBoxSkypeCornersClick(Sender: TObject);

    procedure LabelAppInfoClick(Sender: TObject);
    procedure TrayMenuUIEffectsClick(Sender: TObject);
    procedure TrayMenuListboxSmoothScrollingClick(Sender: TObject);
    procedure TrayMenuIconStyleOldClick(Sender: TObject);
    procedure TrayMenuIconStyleWin8Click(Sender: TObject);
    procedure TrayMenuIconStyleWin10Click(Sender: TObject);
    procedure TrayMenuIconStyleWin11Click(Sender: TObject);
    procedure TrayMenuLanguageItemClick(Sender: TObject);
    procedure TrayMenuDisableSystemBorderClick(Sender: TObject);

    procedure TrayNotifyUpdateAvalible(Sender: TObject; Value: Integer);
    procedure TrayNotifyUpdateFail(Sender: TObject; Value: Integer);
    procedure TrayIconPopupMenu(Sender: TObject; Shift: TShiftState);
  protected
    procedure LoadIcon; override;
    procedure Loadlocalization;
    procedure LoadAvailableLocalizetions;
    procedure DoSystemUsesLightThemeChange(LightTheme: Boolean); override;
    procedure DoSystemBorderChanged(var SystemBorder: TSystemBorder); override;

    function DefaultConfig: TConfig;
    function LoadConfig: TConfig;
    procedure SaveConfig(Conf: TConfig);
    procedure SaveCurrentConfig;
    procedure DeleteConfig;
  private
    LockerAutorun: ILocker;
    LockerDesktopBackground: ILocker;
    LockerAnimations: ILocker;
    LockerUIEffects: ILocker;
    LockerListboxSmoothScrolling: ILocker;
    LockerSaveConfig: ILocker;
    LockerSystemBorder: ILocker;
    LockerSkypeCorners: ILocker;

    FUIInfo: TUIInfo;

    AutoUpdateScheduler: TAutoUpdateScheduler;

    HotKeyHandler: THotKeyHendler;

    FIconsManager: TIconsManager;

    procedure AutorunManagerAutorun(Sender: TObject; Enable: Boolean);

    procedure UpdateTrayMenuHotKey;
    procedure HotKeyHandlerEnabled(Sender: TObject; Enable: Boolean);
    procedure HotKeyHandlerHotKey(Sender: TObject; Index: THotKeyIndex);
    procedure HotKeyHandlerChange(Sender: TObject; Index: THotKeyIndex);

    procedure OpenPersonalization;

    procedure SetUIInfo(const Value: TUIInfo);

    procedure IconHelperChange(Sender: TObject);

    function GetIconOptions: TIconsOptions;

    procedure DesktopManagerDisableOverlappedContent(Sender: TObject; Capable: Boolean; State: Boolean);
    procedure DesktopManagerClientAreaAnimation(Sender: TObject; Capable: Boolean; State: Boolean);
    procedure DesktopManagerUIEffects(Sender: TObject; Capable: Boolean; State: Boolean);
    procedure DesktopManagerListboxSmoothScrolling(Sender: TObject; Capable: Boolean; State: Boolean);

    procedure SkypeCornersStateChange(Sender: TObject; State: Boolean);
    procedure SkypeCornersSharingChange(Sender: TObject; Sharing: Boolean);

    procedure AutoUpdateSchedulerInCheck(Sender: TObject);
    procedure AutoUpdateSchedulerChecked(Sender: TObject);
    procedure AutoUpdateSchedulerSaveLastCheck(Sender: TObject; Time: TDateTime);
    procedure AutoUpdateSchedulerInstalling(Sender: TObject);
    procedure AutoUpdateSchedulerSkip(Sender: TObject; Version: TVersion);
    procedure AutoUpdateSchedulerAvalible(Sender: TObject; Version: TVersion);

    procedure WMThemeChanged(var Message: TMessage); message WM_THEMECHANGED;
  public
    property UIInfo: TUIInfo read FUIInfo write SetUIInfo;
    property IconOptions: TIconsOptions read GetIconOptions;
  end;

var
  DesktopManagerForm: TDesktopManagerForm;

implementation

{$R *.dfm}

procedure TDesktopManagerForm.FormCreate(Sender: TObject);
var
  Conf: TConfig;
begin
  // Инициализация блокировщиков событий
  LockerAutorun                 := TLocker.Create;
  LockerDesktopBackground       := TLocker.Create;
  LockerAnimations              := TLocker.Create;
  LockerUIEffects               := TLocker.Create;
  LockerListboxSmoothScrolling  := TLocker.Create;
  LockerSystemBorder            := TLocker.Create;
  LockerSaveConfig              := TLocker.Create;
  LockerSkypeCorners            := TLocker.Create;

  // Загрузка конфигурации
  Conf := LoadConfig;

  // Инициализация интерфейса
  Link.LinkMode           := True;
  PanelTop.Shape          := psBottomLine;
  PanelTop.Style          := tfpsHeader;
  PanelConfig.Shape       := psBottomLine;
  PanelConfig.Style       := tfpsBody;
  PanelBottom.Style       := tfpsLinkArea;
  LabelAppName.Caption    := TVersionInfo.ProductName;
  UIInfo                  := Low(UIInfo);

  LabelAppInfo.Font.Name := Font.Name;
  LabelAppInfo.Font.Size := Font.Size;
  LabelConfig.Font.Name := Font.Name;
  LabelConfig.Font.Size := Font.Size;

  CheckBoxSkypeCorners.AutoSize           := True;
  CheckBoxBackground.AutoSize             := True;
  CheckBoxAnimation.AutoSize              := True;
  CheckBoxUIEffects.AutoSize              := True;
  CheckBoxListboxSmoothScrolling.AutoSize := True;

  CheckBoxSkypeCorners.AdditionalSpace            := True;
  CheckBoxBackground.AdditionalSpace              := True;
  CheckBoxAnimation.AdditionalSpace               := True;
  CheckBoxUIEffects.AdditionalSpace               := True;
  CheckBoxListboxSmoothScrolling.AdditionalSpace  := True;

  SystemBorder := Conf.SystemBorder;

  // Инициализация трея
  TrayIcon.PopupMenu := PopupMenuTray;
  TrayIcon.Icon := Application.Icon.Handle;
  TrayIcon.OnPopupMenu := TrayIconPopupMenu;

  // Инициализация Notification
  TNotificationService.Notification := TrayNotification;

  // Инициализация автозагрузки
  AutorunManager.OnAutorun := AutorunManagerAutorun;

  // Icons
  FIconsManager := TIconsManager.Create;
  IconOptions.IconStyle := Conf.IconStyle;
  IconOptions.IconStyle := Conf.IconStyle;
  if IsSystemUsesLightTheme then
    IconOptions.IconTheme := ithDark
  else
    IconOptions.IconTheme := ithLight;
  IconOptions.TrayIconDark := TrayIcon.IsTrayIconDark;
  IconOptions.OnChange2 := IconHelperChange;

  TrayMenuIconStyleOld.Checked    := Conf.IconStyle = isOld;
  TrayMenuIconStyleWin8.Checked   := Conf.IconStyle = isWin8;
  TrayMenuIconStyleWin10.Checked  := Conf.IconStyle = isWin10;
  TrayMenuIconStyleWin11.Checked  := Conf.IconStyle = isWin11;

  // Инициализация TDesktopManager
  TDesktopManager.OnDisableOverlappedContent := DesktopManagerDisableOverlappedContent;
  TDesktopManager.OnClientAreaAnimation := DesktopManagerClientAreaAnimation;
  TDesktopManager.OnUIEffects := DesktopManagerUIEffects;
  TDesktopManager.OnListboxSmoothScrolling := DesktopManagerListboxSmoothScrolling;

  // Инициализация TSkypeCorners
  TSkypeCorners.OnStateChange:= SkypeCornersStateChange;
  TSkypeCorners.OnSkypeSharingChange:= SkypeCornersSharingChange;
  TSkypeCorners.Enable:= Conf.SkypeCorners;

  // Инициализация горячих клавиш
  HotKeyHandler := THotKeyHendler.Create;
  HotKeyHandler.OnHotKey := HotKeyHandlerHotKey;
  HotKeyHandler.OnChange := HotKeyHandlerChange;
  HotKeyHandler.OnEnabled := HotKeyHandlerEnabled;
  HotKeyHandler.RegisterHotKey(HotKeyDesktopBackground, THotKeyValue.Create(MOD_CONTROL or MOD_WIN, VK_OEM_6));
  HotKeyHandler.RegisterHotKey(HotKeyAnimations, THotKeyValue.Create(MOD_CONTROL or MOD_WIN, VK_OEM_4));
  HotKeyHandler.Enabled := True;

  // Инициализация AutoUpdateScheduler
  AutoUpdateScheduler := TAutoUpdateScheduler.Create(TLang[40],
    Conf.AutoUpdateLastCheck, Conf.AutoUpdateSkipVersion, Conf.ID);
  AutoUpdateScheduler.OnInCheck := AutoUpdateSchedulerInCheck;
  AutoUpdateScheduler.OnChecked := AutoUpdateSchedulerChecked;
  AutoUpdateScheduler.OnSaveLastCheck := AutoUpdateSchedulerSaveLastCheck;
  AutoUpdateScheduler.OnInstalling := AutoUpdateSchedulerInstalling;
  AutoUpdateScheduler.OnSkip := AutoUpdateSchedulerSkip;
  AutoUpdateScheduler.OnAvalible := AutoUpdateSchedulerAvalible;
  AutoUpdateScheduler.Enable := Conf.AutoUpdateEnable;

  TrayMenuAutoUpdateEnable.Checked := AutoUpdateScheduler.Enable;

  // Загрузка локализации
  LoadAvailableLocalizetions;
  Loadlocalization;

  // Отображение иконки в трее
  TrayIcon.Visible := True;

  case AutoUpdateScheduler.StartupUpdateStatus of
    susComplete: TrayNotification.Notify(Format(TLang[45], [TVersionInfo.FileVersion.ToString]));
    susFail: TrayNotification.Notify(Format(TLang[46], [TVersionInfo.FileVersion.ToString]), [nfError], TrayNotifyUpdateFail);
  end;
end;

procedure TDesktopManagerForm.FormDestroy(Sender: TObject);
begin
  if WindowCreated and not LockerSaveConfig.IsLocked then
    SaveCurrentConfig;

  AutoUpdateScheduler.Free;

  HotKeyHandler.Free;
end;

procedure TDesktopManagerForm.FormDeactivate(Sender: TObject);
begin
  UIInfo := Low(UIInfo);
end;

procedure TDesktopManagerForm.FormShow(Sender: TObject);
begin
  PanelConfig.Realign;
end;

{$REGION 'TDesktopManagerForm Events'}
procedure TDesktopManagerForm.LabelAppInfoClick(Sender: TObject);
begin
  if UIInfo = High(UIInfo) then
    UIInfo := Low(UIInfo)
  else
    UIInfo := Succ(UIInfo);
end;

procedure TDesktopManagerForm.LinkClick(Sender: TObject);
begin
  OpenPersonalization;
end;

procedure TDesktopManagerForm.CheckBoxBackgroundClick(Sender: TObject);
begin
  if LockerDesktopBackground.IsLocked then Exit;
  TDesktopManager.DisableOverlappedContent := not (Sender as TCheckBox).Checked;
end;

procedure TDesktopManagerForm.CheckBoxAnimationClick(Sender: TObject);
begin
  if LockerAnimations.IsLocked then Exit;
  TDesktopManager.ClientAreaAnimation := (Sender as TCheckBox).Checked;
end;

procedure TDesktopManagerForm.CheckBoxUIEffectsClick(Sender: TObject);
begin
  if LockerUIEffects.IsLocked then Exit;
  TDesktopManager.UIEffects := (Sender as TCheckBox).Checked;
end;

procedure TDesktopManagerForm.CheckBoxListboxSmoothScrollingClick(
  Sender: TObject);
begin
  if LockerListboxSmoothScrolling.IsLocked then Exit;
  TDesktopManager.ListboxSmoothScrolling := (Sender as TCheckBox).Checked;
end;

procedure TDesktopManagerForm.CheckBoxSkypeCornersClick(Sender: TObject);
begin
  if LockerSkypeCorners.IsLocked then Exit;
  TSkypeCorners.Enable := (Sender as TCheckBox).Checked;
end;

procedure TDesktopManagerForm.TrayMenuPersonalizationClick(Sender: TObject);
begin
  OpenPersonalization;
end;

procedure TDesktopManagerForm.TrayMenuBackgroundClick(Sender: TObject);
begin
  if LockerDesktopBackground.IsLocked then Exit;
  TDesktopManager.DisableOverlappedContent := not (Sender as TMenuItem).Checked;
end;

procedure TDesktopManagerForm.TrayMenuAnimationClick(Sender: TObject);
begin
  if LockerAnimations.IsLocked then Exit;
  TDesktopManager.ClientAreaAnimation := (Sender as TMenuItem).Checked;
end;

procedure TDesktopManagerForm.TrayMenuUIEffectsClick(Sender: TObject);
begin
  if LockerUIEffects.IsLocked then Exit;
  TDesktopManager.UIEffects := (Sender as TMenuItem).Checked;
end;

procedure TDesktopManagerForm.TrayMenuListboxSmoothScrollingClick(
  Sender: TObject);
begin
  if LockerListboxSmoothScrolling.IsLocked then Exit;
  TDesktopManager.ListboxSmoothScrolling := (Sender as TMenuItem).Checked;
end;

procedure TDesktopManagerForm.TrayMenuSkypeCornersClick(Sender: TObject);
begin
  if LockerSkypeCorners.IsLocked then Exit;
  TSkypeCorners.Enable := (Sender as TMenuItem).Checked;
end;

procedure TDesktopManagerForm.TrayMenuAutorunClick(Sender: TObject);
begin
  if LockerAutorun.IsLocked then Exit;
  AutorunManager.SetAutorunEx((Sender as TMenuItem).Checked);
  SetForegroundWindow(TrayIcon.Handle);
end;

procedure TDesktopManagerForm.TrayMenuAutoUpdateEnableClick(Sender: TObject);
begin
  AutoUpdateScheduler.Enable := (Sender as TMenuItem).Checked;
end;

procedure TDesktopManagerForm.TrayMenuAutoUpdateCheckClick(Sender: TObject);
begin
  AutoUpdateScheduler.Check(True);
end;

procedure TDesktopManagerForm.TrayMenuWebsiteClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', LPTSTR(TLang[12]), nil, nil, SW_RESTORE);
end;

procedure TDesktopManagerForm.TrayMenuCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDesktopManagerForm.TrayMenuIconStyleOldClick(Sender: TObject);
begin
  IconOptions.IconStyle := isOld;
end;

procedure TDesktopManagerForm.TrayMenuIconStyleWin8Click(Sender: TObject);
begin
  IconOptions.IconStyle := isWin8;
end;

procedure TDesktopManagerForm.TrayMenuIconStyleWin10Click(Sender: TObject);
begin
  IconOptions.IconStyle := isWin10;
end;

procedure TDesktopManagerForm.TrayMenuIconStyleWin11Click(Sender: TObject);
begin
  IconOptions.IconStyle := isWin11;
end;

procedure TDesktopManagerForm.TrayMenuLanguageItemClick(Sender: TObject);
var
  NewLanguageId, LastEffectiveLanguageId: LANGID;
  StartUpInfo : TStartUpInfo;
  ProcessInfo : TProcessInformation;
begin
  if (Sender is TLanguageMenuItem) then
    NewLanguageId := (Sender as TLanguageMenuItem).Localization.LanguageId
  else
    NewLanguageId := 0;

  if TLang.LanguageId = NewLanguageId then Exit;

  LastEffectiveLanguageId := TLang.EffectiveLanguageId;
  TLang.LanguageId := NewLanguageId;
  if LastEffectiveLanguageId = TLang.EffectiveLanguageId then Exit;

  Loadlocalization;

  SaveCurrentConfig;

  TMutexLocker.Unlock;
  TrayIcon.Visible := False;

  ZeroMemory(@StartUpInfo, SizeOf(StartUpInfo));
  StartUpInfo.cb := SizeOf(StartUpInfo);

  if not CreateProcess(LPCTSTR(Application.ExeName), nil, nil, nil, True,
    GetPriorityClass(GetCurrentProcess), nil, nil, StartUpInfo, ProcessInfo) then
  begin
    TMutexLocker.Lock;
    TrayIcon.Visible := True;
    Exit;
  end;

  LockerSaveConfig.Lock;
  try
    Application.Terminate;
  finally
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);

    ExitProcess(0);
  end;
end;

procedure TDesktopManagerForm.TrayMenuDisableSystemBorderClick(Sender: TObject);
begin
  if LockerSystemBorder.IsLocked then Exit;

  if (Sender as TMenuItem).Checked then
    SystemBorder := sbWithoutBorder
  else
    SystemBorder := sbDefault;
end;

procedure TDesktopManagerForm.TrayNotifyUpdateAvalible(Sender: TObject; Value: Integer);
begin
  SetForegroundWindow(TrayIcon.Handle);
  AutoUpdateScheduler.Check(True);
end;

procedure TDesktopManagerForm.TrayNotifyUpdateFail(Sender: TObject; Value: Integer);
begin
  ShellExecute(Handle, 'open', LPTSTR(TLang.GetString(12)), nil, nil, SW_RESTORE);
end;

procedure TDesktopManagerForm.TrayIconPopupMenu(Sender: TObject;
  Shift: TShiftState);
begin
  TrayMenuDisableSystemBorder.Visible   := (SystemBorder <> sbDefault) or
                                           ((ssShift in Shift) and IsWindowsVistaOrGreater) or
                                           IsWindows10OrGreater;
end;
{$ENDREGION}

{$REGION 'TDesktopManager Event'}
procedure TDesktopManagerForm.DesktopManagerDisableOverlappedContent(
  Sender: TObject; Capable, State: Boolean);
begin
  LockerDesktopBackground.Lock;

  PanelConfig.AutoSize := False;
  PanelConfig.DisableAlign;
  try
    CheckBoxBackground.Visible := Capable;
    TrayMenuBackground.Visible := Capable;

    CheckBoxBackground.Checked := not State;
    TrayMenuBackground.Checked := not State;

    if not State then
      TrayIcon.Hint := TLang[1] + sLineBreak + TLang[4]
    else
      TrayIcon.Hint := TLang[1] + sLineBreak + TLang[5];

    LoadIcon;
  finally
    PanelConfig.EnableAlign;
    PanelConfig.AutoSize := True;
    LockerDesktopBackground.Unlock;
  end;
end;

procedure TDesktopManagerForm.DesktopManagerClientAreaAnimation(Sender: TObject;
  Capable, State: Boolean);
begin
  LockerAnimations.Lock;
  PanelConfig.AutoSize := False;
  PanelConfig.DisableAlign;
  try
    CheckBoxAnimation.Visible := Capable;
    TrayMenuAnimation.Visible := Capable;

    CheckBoxAnimation.Checked := State;
    TrayMenuAnimation.Checked := State;
  finally
    PanelConfig.EnableAlign;
    PanelConfig.AutoSize := True;
    LockerAnimations.Unlock;
  end;
end;

procedure TDesktopManagerForm.DesktopManagerUIEffects(Sender: TObject; Capable,
  State: Boolean);
begin
  LockerUIEffects.Lock;
  PanelConfig.AutoSize := False;
  PanelConfig.DisableAlign;
  try
    CheckBoxUIEffects.Visible := Capable;
    TrayMenuUIEffects.Visible := Capable;

    CheckBoxUIEffects.Checked := State;
    TrayMenuUIEffects.Checked := State;

    if Capable then begin
      CheckBoxListboxSmoothScrolling.Enabled := State;
      TrayMenuListboxSmoothScrolling.Enabled := State;
    end;
  finally
    PanelConfig.EnableAlign;
    PanelConfig.AutoSize := True;
    LockerUIEffects.Unlock;
  end;
end;

procedure TDesktopManagerForm.DesktopManagerListboxSmoothScrolling(
  Sender: TObject; Capable, State: Boolean);
begin
  LockerListboxSmoothScrolling.Lock;
  PanelConfig.AutoSize := False;
  PanelConfig.DisableAlign;
  try
    CheckBoxListboxSmoothScrolling.Visible := Capable;
    TrayMenuListboxSmoothScrolling.Visible := Capable;

    CheckBoxListboxSmoothScrolling.Checked := State;
    TrayMenuListboxSmoothScrolling.Checked := State;
  finally
    PanelConfig.EnableAlign;
    PanelConfig.AutoSize := True;
    LockerListboxSmoothScrolling.Unlock;
  end;
end;
{$ENDREGION}

{$REGION 'TSkypeCorners Event'}
procedure TDesktopManagerForm.SkypeCornersStateChange(Sender: TObject;
  State: Boolean);
begin
  LockerSkypeCorners.Lock;
  try
    CheckBoxSkypeCorners.Checked := State;
    TrayMenuSkypeCorners.Checked := State;
  finally
    LockerSkypeCorners.Unlock;
  end;
end;

procedure TDesktopManagerForm.SkypeCornersSharingChange(Sender: TObject;
  Sharing: Boolean);
begin
  LoadIcon;
end;
{$ENDREGION}

{$REGION 'AutoUpdateScheduler Event'}
procedure TDesktopManagerForm.AutoUpdateSchedulerChecked(Sender: TObject);
begin
  TrayMenuAutoUpdateCheck.Enabled := True;
end;

procedure TDesktopManagerForm.AutoUpdateSchedulerInCheck(Sender: TObject);
begin
  TrayMenuAutoUpdateCheck.Enabled := False;
end;

procedure TDesktopManagerForm.AutoUpdateSchedulerInstalling(Sender: TObject);
begin
  SaveCurrentConfig;
  TrayIcon.Visible := False;
  Application.Terminate;
  ExitProcess(0);
end;

procedure TDesktopManagerForm.AutoUpdateSchedulerSaveLastCheck(Sender: TObject;
  Time: TDateTime);
begin
  SaveCurrentConfig;
end;

procedure TDesktopManagerForm.AutoUpdateSchedulerSkip(Sender: TObject;
  Version: TVersion);
begin
  SaveCurrentConfig;
end;

procedure TDesktopManagerForm.AutoUpdateSchedulerAvalible(Sender: TObject;
  Version: TVersion);
begin
  TrayNotification.Notify(Format(TLang[44], [Version.ToString]), TrayNotifyUpdateAvalible);
end;
{$ENDREGION}

procedure TDesktopManagerForm.WMThemeChanged(var Message: TMessage);
begin
  IconOptions.TrayIconDark := TrayIcon.IsTrayIconDark;
end;

procedure TDesktopManagerForm.UpdateTrayMenuHotKey;
var
  HotKeyText: string;
begin
  if HotKeyHandler.Enabled then
    HotKeyText := HotKeyHandler.HotKey[HotKeyDesktopBackground].ToString
  else
    HotKeyText := TLang[91]; // Отключено

  TrayMenuBackground.Caption := Format('%0:s'#9'%1:s', [TLang[3], HotKeyText]); // Показать &обои рабочего стола

  if HotKeyHandler.Enabled then
    HotKeyText := HotKeyHandler.HotKey[HotKeyAnimations].ToString
  else
    HotKeyText := TLang[91]; // Отключено

  TrayMenuAnimation.Caption := Format('%0:s'#9'%1:s', [TLang[7], HotKeyText]); // &Воспроизводить анимацию
end;

procedure TDesktopManagerForm.HotKeyHandlerEnabled(Sender: TObject;
  Enable: Boolean);
begin
  UpdateTrayMenuHotKey;
end;

procedure TDesktopManagerForm.HotKeyHandlerHotKey(Sender: TObject;
  Index: THotKeyIndex);
begin
  case Index of
    HotKeyDesktopBackground: TDesktopManager.DisableOverlappedContent := not TDesktopManager.DisableOverlappedContent;
    HotKeyAnimations: TDesktopManager.ClientAreaAnimation := not TDesktopManager.ClientAreaAnimation;
  end;
end;

procedure TDesktopManagerForm.HotKeyHandlerChange(Sender: TObject;
  Index: THotKeyIndex);
begin
  case Index of
    HotKeyDesktopBackground: UpdateTrayMenuHotKey;
    HotKeyAnimations: UpdateTrayMenuHotKey;
  end;
end;

procedure TDesktopManagerForm.AutorunManagerAutorun(Sender: TObject; Enable: Boolean);
begin
  LockerAutorun.Lock;
  try
    TrayMenuAutorun.Checked := Enable;
  finally
    LockerAutorun.Unlock;
  end;
end;

procedure TDesktopManagerForm.OpenPersonalization;
begin
  if IsWindowsVistaOrGreater then
    ShellExecute(0, 'open', 'Shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}', '', '', SW_RESTORE)
  else
    WinExec('control desk.cpl', SW_RESTORE);
end;

procedure TDesktopManagerForm.LoadIcon;
var
  IconParams: TIconParams;
begin
  IconParams.Create(not TDesktopManager.DisableOverlappedContent, TSkypeCorners.SkypeSharing);

  TrayIcon.Icon := FIconsManager.GetIcon(IconParams, GetCurrentPPI);

  if IsWindowsVistaOrGreater then
  begin
    DeleteObject(ImageIcon.Picture.Bitmap.Handle);
    ImageIcon.Picture.Bitmap.Handle := FIconsManager.GetImage(IconParams, GetCurrentPPI);
  end
  else
  begin
    DeleteObject(ImageIcon.Picture.Icon.Handle);
    ImageIcon.Picture.Icon.Handle := FIconsManager.GetImageAsIcon(IconParams, GetCurrentPPI);
  end;
end;

procedure TDesktopManagerForm.Loadlocalization;
  function GetInternationalization(Index: Integer): string;
  var
    NonLocalized: string;
  begin
    Result := TLang[Index];
    NonLocalized := TLang.GetString(Index, TLang.DefaultLang);
    if Result <> NonLocalized then
      Result := Result + ' (' + NonLocalized + ')';
  end;
begin
  LabelAppName.Caption            := TLang[1];  // Desktop Manager
  LabelConfig.Caption             := TLang[2];  // Параметры программы:
  CheckBoxBackground.Caption      := TLang[3];  // Показать фон Windows
  CheckBoxAnimation.Caption       := TLang[7];  // Воспроизводить анимацию
  CheckBoxUIEffects.Caption       := TLang[21]; // UI эффекты
  CheckBoxListboxSmoothScrolling.Caption:= TLang[22]; // Гладкое прокручивание списков
  CheckBoxSkypeCorners.Caption    := TLang[20]; // Отключить рамку Skype
  Link.Caption                    := TLang[8];  // Персонализация
  TrayMenuPersonalization.Caption := TLang[8];  // Персонализация
  TrayMenuUIEffects.Caption       := TLang[21]; // UI эффекты
  TrayMenuListboxSmoothScrolling.Caption:= TLang[22]; // Гладкое прокручивание списков
  TrayMenuSkypeCorners.Caption    := TLang[20]; // Отключить рамку Skype
  TrayMenuAutorun.Caption         := TLang[6];  // Автозапуск
  TrayMenuWebsite.Caption         := TLang[11]; // Посетить &сайт Desktop Manager
  TrayMenuClose.Caption           := TLang[9];  // Выход

  TrayMenuAutoUpdate.Caption        := TLang[41]; // Автоматическое обновление
  TrayMenuAutoUpdateEnable.Caption  := TLang[42]; // Автоматическая проверка обновлений
  TrayMenuAutoUpdateCheck.Caption   := TLang[43]; // Проверить на наличие обновлений

  TrayMenuIconStyle.Caption         := TLang[70]; // Стиль значков
  TrayMenuIconStyleOld.Caption      := TLang[74]; // По умолчанию
  TrayMenuIconStyleWin8.Caption     := TLang[72]; // Windows 8
  TrayMenuIconStyleWin10.Caption    := TLang[73]; // Windows 10
  TrayMenuIconStyleWin11.Caption    := TLang[75]; // Windows 11

  TrayMenuDisableSystemBorder.Caption := TLang[130]; // Отключить заголовок окна

  TrayMenuLanguage.Caption            := GetInternationalization(150);
  TrayMenuLanguageSystem.Caption      := GetInternationalization(151);

  if not TDesktopManager.DisableOverlappedContent then
    TrayIcon.Hint := TLang[1] + sLineBreak + TLang[4]  // Показать фон Windows
  else
    TrayIcon.Hint := TLang[1] + sLineBreak + TLang[5]; // Скрыть фон Windows

  TrayIcon.BalloonTitle  := TLang[1]; // Desktop Manager
  TrayNotification.Title := TLang[1]; // Desktop Manager
end;

procedure TDesktopManagerForm.LoadAvailableLocalizetions;
var
  AvailableLocalizations: TAvailableLocalizations;
  Localization: TAvailableLocalization;
  MenuItem: TMenuItem;
begin
  AvailableLocalizations := TLang.GetAvailableLocalizations(0);
  AvailableLocalizations.Sort(TComparer<TAvailableLocalization>.Construct(
    function(const Left, Right: TAvailableLocalization): Integer
    begin
      Result := string.Compare(
        Left.Value,
        Right.Value,
        [coLingIgnoreCase],
        MAKELCID(TLang.LanguageId, SORT_DEFAULT));
    end
  ));
  try
    for Localization in AvailableLocalizations do
    begin
      MenuItem := TLanguageMenuItem.Create(PopupMenuTray, Localization);
      MenuItem.OnClick := TrayMenuLanguageItemClick;
      MenuItem.Checked := Localization.LanguageId = TLang.LanguageId;

      TrayMenuLanguage.Add(MenuItem);
    end;

    TrayMenuLanguageSystem.Checked := TLang.LanguageId = 0;
  finally
    AvailableLocalizations.Free;
  end;
end;

procedure TDesktopManagerForm.DoSystemUsesLightThemeChange(LightTheme: Boolean);
begin
  inherited;

  if LightTheme then
    IconOptions.IconTheme := ithDark
  else
    IconOptions.IconTheme := ithLight;
end;

procedure TDesktopManagerForm.DoSystemBorderChanged(var SystemBorder: TSystemBorder);
begin
  inherited;

  LockerSystemBorder.Lock;
  try
    TrayMenuDisableSystemBorder.Checked := SystemBorder = sbWithoutBorder;
  finally
    LockerSystemBorder.Unlock;
  end;
end;

procedure TDesktopManagerForm.SetUIInfo(const Value: TUIInfo);
const
  VerFmt = '%0:s: %1:s %2:s';
begin
  FUIInfo := Value;
  case Value of
    UIInfoSN: begin
      LabelAppInfo.Visible := True;
      LabelAppInfo.Caption := Format(VerFmt,
        [TLang[10], string(TVersionInfo.FileVersion), TVersionInfo.BinaryTypeAsShortString]);
    end;
    else begin
      LabelAppInfo.Visible := False;
    end;
  end;
end;

procedure TDesktopManagerForm.IconHelperChange(Sender: TObject);
begin
  LoadIcon;
end;

function TDesktopManagerForm.GetIconOptions: TIconsOptions;
begin
  Result := FIconsManager.Options;
end;

{$REGION 'Config'}
function TDesktopManagerForm.DefaultConfig: TConfig;
begin
  Result.ID := TAutoUpdateScheduler.NewID;
  Result.IconStyle := TIconsOptions.DefaultIconStyle;
  Result.SystemBorder := sbDefault;
  Result.AutoUpdateEnable := True;
  Result.AutoUpdateLastCheck := 0;
  Result.AutoUpdateSkipVersion := TVersion.Empty;
  Result.SkypeCorners := True;
end;

function TDesktopManagerForm.LoadConfig: TConfig;
var
  Default: TConfig;
  Registry: TRegistry;

  function ReadBoolDef(const Name: string; const Def: Boolean): Boolean;
  begin
    if Registry.ValueExists(Name) then
      Result := Registry.ReadBool(Name)
    else
      Result := Def;
  end;

  function ReadIntegerDef(const Name: string; const Def: Integer): Integer;
  begin
    if Registry.ValueExists(Name) then
      Result := Registry.ReadInteger(Name)
    else
      Result := Def;
  end;

  function ReadStringDef(const Name: string; const Def: string): string;
  begin
    if Registry.ValueExists(Name) then
      Result := Registry.ReadString(Name)
    else
      Result := Def;
  end;
begin
  Default := DefaultConfig;
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if not Registry.KeyExists(REG_Key) then Exit(Default);
    if not Registry.OpenKeyReadOnly(REG_Key) then Exit(Default);

    // Read config
    Result.ID := ReadIntegerDef(REG_ID, Default.ID);
    Result.IconStyle := TIconStyle(ReadIntegerDef(REG_IconStyle, Integer(Default.IconStyle)));
    Result.SystemBorder := TSystemBorder(ReadIntegerDef(REG_SystemBorder, Integer(Default.SystemBorder)));
    Result.AutoUpdateEnable := ReadBoolDef(REG_AutoUpdateEnable, Default.AutoUpdateEnable);
    Result.AutoUpdateLastCheck := StrToDateTimeDef(ReadStringDef(REG_AutoUpdateLastCheck, ''), Default.AutoUpdateLastCheck);
    Result.AutoUpdateSkipVersion := ReadStringDef(REG_AutoUpdateSkipVersion, Default.AutoUpdateSkipVersion);
    Result.SkypeCorners := ReadBoolDef(REG_SkypeCorners, True);
    // end read config

    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure TDesktopManagerForm.SaveConfig(Conf: TConfig);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey(REG_Key, True) then begin
      // Write config
      Registry.WriteInteger(REG_ID, Conf.ID);
      Registry.WriteString(REG_Version, TVersionInfo.FileVersion); // Last version
      Registry.WriteInteger(REG_LanguageId, TLang.LanguageId);

      Registry.WriteInteger(REG_IconStyle, Integer(Conf.IconStyle));
      Registry.WriteInteger(REG_SystemBorder, Integer(Conf.SystemBorder));
      Registry.WriteBool(REG_AutoUpdateEnable, Conf.AutoUpdateEnable);
      Registry.WriteString(REG_AutoUpdateLastCheck, DateTimeToStr(Conf.AutoUpdateLastCheck));
      Registry.WriteString(REG_AutoUpdateSkipVersion, Conf.AutoUpdateSkipVersion);
      Registry.WriteBool(REG_SkypeCorners, Conf.SkypeCorners);
      // end write config

      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;

procedure TDesktopManagerForm.SaveCurrentConfig;
var
  Conf: TConfig;
begin
  Conf.ID := AutoUpdateScheduler.ID;
  Conf.IconStyle := IconOptions.IconStyle;
  Conf.SystemBorder := SystemBorder;
  Conf.AutoUpdateEnable := AutoUpdateScheduler.Enable;
  Conf.AutoUpdateLastCheck := AutoUpdateScheduler.LastCheck;
  Conf.AutoUpdateSkipVersion := AutoUpdateScheduler.SkipVersion;
  Conf.SkypeCorners := TSkypeCorners.Enable;

  SaveConfig(Conf);
end;

procedure TDesktopManagerForm.DeleteConfig;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.DeleteKey(REG_Key);
  finally
    Registry.Free;
  end;
end;
{$ENDREGION}

end.
