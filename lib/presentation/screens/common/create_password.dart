// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/checkBox/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_event.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_state.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_bloc.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_event.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_state.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_event.dart';
import 'package:dialup_mobile_app/bloc/matchPassword/match_password_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/createPassword/criteria.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late final TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late CreateAccountArgumentModel createAccountArgumentModel;

  bool showPassword = false;
  bool showConfirmPassword = false;

  int toggle = 0;

  // ? boolean flags for criteria
  bool hasMin8 = false;
  bool hasNumeric = false;
  bool hasUpperLower = false;
  bool hasSpecial = false;

  bool isMatch = false;

  bool isChecked = false;

  bool allTrue = false;

  bool isRegistering = false;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    controllerInitialization();
    blocInitialization();
  }

  void argumentInitialization() {
    createAccountArgumentModel =
        CreateAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void controllerInitialization() {
    _emailController =
        TextEditingController(text: createAccountArgumentModel.email);
  }

  void blocInitialization() {
    final CriteriaBloc criteriaBloc = context.read<CriteriaBloc>();
    criteriaBloc.add(CriteriaMin8Event(hasMin8: hasMin8));
    criteriaBloc.add(CriteriaNumericEvent(hasNumeric: hasNumeric));
    criteriaBloc.add(CriteriaUpperLowerEvent(hasUpperLower: hasUpperLower));
    criteriaBloc.add(CriteriaSpecialEvent(hasSpecial: hasSpecial));

    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));

    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: false));

    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
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
                (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[182]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 15),
                    Text(
                      labels[219]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'User ID',
                                style: TextStyles.primary.copyWith(
                                  color: AppColors.black63,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' * ',
                                    style: TextStyles.primary.copyWith(
                                      color: AppColors.red100,
                                      fontSize: (14 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '(Email address)',
                                    style: TextStyles.primary.copyWith(
                                      color:
                                          const Color.fromRGBO(99, 99, 99, 0.5),
                                      fontSize: (14 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizeBox(height: 9),
                            CustomTextField(
                              controller: _emailController,
                              enabled: false,
                              onChanged: (p0) {},
                              color: AppColors.dark10,
                              fontColor: const Color.fromRGBO(37, 37, 37, 0.5),
                            ),
                            const SizeBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  labels[182]["labelText"],
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.black63,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const Asterisk(),
                              ],
                            ),
                            const SizeBox(height: 9),
                            BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                              builder: buildShowPassword,
                            ),
                            const SizeBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  labels[49]["labelText"],
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.black63,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                const Asterisk(),
                              ],
                            ),
                            const SizeBox(height: 9),
                            BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                              builder: buildShowConfirmPassword,
                            ),
                            const SizeBox(height: 9),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: (context, state) {
                                if (_confirmPasswordController.text.length <
                                    8) {
                                  return const SizeBox();
                                } else {
                                  return BlocBuilder<MatchPasswordBloc,
                                      MatchPasswordState>(
                                    builder: buildMatchMessage,
                                  );
                                }
                              },
                            ),
                            const SizeBox(height: 15),
                            BlocBuilder<CriteriaBloc, CriteriaState>(
                              builder: buildCriteriaSection,
                            ),
                            const SizeBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      BlocBuilder<CheckBoxBloc, CheckBoxState>(
                        builder: buildCheckBox,
                      ),
                      const SizeBox(width: 5),
                      Row(
                        children: [
                          Text(
                            'I agree to the ',
                            style: TextStyles.primary.copyWith(
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.pushNamed(
                          //         context, Routes.termsAndConditions);
                          //   },
                          //   child: Text(
                          //     'Terms & Conditions',
                          //     style: TextStyles.primary.copyWith(
                          //       color: AppColors.primary,
                          //       fontSize: (16 / Dimensions.designWidth).w,
                          //       decoration: TextDecoration.underline,
                          //     ),
                          //   ),
                          // ),
                          // Text(
                          //   ' and ',
                          //   style: TextStyles.primary.copyWith(
                          //     color: const Color.fromRGBO(0, 0, 0, 0.5),
                          //     fontSize: (16 / Dimensions.designWidth).w,
                          //   ),
                          // ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.privacyStatement);
                            },
                            child: Text(
                              'Privacy Policy',
                              style: TextStyles.primary.copyWith(
                                color: AppColors.primary,
                                fontSize: (16 / Dimensions.designWidth).w,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizeBox(height: 5),
                  BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
                    builder: buildSubmitButton,
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

  Widget buildShowPassword(BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
    if (showPassword) {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showPassword = !showPassword;
            },
            child: Icon(
              Icons.visibility_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerCriteriaEvent(p0);
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showPassword,
      );
    } else {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showPassword = !showPassword;
            },
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerCriteriaEvent(p0);
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showPassword,
      );
    }
  }

  Widget buildShowConfirmPassword(
      BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc confirmPasswordBloc =
        context.read<ShowPasswordBloc>();
    // final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showConfirmPassword) {
      return CustomTextField(
        // width: 83.w,
        controller: _confirmPasswordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              confirmPasswordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showConfirmPassword = !showConfirmPassword;
            },
            child: Icon(
              Icons.visibility_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
          // showButtonBloc.add(ShowButtonEvent(show: p0.length < 8));
        },
        obscureText: !showConfirmPassword,
      );
    } else {
      return CustomTextField(
        // width: 83.w,
        controller: _confirmPasswordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              confirmPasswordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showConfirmPassword = !showConfirmPassword;
            },
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
          // showButtonBloc.add(ShowButtonEvent(show: p0.length < 8));
        },
        obscureText: !showConfirmPassword,
      );
    }
  }

  Widget buildMatchMessage(BuildContext context, MatchPasswordState state) {
    return BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
        builder: (context, state) {
      return Row(
        children: [
          Ternary(
            condition: isMatch,
            truthy: Icon(
              Icons.check_circle_rounded,
              color: AppColors.green100,
              size: (13 / Dimensions.designWidth).w,
            ),
            falsy: Icon(
              Icons.error,
              color: AppColors.orange100,
              size: (13 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(width: 5),
          Text(
            isMatch ? "Password is matching" : "Password is not matching",
            style: TextStyles.primaryMedium.copyWith(
              color: isMatch ? AppColors.green100 : AppColors.orange100,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    });
  }

  Widget buildCriteriaSection(BuildContext context, CriteriaState state) {
    return PasswordCriteria(
      criteria1Color: hasMin8 ? AppColors.primaryDark : AppColors.red100,
      criteria2Color: hasNumeric ? AppColors.primaryDark : AppColors.red100,
      criteria3Color: hasUpperLower ? AppColors.primaryDark : AppColors.red100,
      criteria4Color: hasSpecial ? AppColors.primaryDark : AppColors.red100,
      criteria1Widget: hasMin8
          ? SvgPicture.asset(
              ImageConstants.checkSmall,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            )
          : SvgPicture.asset(
              ImageConstants.redCross,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
      criteria2Widget: hasNumeric
          ? SvgPicture.asset(
              ImageConstants.checkSmall,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            )
          : SvgPicture.asset(
              ImageConstants.redCross,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
      criteria3Widget: hasUpperLower
          ? SvgPicture.asset(
              ImageConstants.checkSmall,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            )
          : SvgPicture.asset(
              ImageConstants.redCross,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
      criteria4Widget: hasSpecial
          ? SvgPicture.asset(
              ImageConstants.checkSmall,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            )
          : SvgPicture.asset(
              ImageConstants.redCross,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
    );
  }

  Widget buildCheckBox(BuildContext context, CheckBoxState state) {
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

  Widget buildSubmitButton(BuildContext context, CreatePasswordState state) {
    if (allTrue) {
      return Column(
        children: [
          const SizeBox(height: 10),
          GradientButton(
            onTap: () async {
              if (!isRegistering) {
                final CreatePasswordBloc createPasswordBloc =
                    context.read<CreatePasswordBloc>();

                log("Original Password -> ${_passwordController.text}");
                String ecryptedPassword =
                    EncryptDecrypt.encrypt(_passwordController.text);
                log("Encrypted Password -> $ecryptedPassword");
                await storage.write(
                  key: "password", value: ecryptedPassword,
                  // _passwordController.text
                );
                storagePassword = await storage.read(key: "password");
                log("storagePassword -> $storagePassword");
                if (createAccountArgumentModel.isRetail) {
                  isRegistering = true;
                  createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
                  log("Register User API Req -> ${{
                    "userType": 1,
                    "emailId": createAccountArgumentModel.email,
                    "password": ecryptedPassword,
                    "deviceId": storageDeviceId,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion,
                    "invitationCode": referralCode,
                  }}");
                  var result1 = await MapRegisterUser.mapRegisterUser({
                    "userType": 1,
                    "emailId": createAccountArgumentModel.email,
                    "password": ecryptedPassword,
                    "deviceId": storageDeviceId,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion,
                    "invitationCode": referralCode,
                  });
                  log("Register User API Response -> $result1");

                  userId = result1["userId"];
                  await storage.write(key: "userId", value: userId.toString());
                  await storage.write(key: "userTypeId", value: 1.toString());
                  await storage.write(key: "companyId", value: 0.toString());

                  storageUserId =
                      int.parse(await storage.read(key: "userId") ?? "0");
                  storageUserTypeId =
                      int.parse(await storage.read(key: "userTypeId") ?? "0");
                  storageCompanyId =
                      int.parse(await storage.read(key: "companyId") ?? "0");

                  var result = await MapLogin.mapLogin({
                    "emailId": createAccountArgumentModel.email,
                    "userTypeId": storageUserTypeId,
                    "userId": storageUserId,
                    "companyId": storageCompanyId,
                    "password": ecryptedPassword,
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
                    // customerName = result["customerName"];

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
                    await storage.write(
                        key: "loggedOut", value: false.toString());
                    storageLoggedOut =
                        await storage.read(key: "loggedOut") == "true";
                    await storage.write(
                        key: "stepsCompleted", value: 2.toString());
                    storageStepsCompleted = int.parse(
                        await storage.read(key: "stepsCompleted") ?? "0");
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.retailOnboardingStatus,
                        (routes) => false,
                        arguments: OnboardingStatusArgumentModel(
                          stepsCompleted: 1,
                          isFatca: false,
                          isPassport: false,
                          isRetail: createAccountArgumentModel.isRetail,
                        ).toMap(),
                      );
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
                        case 9:
                          promptMaxRetries(result["reason"] ??
                              "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.");
                          break;
                        default:
                      }
                    }
                  }
                } else {
                  isRegistering = true;
                  createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
                  log("Register User API Req -> ${{
                    "userType": 2,
                    "emailId": createAccountArgumentModel.email,
                    "password":
                        EncryptDecrypt.encrypt(_passwordController.text),
                    "deviceId": storageDeviceId,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion
                  }}");
                  var result1 = await MapRegisterUser.mapRegisterUser({
                    "userType": 2,
                    "emailId": createAccountArgumentModel.email,
                    "password":
                        EncryptDecrypt.encrypt(_passwordController.text),
                    "deviceId": storageDeviceId,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion
                  });
                  log("Register User API Response -> $result1");

                  userId = result1["userId"];
                  log("userId -> $userId");
                  log("userId runtimeType -> ${userId.runtimeType}");

                  await storage.write(key: "userId", value: userId.toString());
                  await storage.write(key: "userTypeId", value: 2.toString());
                  await storage.write(key: "companyId", value: 1.toString());

                  storageUserId =
                      int.parse(await storage.read(key: "userId") ?? "");
                  storageUserTypeId =
                      int.parse(await storage.read(key: "userTypeId") ?? "");
                  storageCompanyId =
                      int.parse(await storage.read(key: "companyId") ?? "");

                  var result = await MapLogin.mapLogin({
                    "emailId": createAccountArgumentModel.email,
                    "userTypeId": storageUserTypeId,
                    "userId": storageUserId,
                    "companyId": storageCompanyId,
                    "password":
                        EncryptDecrypt.encrypt(_passwordController.text),
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
                    // customerName = result["customerName"];
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
                    await storage.write(
                        key: "loggedOut", value: false.toString());
                    storageLoggedOut =
                        await storage.read(key: "loggedOut") == "true";
                    await storage.write(
                        key: "stepsCompleted", value: 2.toString());
                    storageStepsCompleted = int.parse(
                        await storage.read(key: "stepsCompleted") ?? "0");
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.businessOnboardingStatus,
                        (routes) => false,
                        arguments: OnboardingStatusArgumentModel(
                          stepsCompleted: 1,
                          isFatca: false,
                          isPassport: false,
                          isRetail: createAccountArgumentModel.isRetail,
                        ).toMap(),
                      );
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
                        case 9:
                          promptMaxRetries(result["reason"] ??
                              "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.");
                          break;
                        default:
                      }
                    }
                  }
                }
                isRegistering = false;
                createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
              }
            },
            text: labels[222]["labelText"],
            auxWidget: isRegistering ? const LoaderRow() : const SizeBox(),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizeBox(height: 10),
          SolidButton(onTap: () {}, text: labels[222]["labelText"]),
        ],
      );
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
          auxWidget: Column(
            children: [
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizeBox(height: 15),
                      GradientButton(
                        onTap: () async {
                          isLoading = true;
                          final ShowButtonBloc showButtonBloc =
                              context.read<ShowButtonBloc>();
                          showButtonBloc.add(ShowButtonEvent(show: isLoading));
                          var result = await MapLogin.mapLogin({
                            "emailId": createAccountArgumentModel.email,
                            "userTypeId": storageUserTypeId,
                            "userId": storageUserId,
                            "companyId": storageCompanyId,
                            "password": EncryptDecrypt.encrypt(
                                _passwordController.text),
                            "deviceId": storageDeviceId,
                            "registerDevice": true,
                            "deviceName": deviceName,
                            "deviceType": deviceType,
                            "appVersion": appVersion,
                            "fcmToken": fcmToken,
                          });
                          log("Login API Response -> $result");

                          await storage.write(
                              key: "token", value: result["token"]);
                          if (result["success"]) {
                            isUserLoggedIn = true;
                            // customerName = result["customerName"];
                            if (context.mounted) {
                              if (result["invitationCode"] != null &&
                                  result["invitationCode"].isNotEmpty) {
                                await PopulateInviteDetails
                                    .populateInviteDetails(
                                        context, result["invitationCode"]);
                              }
                            }
                            notificationCount = result["notificationCount"];
                            log("notificationCount -> $notificationCount");
                            passwordChangesToday =
                                result["passwordChangesToday"];
                            emailChangesToday = result["emailChangesToday"];
                            mobileChangesToday = result["mobileChangesToday"];
                            await storage.write(
                                key: "loggedOut", value: false.toString());
                            storageLoggedOut =
                                await storage.read(key: "loggedOut") == "true";
                            await storage.write(
                                key: "stepsCompleted", value: 2.toString());
                            storageStepsCompleted = int.parse(
                                await storage.read(key: "stepsCompleted") ??
                                    "0");
                            if (context.mounted) {
                              if (createAccountArgumentModel.userTypeId == 1) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.retailDashboard,
                                  (route) => false,
                                  arguments: RetailDashboardArgumentModel(
                                    imgUrl: "",
                                    name: result["customerName"],
                                    isFirst: true,
                                  ).toMap(),
                                );
                              } else {
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
                                case 9:
                                  promptMaxRetries(result["reason"] ??
                                      "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.");
                                  break;
                                default:
                              }
                            }
                          }
                          isLoading = false;
                          showButtonBloc.add(ShowButtonEvent(show: isLoading));
                        },
                        text: labels[31]["labelText"],
                        auxWidget:
                            isLoading ? const LoaderRow() : const SizeBox(),
                      ),
                    ],
                  );
                },
              ),
              const SizeBox(height: 15),
            ],
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

  void promptMaxRetries(String reason) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Retry Limit Reached",
          message: reason,
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                Routes.onboarding,
                arguments: OnboardingArgumentModel(isInitial: true).toMap(),
              );
            },
            text: "Go Home",
          ),
        );
      },
    );
  }

  void promptKycExpired() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "KYC Expired",
          message:
              "Your KYC Documents have expired. Please verify your documents again.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.verificationInitializing,
                arguments: VerificationInitializationArgumentModel(
                  isReKyc: false,
                ).toMap(),
              );
            },
            text: "Verify",
          ),
        );
      },
    );
  }

  void triggerCriteriaEvent(String p0) {
    final CriteriaBloc criteriaBloc = context.read<CriteriaBloc>();

    if (p0.length >= 8) {
      criteriaBloc.add(CriteriaMin8Event(hasMin8: true));
      hasMin8 = true;
    } else {
      criteriaBloc.add(CriteriaMin8Event(hasMin8: false));
      hasMin8 = false;
    }

    if (p0.contains(RegExp(r'[0-9]'))) {
      criteriaBloc.add(CriteriaNumericEvent(hasNumeric: true));
      hasNumeric = true;
    } else {
      criteriaBloc.add(CriteriaNumericEvent(hasNumeric: false));
      hasNumeric = false;
    }

    if (p0.contains(RegExp(r'[A-Z]')) && p0.contains(RegExp(r'[a-z]'))) {
      criteriaBloc.add(CriteriaUpperLowerEvent(hasUpperLower: true));
      hasUpperLower = true;
    } else {
      criteriaBloc.add(CriteriaUpperLowerEvent(hasUpperLower: false));
      hasUpperLower = false;
    }

    if (p0.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      criteriaBloc.add(CriteriaSpecialEvent(hasSpecial: true));
      hasSpecial = true;
    } else {
      criteriaBloc.add(CriteriaSpecialEvent(hasSpecial: false));
      hasSpecial = false;
    }
  }

  void triggerPasswordMatchEvent() {
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (_passwordController.text == _confirmPasswordController.text) {
      isMatch = true;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    } else {
      isMatch = false;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    }
    showButtonBloc
        .add(ShowButtonEvent(show: _confirmPasswordController.text.length < 8));
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void triggerAllTrueEvent() {
    allTrue = hasMin8 &&
        hasNumeric &&
        hasUpperLower &&
        hasSpecial &&
        isMatch &&
        isChecked;
    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
  }
}
