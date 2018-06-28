(*
-----------------------------------------------------------------------------------------------------
Version : (296 - 305)
Date    : 09.01.2011
Author  : Antonio Marcos Fernandes de Souza (amfsouza)
Issue   : Combine lines is not working if sale has different prices
Solution: remove price of the condition
Version : (296 - 306)
------------------------------------------------------------------------------------------------------

Version : (291 - 292)
Date    : 05.11.2011
Author  : Antonio Marcos Fernandes de Souza (amfsouza)
Issue   : Combine lines is not working if sale has discount
Solution: I had to get another discounts to documentID
Version : (291 - 293)
------------------------------------------------------------------------------------------------------

Version : (288 - 279)
Date    : 02.04.2011
Author  : Antonio Marcos Fernandes de Souza (amfsouza)
Issue   : Change qty in cash register ( sale is disappearing )
Solution: I did some changes ( identify when Insert or Update a sale ) in previous routine.
Version : (288 - 280)
------------------------------------------------------------------------------------------------------

Version : (288 - 278)
Date    : 10.22.2010
Author  : Antonio Marcos Fernandes de Souza (amfsouza)
Issue   : To negative quantities combine lines is not working.
Solution: I implemented a new routine ( function ) to verify previous quantity presales with same condition.
Version : (287 - 277)
------------------------------------------------------------------------------------------------------
Version : (287 - 272)
Date    : 10.20.2010
Author  : Antonio Marcos Fernandes de Souza (amfsouza)
Issue   : Cash Register Combine Line Items
Solution: I implemented a new routine ( function ) to verify previous quantity presales with same condition.
Version : (287 - 273)
-----------------------------------------------------------------------------------------------------
*)
unit uFrmPOSFunctions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, ExtCtrls, PowerADOQuery, DBClient, Provider,
  HTTPApp;

