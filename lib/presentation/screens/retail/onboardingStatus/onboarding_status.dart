// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class RetailOnboardingStatusScreen extends StatefulWidget {
  const RetailOnboardingStatusScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RetailOnboardingStatusScreen> createState() =>
      _RetailOnboardingStatusScreenState();
}

class _RetailOnboardingStatusScreenState
    extends State<RetailOnboardingStatusScreen> {
  late OnboardingStatusArgumentModel onboardingStatusArgument;

  bool isChecked = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    onboardingStatusArgument =
        OnboardingStatusArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(ImageConstants.appBarLogo),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                  const SizeBox(height: 20),
                  Text(
                    labels[223]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  OnboardingStatusRow(
                    isCompleted: onboardingStatusArgument.stepsCompleted >= 1,
                    isCurrent: onboardingStatusArgument.stepsCompleted == 0,
                    iconPath: ImageConstants.envelope,
                    iconWidth: 10,
                    iconHeight: 14,
                    text: labels[224]["labelText"],
                    dividerHeight: 24,
                  ),
                  OnboardingStatusRow(
                    isCompleted: onboardingStatusArgument.stepsCompleted >= 2,
                    isCurrent: onboardingStatusArgument.stepsCompleted == 1,
                    iconPath: ImageConstants.idCard,
                    iconWidth: 10,
                    iconHeight: 14,
                    text: labels[225]["labelText"],
                    dividerHeight: 24,
                  ),
                  OnboardingStatusRow(
                    isCompleted: onboardingStatusArgument.stepsCompleted >= 3,
                    isCurrent: onboardingStatusArgument.stepsCompleted == 2,
                    iconPath: ImageConstants.article,
                    iconWidth: 14,
                    iconHeight: 14,
                    text: labels[226]["labelText"],
                    dividerHeight: 24,
                  ),
                  OnboardingStatusRow(
                    isCompleted: onboardingStatusArgument.stepsCompleted >= 4,
                    isCurrent: onboardingStatusArgument.stepsCompleted == 3,
                    iconPath: ImageConstants.mobile,
                    iconWidth: 14,
                    iconHeight: 18,
                    text: labels[227]["labelText"],
                    dividerHeight: 0,
                  ),
                  const SizeBox(height: 30),
                  Ternary(
                    condition: !onboardingStatusArgument.isFatca &&
                        !onboardingStatusArgument.isPassport &&
                        onboardingStatusArgument.stepsCompleted == 4,
                    truthy: const SizeBox(),
                    // Text(
                    //   "You will get a free AED Vault powered by FH.",
                    //   style: TextStyles.primaryMedium.copyWith(
                    //     color: AppColors.black63,
                    //     fontSize: (16 / Dimensions.designWidth).w,
                    //   ),
                    // ),
                    falsy: const SizeBox(),
                  ),
                ],
              ),
            ),
            Ternary(
              condition: onboardingStatusArgument.stepsCompleted == 4,
              truthy: Column(
                children: [
                  // Row(
                  //   children: [
                  //     BlocBuilder<CheckBoxBloc, CheckBoxState>(
                  //       builder: buildTC,
                  //     ),
                  //     const SizeBox(width: 5),
                  //     Row(
                  //       children: [
                  //         Text(
                  //           'I agree to the ',
                  //           style: TextStyles.primary.copyWith(
                  //             color: const Color.fromRGBO(0, 0, 0, 0.5),
                  //             fontSize: (16 / Dimensions.designWidth).w,
                  //           ),
                  //         ),
                  //         InkWell(
                  //           onTap: () {
                  //             Navigator.pushNamed(
                  //                 context, Routes.termsAndConditions);
                  //           },
                  //           child: Text(
                  //             'Terms & Conditions',
                  //             style: TextStyles.primary.copyWith(
                  //               color: AppColors.primary,
                  //               fontSize: (16 / Dimensions.designWidth).w,
                  //               decoration: TextDecoration.underline,
                  //             ),
                  //           ),
                  //         ),
                  //         Text(
                  //           ' and ',
                  //           style: TextStyles.primary.copyWith(
                  //             color: const Color.fromRGBO(0, 0, 0, 0.5),
                  //             fontSize: (16 / Dimensions.designWidth).w,
                  //           ),
                  //         ),
                  //         InkWell(
                  //           onTap: () {
                  //             Navigator.pushNamed(
                  //                 context, Routes.privacyStatement);
                  //           },
                  //           child: Text(
                  //             'Privacy Policy',
                  //             style: TextStyles.primary.copyWith(
                  //               color: AppColors.primary,
                  //               fontSize: (16 / Dimensions.designWidth).w,
                  //               decoration: TextDecoration.underline,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // const SizeBox(height: 15),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      // if (isChecked) {
                      return Column(
                        children: [
                          GradientButton(
                            onTap: () {
                              callLoginApi();
                              Navigator.pushNamed(
                                context,
                                Routes.acceptTermsAndConditions,
                                arguments: CreateAccountArgumentModel(
                                  email: storageEmail ?? "",
                                  isRetail: true,
                                  userTypeId: 1,
                                  companyId: 0,
                                ).toMap(),
                              );
                            },
                            text: labels[288]["labelText"],
                          ),
                          SizeBox(
                            height: PaddingConstants.bottomPadding +
                                MediaQuery.of(context).padding.bottom,
                          ),
                        ],
                      );
                      // } else {
                      //   return Column(
                      //     children: [
                      //       SolidButton(
                      //           onTap: () {}, text: labels[288]["labelText"]),
                      //       SizeBox(
                      //         height: PaddingConstants.bottomPadding +
                      //             MediaQuery.of(context).padding.bottom,
                      //       ),
                      //     ],
                      //   );
                      // }
                    },
                  ),
                ],
              ),
              falsy: Column(
                children: [
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return GradientButton(
                        onTap: () {
                          switch (onboardingStatusArgument.stepsCompleted) {
                            case 0:
                              Navigator.pushNamed(
                                context,
                                Routes.createPassword,
                                arguments: CreateAccountArgumentModel(
                                  email: storageEmail ?? "",
                                  isRetail:
                                      storageUserTypeId == 1 ? true : false,
                                  userTypeId: storageUserTypeId ?? 1,
                                  companyId: storageCompanyId ?? 0,
                                ).toMap(),
                              );
                              break;
                            case 1:
                              callLoginApi();
                              Navigator.pushNamed(
                                context,
                                Routes.verificationInitializing,
                                arguments:
                                    VerificationInitializationArgumentModel(
                                  isReKyc: false,
                                ).toMap(),
                              );
                              break;
                            case 2:
                              if (storageStepsCompleted == 4) {
                                callLoginApi();
                                Navigator.pushNamed(
                                    context, Routes.applicationAddress);
                              } else if (storageStepsCompleted == 5) {
                                callLoginApi();
                                Navigator.pushNamed(
                                    context, Routes.applicationIncome);
                              } else if (storageStepsCompleted == 6) {
                                callLoginApi();
                                Navigator.pushNamed(
                                    context, Routes.applicationTaxFATCA);
                              } else if (storageStepsCompleted == 7) {
                                callLoginApi();
                                Navigator.pushNamed(
                                  context,
                                  Routes.applicationTaxCRS,
                                  arguments: TaxCrsArgumentModel(
                                    isUSFATCA: storageIsUSFATCA ?? true,
                                    ustin: storageUsTin ?? "",
                                  ).toMap(),
                                );
                              } else if (storageStepsCompleted == 8) {
                                callLoginApi();
                                Navigator.pushNamed(
                                  context,
                                  Routes.applicationAccount,
                                  arguments: ApplicationAccountArgumentModel(
                                    isInitial: true,
                                    isRetail: true,
                                    savingsAccountsCreated: 0,
                                    currentAccountsCreated: 0,
                                  ).toMap(),
                                );
                              }
                              break;
                            case 3:
                              Navigator.pushNamed(
                                context,
                                Routes.verifyMobile,
                                arguments: VerifyMobileArgumentModel(
                                  isBusiness: false,
                                  isUpdate: false,
                                  isReKyc: false,
                                ).toMap(),
                              );
                              break;
                            default:
                          }
                        },
                        text: labels[31]["labelText"],
                        auxWidget:
                            isLoading ? const LoaderRow() : const SizeBox(),
                      );
                    },
                  ),
                  SizeBox(
                    height: PaddingConstants.bottomPadding +
                        MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTC(BuildContext context, CheckBoxState state) {
    if (isChecked) {
      return InkWell(
        onTap: () {
          isChecked = false;
          triggerCheckBoxEvent(isChecked);
          triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.checkedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          isChecked = true;
          triggerCheckBoxEvent(isChecked);
          triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.uncheckedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    }
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void triggerAllTrueEvent() {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }

  void callLoginApi() async {
    isLoading = true;
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isLoading));
    var result = await MapLogin.mapLogin({
      "emailId": storageEmail,
      "userTypeId": storageUserTypeId,
      "userId": storageUserId,
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
    customerName = result["customerName"];
    await storage.write(key: "customerName", value: customerName);
    storageCustomerName = await storage.read(key: "customerName");
    await storage.write(key: "loggedOut", value: false.toString());
    storageLoggedOut = await storage.read(key: "loggedOut") == "true";
    isLoading = false;
    showButtonBloc.add(ShowButtonEvent(show: isLoading));
  }
}
