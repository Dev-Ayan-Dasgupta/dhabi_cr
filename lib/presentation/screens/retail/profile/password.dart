// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class ProfileDetailsPasswordScreen extends StatefulWidget {
  const ProfileDetailsPasswordScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ProfileDetailsPasswordScreen> createState() =>
      _ProfileDetailsPasswordScreenState();
}

class _ProfileDetailsPasswordScreenState
    extends State<ProfileDetailsPasswordScreen> {
  bool showPassword = false;
  final TextEditingController _passwordController = TextEditingController();
  int toggle = 0;
  bool hasMin8 = false;
  bool hasNumeric = false;
  bool hasUpperLower = false;
  bool hasSpecial = false;
  bool allTrue = false;

  late ProfileUpdatePasswordArgumentModel profileUpdatePasswordArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    profileUpdatePasswordArgument = ProfileUpdatePasswordArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
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
                  const SizeBox(height: 10),
                  Text(
                    "Password",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Enter your login password to proceed with the change",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Enter Password",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                    builder: (context, state) {
                      if (showPassword) {
                        return CustomTextField(
                          controller: _passwordController,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                                left: (10 / Dimensions.designWidth).w),
                            child: InkWell(
                              onTap: () {
                                passwordBloc.add(HidePasswordEvent(
                                    showPassword: false, toggle: ++toggle));
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
                            triggerAllTrueEvent();
                          },
                          obscureText: !showPassword,
                        );
                      } else {
                        return CustomTextField(
                          maxLines: 1,
                          controller: _passwordController,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                                left: (10 / Dimensions.designWidth).w),
                            child: InkWell(
                              onTap: () {
                                passwordBloc.add(DisplayPasswordEvent(
                                    showPassword: true, toggle: ++toggle));
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
                            triggerAllTrueEvent();
                          },
                          obscureText: !showPassword,
                        );
                      }
                    },
                  ),
                  // const SizeBox(height: 10),
                  // InkWell(
                  //   onTap: () {
                  //     // TODO: Navigate to forgot password screen
                  //     Navigator.pushNamed(context, Routes.registration,
                  //         arguments: RegistrationArgumentModel(
                  //           isInitial: false,
                  //           isUpdateCorpEmail: false,
                  //         ).toMap());
                  //   },
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Text(
                  //       labels[47]["labelText"],
                  //       style: TextStyles.primaryMedium.copyWith(
                  //         color: const Color.fromRGBO(34, 97, 105, 0.5),
                  //         fontSize: (16 / Dimensions.designWidth).w,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                if (allTrue) {
                  return Column(
                    children: [
                      GradientButton(
                        onTap: () async {
                          if (_passwordController.text ==
                              decryptedStoredPassword) {
                            if (profileUpdatePasswordArgument.isEmailChange) {
                              if (profileUpdatePasswordArgument.isRetail) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.errorSuccessScreen,
                                  arguments: ErrorArgumentModel(
                                    hasSecondaryButton: true,
                                    iconPath: ImageConstants.warning,
                                    title: labels[250]["labelText"],
                                    message: messages[53]["messageText"],
                                    buttonText: labels[31]["labelText"],
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Routes.registration,
                                        arguments: RegistrationArgumentModel(
                                          isInitial: false,
                                          isUpdateCorpEmail: false,
                                        ).toMap(),
                                      );
                                    },
                                    buttonTextSecondary: labels[347]
                                        ["labelText"],
                                    onTapSecondary: () {
                                      Navigator.pop(context);
                                    },
                                  ).toMap(),
                                );
                              } else {
                                if (canChangeEmailId) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.errorSuccessScreen,
                                    arguments: ErrorArgumentModel(
                                      hasSecondaryButton: true,
                                      iconPath: ImageConstants.warning,
                                      title: labels[250]["labelText"],
                                      message: messages[53]["messageText"],
                                      buttonText: labels[31]["labelText"],
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          Routes.registration,
                                          arguments: RegistrationArgumentModel(
                                            isInitial: false,
                                            isUpdateCorpEmail: true,
                                          ).toMap(),
                                        );
                                      },
                                      buttonTextSecondary: labels[347]
                                          ["labelText"],
                                      onTapSecondary: () {
                                        Navigator.pop(context);
                                      },
                                    ).toMap(),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "No Permission",
                                        message:
                                            "You do not have permission to update your Email ID",
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
                            } else if (profileUpdatePasswordArgument
                                .isMobileChange) {
                              if (profileUpdatePasswordArgument.isRetail) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.verifyMobile,
                                  arguments: VerifyMobileArgumentModel(
                                    isBusiness: false,
                                    isUpdate: true,
                                    isReKyc: false,
                                  ).toMap(),
                                );
                              } else {
                                if (canChangeMobileNumber) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.verifyMobile,
                                    arguments: VerifyMobileArgumentModel(
                                      isBusiness: true,
                                      isUpdate: true,
                                      isReKyc: false,
                                    ).toMap(),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "No Permission",
                                        message:
                                            "You do not have permission to update your Mobile Number",
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
                              Navigator.pushNamed(
                                context,
                                Routes.setPassword,
                                arguments: SetPasswordArgumentModel(
                                  fromTempPassword: true,
                                  userTypeId: storageUserTypeId ?? 1,
                                  companyId: storageCompanyId ?? 0,
                                ).toMap(),
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  svgAssetPath: ImageConstants.warning,
                                  title: "Error",
                                  message:
                                      "Wrong password entered, please enter the correct password",
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
                        },
                        text: labels[31]["labelText"],
                      ),
                      SizeBox(
                        height: PaddingConstants.bottomPadding +
                            MediaQuery.paddingOf(context).bottom,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SolidButton(
                        onTap: () {},
                        text: labels[31]["labelText"],
                      ),
                      SizeBox(
                        height: PaddingConstants.bottomPadding +
                            MediaQuery.paddingOf(context).bottom,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
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

  void triggerAllTrueEvent() {
    allTrue = hasMin8 && hasNumeric && hasUpperLower && hasSpecial;
    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: allTrue));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
