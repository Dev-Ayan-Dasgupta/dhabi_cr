// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dialup_mobile_app/data/models/widgets/dropdown_countries.dart';
import 'package:dialup_mobile_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/data/repositories/configurations/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  log('Handling a background message ${message.messageId}');
  log("FCM Message BGHandler -> ${message.data}");
}

bool isTerraPaySupported = false;
bool isBusinessSupported = false;
double threshold = 0;
List purposeCodes = [];
List<String> purposeCodeValuesSwift = [];
List<String> purposeCodeValuesTerraPay = [];

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

bool isBioCapable = false;

String fcmToken = "";

String? deviceId;
String deviceName = "";
String deviceType = "";
String appVersion = "";

List dhabiCountries = [];
List<DropDownCountriesModel> dhabiCountriesWithFlags = [];
List<DropDownCountriesModel> dhabiCountryCodesWithFlags = [];
List<String> incomeLevels = [];

List uaeDetails = [];
List<String> emirates = [];

List banks = [];

List faqs = [];

List availableBiometrics = [];

List transferCapabilities = [];

int uaeIndex = 0;
int emptyCountries = 0;

String decryptedStoredPassword = "";

class _SplashScreenState extends State<SplashScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getBiometricCapability();
      await getDeviceId();
      await getPackageInfo();
      await getTransferCapabilities();
      await initPlatformState();
      await initConfigurations();
      await initLocalStorageData();
      await getAvailableBiometrics();
      addNewDevice();
      await initFirebaseNotifications();
      if (context.mounted) {
        navigate(context);
      }
    });
  }

  Future<void> initConfigurations() async {
    log("Init conf started");
    getApplicationConfigurations();
    getIncomeRange();
    labels = await MapAppLabels.mapAppLabels({"languageCode": "en"});
    messages = await MapAppMessages.mapAppMessages({"languageCode": "en"});
    dhabiCountries = await MapAllCountries.mapAllCountries();
    // getUaeFlagJpeg();
    getDhabiCountriesFlagsAndCodes();
    getDhabiCountryNames();
    calculateUaeIndex();
    allDDs = await MapDropdownLists.mapDropdownLists({"languageCode": "en"});
    populateDD(serviceRequestDDs, 0);
    populateDD(statementFileDDs, 1);
    populateDD(moneyTransferReasonDDs, 2);
    populateDD(typeOfAccountDDs, 3);
    populateDD(bearerDetailDDs, 4);
    populateDD(sourceOfIncomeDDs, 5);
    populateDD(noTinReasonDDs, 6);
    populateDD(statementDurationDDs, 7);
    populateDD(payoutDurationDDs, 8);
    populateDD(reasonOfSending, 9);
    populateDD(loanServiceRequest, 10);
    populateDD(walletNames, 11);
    populateDD(chargeCodes, 12);
    populateEmirates();
    getPolicies();
    getPurposeCodes();
    banks = await MapBankDetails.mapBankDetails();
    var faqData = await MapFaqs.mapFaqs();
    faqs = faqData["fAQDatas"];
    populateBankNames();
    log("Init conf ended");
  }

  Future<void> getUaeFlagJpeg() async {
    log("getImage Req -> ${{"countryShortCode": "AE"}}");
    var getImageRes = await MapImage.mapImage({"countryShortCode": "AE"});
    log("getImageRes -> $getImageRes");
  }

  void calculateUaeIndex() {
    for (var i = 0; i < dhabiCountries.length; i++) {
      if (dhabiCountries[i]["shortCode"] == "AE") {
        uaeIndex = i;
        break;
      }
    }
    // uaeIndex = uaeIndex - emptyCountries;
    log("uaeIndex -> $uaeIndex");
  }

  void getApplicationConfigurations() async {
    var result =
        await MapApplicationConfigurations.mapApplicationConfigurations();
    log("Application Config API response -> $result");
    maxSavingAccountAllowed = result["maxSavingAccountAllowed"];
    maxCurrentAccountAllowed = result["maxCurrentAccountAllowed"];
    selfieScoreMatch = result["selfieScoreMatch"];
    customerCarePhone = result["customerCarePhone"];
    log("maxSavingAccountAllowed -> $maxSavingAccountAllowed");
    log("maxCurrentAccountAllowed -> $maxCurrentAccountAllowed");
    log("selfieScoreMatch -> $selfieScoreMatch");
  }

  Future<void> getPurposeCodes() async {
    var getPurposeCodesApiRes = await MapPurposeCodes.mapPurposeCodes();
    log("getPurposeCodesApiRes -> $getPurposeCodesApiRes");
    purposeCodes = getPurposeCodesApiRes["purposeCodes"];
    purposeCodeValuesSwift.clear();
    purposeCodeValuesTerraPay.clear();
    for (var purposeCode in purposeCodes) {
      if (purposeCode["isForSwift"]) {
        purposeCodeValuesSwift.add(purposeCode["purposeCodeValue"]);
      }
      if (purposeCode["isForTerraPay"]) {
        purposeCodeValuesTerraPay.add(purposeCode["purposeCodeValue"]);
      }
    }
    log("purposeCodeValuesSwift -> $purposeCodeValuesSwift");
    log("purposeCodeValuesTerraPay -> $purposeCodeValuesTerraPay");
  }

  Future<void> getTransferCapabilities() async {
    try {
      var transferCapabilitiesAPiResult =
          await MapTransferCapabilities.mapTransferCapabilities();
      transferCapabilities =
          transferCapabilitiesAPiResult["transferCapabilities"];
      log("transferCapabilities -> $transferCapabilities");
    } catch (_) {
      // if (context.mounted) {
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return CustomDialog(
      //         svgAssetPath: ImageConstants.warning,
      //         title: "Catch block",
      //         message: "From catch block",
      //         actionWidget: GradientButton(
      //           onTap: () {
      //             Navigator.pop(context);
      //           },
      //           text: "Okay",
      //         ),
      //       );
      //     },
      //   );
      // }
      rethrow;
    }
  }

  Future<void> getIncomeRange() async {
    try {
      var incomeRangeApiResult = await MapIncomeRange.mapIncomeRange();
      log("incomeRangeApiResult -> $incomeRangeApiResult");
      incomeLevels.clear();
      for (var range in incomeRangeApiResult["ranges"]) {
        incomeLevels.add(range["value"]);
      }
      log("incomeLevels -> $incomeLevels");
    } catch (_) {
      rethrow;
    }
  }

  void getDhabiCountriesFlagsAndCodes() {
    dhabiCountriesWithFlags.clear();
    dhabiCountryCodesWithFlags.clear();

    for (var country in dhabiCountries) {
      // if (country["countryFlagBase64"] == null ||
      //     country["countryFlagBase64"] == "" ||
      //     country["dialCode"] == null ||
      //     country["dialCode"] == "" ||
      //     country["countryName"] == null ||
      //     country["countryName"] == "") {
      //   emptyCountries++;
      // } else {
      //   dhabiCountriesWithFlags.add(
      //     DropDownCountriesModel(
      //       countryFlagBase64: country["countryFlagBase64"],
      //       countrynameOrCode: country["countryName"],
      //       isEnabled: country["isEnabled"],
      //     ),
      //   );
      //   dhabiCountryCodesWithFlags.add(
      //     DropDownCountriesModel(
      //       countryFlagBase64: country["countryFlagBase64"],
      //       countrynameOrCode: "+${country["dialCode"]}",
      //       isEnabled: country["isEnabled"],
      //     ),
      //   );
      // }
      dhabiCountriesWithFlags.add(
        DropDownCountriesModel(
          countryFlagBase64: country["countryFlagBase64"],
          countrynameOrCode: country["countryName"],
          isEnabled: country["isEnabled"],
        ),
      );
      dhabiCountryCodesWithFlags.add(
        DropDownCountriesModel(
          countryFlagBase64: country["countryFlagBase64"],
          countrynameOrCode: "+${country["dialCode"]}",
          isEnabled: country["isEnabled"],
        ),
      );
    }
    log("emptyCountries -> $emptyCountries");
  }

  void getDhabiCountryNames() {
    dhabiCountryNames.clear();
    countryLongCodes.clear();
    for (var country in dhabiCountries) {
      if (country["countryFlagBase64"] != null &&
          country["dialCode"] != null &&
          country["countryName"] != null) {
        dhabiCountryNames.add(country["countryName"]);
        countryLongCodes.add(country["longCode"]);
      }
    }
  }

  void populateDD(List dropdownList, int dropdownIndex) {
    dropdownList.clear();
    for (Map<String, dynamic> item in allDDs[dropdownIndex]["items"]) {
      dropdownList.add(item["value"]);
    }
  }

  void populateEmirates() async {
    uaeDetails =
        await MapCountryDetails.mapCountryDetails({"countryShortCode": "AE"});
    emirates.clear();
    for (Map<String, dynamic> emirate in uaeDetails) {
      emirates.add(emirate["city_Name"]);
    }
  }

  void getPolicies() async {
    terms = await MapTermsAndConditions.mapTermsAndConditions(
        {"languageCode": "en"});
    statement =
        await MapPrivacyStatement.mapPrivacyStatement({"languageCode": "en"});
  }

  void populateBankNames() {
    bankNames.clear();
    for (var bank in banks) {
      bankNames.add(bank["displayName"]);
    }
    log("bankNames -> $bankNames");
  }

  Future<void> getBiometricCapability() async {
    isBioCapable = await LocalAuthentication().canCheckBiometrics;
    log("isBioCapable -> $isBioCapable");
  }

  Future<void> getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    if (!mounted) return;
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = DeviceInfoHelper.readWebBrowserInfo(
            await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData = DeviceInfoHelper.readAndroidBuildData(
              await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = DeviceInfoHelper.readIosDeviceInfo(
              await deviceInfoPlugin.iosInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    _deviceData = deviceData;

    if (Platform.isAndroid) {
      deviceType = "Android";
    } else if (Platform.isIOS) {
      deviceType = "iOS";
      deviceName = _deviceData['name'];
    }

    await storage.write(key: "deviceId", value: deviceId);
    storageDeviceId = await storage.read(key: "deviceId");

    log("deviceId -> $deviceId");
    log("deviceName -> $deviceName");
    log("deviceType -> $deviceType");
    log("appVersion -> $appVersion");
  }

  Future<void> initLocalStorageData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      await storage.delete(key: "newInstall");
      await storage.delete(key: "hasFirstLoggedIn");
      await storage.delete(key: "isFirstLogin");
      await storage.delete(key: "userId");
      await storage.delete(key: "password");
      await storage.delete(key: "emailAddress");
      await storage.delete(key: "userTypeId");
      await storage.delete(key: "companyId");
      await storage.delete(key: "persistBiometric");
      await storage.delete(key: "stepsCompleted");
      await storage.delete(key: "isEid");
      await storage.delete(key: "fullName");
      await storage.delete(key: "eiDNumber");
      await storage.delete(key: "passportNumber");
      await storage.delete(key: "nationality");
      await storage.delete(key: "nationalityCode");
      await storage.delete(key: "issuingStateCode");
      await storage.delete(key: "expiryDate");
      await storage.delete(key: "dob");
      await storage.delete(key: "gender");
      await storage.delete(key: "photo");
      await storage.delete(key: "docPhoto");
      await storage.delete(key: "selfiePhoto");
      await storage.delete(key: "photoMatchScore");
      await storage.delete(key: "addressCountry");
      await storage.delete(key: "addressLine1");
      await storage.delete(key: "addressLine2");
      await storage.delete(key: "addressCity");
      await storage.delete(key: "addressState");
      await storage.delete(key: "addressEmirate");
      await storage.delete(key: "poBox");
      await storage.delete(key: "incomeSource");
      await storage.delete(key: "incomeLevel");
      await storage.delete(key: "isUSFatca");
      await storage.delete(key: "taxCountry");
      await storage.delete(key: "isTinYes");
      await storage.delete(key: "crsTin");
      await storage.delete(key: "noTinReason");
      await storage.delete(key: "accountType");
      await storage.delete(key: "cif");
      await storage.delete(key: "isCompany");
      await storage.delete(key: "isCompanyRegistered");
      await storage.delete(key: "retailLoggedIn");
      await storage.delete(key: "customerName");
      await storage.delete(key: "chosenAccount");
      await storage.delete(key: "loggedOut");
      await storage.delete(key: "chosenAccountForCreateFD");
      await storage.delete(key: "chosenprofilePhotoBase64Account");
      await storage.delete(key: "hasSingleCif");
      prefs.setBool('first_run', false);
    }

    try {
      storageDeviceId = await storage.read(key: "deviceId");
      log("storageDeviceId -> $storageDeviceId");
      storageIsNotNewInstall =
          (await storage.read(key: "newInstall")) == "true";
      log("storageIsNotNewInstall -> $storageIsNotNewInstall");
      storageHasFirstLoggedIn =
          (await storage.read(key: "hasFirstLoggedIn")) == "true";
      log("storageHasFirstLoggedIn -> $storageHasFirstLoggedIn");
      storageIsFirstLogin = (await storage.read(key: "isFirstLogin")) == "true";
      log("storageIsFirstLogin -> $storageIsFirstLogin");

      storageHasSingleCif = (await storage.read(key: "hasSingleCif")) == "true";
      log("storageHasSingleCif -> $storageHasSingleCif");

      storageEmail = await storage.read(key: "emailAddress");
      log("storageEmail -> $storageEmail");
      storageMobileNumber = await storage.read(key: "mobileNumber");
      log("storageMobileNumber -> $storageMobileNumber");
      storagePassword = await storage.read(key: "password");
      log("storagePassword -> $storagePassword");
      storageUserId = int.parse(await storage.read(key: "userId") ?? "0");
      log("storageUserId -> $storageUserId");
      storageUserTypeId =
          int.parse(await storage.read(key: "userTypeId") ?? "1");
      log("storageUserTypeId -> $storageUserTypeId");
      storageCompanyId = int.parse(await storage.read(key: "companyId") ?? "0");
      log("storageCompanyId -> $storageCompanyId");

      persistBiometric = await storage.read(key: "persistBiometric") == "true";
      log("persistBiometric -> $persistBiometric");

      storageStepsCompleted =
          int.parse(await storage.read(key: "stepsCompleted") ?? "0");
      log("storageStepsCompleted -> $storageStepsCompleted");

      storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
      log("storageIsEid -> $storageIsEid");
      storageFullName = await storage.read(key: "fullName");
      log("storageFullName -> $storageFullName");
      storageEidNumber = await storage.read(key: "eiDNumber");
      log("storageEidNumber -> $storageEidNumber");
      storagePassportNumber = await storage.read(key: "passportNumber");
      log("storagePassportNumber -> $storagePassportNumber");
      storageNationality = await storage.read(key: "nationality");
      log("storageNationality -> $storageNationality");
      storageNationalityCode = await storage.read(key: "nationalityCode");
      log("storageNationalityCode -> $storageNationalityCode");
      storageIssuingStateCode = await storage.read(key: "issuingStateCode");
      log("storageIssuingStateCode -> $storageIssuingStateCode");
      storageExpiryDate = await storage.read(key: "expiryDate");
      log("storageExpiryDate -> $storageExpiryDate");
      storageDob = await storage.read(key: "dob");
      log("storageDob -> $storageDob");
      storageGender = await storage.read(key: "gender");
      log("storageGender -> $storageGender");
      storagePhoto = await storage.read(key: "photo");
      log("storagePhoto -> $storagePhoto");
      storageDocPhoto = await storage.read(key: "docPhoto");
      log("storageDocPhoto -> $storageDocPhoto");
      storageSelfiePhoto = await storage.read(key: "selfiePhoto");
      log("storageSelfiePhoto -> $storageSelfiePhoto");
      storagePhotoMatchScore =
          double.parse(await storage.read(key: "photoMatchScore") ?? "0");
      log("storagePhotoMatchScore -> $storagePhotoMatchScore");

      storageAddressCountry = await storage.read(key: "addressCountry");
      log("storageAddressCountry -> $storageAddressCountry");
      storageAddressLine1 = await storage.read(key: "addressLine1");
      log("storageAddressLine1 -> $storageAddressLine1");
      storageAddressLine2 = await storage.read(key: "addressLine2");
      log("storageAddressLine2 -> $storageAddressLine2");
      storageAddressCity = await storage.read(key: "addressCity");
      log("storageAddressCity -> $storageAddressCity");
      storageAddressState = await storage.read(key: "addressState");
      log("storageAddressState -> $storageAddressState");
      storageAddressEmirate = await storage.read(key: "addressEmirate");
      log("storageAddressEmirate -> $storageAddressEmirate");
      storageAddressPoBox = await storage.read(key: "poBox");
      log("storageAddressPoBox -> $storageAddressPoBox");

      storageIncomeSource = await storage.read(key: "incomeSource");
      log("storageIncomeSource -> $storageIncomeSource");

      storageIncomeLevel = await storage.read(key: "incomeLevel");
      log("storageIncomeLevel -> $storageIncomeLevel");

      storageIsUSFATCA = await storage.read(key: "isUSFatca") == "true";
      log("storageIsUSFATCA -> $storageIsUSFATCA");
      storageUsTin = await storage.read(key: "usTin");
      log("storageUsTin -> $storageUsTin");

      storageTaxCountry = await storage.read(key: "taxCountry");
      log("storageTaxCountry -> $storageTaxCountry");
      storageIsTinYes = await storage.read(key: "isTinYes") == "true";
      log("storageIsTinYes -> $storageIsTinYes");
      storageCrsTin = await storage.read(key: "crsTin");
      log("storageCrsTin -> $storageCrsTin");
      storageNoTinReason = await storage.read(key: "noTinReason");
      log("storageNoTinReason -> $storageNoTinReason");

      storageAccountType =
          int.parse(await storage.read(key: "accountType") ?? "2");
      log("storageAccountType -> $storageAccountType");

      storageCif = await storage.read(key: "cif");
      log("storageCif -> $storageCif");
      storageIsCompany = await storage.read(key: "isCompany") == "true";
      log("storageIsCompany -> $storageIsCompany");
      storageisCompanyRegistered =
          await storage.read(key: "isCompanyRegistered") == "true";
      log("storageisCompanyRegistered -> $storageisCompanyRegistered");

      storageRetailLoggedIn =
          await storage.read(key: "retailLoggedIn") == "true";
      log("storageRetailLoggedIn -> $storageRetailLoggedIn");

      storageCustomerName = await storage.read(key: "customerName");
      log("storageCustomerName -> $storageCustomerName");

      storageChosenAccount =
          int.parse(await storage.read(key: "chosenAccount") ?? "0");
      log("storageChosenAccount -> $storageChosenAccount");
      storageChosenAccountForCreateFD = int.parse(
        await storage.read(key: "chosenAccountForCreateFD") ?? "0",
      );

      storageProfilePhotoBase64 = await storage.read(key: "profilePhotoBase64");
      log("storageProfilePhotoBase64 -> $storageProfilePhotoBase64");

      storageLoggedOut = await storage.read(key: "loggedOut") == "true";
      log("storageLoggedOut -> $storageLoggedOut");

      var decryptedStoredPasswordRes = await MapDecrypt.mapDecrypt({
        "decryptedString": storagePassword ?? "",
        "uniqueId": DateTime.now().millisecondsSinceEpoch,
        "hash":
            EncryptDecrypt.encrypt("${DateTime.now().millisecondsSinceEpoch}"),
      });
      decryptedStoredPassword = decryptedStoredPasswordRes["message"];
      log("decryptedStoredPassword -> $decryptedStoredPassword");
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getAvailableBiometrics() async {
    availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
  }

  void addNewDevice() {
    if (storageIsNotNewInstall == false) {
      MapAddNewDevice.mapAddNewDevice({
        "deviceId": deviceId,
        "deviceName": deviceName,
        "deviceType": deviceType,
        "appVersion": appVersion,
      });
    }
  }

  Future<void> initFirebaseNotifications() async {
    try {
      // initialize local notification service
      LocalNotificationService.initialize("0", "");

      // initialize firebase
      await Firebase.initializeApp(
          // name: "main project",
          // options: DefaultFirebaseOptions.currentPlatform,
          );

      // request firebase permission
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      // GET FCM TOKEN
      FirebaseMessaging.instance.getToken().then((String? token) {
        if (token != null) {
          fcmToken = token;
        }
        log("FCM Token -> $token");
      });

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      // THIS WILL HELP US IN NAVIGATING TO A SCREEN WHEN APP IS TERMINATED
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) async {
        if (message != null) {
          log("FCM Message getInitialMessage -> ${message.data}");
          LocalNotificationService.display(message);
          log("Message Type -> ${message.data["MessageType"]}");
          LocalNotificationService.initialize(
            message.data["MessageType"],
            message.data["AdditionalInfo"],
          );
        }
      });

      // THIS WILL HANDLE NOTIFICATION WHEN THE APP IS IN THE BACKGROUND - either minimized or terminated
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // GET NOTIFICATION ONTO THE APP WHEN THE APP IS RUNNING IN FOREGROUND
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log("FCM Message onMessageListen -> ${message.data}");
        LocalNotificationService.display(message);
        log("Message Type -> ${message.data["MessageType"]}");
        LocalNotificationService.initialize(
          message.data["MessageType"],
          message.data["AdditionalInfo"],
        );
      });
    } catch (_) {
      rethrow;
    }
  }

  void navigate(BuildContext context) {
    if (storageIsNotNewInstall == false) {
      Navigator.pushReplacementNamed(context, Routes.onboarding,
          arguments: OnboardingArgumentModel(isInitial: true).toMap());
    } else {
      if (storageLoggedOut == true) {
        Navigator.pushReplacementNamed(
          context,
          Routes.onboarding,
          arguments: OnboardingArgumentModel(isInitial: true).toMap(),
        );
      } else {
        if (storageStepsCompleted == 0) {
          if (storageUserTypeId == 2) {
            if (storageIsFirstLogin == false) {
              Navigator.pushReplacementNamed(context, Routes.onboarding,
                  arguments: OnboardingArgumentModel(isInitial: true).toMap());
            } else {
              if (persistBiometric == true && availableBiometrics.isNotEmpty) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.loginBiometric,
                  arguments: LoginPasswordArgumentModel(
                    emailId: storageEmail ?? "",
                    userId: storageUserId ?? 0,
                    userTypeId: storageUserTypeId ?? 1,
                    companyId: storageCompanyId ?? 0,
                    isSwitching: false,
                  ).toMap(),
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.loginPassword,
                  arguments: LoginPasswordArgumentModel(
                    emailId: storageEmail ?? "",
                    userId: storageUserId ?? 0,
                    userTypeId: storageUserTypeId ?? 1,
                    companyId: storageCompanyId ?? 0,
                    isSwitching: false,
                  ).toMap(),
                );
              }
            }
          } else {
            if (persistBiometric == true && availableBiometrics.isNotEmpty) {
              Navigator.pushReplacementNamed(
                context,
                Routes.loginBiometric,
                arguments: LoginPasswordArgumentModel(
                  emailId: storageEmail ?? "",
                  userId: storageUserId ?? 0,
                  userTypeId: storageUserTypeId ?? 1,
                  companyId: storageCompanyId ?? 0,
                  isSwitching: false,
                ).toMap(),
              );
            } else {
              Navigator.pushReplacementNamed(
                context,
                Routes.loginPassword,
                arguments: LoginPasswordArgumentModel(
                  emailId: storageEmail ?? "",
                  userId: storageUserId ?? 0,
                  userTypeId: storageUserTypeId ?? 1,
                  companyId: storageCompanyId ?? 0,
                  isSwitching: false,
                ).toMap(),
              );
            }
          }
        } else {
          if (storageUserTypeId == 1) {
            if (storageStepsCompleted == 1) {
              Navigator.pushReplacementNamed(
                context,
                Routes.retailOnboardingStatus,
                arguments: OnboardingStatusArgumentModel(
                  stepsCompleted: 0,
                  isFatca: false,
                  isPassport: false,
                  isRetail: true,
                ).toMap(),
              );
            } else if (storageStepsCompleted == 2 ||
                storageStepsCompleted == 3) {
              Navigator.pushReplacementNamed(
                context,
                Routes.retailOnboardingStatus,
                arguments: OnboardingStatusArgumentModel(
                  stepsCompleted: 1,
                  isFatca: false,
                  isPassport: false,
                  isRetail: true,
                ).toMap(),
              );
            } else if (storageStepsCompleted == 4 ||
                storageStepsCompleted == 5 ||
                storageStepsCompleted == 6 ||
                storageStepsCompleted == 7 ||
                storageStepsCompleted == 8) {
              Navigator.pushReplacementNamed(
                context,
                Routes.retailOnboardingStatus,
                arguments: OnboardingStatusArgumentModel(
                  stepsCompleted: 2,
                  isFatca: false,
                  isPassport: false,
                  isRetail: true,
                ).toMap(),
              );
            } else if (storageStepsCompleted == 9) {
              Navigator.pushReplacementNamed(
                context,
                Routes.retailOnboardingStatus,
                arguments: OnboardingStatusArgumentModel(
                  stepsCompleted: 3,
                  isFatca: false,
                  isPassport: false,
                  isRetail: true,
                ).toMap(),
              );
            } else if (storageStepsCompleted == 10) {
              Navigator.pushReplacementNamed(
                context,
                Routes.retailOnboardingStatus,
                arguments: OnboardingStatusArgumentModel(
                  stepsCompleted: 4,
                  isFatca: false,
                  isPassport: false,
                  isRetail: true,
                ).toMap(),
              );
            }
          }
          if (storageUserTypeId == 2) {
            if (storageStepsCompleted == 1) {
              Navigator.pushReplacementNamed(
                context,
                Routes.createPassword,
                arguments: CreateAccountArgumentModel(
                  email: storageEmail ?? "",
                  isRetail: storageUserTypeId == 1 ? true : false,
                  userTypeId: storageUserTypeId ?? 1,
                  companyId: storageCompanyId ?? 0,
                ).toMap(),
              );
            } else if (storageStepsCompleted == 2) {
              Navigator.pushReplacementNamed(
                context,
                Routes.businessOnboardingStatus,
                arguments: OnboardingStatusArgumentModel(
                  stepsCompleted: 1,
                  isFatca: false,
                  isPassport: false,
                  isRetail: false,
                ).toMap(),
              );
            } else if (storageStepsCompleted == 11) {
              Navigator.pushReplacementNamed(
                context,
                Routes.businessOnboardingStatus,
                arguments: OnboardingStatusArgumentModel(
                  stepsCompleted: 2,
                  isFatca: false,
                  isPassport: false,
                  isRetail: false,
                ).toMap(),
              );
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstants.splashBackGround),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(ImageConstants.splashIcon),
        ),
      ),
    );
  }
}
