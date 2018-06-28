inherited PctSpeciesFch: TPctSpeciesFch
  Caption = 'PctSpeciesFch'
  ClientHeight = 172
  ClientWidth = 322
  PixelsPerInch = 96
  TextHeight = 13
  object edtSpecies: TmrDBEdit [0]
    Left = 104
    Top = 73
    Width = 153
    Height = 21
    DataBinding.DataSource = dsFch
    DataBinding.DataField = 'Species'
    Properties.ReadOnly = False
    Style.Color = clWindow
    Style.StyleController = DMPetCenter.cxStyleController
    TabOrder = 0
    EditLabel.Width = 43
    EditLabel.Height = 13
    EditLabel.Caption = 'Species :'
    LabelPosition = lpLeft
    LabelSpacing = 6
    Required = False
    Locked = False
  end
  inherited pnlBottom: TPanel
    Top = 144
    Width = 322
    TabOrder = 1
    inherited btnOk: TXiButton
      Left = 167
    end
    inherited btnCancel: TXiButton
      Left = 245
    end
    object btnEditReport: TXiButton
      Left = 89
      Top = 3
      Width = 75
      Height = 24
      ColorFace = 14737632
      ColorGrad = 3653375
      ColorDark = 11447982
      ColorLight = 16250871
      ColorBorder = 6447714
      ColorText = clBlack
      OverColorFace = 13619151
      OverColorGrad = 41968
      OverColorDark = 7960953
      OverColorLight = 15658734
      OverColorBorder = 7697781
      OverColorText = clBlack
      DownColorFace = 13882323
      DownColorGrad = 7852799
      DownColorDark = 15329769
      DownColorLight = 8158332
      DownColorBorder = 5131854
      DownColorText = clBlack
      DisabledColorFace = 14869218
      DisabledColorGrad = clWhite
      DisabledColorDark = 14211288
      DisabledColorLight = 15395562
      DisabledColorBorder = 12895428
      DisabledColorText = clGray
      ColorFocusRect = 9079434
      ColorScheme = csSilver
      Ctl3D = True
      Layout = blGlyphLeft
      Glyph.Data = {
        76030000424D7603000000000000360000002800000011000000100000000100
        1800000000004003000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FFC8C6C3806850806050806050
        706050705840705840705040705040604830604830604830A29A92FF00FFFF00
        FF00FF00FFC1C4C3A38D85E0D0C0B0A090B0A090B0A090B0A090B0A090B0A090
        B0A090B0A090B0A090B0A090604830FF00FFFF00FF00FF00FFBCB7B0B29C94FF
        E8E0FFF8F0FFF0E0FFE8E0F0D8D0F0D0B0F0C0A000A00000A00000A000705840
        604830857767FF00FF00FF00FFB29485E0D8D0FFFFFFFFFFFFFFFFFFFFFFFFFF
        F0F0F0E0E0F0D8C000FF1000FFB000A000806850705040604830FF00FF00FF00
        FFB09080F0E8E0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F0F0E8E000FF1000
        FF1000A000907060706050604830FF00FF00FF00FFB09880D0C0B0D0B8B0C0B0
        A0B0A090B09880A0888090807090706080686080605070585090807080686070
        5840FF00FF00FF00FFC0A090FFF8F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFF8F0FFF0F0F0F0F0F0E8E0A08880907860806050FF00FF00FF00FFCEC9C3
        B6A18CD0B0A0C0A8A0D0B0A0C0A090B09080A080709070608060507060508070
        60B0A090A08870806050FF00FF00FF00FFFF00FFCBC7C2C0B0A0E0C8C0FFFFFF
        FFF8FFFFF8FFFFF0F0F0F0E0F0E0E0C0A8A0806050A09080C0B0A0806050FF00
        FF00FF00FFFF00FFFF00FFDEDFDDC0B0A0FFFFFFF0E8E0D0C8C0D0C8C0D0B8B0
        D0C0B0E0D0D0806860806050B09890B0A090FF00FF00FF00FFFF00FFFF00FFFF
        00FFD8CBBCF0E8E0FFFFFFFFFFFFFFFFFFFFF8FFFFF0F0F0E0D0D0B8B0806050
        BAADA8FF00FFFF00FF00FF00FFFF00FFFF00FFFF00FFE5E5E6D0B8B0FFFFFFF0
        F0F0D0C8C0D0C8C0D0B8B0C0B0B0E0D8D0807060866859FF00FFFF00FF00FF00
        FFFF00FFFF00FFFF00FFFF00FFDED5D3E0D1D1FFFFFFFFFFFFFFFFFFFFFFFFFF
        F8FFF0E8E0D0B8B0806050FF00FFFF00FF00FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFDFD6D3D0C0B0D0C0B0D0C0B0D0C0B0D0C0B0D0C0B0D0C0B0D0C0B0FF
        00FFFF00FF00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00}
      Spacing = 4
      TransparentGlyph = True
      Gradient = False
      HotTrack = True
      Anchors = [akTop, akRight]
      Caption = '&Warranty'
      TabOrder = 6
      OnClick = btnEditReportClick
    end
  end
  inherited pnlTitulo: TPanel
    Width = 322
    TabOrder = 2
    inherited lbLoop: TLabel
      Left = 267
    end
    inherited btnLoop: TXiButton
      Left = 294
    end
  end
  inherited dsFch: TDataSource
    Left = 88
    Top = 40
  end
  inherited PrintFch: TPrintDialog
    Left = 144
    Top = 44
  end
  inherited ConfigFch: TmrConfigFch
    Connection = 'PetCenterConn'
    ProviderName = 'dspSpecies'
    Left = 28
    Top = 44
  end
end