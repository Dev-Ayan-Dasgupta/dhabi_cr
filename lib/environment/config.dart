import 'package:dialup_mobile_app/environment/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AllConfig {
  static String get appVersion => dotenv.env['APP_VERSION'] ?? "";
  static String get googleBundleId => dotenv.env['GOOGLE_BUNDLE_ID'] ?? "";
  static String get appleBundleId => dotenv.env['APPLE_BUNDLE_ID'] ?? "";
  static String get companyName => dotenv.env['COMPANY_NAME'] ?? "";
}

class EnvConfig implements BaseConfig {
  // ? Accounts APIs

  @override
  String get createAccount {
    return dotenv.env['CREATE_ACCOUNT'] ?? "";
  }

  @override
  String get getCustomerDetails {
    return dotenv.env['GET_CUSTOMER_DETAILS'] ?? "";
  }

  @override
  String get hasCustomerSingleCif {
    return dotenv.env['HAS_CUSTOMER_SINGLE_CIF'] ?? "";
  }

  @override
  String get getCustomerAccountDetails {
    return dotenv.env['GET_CUSTOMER_ACCOUNT_DETAILS'] ?? "";
  }

  @override
  String get getCustomerAccountStatement {
    return dotenv.env['GET_CUSTOMER_ACCOUNT_STATEMENT'] ?? "";
  }

  @override
  String get getExcelCustomerAccountStatement {
    return dotenv.env['GET_EXCEL_CUSTOMER_ACCOUNT_STATEMENT'] ?? "";
  }

  @override
  String get getPdfCustomerAccountStatement {
    return dotenv.env['GET_PDF_CUSTOMER_ACCOUNT_STATEMENT'] ?? "";
  }

  @override
  String get getFdRates {
    return dotenv.env['GET_FD_RATES'] ?? "";
  }

  @override
  String get createBeneficiary {
    return dotenv.env['CREATE_BENEFICIARY'] ?? "";
  }

  @override
  String get getBeneficiaries {
    return dotenv.env['GET_BENEFICIARIES'] ?? "";
  }

  @override
  String get createFd {
    return dotenv.env['CREATE_FD'] ?? "";
  }

  @override
  String get getCustomerFdAccountStatement {
    return dotenv.env['GET_CUSTOMER_FD_ACCOUNT_STATEMENT'] ?? "";
  }

  @override
  String get getCustomerFdDetails {
    return dotenv.env['GET_CUSTOMER_FD_DETAILS'] ?? "";
  }

  @override
  String get getFdPrematureWithdrawalDetails {
    return dotenv.env['GET_FD_PREMATURE_WITHDRAWAL_DETAILS'] ?? "";
  }

  @override
  String get fdPrematureWithdraw {
    return dotenv.env['FD_PREMATURE_WITHDRAW'] ?? "";
  }

  @override
  String get getLoans {
    return dotenv.env['GET_LOANS'] ?? "";
  }

  @override
  String get getLoanDetails {
    return dotenv.env['GET_LOAN_DETAILS'] ?? "";
  }

  @override
  String get getLoanStatement {
    return dotenv.env['GET_LOAN_STATEMENT'] ?? "";
  }

  @override
  String get getLoanSchedule {
    return dotenv.env['GET_LOAN_SCHEDULE'] ?? "";
  }

  @override
  String get downloadFdCertificate {
    return dotenv.env['DOWNLOAD_FD_CERTIFICATE'] ?? "";
  }

  @override
  String get removeBeneficiary {
    return dotenv.env['REMOVE_BENEFICIARY'] ?? "";
  }

  // ? Authentication APIs

  @override
  String get login {
    return dotenv.env['LOGIN'] ?? "";
  }

  @override
  String get logout {
    return dotenv.env['LOGOUT'] ?? "";
  }

  @override
  String get addNewDevice {
    return dotenv.env['ADD_NEW_DEVICE'] ?? "";
  }

  @override
  String get validateEmailOtpForPassword {
    return dotenv.env['VALIDATE_EMAIL_OTP_FOR_PASSWORD'] ?? "";
  }

  @override
  String get changePassword {
    return dotenv.env['CHANGE_PASSWORD'] ?? "";
  }

  @override
  String get isDeviceValid {
    return dotenv.env['IS_DEVICE_VALID'] ?? "";
  }

  @override
  String get renewToken {
    return dotenv.env['RENEW_TOKEN'] ?? "";
  }

  @override
  String get registeredMobileOTPRequest {
    return dotenv.env['REGISTERED_MOBILE_OTP_REQUEST'] ?? "";
  }

  @override
  String get uploadProfilePhoto {
    return dotenv.env['UPLOAD_PROFILE_PHOTO'] ?? "";
  }

  @override
  String get getProfileData {
    return dotenv.env['GET_PROFILE_DATA'] ?? "";
  }

