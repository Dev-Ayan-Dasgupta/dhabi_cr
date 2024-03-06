// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/matchPassword/match_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_event.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_state.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class LoginPasswordScreen extends StatefulWidget {
  const LoginPasswordScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;

  bool isMatch = true;

  int matchPasswordErrorCount = 0;
  int toggle = 0;

  bool isLoading = false;

  bool isPwdBlank = false;

  bool isSendingOtp = false;

  late LoginPasswordArgumentModel loginPasswordArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    // biometricPrompt();
    // AppUpdate.showUpdatePopup(context);
  }

  void argumentInitialization() {
    loginPasswordArgument =
        LoginPasswordArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      log("constraints.maxWidth -> ${constraints.maxWidth}");
      // if (constraints.maxWidth >= 480) {
      //   return Text("Hello world");
      // }
      // else {
      return Scaffold(
        appBar: AppBar(
          leading: const AppBarLeading(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[214]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Enter Password",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.black63,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 10),
                    BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                      builder: buildShowHidePassword,
                    ),
                    const SizeBox(height: 7),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: buildErrorMessage,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  BlocBuilder<MatchPasswordBloc, MatchPasswordState>(
                    builder: buildLoginButton,
                  ),
                  const SizeBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: onForgotEmailPwd,
                      child: Text(
                        labels[47]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primaryLighter,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  ),
                  SizeBox(
                    height: PaddingConstants.bottomPadding +
                        MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      // }
    });
  }

  Widget buildShowHidePassword(BuildContext context, ShowPasswordState state) {
    if (showPassword) {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return CustomTextField(
            borderColor:
                isPwdBlank ? AppColors.red100 : const Color(0xFFEEEEEE),
            controller: _passwordController,
            minLines: 1,
            maxLines: 1,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
              child: InkWell(
                onTap: hidePassword,
                child: Icon(
                  Icons.visibility_outlined,
                  color: const Color.fromRGBO(34, 97, 105, 0.5),
                  size: (20 / Dimensions.designWidth).w,
                ),
              ),
            ),
            onChanged: onChanged,
            obscureText: !showPassword,
          );
        },
      );
    } else {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return CustomTextField(
            borderColor:
                isPwdBlank ? AppColors.red100 : const Color(0xFFEEEEEE),
            controller: _passwordController,
            minLines: 1,
            maxLines: 1,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
              child: InkWell(
                onTap: showsPassword,
                child: Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.primaryBright50,
                  size: (20 / Dimensions.designWidth).w,
                ),
              ),
            ),
            onChanged: onChanged,
            obscureText: !showPassword,
          );
        },
      );
    }
  }

  void hidePassword() {
    final ShowPasswordBloc showPasswordBloc = context.read<ShowPasswordBloc>();
    showPasswordBloc
        .add(HidePasswordEvent(showPassword: false, toggle: ++toggle));
    showPassword = !showPassword;
  }

  void showsPassword() {
    final ShowPasswordBloc showPasswordBloc = context.read<ShowPasswordBloc>();
    showPasswordBloc
        .add(DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
    showPassword = !showPassword;
  }

  void onChanged(String p0) {
    isPwdBlank = false;
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isPwdBlank));
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    if (p0 == "AyanDg16@#") {
      isMatch = true;
      matchPasswordBloc.add(
          MatchPasswordEvent(isMatch: isMatch, count: matchPasswordErrorCount));
    } else {
      isMatch = true;
      matchPasswordBloc.add(
          MatchPasswordEvent(isMatch: isMatch, count: matchPasswordErrorCount));
    }
  }

  void onSubmit(String password) async {
    log("companyID -> ${loginPasswordArgument.companyId}");
    log("userTypeId -> ${loginPasswordArgument.userTypeId}");
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    isLoading = true;
    matchPasswordBloc
        .add(MatchPasswordEvent(isMatch: isMatch, count: ++toggle));

    log("Login API Request -> ${{
      "emailId": loginPasswordArgument.emailId,
      "userTypeId": loginPasswordArgument.userTypeId,
      "userId": loginPasswordArgument.userId,
      "companyId": loginPasswordArgument.companyId,
      "password": EncryptDecrypt.encrypt(_passwordController.text),
      "deviceId": storageDeviceId,
      "registerDevice": false,
      "deviceName": deviceName,
      "deviceType": deviceType,
      "appVersion": appVersion,
      "fcmToken": fcmToken,
    }}");

    var result = await MapLogin.mapLogin({
      "emailId": loginPasswordArgument.emailId,
      "userTypeId": loginPasswordArgument.userTypeId,
      "userId": loginPasswordArgument.userId,
      "companyId": loginPasswordArgument.companyId,
      "password": EncryptDecrypt.encrypt(_passwordController.text),
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

      passwordChangesToday = result["passwordChangesToday"];
      emailChangesToday = result["emailChangesToday"];
      mobileChangesToday = result["mobileChangesToday"];

      var decryptedStoredPasswordRes = await MapDecrypt.mapDecrypt({
        "decryptedString": EncryptDecrypt.encrypt(_passwordController.text),
        "uniqueId": DateTime.now().millisecondsSinceEpoch,
        "hash":
            EncryptDecrypt.encrypt("${DateTime.now().millisecondsSinceEpoch}"),
      });
      decryptedStoredPassword = decryptedStoredPasswordRes["message"];
      log("decryptedStoredPassword -> $decryptedStoredPassword");

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
        log("storageCompanyId -> $storageCompanyId");
      }

      await storage.write(
          key: "companyId", value: loginPasswordArgument.companyId.toString());
      storageCompanyId = int.parse(await storage.read(key: "companyId") ?? "");
      log("storageCompanyId -> $storageCompanyId");

      await storage.write(
          key: "userTypeId",
          value: loginPasswordArgument.userTypeId.toString());
      storageUserTypeId =
          int.parse(await storage.read(key: "userTypeId") ?? "");

      await storage.write(key: "cif", value: result["cif"]);
      storageCif = await storage.read(key: "cif");
      log("storageCif -> $storageCif");
      await storage.write(key: "newInstall", value: true.toString());
      storageIsNotNewInstall =
          (await storage.read(key: "newInstall")) == "true";

      customerName = result["customerName"];
      await storage.write(key: "customerName", value: customerName);
      storageCustomerName = await storage.read(key: "customerName");
      await storage.write(
        key: "password",
        value: EncryptDecrypt.encrypt(_passwordController.text),
        // _passwordController.text,
      );
      storagePassword = await storage.read(key: "password");
      log("storagePassword -> $storagePassword");
      await persistOnboardingState(result["onboardingState"]);
      if (result["isTemporaryPassword"]) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.setPassword,
            arguments: SetPasswordArgumentModel(
              fromTempPassword: true,
              userTypeId: loginPasswordArgument.userTypeId,
              companyId: loginPasswordArgument.companyId,
            ).toMap(),
          );
        }
      } else {
        if (result["onboardingState"] == 5 || result["onboardingState"] == 10) {
          if (context.mounted) {
            if (loginPasswordArgument.userTypeId == 1) {
              await storage.write(
                  key: "retailLoggedIn", value: true.toString());
              storageRetailLoggedIn =
                  await storage.read(key: "retailLoggedIn") == "true";
              if (context.mounted) {
                await getProfileData();
                await storage.write(key: "loggedOut", value: false.toString());
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
                      isFirst: storageIsFirstLogin == true ? false : true,
                    ).toMap(),
                  );
                }
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
                      isFirst: storageIsFirstLogin == true ? false : true,
                    ).toMap(),
                  );
                }
              }
            }
          }
        }
      }

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
            promptMaxRetries(result["reason"]);
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
    matchPasswordBloc
        .add(MatchPasswordEvent(isMatch: isMatch, count: ++toggle));
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
            },
            text: labels[88]["labelText"],
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
                  if (!isLoading) {
                    isLoading = true;
                    final ShowButtonBloc showButtonBloc =
                        context.read<ShowButtonBloc>();
                    showButtonBloc.add(ShowButtonEvent(show: isLoading));
                    var result = await MapLogin.mapLogin({
                      "emailId": loginPasswordArgument.emailId,
                      "userTypeId": loginPasswordArgument.userTypeId,
                      "userId": loginPasswordArgument.userId,
                      "companyId": loginPasswordArgument.companyId,
                      "password":
                          EncryptDecrypt.encrypt(_passwordController.text),
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
                        storageCompanyId = int.parse(
                            await storage.read(key: "companyId") ?? "");
                        log("storageCompanyId -> $storageCompanyId");
                      }

                      await storage.write(
                          key: "companyId",
                          value: loginPasswordArgument.companyId.toString());
                      storageCompanyId =
                          int.parse(await storage.read(key: "companyId") ?? "");
                      log("storageCompanyId -> $storageCompanyId");

                      passwordChangesToday = result["passwordChangesToday"];
                      emailChangesToday = result["emailChangesToday"];
                      mobileChangesToday = result["mobileChangesToday"];

                      var decryptedStoredPasswordRes =
                          await MapDecrypt.mapDecrypt({
                        "decryptedString":
                            EncryptDecrypt.encrypt(_passwordController.text),
                        "uniqueId": DateTime.now().millisecondsSinceEpoch,
                        "hash": EncryptDecrypt.encrypt(
                            "${DateTime.now().millisecondsSinceEpoch}"),
                      });
                      decryptedStoredPassword =
                          decryptedStoredPasswordRes["message"] ?? "";
                      log("decryptedStoredPassword -> $decryptedStoredPassword");

                      await storage.write(key: "cif", value: result["cif"]);
                      storageCif = await storage.read(key: "cif");
                      log("storageCif -> $storageCif");

                      await persistOnboardingState(result["onboardingState"]);
                      if (result["isTemporaryPassword"]) {
                        if (context.mounted) {
                          Navigator.pushNamed(
                            context,
                            Routes.setPassword,
                            arguments: SetPasswordArgumentModel(
                              fromTempPassword: true,
                              userTypeId: loginPasswordArgument.userTypeId,
                              companyId: loginPasswordArgument.companyId,
                            ).toMap(),
                          );
                        }
                      } else {
                        if (result["onboardingState"] == 5 ||
                            result["onboardingState"] == 10) {
                          if (context.mounted) {
                            if (loginPasswordArgument.userTypeId == 1) {
                              await storage.write(
                                  key: "retailLoggedIn",
                                  value: true.toString());
                              storageRetailLoggedIn =
                                  await storage.read(key: "retailLoggedIn") ==
                                      "true";
                              if (context.mounted) {
                                await getProfileData();
                                await storage.write(
                                    key: "loggedOut", value: false.toString());
                                storageLoggedOut =
                                    await storage.read(key: "loggedOut") ==
                                        "true";
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.retailDashboard,
                                    (route) => false,
                                    arguments: RetailDashboardArgumentModel(
                                      imgUrl: "",
                                      name: result["customerName"],
                                      isFirst: storageIsFirstLogin == true
                                          ? false
                                          : true,
                                    ).toMap(),
                                  );
                                }
                              }
                            } else {
                              await storage.write(
                                  key: "cif", value: result["cif"]);
                              storageCif = await storage.read(key: "cif");
                              log("storageCif -> $storageCif");
                              if (storageCif == null || storageCif == "null") {
                                if (context.mounted) {
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
                                                arguments:
                                                    OnboardingArgumentModel(
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
                                }
                              } else {
                                await getProfileData();
                                await storage.write(
                                    key: "loggedOut", value: false.toString());
                                storageLoggedOut =
                                    await storage.read(key: "loggedOut") ==
                                        "true";
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.businessDashboard,
                                    (route) => false,
                                    arguments: RetailDashboardArgumentModel(
                                      imgUrl: storageProfilePhotoBase64 ?? "",
                                      name: profileName ?? "",
                                      isFirst: storageIsFirstLogin == true
                                          ? false
                                          : true,
                                    ).toMap(),
                                  );
                                }
                              }
                            }
                          }
                        }
                      }

                      await storage.write(
                          key: "password",
                          value:
                              EncryptDecrypt.encrypt(_passwordController.text)
                          // _passwordController.text,
                          );
                      storagePassword = await storage.read(key: "password");
                      log("storagePassword -> $storagePassword");
                      await storage.write(
                          key: "newInstall", value: true.toString());
                      storageIsNotNewInstall =
                          (await storage.read(key: "newInstall")) == "true";
                      customerName = result["customerName"];
                      await storage.write(
                          key: "customerName", value: customerName);
                      storageCustomerName =
                          await storage.read(key: "customerName");

                      await storage.write(
                          key: "isFirstLogin", value: true.toString());
                      storageIsFirstLogin =
                          (await storage.read(key: "isFirstLogin")) == "true";
                    } else {
                      log("Verif Reason Code -> ${result["reasonCode"]}");
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
                  }
                  // if (context.mounted) {
                  //   Navigator.pop(context);
                  // }
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
                if (!isLoading) {
                  final ShowButtonBloc showButtonBloc =
                      context.read<ShowButtonBloc>();
                  isLoading = true;
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));
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

                    var decryptedStoredPasswordRes =
                        await MapDecrypt.mapDecrypt({
                      "decryptedString": storagePassword,
                      "uniqueId": DateTime.now().millisecondsSinceEpoch,
                      "hash": EncryptDecrypt.encrypt(
                          "${DateTime.now().millisecondsSinceEpoch}"),
                    });
                    decryptedStoredPassword =
                        decryptedStoredPasswordRes["message"];
                    log("decryptedStoredPassword -> $decryptedStoredPassword");

                    isLoading = false;
                    showButtonBloc.add(ShowButtonEvent(show: isLoading));
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
            auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
          ),
        );
      },
    );
  }

  void promptKycExpired() async {
    await storage.write(
        key: "password", value: EncryptDecrypt.encrypt(_passwordController.text)
        // _passwordController.text,
        );
    storagePassword = await storage.read(key: "password");
    if (context.mounted) {
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
                    Navigator.pushNamed(
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
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    return Ternary(
      condition: !isPwdBlank,
      truthy: const SizeBox(),
      falsy: Row(
        children: [
          Icon(
            Icons.error_rounded,
            color: AppColors.red100,
            size: (13 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "Password is required",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red100,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton(BuildContext context, MatchPasswordState state) {
    return GradientButton(
      onTap: () async {
        final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
        if (_passwordController.text.isEmpty) {
          isPwdBlank = true;
        } else {
          isPwdBlank = false;
          onSubmit(_passwordController.text);
        }
        showButtonBloc.add(ShowButtonEvent(show: isPwdBlank));
      },
      text: labels[205]["labelText"],
      auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
    );
  }

  void onForgotEmailPwd() async {
    if (!isLoading) {
      isLoading = true;
      var result =
          await MapSendEmailOtp.mapSendEmailOtp({"emailID": storageEmail});
      log("Send Email OTP Response -> $result");

      if (result["success"]) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.otp,
            arguments: OTPArgumentModel(
              emailOrPhone: storageEmail ?? "",
              isReferral: false,
              isEmail: true,
              isBusiness: false,
              isInitial: false,
              isLogin: false,
              isEmailIdUpdate: false,
              isMobileUpdate: false,
              isReKyc: false,
              userTypeId: storageUserTypeId ?? 1,
              companyId: storageCompanyId ?? 0,
            ).toMap(),
          );
        }
      } else {
        if (context.mounted) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry",
                message: result["message"] ??
                    "There was an error in sending OTP, please try again later",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: "Okay",
                ),
              );
            },
          );
        }
      }
      isLoading = false;
    }
  }

  Future<void> persistOnboardingState(int state) async {
    if (state == 1) {
      await storage.write(key: "stepsCompleted", value: 2.toString());
      storageStepsCompleted =
          int.parse(await storage.read(key: "stepsCompleted") ?? "2");
      log("storageStepsCompleted -> $storageStepsCompleted");
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          loginPasswordArgument.userTypeId == 1
              ? Routes.retailOnboardingStatus
              : Routes.businessOnboardingStatus,
          arguments: OnboardingStatusArgumentModel(
            stepsCompleted: 1,
            isFatca: false,
            isPassport: false,
            isRetail: loginPasswordArgument.userTypeId == 1 ? true : false,
          ).toMap(),
        );
      }
    } else if (state == 2 || state == 3 || state == 7) {
      await storage.write(key: "stepsCompleted", value: 4.toString());
      storageStepsCompleted =
          int.parse(await storage.read(key: "stepsCompleted") ?? "4");
      log("storageStepsCompleted -> $storageStepsCompleted");
      if (context.mounted) {
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
      }
    } else if (state == 6) {
      await storage.write(key: "stepsCompleted", value: 9.toString());
      storageStepsCompleted =
          int.parse(await storage.read(key: "stepsCompleted") ?? "9");
      log("storageStepsCompleted -> $storageStepsCompleted");
      if (context.mounted) {
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
      }
    } else if (state == 9) {
      await storage.write(key: "stepsCompleted", value: 11.toString());
      storageStepsCompleted =
          int.parse(await storage.read(key: "stepsCompleted") ?? "11");
      log("storageStepsCompleted -> $storageStepsCompleted");
      if (context.mounted) {
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
    } else if (state == 4) {
      if (loginPasswordArgument.userTypeId == 1) {
        await storage.write(key: "stepsCompleted", value: 10.toString());
        storageStepsCompleted =
            int.parse(await storage.read(key: "stepsCompleted") ?? "10");
        log("storageStepsCompleted -> $storageStepsCompleted");
        if (context.mounted) {
          Navigator.pushNamed(
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
      } else {
        await storage.write(key: "stepsCompleted", value: 0.toString());
        storageStepsCompleted =
            int.parse(await storage.read(key: "stepsCompleted") ?? "0");
        log("storageStepsCompleted -> $storageStepsCompleted");
        if (context.mounted) {
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
    }
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

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
