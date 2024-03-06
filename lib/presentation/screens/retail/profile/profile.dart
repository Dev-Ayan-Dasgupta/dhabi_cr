// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:local_auth/local_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileArgumentModel profileArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    profileArgument =
        ProfileArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
              labels[12]["labelText"],
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            Text(
              labels[22]["labelText"],
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: const Color(0XFFF8F8F8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Customer ID",
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Text(
                        storageCif ?? "",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labels[23]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Text(
                        profileName ?? "",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labels[24]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy').format(
                            DateTime.parse(profileDoB ?? "01 January 1900")),
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizeBox(height: 20),
            Text(
              labels[25]["labelText"],
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: const Color(0XFFF8F8F8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labels[26]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            profileEmailId ?? "",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(width: 20),
                          InkWell(
                            onTap: () async {
                              if (emailChangesToday > 1) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.errorSuccessScreen,
                                  arguments: ErrorArgumentModel(
                                    hasSecondaryButton: false,
                                    iconPath: ImageConstants.errorOutlined,
                                    title: "Limit exceeded!",
                                    message:
                                        "Email cannot be changed more than once a day",
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
                                bool isBioCapable = await LocalAuthentication()
                                    .canCheckBiometrics;
                                if (!isBioCapable) {
                                  // navigate to password screen
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.profileUpdatePassword,
                                      arguments:
                                          ProfileUpdatePasswordArgumentModel(
                                        isRetail: profileArgument.isRetail,
                                        isEmailChange: true,
                                        isMobileChange: false,
                                        isPasswordChange: false,
                                      ).toMap(),
                                    );
                                  }
                                } else {
                                  List availableBios =
                                      await LocalAuthentication()
                                          .getAvailableBiometrics();
                                  if (availableBios.isEmpty ||
                                      persistBiometric != true) {
                                    // navigate to password screen
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.profileUpdatePassword,
                                        arguments:
                                            ProfileUpdatePasswordArgumentModel(
                                          isRetail: profileArgument.isRetail,
                                          isEmailChange: true,
                                          isMobileChange: false,
                                          isPasswordChange: false,
                                        ).toMap(),
                                      );
                                    }
                                  } else {
                                    bool isAuthenticated = await BiometricHelper
                                        .authenticateUser();
                                    if (!isAuthenticated) {
                                      // navigate to password screen
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.profileUpdatePassword,
                                          arguments:
                                              ProfileUpdatePasswordArgumentModel(
                                            isRetail: profileArgument.isRetail,
                                            isEmailChange: false,
                                            isMobileChange: true,
                                            isPasswordChange: false,
                                          ).toMap(),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        if (profileArgument.isRetail) {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.errorSuccessScreen,
                                            arguments: ErrorArgumentModel(
                                              hasSecondaryButton: true,
                                              iconPath: ImageConstants.warning,
                                              title: labels[250]["labelText"],
                                              message: messages[53]
                                                  ["messageText"],
                                              buttonText: labels[31]
                                                  ["labelText"],
                                              onTap: () {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.registration,
                                                  arguments:
                                                      RegistrationArgumentModel(
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
                                                iconPath:
                                                    ImageConstants.warning,
                                                title: labels[250]["labelText"],
                                                message: messages[53]
                                                    ["messageText"],
                                                buttonText: labels[31]
                                                    ["labelText"],
                                                onTap: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    Routes.registration,
                                                    arguments:
                                                        RegistrationArgumentModel(
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
                                                  svgAssetPath:
                                                      ImageConstants.warning,
                                                  title: "No Permission",
                                                  message:
                                                      "You do not have permission to update your Email ID",
                                                  actionWidget: GradientButton(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    text: labels[346]
                                                        ["labelText"],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            child: SvgPicture.asset(
                              ImageConstants.edit,
                              width: (18 / Dimensions.designWidth).w,
                              height: (18 / Dimensions.designWidth).w,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizeBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labels[27]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            profileMobileNumber ?? "",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(width: 20),
                          InkWell(
                            onTap: () async {
                              if (mobileChangesToday > 0) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.errorSuccessScreen,
                                  arguments: ErrorArgumentModel(
                                    hasSecondaryButton: false,
                                    iconPath: ImageConstants.errorOutlined,
                                    title: "Limit exceeded!",
                                    message:
                                        "Mobile number cannot be changed more than once a day",
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
                                bool isBioCapable = await LocalAuthentication()
                                    .canCheckBiometrics;
                                if (!isBioCapable) {
                                  // navigate to password screen
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.profileUpdatePassword,
                                      arguments:
                                          ProfileUpdatePasswordArgumentModel(
                                        isRetail: profileArgument.isRetail,
                                        isEmailChange: false,
                                        isMobileChange: true,
                                        isPasswordChange: false,
                                      ).toMap(),
                                    );
                                  }
                                } else {
                                  List availableBios =
                                      await LocalAuthentication()
                                          .getAvailableBiometrics();
                                  if (availableBios.isEmpty ||
                                      persistBiometric != true) {
                                    // navigate to password screen
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.profileUpdatePassword,
                                        arguments:
                                            ProfileUpdatePasswordArgumentModel(
                                          isRetail: profileArgument.isRetail,
                                          isEmailChange: false,
                                          isMobileChange: true,
                                          isPasswordChange: false,
                                        ).toMap(),
                                      );
                                    }
                                  } else {
                                    bool isAuthenticated = await BiometricHelper
                                        .authenticateUser();
                                    if (!isAuthenticated) {
                                      // navigate to password screen
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.profileUpdatePassword,
                                          arguments:
                                              ProfileUpdatePasswordArgumentModel(
                                            isRetail: profileArgument.isRetail,
                                            isEmailChange: false,
                                            isMobileChange: true,
                                            isPasswordChange: false,
                                          ).toMap(),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        if (profileArgument.isRetail) {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.verifyMobile,
                                            arguments:
                                                VerifyMobileArgumentModel(
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
                                              arguments:
                                                  VerifyMobileArgumentModel(
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
                                                  svgAssetPath:
                                                      ImageConstants.warning,
                                                  title: "No Permission",
                                                  message:
                                                      "You do not have permission to update your Mobile Number",
                                                  actionWidget: GradientButton(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    text: labels[346]
                                                        ["labelText"],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            child: SvgPicture.asset(
                              ImageConstants.edit,
                              width: (18 / Dimensions.designWidth).w,
                              height: (18 / Dimensions.designWidth).w,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizeBox(height: 20),
            Text(
              labels[28]["labelText"],
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all((15 / Dimensions.designWidth).w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: const Color(0XFFF8F8F8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labels[28]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 35.w,
                            child: Text(
                              profileAddress ?? "",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.primary,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizeBox(width: 20),
                          InkWell(
                            onTap: () {
                              if (profileArgument.isRetail) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.updateAddress,
                                  arguments: ProfileArgumentModel(
                                    isRetail: profileArgument.isRetail,
                                  ).toMap(),
                                );
                              } else {
                                if (canChangeAddress) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.updateAddress,
                                    arguments: ProfileArgumentModel(
                                      isRetail: profileArgument.isRetail,
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
                                            "You do not have permission to update your Address",
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
                            },
                            child: SvgPicture.asset(
                              ImageConstants.edit,
                              width: (18 / Dimensions.designWidth).w,
                              height: (18 / Dimensions.designWidth).w,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