type
  TPayment = class
    fCustomer      : ShortString;
    fPhone         : ShortString;
    fDocument      : ShortString;
    fBank          : ShortString;
    fDocNumber     : ShortString;
    fOBS           : ShortString;
    fAuthorization : ShortString;
    fExpireDate    : TDateTime;
    fCreationDate  : TDateTime;
    fAmount        : Double;
    property Customer      : ShortString read fCustomer      write fCustomer;
    property Phone         : ShortString read fPhone         write fPhone;
    property Document      : ShortString read fDocument      write fDocument;
    property Bank          : ShortString read fBank          write fBank;
    property DocNumber     : ShortString read fDocNumber     write fDocNumber;
    property OBS           : ShortString read fOBS           write fOBS;
    property Authorization : ShortString read fAuthorization write fAuthorization;
    property ExpireDate    : TDateTime   read fExpireDate    write fExpireDate;
    property CreationDate  : TDateTime   read fCreationDate  write fCreationDate;
    property Amount        : Double      read fAmount        write fAmount;
  end;

  TExtPayment = class(TPayment)
    fIDPreSale     : Integer;
    fIDPaymentType : Integer;
    fTypeOfPayment : Integer;
    fIDCashRegMov  : Integer;
    fIDLancamento  : Integer;
    property IDPreSale     : Integer read fIDPreSale     write fIDPreSale;
    property IDPaymentType : Integer read fIDPaymentType write fIDPaymentType;
    property TypeOfPayment : Integer read fTypeOfPayment write fTypeOfPayment;
    property IDCashRegMov  : Integer read fIDCashRegMov  write fIDCashRegMov;
    property IDLancamento  : Integer read fIDLancamento  write fIDLancamento;
  end;

  TSalesPerson = class
    IDPessoa: Integer;
    Pessoa:   String;
    Percent:  Real;
  end;

  TFrmPOSFunctions = class(TForm)
    spCashRegOpen: TADOStoredProc;
    spCashRegClose: TADOStoredProc;
    quCashRegResidual: TADOQuery;
    quCashRegResidualIDCashRegMov: TIntegerField;
    quCashRegResidualIDOpenUser: TIntegerField;
    quCashRegResidualResidual: TFloatField;
    quCashRegInfo: TADOQuery;
    quCashRegInfoIDCashRegMov: TIntegerField;
    quCashRegInfoSystemUser: TStringField;
    quCashRegInfoCashRegister: TStringField;
    quCashRegInfoOpenTime: TDateTimeField;
    quCashRegInfoIDCashRegStatus: TIntegerField;
    quTestRefresh: TADOQuery;
    quTestRefreshInvoiceCount: TIntegerField;
    Label1: TLabel;
    spCashRegCalcCash: TADOStoredProc;
    spCashRegPetty: TADOStoredProc;
    spCashRegCalcCashWidraw: TADOStoredProc;
    spCashRegWidraw: TADOStoredProc;
    Label2: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    spDeletePreSale: TADOStoredProc;
    spquQuantity: TADOStoredProc;
    spquQuantityName: TStringField;
    spquQuantityStoreID: TIntegerField;
    spquQuantityCurrentCost: TFloatField;
    spquKitPrice: TADOStoredProc;
    spquKitPriceSellingPrice: TFloatField;
    spAddPreSaleItem: TADOStoredProc;
    spDeletePreSaleItem: TADOStoredProc;
    spUpdatePreSaleItem: TADOStoredProc;
    spAddParcela: TADOStoredProc;
    spPreSalePay: TADOStoredProc;
    spRecalcTax: TADOStoredProc;
    cmdExemptTax: TADOCommand;
    spAddSpecialPrice: TADOStoredProc;
    spDeleteSpecialPrice: TADOStoredProc;
    spManageDiscount: TADOStoredProc;
    spMaxDiscount: TADOStoredProc;
    spSetTaxIsention: TADOStoredProc;
    spCalcFullTotal: TADOStoredProc;
    spAddInvAdtionalCost: TADOStoredProc;
    spDeleteInvAdtionalCost: TADOStoredProc;
    quPaymentValue: TADOQuery;
    Shape3: TShape;
    Label3: TLabel;
    spPreSaleCancelHold: TADOStoredProc;
    spCashRegSubClose: TADOStoredProc;
    sp_CashRegister_QuitaLancamento: TADOStoredProc;
    spDivideHold: TADOStoredProc;
    spCreateHold: TADOStoredProc;
    quPaymentValueTotal: TBCDField;
    spAddCustomerCredit: TADOStoredProc;
    spquQuantityFloatPercent: TIntegerField;
    quQtyInventoryPreSale: TADOQuery;
    quVerifyDeliveryModel: TADOQuery;
    quDeliverOpenHolds: TADODataSet;
    quDeliverOpenHoldsSaleCode: TStringField;
    quHasPendingPayment: TADODataSet;
    quHasPendingPaymentIDLancamento: TIntegerField;
    spNewSaleCode: TADOStoredProc;
    quSalesPerson: TPowerADOQuery;
    quSalesPersonPessoa: TStringField;
    quSalesPersonIDPessoa: TIntegerField;
    quSalesPersonCommissionPercent: TBCDField;
    spquQuantityQtyOnPreSale: TFloatField;
    spquQuantityQtyOnHand: TFloatField;
    spquQuantityQtyOnOrder: TFloatField;
    spquQuantityQtyOnRepair: TFloatField;
    spquQuantityQtyOnPrePurchase: TFloatField;
    quVerifyDeliveryModelQty: TFloatField;
    quVerifyDeliveryModelOnHand: TFloatField;
    quVerifyDeliveryModelInPurchasing: TFloatField;
    spquKitPriceQty: TFloatField;
    spApplyCustomerDiscount: TADOStoredProc;
    spCalcCustomerDiscount: TADOStoredProc;
    dspKitPrice: TDataSetProvider;
    cdsKitPrice: TClientDataSet;
    cdsKitPriceSellingPrice: TFloatField;
    cdsKitPriceQty: TFloatField;
    spApplyCustItemDiscount: TADOStoredProc;
    spCashAddPayment: TADOStoredProc;
    spImporEstimated: TADOStoredProc;
    quValidateDelivery: TADODataSet;
    quValidateDeliveryQty: TBCDField;
    WebDispatcher1: TWebDispatcher;
  private

  public
     fCommisList : TStringList;
     fDefaultSalesPerson : TStringList;

    //CashRegister functions
    function OpenCashRegister(f100, f50, f20, f10, f05, f02, f01,
                              f0100, f050, f025, f010, f005, f001 : Integer;
                              fIDCashReg, fIDUser : Integer;
                              fTotalCount, fTotalCash, fTotalCard, fTotalPreCard,
                              fTotalCheck, fTotalOther, fTotalDebit: Currency;
                              fDate : TDateTime;
                              var fIDCashRegMov, fIDCashRegLog : Integer):Boolean;
    function CloseCashRegister(fIDCashRegMov, fIDUser : Integer;
                              f100, f50, f20, f10, f05, f02, f01,
                              f0100, f050, f025, f010, f005, f001 : Integer;
                              fTotalCount, fTotalCash, fTotalCard, fTotalPreCard,
                              fTotalCheck, fTotalOther, fTotalDebit : Currency;
                              fEnvolop : String;
                              fDate : TDateTime;
                              var fIDCashRegLog, fError : Integer):Boolean;

    function SubCloseCashRegister(fIDCashRegMov, fIDUser: Integer;
                                  fTotalCount, fTotalCash, fTotalCard,
                                  fTotalPreCard, fTotalCheck,
                                  fTotalOther, fTotalDebit: Currency; fEnvolop: String;
                                  fDate: TDateTime; var fIDCashRegLog,
                                  fError: Integer): Boolean;

    function QuitaLancamento(FIDCashRegMov, FIDLancamentoQuitar,
                             FUser: Integer; FDate: TDateTime): Boolean;




    function WithdrawCashRegister(fIDCashRegMov, fIDUser : Integer;
                                f100, f50, f20, f10, f05, f02, f01,
                                f0100, f050, f025, f010, f005, f001 : Integer;
                                fTotalCash, fTotalCard, fTotalPreCard,
                                fTotalCheck, fTotalOther, fTotalDebit : Currency;
                                fEnvolop : String;
                                fDate : TDateTime;
                                fOBS: String; fIDReason: Integer):Boolean;

    procedure GetCashRegisterResidual(fIDCashRegMov:Integer;
                                     var fIDOpenUser : Integer;
                                     var fResidual   : Double);
    procedure GetCashRegisterInfo(fIDCashReg : Integer;
                                  var fCashRegName, fOpenUser : String;
                                  var fStatus : Integer;
                                  var fOpenDate : TDateTime);
    function TestRefresh:Integer;
    function GetTotalCashReceived(fIDCashRegMov:Integer):Double;
    function GetTotalCashWithdraw(fIDCashRegMov:Integer):Double;
    function AddPettyCash(fIDCashRegMov, fIDUser:Integer;
                          fCash : Currency;
                          fDate : TDateTime;
                          fIDReason : Integer;
                          fOBS: String;
                          var fIDCashRegLog: Integer):Boolean;
    function AddCash(fIDCashRegMov, fIDUser:Integer;
                          fCash : Currency;
                          fDate : TDateTime;
                          fIDReason : Integer;
                          fOBS: String;
                          var fIDCashRegLog: Integer):Boolean;
    function AddPayment(fIDPreSale, fIDStore, fIDUser, fIDCustomer,
                        fIDMeioPag, fIDCashRegMov : Integer;
                        fPreSaleDate, fExpireDate : TDateTime;
                        fNumParcela, fAutotize : String;
                        fTotalInvoice : Double;
                        fCheckNumber, fCustomerDocument,
                        fCustomerName, fCustomerPhone: String;
                        fIDBankCheck : Integer;
                        fOBS: String;
                        fPaymentPlace: Integer;
                        fIsPreDatado: Boolean):Boolean;

    function PreSalePay(fIDPreSale, fIDTourGroup, fIDOtherCommis,
                        fIDCashRegMov, fIDStore : Integer;
                        fDate, fPayDate : TDateTime;
                        fCashReceived : Double; fBonusBucks: Currency;
                        fBonusCode : String;
                        var fIDInvoice : Integer):Boolean;

    //Invoice functions
    function CreateHold(fDeliverType : Integer;
                     fIsLayaway : Boolean; fIDStore : Integer;
                     fFName, fLName, fZip : String;
                     fIDTourGroup : Integer; fPreSaleDate : TDateTime;
                     fIDCustomer, fIDMedia, fIDOtherComm : Integer;
                     InvObs:String; var fIDPreSale: Integer):Boolean;
    function DeleteHold(fIDPreSale, fIDUser:Integer):Boolean;
    procedure GetQty(fIDModel, fIDStore : Integer;
                     var OnHand, OnPreSale, OnPrePurchase, OnAvailable : Double);
    function GetKitPrice(fIDModel : Integer; fQty : Double; fSellingPrice:Currency;
                         var fIsEmpty:Boolean):Currency;
    function AddHoldItem(fIDCustomer, fIDHold, fIDModel, fIDStore: Integer; fQty : Double;
                         fDiscount, fSale, fCost : Currency;
                         fIDUser, fIDCommis : Integer;
                         fMovDate, fDate : TDateTime;
                         fResetDisc, fManager : Boolean;
                         fIDPreInvMovExchange : Integer;
                         fDepartment : Integer;
                         var fError, fIDPreInvMov : Integer;
                         fIDParentPack : Integer = 0;
                         fPromo : Boolean = False;
                         fIDDescriptionPrice: Integer = 0;
                         fIDVendorPrice: Integer = 0;
                         fSuggPrice: Currency = 0;
                         fDocumentNumber: String = '';
                         fIDDocumentType: Integer = 0;
                         fDiscountPromo: Currency=0): Boolean;
    function DeleteHoldItem(fIDHold, fIDPreInvMov, fIDModel,
                            fIDUser : Integer; fQty : Double;
                            fDiscount, fSale : Double;
                            fResetDisc, fManage, SellBelowCost : Boolean;
                            fDate:TDateTime;
                            var fError : Integer):Boolean;

    //amfsouza 12.22.2010 - I had to add IdStore information in order to realize uses same function.
    function UpdateHoldItem(fIDHold, fPreInvMovID, fIDModel,
                            fIDCommis, fIDUSer : Integer; fQty : Double;
                            fDiscount, fSale, fCost : Double;
                            fMovDate, fDate : TDateTime;
                            fResetDisc, fManager : Boolean;
                            fDepartment : Integer;
                            var fError, fIDPreInvMov : Integer;
                            fIDPreSaleParent : Integer = 0;
                            fPromo : Boolean = False;
                            fIDDescriptionPrice: Integer = 0;
                            fIDVendorPrice: Integer = 0;
                            fSuggPrice: Currency = 0;
                            fDocumentNumber: String = '';
                            fIDDocumentType: Integer = 0;
                            fDiscountPromo: Currency=0;
                            fIdStore: Integer = 1):Boolean;
    function RecalcTax(fIDPreSale : Integer; fDate :TDateTime):Boolean;
    function ExemptTax(fIDPreSale : Integer; fExempt :Boolean):Boolean;
    function SetExemptTax(fIDPreSale, fIDMedia : Integer; fDate :TDateTime):Boolean;
    function AddSpecialPrice(fIDPreSale, fIDSpecialPrice: Integer;
                             fDate :TDateTime; fExemptTax:Boolean):Boolean;
    function DeleteSpecialPrice(fIDPreSale : Integer; fDate :TDateTime; fExemptTax:Boolean):Boolean;
    function GetSpecialPriceTotal(fIDPreSale:Integer):Double;
    function ManageDiscount(fIDPreSale: Integer; fDiscountPercent : Double;
                            fDate :TDateTime; fExemptTax, fSellBellowCost, fIsPromo:Boolean):Boolean;
    function GetMinSaleAndMaxDiscount(fIDPreSale, fIDUser : Integer;
                                      var fMaxMinSale, fMaxDiscount : Double):Boolean;
    function AddInvoiceAdtionalCost(fIDPreSale, fIDCostType : Integer; fAmount : Currency):Boolean;
    function DeleteInvoiceAdtionalCost(fIDInvoiceCost:Integer):Boolean;
    function CancelHold(IDPreSale, IDUser:Integer):Boolean;

    function DivideHold(IDPreSale, DeliverTypeID: Integer;
       DeliverDate: TDateTime; DeliverAddress, DeliverOBS: String;
       var NewIDPreSale: Integer): Boolean;

    //Invoice Values
    function GetInvoicePayments(IDPreSale:Integer):Currency;

    function AddCustomerCredit(fIDPessoa, fIDUser, fIDStore, fIDLancamento: Integer; fCreditDate,
      fExpirationDate: TDateTime; fAmount: Double;
      var fIDCustomerCredit: Integer): Boolean;

    function GetPayType(FIDMeioPag: String): Integer;

    function IsNegativeStoreDelivery(IDPreSale, IDStore, IDModel: Integer; var AQtyAvaiable: Double): Boolean;
    function QtyInDelivered(IDModel, IDStore : Integer; var HasDeliver: Boolean):Double;
    function GetCustomerDeliverOpenHold(IDCustomer, IDPreSale: Integer):String;
    function HasPaymentPending(IDPreSale: Integer): Boolean;
    function CanMarkDelivery(AIDPreSale, AIDModel : Integer; APreSaleDate : TDateTime;
         AQtyAvaiable, AQtyActual: Double): Boolean;

    function CreateSaleCode(IDPreSale, IDPreSaleParent, IDStore: Integer):String;

    function AddItemCommission(IDInventoryMov, IDPreInventoryMov: String;
      IDPessoa: Integer; Percent: Real):Boolean;
    procedure ClearCommissionList;
    procedure AddSaleItemCommission(ID, PreSaleType: Integer);
    procedure AddCommissionsList(ID, PreSaleType: Integer);
    procedure ApplyCustomerDiscount(AIDPreSale, AIDCustomer: Integer; ADate: TDateTime);
    procedure ApplyCustomerItemDiscount(AIDPreSale, AIDCustomer, AIDPreInventoryMov: Integer; ADate: TDateTime);
    function CalcCustomerDiscount(AIDCustomer, AIDModel: Integer; AQty, ASalePrice: Double): Currency;

    procedure AddPreSaleItemCommission(ID: Integer; DefaultSalesPerson: TStringList);
    procedure ClearDefaultSalesPerson;

    function ImportEstimated(IDEstimated, IDMedia, IDStore, IDUser : Integer;
      TaxIsent, UpdateSalePrice : Boolean):Integer;

    //amfsouza 10.20.2010: Verify if already exists presale with the same conditions(IdModel, sale price, discount, comission)
    function IsThereSameConditionsToSale(var APreInvQtyCurrent: double; var AIdPreInvMov: integer; var OutQtyPreSale: double; var OutDiscount: double; AIdStore, AIdModel, ADocumentID, AIdComission: integer;
    ASalePrice, ADiscount: double; AInsert: boolean; AManager: boolean; pPromoDiscount: double): boolean;

    //amfsouza 10.20.2010: update quantity into preInventory
    procedure UpdateQtyPreInventory(ATotalQtyPreInventory: double;
      AIdStore, AIdModel, ADocumentID, AIdComission: integer; ASalePrice, ADiscount: double);



  end;

implementation

uses uDM, uSystemConst, uSqlFunctions, uHandleError, ConvUtils,
  uCDSFunctions, uPassword;

{$R *.dfm}

function TFrmPOSFunctions.WithdrawCashRegister(fIDCashRegMov, fIDUser : Integer;
                              f100, f50, f20, f10, f05, f02, f01,
                              f0100, f050, f025, f010, f005, f001 : Integer;
                              fTotalCash, fTotalCard, fTotalPreCard,
                              fTotalCheck, fTotalOther, fTotalDebit : Currency;
                              fEnvolop : String;
                              fDate : TDateTime;
                              fOBS: String; fIDReason: Integer):Boolean;
var
  iError : Integer;
