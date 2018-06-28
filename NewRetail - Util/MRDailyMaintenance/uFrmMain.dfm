object FrmMain: TFrmMain
  Left = 415
  Top = 242
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'MR Daily Maintenance'
  ClientHeight = 180
  ClientWidth = 400
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    400
    180)
  PixelsPerInch = 96
  TextHeight = 13
  object lbWait: TLabel
    Left = 28
    Top = 60
    Width = 115
    Height = 19
    Caption = 'Please wait ...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object lbPowered: TLabel
    Left = 2
    Top = 145
    Width = 115
    Height = 11
    Anchors = [akLeft, akBottom]
    Caption = 'Powered by MainRetail'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label4: TLabel
    Left = 2
    Top = 165
    Width = 177
    Height = 11
    Anchors = [akLeft, akBottom]
    Caption = '@2000 Retail Systems. All rights reserved.'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lblVersion: TLabel
    Left = 333
    Top = 163
    Width = 65
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'Version 1.3'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = 8404992
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Shape5: TShape
    Left = 2
    Top = 161
    Width = 397
    Height = 3
    Anchors = [akLeft, akRight, akBottom]
    Brush.Color = 8404992
    Pen.Style = psClear
  end
  object lbTimer: TLabel
    Left = 28
    Top = 61
    Width = 298
    Height = 19
    Caption = 'MainRetail schedule will start in %D'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object btnStart: TButton
    Left = 26
    Top = 87
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    Visible = False
    OnClick = btnStartClick
  end
  object btnStop: TButton
    Left = 26
    Top = 87
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 0
    Visible = False
    OnClick = btnStopClick
  end
  object ADOCon: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=fudeu;Persist Security Info=True;Us' +
      'er ID=sa;Initial Catalog=ApresentacaoDB;Data Source=(local)'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 17
    Top = 11
  end
  object Timer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = TimerTimer
    Left = 92
    Top = 36
  end
  object TimerStart: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerStartTimer
    Left = 140
    Top = 36
  end
  object siLang: TsiLang
    Version = '6.1.0.1'
    StringsTypes.Strings = (
      'TIB_STRINGLIST'
      'TSTRINGLIST')
    NumOfLanguages = 3
    LangDispatcher = DMGlobal.LanguageDispatcher
    LangDelim = 1
    LangNames.Strings = (
      'English'
      'Portugu'#234's'
      'Espa'#241'ol')
    Language = 'English'
    ExcludedProperties.Strings = (
      'Category'
      'SecondaryShortCuts'
      'HelpKeyword'
      'InitialDir'
      'HelpKeyword'
      'ActivePage'
      'ImeName'
      'DefaultExt'
      'FileName'
      'FieldName'
      'PickList'
      'DisplayFormat'
      'EditMask'
      'KeyList'
      'LookupDisplayFields'
      'DropDownSpecRow'
      'TableName'
      'DatabaseName'
      'IndexName'
      'MasterFields')
    Left = 44
    Top = 36
    TranslationData = {
      737443617074696F6E730D0A5446726D4D61696E014D52204461696C79204D61
      696E74656E616E6365014D52204461696C79204D61696E74656E616E6365014D
      52204461696C79204D61696E74656E616E6365010D0A6C625761697401506C65
      6173652077616974202E2E2E01506F72206661766F722C20657370657265202E
      2E2E01506F72206661766F722C20657370657265202E2E2E010D0A6C62506F77
      6572656401506F7765726564206279204D61696E52657461696C01506F776572
      6564206279204D61696E52657461696C01506F7765726564206279204D61696E
      52657461696C010D0A4C6162656C340140323030302052657461696C20537973
      74656D732E20416C6C207269676874732072657365727665642E014032303030
      2052657461696C2053797374656D732E20416C6C207269676874732072657365
      727665642E0140323030302052657461696C2053797374656D732E20416C6C20
      7269676874732072657365727665642E010D0A6C626C56657273696F6E015665
      7273696F6E20312E310156657273696F6E20312E310156657273696F6E20312E
      31010D0A4F7074696F6E7331014F7074696F6E73014F70E7F56573014F706369
      6F6E6573010D0A6D656D43616C634176670143616C632041766720436F737401
      43616C63756C617220437573746F204DE964696F0143616C63756C617220436F
      73746F204DE964696F010D0A6D656D43616C634142430143616C632041424320
      616E64204175746F2D726571756573740143616C63756C617220636C61737369
      66696361E7E36F204142432065204175746F2D52657175697369E7E36F014361
      6C63756C617220414243206573746F717565010D0A6D656D44656C486F6C6401
      44656C657465206F6C6420486F6C647320616E6420496E76656E746F72790144
      656C65746172204573746F71756520652050656469646F7320616E7469676F73
      015669656A6F73206173696D69656E746F73206520696E76656E746172696F20
      6465206C612063616E63656C616369F36E010D0A62746E53746F700153746F70
      015061726172015061726172010D0A62746E537461727401537461727401496E
      696369617201496E6963696172010D0A6C6254696D6572015363686564756C65
      2077696C6C20737461727420696E202544014578656375E7E36F20636F6D65E7
      6172E12064656E74726F20254401456C20686F726172696F20636F6D656E7A61
      72E1206164656E74726F202544010D0A737448696E74730D0A5446726D4D6169
      6E01010D0A6C6257616974010101010D0A6C62506F7765726564010101010D0A
      4C6162656C34010101010D0A6C626C56657273696F6E010101010D0A53686170
      6535010101010D0A4F7074696F6E7331010101010D0A6D656D43616C63417667
      010101010D0A6D656D43616C63414243010101010D0A6D656D44656C486F6C64
      010101010D0A62746E53746F70010101010D0A62746E5374617274010101010D
      0A6C6254696D6572010101010D0A7374446973706C61794C6162656C730D0A73
      74466F6E74730D0A5446726D4D61696E014D532053616E732053657269660101
      010D0A6C6257616974015461686F6D610101010D0A6C62506F77657265640154
      61686F6D610101010D0A4C6162656C34015461686F6D610101010D0A6C626C56
      657273696F6E0156657264616E610101010D0A6C6254696D6572015461686F6D
      610101010D0A73744D756C74694C696E65730D0A7374446C677343617074696F
      6E730D0A5761726E696E67015761726E696E670101010D0A4572726F72014572
      726F720101010D0A496E666F726D6174696F6E01496E666F726D6174696F6E01
      01010D0A436F6E6669726D01436F6E6669726D0101010D0A5965730126596573
      0101010D0A4E6F01264E6F0101010D0A4F4B014F4B0101010D0A43616E63656C
      0143616E63656C0101010D0A41626F7274012641626F72740101010D0A526574
      7279012652657472790101010D0A49676E6F7265012649676E6F72650101010D
      0A416C6C0126416C6C0101010D0A4E6F20546F20416C6C014E266F20746F2041
      6C6C0101010D0A59657320546F20416C6C0159657320746F2026416C6C010101
      0D0A48656C70012648656C700101010D0A7374537472696E67730D0A73744F74
      686572537472696E67730D0A5446726D4D61696E2E48656C7046696C65010101
      010D0A41444F436F6E2E436F6E6E656374696F6E537472696E670150726F7669
      6465723D53514C4F4C4544422E313B50617373776F72643D6D72757365723230
      30303B5065727369737420536563757269747920496E666F3D547275653B5573
      65722049443D6D72757365723B496E697469616C20436174616C6F673D526F64
      7269676F5465737444423B4461746120536F757263653D286C6F63616C290101
      010D0A41444F436F6E2E44656661756C744461746162617365010101010D0A41
      444F436F6E2E50726F76696465720153514C4F4C4544422E310101010D0A7370
      4461696C794D61696E74656E616E63652E436F6E6E656374696F6E537472696E
      67010101010D0A73704461696C794D61696E74656E616E63652E46696C746572
      010101010D0A73704461696C794D61696E74656E616E63652E50726F63656475
      72654E616D650173705F5379735F4461696C794D61696E74656E616E63653B31
      0101010D0A73744C6F63616C65730D0A43757272656E637920537472696E6701
      240101010D0A54686F7573616E6420536570617261746F72012C0101010D0A44
      6563696D616C20536570617261746F72012E0101010D0A446174652053657061
      7261746F72012F0101010D0A53686F7274204461746520466F726D6174014D2F
      642F797979790101010D0A4C6F6E67204461746520466F726D61740164646464
      2C204D4D4D4D2064642C20797979790101010D0A54696D652053657061726174
      6F72013A0101010D0A54696D6520414D20537472696E6701414D0101010D0A54
      696D6520504D20537472696E6701504D0101010D0A53686F72742054696D6520
      466F726D617401683A6D6D20414D504D0101010D0A4C6F6E672054696D652046
      6F726D617401683A6D6D3A737320414D504D0101010D0A53686F7274204D6F6E
      7468204E616D6573014A616E2C4665622C4D61722C4170722C4D61792C4A756E
      2C4A756C2C4175672C5365702C4F63742C4E6F762C4465630101010D0A4C6F6E
      67204D6F6E7468204E616D6573014A616E756172792C46656272756172792C4D
      617263682C417072696C2C4D61792C4A756E652C4A756C792C4175677573742C
      53657074656D6265722C4F63746F6265722C4E6F76656D6265722C446563656D
      6265720101010D0A53686F727420446179204E616D65730153756E2C4D6F6E2C
      5475652C5765642C5468752C4672692C5361740101010D0A4C6F6E6720446179
      204E616D65730153756E6461792C4D6F6E6461792C547565736461792C576564
      6E65736461792C54687572736461792C4672696461792C536174757264617901
      01010D0A7374436F6C6C656374696F6E730D0A737443686172536574730D0A54
      46726D4D61696E0144454641554C545F434841525345540101010D0A6C625761
      697401414E53495F43484152534554010D0A6C62506F776572656401414E5349
      5F43484152534554010D0A4C6162656C3401414E53495F43484152534554010D
      0A6C626C56657273696F6E01414E53495F43484152534554010D0A6C6254696D
      657201414E53495F43484152534554010D0A}
  end
  object spDailyMaintenance: TADOStoredProc
    Connection = ADOCon
    CommandTimeout = 18000
    ProcedureName = 'sp_Sys_DailyMaintenance;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@CalcABC'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@CalcAvg'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@DelHold'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end>
    Left = 188
    Top = 107
  end
  object MainMenu1: TMainMenu
    Left = 374
    Top = 38
    object Options1: TMenuItem
      Caption = 'Options'
      object memCalcAvg: TMenuItem
        Caption = 'Calc Avg Cost'
        Checked = True
        OnClick = memCalcAvgClick
      end
      object memCalcABC: TMenuItem
        Caption = 'Calc ABC and Auto-request'
        Checked = True
        OnClick = memCalcAvgClick
      end
      object memDelHold: TMenuItem
        Caption = 'Delete old Holds and Inventory'
        Checked = True
        OnClick = memCalcAvgClick
      end
    end
  end
  object TimerSeconds: TTimer
    Enabled = False
    OnTimer = TimerSecondsTimer
    Left = 300
    Top = 36
  end
  object spReindexTables: TADOStoredProc
    Connection = ADOCon
    CommandTimeout = 18000
    ProcedureName = 'sp_Mnt_Reindex_All_Tables;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end>
    Left = 253
    Top = 107
  end
  object spRecompileObjects: TADOStoredProc
    Connection = ADOCon
    CommandTimeout = 18000
    ProcedureName = 'sp_Mnt_Recompile_All_Objects;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end>
    Left = 328
    Top = 107
  end
end