// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SelectAccountScreen extends StatefulWidget {
  const SelectAccountScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SelectAccountScreen> createState() => _SelectAccountScreenState();
}

class _SelectAccountScreenState extends State<SelectAccountScreen> {
  late SelectAccountArgumentModel selectAccountArgument;

  // bool isLoading = false;
  bool isSelected = false;

  int selectedIndex = -1;

  int companyId = 0;
  int userTypeId = 0;

  @override
  void initState() {
    super.initState();
    selectAccountArgument =
        SelectAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
              "Select an entity",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Please select the entity you want to login to",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.grey40,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: selectAccountArgument.cifDetails.length,
                itemBuilder: (context, index) {
                  return Ternary(
                    condition: selectAccountArgument.isSwitching
                        ? selectAccountArgument.cifDetails[index]["cif"] ==
                            storageCif
                        : 1 == 2,
                    truthy: const SizeBox(),
                    falsy: Column(
                      children: [
                        BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          builder: (context, state) {
                            return SolidButton(
                              borderColor: selectedIndex == index
                                  ? const Color.fromRGBO(0, 184, 148, 0.21)
                                  : Colors.transparent,
                              onTap: () async {
                                isSelected = true;
                                selectedIndex = index;
                                final ShowButtonBloc showButtonBloc =
                                    context.read<ShowButtonBloc>();
                                showButtonBloc
                                    .add(ShowButtonEvent(show: isSelected));

                                if (!(selectAccountArgument.isLogin)) {
                                  cif = selectAccountArgument.cifDetails[index]
                                      ["cif"];
                                  log("cif -> $cif");
                                  log("cif RTT -> ${cif.runtimeType}");

                                  await storage.write(key: "cif", value: cif);
                                  storageCif = await storage.read(key: "cif");
                                  log("storageCif -> $storageCif");
                                }

                                isCompany = selectAccountArgument
                                    .cifDetails[index]["isCompany"];
                                log("isCompany -> $isCompany");

                                companyId = selectAccountArgument
                                    .cifDetails[index]["companyId"];
                                log("companyId -> $companyId");

                                // if (isCompany) {
                                //   companyId = selectAccountArgument
                                //       .cifDetails[index]["companyId"];

                                //   await storage.write(
                                //       key: "companyId",
                                //       value: companyId.toString());
                                //   storageCompanyId = int.parse(
                                //       await storage.read(key: "companyId") ??
                                //           "");
                                //   log("storageCompanyId -> $storageCompanyId");
                                // }

                                isCompanyRegistered = selectAccountArgument
                                    .cifDetails[index]["isCompanyRegistered"];
                                log("isCompanyRegistered -> $isCompanyRegistered");

                                log("isLogin -> ${selectAccountArgument.isLogin}");
                                log("isPwChange -> ${selectAccountArgument.isPwChange}");

                                if (selectAccountArgument.cifDetails[index]
                                            ["isCompanyRegistered"] ==
                                        false &&
                                    selectAccountArgument.cifDetails[index]
                                            ["isCompany"] ==
                                        true) {
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
                                          actionWidget: GradientButton(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            text: labels[347]["labelText"],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  if (selectAccountArgument.isPwChange) {
                                    var isDeviceValidApiResult =
                                        await MapIsDeviceValid.mapIsDeviceValid(
                                            {
                                          "userId": selectAccountArgument
                                              .cifDetails[index]["userID"],
                                          "deviceId": storageDeviceId,
                                        },
                                            tokenCP ?? "");
                                    log("isDeviceValidApiResult -> $isDeviceValidApiResult");
                                    if (isDeviceValidApiResult["success"]) {
                                      if (!isCompany || isCompanyRegistered) {
                                        // await storage.write(
                                        //     key: "companyId",
                                        //     value: companyId.toString());
                                        // storageCompanyId = int.parse(
                                        //     await storage.read(
                                        //             key: "companyId") ??
                                        //         "");
                                        // log("storageCompanyId -> $storageCompanyId");
                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.setPassword,
                                            arguments: SetPasswordArgumentModel(
                                              fromTempPassword: false,
                                              userTypeId:
                                                  companyId == 0 ? 1 : 2,
                                              companyId: companyId,
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
                                                svgAssetPath:
                                                    ImageConstants.warning,
                                                title:
                                                    "Application approval pending",
                                                message:
                                                    "You already have a registration pending. Please contact Dhabi support.",
                                                actionWidget: GradientButton(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  text: labels[347]
                                                      ["labelText"],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    } else {
                                      var rmorResult =
                                          await MapRegisteredMobileOtpRequest
                                              .mapRegisteredMobileOtpRequest(
                                        {
                                          "emailId": storageEmail,
                                          "cif": cif,
                                        },
                                        tokenCP ?? "",
                                      );
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
                                              userTypeId:
                                                  companyId == 0 ? 1 : 2,
                                              companyId: companyId,
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
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      context,
                                                      Routes.onboarding,
                                                      arguments:
                                                          OnboardingArgumentModel(
                                                                  isInitial:
                                                                      true)
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
                                      //         svgAssetPath:
                                      //             ImageConstants.warning,
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
                                  } else {
                                    if (selectAccountArgument.isLogin) {
                                      userTypeId = selectAccountArgument
                                                      .cifDetails[index]
                                                  ["companyId"] ==
                                              0
                                          ? 1
                                          : 2;

                                      if (!(selectAccountArgument
                                          .isSwitching)) {
                                        await storage.write(
                                            key: "userTypeId",
                                            value: userTypeId.toString());
                                        storageUserTypeId = int.parse(
                                            await storage.read(
                                                    key: "userTypeId") ??
                                                "");
                                        log("storageUserTypeId -> $storageUserTypeId");
                                      }

                                      companyId = selectAccountArgument
                                          .cifDetails[index]["companyId"];

                                      await storage.write(
                                          key: "companyId",
                                          value: companyId.toString());
                                      storageCompanyId = int.parse(await storage
                                              .read(key: "companyId") ??
                                          "");
                                      log("storageCompanyId -> $storageCompanyId");

                                      log("userTypeId -> $userTypeId");
                                      log("companyId -> $companyId");

                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.loginPassword,
                                          arguments: LoginPasswordArgumentModel(
                                            emailId:
                                                selectAccountArgument.emailId,
                                            userId: 0,
                                            userTypeId: userTypeId,
                                            companyId: companyId,
                                            isSwitching: selectAccountArgument
                                                .isSwitching,
                                          ).toMap(),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                            context, Routes.loginUserId);
                                      }
                                    }
                                  }
                                }
                              },
                              text: selectAccountArgument.cifDetails[index]
                                      ["companyName"] ??
                                  "Personal Account",
                              subtitle: (selectAccountArgument.cifDetails[index]
                                              ["isCompanyRegistered"] ==
                                          false &&
                                      selectAccountArgument.cifDetails[index]
                                              ["isCompany"] ==
                                          true)
                                  ? "Request Pending"
                                  : null,
                              color: Colors.white,
                              boxShadow: [BoxShadows.primary],
                              fontColor: AppColors.primary,
                            );
                          },
                        ),
                        const SizeBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