begin

  try
    // Fecha a caixa registradora
    with spCashRegWidraw do
    begin
      Parameters.ParamByName('@IDCashRegMov').Value := fIDCashRegMov;
      Parameters.ParamByName('@IDUser').Value       := fIDUser;
      Parameters.ParamByName('@Bill100').Value      := f100;
      Parameters.ParamByName('@Bill50').Value       := f50;
      Parameters.ParamByName('@Bill20').Value       := f20;
      Parameters.ParamByName('@Bill10').Value       := f10;
      Parameters.ParamByName('@Bill5').Value        := f05;
      Parameters.ParamByName('@Bill2').Value        := f02;
      Parameters.ParamByName('@Bill1').Value        := f01;
      Parameters.ParamByName('@Coin1').Value        := f0100;
      Parameters.ParamByName('@Coin050').Value      := f050;
      Parameters.ParamByName('@Coin025').Value      := f025;
      Parameters.ParamByName('@Coin010').Value      := f010;
      Parameters.ParamByName('@Coin005').Value      := f005;
      Parameters.ParamByName('@Coin001').Value      := f001;
      Parameters.ParamByName('@TotalCash').Value    := fTotalCash;
      Parameters.ParamByName('@TotalCard').Value    := fTotalCard;
      Parameters.ParamByName('@TotalCardPre').Value := fTotalPreCard;
      Parameters.ParamByName('@TotalCheck').Value   := fTotalCheck;
      Parameters.ParamByName('@TotalOther').Value   := fTotalOther;
      Parameters.ParamByName('@TotalDebit').Value   := fTotalDebit;
      Parameters.ParamByName('@LogDocument').Value  := fEnvolop;
      Parameters.ParamByName('@Date').Value         := fDate;
      Parameters.ParamByName('@IDReason').Value     := fIDReason;
      Parameters.ParamByName('@COO').Value          := 0;
      Parameters.ParamByName('@GNF').Value          := 0;

      if Trim(fOBS) <> '' then
        Parameters.ParamByName('@OBS').Value         := fOBS
      else
        Parameters.ParamByName('@OBS').Value         := NULL;
      ExecProc;
      iError := Parameters.ParamByName('@RETURN_VALUE').Value;
      Result := (iError = 0);
    end;
  except
    Result := False;
    end;

end;

function TFrmPOSFunctions.GetTotalCashWithdraw(fIDCashRegMov:Integer):Double;
begin
  with spCashRegCalcCashWidraw do
     begin
     Parameters.ParamByName('@IDCashRegMov').Value := fIDCashRegMov;
     ExecProc;
     Result := Parameters.ParamByName('@TotalCash').Value;
     end;
end;

function TFrmPOSFunctions.AddPettyCash(fIDCashRegMov, fIDUser:Integer;
                         fCash : Currency;
                         fDate : TDateTime;
                         fIDReason : Integer;
                         fOBS: String; var fIDCashRegLog: Integer):Boolean;
begin

  try
    with spCashRegPetty do
       begin
       Parameters.ParamByName('@IDCashRegMov').Value := fIDCashRegMov;
       Parameters.ParamByName('@IDUser').Value       := fIDUser;
       Parameters.ParamByName('@TotalCash').Value    := fCash;
       Parameters.ParamByName('@Date').Value         := fDate;
       Parameters.ParamByName('@IDReason').Value     := fIDReason;
       Parameters.ParamByName('@COO').Value          := 0;
       Parameters.ParamByName('@GNF').Value          := 0;

       if Trim(fOBS) <> '' then
         Parameters.ParamByName('@OBS').Value         := fOBS
       else
         Parameters.ParamByName('@OBS').Value         := NULL;
       ExecProc;
       fIDCashRegLog := Parameters.ParamByName('@IDCashRegLog').Value;
       //fIDCashRegLog := Parameters.ParamByName('@RETURN_VALUE').Value;
       end;
    Result := True;
  except
     Result := False;
     end;
end;

function TFrmPOSFunctions.AddPayment(fIDPreSale, fIDStore, fIDUser, fIDCustomer,
                                     fIDMeioPag, fIDCashRegMov : Integer;
                                     fPreSaleDate, fExpireDate : TDateTime;
                                     fNumParcela, fAutotize : String;
                                     fTotalInvoice : Double;
                                     fCheckNumber, fCustomerDocument,
                                     fCustomerName, fCustomerPhone: String;
                                     fIDBankCheck : Integer;
                                     fOBS: String;
                                     fPaymentPlace: Integer;
                                     fIsPreDatado: Boolean):Boolean;
var
  iError : Integer;
begin
  DM.FTraceControl.TraceIn('TFrmPOSFunctions.AddPayment');

    try
      with spAddParcela do
        begin
        Parameters.ParambyName('@PreSaleID').Value      := fIDPreSale;
        Parameters.ParambyName('@IDStore').Value        := fIDStore;
        Parameters.ParambyName('@IDUser').Value         := fIDUser;
        Parameters.ParambyName('@IDCliente').Value      := fIDCustomer;
        Parameters.ParambyName('@IDMeioPag').Value      := fIDMeioPag;
        Parameters.ParambyName('@IDCashRegMov').Value   := fIDCashRegMov;

        Parameters.ParambyName('@PreSaleDate').Value    := Int(fPreSaleDate);
        Parameters.ParambyName('@ExpirationDate').Value := Int(fExpireDate);
        Parameters.ParambyName('@Parcela').Value        := fNumParcela;
        if fAutotize <> '' then
           Parameters.ParambyName('@Authorization').Value := fAutotize
        else
           Parameters.ParambyName('@Authorization').Value := Null;
        Parameters.ParambyName('@Value').Value          := fTotalInvoice;

        if fCheckNumber <> '' then
          Parameters.ParambyName('@CheckNumber').Value       := fCheckNumber
        else
          Parameters.ParambyName('@CheckNumber').Value       := Null;

        if fCustomerDocument <> '' then
          Parameters.ParambyName('@CustomerDocument').Value  := fCustomerDocument
        else
          Parameters.ParambyName('@CustomerDocument').Value  := Null;

        if fCustomerName <> '' then
          Parameters.ParambyName('@CustomerName').Value      := fCustomerName
        else
          Parameters.ParambyName('@CustomerName').Value      := Null;

        if fCustomerPhone <> '' then
          Parameters.ParambyName('@CustomerPhone').Value     := fCustomerPhone
        else
          Parameters.ParambyName('@CustomerPhone').Value     := Null;

        if fIDBankCheck <> 0 then
          Parameters.ParambyName('@IDBankCheck').Value       := fIDBankCheck
        else
          Parameters.ParambyName('@IDBankCheck').Value       := Null;

        if fOBS <> '' then
          Parameters.ParambyName('@OBS').Value     := fOBS
        else
          Parameters.ParambyName('@OBS').Value     := Null;

        Parameters.ParambyName('@PaymentPlace').Value  := fPaymentPlace;

        Parameters.ParambyName('@IsPreDatado').Value  := fIsPreDatado;


        ExecProc;

        iError := Parameters.ParamByName('@RETURN_VALUE').Value;

        Result := (iError = 0);

        if iError <> 0 then
          Raise Exception.Create('sp_PreSale_AddParcela Error ' + IntToStr(iError));
        end;
    except
      on E: Exception do
      begin
        DM.FTraceControl.SetException(E.Message, 'TFrmPOSFunctions');
        Result := False;
      end;
    end;

  DM.FTraceControl.TraceOut;
end;

function TFrmPOSFunctions.PreSalePay(fIDPreSale, fIDTourGroup, fIDOtherCommis,
                                     fIDCashRegMov, fIDStore : Integer;
                                     fDate, fPayDate : TDateTime;
                                     fCashReceived : Double; fBonusBucks: Currency;
                                     fBonusCode : String;
                                     var fIDInvoice : Integer):Boolean;
var
  sParamError: String;
  iError : Integer;
begin

  DM.FTraceControl.TraceIn('TFrmPOSFunctions.PreSalePay');

  Result := True;

   Try
     with spPreSalePay do
        begin
        Parameters.ParambyName('@PreSaleID').Value         := fIDPreSale;
        Parameters.ParambyName('@IDTouristGroup').Value    := fIDTourGroup;
        Parameters.ParambyName('@OtherComID').Value        := fIDOtherCommis;
        Parameters.ParambyName('@IDCashRegMov').Value      := fIDCashRegMov;
        Parameters.ParambyName('@IDStore').Value           := fIDStore;
        Parameters.ParambyName('@Date').Value              := fDate;
        Parameters.ParambyName('@PayDate').Value           := fPayDate;
        Parameters.ParambyName('@CashReceived').Value      := fCashReceived;
        Parameters.ParamByName('@BonusBucks').Value        := fBonusBucks;
        Parameters.ParamByName('@InvoiceCode').Value       := Null;
        Parameters.ParamByName('@BonusCode').Value         := fBonusCode;
        ExecProc;
        fIDInvoice := Parameters.ParambyName('@IDInvoice').Value;

        iError := Parameters.ParamByName('@RETURN_VALUE').Value;
        Result := (iError = 0);

        if iError <> 0 then
          Raise Exception.Create('sp_PreSale_Pay Error ' + IntToStr(iError));

        end;
    except
      on E: Exception do
      begin
        Result := False;
        sParamError := 'fIDPreSale=' + IntTostr(fIDPreSale) + ';fIDTourGroup=' +
          IntTostr(fIDTourGroup) + ';fIDOtherCommis=' + IntTostr(fIDOtherCommis) +
          ';fIDCashRegMov=' + IntTostr(fIDCashRegMov) + ';fIDStore='+IntTostr(fIDStore) +
          ';fDate=' + FormatDateTime('ddddd hh:mm', fDate) + ';fDate=' + FormatDateTime('ddddd hh:mm', fPayDate) +
          ';fCashReceived=' + CurrToStr(fCashReceived) + '.';
       DM.FTraceControl.SetException(E.Message + ' Param = ' + sParamError, 'TFrmPOSFunctions');
      end;
    end;
end;

function TFrmPOSFunctions.GetTotalCashReceived(fIDCashRegMov:Integer):Double;
begin
  with spCashRegCalcCash do
     begin
     Parameters.ParamByName('@IDCashRegMov').Value := fIDCashRegMov;
     ExecProc;
     Result := Parameters.ParamByName('@TotalCash').Value;
     end;
end;


function TFrmPOSFunctions.TestRefresh:Integer;
begin
  with quTestRefresh do
     begin
     Open;
     Result := FieldByName('InvoiceCount').AsInteger;
     Close;
     end;
end;

