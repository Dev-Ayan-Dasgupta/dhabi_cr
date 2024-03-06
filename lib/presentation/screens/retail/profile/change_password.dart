import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
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

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  // ? boolean flags for password obscurity
  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmNewPassword = false;

  int toggle = 0;

  bool isCorrect = false;
  bool isMatch = false;

  // ? boolean flags for password criteria
  bool hasMin8 = false;
  bool hasUpperLower = false;
  bool hasNumeric = false;
  bool hasSpecial = false;

  bool isChecked = false;

  bool allTrue = false;

  String currentPassword = storagePassword ?? "";

  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
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
                    labels[45]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Update your password by filling out the form below with your new password and confirmation.",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    labels[46]["labelText"],
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.dark80,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                  const Asterisk(),
                                ],
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.pushNamed(
                              //         context, Routes.registration,
                              //         arguments: RegistrationArgumentModel(
                              //             isInitial: false));
                              //   },
                              //   child: Text(
                              //     labels[47]["labelText"],
                              //     style: TextStyles.primaryMedium.copyWith(
                              //       color:
                              //           const Color.fromRGBO(34, 97, 105, 0.5),
                              //       fontSize: (16 / Dimensions.designWidth).w,
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                            builder: buildCurrentPassword,
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: buildCurrentPasswordError,
                          ),
                          const SizeBox(height: 15),
                          Row(
                            children: [
                              Text(
                                labels[48]["labelText"],
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                            builder: buildShowNewPassword,
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: buildCriteriaError,
                          ),
                          const SizeBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "Confirm New Password",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                            builder: buildConfirmNewPassword,
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: buildConfirmNewPasswordError,
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
    );
  }

  void triggerValidityEvent(String p0, String matcher) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    if (p0.length >= 8) {
      if (p0 == matcher) {
        isCorrect = true;
        showButtonBloc.add(ShowButtonEvent(show: isCorrect));
      } else {
        isCorrect = false;
        showButtonBloc.add(ShowButtonEvent(show: isCorrect));
      }
    }
  }

  void triggerCriteriaEvent(String p0) {
    final CriteriaBloc criteriaBloc = context.read<CriteriaBloc>();
    final ShowButtonBloc showCriteriaMessageBloc =
        context.read<ShowButtonBloc>();

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

    showCriteriaMessageBloc.add(ShowButtonEvent(
        show: hasMin8 && hasNumeric && hasUpperLower && hasSpecial));
  }

  void triggerPasswordMatchEvent() {
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();

    final ShowButtonBloc matchPasswordMessageBloc =
        context.read<ShowButtonBloc>();

    if (_newPasswordController.text == _confirmNewPasswordController.text) {
      isMatch = true;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    } else {
      isMatch = false;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    }

    matchPasswordMessageBloc.add(ShowButtonEvent(show: isMatch));
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void triggerAllTrueEvent() {
    allTrue = isCorrect &&
        hasMin8 &&
        hasNumeric &&
        hasUpperLower &&
        hasSpecial &&
        isMatch;
    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
  }

  Widget buildCurrentPassword(BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
    if (showCurrentPassword) {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return CustomTextField(
            borderColor:
                !isCorrect && _currentPasswordController.text.length >= 8
                    ? AppColors.red100
                    : const Color(0XFFEEEEEE),
            controller: _currentPasswordController,
            minLines: 1,
            maxLines: 1,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
              child: InkWell(
                onTap: () {
                  passwordBloc.add(
                      HidePasswordEvent(showPassword: false, toggle: ++toggle));
                  showCurrentPassword = !showCurrentPassword;
                },
                child: Icon(
                  Icons.visibility_outlined,
                  color: const Color.fromRGBO(34, 97, 105, 0.5),
                  size: (20 / Dimensions.designWidth).w,
                ),
              ),
            ),
            onChanged: (p0) async {
              triggerValidityEvent(
                p0,
                decryptedStoredPassword,
                // storagePassword ?? "",
              );
              triggerAllTrueEvent();
            },
            obscureText: !showCurrentPassword,
          );
        },
      );
    } else {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return CustomTextField(
            borderColor:
                !isCorrect && _currentPasswordController.text.length >= 8
                    ? AppColors.red100
                    : const Color(0XFFEEEEEE),
            controller: _currentPasswordController,
            minLines: 1,
            maxLines: 1,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
              child: InkWell(
                onTap: () {
                  passwordBloc.add(DisplayPasswordEvent(
                      showPassword: true, toggle: ++toggle));
                  showCurrentPassword = !showCurrentPassword;
                },
                child: Icon(
                  Icons.visibility_off_outlined,
                  color: const Color.fromRGBO(34, 97, 105, 0.5),
                  size: (20 / Dimensions.designWidth).w,
                ),
              ),
            ),
            onChanged: (p0) async {
              triggerValidityEvent(
                p0,
                decryptedStoredPassword,
                // storagePassword ?? "",
              );
              triggerAllTrueEvent();
            },
            obscureText: !showCurrentPassword,
          );
        },
      );
    }
  }

  Widget buildCurrentPasswordError(
      BuildContext context, ShowButtonState state) {
    if (!isCorrect && _currentPasswordController.text.length >= 8) {
      return Row(
        children: [
          SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "Password incorrect",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red100,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildShowNewPassword(BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
    if (showNewPassword) {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return CustomTextField(
            borderColor:
                !(hasMin8 && hasUpperLower && hasNumeric && hasSpecial) &&
                        _newPasswordController.text.length >= 8
                    ? AppColors.red100
                    : const Color(0XFFEEEEEE),
            controller: _newPasswordController,
            minLines: 1,
            maxLines: 1,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
              child: InkWell(
                onTap: () {
                  passwordBloc.add(
                      HidePasswordEvent(showPassword: false, toggle: ++toggle));
                  showNewPassword = !showNewPassword;
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
            obscureText: !showNewPassword,
          );
        },
      );
    } else {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return CustomTextField(
            borderColor:
                !(hasMin8 && hasUpperLower && hasNumeric && hasSpecial) &&
                        _newPasswordController.text.length >= 8
                    ? AppColors.red100
                    : const Color(0XFFEEEEEE),
            controller: _newPasswordController,
            minLines: 1,
            maxLines: 1,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
              child: InkWell(
                onTap: () {
                  passwordBloc.add(DisplayPasswordEvent(
                      showPassword: true, toggle: ++toggle));
                  showNewPassword = !showNewPassword;
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
            obscureText: !showNewPassword,
          );
        },
      );
    }
  }

  Widget buildCriteriaError(BuildContext context, ShowButtonState state) {
    if (!(hasMin8 && hasUpperLower && hasNumeric && hasSpecial) &&
        _newPasswordController.text.length >= 8) {
      return Row(
        children: [
          SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "Password does not meet the criteria",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red100,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildConfirmNewPassword(
      BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc confirmPasswordBloc =
        context.read<ShowPasswordBloc>();
    if (showConfirmNewPassword) {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return CustomTextField(
            borderColor:
                !isMatch && _confirmNewPasswordController.text.length >= 8
                    ? AppColors.orange100
                    : const Color(0xFFEEEEEE),
            controller: _confirmNewPasswordController,
            minLines: 1,
            maxLines: 1,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
              child: InkWell(
                onTap: () {
                  confirmPasswordBloc.add(
                      HidePasswordEvent(showPassword: false, toggle: ++toggle));
                  showConfirmNewPassword = !showConfirmNewPassword;
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
            },
            obscureText: !showConfirmNewPassword,
          );
        },
      );
    } else {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return CustomTextField(
            borderColor:
                !isMatch && _confirmNewPasswordController.text.length >= 8
                    ? AppColors.orange100
                    : const Color(0xFFEEEEEE),
            controller: _confirmNewPasswordController,
            minLines: 1,
            maxLines: 1,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
              child: InkWell(
                onTap: () {
                  confirmPasswordBloc.add(DisplayPasswordEvent(
                      showPassword: true, toggle: ++toggle));
                  showConfirmNewPassword = !showConfirmNewPassword;
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
            },
            obscureText: !showConfirmNewPassword,
          );
        },
      );
    }
  }

  Widget buildConfirmNewPasswordError(
      BuildContext context, ShowButtonState state) {
    if (!isMatch && _confirmNewPasswordController.text.length >= 8) {
      return Row(
        children: [
          SvgPicture.asset(
            ImageConstants.warningSmall,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "New passwords do not match",
            style: TextStyles.primaryMedium.copyWith(
              color: const Color(0xFFF39C12),
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildCriteriaSection(BuildContext context, CriteriaState state) {
    return PasswordCriteria(
      criteria1Color: hasMin8 ? AppColors.primary : AppColors.red100,
      criteria2Color: hasNumeric ? AppColors.primary : AppColors.red100,
      criteria3Color: hasUpperLower ? AppColors.primary : AppColors.red100,
      criteria4Color: hasSpecial ? AppColors.primary : AppColors.red100,
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

  Widget buildSubmitButton(BuildContext context, CreatePasswordState state) {
    if (allTrue) {
      return Column(
        children: [
          BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return GradientButton(
                onTap: () async {
                  if (!isUpdating) {
                    final ShowButtonBloc showButtonBloc =
                        context.read<ShowButtonBloc>();
                    isUpdating = true;
                    showButtonBloc.add(ShowButtonEvent(show: isUpdating));

                    // final key = encrypt.Key.fromBase64(
                    //     'izkj9zt/Z7Dkb7MPkXECwmVKo2aB4olInwkytH+8hM4=');
                    // final iv = encrypt.IV.fromLength(64);
                    // final encrypter = encrypt.Encrypter(encrypt.AES(key));
                    // final encrypted =
                    //     encrypter.encrypt(_newPasswordController.text, iv: iv);
                    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
                    // log("encrypted -> ${encrypted.base64}");
                    // log("decrypted -> $decrypted");
                    await storage.write(
                        key: "password",
                        value:
                            EncryptDecrypt.encrypt(_newPasswordController.text)
                        // _newPasswordController.text,
                        );
                    storagePassword = await storage.read(key: "password");
                    log("storagePassword -> $storagePassword");

                    log("Change Password Request -> ${{
                      "cif": storageCif,
                      "password":
                          EncryptDecrypt.encrypt(_newPasswordController.text),
                    }}");
                    var changePasswordApiResult =
                        await MapChangePassword.mapChangePassword(
                      {
                        "cif": storageCif,
                        "password":
                            EncryptDecrypt.encrypt(_newPasswordController.text),
                      },
                      token ?? "",
                    );
                    log("Change Password API response -> $changePasswordApiResult");

                    if (changePasswordApiResult["success"]) {
                      await storage.write(
                          key: "password",
                          value: EncryptDecrypt.encrypt(
                              _confirmNewPasswordController.text)
                          //  _confirmNewPasswordController.text,
                          );
                      storagePassword = await storage.read(key: "password");
                      log("storagePassword -> $storagePassword");
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          Routes.errorSuccessScreen,
                          arguments: ErrorArgumentModel(
                            hasSecondaryButton: false,
                            iconPath: ImageConstants.checkCircleOutlined,
                            title: messages[88]["messageText"],
                            message: messages[44]["messageText"],
                            buttonText: labels[205]["labelText"],
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.loginPassword,
                                (route) => false,
                                arguments: LoginPasswordArgumentModel(
                                  emailId: storageEmail ?? "",
                                  userId: storageUserId ?? 0,
                                  userTypeId: storageUserTypeId ?? 1,
                                  companyId: storageCompanyId ?? 0,
                                  isSwitching: false,
                                ).toMap(),
                              );
                            },
                            buttonTextSecondary: "",
                            onTapSecondary: () {},
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
                              title: "Password Change Error",
                              message: changePasswordApiResult["message"],
                              actionWidget: GradientButton(
                                onTap: () {
                                  Navigator.pop(context);
                                  // Navigator.pushReplacementNamed(
                                  //     context, Routes.loginUserId);
                                },
                                text: "Understood",
                              ),
                            );
                          },
                        );
                      }
                    }
                    isUpdating = false;
                    showButtonBloc.add(ShowButtonEvent(show: isUpdating));
                  }
                },
                text: "Update",
                auxWidget: isUpdating ? const LoaderRow() : const SizeBox(),
              );
            },
          ),
        ],
      );
    } else {
      return SolidButton(onTap: () {}, text: "Update");
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
