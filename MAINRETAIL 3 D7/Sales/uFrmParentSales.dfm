inherited FrmParentSales: TFrmParentSales
  Left = 0
  Width = 640
  Height = 381
  Caption = 'FrmParentSales'
  OldCreateOrder = True
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object dsPreSaleItem: TDataSource
    DataSet = spquPreSaleItem
    Left = 140
    Top = 216
  end
  object spquPreSaleItem: TADOStoredProc
    CursorType = ctStatic
    OnCalcFields = spquPreSaleItemCalcFields
    ProcedureName = 'sp_PreSale_quPreSaleItem;1'
    Parameters = <
      item
        Name = 'RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = 0
      end
      item
        Name = '@DocumentID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@IsPreSale'
        Attributes = [paNullable]
        DataType = ftBoolean
        Value = Null
      end
      item
        Name = '@Date'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end>
    Left = 137
    Top = 266
    object spquPreSaleItemModelID: TIntegerField
      FieldName = 'ModelID'
    end
    object spquPreSaleItemModel: TStringField
      FieldName = 'Model'
      Size = 30
    end
    object spquPreSaleItemDescription: TStringField
      FieldName = 'Description'
      Size = 50
    end
    object spquPreSaleItemSalePrice: TFloatField
      FieldName = 'SalePrice'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleItemDiscActual: TFloatField
      FieldKind = fkCalculated
      FieldName = 'DiscActual'
      DisplayFormat = '#,##0.00'
      Calculated = True
    end
    object spquPreSaleItemDiscount: TFloatField
      DisplayLabel = 'Disc.'
      FieldName = 'Discount'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleItemIDInventoryMov: TIntegerField
      FieldName = 'IDInventoryMov'
    end
    object spquPreSaleItemTotalItem: TFloatField
      DisplayLabel = 'Total'
      FieldName = 'TotalItem'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleItemSalesPerson: TStringField
      FieldName = 'SalesPerson'
      Size = 50
    end
    object spquPreSaleItemIDComission: TIntegerField
      FieldName = 'IDComission'
    end
    object spquPreSaleItemCostPrice: TFloatField
      FieldName = 'CostPrice'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleItemExchangeInvoice: TIntegerField
      FieldName = 'ExchangeInvoice'
    end
    object spquPreSaleItemSuggRetail: TFloatField
      DisplayLabel = 'MSRP'
      FieldName = 'SuggRetail'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleItemSerialNumber: TBooleanField
      DisplayLabel = 'S/N'
      FieldName = 'SerialNumber'
    end
    object spquPreSaleItemIDUser: TIntegerField
      FieldName = 'IDUser'
    end
    object spquPreSaleItemTax: TFloatField
      DisplayLabel = 'Tax %'
      FieldName = 'Tax'
      DisplayFormat = '0.00'
    end
    object spquPreSaleItemSubTotalItem: TFloatField
      FieldKind = fkCalculated
      FieldName = 'SubTotalItem'
      DisplayFormat = '#,##0.00'
      Calculated = True
    end
    object spquPreSaleItemQty: TFloatField
      FieldName = 'Qty'
      DisplayFormat = '0.#####'
    end
    object spquPreSaleItemIDDepartment: TIntegerField
      FieldName = 'IDDepartment'
    end
    object spquPreSaleItemRequestCustomer: TBooleanField
      FieldName = 'RequestCustomer'
    end
    object spquPreSaleItemPuppyTracker: TBooleanField
      FieldName = 'PuppyTracker'
    end
    object spquPreSaleItemPromo: TBooleanField
      FieldName = 'Promo'
    end
    object spquPreSaleItemIDMovParent: TIntegerField
      FieldName = 'IDMovParent'
      ReadOnly = True
    end
    object spquPreSaleItemTotalSaved: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'TotalSaved'
      Calculated = True
    end
    object spquPreSaleItemTotalSalePrice: TCurrencyField
      FieldName = 'TotalSalePrice'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleItemUnitDiscount: TCurrencyField
      FieldName = 'UnitDiscount'
      DisplayFormat = '#,##0.00##'
    end
  end
  object dsPreSaleInfo: TDataSource
    DataSet = quPreSaleInfo
    Left = 228
    Top = 216
  end
  object dsPreSaleValue: TDataSource
    DataSet = spquPreSaleValue
    Left = 314
    Top = 216
  end
  object spquPreSaleValue: TADOStoredProc
    ProcedureName = 'sp_PreSale_quPreSaleValue;1'
    Parameters = <
      item
        Name = 'RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = 0
      end
      item
        Name = '@PreSaleID'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 315
    Top = 266
    object spquPreSaleValueTaxIsent: TBooleanField
      DisplayLabel = 'TaxExempt'
      DisplayWidth = 5
      FieldName = 'TaxIsent'
    end
    object spquPreSaleValueSubTotal: TFloatField
      DisplayWidth = 10
      FieldName = 'SubTotal'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleValueItemDiscount: TFloatField
      DisplayWidth = 10
      FieldName = 'ItemDiscount'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleValueTax: TFloatField
      DisplayWidth = 10
      FieldName = 'Tax'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleValueTaxPrc: TFloatField
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'TaxPrc'
      DisplayFormat = '#,##0.00 %'
      Calculated = True
    end
    object spquPreSaleValueDiscountPrc: TFloatField
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'DiscountPrc'
      DisplayFormat = '#,##0.00 %'
      Calculated = True
    end
    object spquPreSaleValueTotalInvoice: TFloatField
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'TotalInvoice'
      DisplayFormat = '#,##0.00'
      Calculated = True
    end
    object spquPreSaleValueSpecialPriceID: TIntegerField
      DisplayWidth = 10
      FieldName = 'SpecialPriceID'
    end
    object spquPreSaleValueSpecialPrice: TStringField
      DisplayWidth = 30
      FieldName = 'SpecialPrice'
      Size = 30
    end
    object spquPreSaleValuenOpenUser: TIntegerField
      DisplayWidth = 10
      FieldName = 'nOpenUser'
    end
    object spquPreSaleValueShowOpenUser: TIntegerField
      Alignment = taCenter
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'ShowOpenUser'
      Calculated = True
    end
    object spquPreSaleValueNewSubTotal: TFloatField
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'NewSubTotal'
      DisplayFormat = '#,##0.00'
      currency = True
      Calculated = True
    end
    object spquPreSaleValueTaxIsemptValue: TFloatField
      DisplayWidth = 10
      FieldName = 'TaxIsemptValue'
      DisplayFormat = '#,##0.00'
    end
    object spquPreSaleValueSubTotalTaxable: TCurrencyField
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'SubTotalTaxable'
      DisplayFormat = '#,##0.00'
      Calculated = True
    end
    object spquPreSaleValueTaxIsemptItemDiscount: TFloatField
      FieldName = 'TaxIsemptItemDiscount'
    end
    object spquPreSaleValueAditionalExpenses: TBCDField
      FieldName = 'AditionalExpenses'
      DisplayFormat = '#,##0.00'
      Precision = 19
    end
    object spquPreSaleValueInvoiceDiscount: TCurrencyField
      FieldName = 'InvoiceDiscount'
    end
    object spquPreSaleValueTotalDiscount: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'TotalDiscount'
      DisplayFormat = '#,##0.00'
      Calculated = True
    end
    object spquPreSaleValueTotalSaved: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'TotalSaved'
      Calculated = True
    end
  end
  object spUpHold: TADOStoredProc
    ProcedureName = 'sp_PreSale_UpHold;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@IDPreSaleOrigem'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@IDPreSaleDestino'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@Date'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@IDUser'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 396
    Top = 268
  end
  object strepSaleItem: TcxStyleRepository
    Left = 396
    Top = 219
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyleContent: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16247513
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyleContentEven: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16247513
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 14811135
      TextColor = clBlack
    end
    object cxStyle6: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14811135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clNavy
    end
    object cxStyle7: TcxStyle
      AssignedValues = [svColor]
      Color = 14872561
    end
    object cxStyle8: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyleHeader: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 13793052
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16046805
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clWhite
    end
    object cxStyle10: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle11: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyle12: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle13: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14811135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clNavy
    end
    object cxStyleSelection: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 12937777
      TextColor = clWhite
    end
    object GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet
      Caption = 'DevExpress'
      Styles.Background = cxStyle1
      Styles.Content = cxStyleContent
      Styles.ContentEven = cxStyleContentEven
      Styles.ContentOdd = cxStyle4
      Styles.Inactive = cxStyle10
      Styles.IncSearch = cxStyle11
      Styles.Selection = cxStyleSelection
      Styles.FilterBox = cxStyle5
      Styles.Footer = cxStyle6
      Styles.Group = cxStyle7
      Styles.GroupByBox = cxStyle8
      Styles.Header = cxStyleHeader
      Styles.Indicator = cxStyle12
      Styles.Preview = cxStyle13
    end
  end
  object quPreSaleInfo: TADOQuery
    CursorType = ctStatic
    AfterOpen = quPreSaleInfoAfterOpen
    Parameters = <
      item
        Name = 'IDPreSale'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '        I.IDPreSale,'
      '        I.IDMeioPag ,'
      '        I.IDTouristGroup,'
      '        I.PreSaleDate ,'
      '        I.OtherComissionID ,'
      '        I.IDCustomer ,'
      '        I.DeliverTypeID ,'
      '        I.DeliverDate ,'
      '        I.DeliverAddress ,'
      '        I.PassportDate , '
      #9'I.AirLine ,'
      '        I.CompanyName ,'
      '        I.CompanyCGC ,'
      '        I.DepositDate ,'
      '        I.Note ,'
      '        I.PrintNotes,'
      '        I.InvoiceDate ,'
      '        I.IDInvoice ,'
      '        I.Passport ,'
      '        I.Ticket,'
      '        I.MediaID,'
      '        I.CardNumber,'
      '        I.IDStore,'
      '        I.Address,'
      '        I.Layaway,'
      '        I.FirstName,'
      '        I.LastName,'
      '        I.Zip,'
      '        I.DeliverOBS,'
      '        I.DeliverConfirmation,'
      '        I.IDFormOfPayment,'
      '        I.IDPreSaleParent,'
      '        I.SaleCode,'
      #9'I.InvoiceCode,'
      #9'I.PuppyTracker,'
      #9'I.TaxIsent'
      'FROM'
      '        Invoice I'
      'WHERE'
      '        IDPreSale = :IDPreSale')
    Left = 228
    Top = 267
    object quPreSaleInfoIDPreSale: TIntegerField
      FieldName = 'IDPreSale'
      Origin = 'Invoice.IDPreSale'
    end
    object quPreSaleInfoIDMeioPag: TIntegerField
      FieldName = 'IDMeioPag'
      Origin = 'Invoice.IDMeioPag'
    end
    object quPreSaleInfoIDTouristGroup: TIntegerField
      FieldName = 'IDTouristGroup'
      Origin = 'Invoice.IDTouristGroup'
    end
    object quPreSaleInfoPreSaleDate: TDateTimeField
      FieldName = 'PreSaleDate'
      Origin = 'Invoice.PreSaleDate'
      EditMask = '!99/99/00;1;_'
    end
    object quPreSaleInfoOtherComissionID: TIntegerField
      FieldName = 'OtherComissionID'
      Origin = 'Invoice.OtherComissionID'
    end
    object quPreSaleInfoIDCustomer: TIntegerField
      FieldName = 'IDCustomer'
      Origin = 'Invoice.IDCustomer'
    end
    object quPreSaleInfoDeliverTypeID: TIntegerField
      FieldName = 'DeliverTypeID'
      Origin = 'Invoice.DeliverTypeID'
    end
    object quPreSaleInfoDeliverDate: TDateTimeField
      FieldName = 'DeliverDate'
      Origin = 'Invoice.DeliverDate'
      EditMask = '!99/99/00;1;_'
    end
    object quPreSaleInfoDeliverAddress: TStringField
      FieldName = 'DeliverAddress'
      Origin = 'Invoice.DeliverAddress'
      Size = 100
    end
    object quPreSaleInfoPassportDate: TDateTimeField
      FieldName = 'PassportDate'
      Origin = 'Invoice.PassportDate'
      EditMask = '!99/99/00;1;_'
    end
    object quPreSaleInfoAirLine: TStringField
      FieldName = 'AirLine'
      Origin = 'Invoice.AirLine'
      Size = 40
    end
    object quPreSaleInfoCompanyName: TStringField
      FieldName = 'CompanyName'
      Origin = 'Invoice.CompanyName'
      Size = 40
    end
    object quPreSaleInfoCompanyCGC: TStringField
      FieldName = 'CompanyCGC'
      Origin = 'Invoice.CompanyCGC'
    end
    object quPreSaleInfoDepositDate: TDateTimeField
      FieldName = 'DepositDate'
      Origin = 'Invoice.DepositDate'
      EditMask = '!99/99/00;1;_'
    end
    object quPreSaleInfoNote: TStringField
      FieldName = 'Note'
      Origin = 'Invoice.Note'
      Size = 150
    end
    object quPreSaleInfoInvoiceDate: TDateTimeField
      FieldName = 'InvoiceDate'
      Origin = 'Invoice.InvoiceDate'
      EditMask = '!99/99/00;1;_'
    end
    object quPreSaleInfoIDInvoice: TIntegerField
      FieldName = 'IDInvoice'
      Origin = 'Invoice.IDInvoice'
    end
    object quPreSaleInfoPassport: TStringField
      FieldName = 'Passport'
      Origin = 'Invoice.Passport'
    end
    object quPreSaleInfoTicket: TStringField
      FieldName = 'Ticket'
      Origin = 'Invoice.Ticket'
    end
    object quPreSaleInfoMediaID: TIntegerField
      FieldName = 'MediaID'
      Origin = 'Invoice.IDPreSale'
    end
    object quPreSaleInfoCardNumber: TStringField
      FieldName = 'CardNumber'
      Origin = 'Invoice.IDPreSale'
      Size = 30
    end
    object quPreSaleInfoIDStore: TIntegerField
      FieldName = 'IDStore'
      Origin = 'Invoice.IDPreSale'
    end
    object quPreSaleInfoAddress: TStringField
      FieldName = 'Address'
      Origin = 'Invoice.IDPreSale'
      Size = 200
    end
    object quPreSaleInfoLayaway: TBooleanField
      FieldName = 'Layaway'
    end
    object quPreSaleInfoFirstName: TStringField
      FieldName = 'FirstName'
    end
    object quPreSaleInfoLastName: TStringField
      FieldName = 'LastName'
    end
    object quPreSaleInfoZip: TStringField
      FieldName = 'Zip'
    end
    object quPreSaleInfoPrintNotes: TBooleanField
      FieldName = 'PrintNotes'
    end
    object quPreSaleInfoDeliverOBS: TStringField
      FieldName = 'DeliverOBS'
      Size = 255
    end
    object quPreSaleInfoDeliverConfirmation: TBooleanField
      FieldName = 'DeliverConfirmation'
    end
    object quPreSaleInfoIDFormOfPayment: TIntegerField
      FieldName = 'IDFormOfPayment'
    end
    object quPreSaleInfoIDPreSaleParent: TIntegerField
      FieldName = 'IDPreSaleParent'
    end
    object quPreSaleInfoSaleCode: TStringField
      FieldName = 'SaleCode'
    end
    object quPreSaleInfoInvoiceCode: TStringField
      FieldName = 'InvoiceCode'
    end
    object quPreSaleInfoPuppyTracker: TBooleanField
      FieldName = 'PuppyTracker'
    end
    object quPreSaleInfoTaxIsent: TBooleanField
      FieldName = 'TaxIsent'
    end
  end
end