procedure TFrmPOSFunctions.GetCashRegisterInfo(fIDCashReg : Integer;
                                 var fCashRegName, fOpenUser : String;
                                 var fStatus : Integer;
                                 var fOpenDate : TDateTime);
begin

  with quCashRegInfo do
     begin
     Close;
     Parameters.ParamByName('IDCashRegMov').Value := fIDCashReg;
     Open;
     fCashRegName := quCashRegInfoCashRegister.AsString;
     fOpenUser    := quCashRegInfoSystemUser.AsString;
     fStatus      := quCashRegInfoIDCashregStatus.AsInteger;
     fOpenDate    := quCashRegInfoOpenTime.AsDateTime;
     Close;
     end;

end;


procedure TFrmPOSFunctions.GetCashRegisterResidual(fIDCashRegMov:Integer;
                              var fIDOpenUser : Integer;
                              var fResidual   : Double);
begin
  with quCashRegResidual do
     begin
     Parameters.ParamByName('IDCashRegMov').Value := fIDCashRegMov;
     Open;
     fIDOpenUser := quCashRegResidualIDOpenUser.AsInteger;
     fResidual   := quCashRegResidualResidual.AsFloat;
     Close;
     end;
end;


function TFrmPOSFunctions.CloseCashRegister(fIDCashRegMov, fIDUser : Integer;
                              f100, f50, f20, f10, f05, f02, f01,
                              f0100, f050, f025, f010, f005, f001 : Integer;
                              fTotalCount, fTotalCash, fTotalCard, fTotalPreCard,
                              fTotalCheck, fTotalOther, fTotalDebit : Currency;
                              fEnvolop : String;
                              fDate : TDateTime;
                              var fIDCashRegLog, fError : Integer):Boolean;
begin

   try
      // Fecha a caixa registradora
      with spCashRegClose do
      begin
        Parameters.ParamByName('@IDCashRegMov').Value := fIDCashRegMov;
        Parameters.ParamByName('@IDUser').Value       := fIDUser;
        Parameters.ParamByName('@IDUsuario').Value    := fIDUser;
        Parameters.ParamByName('@Bill100').Value      := f100;
        Parameters.ParamByName('@Bill50').Value       := f50;
        Parameters.ParamByName('@Bill20').Value       := f20;
        Parameters.ParamByName('@Bill10').Value       := f10;
        Parameters.ParamByName('@Bill5').Value        := f05;
        Parameters.ParamByName('@Bill2').Value        := f02;
        Parameters.ParamByName('@Bill1').Value        := f01;
        Parameters.ParamByName('@Coin1').Value        := f0100;
        Parameters.ParamByName('@Coin050').Value      := f050;
        Parameters.ParamByName('@Coin025').Value      := f025;
        Parameters.ParamByName('@Coin010').Value      := f010;
        Parameters.ParamByName('@Coin005').Value      := f005;
        Parameters.ParamByName('@Coin001').Value      := f001;
        Parameters.ParamByName('@FinalCount').Value   := fTotalCount;
        Parameters.ParamByName('@TotalCash').Value    := fTotalCash;
        Parameters.ParamByName('@TotalCard').Value    := fTotalCard;
        Parameters.ParamByName('@TotalCardPre').Value := fTotalPreCard;
        Parameters.ParamByName('@TotalCheck').Value   := fTotalCheck;
        Parameters.ParamByName('@TotalOther').Value   := fTotalOther;
        Parameters.ParamByName('@TotalDebit').Value   := fTotalDebit;
        Parameters.ParamByName('@LogDocument').Value  := fEnvolop;
        Parameters.ParamByName('@Date').Value         := fDate;
        ExecProc;
        fIDCashRegLog := spCashRegClose.Parameters.ParamByName('@IDCashRegLog').Value;
        fError        := Parameters.ParamByName('@RETURN_VALUE').Value; //IF Error = -1  (Error closing)
        Result        := True;
      end;
   except
      fError := -1;
      Result := False;
      end;

end;


function TFrmPOSFunctions.SubCloseCashRegister(fIDCashRegMov, fIDUser : Integer;
                              fTotalCount, fTotalCash, fTotalCard, fTotalPreCard,
                              fTotalCheck, fTotalOther, fTotalDebit : Currency;
                              fEnvolop : String;
                              fDate : TDateTime;
                              var fIDCashRegLog, fError : Integer):Boolean;
begin

   try
      // Fecha a caixa registradora
      with spCashRegSubClose do
      begin
        Parameters.ParamByName('@IDCashRegMov').Value := fIDCashRegMov;
        Parameters.ParamByName('@IDUser').Value       := fIDUser;
        Parameters.ParamByName('@IDUsuario').Value    := fIDUser;
        Parameters.ParamByName('@FinalCount').Value   := fTotalCount;
        Parameters.ParamByName('@TotalCash').Value    := fTotalCash;
        Parameters.ParamByName('@TotalCard').Value    := fTotalCard;
        Parameters.ParamByName('@TotalCardPre').Value := fTotalPreCard;
        Parameters.ParamByName('@TotalCheck').Value   := fTotalCheck;
        Parameters.ParamByName('@TotalOther').Value   := fTotalOther;
        Parameters.ParamByName('@TotalDebit').Value   := fTotalDebit;
        Parameters.ParamByName('@LogDocument').Value  := fEnvolop;
        Parameters.ParamByName('@Date').Value         := fDate;
        ExecProc;
        fIDCashRegLog := spCashRegSubClose.Parameters.ParamByName('@IDCashRegLog').Value;
        fError        := Parameters.ParamByName('@RETURN_VALUE').Value; //IF Error = -1  (Error closing)
        Result        := True;
      end;
   except
      fError := -1;
      Result := False;
      end;
end;


function TFrmPOSFunctions.QuitaLancamento(FIDCashRegMov, FIDLancamentoQuitar, FUser: Integer; FDate: TDateTime): Boolean;
begin
  Result := True;
  try
    with sp_CashRegister_QuitaLancamento do
    begin
      Parameters.ParamByName('@IDCashRegMov').Value       := FIDCashRegMov;
      Parameters.ParamByName('@IDLancamentoQuitar').Value := FIDLancamentoQuitar;
      Parameters.ParamByName('@IDUsuario').Value          := FUser;
      Parameters.ParamByName('@Date').Value               := FDate;
      ExecProc;
    end;
  except
    Result := False;
  end;
end;


function TFrmPOSFunctions.OpenCashRegister(f100, f50, f20, f10, f05, f02, f01,
                              f0100, f050, f025, f010, f005, f001 : Integer;
                              fIDCashReg, fIDUser : Integer;
                              fTotalCount, fTotalCash, fTotalCard, fTotalPreCard,
                              fTotalCheck, fTotalOther, fTotalDebit : Currency;
                              fDate : TDateTime;
                              var fIDCashRegMov, fIDCashRegLog : Integer):Boolean;
begin

  try

    with spCashRegOpen do
    begin
      Parameters.ParamByName('@Bill100').Value        := f100;
      Parameters.ParamByName('@Bill50').Value         := f50;
      Parameters.ParamByName('@Bill20').Value         := f20;
      Parameters.ParamByName('@Bill10').Value         := f10;
      Parameters.ParamByName('@Bill5').Value          := f05;
      Parameters.ParamByName('@Bill2').Value          := f02;
      Parameters.ParamByName('@Bill1').Value          := f01;
      Parameters.ParamByName('@Coin1').Value          := f0100;
      Parameters.ParamByName('@Coin050').Value        := f050;
      Parameters.ParamByName('@Coin025').Value        := f025;
      Parameters.ParamByName('@Coin010').Value        := f010;
      Parameters.ParamByName('@Coin005').Value        := f005;
      Parameters.ParamByName('@Coin001').Value        := f001;
      Parameters.ParamByName('@IDCashregister').Value := fIDCashReg;
      Parameters.ParamByName('@IDUser').Value         := fIDUser;
      Parameters.ParamByName('@OpenMoney').Value      := fTotalCount;
      Parameters.ParamByName('@TotalCash').Value      := fTotalCash;
      Parameters.ParamByName('@TotalCard').Value      := fTotalCard;
      Parameters.ParamByName('@TotalCardPre').Value   := fTotalPreCard;
      Parameters.ParamByName('@TotalCheck').Value     := fTotalCheck;
      Parameters.ParamByName('@TotalOther').Value     := fTotalOther;
      Parameters.ParamByName('@TotalDebit').Value     := fTotalDebit;
      Parameters.ParamByName('@Date').Value           := fDate;
      Parameters.ParamByName('@COO').Value            := 0;
      Parameters.ParamByName('@GNF').Value            := 0;

      ExecProc;
      fIDCashRegLog := spCashRegOpen.Parameters.ParamByName('@IDCashRegLog').Value;
      fIDCashRegMov := spCashRegOpen.Parameters.ParamByName('@IDCashRegMov').Value;
    end;
    Result := True;
  except
    Result := False;
    end;

end;

//Invoice Function s
function TFrmPOSFunctions.CreateHold(fDeliverType : Integer;
                                     fIsLayaway : Boolean; fIDStore : Integer;
                                     fFName, fLName, fZip : String;
                                     fIDTourGroup : Integer; fPreSaleDate : TDateTime;
                                     fIDCustomer, fIDMedia, fIDOtherComm : Integer;
                                     InvObs:String; var fIDPreSale: Integer):Boolean;