  @override
  String get updateRetailEmailId {
    return dotenv.env['UPDATE_RETAIL_EMAIL_ID'] ?? "";
  }

  @override
  String get updateRetailMobileNumber {
    return dotenv.env['UPDATE_RETAIL_MOBILE_NUMBER'] ?? "";
  }

  @override
  String get updateRetailAddress {
    return dotenv.env['UPDATE_RETAIL_ADDRESS'] ?? "";
  }

  @override
  String get decrypt {
    return dotenv.env['DECRYPT'] ?? "";
  }

  // ? Configuration APIs

  @override
  String get getAllCountries {
    return dotenv.env['GET_ALL_COUNTRIES'] ?? "";
  }

  @override
  String get getSupportedLanguages {
    return dotenv.env['GET_SUPPORTED_LANGUAGES'] ?? "";
  }

  @override
  String get getCountryDetails {
    return dotenv.env['GET_COUNTRY_DETAILS'] ?? "";
  }

  @override
  String get getAppLabels {
    return dotenv.env['GET_APP_LABELS'] ?? "";
  }

  @override
  String get getAppMessages {
    return dotenv.env['GET_APP_MESSAGES'] ?? "";
  }

  @override
  String get getDropdownLists {
    return dotenv.env['GET_DROPDOWN_LISTS'] ?? "";
  }

  @override
  String get getTermsAndConditions {
    return dotenv.env['GET_TERMS_AND_CONDITIONS'] ?? "";
  }

  @override
  String get getPrivacyStatement {
    return dotenv.env['GET_PRIVACY_STATEMENT'] ?? "";
  }

  @override
  String get getApplicationConfigurations {
    return dotenv.env['GET_APPLICATION_CONFIGURATIONS'] ?? "";
  }

  @override
  String get getBankDetails {
    return dotenv.env['GET_BANK_DETAILS'] ?? "";
  }

  @override
  String get getDynamicFields {
    return dotenv.env['GET_DYNAMIC_FIELDS'] ?? "";
  }

  @override
  String get getTransferCapabilities {
    return dotenv.env['GET_TRANSFER_CAPABILITIES'] ?? "";
  }

  @override
  String get getFAQs {
    return dotenv.env['GET_FAQS'] ?? "";
  }

  @override
  String get getImage {
    return dotenv.env['GET_IMAGE'] ?? "";
  }

  @override
  String get getIncomeRange {
    return dotenv.env['GET_INCOME_RANGE'] ?? "";
  }

  @override
  String get getPurposeCodes {
    return dotenv.env['GET_PURPOSE_CODES'] ?? "";
  }

  @override
  String get getCountryTransferCapabilities {
    return dotenv.env['GET_COUNTRY_TRANSFER_CAPABILITIES'] ?? "";
  }

  // ? Onboarding APIs

  @override
  String get sendEmailOtp {
    return dotenv.env['SEND_EMAIL_OTP'] ?? "";
  }

  @override
  String get verifyEmailOtp {
    return dotenv.env['VERIFY_EMAIL_OTP'] ?? "";
  }

  @override
  String get validateEmail {
    return dotenv.env['VALIDATE_EMAIL'] ?? "";
  }

  @override
  String get registerUser {
    return dotenv.env['REGISTER_USER'] ?? "";
  }

  @override
  String get ifEidExists {
    return dotenv.env['IF_EID_EXISTS'] ?? "";
  }

  @override
  String get ifPassportExists {
    return dotenv.env['IF_PASSPORT_EXISTS'] ?? "";
  }

  @override
  String get uploadPersonalDetails {
    return dotenv.env['UPLOAD_PERSONAL_DETAILS'] ?? "";
  }

  @override
  String get registerRetailCustomerAddress {
    return dotenv.env['REGISTER_RETAIL_CUSTOMER_ADDRESS'] ?? "";
  }

  @override
  String get addOrUpdateIncomeSource {
    return dotenv.env['ADD_OR_UPDATE_INCOME_SOURCE'] ?? "";
  }

  @override
  String get uploadCustomerTaxInformation {
    return dotenv.env['UPLOAD_CUSTOMER_TAX_INFORMATION'] ?? "";
  }

  @override
  String get registerRetailCustomer {
    return dotenv.env['REGISTER_RETAIL_CUSTOMER'] ?? "";
  }

  @override
  String get sendMobileOtp {
    return dotenv.env['SEND_MOBILE_OTP'] ?? "";
  }

  @override
  String get verifyMobileOtp {
    return dotenv.env['VERIFY_MOBILE_OTP'] ?? "";
  }

  @override
  String get uploadEid {
    return dotenv.env['UPLOAD_EID'] ?? "";
  }

  @override
  String get uploadPassport {
    return dotenv.env['UPLOAD_PASSPORT'] ?? "";
  }

