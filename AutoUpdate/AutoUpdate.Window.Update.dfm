object AutoUpdateWnd: TAutoUpdateWnd
  Left = 0
  Top = 0
  Caption = 'AutoUpdateWnd'
  ClientHeight = 388
  ClientWidth = 612
  Color = clBtnFace
  Constraints.MinHeight = 181
  Constraints.MinWidth = 460
  DefaultMonitor = dmPrimary
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnAfterMonitorDpiChanged = FormAfterMonitorDpiChanged
  OnBeforeMonitorDpiChanged = FormBeforeMonitorDpiChanged
  PixelsPerInch = 96
  TextHeight = 15
  object PanelImage: TPanel
    Left = 0
    Top = 0
    Width = 65
    Height = 388
    Align = alLeft
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'PanelImage'
    Padding.Left = 26
    Padding.Top = 20
    Padding.Right = 7
    Padding.Bottom = 20
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object Image: TImage
      Left = 26
      Top = 20
      Width = 32
      Height = 348
      Align = alLeft
      AutoSize = True
      ExplicitTop = 26
      ExplicitHeight = 32
    end
  end
  object PanelInfo: TPanel
    Left = 65
    Top = 0
    Width = 547
    Height = 388
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PanelInfo'
    Padding.Top = 16
    Padding.Right = 16
    ParentColor = True
    ShowCaption = False
    TabOrder = 1
    object LabelMessage: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 42
      Width = 531
      Height = 15
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 16
      Align = alTop
      Caption = 'Message'
      ExplicitWidth = 46
    end
    object LabelTitle: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 16
      Width = 531
      Height = 20
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Title'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clHotLight
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 29
    end
    object LabelInfo: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 73
      Width = 531
      Height = 15
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Info'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 23
    end
    object PanelWeb: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 93
      Width = 531
      Height = 246
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = 'PanelWeb'
      Ctl3D = False
      ParentColor = True
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 0
    end
    object PanelButton: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 339
      Width = 531
      Height = 49
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'PanelButton'
      Padding.Top = 12
      Padding.Bottom = 11
      ParentColor = True
      ShowCaption = False
      TabOrder = 1
      object ButtonInstall: TButton
        AlignWithMargins = True
        Left = 443
        Top = 12
        Width = 88
        Height = 26
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = 'Install'
        Default = True
        ModalResult = 6
        TabOrder = 0
      end
      object ButtonSkip: TButton
        AlignWithMargins = True
        Left = 0
        Top = 12
        Width = 88
        Height = 26
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alLeft
        Caption = 'Skip'
        ModalResult = 5
        TabOrder = 2
      end
      object PanelLater: TPanel
        Left = 98
        Top = 12
        Width = 345
        Height = 26
        Align = alClient
        BevelOuter = bvNone
        Caption = 'PanelLater'
        ParentColor = True
        ShowCaption = False
        TabOrder = 1
        object ButtonLater: TButton
          AlignWithMargins = True
          Left = 247
          Top = 0
          Width = 88
          Height = 26
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          Align = alRight
          Cancel = True
          Caption = 'Later'
          ModalResult = 2
          TabOrder = 0
        end
      end
    end
  end
end
