inherited brwSize: TbrwSize
  Left = 99
  Top = 85
  HelpContext = 1860
  Caption = 'brwSize'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlMain: TPanel
    inherited pnlButton: TPanelRights
      object btColorGroup: TSpeedButton [11]
        Left = 2
        Top = 222
        Width = 110
        Height = 26
        Caption = 'Horiz. Group'
        Flat = True
        Margin = 7
        OnClick = btColorGroupClick
      end
      object Panel4: TPanel
        Left = 7
        Top = 218
        Width = 101
        Height = 2
        BevelOuter = bvLowered
        TabOrder = 2
      end
    end
    inherited pnlMainBrowse: TPanel
      inherited grdBrowse: TcxGrid
        inherited grdBrowseDB: TcxGridDBTableView
          DataController.Filter.Criteria = {FFFFFFFF0000000000}
          DataController.KeyFieldNames = 'IDSize'
          OptionsView.Footer = False
          object grdBrowseDBIDSize: TcxGridDBColumn
            Caption = 'ID'
            DataBinding.FieldName = 'IDSize'
            Visible = False
          end
          object grdBrowseDBCodSize: TcxGridDBColumn
            Caption = 'Code'
            DataBinding.FieldName = 'CodSize'
          end
          object grdBrowseDBSizeName: TcxGridDBColumn
            Caption = 'Description'
            DataBinding.FieldName = 'SizeName'
          end
        end
      end
    end
  end
  inherited siLang: TsiLangRT
    StorageFile = 'MR_brwSize.sil'
    TranslationData = {
      737443617074696F6E730D0A737448696E74730D0A7374446973706C61794C61
      62656C730D0A7374466F6E74730D0A73744D756C74694C696E65730D0A737444
      6C677343617074696F6E730D0A5761726E696E67015761726E696E670101010D
      0A4572726F72014572726F720101010D0A496E666F726D6174696F6E01496E66
      6F726D6174696F6E0101010D0A436F6E6669726D01436F6E6669726D0101010D
      0A59657301265965730101010D0A4E6F01264E6F0101010D0A4F4B014F4B0101
      010D0A43616E63656C0143616E63656C0101010D0A41626F7274012641626F72
      740101010D0A5265747279012652657472790101010D0A49676E6F7265012649
      676E6F72650101010D0A416C6C0126416C6C0101010D0A4E6F20546F20416C6C
      014E266F20746F20416C6C0101010D0A59657320546F20416C6C015965732074
      6F2026416C6C0101010D0A48656C70012648656C700101010D0A737453747269
      6E67730D0A73744F74686572537472696E67730D0A67726442726F7773652E49
      6E6946696C654E616D65010101010D0A67726442726F7773652E496E69536563
      74696F6E4E616D65010101010D0A67726442726F7773652E4B65794669656C64
      010101010D0A67726442726F7773652E507265766965774669656C644E616D65
      010101010D0A67726442726F7773652E52656769737472795061746801010101
      0D0A67726442726F7773652E53756D6D617279536570617261746F72012C2001
      01010D0A717542726F7773652E436F6D6D616E6454657874010101010D0A7175
      42726F7773652E436F6E6E656374696F6E537472696E67010101010D0A717542
      726F7773652E46696C746572010101010D0A717542726F7773652E496E646578
      4669656C644E616D6573010101010D0A717542726F7773652E496E6465784E61
      6D65010101010D0A717542726F7773652E4B65794669656C6473010101010D0A
      717542726F7773652E4D61737465724669656C6473010101010D0A42726F7773
      65436F6E6669672E44656661756C74427574746F6E01627444657461696C0101
      010D0A42726F777365436F6E6669672E466368436C6173734E616D6501010101
      0D0A42726F777365436F6E6669672E5669657744656C6574655461626C650101
      01010D0A53442E44656661756C74457874012A2E786C730101010D0A53442E46
      696C654E616D65010101010D0A53442E46696C746572014D6963726F736F6674
      20457863656C7C2A2E786C730101010D0A53442E496E697469616C4469720143
      3A5C0101010D0A53442E5469746C65010101010D0A73744C6F63616C65730D0A
      43757272656E637920537472696E6701240101010D0A54686F7573616E642053
      6570617261746F72012C0101010D0A446563696D616C20536570617261746F72
      012E0101010D0A4461746520536570617261746F72012F0101010D0A53686F72
      74204461746520466F726D6174014D2F642F797979790101010D0A4C6F6E6720
      4461746520466F726D617401646464642C204D4D4D4D2064642C207979797901
      01010D0A54696D6520536570617261746F72013A0101010D0A54696D6520414D
      20537472696E6701414D0101010D0A54696D6520504D20537472696E6701504D
      0101010D0A53686F72742054696D6520466F726D617401683A6D6D20414D504D
      0101010D0A4C6F6E672054696D6520466F726D617401683A6D6D3A737320414D
      504D0101010D0A53686F7274204D6F6E7468204E616D6573014A616E2C466562
      2C4D61722C4170722C4D61792C4A756E2C4A756C2C4175672C5365702C4F6374
      2C4E6F762C4465630101010D0A4C6F6E67204D6F6E7468204E616D6573014A61
      6E756172792C46656272756172792C4D617263682C417072696C2C4D61792C4A
      756E652C4A756C792C4175677573742C53657074656D6265722C4F63746F6265
      722C4E6F76656D6265722C446563656D6265720101010D0A53686F7274204461
      79204E616D65730153756E2C4D6F6E2C5475652C5765642C5468752C4672692C
      5361740101010D0A4C6F6E6720446179204E616D65730153756E6461792C4D6F
      6E6461792C547565736461792C5765646E65736461792C54687572736461792C
      4672696461792C53617475726461790101010D0A7374436F6C6C656374696F6E
      730D0A737443686172536574730D0A}
  end
  inherited quBrowse: TPowerADOQuery
    CursorType = ctStatic
    CommandText = 
      'SELECT'#13#10'        IDSize,'#13#10'        CodSize,'#13#10'        SizeName'#13#10'FRO' +
      'M'#13#10'        InvSize (NOLOCK)'
    object quBrowseIDSize: TIntegerField
      FieldName = 'IDSize'
    end
    object quBrowseCodSize: TStringField
      DisplayLabel = 'Code'
      FieldName = 'CodSize'
      Size = 10
    end
    object quBrowseSizeName: TStringField
      DisplayLabel = 'Description'
      FieldName = 'SizeName'
    end
  end
  inherited gridPrinter: TdxComponentPrinter
    PreviewOptions.PreviewBoundsRect = {00000000000000002003000058020000}
    inherited gridPrinterLink: TdxGridReportLink
      DateTime = 37946.736551481480000000
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 1
      BuiltInReportLink = True
    end
  end
end