begin
  Dm.FTraceControl.TraceIn('TFrmPOSFunctions.CreateHold');

  try
    with spCreateHold do
      begin
        Parameters.ParambyName('@DeliverTypeID').Value     := fDeliverType;
        Parameters.ParambyName('@Layaway').Value           := fIsLayaway;
        Parameters.ParambyName('@IDStore').Value           := fIDStore;
        Parameters.ParambyName('@FirstName').Value         := fFName;
        Parameters.ParambyName('@LastName').Value          := fLName;
        Parameters.ParambyName('@ZIP').Value               := fZip;
        Parameters.ParambyName('@PreSaleDate').Value       := fPreSaleDate;
        Parameters.ParambyName('@IDCustomer').Value        := fIDCustomer;
        Parameters.ParambyName('@MediaID').Value           := fIDMedia;
        Parameters.ParambyName('@IDOtherCommission').Value := fIDOtherComm;
        Parameters.ParambyName('@CustomerDOC').Value       := Null;
        if fIDOtherComm = 0 then
           Parameters.ParambyName('@IDOtherCommission').Value := Null
        else
           Parameters.ParambyName('@IDOtherCommission').Value := fIDOtherComm;
        if fIDTourGroup = 0 then
           Parameters.ParambyName('@IDTouristGroup').Value := Null
        else
           Parameters.ParambyName('@IDTouristGroup').Value := fIDTourGroup;
        if Trim(InvObs) = '' then
           begin
           Parameters.ParambyName('@Note').Value       := Null;
           Parameters.ParambyName('@PrintNotes').Value := False;
           end
        else
           begin
           Parameters.ParambyName('@Note').Value       := InvObs;
           Parameters.ParambyName('@PrintNotes').Value := True;
           end;
        ExecProc;
        fIDPreSale := Parameters.ParambyName('@IDPreSale').Value;
      end;
     Result := True;
   except
     on E: Exception do
     begin
       Result := False;
       DM.FTraceControl.SaveTrace(DM.fUser.ID, E.Message, 'TFrmPOSFunctions');
     end;
   end;

  Dm.FTraceControl.TraceOut;
end;

function TFrmPOSFunctions.DeleteHold(fIDPreSale, fIDUser:Integer):Boolean;
begin
  try
    with spDeletePreSale do
       begin
       Parameters.ParambyName('@PreSaleID').Value := fIDPreSale;
       Parameters.ParambyName('@IDUser').Value    := fIDUser;
       ExecProc;
       end;
    Result := True;
  except
    Result := False;
    end;

end;

procedure TFrmPOSFunctions.GetQty(fIDModel, fIDStore : Integer;
                                  var OnHand, OnPreSale, OnPrePurchase, OnAvailable : Double);
begin

  with spquQuantity do
     if not Active then
        begin
        if fIDModel = 0 then
           Parameters.ParambyName('@ModelID').Value := Null
        else
           Parameters.ParambyName('@ModelID').Value := fIDModel;
        Open;
        Locate('StoreID', IntToStr(fIDStore), []);
        OnHand        := spquQuantityQtyOnHand.AsFloat;
        OnPreSale     := spquQuantityQtyOnPreSale.AsFloat;
        OnPrePurchase := spquQuantityQtyOnPrePurchase.AsFloat;
        if not DM.fSystem.SrvParam[PARAM_DISPLAY_QTY_FLOATING] then
           OnAvailable := OnHand - OnPreSale
        else
          begin
            if DM.fSystem.SrvParam[PARAM_USE_FRACTIONARY_QTY] then
               OnAvailable := (OnHand - OnPreSale) + ((OnPreSale * spquQuantityFloatPercent.AsFloat)) / 100
            else
               OnAvailable := Trunc((OnHand - OnPreSale) + ((OnPreSale * spquQuantityFloatPercent.AsFloat)) / 100);
          end;

        Close;
        end;

end;

function TFrmPOSFunctions.GetKitPrice(fIDModel : Integer; fQty : Double; fSellingPrice:Currency;
                                      var fIsEmpty : Boolean):Currency;
const
  PAR_1 = 1;
begin

  Result := fSellingPrice;
  fIsEmpty := True;

  if fQty <= 1 then
   Exit;


  with cdsKitPrice do
  try
    Filter   := '';
    Filtered := False;
    Close;
    Params.ParamByName('@IDModel').Value := fIDModel;
    Open;


    if DM.fSystem.SrvParam[PARAM_PROGRESSIVE_QTY_DISCOUNT] then
      begin

        Filter   := Format('Qty <= %f', [fQty]);
        Filtered := True;
        SetCDSIndex(cdsKitPrice, 'IDX_Qty', ['Qty'], ['Qty']);
        First;

        if not IsEmpty then
          Result := cdsKitPriceSellingPrice.AsFloat;
      end
    else
      begin
        if Locate('Qty', FloatToStr(fQty), []) then
         Result := cdsKitPriceSellingPrice.AsFloat;
      end;

    fIsEmpty := cdsKitPrice.IsEmpty;
  finally
    IndexName := '';
    Close;
    Filter   := '';
    Filtered := False;
  end;
end;

function TFrmPOSFunctions.AddHoldItem(fIDCustomer, fIDHold, fIDModel, fIDStore : Integer;
                                      fQty : Double;
                                      fDiscount, fSale, fCost : Currency;
                                      fIDUser, fIDCommis : Integer;
                                      fMovDate, fDate : TDateTime;
                                      fResetDisc, fManager : Boolean;
                                      fIDPreInvMovExchange : Integer;
                                      fDepartment : Integer;
                                      var fError, fIDPreInvMov : Integer;
                                      fIDParentPack : Integer = 0;
                                      fPromo : Boolean = False;
                                      fIDDescriptionPrice: Integer = 0;
                                      fIDVendorPrice: Integer = 0;
                                      fSuggPrice: Currency = 0;
                                      fDocumentNumber: String = '';
                                      fIDDocumentType: Integer = 0;
                                      fDiscountPromo: Currency=0): Boolean;
var
   qtyPreInventoryCurrent: double;
   OutQtyPreSale: double;
   OutDiscount: double;
   IdpreInvMov: integer;
   iError: integer;
begin
  try
    //amfsouza 10.20.2010 - if exists the same conditions.
    qtyPreInventoryCurrent := fqty;

    if ( IsThereSameConditionsToSale(qtyPreInventoryCurrent, IdPreInvMov, OutqtyPreSale, OutDiscount, fIdStore, fIdModel, fIdHold,
                                     fIdCommis, fSale, fDiscount,  true, fManager, fDiscountPromo) ) then begin
       //delete previous hold with same conditions
         if not ( DeleteHoldItem(FIdHold, IdPreInvMov, fIdModel, fIdUser, OutqtyPreSale, OutDiscount, fSale, False, False, Password.HasFuncRight(9), Now, iError) ) then
                  DeleteHoldItem(FIdHold, IdPreInvMov, fIdModel, fIdUser, OutqtyPreSale, OutDiscount, fSale, False, Password.HasFuncRight(9), Password.HasFuncRight(9), Now, iError);

       fqty := qtyPreInventoryCurrent;
    end;

    with spAddPreSaleItem do begin
       Parameters.ParambyName('@IDCliente').Value           := fIDCustomer;
       Parameters.ParambyName('@PreSaleID').Value           := fIDHold;
       Parameters.ParambyName('@ModelID').Value             := fIDModel;
       Parameters.ParambyName('@StoreID').Value             := fIDStore;
       Parameters.ParambyName('@Qty').Value                 := fQty;
       Parameters.ParambyName('@Discount').Value            := fDiscount;
       Parameters.ParambyName('@SalePrice').Value           := fSale;
       Parameters.ParambyName('@CostPrice').Value           := fCost;
       Parameters.ParambyName('@UserID').Value              := fIDUser;
       Parameters.ParambyName('@IDComission').Value         := fIDCommis;
       Parameters.ParambyName('@MovDate').Value             := fMovDate;
       Parameters.ParambyName('@Date').Value                := fDate;
       Parameters.ParambyName('@ResetDiscount').Value       := fResetDisc;
       Parameters.ParambyName('@Manager').Value             := fManager;
       Parameters.ParambyName('@IDDepartment').Value        := fDepartment;
       Parameters.ParambyName('@Promo').Value               := fPromo;
       Parameters.ParambyName('@IDDescriptionPrice').Value  := fIDDescriptionPrice;
       Parameters.ParambyName('@IDVendorPrice').Value       := fIDVendorPrice;
       Parameters.ParambyName('@SuggPrice').Value           := fSuggPrice;
       Parameters.ParambyName('@DocumentNumber').Value      := fDocumentNumber;
       Parameters.ParambyName('@IDDocumentType').Value      := fIDDocumentType;
       Parameters.ParambyName('@SequencyNum').Value         := Null;
       Parameters.ParambyName('@TotParcial').Value          := Null;
       Parameters.ParambyName('@DiscountPromo').Value       := fDiscountPromo;

       if fIDPreInvMovExchange <> 0 then
          Parameters.ParambyName('@IDPreInvMovExchange').Value := fIDPreInvMovExchange
       else
          Parameters.ParambyName('@IDPreInvMovExchange').Value := Null;
       if fIDParentPack <> 0 then
          Parameters.ParambyName('@PreInvMovParentID').Value := fIDParentPack
       else
          Parameters.ParambyName('@PreInvMovParentID').Value := Null;
       ExecProc;
       fIDPreInvMov := Parameters.ParambyName('@PreInventMovID').Value;
       fError       := Parameters.ParambyName('@RETURN_VALUE').Value;
    end;
    Result := True;
  except
        Result := False;
        fError := -1;
  end;
end;

function TFrmPOSFunctions.DeleteHoldItem(fIDHold, fIDPreInvMov, fIDModel,
                                         fIDUser : Integer; fQty : Double;
                                         fDiscount, fSale : Double;
                                         fResetDisc, fManage, SellBelowCost : Boolean;
                                         fDate:TDateTime;
                                         var fError : Integer):Boolean;
begin

  try
     with spDeletePreSaleItem do
      begin
        Parameters.ParambyName('@PreSaleID').Value      := fIDHold;
        Parameters.ParambyName('@PreInventMovID').Value := fIDPreInvMov;
        Parameters.ParambyName('@ModelID').Value        := fIDModel;
        Parameters.ParambyName('@UserID').Value         := fIDUser;
        Parameters.ParambyName('@Qty').Value            := fQty;
        Parameters.ParambyName('@Discount').Value       := fDiscount;
        Parameters.ParambyName('@SalePrice').Value      := fSale;
        Parameters.ParambyName('@ResetDiscount').Value  := fResetDisc;
        Parameters.ParambyName('@Manager').Value        := fManage;
        Parameters.ParambyName('@Date').Value           := fDate;
        Parameters.ParambyName('@SellBelowCost').Value  := SellBelowCost;
        ExecProc;
        fError := Parameters.ParambyName('@RETURN_VALUE').Value;
      end;
     Result := (fError = 0);
  except
     Result := False;
     end;

