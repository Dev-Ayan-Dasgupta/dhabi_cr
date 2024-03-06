import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginUserIdScreen extends StatefulWidget {
  const LoginUserIdScreen({Key? key}) : super(key: key);

  @override
  State<LoginUserIdScreen> createState() => _LoginUserIdScreenState();
}

class _LoginUserIdScreenState extends State<LoginUserIdScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool isEmailValid = false;
  // bool emailExists = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "Enter User ID",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                      Text(
                        "(Email address)",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark50,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return CustomTextField(
                        controller: _emailController,
                        borderColor: (_emailController.text.contains('@') &&
                                _emailController.text.contains('.'))
                            ? isEmailValid ||
                                    _emailController.text.isEmpty ||
                                    !_emailController.text.contains('@') ||
                                    (_emailController.text.contains('@') &&
                                        (RegExp("[A-Za-z0-9.-]").hasMatch(
                                            _emailController.text
                                                .split('@')
                                                .last)) &&
                                        !(_emailController.text
                                            .split('@')
                                            .last
                                            .contains(RegExp(
                                                r'[!@#$%^&*(),_?":{}|<>\/\\]'))))
                                ? const Color(0xFFEEEEEE)
                                : AppColors.red100
                            : const Color(0xFFEEEEEE),
                        suffixIcon: Ternary(
                          condition: !isEmailValid,
                          truthy: Padding(
                            padding: EdgeInsets.only(
                                left: (10 / Dimensions.designWidth).w),
                            child: InkWell(
                              onTap: () {
                                _emailController.clear();
                              },
                              child: SvgPicture.asset(
                                ImageConstants.deleteText,
                                width: (17.5 / Dimensions.designWidth).w,
                                height: (17.5 / Dimensions.designWidth).w,
                              ),
                            ),
                          ),
                          falsy: Padding(
                            padding: EdgeInsets.only(
                                left: (10 / Dimensions.designWidth).w),
                            child: SvgPicture.asset(
                              ImageConstants.checkCircle,
                              width: (20 / Dimensions.designWidth).w,
                              height: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        onChanged: emailValidation,
                      );
                    },
                  ),
                  const SizeBox(height: 7),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildErrorMessage,
                  ),
                  const SizeBox(height: 15),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildProceedButton,
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

  void emailValidation(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (EmailValidator.validate(p0)) {
      isEmailValid = true;
      showButtonBloc.add(ShowButtonEvent(show: isEmailValid));
    } else {
      isEmailValid = false;
      showButtonBloc.add(ShowButtonEvent(show: isEmailValid));
    }
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    if ((_emailController.text.contains('@') &&
        _emailController.text.contains('.'))) {
      if (isEmailValid ||
          _emailController.text.isEmpty ||
          !_emailController.text.contains('@') ||
          (_emailController.text.contains('@') &&
              (RegExp("[A-Za-z0-9.-]")
                  .hasMatch(_emailController.text.split('@').last)) &&
              !(_emailController.text
                  .split('@')
                  .last
                  .contains(RegExp(r'[!@#$%^&*(),_?":{}|<>\/\\]'))))) {
        return const SizeBox();
      } else {
        return Row(
          children: [
            SvgPicture.asset(
              ImageConstants.errorSolid,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
            const SizeBox(width: 5),
            Text(
              "Invalid email address",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color(0xFFC94540),
                fontSize: (12 / Dimensions.designWidth).w,
              ),
            ),
          ],
        );
      }
    } else {
      return const SizeBox();
    }
  }

  Widget buildProceedButton(BuildContext context, ShowButtonState state) {
    if (isEmailValid) {
      return GradientButton(
        onTap: () async {
          if (!isLoading) {
            isLoading = true;
            final ShowButtonBloc showButtonBloc =
                context.read<ShowButtonBloc>();
            showButtonBloc.add(ShowButtonEvent(show: isLoading));

            await storage.write(
                key: "emailAddress", value: _emailController.text);
            storageEmail = await storage.read(key: "emailAddress");
            log("storageEmail -> $storageEmail");

            // check if single cif exists
            log("singleCif Req -> ${{"emailId": _emailController.text}}");
            var singleCifResult =
                await MapCustomerSingleCif.mapCustomerSingleCif(
                    {"emailId": _emailController.text});
            log("singleCifResult -> $singleCifResult");

            if (singleCifResult["success"]) {
              await storage.write(
                  key: "userTypeId",
                  value: singleCifResult["userType"].toString());
              storageUserTypeId =
                  int.parse(await storage.read(key: "userTypeId") ?? "0");
              log("storageUserTypeId -> $storageUserTypeId");

              await storage.write(
                  key: 'hasSingleCif',
                  value: singleCifResult["hasSingleCIF"].toString());
              storageHasSingleCif =
                  (await storage.read(key: "hasSingleCif")) == "true";
              log("storageHasSingleCif -> $storageHasSingleCif");

              await storage.write(
                  key: "companyId", value: singleCifResult["cid"].toString());
              storageCompanyId =
                  int.parse(await storage.read(key: "companyId") ?? "0");
              log("storageCompanyId -> $storageCompanyId");
              // if only one cif
              if (singleCifResult["hasSingleCIF"]) {
                if (singleCifResult["hasValidCIF"]) {
                  // if (singleCifResult["userType"] == 2) {
                  //   var getCustomerDetailsResponse =
                  //       await MapCustomerDetails.mapCustomerDetails(tokenCP ?? "");
                  //   log("Get Customer Details API response -> $getCustomerDetailsResponse");
                  //   List cifDetails = getCustomerDetailsResponse["cifDetails"];
                  //   if (cifDetails[0]["isCompanyRegistered"]) {
                  //     if (context.mounted) {
                  //       Navigator.pushNamed(
                  //         context,
                  //         Routes.loginPassword,
                  //         arguments: LoginPasswordArgumentModel(
                  //           emailId: _emailController.text,
                  //           userId: 0,
                  //           userTypeId: singleCifResult["userType"],
                  //           companyId: singleCifResult["cid"],
                  //         ).toMap(),
                  //       );
                  //     }
                  //   } else {
                  //     if (context.mounted) {
                  //       showDialog(
                  //         context: context,
                  //         barrierDismissible: false,
                  //         builder: (context) {
                  //           return CustomDialog(
                  //             svgAssetPath: ImageConstants.warning,
                  //             title: "Application approval pending",
                  //             message:
                  //                 "You already have a registration pending. Please contact Dhabi support.",
                  //             auxWidget: GradientButton(
                  //               onTap: () async {
                  //                 if (context.mounted) {
                  //                   Navigator.pop(context);
                  //                   Navigator.pushReplacementNamed(
                  //                     context,
                  //                     Routes.onboarding,
                  //                     arguments: OnboardingArgumentModel(
                  //                       isInitial: true,
                  //                     ).toMap(),
                  //                   );
                  //                 }
                  //               },
                  //               text: labels[347]["labelText"],
                  //             ),
                  //             actionWidget: SolidButton(
                  //               onTap: () {
                  //                 Navigator.pop(context);
                  //               },
                  //               text: labels[166]["labelText"],
                  //               color: AppColors.primaryBright17,
                  //               fontColor: AppColors.primary,
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     }
                  //   }
                  // } else {
                  //   if (context.mounted) {
                  //     Navigator.pushNamed(
                  //       context,
                  //       Routes.loginPassword,
                  //       arguments: LoginPasswordArgumentModel(
                  //         emailId: _emailController.text,
                  //         userId: 0,
                  //         userTypeId: singleCifResult["userType"],
                  //         companyId: singleCifResult["cid"],
                  //       ).toMap(),
                  //     );
                  //   }
                  // }
                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      Routes.loginPassword,
                      arguments: LoginPasswordArgumentModel(
                        emailId: _emailController.text,
                        userId: 0,
                        userTypeId: singleCifResult["userType"],
                        companyId: singleCifResult["cid"],
                        isSwitching: false,
                      ).toMap(),
                    );
                  }
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
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
                  }
                }
              } else {
                if (singleCifResult["hasValidCIF"]) {
                  var sendEmailOtpResult =
                      await MapSendEmailOtp.mapSendEmailOtp(
                          {"emailID": _emailController.text});
                  log("sendEmailOtpResult -> $sendEmailOtpResult");
                  if (sendEmailOtpResult["success"]) {
                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        Routes.otp,
                        arguments: OTPArgumentModel(
                          emailOrPhone: _emailController.text,
                          isReferral: false,
                          isEmail: true,
                          isBusiness: false,
                          isInitial: false,
                          isLogin: true,
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
                            svgAssetPath: ImageConstants.warning,
                            title: "Max Retries Reached",
                            message: sendEmailOtpResult["message"],
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
                  // promptWrongCredentials();
                  if ((singleCifResult["retailOnboardingState"] != 0 &&
                          singleCifResult["corporateOnboardingState"] == 0) ||
                      (singleCifResult["retailOnboardingState"] == 0 &&
                          singleCifResult["corporateOnboardingState"] != 0) ||
                      (singleCifResult["retailOnboardingState"] != 0 &&
                          singleCifResult["corporateOnboardingState"] == 4) ||
                      (singleCifResult["retailOnboardingState"] == 5 &&
                          singleCifResult["corporateOnboardingState"] != 0)) {
                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        Routes.loginPassword,
                        arguments: LoginPasswordArgumentModel(
                          emailId: storageEmail ?? "",
                          userId: storageUserId ?? 0,
                          userTypeId:
                              ((singleCifResult["retailOnboardingState"] != 0 &&
                                          singleCifResult[
                                                  "corporateOnboardingState"] ==
                                              0) ||
                                      (singleCifResult[
                                                  "retailOnboardingState"] !=
                                              0 &&
                                          singleCifResult[
                                                  "corporateOnboardingState"] ==
                                              4))
                                  ? 1
                                  : 2,
                          companyId: storageCompanyId ?? 0,
                          isSwitching: false,
                        ).toMap(),
                      );
                    }
                  } else if (singleCifResult["retailOnboardingState"] != 5 &&
                      singleCifResult["corporateOnboardingState"] != 4) {
                    if (context.mounted) {
                      Navigator.pushNamed(context, Routes.entityForOnboarding);
                    }
                  } else {
                    var sendEmailOtpResult =
                        await MapSendEmailOtp.mapSendEmailOtp(
                            {"emailID": _emailController.text});
                    log("sendEmailOtpResult -> $sendEmailOtpResult");
                    if (sendEmailOtpResult["success"]) {
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          Routes.otp,
                          arguments: OTPArgumentModel(
                            emailOrPhone: _emailController.text,
                            isReferral: false,
                            isEmail: true,
                            isBusiness: false,
                            isInitial: false,
                            isLogin: true,
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
                              svgAssetPath: ImageConstants.warning,
                              title: "Max Retries Reached",
                              message: sendEmailOtpResult["message"],
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
                  }
                }
              }
            } else {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      svgAssetPath: ImageConstants.warning,
                      title: "Error",
                      message: "here was an eror logging in",
                      actionWidget: GradientButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: labels[293]["labelText"],
                      ),
                    );
                  },
                );
              }
            }

            isLoading = false;
            showButtonBloc.add(ShowButtonEvent(show: isLoading));
          }
        },
        text: labels[31]["labelText"],
        auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
      );
    } else {
      return SolidButton(onTap: () {}, text: labels[31]["labelText"]);
    }
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
