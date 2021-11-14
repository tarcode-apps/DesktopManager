program DesktopManager;

{$WEAKLINKRTTI ON}

{$R *.res}

{$R 'EnglishAutorunMessage.res' 'Localization\English\EnglishAutorunMessage.rc'}
{$R 'EnglishAutoUpdate.res' 'Localization\English\EnglishAutoUpdate.rc'}
{$R 'EnglishLocalization.res' 'Localization\English\EnglishLocalization.rc'}
{$R 'EnglishHotKey.res' 'Localization\English\EnglishHotKey.rc'}
{$R 'RussianAutorunMessage.res' 'Localization\Russian\RussianAutorunMessage.rc'}
{$R 'RussianAutoUpdate.res' 'Localization\Russian\RussianAutoUpdate.rc'}
{$R 'RussianLocalization.res' 'Localization\Russian\RussianLocalization.rc'}
{$R 'RussianHotKey.res' 'Localization\Russian\RussianHotKey.rc'}
{$R *.dres}

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Win.Registry,
  Vcl.Forms,
  Autorun in 'Autorun\Autorun.pas',
  Autorun.Manager in 'Autorun\Autorun.Manager.pas',
  Autorun.Providers.Registry in 'Autorun\Autorun.Providers.Registry.pas',
  Autorun.Providers.TaskScheduler2 in 'Autorun\Autorun.Providers.TaskScheduler2.pas',
  AutoUpdate in 'AutoUpdate\AutoUpdate.pas',
  AutoUpdate.Params in 'AutoUpdate\AutoUpdate.Params.pas',
  AutoUpdate.Scheduler in 'AutoUpdate\AutoUpdate.Scheduler.pas',
  AutoUpdate.VersionDefinition in 'AutoUpdate\AutoUpdate.VersionDefinition.pas',
  AutoUpdate.Window.NotFound in 'AutoUpdate\AutoUpdate.Window.NotFound.pas',
  AutoUpdate.Window.Notify in 'AutoUpdate\AutoUpdate.Window.Notify.pas',
  AutoUpdate.Window.Update in 'AutoUpdate\AutoUpdate.Window.Update.pas',
  HotKey in 'HotKey\HotKey.pas',
  HotKey.Handler in 'HotKey\HotKey.Handler.pas',
  Icon.Renderers.Default in 'Icon.Renderers\Icon.Renderers.Default.pas',
  Icon.Renderers.Legacy in 'Icon.Renderers\Icon.Renderers.Legacy.pas',
  Icon.Renderers in 'Icon.Renderers\Icon.Renderers.pas',
  Icons.Manager in 'Icons.Manager.pas',
  GdiPlus in 'Libs\GdiPlus.pas',
  GdiPlusHelpers in 'Libs\GdiPlusHelpers.pas',
  TaskSchd in 'Libs\TaskSchd.pas',
  WinHttp_TLB in 'Libs\WinHttp_TLB.pas',
  Core.Language in 'Core.Language.pas',
  Core.Language.Controls in 'Core.Language.Controls.pas',
  Core.Startup in 'Core.Startup.pas',
  Core.Startup.Tasks in 'Core.Startup.Tasks.pas',
  Core.UI in 'Core.UI.pas',
  Core.UI.Controls in 'Core.UI.Controls.pas',
  Core.UI.Notifications in 'Core.UI.Notifications.pas',
  Desktop in 'Desktop.pas',
  Desktop.Skype in 'Desktop.Skype.pas',
  Helpers.Images.Generator in 'Helpers.Images.Generator.pas',
  Helpers.License in 'Helpers.License.pas',
  Helpers.Services in 'Helpers.Services.pas',
  Helpers.Wts in 'Helpers.Wts.pas',
  MainUnit in 'MainUnit.pas' {DesktopManagerForm},
  Tray.Helpers in 'Tray.Helpers.pas',
  Tray.Icon in 'Tray.Icon.pas',
  Tray.Icon.Notifications in 'Tray.Icon.Notifications.pas',
  Tray.Notify.Controls in 'Tray.Notify.Controls.pas',
  Tray.Notify.Window in 'Tray.Notify.Window.pas',
  Versions in 'Versions.pas',
  Versions.Helpers in 'Versions.Helpers.pas',
  Versions.Info in 'Versions.Info.pas';

{$SETPEFlAGS IMAGE_FILE_DEBUG_STRIPPED or IMAGE_FILE_LINE_NUMS_STRIPPED or IMAGE_FILE_LOCAL_SYMS_STRIPPED or IMAGE_FILE_RELOCS_STRIPPED}

var
  Wnd: HWND;
  i: Integer;
  CallExit: Boolean;
  ExitCode: UINT;
  Registry: TRegistry;

begin
  Registry := TRegistry.Create;
  try
    try
      Registry.RootKey := HKEY_CURRENT_USER;
      if Registry.KeyExists(REG_Key) then
        if Registry.OpenKeyReadOnly(REG_Key) then
        try
          if Registry.ValueExists(REG_LanguageId) then
            TLang.LanguageId := Registry.ReadInteger(REG_LanguageId)
          else if Registry.ValueExists(REG_Language) then
            TLang.LanguageId := TLang.LocaleNameToLCID(Registry.ReadString(REG_Language));
        finally
          Registry.CloseKey;
        end;
    finally
      Registry.Free;
    end;
  except
    TLang.GetStringRes(HInstance, 0, TLang.EffectiveLanguageId);
  end;

  //TLang.LanguageId := MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US);       // 1033 (0x0409)

  AutorunManager.AddProvider(TRegistryProvider.Create, True, True);
  AutorunManager.AddProvider(TTaskScheduler2Provider.Create, False, False);

  CallExit := False;
  ExitCode := TTasks.ERROR_Ok;
  for i := 1 to ParamCount do
    ExitCode := ExitCode or TTasks.Perform(ParamStr(i), CallExit);
  if CallExit then ExitProcess(ExitCode);

  // Проверка запущеной копии программы
  TMutexLocker.Init('DesktopManagerMutex');
  TMutexLocker.Lock;
  if TMutexLocker.IsExist then
  begin
    Wnd := FindWindow('TDesktopManagerForm', nil);
    if Wnd <> 0 then begin
      ShowWindowAsync(Wnd, SW_SHOW);
      SetForegroundWindow(Wnd);
    end;
    TMutexLocker.Unlock;
    ExitProcess(TTasks.ERROR_Mutex);
  end;

  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := TLang[1];
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDesktopManagerForm, DesktopManagerForm);
  Application.Run;

  TMutexLocker.Unlock;
end.