end;

function TFrmPOSFunctions.UpdateHoldItem(fIDHold, fPreInvMovID, fIDModel,
                                         fIDCommis, fIDUSer : Integer; fQty : Double;
                                         fDiscount, fSale, fCost : Double;
                                         fMovDate, fDate : TDateTime;
                                         fResetDisc, fManager : Boolean;
                                         fDepartment: Integer;
                                         var fError, fIDPreInvMov : Integer;
                                         fIDPreSaleParent : Integer = 0;
                                         fPromo : Boolean = False;
                                         fIDDescriptionPrice: Integer = 0;
                                         fIDVendorPrice: Integer = 0;
                                         fSuggPrice: Currency = 0;
                                         fDocumentNumber: String = '';
                                         fIDDocumentType: Integer = 0;
                                         fDiscountPromo: Currency=0;
                                         fIdStore: Integer = 1):Boolean;
var
(*   qtyPreInventoryCurrent: double;
   IdpreInvMov: integer; *)
   iError: integer;
begin



  try
    with spUpdatePreSaleItem do
    begin
      Parameters.ParambyName('@PreSaleID').Value          := fIDHold;
      Parameters.ParambyName('@PreInventMovID').Value     := fPreInvMovID;
      Parameters.ParambyName('@ModelID').Value            := fIDModel;
      Parameters.ParambyName('@IDComission').Value        := fIDCommis;
      Parameters.ParambyName('@UserID').Value             := fIDUSer;
      Parameters.ParambyName('@Qty').Value                := fQty;
      Parameters.ParambyName('@Discount').Value           := fDiscount;
      Parameters.ParambyName('@SalePrice').Value          := fSale;
      Parameters.ParambyName('@CostPrice').Value          := fCost;
      Parameters.ParambyName('@MovDate').Value            := fMovDate;
      Parameters.ParambyName('@Date').Value               := fDate;
      Parameters.ParambyName('@ResetDiscount').Value      := fResetDisc;
      Parameters.ParambyName('@IDDepartment').Value       := fDepartment;
      Parameters.ParambyName('@Promo').Value              := fPromo;
      Parameters.ParambyName('@Manager').Value            := fManager;
      Parameters.ParambyName('@IDDescriptionPrice').Value := fIDDescriptionPrice;
      Parameters.ParambyName('@IDVendorPrice').Value      := fIDVendorPrice;
      Parameters.ParambyName('@SuggPrice').Value          := fSuggPrice;
      Parameters.ParambyName('@DocumentNumber').Value     := fDocumentNumber;
      Parameters.ParambyName('@IDDocumentType').Value     := fIDDocumentType;
      Parameters.ParambyName('@DiscountPromo').Value      := fDiscountPromo;

      if fIDPreSaleParent <> 0 then
        Parameters.ParambyName('@PreInvMovParentID').Value := fIDPreSaleParent
      else
        Parameters.ParambyName('@PreInvMovParentID').Value := Null;

      ExecProc;
      fIDPreInvMov := Parameters.ParambyName('@PreInventMovID').Value;
      fError       := Parameters.ParambyName('@RETURN_VALUE').Value;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.RecalcTax(fIDPreSale: Integer; fDate: TDateTime):Boolean;
begin
  try
    with spRecalcTax do
    begin
      Parameters.ParambyName('@PreSaleID').Value := fIDPreSale;
      Parameters.ParambyName('@Date').Value      := fDate;
      ExecProc;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.SetExemptTax(fIDPreSale, fIDMedia: Integer; fDate: TDateTime): Boolean;
begin
  try
    with spSetTaxIsention do
    begin
      Parameters.ParambyName('@IDPreSale').Value := fIDPreSale;
      Parameters.ParambyName('@IDMedia').Value   := fIDMedia;
      Parameters.ParambyName('@Date').Value      := fDate;
      ExecProc;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.ExemptTax(fIDPreSale: Integer; fExempt: Boolean): Boolean;
begin
  try
    with cmdExemptTax do
    begin
      Parameters.ParambyName('IDPreSale').Value := fIDPreSale;
      Parameters.ParambyName('TaxIsent').Value  := fExempt;
      Execute;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.AddSpecialPrice(fIDPreSale, fIDSpecialPrice: Integer;
  fDate: TDateTime; fExemptTax: Boolean): Boolean;
begin
  try
    with spAddSpecialPrice do
    begin
      Parameters.ParambyName('@PreSaleID').Value      := fIDPreSale;
      Parameters.ParambyName('@SpecialPriceID').Value := fIDSpecialPrice;
      Parameters.ParambyName('@Date').Value           := fDate;
      Parameters.ParambyName('@ExemptTax').Value      := fExemptTax;
      ExecProc;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.DeleteSpecialPrice(fIDPreSale : Integer; fDate :TDateTime;
                  fExemptTax:Boolean):Boolean;
begin
  try
    with spDeleteSpecialPrice do
    begin
      Parameters.ParambyName('@PreSaleID').Value := fIDPreSale;
      Parameters.ParambyName('@Date').Value      := fDate;
      Parameters.ParambyName('@ExemptTax').Value := fExemptTax;

      ExecProc;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.ManageDiscount(fIDPreSale: Integer; fDiscountPercent: Double;
  fDate: TDateTime; fExemptTax, fSellBellowCost, fIsPromo: Boolean): Boolean;
begin
  try
    with spManageDiscount do
    begin
      Parameters.ParambyName('@PreSaleID').Value     := fIDPreSale;
      Parameters.ParambyName('@PercDiscount').Value  := fDiscountPercent;
      Parameters.ParambyName('@Date').Value          := fDate;
      Parameters.ParambyName('@ExemptTax').Value     := fExemptTax;
      Parameters.ParambyName('@SellBelowCost').Value := fSellBellowCost;
      Parameters.ParambyName('@IsPromo').Value       := fIsPromo;

      ExecProc;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.GetMinSaleAndMaxDiscount(fIDPreSale, fIDUser : Integer;
                                               var fMaxMinSale, fMaxDiscount : Double):Boolean;
begin

 try
  with spMaxDiscount do
   begin
     Parameters.ParambyName('@PreSaleID').Value := fIDPreSale;
     Parameters.ParambyName('@UserID').Value    := fIDUser;
     ExecProc;
     fMaxMinSale  := Parameters.ParambyName('@MaxVendaMin').Value;
     fMaxDiscount := Parameters.ParambyName('@MaxDiscount').Value;
   end;
    result := True;
  except
    Result := false;
  end;
end;

function TFrmPOSFunctions.GetSpecialPriceTotal(fIDPreSale:Integer):Double;
begin

  with spCalcFullTotal do
     begin
     Parameters.ParambyName('@IDPreSale').Value := fIDPreSale;
     ExecProc;
     Result := Parameters.ParambyName('@FullTotal').Value;
     end;

end;

function TFrmPOSFunctions.AddInvoiceAdtionalCost(fIDPreSale,
  fIDCostType: Integer; fAmount: Currency): Boolean;
begin

 try
  with spAddInvAdtionalCost do
   begin
     Parameters.ParambyName('@IDPreSale').Value   := fIDPreSale;
     Parameters.ParambyName('@IDCostType').Value  := fIDCostType;
     Parameters.ParambyName('@Amount').Value      := fAmount;
     ExecProc;
   end;
    result := True;
  except
    Result := false;
  end;

end;

function TFrmPOSFunctions.DeleteInvoiceAdtionalCost(
  fIDInvoiceCost: Integer): Boolean;
begin

 try
  with spDeleteInvAdtionalCost do
   begin
     Parameters.ParambyName('@IDInvoiceCost').Value := fIDInvoiceCost;
     ExecProc;
   end;
    result := True;
  except
    Result := false;
  end;

end;

function TFrmPOSFunctions.GetInvoicePayments(IDPreSale: Integer): Currency;
begin
   with quPaymentValue do
      begin
      if Active then
         Close;
      Parameters.ParambyName('IDPreSale').Value := IDPreSale;
      Try
         Open;
         Result := quPaymentValueTotal.AsFloat;
      finally
         Close;
         end;
      end;
end;

function TFrmPOSFunctions.CancelHold(IDPreSale, IDUser: Integer): Boolean;
begin

  Result := True;
  try
    with spPreSaleCancelHold do
       begin
       Parameters.ParamByName('@IDPreSale').Value := IDPreSale;
       Parameters.ParamByName('@IDUser').Value    := IDUser;
       ExecProc;
      end;
  except
    Result := False;
    end;

end;

function TFrmPOSFunctions.DivideHold(IDPreSale, DeliverTypeID: Integer;
                    DeliverDate: TDateTime; DeliverAddress,
                    DeliverOBS: String; var NewIDPreSale: Integer): Boolean;
begin
  Result := False;
  NewIDPreSale := -1;
  try
    with spDivideHold do
    begin
      Parameters.ParambyName('@IDPreSale').Value      := IDPreSale;
      Parameters.ParambyName('@DeliverTypeID').Value  := DeliverTypeID;
      Parameters.ParambyName('@DeliverDate').Value    := DeliverDate;
      Parameters.ParambyName('@DeliverAddress').Value := DeliverAddress;
      Parameters.ParambyName('@DeliverOBS').Value     := DeliverOBS;
      ExecProc;
      Result :=  Parameters.ParambyName('@RETURN_VALUE').Value = 0;
      NewIDPreSale := Parameters.ParambyName('@NewIDPreSale').Value;
    end;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.AddCustomerCredit(fIDPessoa, fIDUser, fIDStore, fIDLancamento : Integer;
  fCreditDate, fExpirationDate: TDateTime; fAmount: Double;
  var fIDCustomerCredit: Integer): Boolean;
