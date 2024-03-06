// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:local_auth/local_auth.dart';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool isEnabled = persistBiometric == true;
  bool isBioAvailable = true;

  late ProfileUpdatePasswordArgumentModel profileUpdatePasswordArgument;

  @override
  void initState() {
    super.initState();
    initializeArgument();
    checkBioAvailability();
  }

  void initializeArgument() {
    profileUpdatePasswordArgument = ProfileUpdatePasswordArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
  }

  Future<void> checkBioAvailability() async {
    List availableBiometrics =
        await LocalAuthentication().getAvailableBiometrics();
    isBioAvailable = availableBiometrics.isNotEmpty;
    log("isBioAvailable -> $isBioAvailable");
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labels[13]["labelText"],
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              labels[43]["labelText"],
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.dark50,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
                vertical: (13 / Dimensions.designHeight).h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: AppColors.dark10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    labels[44]["labelText"],
                    style: TextStyles.primary.copyWith(
                      color: const Color(0XFF979797),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildBiometricSwitch,
                  ),
                ],
              ),
            ),
            const SizeBox(height: 30),
            InkWell(
              onTap: () async {
                if (passwordChangesToday > 2) {
                  Navigator.pushNamed(
                    context,
                    Routes.errorSuccessScreen,
                    arguments: ErrorArgumentModel(
                      hasSecondaryButton: false,
                      iconPath: ImageConstants.errorOutlined,
                      title: "Limit exceeded!",
                      message:
                          "Password cannot be changed more than thrice a day",
                      buttonText: labels[347]["labelText"],
                      onTap: () {
                        // Navigator.pushNamedAndRemoveUntil(
                        //   context,
                        //   Routes.retailDashboard,
                        //   (route) => false,
                        //   arguments: RetailDashboardArgumentModel(
                        //     imgUrl: "",
                        //     name: customerName ?? "",
                        //     isFirst: storageIsFirstLogin == true
                        //         ? false
                        //         : true,
                        //   ).toMap(),
                        // );
                        Navigator.pop(context);
                      },
                      buttonTextSecondary: "",
                      onTapSecondary: () {},
                    ).toMap(),
                  );
                } else {
                  bool isBioCapable =
                      await LocalAuthentication().canCheckBiometrics;
                  if (!isBioCapable) {
                    // navigate to password screen
                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        Routes.profileUpdatePassword,
                        arguments: ProfileUpdatePasswordArgumentModel(
                          isRetail: profileUpdatePasswordArgument.isRetail,
                          isEmailChange: false,
                          isMobileChange: false,
                          isPasswordChange: true,
                        ).toMap(),
                      );
                    }
                  } else {
                    List availableBios =
                        await LocalAuthentication().getAvailableBiometrics();
                    if (availableBios.isEmpty || persistBiometric != true) {
                      // navigate to password screen
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          Routes.profileUpdatePassword,
                          arguments: ProfileUpdatePasswordArgumentModel(
                            isRetail: profileUpdatePasswordArgument.isRetail,
                            isEmailChange: false,
                            isMobileChange: false,
                            isPasswordChange: true,
                          ).toMap(),
                        );
                      }
                    } else {
                      bool isAuthenticated =
                          await BiometricHelper.authenticateUser();
                      if (!isAuthenticated) {
                        // navigate to password screen
                        if (context.mounted) {
                          Navigator.pushNamed(
                            context,
                            Routes.profileUpdatePassword,
                            arguments: ProfileUpdatePasswordArgumentModel(
                              isRetail: profileUpdatePasswordArgument.isRetail,
                              isEmailChange: false,
                              isMobileChange: false,
                              isPasswordChange: true,
                            ).toMap(),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          Navigator.pushNamed(context, Routes.changePassword);
                        }
                      }
                    }
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (PaddingConstants.horizontalPadding /
                          Dimensions.designWidth)
                      .w,
                  vertical: (PaddingConstants.horizontalPadding /
                          Dimensions.designHeight)
                      .h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                  color: Colors.white,
                  boxShadow: [BoxShadows.primary],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        labels[45]["labelText"],
                        style: TextStyles.primary.copyWith(
                          color: AppColors.primary,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      ImageConstants.arrowForwardIos,
                      width: (12 / Dimensions.designWidth).w,
                      height: (16 / Dimensions.designHeight).h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    // const SizeBox(width: 10),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBiometricSwitch(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc isEnabledBloc = context.read<ShowButtonBloc>();
    return FlutterSwitch(
      width: (45 / Dimensions.designWidth).w,
      height: (25 / Dimensions.designHeight).h,
      activeColor: AppColors.green100,
      inactiveColor: const Color(0XFF818181),
      toggleSize: (15 / Dimensions.designWidth).w,
      value: isEnabled,
      onToggle: (val) async {
        if (isBioCapable) {
          if (isBioAvailable) {
            isEnabled = val;
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.checkCircleOutlined,
                  title: isEnabled ? "Biometric enabled" : "Biometric Disabled",
                  message: isEnabled
                      ? "Enjoy the added convenience and security in using the app with biometric authentication."
                      : "You can turn on biometric authentication anytime from the profile menu.",
                  actionWidget: GradientButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: labels[293]["labelText"],
                  ),
                );
              },
            );
            await storage.write(
                key: "persistBiometric", value: isEnabled.toString());
            persistBiometric =
                await storage.read(key: "persistBiometric") == "true";
            log("persistBiometric -> $persistBiometric");
            isEnabledBloc.add(ShowButtonEvent(show: isEnabled));
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Biometric Not Setup",
                  message:
                      "Biometric has not been set up on this device. Please go to your phone's settings to set it up.",
                  actionWidget: GradientButton(
                    onTap: () {
                      // TODO: In future we can implement Opensettings here
                      Navigator.pop(context);
                    },
                    text: labels[346]["labelText"],
                  ),
                );
              },
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Biometric Not Available",
                message:
                    "Your phone does not support biometric authentication.",
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
    );
  }
}
