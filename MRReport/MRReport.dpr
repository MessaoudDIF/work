program MRReport;

uses
  Forms,
  MRReportMain in 'MRReportMain.pas' {MainFrm},
  uRepParentFilter in 'uRepParentFilter.pas' {RepParentFilter},
  uRepParentLookupFilter in 'uRepParentLookupFilter.pas' {RepParentLookupFilter},
  uRepParentListFilter in 'uRepParentListFilter.pas' {RepParentListFilter},
  uDMGlobal in '..\RepositoryD7\uDMGlobal.pas' {DMGlobal: TDataModule},
  uDMGlobalNTier in '..\RepositoryD7\uDMGlobalNTier.pas' {DMGlobalNTier: TDataModule},
  uDMReport in 'uDMReport.pas' {DMReport: TDataModule},
  uRepConfigFrm in 'uRepConfigFrm.pas' {RepConfigFrm},
  uRepConnectionFrm in 'uRepConnectionFrm.pas' {RepConnectionFrm},
  uReportExplorerFrm in 'uReportExplorerFrm.pas' {ReportExplorerFrm},
  uRepDateFilter in 'uRepDateFilter.pas' {RepDateFilter},
  uRepStoreFilter in 'uRepStoreFilter.pas' {RepStoreFilter},
  uRepCustomerFilter in 'uRepCustomerFilter.pas' {RepCustomerFilter},
  uRepVendorFilter in 'uRepVendorFilter.pas' {RepVendorFilter},
  uRepCategoryFilter in 'uRepCategoryFilter.pas' {RepCategoryFilter},
  uRepSubCategoryFilter in 'uRepSubCategoryFilter.pas' {RepSubCategoryFilter},
  uRepGroupFilter in 'uRepGroupFilter.pas' {RepGroupFilter},
  uRepSizeFilter in 'uRepSizeFilter.pas' {RepSizeFilter},
  uRepModelFilter in 'uRepModelFilter.pas' {RepModelFilter},
  uRepColorFilter in 'uRepColorFilter.pas' {RepColorFilter},
  uRepUserFilter in 'uRepUserFilter.pas' {RepUserFilter},
  uRepTextFilter in 'uRepTextFilter.pas' {RepTextFilter},
  uRepCheckFilter in 'uRepCheckFilter.pas' {RepCheckFilter},
  uRepNumberFilter in 'uRepNumberFilter.pas' {RepNumberFilter},
  uRepVendorListFilter in 'uRepVendorListFilter.pas' {RepVendorListFilter},
  uRepCustomerListFilter in 'uRepCustomerListFilter.pas' {RepCustomerListFilter},
  uRepUserListFilter in 'uRepUserListFilter.pas' {RepUserListFilter},
  uRepManufacturerListFilter in 'uRepManufacturerListFilter.pas' {RepManufacturerListFilter},
  uRepManufacturerFilter in 'uRepManufacturerFilter.pas' {RepManufacturerFilter},
  uRepCategoryListFilter in 'uRepCategoryListFilter.pas' {RepCategoryListFilter},
  uRepSubCategoryListFilter in 'uRepSubCategoryListFilter.pas' {RepSubCategoryListFilter},
  uRepGroupListFilter in 'uRepGroupListFilter.pas' {RepGroupListFilter},
  uRepStoreListFilter in 'uRepStoreListFilter.pas' {RepStoreListFilter},
  uRepCashRegisterFilter in 'uRepCashRegisterFilter.pas' {RepCashRegisterFilter},
  uRepCashRegisterListFilter in 'uRepCashRegisterListFilter.pas' {RepCashRegisterListFilter},
  uRepYearFilter in 'uRepYearFilter.pas' {RepYearFilter},
  uRepMonthFilter in 'uRepMonthFilter.pas' {RepMonthFilter},
  uRepLogin in 'uRepLogin.pas' {RepLoginFrm},
  MRUpdate in 'MRUpdate.pas' {UpdateFrm},
  uRepDecimalFilter in 'uRepDecimalFilter.pas' {RepDecimalFilter},
  uRepMediaListFilter in 'uRepMediaListFilter.pas' {RepMediaListFilter},
  uRepAgencyFilter in 'uRepAgencyFilter.pas' {RepAgencyFilter},
  uRepGuideFilter in 'uRepGuideFilter.pas' {RepGuideFilter},
  uRepBankFilter in 'uRepBankFilter.pas' {RepBankFilter},
  uRepChartOfAccountFilter in 'uRepChartofAccountFilter.pas' {RepChartOfAccountFilter},
  uRepBankAccountFilter in 'uRepBankAccountFilter.pas' {RepBankAccountFilter},
  uRepDocumentTypeFilter in 'uRepDocumentTypeFilter.pas' {RepDocumentTypeFilter},
  uRepPaymentTypeFilter in 'uRepPaymentTypeFilter.pas' {RepPaymentTypeFilter},
  uRepCommissiontFilter in 'uRepCommissiontFilter.pas' {RepCommissiontFilter},
  uRepCommissionListFilter in 'uRepCommissionListFilter.pas' {RepCommissionListFilter},
  uRepPetStatusFilter in 'uRepPetStatusFilter.pas' {RepPetStatusFilter},
  uRepPetStatusListFilter in 'uRepPetStatusListFilter.pas' {RepPetStatusListFilter},
  uRepPetSpeciesFilter in 'uRepPetSpeciesFilter.pas' {RepPetSpeciesFilter},
  uRepPetSpeciesListFilter in 'uRepPetSpeciesListFilter.pas' {RepPetSpeciesListFilter},
  uRepPetBreedFilter in 'uRepPetBreedFilter.pas' {RepPetBreedFilter},
  uRepPetBreedListFilter in 'uRepPetBreedListFilter.pas' {RepPetBreedListFilter},
  uRepDefectTypeFilter in 'uRepDefectTypeFilter.pas' {RepDefectTypeFilter},
  uRepDefectTypeListFilter in 'uRepDefectTypeListFilter.pas' {RepDefectTypeListFilter},
  uRepSOCustomerProductFilter in 'uRepSOCustomerProductFilter.pas' {RepSOCustomerProductFilter},
  uRepSOCustomerProductListFilter in 'uRepSOCustomerProductListFilter.pas' {RepSOCustomerProductListFilter},
  uRepSOStatusFilter in 'uRepSOStatusFilter.pas' {RepSOStatusFilter},
  uRepSOStatusListFilter in 'uRepSOStatusListFilter.pas' {RepSOStatusListFilter},
  uRepModelListFilter in 'uRepModelListFilter.pas' {RepModelListFilter},
  URepPaymentTypeListFilter in 'URepPaymentTypeListFilter.pas' {RepPaymentTypeListFilter},
  uRepCompanyFilter in 'uRepCompanyFilter.pas' {RepCompanyFilter},
  uRepGuideListFilter in 'uRepGuideListFilter.pas' {RepGuideListFilter};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDMReport, DMReport);
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.