begin
  fIDCustomerCredit := -1;
  try
    with spAddCustomerCredit do
    begin
      Parameters.ParamByName('@IDPessoa').Value         := fIDPessoa;
      Parameters.ParamByName('@IDUser').Value           := fIDUser;
      Parameters.ParamByName('@IDStore').Value          := fIDStore;
      Parameters.ParamByName('@CreditDate').Value       := fCreditDate;
      if fExpirationDate = 0 then
        Parameters.ParamByName('@ExpirationDate').Value := Null
      else
        Parameters.ParamByName('@ExpirationDate').Value := fExpirationDate;
      Parameters.ParamByName('@Amount').Value           := fAmount;

      if fIDLancamento = 0 then
        Parameters.ParamByName('@IDLancamento').Value   := Null
      else
        Parameters.ParamByName('@IDLancamento').Value   := fIDLancamento;

      ExecProc;
      Result                                            := Parameters.ParambyName('@RETURN_VALUE').Value = 0;
      if Result then
        fIDCustomerCredit                               := Parameters.ParamByName('@IDCustomerCredit').Value;
    end;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.GetPayType(FIDMeioPag: String): Integer;
begin
   if Trim(FIDMeioPag) = '' then
      Result := -1
   else
      Result := StrToInt(DM.DescCodigo(['IDMeioPag'], [FIDMeioPag], 'MeioPag', 'Tipo'));
end;


function TFrmPOSFunctions.IsNegativeStoreDelivery(
  IDPreSale, IDStore, IDModel: Integer; var AQtyAvaiable: Double): Boolean;
var
  fIDModel : Integer;
  fOnHand,
  fOnPreSale,
  fOnPrePurchase : Double;
begin
  Result := False;
  with quQtyInventoryPreSale do
  try
    Parameters.ParamByName('PreSaleID').Value := IDPreSale;
    Parameters.ParamByName('StoreID').Value   := IDStore;
    if IDModel = 0 then
       Parameters.ParamByName('IDModel').Value   := Null
    else
       Parameters.ParamByName('IDModel').Value   := IDModel;
    Open;
    while not EOF do
    begin
      fOnHand        := FieldByName('QtyOnHand').AsFloat;
      fOnPreSale     := FieldByName('QtyOnPreSale').AsFloat;
      fOnPrePurchase := FieldByName('QtyOnPrePurchase').AsFloat;

      if DM.fSystem.SrvParam[PARAM_INCLUDEPREPURCHASE] then
        fOnHand := fOnHand + fOnPrePurchase;

      AQtyAvaiable := fOnHand;
      if fOnHand <= 0 then
      begin
        Result := True;
        Break;
      end;

      Next;
    end;
  finally
    Close;
  end;
end;

function TFrmPOSFunctions.QtyInDelivered(IDModel, IDStore: Integer; var HasDeliver: Boolean):Double;
var
  fQtyAvailable : Double;
begin
  with quVerifyDeliveryModel do
    begin
    If Active then
       Close;
    Parameters.ParamByName('IDModel').Value := IDModel;
    Parameters.ParamByName('IDStore').Value := IDStore;
    Open;
    HasDeliver    := not (quVerifyDeliveryModelOnHand.IsNull);
    fQtyAvailable := quVerifyDeliveryModelOnHand.AsFloat;
    if DM.fSystem.SrvParam[PARAM_INCLUDEPREPURCHASE] then
       fQtyAvailable := fQtyAvailable + quVerifyDeliveryModelInPurchasing.AsFloat;
    Result := (fQtyAvailable - quVerifyDeliveryModelQty.AsFloat);
    Close;
    end;
end;

function TFrmPOSFunctions.GetCustomerDeliverOpenHold(
  IDCustomer, IDPreSale: Integer): String;
begin
  Result := '';
  with quDeliverOpenHolds do
    begin
    Parameters.ParamByName('IDCustomer').Value := IDCustomer;
    Parameters.ParamByName('IDPreSale').Value  := IDPreSale;
    Try
      Open;
      First;
      While not EOF do
        begin
        Result := Result + quDeliverOpenHoldsSaleCode.AsString;
        Next;
        if not EOF then
           Result := Result + ', ';
        end;
    Finally
      Close;
      end;
    end;
end;

function TFrmPOSFunctions.HasPaymentPending(IDPreSale: Integer): Boolean;
begin
   with quHasPendingPayment do
     begin
     if Active then
        Close;
     Parameters.ParamByName('IDPreSale').Value := IDPreSale;
     Open;
     Result := (RecordCount>0);
     Close;
     end;
end;

function TFrmPOSFunctions.CreateSaleCode(IDPreSale, IDPreSaleParent, IDStore: Integer):String;
begin
  DM.FTraceControl.TraceIn('TFrmPOSFunctions.CreateSaleCode');

  try
    with spNewSaleCode do
      begin
      if IDPreSaleParent = 0 then
         Parameters.ParambyName('@IDPreSaleParent').Value := Null
      else
         Parameters.ParambyName('@IDPreSaleParent').Value := IDPreSaleParent;

      Parameters.ParambyName('@IDStore').Value := IDStore;
      ExecProc;
      Result := Parameters.ParambyName('@SaleCode').Value;
      end;

      DM.RunSQL('UPDATE Invoice SET SaleCode = '+QuotedStr(Result)+' WHERE IDPreSale = ' + IntToStr(IDPreSale));
  except
    on E: Exception do
      DM.FTraceControl.SaveTrace(DM.fUser.ID, E.Message, 'TFrmPOSFunctions');
  end;

  DM.FTraceControl.TraceOut;
end;

function TFrmPOSFunctions.AddItemCommission(IDInventoryMov,IDPreInventoryMov:String;
  IDPessoa: Integer; Percent: Real): Boolean;
var  iID : Integer;
begin
  iID := DM.GetNextID('SaleItemCommission.IDSaleItemCommission');
  DM.RunSQL('INSERT SaleItemCommission (IDSaleItemCommission,IDInventoryMov,IDPreInventoryMov, IDCommission, CommissionPercent) ' +
            'VALUES ('+intToStr(iID) + ', ' + IDInventoryMov + ', ' + IDPreInventoryMov + ', ' + IntToStr(IDPessoa) + ', ' + FloattoStr(Percent) + ')');
end;

procedure TFrmPOSFunctions.ClearCommissionList;
begin
  if Assigned(fCommisList) and (fCommisList.Count > 0) then
     fCommisList.Clear;
end;

procedure TFrmPOSFunctions.AddSaleItemCommission(ID, PreSaleType :Integer);
var
  i: Integer;
begin
  case PreSaleType of
    SALE_INVOICE:
    begin
      DM.RunSQL('DELETE FROM SaleItemCommission WHERE IDInventoryMov = ' + InttoStr(ID) );

      for i := 0 to fCommisList.Count - 1 do
        AddItemCommission(InttoStr(ID),
                          'NULL',
                          TSalesPerson(fCommisList.Objects[I]).IDPessoa,
                          TSalesPerson(fCommisList.Objects[I]).Percent);
    end

    else
      AddPreSaleItemCommission(ID, fCommisList);
  end;
end;

procedure TFrmPOSFunctions.AddPreSaleItemCommission(ID :Integer; DefaultSalesPerson : TStringList);
var
  i: Integer;
begin
  DM.RunSQL('DELETE FROM SaleItemCommission WHERE IDPreInventoryMov = ' + InttoStr(ID) );

  for i := 0 to DefaultSalesPerson.Count - 1 do
    AddItemCommission('NULL',
                      InttoStr(ID),
                      TSalesPerson(DefaultSalesPerson.Objects[I]).IDPessoa,
                      TSalesPerson(DefaultSalesPerson.Objects[I]).Percent);
end;

procedure TFrmPOSFunctions.AddCommissionsList(ID,PreSaleType :Integer);
var
  SalesPerson: TSalesPerson;
  sWhere, sOldSQL: String;
begin
  with quSalesPerson do
  begin
    if Active then
      Close;
    sOldSQL := CommandText;

    case PreSaleType of
      SALE_INVOICE : sWhere := 'IDInventoryMov =' +InttoStr(ID)
      else
        sWhere := 'IDPreInventoryMov =' +InttoStr(ID);
    end;

    CommandText := ChangeWhereClause(CommandText, sWhere, True);

    Open;
    First;

    while not EOF do
    begin
      SalesPerson := TSalesPerson.Create;
      SalesPerson.IDPessoa := quSalesPersonIDPessoa.AsInteger;
      SalesPerson.Pessoa   := quSalesPersonPessoa.AsString;
      SalesPerson.Percent  := quSalesPersonCommissionPercent.AsFloat;
      DM.fPOS.fCommisList.AddObject(SalesPerson.Pessoa + ' - ' + FloattoStr(SalesPerson.Percent) + '%',SalesPerson);
      Next;
    end;

    Close;
    CommandText := ChangeWhereClause(sOldSQL, '', True);
  end;
end;

procedure TFrmPOSFunctions.ApplyCustomerItemDiscount(AIDPreSale, AIDCustomer,
  AIDPreInventoryMov: Integer; ADate: TDateTime);
begin
  with spApplyCustItemDiscount do
  begin
    Parameters.ParamByName('@IDPreSale').Value         := AIDPreSale;
    Parameters.ParamByName('@IDCustomer').Value        := AIDCustomer;
    Parameters.ParamByName('@IDPreInventoryMov').Value := AIDPreInventoryMov;
    Parameters.ParamByName('@Date').Value              := ADate;
    ExecProc;
  end;
end;

procedure TFrmPOSFunctions.ApplyCustomerDiscount(AIDPreSale,
  AIDCustomer: Integer; ADate: TDateTime);
begin
  with spApplyCustomerDiscount do
  begin
    Parameters.ParamByName('@IDPreSale').Value  := AIDPreSale;
    Parameters.ParamByName('@IDCustomer').Value := AIDCustomer;
    Parameters.ParamByName('@Date').Value       := ADate;
    ExecProc;
  end;
end;

function TFrmPOSFunctions.CalcCustomerDiscount(AIDCustomer,
  AIDModel: Integer; AQty, ASalePrice: Double): Currency;
begin
  with spCalcCustomerDiscount do
  begin
    Parameters.ParamByName('@IDCustomer').Value := AIDCustomer;
    Parameters.ParamByName('@IDModel').Value := AIDModel;
    Parameters.ParamByName('@Qty').Value := AQty;
    Parameters.ParamByName('@SalePrice').Value := ASalePrice;
    Parameters.ParamByName('@Discount').Value := 0;
    ExecProc;
    Result := Parameters.ParamByName('@Discount').Value;
  end;
end;

