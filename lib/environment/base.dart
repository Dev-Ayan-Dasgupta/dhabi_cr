abstract class BaseConfig {
  // ? Accounts APIs

  String get createAccount;
  String get getCustomerDetails;
  String get hasCustomerSingleCif;
  String get getCustomerAccountDetails;
  String get getCustomerAccountStatement;
  String get getExcelCustomerAccountStatement;
  String get getPdfCustomerAccountStatement;
  String get getFdRates;
  String get createBeneficiary;
  String get getBeneficiaries;
  String get createFd;
  String get getCustomerFdAccountStatement;
  String get getCustomerFdDetails;
  String get getFdPrematureWithdrawalDetails;
  String get fdPrematureWithdraw;
  String get getLoans;
  String get getLoanDetails;
  String get getLoanStatement;
  String get getLoanSchedule;
  String get downloadFdCertificate;
  String get removeBeneficiary;

  // ? Authentication APIs

  String get login;
  String get logout;
  String get addNewDevice;
  String get validateEmailOtpForPassword;
  String get changePassword;
  String get isDeviceValid;
  String get renewToken;
  String get registeredMobileOTPRequest;
  String get uploadProfilePhoto;
  String get getProfileData;
  String get updateRetailEmailId;
  String get updateRetailMobileNumber;
  String get updateRetailAddress;
  String get decrypt;

  // ? Configuration APIs

  String get getAllCountries;
  String get getSupportedLanguages;
  String get getCountryDetails;
  String get getAppLabels;
  String get getAppMessages;
  String get getDropdownLists;
  String get getTermsAndConditions;
  String get getPrivacyStatement;
  String get getApplicationConfigurations;
  String get getBankDetails;
  String get getDynamicFields;
  String get getTransferCapabilities;
  String get getFAQs;
  String get getImage;
  String get getIncomeRange;
  String get getPurposeCodes;
  String get getCountryTransferCapabilities;

  // ? Onboarding APIs

  String get sendEmailOtp;
  String get verifyEmailOtp;
  String get validateEmail;
  String get registerUser;
  String get ifEidExists;
  String get ifPassportExists;
  String get uploadPersonalDetails;
  String get sendMobileOtp;
  String get verifyMobileOtp;
  String get registerRetailCustomerAddress;
  String get addOrUpdateIncomeSource;
  String get uploadCustomerTaxInformation;
  String get registerRetailCustomer;
  String get uploadEid;
  String get uploadPassport;
  String get createCustomer;

  // ? Corporate Onboarding APIs

  String get checkIfTradeLicenseExists;
  String get register;

  // ? Services APIs

  String get createServiceRequest;

  // ? Notification APIs

  String get getNotifications;
  String get removeNotification;

  // ? Corporate Accounts APIs

  String get getCorporateCustomerAccountDetails;
  String get getCorporateCustomerPermissions;
  String get createCorporateFd;
  String get getCorporateFdApprovalList;
  String get approveOrDisapproveCorporateFd;
  String get createAccountCorporate;
  String get changeAddress;
  String get changeMobileNumber;
  String get changeEmailAddress;
  String get closeOrDeactivateAccount;
  String get makeInternalMoneyTransferCorporate;
  String get makeDhabiMoneyTransfer;
  String get makeForeignMoneyTransfer;
  String get getWorkflowDetails;
  String get approveOrDisapproveWorkflow;

  // ? Payments APIs

  String get makeInternalMoneyTransfer;
  String get getDhabiCustomerDetails;
  String get getQuotation;
  String get makeInter;
  String get getExchangeRate;
  String get getExchangeRateV2;
  String get getRecentTransactions;
  String get makeInternationalFundTransferV2;

  // ? Invitation APIs

  String get getInvitationPermissions;
  String get getInvitationDetails;
  String get getInvitationEmail;
}
