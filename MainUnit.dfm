object DesktopManagerForm: TDesktopManagerForm
  Left = 196
  Top = 149
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'DesktopManagerForm'
  ClientHeight = 246
  ClientWidth = 257
  Color = clWindow
  Ctl3D = False
  DefaultMonitor = dmDesktop
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      257
      45)
    object LabelAppName: TLabel
      Left = 51
      Top = 5
      Width = 191
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'LabelAppName'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      OnClick = LabelAppInfoClick
    end
    object ImageIcon: TImage
      Left = 10
      Top = 3
      Width = 36
      Height = 36
      Center = True
      Transparent = True
      OnClick = LabelAppInfoClick
    end
    object LabelAppInfo: TLabel
      Left = 51
      Top = 22
      Width = 190
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'LabelAppInfo'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Visible = False
      OnClick = LabelAppInfoClick
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 203
    Width = 257
    Height = 43
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clMenu
    Constraints.MinHeight = 43
    ParentBackground = False
    TabOrder = 2
    object LinkGridPanel: TGridPanel
      Left = 0
      Top = 0
      Width = 257
      Height = 43
      Align = alTop
      BevelOuter = bvNone
      Caption = 'LinkGridPanel'
      Color = clMenu
      ColumnCollection = <
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = Link
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      ShowCaption = False
      TabOrder = 0
      DesignSize = (
        257
        43)
      object Link: TStaticText
        Left = 115
        Top = 12
        Width = 26
        Height = 19
        Margins.Left = 19
        Margins.Top = 14
        Margins.Right = 19
        Margins.Bottom = 8
        Alignment = taCenter
        Anchors = []
        Caption = 'Link'
        ShowAccelChar = False
        TabOrder = 0
        TabStop = True
        OnClick = LinkClick
      end
    end
  end
  object PanelConfig: TPanel
    Left = 0
    Top = 45
    Width = 257
    Height = 158
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 4
    Padding.Top = 5
    Padding.Right = 4
    Padding.Bottom = 12
    ParentColor = True
    TabOrder = 1
    object LabelConfig: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 5
      Width = 225
      Height = 15
      Margins.Left = 12
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 2
      Align = alTop
      Alignment = taCenter
      Caption = 'Config'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGrayText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 36
    end
    object CheckBoxBackground: TCheckBox
      AlignWithMargins = True
      Left = 20
      Top = 51
      Width = 217
      Height = 17
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Background'
      TabOrder = 1
      OnClick = CheckBoxBackgroundClick
    end
    object CheckBoxAnimation: TCheckBox
      AlignWithMargins = True
      Left = 20
      Top = 76
      Width = 217
      Height = 17
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Animation'
      TabOrder = 2
      OnClick = CheckBoxAnimationClick
    end
    object CheckBoxSkypeCorners: TCheckBox
      AlignWithMargins = True
      Left = 20
      Top = 26
      Width = 217
      Height = 17
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alTop
      Caption = 'SkypeCorners'
      TabOrder = 0
      OnClick = CheckBoxSkypeCornersClick
    end
    object CheckBoxListboxSmoothScrolling: TCheckBox
      AlignWithMargins = True
      Left = 20
      Top = 125
      Width = 217
      Height = 17
      Margins.Left = 16
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alTop
      Caption = 'ListboxSmoothScrolling'
      TabOrder = 4
      OnClick = CheckBoxListboxSmoothScrollingClick
    end
    object CheckBoxUIEffects: TCheckBox
      AlignWithMargins = True
      Left = 20
      Top = 101
      Width = 217
      Height = 17
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alTop
      Caption = 'UIEffects'
      TabOrder = 3
      OnClick = CheckBoxUIEffectsClick
    end
  end
  object PopupMenuTray: TPopupMenu
    Left = 168
    Top = 96
    object TrayMenuPersonalization: TMenuItem
      Caption = 'Personalization'
      OnClick = TrayMenuPersonalizationClick
    end
    object TrayMenuSeparator1: TMenuItem
      Caption = '-'
    end
    object TrayMenuSkypeCorners: TMenuItem
      AutoCheck = True
      Caption = 'SkypeCorners'
      OnClick = TrayMenuSkypeCornersClick
    end
    object TrayMenuBackground: TMenuItem
      AutoCheck = True
      Caption = 'Background'
      OnClick = TrayMenuBackgroundClick
    end
    object TrayMenuAnimation: TMenuItem
      AutoCheck = True
      Caption = 'Animation'
      OnClick = TrayMenuAnimationClick
    end
    object TrayMenuUIEffects: TMenuItem
      AutoCheck = True
      Caption = 'UIEffects'
      OnClick = TrayMenuUIEffectsClick
    end
    object TrayMenuListboxSmoothScrolling: TMenuItem
      AutoCheck = True
      Caption = 'ListboxSmoothScrolling'
      OnClick = TrayMenuListboxSmoothScrollingClick
    end
    object TrayMenuSeparator2: TMenuItem
      Caption = '-'
    end
    object TrayMenuAutorun: TMenuItem
      AutoCheck = True
      Caption = 'Autorun'
      OnClick = TrayMenuAutorunClick
    end
    object TrayMenuAutoUpdate: TMenuItem
      Caption = 'AutoUpdate'
      object TrayMenuAutoUpdateEnable: TMenuItem
        AutoCheck = True
        Caption = 'Enable'
        OnClick = TrayMenuAutoUpdateEnableClick
      end
      object TrayMenuAutoUpdateCheck: TMenuItem
        Caption = 'Check'
        OnClick = TrayMenuAutoUpdateCheckClick
      end
    end
    object TrayMenuIconStyle: TMenuItem
      Caption = 'IconStyle'
      object TrayMenuIconStyleOld: TMenuItem
        AutoCheck = True
        Caption = 'IconStyleOld'
        RadioItem = True
        OnClick = TrayMenuIconStyleOldClick
      end
      object TrayMenuIconStyleWin8: TMenuItem
        AutoCheck = True
        Caption = 'IconStyleWin8'
        RadioItem = True
        OnClick = TrayMenuIconStyleWin8Click
      end
      object TrayMenuIconStyleWin10: TMenuItem
        AutoCheck = True
        Caption = 'IconStyleWin10'
        RadioItem = True
        OnClick = TrayMenuIconStyleWin10Click
      end
      object TrayMenuIconStyleWin11: TMenuItem
        AutoCheck = True
        Caption = 'IconStyleWin11'
        RadioItem = True
        OnClick = TrayMenuIconStyleWin11Click
      end
    end
    object TrayMenuLanguage: TMenuItem
      Caption = 'Language'
      object TrayMenuLanguageSystem: TMenuItem
        AutoCheck = True
        Caption = 'System'
        RadioItem = True
        OnClick = TrayMenuLanguageItemClick
      end
      object TrayMenuSeparator5: TMenuItem
        Caption = '-'
      end
    end
    object TrayMenuDisableSystemBorder: TMenuItem
      AutoCheck = True
      Caption = 'DisableSystemBorder'
      OnClick = TrayMenuDisableSystemBorderClick
    end
    object TrayMenuSeparator3: TMenuItem
      Caption = '-'
    end
    object TrayMenuWebsite: TMenuItem
      Caption = 'Website'
      OnClick = TrayMenuWebsiteClick
    end
    object TrayMenuSeparator4: TMenuItem
      Caption = '-'
    end
    object TrayMenuClose: TMenuItem
      Caption = 'Close'
      OnClick = TrayMenuCloseClick
    end
  end
end