procedure TFrmPOSFunctions.ClearDefaultSalesPerson;
begin
  if Assigned(fDefaultSalesPerson) and (fDefaultSalesPerson.Count > 0) then
    fDefaultSalesPerson.Clear;
end;

function TFrmPOSFunctions.AddCash(fIDCashRegMov, fIDUser: Integer;
  fCash: Currency; fDate: TDateTime; fIDReason: Integer; fOBS: String;
  var fIDCashRegLog: Integer): Boolean;
begin
  try
    with spCashAddPayment do
       begin
       Parameters.ParamByName('@IDCashRegMov').Value := fIDCashRegMov;
       Parameters.ParamByName('@IDUser').Value       := fIDUser;
       Parameters.ParamByName('@TotalCash').Value    := fCash;
       Parameters.ParamByName('@Date').Value         := fDate;
       Parameters.ParamByName('@IDReason').Value     := fIDReason;
       Parameters.ParamByName('@COO').Value          := 0;
       Parameters.ParamByName('@GNF').Value          := 0;
       
       if Trim(fOBS) <> '' then
         Parameters.ParamByName('@OBS').Value         := fOBS
       else
         Parameters.ParamByName('@OBS').Value         := NULL;
       ExecProc;
       fIDCashRegLog := Parameters.ParamByName('@IDCashRegLog').Value;
       //fIDCashRegLog := Parameters.ParamByName('@RETURN_VALUE').Value;
       end;
    Result := True;
  except
    Result := False;
  end;
end;

function TFrmPOSFunctions.ImportEstimated(IDEstimated, IDMedia, IDStore,
  IDUser: Integer; TaxIsent, UpdateSalePrice: Boolean): Integer;
begin

  with spImporEstimated do
  try
    Parameters.ParamByName('@IDEstimated').Value     := IDEstimated;
    Parameters.ParamByName('@TaxIsent').Value        := TaxIsent;
    Parameters.ParamByName('@MediaID').Value         := IDMedia;
    Parameters.ParamByName('@IDStore').Value         := IDStore;
    Parameters.ParamByName('@IDUser').Value          := IDUser;
    Parameters.ParamByName('@UpdateSalePrice').Value := UpdateSalePrice;
    ExecProc;
    Result := Parameters.ParamByName('@NewIDPreSale').Value;

    if DM.fSystem.SrvParam[PARAM_SALECODE_ON_CREATE_SALE] then
      CreateSaleCode(Result, 0, IDStore);

  except
    raise;
    Result := -1;
  end;

end;

function TFrmPOSFunctions.CanMarkDelivery(AIDPreSale, AIDModel: Integer;
  APreSaleDate: TDateTime; AQtyAvaiable, AQtyActual: Double): Boolean;
var
  Balance : Double;
begin

  Result := False;

  with quValidateDelivery do
  try
    Parameters.ParamByName('IDModel').Value   := AIDModel;
    Parameters.ParamByName('MovDate').Value   := APreSaleDate;
    Parameters.ParamByName('IDPreSale').Value := AIDPreSale;
    Open;
    Balance := (AQtyAvaiable - quValidateDeliveryQty.AsFloat);
    if Balance <= 0 then
      Result := False
    else if (Balance - AQtyActual) >= 0 then
      Result := True;

  finally
    Close;
  end;
end;



function TFrmPOSFunctions.IsThereSameConditionsToSale(var APreInvQtyCurrent: double; var AIdPreInvMov: integer;
var OutQtyPreSale: double; var OutDiscount: double; AIdStore, AIdModel, ADocumentID, AIdComission: integer;
    ASalePrice, ADiscount: double; AInsert: boolean; AManager: boolean; pPromoDiscount: double): boolean;
var
  qry: TADOQuery;
  sql: String;
  savePreInvQtyCurrent: double;
  NewDiscount: double;
  DiscountToCondition: double;
  i: integer;
begin
  try
     qry := TADOQuery.Create(nil);
     qry.Connection := DM.ADODBConnect;

     DiscountToCondition := 0;
     savePreInvQtyCurrent := APreInvQtyCurrent;

    if ( APreInvQtyCurrent > 0 ) then
       DiscountToCondition  := ( ADiscount / APreInvQtyCurrent );

     (* I not sure yet but according to test if AManager is true some discount was applied. *)
     if ( not AManager ) then begin
        //amfsouza 05.11.2011 - get discounts
        sql := 'SELECT IsNull( Sum( IsNull(PIM.Discount,0) ), 0) NewDiscount '+
               'FROM                                             '+
               'dbo.PreInventoryMov PIM (NOLOCK)                 '+
               'WHERE                                            '+
               'PIM.DocumentID = :DocumentNumber                 '+
               'AND                                              '+
               'PIM.InventMovTypeID = 1                          '+
               'and PIM.ModelID = :modelID                       ';

        qry.SQL.Text   := sql;
        qry.Parameters.ParamByName('DocumentNumber').Value     := ADocumentId;
        qry.Parameters.ParamByName('modelID').value            := AIdModel;
        qry.Open;

        NewDiscount := qry.FieldByName('NewDiscount').Value;

        if ( ADiscount = 0 ) then
           DiscountToCondition := NewDiscount
        else
           DiscountToCondition := DiscountToCondition + NewDiscount;
     end;

    //amfsouza 10.20.2010: Verify if there are sale items that matches with conditions. So, items must be added to quantity group by conditions.
    sql := 'select sum(isnull(pim.qty, 0)) currentQty ' +
           '       ,pim.IdPreInventoryMov                ' +
           '       ,pim.discount ' +
           '       ,pim.documentID ' +
           'from PreInventoryMov pim join SaleItemCommission sic on pim.IdPreInventoryMov = sic.IdPreInventoryMov ' +
           'where ModelId = :modelId ' +
           '  and sic.IdCommission = :idcomission ' +
           '  and pim.SalePrice = :saleprice ' +
//           '  and Discount = :discount ' +
           '  and StoreId = :storeid ' +
           '  and DocumentId = :documentid ' +
           '  and pim.InventMovTypeID = 1 ' +
           'group by pim.StoreId ' +
           '        ,pim.ModelId ' +
           '        ,pim.SalePrice ' +
           '        ,pim.Discount ' +
           '        ,sic.IdCommission ' +
           '        ,pim.IdPreInventoryMov ' +
           '        ,pim.DocumentId ';

    qry.SQL.Text   := sql;

    qry.Parameters.ParamByName('modelId').Value     := AIdModel;
    qry.Parameters.ParamByName('idcomission').Value := AIdComission;
    qry.Parameters.ParamByName('saleprice').Value   := ASaleprice;

    //qry.Parameters.ParamByName('discount').Value   := DiscountToCondition;
    qry.Parameters.ParamByName('storeid').Value    := AIdStore;
    qry.Parameters.ParamByName('documentid').Value     := ADocumentId;
    qry.Open;

    while ( not qry.Eof ) do begin
      if ( qry.fieldByName('currentqty').isNull ) then begin
         result := false;
         break;
      end
      else begin
         result := true;
         if ( (APreInvQtyCurrent > 0) and (qry.fieldByName('currentQty').Value < 0) ) then
                result := false
         else if ( (APreInvQtyCurrent < 0) and (qry.FieldByName('currentQty').Value > 0)) then
             result := false;

         //amfsouza 02.04.2011 - I need sum quantity when insert an item.
         if ( result ) then begin
            if ( AInsert ) then begin
               if ( qry.FieldByName('discount').Value / qry.FieldByName('currentQty').Value = DiscountToCondition ) then begin
                   APreInvQtyCurrent := APreInvQtyCurrent + qry.FieldByName('currentQty').Value;
                   AIdPreInvMov      := qry.fieldByName('IdPreInventoryMov').value;
                   OutDiscount       := qry.FieldByName('discount').Value;
                   OutQtyPreSale     := qry.FieldByName('currentQty').Value;
                   break;
               end
               else if ( qry.FieldByName('discount').Value = DiscountToCondition ) then begin
                   APreInvQtyCurrent := APreInvQtyCurrent + qry.FieldByName('currentQty').Value;
                   AIdPreInvMov      := qry.fieldByName('IdPreInventoryMov').value;
                   OutDiscount       := qry.FieldByName('discount').Value;
                   OutQtyPreSale     := qry.FieldByName('currentQty').Value;
                   break;
               end
            end
            else begin //case update an item I need save quantity typed.
               APreInvQtyCurrent := savePreInvQtyCurrent;
               AIdPreInvMov      := qry.fieldByName('IdPreInventoryMov').value;
               result := false;
            end;
         end;
      end;
      qry.Next;
    end;

  finally
    freeAndNil(qry);
  end;
end;

procedure TFrmPOSFunctions.UpdateQtyPreInventory(
  ATotalQtyPreInventory: double; AIdStore, AIdModel, ADocumentID,
  AIdComission: integer; ASalePrice, ADiscount: double);
var
  sql: String;
  qryUpd: TADOQuery;
begin
  try
     qryUpd := TADOQuery.Create(nil);
     qryUpd.Connection := dm.ADODBConnect;

     sql := 'update PreInventoryMov ' +
            'set qty = qty + :qtycurrent ' +
            'where StoreID = :storeid ' +
            '  and ModelID = :modelid ' +
            '  and DocumentID = :documentid ' +
            '  and SalePrice  = :saleprice ' +
            '  and Discount = :discount ' +
            '  and :idcomission in (select sic.IDCommission from PreInventoryMov pim join SaleItemCommission sic on pim.IDPreInventoryMov = sic.IDPreInventoryMov) ';
     qryUpd.SQL.Text := sql;
     qryUpd.Parameters.ParamByName('qtycurrent').Value  := ATotalQtyPreInventory;
     qryUpd.Parameters.ParamByName('storeid').Value     := AIdStore;
     qryUpd.Parameters.ParamByName('modelid').Value     := AIdModel;
     qryUpd.Parameters.ParamByName('documentid').Value  := ADocumentID;
     qryUpd.Parameters.ParamByName('saleprice').Value   := ASalePrice;
     qryUpd.Parameters.ParamByName('discount').Value    := ADiscount;
     qryUpd.Parameters.ParamByName('idcomission').Value := AIdComission;

     qryUpd.ExecSQL;

  finally
     freeAndNil(qryUpd);
  end;

end;

end.