  @override
  String get createCustomer {
    return dotenv.env['CREATE_CUSTOMER'] ?? "";
  }

  // ? Corporate Onboarding APIs

  @override
  String get checkIfTradeLicenseExists {
    return dotenv.env['CHECK_IF_TRADE_LICENSE_EXISTS'] ?? "";
  }

  @override
  String get register {
    return dotenv.env['REGISTER'] ?? "";
  }

  // ? Services APIs

  @override
  String get createServiceRequest {
    return dotenv.env['CREATE_SERVICE_REQUEST'] ?? "";
  }

  // ? Notifications APIs

  @override
  String get getNotifications {
    return dotenv.env['GET_NOTIFICATIONS'] ?? "";
  }

  @override
  String get removeNotification {
    return dotenv.env['REMOVE_NOTIFICATION'] ?? "";
  }

  // ? Corporate Accounts APIs

  @override
  String get getCorporateCustomerAccountDetails {
    return dotenv.env['GET_CORPORATE_CUSTOMER_ACCOUNT_DETAILS'] ?? "";
  }

  @override
  String get getCorporateCustomerPermissions {
    return dotenv.env['GET_CORPORATE_CUSTOMER_PERMISSIONS'] ?? "";
  }

  @override
  String get createCorporateFd {
    return dotenv.env['CREATE_CORPORATE_FD'] ?? "";
  }

  @override
  String get getCorporateFdApprovalList {
    return dotenv.env['GET_CORPORATE_FD_APPROVAL_LIST'] ?? "";
  }

  @override
  String get approveOrDisapproveCorporateFd {
    return dotenv.env['APPROVE_OR_DISAPROVE_CORPORATE_FD'] ?? "";
  }

  @override
  String get createAccountCorporate {
    return dotenv.env['CREATE_ACCOUNT_CORPORATE'] ?? "";
  }

  @override
  String get changeAddress {
    return dotenv.env['CHANGE_ADDRESS'] ?? "";
  }

  @override
  String get changeMobileNumber {
    return dotenv.env['CHANGE_MOBILE_NUMBER'] ?? "";
  }

  @override
  String get changeEmailAddress {
    return dotenv.env['CHANGE_EMAIL_ADDRESS'] ?? "";
  }

  @override
  String get closeOrDeactivateAccount {
    return dotenv.env['CLOSE_OR_DEACTIVATE_ACCOUNT'] ?? "";
  }

  @override
  String get makeInternalMoneyTransferCorporate {
    return dotenv.env['MAKE_INTERNAL_MONEY_TRANSFER_CORPORATE'] ?? "";
  }

  @override
  String get makeDhabiMoneyTransfer {
    return dotenv.env['MAKE_DHABI_MONEY_TRANSFER'] ?? "";
  }

  @override
  String get makeForeignMoneyTransfer {
    return dotenv.env['MAKE_FOREIGN_MONEY_TRANSFER'] ?? "";
  }

  @override
  String get getWorkflowDetails {
    return dotenv.env['GET_WORKFLOW_DETAILS'] ?? "";
  }

  @override
  String get approveOrDisapproveWorkflow {
    return dotenv.env['APPROVE_OR_DISAPROVE_WORKFLOW'] ?? "";
  }

  // ? Payments APIs

  @override
  String get makeInternalMoneyTransfer {
    return dotenv.env['MAKE_INTERNAL_MONEY_TRANSFER'] ?? "";
  }

  @override
  String get getDhabiCustomerDetails {
    return dotenv.env['GET_DHABI_CUSTOMER_DETAILS'] ?? "";
  }

  @override
  String get getQuotation {
    return dotenv.env['GET_QUOTATION'] ?? "";
  }

  @override
  String get makeInter {
    return dotenv.env['MAKE_INTER'] ?? "";
  }

  @override
  String get getExchangeRate {
    return dotenv.env['GET_EXCHANGE_RATE'] ?? "";
  }

  @override
  String get getRecentTransactions {
    return dotenv.env['GET_RECENT_TRANSACTIONS'] ?? "";
  }

  @override
  String get getExchangeRateV2 {
    return dotenv.env['GET_EXCHANGE_RATE_V2'] ?? "";
  }

  @override
  String get makeInternationalFundTransferV2 {
    return dotenv.env['MAKE_INTERNATIONAL_FUND_TRANSFER_V2'] ?? "";
  }

  // ? Invitation APIs

  @override
  String get getInvitationPermissions {
    return dotenv.env['GET_INVITATION_PERMISSIONS'] ?? "";
  }

  @override
  String get getInvitationDetails {
    return dotenv.env['GET_INVITATION_DETAILS'] ?? "";
  }

  @override
  String get getInvitationEmail {
    return dotenv.env['GET_INVITE_EMAIL'] ?? "";
  }
}
