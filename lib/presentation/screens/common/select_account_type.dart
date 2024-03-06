// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_bloc.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_event.dart';
import 'package:dialup_mobile_app/bloc/buttonFocus/button_focus_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SelectAccountTypeScreen extends StatefulWidget {
  const SelectAccountTypeScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SelectAccountTypeScreen> createState() =>
      _SelectAccountTypeScreenState();
}

class _SelectAccountTypeScreenState extends State<SelectAccountTypeScreen> {
  bool isPersonalFocussed = false;
  bool isBusinessFocussed = false;
  int toggles = 0;

  bool isValidating = false;
  // bool isInvalid = false;

  late CreateAccountArgumentModel createAccountArgumentModel;

  @override
  void initState() {
    super.initState();
    createAccountArgumentModel =
        CreateAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
          leading: AppBarLeading(
            onTap: promptUser,
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[215]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 22),
                    Text(
                      labels[216]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                      builder: buildPersonalButton,
                    ),
                    const SizeBox(height: 30),
                    BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                      builder: buildBusinessButton,
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: buildSubmitButton,
                    ),
                    const SizeBox(height: 15),
                    InkWell(
                      onTap: loginMethod,
                      child: RichText(
                        text: TextSpan(
                          text: '${labels[213]["labelText"]} ',
                          style: TextStyles.primary.copyWith(
                            color: AppColors.primary,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: labels[214]["labelText"],
                              style: TextStyles.primaryBold.copyWith(
                                color: AppColors.primary,
                                fontSize: (16 / Dimensions.designWidth).w,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
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
      ),
    );
  }

  Widget buildPersonalButton(BuildContext context, ButtonFocussedState state) {
    return SolidButton(
      onTap: () {
        onButtonTap(true, false);
      },
      color: Colors.white,
      borderColor: isPersonalFocussed
          ? const Color.fromRGBO(0, 184, 148, 0.21)
          : Colors.transparent,
      boxShadow: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(
            (3 / Dimensions.designWidth).w,
            (4 / Dimensions.designHeight).h,
          ),
          blurRadius: (3 / Dimensions.designWidth).w,
        ),
      ],
      fontColor: AppColors.primary,
      text: labels[217]["labelText"],
    );
  }

