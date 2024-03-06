// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:local_auth/local_auth.dart';

class LoginBiometricScreen extends StatefulWidget {
  const LoginBiometricScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<LoginBiometricScreen> createState() => _LoginBiometricScreenState();
}

class _LoginBiometricScreenState extends State<LoginBiometricScreen> {
  late LoginPasswordArgumentModel loginPasswordArgument;

  bool isShowBiometric = true;
  int biometricFailedCount = 0;

  bool isSendingOtp = false;

  bool isClickable = true;

  bool isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    // AppUpdate.showUpdatePopup(context);
    biometricPrompt();
  }

  void argumentInitialization() {
    loginPasswordArgument =
        LoginPasswordArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(ImageConstants.appBarLogo),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.primary,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 15),
                      Text(
                        // "Mr. Mohamed Abood",
                        storageCustomerName ?? "",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SolidButton(
                      onTap: () {
                        if (isClickable) {
                          isShowBiometric = false;
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
                      },
                      text: "Use password instead",
                      color: Colors.white,
                      fontColor: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(
                            (4 / Dimensions.designWidth).w,
                            (4 / Dimensions.designHeight).h,
                          ),
                          blurRadius: (8 / Dimensions.designWidth).w,
                        )
                      ],
                    ),
                    SizeBox(
                      height: PaddingConstants.bottomPadding +
                          MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                )
              ],
            ),
          ),
          Ternary(
            condition: isLoggingIn,
            falsy: const SizeBox(),
            truthy: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(
                    color: AppColors.primary,
                    size: (50 / Dimensions.designWidth).w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void biometricPrompt() async {
    log("storageEmail -> $storageEmail");
    log("storagePassword -> $storagePassword");
    // await Future.delayed(const Duration(seconds: 3));
    //
    log("isShowBiometric -> $isShowBiometric");
    if (isShowBiometric) {
      if (persistBiometric!) {
        bool isBiometricSupported =
            await LocalAuthentication().isDeviceSupported();
        log("isBiometricSupported -> $isBiometricSupported");

        if (!isBiometricSupported) {
        } else {
          bool isAuthenticated = await BiometricHelper.authenticateUser();
          log("isAuthenticated -> $isAuthenticated");

          if (isAuthenticated) {
            setState(() {
              isClickable = false;
              isLoggingIn = true;
            });

            if (context.mounted) {
              onSubmit(storagePassword ?? "");
            }
          } else {
            // OpenSettings.openBiometricEnrollSetting();
            if (context.mounted) {
              biometricFailedCount++;
              log("biometricFailedCount -> $biometricFailedCount");
              // if (biometricFailedCount == 3) {
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
              // } else {
              //   bool isAuthenticated = await BiometricHelper.authenticateUser();
              //   log("isAuthenticated -> $isAuthenticated");
              // }
            }
          }
        }
      }
    }
  }

  void onSubmit(String password) async {
    var result = await MapLogin.mapLogin({
      "emailId": storageEmail,
      "userTypeId": storageUserTypeId,
      "userId": storageUserId,
      "companyId": storageCompanyId,
      "password": storagePassword,
      // EncryptDecrypt.encrypt(password),
      "deviceId": storageDeviceId,
      "registerDevice": false,
      "deviceName": deviceName,
      "deviceType": deviceType,
      "appVersion": appVersion,
      "fcmToken": fcmToken,
    });
    log("Login API Response -> $result");

    await storage.write(key: "token", value: result["token"]);
    if (result["success"]) {
      isUserLoggedIn = true;
      if (context.mounted) {
        if (result["invitationCode"] != null &&
            result["invitationCode"].isNotEmpty) {
          await PopulateInviteDetails.populateInviteDetails(
              context, result["invitationCode"]);
        }
      }

      notificationCount = result["notificationCount"];
      log("notificationCount -> $notificationCount");
      if (loginPasswordArgument.isSwitching) {
        await storage.write(
            key: "userTypeId",
            value: loginPasswordArgument.userTypeId.toString());
        storageUserTypeId =
            int.parse(await storage.read(key: "userTypeId") ?? "");
        log("storageUserTypeId -> $storageUserTypeId");

        await storage.write(
            key: "companyId",
            value: loginPasswordArgument.companyId.toString());
        storageCompanyId =
            int.parse(await storage.read(key: "companyId") ?? "");
      }

      passwordChangesToday = result["passwordChangesToday"];
      emailChangesToday = result["emailChangesToday"];
      mobileChangesToday = result["mobileChangesToday"];
      await storage.write(key: "cif", value: result["cif"]);
      storageCif = await storage.read(key: "cif");
      log("storageCif -> $storageCif");
      await storage.write(key: "newInstall", value: true.toString());
      storageIsNotNewInstall =
          (await storage.read(key: "newInstall")) == "true";
      customerName = result["customerName"];
      await storage.write(key: "customerName", value: customerName);
      storageCustomerName = await storage.read(key: "customerName");
      if (context.mounted) {
        if (loginPasswordArgument.userTypeId == 1) {
          await getProfileData();
          await storage.write(key: "loggedOut", value: false.toString());
          storageLoggedOut = await storage.read(key: "loggedOut") == "true";
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.retailDashboard,
              (route) => false,
              arguments: RetailDashboardArgumentModel(
                imgUrl: "",
                name: result["customerName"],
                isFirst: storageIsFirstLogin == true ? false : false,
              ).toMap(),
            );
          }
        } else {
          if (storageCif == null || storageCif == "null") {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Application approval pending",
                  message:
                      "You already have a registration pending. Please contact Dhabi support.",
                  auxWidget: GradientButton(
                    onTap: () async {
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.onboarding,
                          arguments: OnboardingArgumentModel(
                            isInitial: true,
                          ).toMap(),
                        );
                      }
                    },
                    text: labels[347]["labelText"],
                  ),
                  actionWidget: SolidButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: labels[166]["labelText"],
                    color: AppColors.primaryBright17,
                    fontColor: AppColors.primary,
                  ),
                );
              },
            );
          } else {
            await getProfileData();
            await storage.write(key: "loggedOut", value: false.toString());
            storageLoggedOut = await storage.read(key: "loggedOut") == "true";
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.businessDashboard,
                (route) => false,
                arguments: RetailDashboardArgumentModel(
                  imgUrl: storageProfilePhotoBase64 ?? "",
                  name: profileName ?? "",
                  isFirst: storageIsFirstLogin == true ? false : true,
                ).toMap(),
              );
            }
          }
        }
      }
      // await storage.write(key: "cif", value: cif.toString());
      // storageCif = await storage.read(key: "cif");
      // log("storageCif -> $storageCif");

      await storage.write(key: "isCompany", value: isCompany.toString());
      storageIsCompany = await storage.read(key: "isCompany") == "true";
      log("storageIsCompany -> $storageIsCompany");

      await storage.write(
          key: "isCompanyRegistered", value: isCompanyRegistered.toString());
      storageisCompanyRegistered =
          await storage.read(key: "isCompanyRegistered") == "true";
      log("storageisCompanyRegistered -> $storageisCompanyRegistered");

      await storage.write(key: "isFirstLogin", value: true.toString());
      storageIsFirstLogin = (await storage.read(key: "isFirstLogin")) == "true";
    } else {
      log("Reason Code -> ${result["reasonCode"]}");
      if (context.mounted) {
        switch (result["reasonCode"]) {
          case 1:
            // promptWrongCredentials();
            break;
          case 2:
            promptWrongCredentials();
            break;
          case 3:
            promptWrongCredentials();
            break;
          case 4:
            promptWrongCredentials();
            break;
          case 5:
            promptWrongCredentials();
            break;
          case 6:
            promptKycExpired();
            break;
          case 7:
            promptVerifySession();
            break;
          case 8:
            promptReasonCode8(result["reason"]);
            break;
          case 9:
            promptMaxRetries(result["reason"] ??
                "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.");
            break;
          case 11:
            promptAccountDormant(result["reason"]);
            break;
          case 12:
            promptAccountProcessing(result["reason"]);
            break;
          default:
        }
      }
    }
    setState(() {
      isLoggingIn = false;
    });
  }

  void promptWrongCredentials() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Wrong Credentials",
          message: "You have entered invalid username or password",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Routes.loginUserId);
            },
            text: labels[88]["labelText"],
          ),
        );
      },
    );
  }

  void promptVerifySession() {
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: messages[65]["messageText"],
          message: messages[66]["messageText"],
          auxWidget: BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return GradientButton(
                onTap: () async {
                  isLoading = true;
                  final ShowButtonBloc showButtonBloc =
                      context.read<ShowButtonBloc>();
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));
                  var result = await MapLogin.mapLogin({
                    "emailId": loginPasswordArgument.emailId,
                    "userTypeId": loginPasswordArgument.userTypeId,
                    "userId": loginPasswordArgument.userId,
                    "companyId": loginPasswordArgument.companyId,
                    "password": storagePassword,
                    // EncryptDecrypt.encrypt(storagePassword ?? ""),
                    "deviceId": storageDeviceId,
                    "registerDevice": true,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion,
                    "fcmToken": fcmToken,
                  });
                  log("Login API Response -> $result");

                  await storage.write(key: "token", value: result["token"]);
                  if (result["success"]) {
                    isUserLoggedIn = true;
                    if (context.mounted) {
                      if (result["invitationCode"] != null &&
                          result["invitationCode"].isNotEmpty) {
                        await PopulateInviteDetails.populateInviteDetails(
                            context, result["invitationCode"]);
                      }
                    }
                    notificationCount = result["notificationCount"];
                    log("notificationCount -> $notificationCount");
                    if (loginPasswordArgument.isSwitching) {
                      await storage.write(
                          key: "userTypeId",
                          value: loginPasswordArgument.userTypeId.toString());
                      storageUserTypeId = int.parse(
                          await storage.read(key: "userTypeId") ?? "");
                      log("storageUserTypeId -> $storageUserTypeId");

                      await storage.write(
                          key: "companyId",
                          value: loginPasswordArgument.companyId.toString());
                      storageCompanyId =
                          int.parse(await storage.read(key: "companyId") ?? "");
                    }

                    await storage.write(key: "cif", value: result["cif"]);
                    storageCif = await storage.read(key: "cif");
                    log("storageCif -> $storageCif");
                    passwordChangesToday = result["passwordChangesToday"];
                    emailChangesToday = result["emailChangesToday"];
                    mobileChangesToday = result["mobileChangesToday"];
                    await storage.write(
                        key: "newInstall", value: true.toString());
                    storageIsNotNewInstall =
                        (await storage.read(key: "newInstall")) == "true";
                    customerName = result["customerName"];
                    await storage.write(
                        key: "customerName", value: customerName);
                    storageCustomerName =
                        await storage.read(key: "customerName");
                    if (context.mounted) {
                      if (loginPasswordArgument.userTypeId == 1) {
                        await storage.write(
                            key: "retailLoggedIn", value: true.toString());
                        storageRetailLoggedIn =
                            await storage.read(key: "retailLoggedIn") == "true";
                        if (context.mounted) {
                          await getProfileData();
                          await storage.write(
                              key: "loggedOut", value: false.toString());
                          storageLoggedOut =
                              await storage.read(key: "loggedOut") == "true";
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.retailDashboard,
                              (route) => false,
                              arguments: RetailDashboardArgumentModel(
                                imgUrl: "",
                                name: result["customerName"],
                                isFirst:
                                    storageIsFirstLogin == true ? false : true,
                              ).toMap(),
                            );
                          }
                        }
                      } else {
                        await getProfileData();
                        await storage.write(
                            key: "loggedOut", value: false.toString());
                        storageLoggedOut =
                            await storage.read(key: "loggedOut") == "true";
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.businessDashboard,
                            (route) => false,
                            arguments: RetailDashboardArgumentModel(
                              imgUrl: storageProfilePhotoBase64 ?? "",
                              name: profileName ?? "",
                              isFirst:
                                  storageIsFirstLogin == true ? false : true,
                            ).toMap(),
                          );
                        }
                      }
                    }

                    await storage.write(
                        key: "isFirstLogin", value: true.toString());
                    storageIsFirstLogin =
                        (await storage.read(key: "isFirstLogin")) == "true";
                  } else {
                    log("Reason Code -> ${result["reasonCode"]}");
                    if (context.mounted) {
                      switch (result["reasonCode"]) {
                        case 1:
                          // promptWrongCredentials();
                          break;
                        case 2:
                          promptWrongCredentials();
                          break;
                        case 3:
                          promptWrongCredentials();
                          break;
                        case 4:
                          promptWrongCredentials();
                          break;
                        case 5:
                          promptWrongCredentials();
                          break;
                        case 6:
                          promptKycExpired();
                          break;
                        case 7:
                          promptVerifySession();
                          break;
                        case 8:
                          promptReasonCode8(result["reason"]);
                          break;
                        case 9:
                          promptMaxRetries(result["reason"] ??
                              "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.");
                          break;
                        case 11:
                          promptAccountDormant(result["reason"]);
                          break;
                        case 12:
                          promptAccountProcessing(result["reason"]);
                          break;
                        default:
                      }
                    }
                  }
                  isLoading = false;
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));
                },
                text: labels[31]["labelText"],
                auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
              );
            },
          ),
          actionWidget: SolidButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[166]["labelText"],
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
          ),
        );
      },
    );
  }

  void promptReasonCode8(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Sorry",
          message: message,
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[88]["labelText"],
          ),
        );
      },
    );
  }

  void promptAccountDormant(String message) {
    Navigator.pushNamed(
      context,
      Routes.errorSuccessScreen,
      // (route) => false,
      arguments: ErrorArgumentModel(
        hasSecondaryButton: false,
        iconPath: ImageConstants.checkCircleOutlined,
        title: "Dormant Account",
        message: message,
        buttonText: labels[347]["labelText"],
        onTap: () {
          Navigator.pop(context);
        },
        buttonTextSecondary: "",
        onTapSecondary: () {},
      ).toMap(),
    );
  }

  void promptAccountProcessing(String message) {
    Navigator.pushNamed(
      context,
      Routes.errorSuccessScreen,
      // (route) => false,
      arguments: ErrorArgumentModel(
        hasSecondaryButton: false,
        iconPath: ImageConstants.checkCircleOutlined,
        title: "Registration Pending",
        message: message,
        buttonText: labels[347]["labelText"],
        onTap: () {
          Navigator.pop(context);
        },
        buttonTextSecondary: "",
        onTapSecondary: () {},
      ).toMap(),
    );
  }

  void promptMaxRetries(String reason) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Retry Limit Reached",
          message: reason,
          actionWidget: GradientButton(
            onTap: () async {
              // Navigator.pop(context);
              if (loginPasswordArgument.isSwitching) {
                if (!isLoggingIn) {
                  final ShowButtonBloc showButtonBloc =
                      context.read<ShowButtonBloc>();
                  isLoggingIn = true;
                  showButtonBloc.add(ShowButtonEvent(show: isLoggingIn));
                  log("Login API Request -> ${{
                    "emailId": loginPasswordArgument.emailId,
                    "userTypeId": storageUserTypeId ?? 1,
                    "userId": loginPasswordArgument.userId,
                    "companyId": storageCompanyId ?? 0,
                    "password": storagePassword,
                    // EncryptDecrypt.encrypt(storagePassword ?? ""),
                    "deviceId": storageDeviceId,
                    "registerDevice": false,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion,
                    "fcmToken": fcmToken,
                  }}");

                  var result = await MapLogin.mapLogin({
                    "emailId": loginPasswordArgument.emailId,
                    "userTypeId": storageUserTypeId ?? 1,
                    "userId": loginPasswordArgument.userId,
                    "companyId": storageCompanyId ?? 0,
                    "password": storagePassword,
                    // EncryptDecrypt.encrypt(storagePassword ?? ""),
                    "deviceId": storageDeviceId,
                    "registerDevice": false,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion,
                    "fcmToken": fcmToken,
                  });
                  log("Login API Response -> $result");

                  await storage.write(key: "token", value: result["token"]);
                  if (result["success"]) {
                    isUserLoggedIn = true;
                    if (context.mounted) {
                      if (result["invitationCode"] != null &&
                          result["invitationCode"].isNotEmpty) {
                        await PopulateInviteDetails.populateInviteDetails(
                            context, result["invitationCode"]);
                      }
                    }
                    notificationCount = result["notificationCount"];
                    log("notificationCount -> $notificationCount");
                    isLoggingIn = false;
                    showButtonBloc.add(ShowButtonEvent(show: isLoggingIn));
                    if (context.mounted) {
                      if (storageUserTypeId == 1) {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.retailDashboard,
                          arguments: RetailDashboardArgumentModel(
                            imgUrl: profilePhotoBase64 ?? "",
                            name: profileName ?? "",
                            isFirst: false,
                          ).toMap(),
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.businessDashboard,
                          arguments: RetailDashboardArgumentModel(
                            imgUrl: profilePhotoBase64 ?? "",
                            name: profileName ?? "",
                            isFirst: false,
                          ).toMap(),
                        );
                      }
                    }
                  }
                }
              } else {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.onboarding,
                    arguments: OnboardingArgumentModel(isInitial: true).toMap(),
                  );
                }
              }
            },
            text: "Go Home",
            auxWidget: isLoggingIn ? const LoaderRow() : const SizeBox(),
          ),
        );
      },
    );
  }

  void promptKycExpired() async {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Identification Document Expired",
          message:
              "${messages[9]["messageText"]} ${messages[10]["messageText"]}",
          actionWidget: BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return GradientButton(
                onTap: () async {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.verificationInitializing,
                    arguments: VerificationInitializationArgumentModel(
                      isReKyc: true,
                    ).toMap(),
                  );
                },
                text: "Verify",
                auxWidget: isSendingOtp ? const LoaderRow() : const SizeBox(),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> getProfileData() async {
    try {
      var getProfileDataResult =
          await MapProfileData.mapProfileData(token ?? "");
      log("getProfileDataResult -> $getProfileDataResult");
      if (getProfileDataResult["success"]) {
        profileName = getProfileDataResult["name"];
        await storage.write(key: "customerName", value: profileName);
        storageCustomerName = await storage.read(key: "customerName");

        profilePhotoBase64 = getProfileDataResult["profileImageBase64"];
        await storage.write(
            key: "profilePhotoBase64", value: profilePhotoBase64);
        storageProfilePhotoBase64 =
            await storage.read(key: "profilePhotoBase64");
        profileDoB = getProfileDataResult["dateOfBirth"];
        profileEmailId = getProfileDataResult["emailID"];
        profileMobileNumber = getProfileDataResult["mobileNumber"];
        profileAddressLine1 = getProfileDataResult["addressLine_1"];
        profileAddressLine2 = getProfileDataResult["addressLine_2"];
        profileCity = getProfileDataResult["city"] ?? "";
        profileState = getProfileDataResult["state"] ?? "";
        profilePinCode = getProfileDataResult["pinCode"];
        profileCountryCode = getProfileDataResult["countryCode"];

        await storage.write(key: "emailAddress", value: profileEmailId);
        storageEmail = await storage.read(key: "emailAddress");
        await storage.write(key: "mobileNumber", value: profileMobileNumber);
        storageMobileNumber = await storage.read(key: "mobileNumber");

        await storage.write(key: "addressLine1", value: profileAddressLine1);
        storageAddressLine1 = await storage.read(key: "addressLine1");
        await storage.write(key: "addressLine2", value: profileAddressLine2);
        storageAddressLine2 = await storage.read(key: "addressLine2");

        await storage.write(key: "addressCity", value: profileCity);
        storageAddressCity = await storage.read(key: "addressCity");
        await storage.write(key: "addressState", value: profileState);
        storageAddressState = await storage.read(key: "addressState");

        await storage.write(key: "poBox", value: profilePinCode);
        storageAddressPoBox = await storage.read(key: "poBox");

        profileAddress =
            "$profileAddressLine1${profileAddressLine1 == "" ? '' : ",\n"}$profileAddressLine2${profileAddressLine2 == "" ? '' : ",\n"}$profileCity${profileCity == "" ? '' : ",\n"}$profileState${profileState == "" ? '' : ",\n"}$profilePinCode";

        log("profileName -> $profileName");
        log("profilePhotoBase64 -> $profilePhotoBase64");
        log("profileDoB -> $profileDoB");
        log("profileEmailId -> $profileEmailId");
        log("profileMobileNumber -> $profileMobileNumber");
        log("profileAddress -> $profileAddress");
      }
    } catch (_) {
      rethrow;
    }
  }
}
