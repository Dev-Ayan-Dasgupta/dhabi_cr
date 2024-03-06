// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/otp/pinput/error_bloc.dart';
import 'package:dialup_mobile_app/bloc/otp/pinput/error_event.dart';
import 'package:dialup_mobile_app/bloc/otp/pinput/error_state.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_bloc.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_event.dart';
import 'package:dialup_mobile_app/bloc/otp/timer/timer_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/map_customer_details.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/data/repositories/corporateAccounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _pinController = TextEditingController();

  late OTPArgumentModel otpArgumentModel;

  int pinputErrorCount = 0;

  late final String obscuredEmail;
  late final String obscuredPhone;

  late int seconds;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    blocInitialization();
    startTimer(otpArgumentModel.isEmail ? 300 : 90);
  }

  void argumentInitialization() {
    otpArgumentModel =
        OTPArgumentModel.fromMap(widget.argument as dynamic ?? {});
    if (otpArgumentModel.isEmail) {
      obscuredEmail = ObscureHelper.obscureEmail(otpArgumentModel.emailOrPhone);
    } else {
      obscuredPhone = ObscureHelper.obscurePhone(otpArgumentModel.emailOrPhone);
    }
    log("userTypeId in OTP -> ${otpArgumentModel.userTypeId}");
  }

  void blocInitialization() {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    pinputErrorBloc.add(
        PinputErrorEvent(isError: false, isComplete: false, errorCount: 0));
  }

  void startTimer(int count) {
    seconds = count;
    final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds > 0) {
          seconds--;
          otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
        } else {
          timer.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        promptUser();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(onTap: promptUser),
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
                child: Center(
                  child: Column(
                    children: [
                      const SizeBox(height: 30),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildIcon,
                      ),
                      const SizeBox(height: 20),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildTitle,
                      ),
                      const SizeBox(height: 15),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildDescription,
                      ),
                      const SizeBox(height: 25),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildPinput,
                      ),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildTimer,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIcon(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      if (otpArgumentModel.isEmail) {
        return SvgPicture.asset(
          ImageConstants.otp,
          width: (78 / Dimensions.designWidth).w,
          height: (70 / Dimensions.designHeight).h,
        );
      } else {
        return SvgPicture.asset(
          ImageConstants.phoneAndroid,
          width: (50 / Dimensions.designWidth).w,
          height: (83 / Dimensions.designHeight).h,
        );
      }
    } else {
      return SvgPicture.asset(
        ImageConstants.warningBlue,
        width: (100 / Dimensions.designWidth).w,
        height: (100 / Dimensions.designWidth).w,
      );
    }
  }

  Widget buildTitle(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      return Text(
        labels[32]["labelText"],
        style: TextStyles.primaryMedium.copyWith(
          color: AppColors.dark80,
          fontSize: (24 / Dimensions.designWidth).w,
        ),
      );
    } else {
      return Text(
        "Oops!",
        style: TextStyles.primaryMedium.copyWith(
          color: AppColors.dark80,
          fontSize: (24 / Dimensions.designWidth).w,
        ),
      );
    }
  }

  Widget buildDescription(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      if (otpArgumentModel.isEmail) {
        return Text(
          "${labels[41]["labelText"]} $obscuredEmail",
          style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80,
            fontSize: (16 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          "${labels[33]["labelText"]} $obscuredPhone",
          style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80,
            fontSize: (16 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      return SizedBox(
        width: 80.w,
        child: Text(
          "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.",
          style: TextStyles.primaryMedium.copyWith(
            color: const Color(0xFF343434),
            fontSize: (18 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  void promptUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[250]["labelText"],
          message:
              "Going to the previous screen will make you repeat this step.",
          auxWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
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

  Widget buildPinput(BuildContext context, PinputErrorState state) {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomPinput(
      pinController: _pinController,
      pinColor: (!state.isError)
          ? (state.isComplete)
              ? const Color(0XFFBCE5DD)
              : AppColors.blackEE
          : (state.errorCount >= 3)
              ? const Color(0XFFC0D6FF)
              : const Color(0XFFFFC3C0),
      onChanged: (p0) async {
        if (_pinController.text.length == 6) {
          if (otpArgumentModel.isEmail) {
            if (otpArgumentModel.isReferral) {
              log("tempToken Req -> ${{
                "emailId": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
              }}");
              var tempTokenResult = await MapValidateEmailOtpForPassword
                  .mapValidateEmailOtpForPassword({
                "emailId": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
              });
              if (tempTokenResult["success"]) {
                pinputErrorBloc.add(
                  PinputErrorEvent(
                    isError: false,
                    isComplete: true,
                    errorCount: pinputErrorCount,
                  ),
                );
                log("tempTokenResult -> $tempTokenResult");
                // tokenCP = tempTokenResult["token"];
                // log("tokenCP -> $tokenCP");
                await storage.write(
                    key: "token", value: tempTokenResult["token"]);
                if (context.mounted) {
                  // Navigator.pushReplacementNamed(
                  //   context,
                  //   Routes.verificationInitializing,
                  //   arguments: VerificationInitializationArgumentModel(
                  //     isReKyc: true,
                  //   ).toMap(),
                  // );
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.createPassword,
                    arguments: CreateAccountArgumentModel(
                      email: otpArgumentModel.emailOrPhone,
                      isRetail: storageUserTypeId == 1 ? true : false,
                      userTypeId: storageUserTypeId ?? 1,
                      companyId: storageCompanyId ?? 0,
                    ).toMap(),
                  );
                }
              } else {
                pinputErrorCount++;
                seconds = 0;
                showButtonBloc.add(const ShowButtonEvent(show: true));
                pinputErrorBloc.add(
                  PinputErrorEvent(
                    isError: true,
                    isComplete: true,
                    errorCount: pinputErrorCount,
                  ),
                );
              }
            } else {
              if (otpArgumentModel.isReKyc) {
                var tempTokenResult = await MapValidateEmailOtpForPassword
                    .mapValidateEmailOtpForPassword({
                  "emailId": storageEmail,
                  "otp": _pinController.text,
                });

                if (tempTokenResult["success"]) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                  log("tempTokenResult -> $tempTokenResult");
                  // tokenCP = tempTokenResult["token"];
                  // log("tokenCP -> $tokenCP");
                  await storage.write(
                      key: "token", value: tempTokenResult["token"]);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.verificationInitializing,
                      arguments: VerificationInitializationArgumentModel(
                        isReKyc: true,
                      ).toMap(),
                    );
                  }
                } else {
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              } else {
                if (otpArgumentModel.isEmailIdUpdate) {
                  if (otpArgumentModel.isBusiness == false) {
                    log("Update Email API request -> ${{
                      "otp": _pinController.text,
                      "emailID": updatedEmail,
                    }}");
                    var updateREmailResult =
                        await MapUpdateRetailEmailId.mapUpdateRetailEmailId(
                      {
                        "otp": _pinController.text,
                        "emailID": updatedEmail,
                      },
                      token ?? "",
                    );
                    log("Update Email API response -> $updateREmailResult");

                    if (updateREmailResult["success"]) {
                      pinputErrorBloc.add(
                        PinputErrorEvent(
                          isError: false,
                          isComplete: true,
                          errorCount: pinputErrorCount,
                        ),
                      );

                      var result = await MapLogin.mapLogin({
                        "emailId": updatedEmail,
                        "userTypeId": storageUserTypeId,
                        "userId": 1,
                        "companyId": storageCompanyId,
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

                      isUserLoggedIn = true;
                      if (context.mounted) {
                        if (result["invitationCode"] != null &&
                            result["invitationCode"].isNotEmpty) {
                          await PopulateInviteDetails.populateInviteDetails(
                              context, result["invitationCode"]);
                        }
                      }

                      await storage.write(key: "token", value: result["token"]);
                      notificationCount = result["notificationCount"];
                      log("notificationCount -> $notificationCount");

                      passwordChangesToday = result["passwordChangesToday"];
                      emailChangesToday = result["emailChangesToday"];
                      mobileChangesToday = result["mobileChangesToday"];

                      await storage.write(
                          key: "emailAddress", value: updatedEmail);
                      storageEmail = await storage.read(key: "emailAddress");
                      log("storageEmail -> $storageEmail");
                      profileEmailId = storageEmail;
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.checkCircleOutlined,
                              title: "Email ID Updated",
                              message: messages[54]["messageText"],
                              actionWidget: GradientButton(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.profile,
                                    arguments: ProfileArgumentModel(
                                      isRetail: true,
                                    ).toMap(),
                                  );
                                },
                                text: labels[346]["labelText"],
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.warning,
                              title: "Unable to Update",
                              message: messages[51]["messageText"],
                              actionWidget: GradientButton(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                text: labels[346]["labelText"],
                              ),
                            );
                          },
                        );
                      }
                    }
                  } else {
                    // TODO: Call API to update corporate email
                    log("Update Corporate Email API request -> ${{
                      "otp": _pinController.text,
                      "emailID": updatedEmail,
                    }}");
                    var updateREmailResult =
                        await MapChangeEmailAddress.mapChangeEmailAddress(
                      {
                        "otp": _pinController.text,
                        "emailID": updatedEmail,
                      },
                      token ?? "",
                    );
                    log("Update Corporate Email API response -> $updateREmailResult");

                    if (updateREmailResult["success"]) {
                      pinputErrorBloc.add(
                        PinputErrorEvent(
                          isError: false,
                          isComplete: true,
                          errorCount: pinputErrorCount,
                        ),
                      );
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.checkCircleOutlined,
                              title: "Update Request Placed",
                              message:
                                  "${messages[121]["messageText"]}: ${updateREmailResult["reference"]}",
                              actionWidget: GradientButton(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                text: labels[346]["labelText"],
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.warning,
                              title: "Unable to Update",
                              message: messages[51]["messageText"],
                              actionWidget: GradientButton(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                text: labels[346]["labelText"],
                              ),
                            );
                          },
                        );
                      }
                    }
                  }
                } else {
                  if (otpArgumentModel.isLogin) {
                    log("temp password api req -> ${{
                      "emailId": otpArgumentModel.emailOrPhone,
                      "otp": _pinController.text,
                    }}");
                    var result = await MapValidateEmailOtpForPassword
                        .mapValidateEmailOtpForPassword({
                      "emailId": otpArgumentModel.emailOrPhone,
                      "otp": _pinController.text,
                    });
                    log("result -> $result");
                    // tokenCP = result["token"];
                    // log("tokenCP -> $tokenCP");
                    await storage.write(key: "token", value: result["token"]);
                    if (result["success"]) {
                      pinputErrorBloc.add(
                        PinputErrorEvent(
                          isError: false,
                          isComplete: true,
                          errorCount: pinputErrorCount,
                        ),
                      );
                      // TODO: Call API for getCustomer details and navigate to SelectAccountScreen
                      var getCustomerDetailsResponse =
                          await MapCustomerDetails.mapCustomerDetails(
                              tokenCP ?? "");
                      log("Get Customer Details API response -> $getCustomerDetailsResponse");

                      List cifDetails =
                          getCustomerDetailsResponse["cifDetails"];

                      if (cifDetails.isEmpty) {
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.onboarding,
                            (route) => false,
                            arguments: OnboardingArgumentModel(
                              isInitial: true,
                            ).toMap(),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.selectAccount,
                            arguments: SelectAccountArgumentModel(
                              emailId: otpArgumentModel.emailOrPhone,
                              cifDetails: cifDetails,
                              isPwChange: false,
                              isLogin: true,
                              isSwitching: false,
                              isIncompleteOnboarding: false,
                            ).toMap(),
                          );
                        }
                      }
                    } else {
                      pinputErrorCount++;
                      seconds = 0;
                      showButtonBloc.add(const ShowButtonEvent(show: true));
                      pinputErrorBloc.add(
                        PinputErrorEvent(
                          isError: true,
                          isComplete: true,
                          errorCount: pinputErrorCount,
                        ),
                      );
                    }
                  } else {
                    if (otpArgumentModel.isInitial) {
                      var result = await MapVerifyEmailOtp.mapVerifyEmailOtp(
                        {
                          "emailId": otpArgumentModel.emailOrPhone,
                          "otp": _pinController.text,
                        },
                      );
                      log("Verify Email OTP Response -> $result");

                      if (result["success"] == true) {
                        pinputErrorBloc.add(
                          PinputErrorEvent(
                            isError: false,
                            isComplete: true,
                            errorCount: pinputErrorCount,
                          ),
                        );

                        await Future.delayed(const Duration(milliseconds: 250));
                        if (context.mounted) {
                          if (otpArgumentModel.isEmail) {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.selectAccountType,
                              arguments: CreateAccountArgumentModel(
                                email: otpArgumentModel.emailOrPhone,
                                isRetail: true,
                                userTypeId: 1,
                                companyId: 0,
                              ).toMap(),
                            );
                          } else {
                            if (otpArgumentModel.isBusiness) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath:
                                        ImageConstants.checkCircleOutlined,
                                    title: "Thank You!",
                                    message:
                                        "Your request is submitted with reference number $storagReferenceNumber. We will contact you on next steps.",
                                    actionWidget: BlocBuilder<ShowButtonBloc,
                                        ShowButtonState>(
                                      builder: (context, state) {
                                        return GradientButton(
                                          onTap: () async {
                                            isLoading = true;
                                            final ShowButtonBloc
                                                showButtonBloc =
                                                context.read<ShowButtonBloc>();
                                            showButtonBloc.add(ShowButtonEvent(
                                                show: isLoading));
                                            var getCustomerDetailsResponse =
                                                await MapCustomerDetails
                                                    .mapCustomerDetails(
                                                        token ?? "");
                                            log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                            List cifDetails =
                                                getCustomerDetailsResponse[
                                                    "cifDetails"];
                                            if (context.mounted) {
                                              if (cifDetails.length == 1) {
                                                cif =
                                                    getCustomerDetailsResponse[
                                                        "cifDetails"][0]["cif"];
                                                await storage.write(
                                                    key: "cif", value: cif);
                                                storageCif = await storage.read(
                                                    key: "cif");
                                                isCompany =
                                                    getCustomerDetailsResponse[
                                                            "cifDetails"][0]
                                                        ["isCompany"];

                                                isCompanyRegistered =
                                                    getCustomerDetailsResponse[
                                                            "cifDetails"][0]
                                                        ["isCompanyRegistered"];

                                                if (cif == null ||
                                                    cif == "null") {
                                                  if (isCompany) {
                                                    if (isCompanyRegistered) {
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        Navigator
                                                            .pushReplacementNamed(
                                                          context,
                                                          Routes.loginPassword,
                                                          arguments:
                                                              LoginPasswordArgumentModel(
                                                            emailId:
                                                                storageEmail ??
                                                                    "",
                                                            userId:
                                                                storageUserId ??
                                                                    0,
                                                            userTypeId:
                                                                storageUserTypeId ??
                                                                    2,
                                                            companyId:
                                                                storageCompanyId ??
                                                                    0,
                                                            isSwitching: false,
                                                          ).toMap(),
                                                        );
                                                      }
                                                    } else {
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        Navigator
                                                            .pushReplacementNamed(
                                                          context,
                                                          Routes.onboarding,
                                                          arguments:
                                                              OnboardingArgumentModel(
                                                            isInitial: true,
                                                          ).toMap(),
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                      Navigator
                                                          .pushReplacementNamed(
                                                        context,
                                                        Routes.loginPassword,
                                                        arguments:
                                                            LoginPasswordArgumentModel(
                                                          emailId:
                                                              storageEmail ??
                                                                  "",
                                                          userId:
                                                              storageUserId ??
                                                                  0,
                                                          userTypeId:
                                                              storageUserTypeId ??
                                                                  2,
                                                          companyId:
                                                              storageCompanyId ??
                                                                  0,
                                                          isSwitching: false,
                                                        ).toMap(),
                                                      );
                                                    }
                                                  }
                                                }
                                              } else if (cifDetails.isEmpty) {
                                                if (context.mounted) {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    Routes.onboarding,
                                                    (route) => false,
                                                    arguments:
                                                        OnboardingArgumentModel(
                                                      isInitial: true,
                                                    ).toMap(),
                                                  );
                                                }
                                              } else {
                                                // Navigator.pushReplacementNamed(
                                                //   context,
                                                //   Routes.selectAccount,
                                                //   arguments:
                                                //       SelectAccountArgumentModel(
                                                //     emailId: otpArgumentModel
                                                //         .emailOrPhone,
                                                //     cifDetails: cifDetails,
                                                //     isPwChange: false,
                                                //     isLogin: false,
                                                //     isSwitching: false,
                                                //     isIncompleteOnboarding: false,
                                                //   ).toMap(),
                                                // );
                                                if (context.mounted) {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    Routes.onboarding,
                                                    (route) => false,
                                                    arguments:
                                                        OnboardingArgumentModel(
                                                      isInitial: true,
                                                    ).toMap(),
                                                  );
                                                }
                                              }
                                            }
                                            isLoading = false;
                                            showButtonBloc.add(ShowButtonEvent(
                                                show: isLoading));

                                            await storage.write(
                                                key: "stepsCompleted",
                                                value: 0.toString());
                                            storageStepsCompleted = int.parse(
                                                await storage.read(
                                                        key:
                                                            "stepsCompleted") ??
                                                    "0");
                                            await storage.write(
                                                key: "hasFirstLoggedIn",
                                                value: true.toString());
                                            storageHasFirstLoggedIn =
                                                (await storage.read(
                                                        key:
                                                            "hasFirstLoggedIn")) ==
                                                    "true";
                                          },
                                          text: labels[346]["labelText"],
                                          auxWidget: isLoading
                                              ? const LoaderRow()
                                              : const SizeBox(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.retailOnboardingStatus,
                                arguments: OnboardingStatusArgumentModel(
                                  stepsCompleted: 4,
                                  isFatca: false,
                                  isPassport: false,
                                  isRetail: !otpArgumentModel.isBusiness,
                                ).toMap(),
                              );
                            }
                          }
                        }
                      } else {
                        pinputErrorCount++;
                        seconds = 0;
                        showButtonBloc.add(const ShowButtonEvent(show: true));
                        pinputErrorBloc.add(PinputErrorEvent(
                            isError: true,
                            isComplete: true,
                            errorCount: pinputErrorCount));
                      }
                    } else {
                      var result = await MapValidateEmailOtpForPassword
                          .mapValidateEmailOtpForPassword(
                        {
                          "emailId": otpArgumentModel.emailOrPhone,
                          "otp": _pinController.text,
                        },
                      );
                      log("Validate Email OTP For Password Response -> $result");
                      // tokenCP = result["token"];
                      // log("tokenCP -> $tokenCP");
                      await storage.write(key: "token", value: result["token"]);
                      if (result["success"] == true) {
                        pinputErrorBloc.add(
                          PinputErrorEvent(
                            isError: false,
                            isComplete: true,
                            errorCount: pinputErrorCount,
                          ),
                        );

                        // await Future.delayed(const Duration(milliseconds: 250));
                        if (context.mounted) {
                          if (otpArgumentModel.isEmail) {
                            // Navigator.pop(context);
                            // TODO: Check for new device

                            // TODO: if not new device, go to select entity screen
                            var getCustomerDetailsResponse =
                                await MapCustomerDetails.mapCustomerDetails(
                                    tokenCP ?? "");
                            log("Get Customer Details API response -> $getCustomerDetailsResponse");
                            List cifDetails =
                                getCustomerDetailsResponse["cifDetails"];

                            int retailOnboardingState =
                                getCustomerDetailsResponse[
                                    "retailOnboardingState"];
                            // int corporateOnboardingState =
                            //     getCustomerDetailsResponse[
                            //         "corporateOnboardingState"];

                            if (cifDetails.length == 1) {
                              if (context.mounted) {
                                cif = getCustomerDetailsResponse["cifDetails"]
                                    [0]["cif"];
                                await storage.write(key: "cif", value: cif);
                                storageCif = await storage.read(key: "cif");
                                isCompany =
                                    getCustomerDetailsResponse["cifDetails"][0]
                                        ["isCompany"];

                                isCompanyRegistered =
                                    getCustomerDetailsResponse["cifDetails"][0]
                                        ["isCompanyRegistered"];

                                log("cif -> $cif");
                                log("cif RTT -> ${cif.runtimeType}");
                                log("isCompany -> $isCompany");
                                log("isCompanyRegistered -> $isCompanyRegistered");

                                var isDeviceValidApiResult =
                                    await MapIsDeviceValid.mapIsDeviceValid({
                                  "userId": cifDetails[0]["userID"],
                                  "deviceId": storageDeviceId,
                                }, tokenCP ?? "");
                                log("isDeviceValidApiResult -> $isDeviceValidApiResult");

                                if (isDeviceValidApiResult["success"]) {
                                  if (context.mounted) {
                                    if (cif != null || cif != "null") {
                                      if (isCompany) {
                                        if (isCompanyRegistered) {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            Routes.setPassword,
                                            arguments: SetPasswordArgumentModel(
                                              fromTempPassword: false,
                                              userTypeId:
                                                  otpArgumentModel.userTypeId,
                                              companyId:
                                                  otpArgumentModel.companyId,
                                            ).toMap(),
                                          );
                                        }
                                      } else {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          Routes.setPassword,
                                          arguments: SetPasswordArgumentModel(
                                            fromTempPassword: false,
                                            userTypeId:
                                                otpArgumentModel.userTypeId,
                                            companyId:
                                                otpArgumentModel.companyId,
                                          ).toMap(),
                                        );
                                      }
                                    }
                                    if (cif == null) {
                                      log("cif is null");
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return CustomDialog(
                                            svgAssetPath:
                                                ImageConstants.warning,
                                            title:
                                                "Application approval pending",
                                            message:
                                                "You already have a registration pending. Please contact Dhabi support.",
                                            auxWidget: GradientButton(
                                              onTap: () async {
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    Routes.registration,
                                                    arguments:
                                                        RegistrationArgumentModel(
                                                      isInitial: true,
                                                      isUpdateCorpEmail: false,
                                                    ).toMap(),
                                                  );
                                                }
                                              },
                                              text: "Go Home",
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
                                  }
                                } else {
                                  var rmorResult =
                                      await MapRegisteredMobileOtpRequest
                                          .mapRegisteredMobileOtpRequest({
                                    "emailId": storageEmail,
                                    "cif": cif,
                                  }, tokenCP ?? "");
                                  log("rmorResult -> $rmorResult");
                                  if (rmorResult["success"]) {
                                    if (context.mounted) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Routes.otp,
                                        arguments: OTPArgumentModel(
                                          isReferral: false,
                                          emailOrPhone:
                                              rmorResult["mobileNumber"],
                                          isEmail: false,
                                          isBusiness: isCompany,
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
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomDialog(
                                            svgAssetPath:
                                                ImageConstants.warning,
                                            title: "Mobile Not Registered",
                                            message:
                                                "You do not have an account registered with this mobile number. Please register an account.",
                                            actionWidget: GradientButton(
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.onboarding,
                                                  arguments:
                                                      OnboardingArgumentModel(
                                                              isInitial: true)
                                                          .toMap(),
                                                );
                                              },
                                              text: "Register",
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }
                                  // if (context.mounted) {
                                  //   showDialog(
                                  //     context: context,
                                  //     barrierDismissible: false,
                                  //     builder: (context) {
                                  //       return CustomDialog(
                                  //         svgAssetPath: ImageConstants.warning,
                                  //         title: "Device Invalid",
                                  //         message:
                                  //             "You are trying to login from an unregistered device.",
                                  //         actionWidget: GradientButton(
                                  //           onTap: () {
                                  //             Navigator.pop(context);
                                  //             Navigator.pushReplacementNamed(
                                  //               context,
                                  //               Routes.loginUserId,
                                  //             );
                                  //           },
                                  //           text: labels[347]["labelText"],
                                  //         ),
                                  //       );
                                  //     },
                                  //   );
                                  // }
                                }
                              }
                            } else {
                              if (cifDetails.isEmpty) {
                                if (retailOnboardingState == 0) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return CustomDialog(
                                          svgAssetPath: ImageConstants.warning,
                                          title: "Invalid Email",
                                          message:
                                              "There is no Dhabi Account associated with this email address.",
                                          actionWidget: GradientButton(
                                            onTap: () async {
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.registration,
                                                  arguments:
                                                      RegistrationArgumentModel(
                                                    isInitial: true,
                                                    isUpdateCorpEmail: false,
                                                  ).toMap(),
                                                );
                                              }
                                            },
                                            text: "Go Home",
                                          ),
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.setPassword,
                                      arguments: SetPasswordArgumentModel(
                                        fromTempPassword: false,
                                        userTypeId: otpArgumentModel.userTypeId,
                                        companyId: otpArgumentModel.companyId,
                                      ).toMap(),
                                    );
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.selectAccount,
                                    arguments: SelectAccountArgumentModel(
                                      emailId: otpArgumentModel.emailOrPhone,
                                      cifDetails: cifDetails,
                                      isPwChange: true,
                                      isLogin: false,
                                      isSwitching: false,
                                      isIncompleteOnboarding: false,
                                    ).toMap(),
                                  );
                                }
                              }
                            }
                          } else {
                            if (otpArgumentModel.isBusiness) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath:
                                        ImageConstants.checkCircleOutlined,
                                    title: "Thank You!",
                                    message:
                                        "Your request is submitted with reference number $storagReferenceNumber. We will contact you on next steps.",
                                    actionWidget: BlocBuilder<ShowButtonBloc,
                                        ShowButtonState>(
                                      builder: (context, state) {
                                        return GradientButton(
                                          onTap: () async {
                                            isLoading = true;
                                            final ShowButtonBloc
                                                showButtonBloc =
                                                context.read<ShowButtonBloc>();
                                            showButtonBloc.add(ShowButtonEvent(
                                                show: isLoading));
                                            var getCustomerDetailsResponse =
                                                await MapCustomerDetails
                                                    .mapCustomerDetails(
                                                        token ?? "");
                                            log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                            List cifDetails =
                                                getCustomerDetailsResponse[
                                                    "cifDetails"];
                                            if (context.mounted) {
                                              if (cifDetails.length == 1) {
                                                cif =
                                                    getCustomerDetailsResponse[
                                                        "cifDetails"][0]["cif"];
                                                await storage.write(
                                                    key: "cif", value: cif);
                                                storageCif = await storage.read(
                                                    key: "cif");
                                                isCompany =
                                                    getCustomerDetailsResponse[
                                                            "cifDetails"][0]
                                                        ["isCompany"];

                                                isCompanyRegistered =
                                                    getCustomerDetailsResponse[
                                                            "cifDetails"][0]
                                                        ["isCompanyRegistered"];

                                                if (cif == null ||
                                                    cif == "null") {
                                                  if (isCompany) {
                                                    if (isCompanyRegistered) {
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        Navigator
                                                            .pushReplacementNamed(
                                                          context,
                                                          Routes.loginPassword,
                                                          arguments:
                                                              LoginPasswordArgumentModel(
                                                            emailId:
                                                                storageEmail ??
                                                                    "",
                                                            userId:
                                                                storageUserId ??
                                                                    0,
                                                            userTypeId:
                                                                storageUserTypeId ??
                                                                    2,
                                                            companyId:
                                                                storageCompanyId ??
                                                                    0,
                                                            isSwitching: false,
                                                          ).toMap(),
                                                        );
                                                      }
                                                    } else {
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        Navigator
                                                            .pushReplacementNamed(
                                                          context,
                                                          Routes.onboarding,
                                                          arguments:
                                                              OnboardingArgumentModel(
                                                            isInitial: true,
                                                          ).toMap(),
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                      Navigator
                                                          .pushReplacementNamed(
                                                        context,
                                                        Routes.loginPassword,
                                                        arguments:
                                                            LoginPasswordArgumentModel(
                                                          emailId:
                                                              storageEmail ??
                                                                  "",
                                                          userId:
                                                              storageUserId ??
                                                                  0,
                                                          userTypeId:
                                                              storageUserTypeId ??
                                                                  2,
                                                          companyId:
                                                              storageCompanyId ??
                                                                  0,
                                                          isSwitching: false,
                                                        ).toMap(),
                                                      );
                                                    }
                                                  }
                                                }
                                              } else if (cifDetails.isEmpty) {
                                                if (context.mounted) {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    Routes.onboarding,
                                                    (route) => false,
                                                    arguments:
                                                        OnboardingArgumentModel(
                                                      isInitial: true,
                                                    ).toMap(),
                                                  );
                                                }
                                              } else {
                                                // Navigator.pushReplacementNamed(
                                                //   context,
                                                //   Routes.selectAccount,
                                                //   arguments:
                                                //       SelectAccountArgumentModel(
                                                //     emailId: otpArgumentModel
                                                //         .emailOrPhone,
                                                //     cifDetails: cifDetails,
                                                //     isPwChange: false,
                                                //     isLogin: false,
                                                //     isSwitching: false,
                                                //     isIncompleteOnboarding: false,
                                                //   ).toMap(),
                                                // );
                                                if (context.mounted) {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    Routes.onboarding,
                                                    (route) => false,
                                                    arguments:
                                                        OnboardingArgumentModel(
                                                      isInitial: true,
                                                    ).toMap(),
                                                  );
                                                }
                                              }
                                            }
                                            isLoading = false;
                                            showButtonBloc.add(ShowButtonEvent(
                                                show: isLoading));

                                            await storage.write(
                                                key: "stepsCompleted",
                                                value: 0.toString());
                                            storageStepsCompleted = int.parse(
                                                await storage.read(
                                                        key:
                                                            "stepsCompleted") ??
                                                    "0");
                                            await storage.write(
                                                key: "hasFirstLoggedIn",
                                                value: true.toString());
                                            storageHasFirstLoggedIn =
                                                (await storage.read(
                                                        key:
                                                            "hasFirstLoggedIn")) ==
                                                    "true";
                                          },
                                          text: labels[346]["labelText"],
                                          auxWidget: isLoading
                                              ? const LoaderRow()
                                              : const SizeBox(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.retailOnboardingStatus,
                                arguments: OnboardingStatusArgumentModel(
                                  stepsCompleted: 4,
                                  isFatca: false,
                                  isPassport: false,
                                  isRetail: !otpArgumentModel.isBusiness,
                                ).toMap(),
                              );
                            }
                          }
                        }
                      } else {
                        pinputErrorCount++;
                        seconds = 0;
                        showButtonBloc.add(const ShowButtonEvent(show: true));
                        pinputErrorBloc.add(
                          PinputErrorEvent(
                            isError: true,
                            isComplete: true,
                            errorCount: pinputErrorCount,
                          ),
                        );
                      }
                    }
                  }
                }
              }
            }
          } else {
            log("Phone no. -> ${otpArgumentModel.emailOrPhone}");
            if (otpArgumentModel.isReKyc) {
              var result = await MapVerifyMobileOtp.mapVerifyMobileOtp(
                {
                  "mobileNo": otpArgumentModel.emailOrPhone,
                  "otp": _pinController.text,
                  "isRevalidate": true,
                },
                token ?? "",
              );
              log("Verify Mobile OTP Response -> $result");
              if (result["success"]) {
                pinputErrorBloc.add(
                  PinputErrorEvent(
                    isError: false,
                    isComplete: true,
                    errorCount: pinputErrorCount,
                  ),
                );

                log("Login after Rekyc request -> ${{
                  "emailId": storageEmail,
                  "userTypeId": 1,
                  "userId": storageUserId,
                  "companyId": storageCompanyId,
                  "password": storagePassword,
                  // EncryptDecrypt.encrypt(storagePassword ?? ""),
                  "deviceId": storageDeviceId,
                  "registerDevice": true,
                  "deviceName": deviceName,
                  "deviceType": deviceType,
                  "appVersion": appVersion
                }}");
                var loginApiResult = await MapLogin.mapLogin({
                  "emailId": storageEmail,
                  "userTypeId": 1,
                  "userId": storageUserId,
                  "companyId": storageCompanyId,
                  "password": storagePassword,
                  // EncryptDecrypt.encrypt(storagePassword ?? ""),
                  "deviceId": storageDeviceId,
                  "registerDevice": true,
                  "deviceName": deviceName,
                  "deviceType": deviceType,
                  "appVersion": appVersion
                });
                log("loginApiResult -> $loginApiResult");

                if (loginApiResult["success"]) {
                  isUserLoggedIn = true;
                  if (context.mounted) {
                    if (loginApiResult["invitationCode"] != null &&
                        loginApiResult["invitationCode"].isNotEmpty) {
                      await PopulateInviteDetails.populateInviteDetails(
                          context, result["invitationCode"]);
                    }
                  }
                  notificationCount = result["notificationCount"];
                  log("notificationCount -> $notificationCount");
                  passwordChangesToday = loginApiResult["passwordChangesToday"];
                  emailChangesToday = loginApiResult["emailChangesToday"];
                  mobileChangesToday = loginApiResult["mobileChangesToday"];
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
                        name: loginApiResult["customerName"],
                        isFirst: true,
                      ).toMap(),
                    );
                  }
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Error in Login",
                          message: loginApiResult["message"] ?? "Error message",
                          actionWidget: GradientButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            text: labels[346]["labelText"],
                          ),
                        );
                      },
                    );
                  }
                }
              } else {
                pinputErrorCount++;
                seconds = 0;
                if (context.mounted) {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        svgAssetPath: ImageConstants.warning,
                        title: "Sorry",
                        message: result["message"] ??
                            "There was an issue validating mobile OTP, please try again later",
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

                showButtonBloc.add(const ShowButtonEvent(show: true));
                pinputErrorBloc.add(
                  PinputErrorEvent(
                    isError: true,
                    isComplete: true,
                    errorCount: pinputErrorCount,
                  ),
                );
              }
            } else {
              if (otpArgumentModel.isMobileUpdate) {
                if (otpArgumentModel.isBusiness == false) {
                  var mobileUpdateResult = await MapUpdateRetailMobileNumber
                      .mapUpdateRetailMobileNumber(
                    {
                      "otp": _pinController.text,
                      "mobileNumber": otpArgumentModel.emailOrPhone,
                    },
                    token ?? "",
                  );
                  log("Update Mobile API response -> $mobileUpdateResult");
                  if (mobileUpdateResult["success"]) {
                    await storage.write(
                      key: "mobileNumber",
                      value: otpArgumentModel.emailOrPhone,
                    );
                    storageMobileNumber =
                        await storage.read(key: "mobileNumber");
                    profileMobileNumber = storageMobileNumber;
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.checkCircleOutlined,
                            title: "Mobile Number Updated",
                            message: messages[52]["messageText"],
                            actionWidget: GradientButton(
                              onTap: () {
                                mobileChangesToday++;
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.profile,
                                  arguments: ProfileArgumentModel(
                                    isRetail: true,
                                  ).toMap(),
                                );
                              },
                              text: labels[346]["labelText"],
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "Unable to Update",
                            message: messages[51]["messageText"],
                            actionWidget: GradientButton(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              text: labels[346]["labelText"],
                            ),
                          );
                        },
                      );
                    }
                  }
                } else {
                  // TODO: Call API to update corporate mobile
                  log("corpMobileUpdate Request -> ${{
                    "otp": _pinController.text,
                    "mobileNumber": otpArgumentModel.emailOrPhone,
                  }}");
                  var corpMobileUpdateResult =
                      await MapChangeMobileNumber.mapChangeMobileNumber(
                    {
                      "otp": _pinController.text,
                      "mobileNumber": otpArgumentModel.emailOrPhone,
                    },
                    token ?? "",
                  );
                  log("corpMobileUpdateResult -> $corpMobileUpdateResult");

                  if (corpMobileUpdateResult["success"]) {
                    if (corpMobileUpdateResult["isDirectlyCreated"]) {
                      await storage.write(
                        key: "mobileNumber",
                        value: otpArgumentModel.emailOrPhone,
                      );
                      storageMobileNumber =
                          await storage.read(key: "mobileNumber");
                      profileMobileNumber = storageMobileNumber;
                    }

                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.checkCircleOutlined,
                            title: corpMobileUpdateResult["isDirectlyCreated"]
                                ? "Mobile Number Updated"
                                : "Update Request Placed",
                            message: corpMobileUpdateResult["isDirectlyCreated"]
                                ? messages[52]["messageText"]
                                : "${messages[121]["messageText"]}: ${corpMobileUpdateResult["reference"]}",
                            actionWidget: GradientButton(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.profile,
                                  arguments: ProfileArgumentModel(
                                    isRetail: false,
                                  ).toMap(),
                                );
                              },
                              text: labels[346]["labelText"],
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "Unable to Update",
                            message: messages[51]["messageText"],
                            actionWidget: GradientButton(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              text: labels[346]["labelText"],
                            ),
                          );
                        },
                      );
                    }
                  }
                }
              } else {
                log("Verify Otp Request -> ${{
                  "mobileNo": otpArgumentModel.emailOrPhone,
                  "otp": _pinController.text,
                }}");
                var result = await MapVerifyMobileOtp.mapVerifyMobileOtp(
                  {
                    "mobileNo": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                  },
                  otpArgumentModel.isInitial ? token ?? "" : tokenCP ?? "",
                );
                log("Verify Mobile OTP Response -> $result");

                if (result["success"] == true) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );

                  await Future.delayed(const Duration(milliseconds: 250));

                  if (otpArgumentModel.isInitial) {
                    if (context.mounted) {
                      if (otpArgumentModel.isEmail) {
                        Navigator.pop(context);
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
                      } else {
                        if (otpArgumentModel.isBusiness) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return CustomDialog(
                                svgAssetPath:
                                    ImageConstants.checkCircleOutlined,
                                title: "Thank You!",
                                message:
                                    "Your request is submitted with reference number $storagReferenceNumber. We will contact you on next steps.",
                                actionWidget: BlocBuilder<ShowButtonBloc,
                                    ShowButtonState>(
                                  builder: (context, state) {
                                    return GradientButton(
                                      onTap: () async {
                                        isLoading = true;
                                        final ShowButtonBloc showButtonBloc =
                                            context.read<ShowButtonBloc>();
                                        showButtonBloc.add(
                                            ShowButtonEvent(show: isLoading));
                                        var getCustomerDetailsResponse =
                                            await MapCustomerDetails
                                                .mapCustomerDetails(
                                                    token ?? "");
                                        log("Get Customer Details API response -> $getCustomerDetailsResponse");
                                        List cifDetails =
                                            getCustomerDetailsResponse[
                                                "cifDetails"];
                                        if (context.mounted) {
                                          if (cifDetails.length == 1) {
                                            cif = getCustomerDetailsResponse[
                                                "cifDetails"][0]["cif"];
                                            await storage.write(
                                                key: "cif", value: cif);
                                            storageCif =
                                                await storage.read(key: "cif");
                                            isCompany =
                                                getCustomerDetailsResponse[
                                                        "cifDetails"][0]
                                                    ["isCompany"];

                                            isCompanyRegistered =
                                                getCustomerDetailsResponse[
                                                        "cifDetails"][0]
                                                    ["isCompanyRegistered"];

                                            if (cif == null || cif == "null") {
                                              if (isCompany) {
                                                if (isCompanyRegistered) {
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      context,
                                                      Routes.loginPassword,
                                                      arguments:
                                                          LoginPasswordArgumentModel(
                                                        emailId:
                                                            storageEmail ?? "",
                                                        userId:
                                                            storageUserId ?? 0,
                                                        userTypeId:
                                                            storageUserTypeId ??
                                                                2,
                                                        companyId:
                                                            storageCompanyId ??
                                                                0,
                                                        isSwitching: false,
                                                      ).toMap(),
                                                    );
                                                  }
                                                } else {
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      context,
                                                      Routes.onboarding,
                                                      arguments:
                                                          OnboardingArgumentModel(
                                                        isInitial: true,
                                                      ).toMap(),
                                                    );
                                                  }
                                                }
                                              } else {
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    Routes.loginPassword,
                                                    arguments:
                                                        LoginPasswordArgumentModel(
                                                      emailId:
                                                          storageEmail ?? "",
                                                      userId:
                                                          storageUserId ?? 0,
                                                      userTypeId:
                                                          storageUserTypeId ??
                                                              2,
                                                      companyId:
                                                          storageCompanyId ?? 0,
                                                      isSwitching: false,
                                                    ).toMap(),
                                                  );
                                                }
                                              }
                                            }
                                          } else if (cifDetails.isEmpty) {
                                            if (context.mounted) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.onboarding,
                                                (route) => false,
                                                arguments:
                                                    OnboardingArgumentModel(
                                                  isInitial: true,
                                                ).toMap(),
                                              );
                                            }
                                          } else {
                                            // Navigator.pushReplacementNamed(
                                            //   context,
                                            //   Routes.selectAccount,
                                            //   arguments:
                                            //       SelectAccountArgumentModel(
                                            //     emailId: otpArgumentModel
                                            //         .emailOrPhone,
                                            //     cifDetails: cifDetails,
                                            //     isPwChange: false,
                                            //     isLogin: false,
                                            //     isSwitching: false,
                                            //     isIncompleteOnboarding: false,
                                            //   ).toMap(),
                                            // );
                                            if (context.mounted) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.onboarding,
                                                (route) => false,
                                                arguments:
                                                    OnboardingArgumentModel(
                                                  isInitial: true,
                                                ).toMap(),
                                              );
                                            }
                                          }
                                        }
                                        isLoading = false;
                                        showButtonBloc.add(
                                            ShowButtonEvent(show: isLoading));

                                        await storage.write(
                                            key: "stepsCompleted",
                                            value: 0.toString());
                                        storageStepsCompleted = int.parse(
                                            await storage.read(
                                                    key: "stepsCompleted") ??
                                                "0");
                                        await storage.write(
                                            key: "hasFirstLoggedIn",
                                            value: true.toString());
                                        storageHasFirstLoggedIn =
                                            (await storage.read(
                                                    key: "hasFirstLoggedIn")) ==
                                                "true";
                                      },
                                      text: labels[346]["labelText"],
                                      auxWidget: isLoading
                                          ? const LoaderRow()
                                          : const SizeBox(),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.retailOnboardingStatus,
                            arguments: OnboardingStatusArgumentModel(
                              stepsCompleted: 4,
                              isFatca: true,
                              isPassport: false,
                              isRetail: !otpArgumentModel.isBusiness,
                            ).toMap(),
                          );
                          await storage.write(
                              key: "stepsCompleted", value: 10.toString());
                          storageStepsCompleted = int.parse(
                              await storage.read(key: "stepsCompleted") ?? "0");
                        }
                      }
                    }
                  } else {
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.setPassword,
                        arguments: SetPasswordArgumentModel(
                          fromTempPassword: false,
                          userTypeId: otpArgumentModel.userTypeId,
                          companyId: otpArgumentModel.companyId,
                        ).toMap(),
                      );
                    }
                  }
                } else {
                  pinputErrorCount++;
                  seconds = 0;
                  if (context.mounted) {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Sorry",
                          message: result["message"] ??
                              "There was an issue validating mobile OTP, please try again later",
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

                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              }
            }
          }
        } else {
          pinputErrorBloc.add(PinputErrorEvent(
              isError: false, isComplete: false, errorCount: pinputErrorCount));
        }
      },
      enabled: pinputErrorCount < 1 ? true : false,
      // state.errorCount < 1 ? true : false,
    );
  }

  Widget buildTimer(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      return Column(
        children: [
          const SizeBox(height: 30),
          BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return Ternary(
                condition: pinputErrorCount == 0,
                truthy: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${labels[34]["labelText"]} ",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                    BlocBuilder<OTPTimerBloc, OTPTimerState>(
                      builder: (context, state) {
                        if (seconds % 60 < 10) {
                          return Text(
                            "${seconds ~/ 60}:0${seconds % 60}",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red100,
                              fontSize: (14 / Dimensions.designWidth).w,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        } else {
                          return Text(
                            "${seconds ~/ 60}:${seconds % 60}",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red100,
                              fontSize: (14 / Dimensions.designWidth).w,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                falsy: Text(
                  messages[7]["messageText"],
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.red100,
                    fontSize: (14 / Dimensions.designWidth).w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          const SizeBox(height: 25),
          BlocBuilder<OTPTimerBloc, OTPTimerState>(
            builder: (context, state) {
              return InkWell(
                onTap: resendOTP,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Text(
                  labels[35]["labelText"],
                  style: TextStyles.primaryBold.copyWith(
                    color: seconds == 0 || pinputErrorCount > 0
                        ? AppColors.primary
                        : AppColors.dark50,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizeBox(height: 20),
          Text(
            labels[36]["labelText"],
            style: TextStyles.primaryMedium.copyWith(
              color: const Color(0xFF636363),
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    }
  }

  void resendOTP() async {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    if (seconds == 0) {
      final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
      if (seconds == 0 || pinputErrorCount > 0) {
        if (otpArgumentModel.isEmail) {
          seconds = 90;
        } else {
          seconds = 90;
        }
        startTimer(seconds);
        final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
        otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
      }
      if (otpArgumentModel.isEmail) {
        var result = await MapSendEmailOtp.mapSendEmailOtp(
            {"emailID": otpArgumentModel.emailOrPhone});
        if (!(result["success"])) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Retry Limit Reached",
                  message: result["message"],
                  actionWidget: GradientButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.onboarding,
                        arguments: OnboardingArgumentModel(
                          isInitial: true,
                        ).toMap(),
                      );
                    },
                    text: "Go Home",
                  ),
                );
              },
            );
            // isLoading = false;
            // showButtonBloc.add(ShowButtonEvent(show: isLoading));
          }
        }
      } else {
        var result = await MapSendMobileOtp.mapSendMobileOtp(
          {"mobileNo": otpArgumentModel.emailOrPhone},
          token ?? "",
        );
        if (!(result["success"])) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Retry Limit Reached",
                  message: result["message"],
                  actionWidget: GradientButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.onboarding,
                        arguments: OnboardingArgumentModel(
                          isInitial: true,
                        ).toMap(),
                      );
                    },
                    text: "Go Home",
                  ),
                );
              },
            );
            // isLoading = false;
            // showButtonBloc.add(ShowButtonEvent(show: isLoading));
          }
        }
      }
      pinputErrorCount = 0;
      _pinController.clear();
      pinputErrorBloc.add(
        PinputErrorEvent(
          isError: false,
          isComplete: false,
          errorCount: pinputErrorCount,
        ),
      );

      showButtonBloc.add(const ShowButtonEvent(show: true));
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
    _pinController.dispose();
    super.dispose();
  }
}