  Widget buildBusinessButton(BuildContext context, ButtonFocussedState state) {
    return SolidButton(
      onTap: () {
        onButtonTap(false, true);
      },
      color: Colors.white,
      borderColor: isBusinessFocussed
          ? const Color.fromRGBO(0, 184, 148, 0.21)
          : Colors.transparent,
      boxShadow: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(
            (3 / Dimensions.designWidth).w,
            (4 / Dimensions.designHeight).h,
          ),
          blurRadius: (3 / Dimensions.designWidth).w,
        ),
      ],
      fontColor: AppColors.primary,
      text: labels[218]["labelText"],
    );
  }

  void onButtonTap(bool isPersonal, bool isBusiness) {
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isPersonalFocussed = isPersonal;
    isBusinessFocussed = isBusiness;
    toggles++;
    buttonFocussedBloc.add(
      ButtonFocussedEvent(
        isFocussed: isPersonal ? isPersonalFocussed : isBusinessFocussed,
        toggles: toggles,
      ),
    );
    showButtonBloc.add(
      ShowButtonEvent(
        show: isPersonal ? isPersonalFocussed : isBusinessFocussed,
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isPersonalFocussed || isBusinessFocussed) {
      final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
      return GradientButton(
        onTap: () async {
          if (!isValidating) {
            log("emailAddress -> $emailAddress");
            isValidating = true;
            showButtonBloc.add(ShowButtonEvent(show: isValidating));
            Map<String, dynamic> result;
            if (isPersonalFocussed && !isBusinessFocussed) {
              await storage.write(key: "userTypeId", value: 1.toString());
              storageUserTypeId =
                  int.parse(await storage.read(key: "userTypeId") ?? "");
              result = await MapValidateEmail.mapValidateEmail({
                "emailId": createAccountArgumentModel.email,
                "userTypeId": 1
              });
              log("Validate Email (Retail) response -> $result");
            } else {
              await storage.write(key: "userTypeId", value: 2.toString());
              storageUserTypeId =
                  int.parse(await storage.read(key: "userTypeId") ?? "");
              result = await MapValidateEmail.mapValidateEmail({
                "emailId": createAccountArgumentModel.email,
                "userTypeId": 2
              });
              log("Validate Email (Business) response -> $result");
            }
            if (result["success"]) {
              await storage.write(key: "newInstall", value: true.toString());
              storageIsNotNewInstall =
                  (await storage.read(key: "newInstall")) == "true";
              await storage.write(key: "stepsCompleted", value: 1.toString());
              storageStepsCompleted =
                  int.parse(await storage.read(key: "stepsCompleted") ?? "0");
              if (context.mounted) {
                Navigator.pushNamed(
                  context,
                  Routes.createPassword,
                  arguments: CreateAccountArgumentModel(
                    email: createAccountArgumentModel.email,
                    isRetail: isPersonalFocussed ? true : false,
                    userTypeId: isPersonalFocussed ? 1 : 2,
                    companyId: isPersonalFocussed ? 0 : 1,
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
                      title: storageUserTypeId == 1
                          ? "Sorry"
                          // messages[71]["messageText"]
                          : "Application approval pending",
                      message: storageUserTypeId == 1
                          ? messages[70]["messageText"]
                          : result["message"] == "" || result["message"] == null
                              ? "You already have a registration pending. Please contact Dhabi support."
                              : result["message"],
                      auxWidget: GradientButton(
                        onTap: () async {
                          await storage.write(
                              key: "stepsCompleted", value: 0.toString());
                          storageStepsCompleted = int.parse(
                              await storage.read(key: "stepsCompleted") ?? "0");
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              storageUserTypeId == 1
                                  ? Routes.loginPassword
                                  : Routes.onboarding,
                              arguments: storageUserTypeId == 1
                                  ? LoginPasswordArgumentModel(
                                      emailId: createAccountArgumentModel.email,
                                      userId: 0,
                                      userTypeId: isPersonalFocussed ? 1 : 2,
                                      companyId: isPersonalFocussed ? 0 : 1,
                                      isSwitching: false,
                                    ).toMap()
                                  : OnboardingArgumentModel(
                                      isInitial: true,
                                    ).toMap(),
                            );
                          }
                        },
                        text: storageUserTypeId == 1
                            ? labels[205]["labelText"]
                            : labels[347]["labelText"],
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
            isValidating = false;
            showButtonBloc.add(ShowButtonEvent(show: isValidating));
          }
        },
        text: labels[31]["labelText"],
        auxWidget: isValidating ? const LoaderRow() : const SizeBox(),
      );
    } else {
      return SolidButton(onTap: () {}, text: labels[31]["labelText"]);
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
              // Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                Routes.registration,
                arguments: RegistrationArgumentModel(
                  isInitial: true,
                  isUpdateCorpEmail: false,
                ).toMap(),
              );
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

  void loginMethod() {
    if (storageCif == "null" || storageCif == null) {
      if (storageRetailLoggedIn == true) {
        if (persistBiometric == true) {
          Navigator.pushNamed(
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
          Navigator.pushNamed(
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
      } else {
        Navigator.pushNamed(context, Routes.loginUserId);
      }
    } else {
      if (storageIsCompany == true) {
        if (storageisCompanyRegistered == false) {
          Navigator.pushNamed(context, Routes.loginUserId);
        } else {
          if (persistBiometric == true) {
            Navigator.pushNamed(
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
            Navigator.pushNamed(
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
        if (persistBiometric == true) {
          Navigator.pushNamed(
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
          Navigator.pushNamed(
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
    }
  }
}
