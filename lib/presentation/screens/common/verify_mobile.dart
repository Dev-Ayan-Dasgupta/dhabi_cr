// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/input_validator.dart';

class VerifyMobileScreen extends StatefulWidget {
  const VerifyMobileScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  late VerifyMobileArgumentModel verifyMobileArgumentModel;
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;

  bool isLoading = false;
  DropDownCountriesModel selectedCountry = DropDownCountriesModel(
    countryFlagBase64: dhabiCountryCodesWithFlags[uaeIndex].countryFlagBase64,
    countrynameOrCode: dhabiCountryCodesWithFlags[uaeIndex].countrynameOrCode,
    isEnabled: dhabiCountryCodesWithFlags[uaeIndex].isEnabled,
  );
  String? selectedIsd = "+971";
  int toggles = 0;
  int dhabiCountryIndex = uaeIndex;

  Color borderColor = const Color(0xFFEEEEEE);

  @override
  void initState() {
    super.initState();
    verifyMobileArgumentModel =
        VerifyMobileArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ternary(
                    condition: verifyMobileArgumentModel.isUpdate,
                    truthy: Text(
                      labels[30]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    falsy: Text(
                      labels[227]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                  ),
                  const SizeBox(height: 20),
                  Ternary(
                    condition: verifyMobileArgumentModel.isUpdate,
                    truthy: Text(
                      "To update your mobile number, please fill out the form below.",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    falsy: Text(
                      "We will send the OTP to your registered mobile number",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ),
                  const SizeBox(height: 22),
                  Row(
                    children: [
                      Ternary(
                        condition: verifyMobileArgumentModel.isUpdate,
                        truthy: Text(
                          "New Mobile Number",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        falsy: Text(
                          labels[27]["labelText"],
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 9),
                  // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  //   builder: (context, state) {
                  //     return
                  CustomTextField(
                    borderColor: borderColor,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    prefixIcon: BlocBuilder<DropdownSelectedBloc,
                        DropdownSelectedState>(
                      builder: (context, state) {
                        return CustomDropdownIsds(
                          title: "Select a country",
                          items: dhabiCountryCodesWithFlags,
                          value: selectedCountry,
                          onChanged: (value) {
                            final DropdownSelectedBloc residenceSelectedBloc =
                                context.read<DropdownSelectedBloc>();
                            toggles++;

                            selectedCountry = value as DropDownCountriesModel;
                            selectedIsd = selectedCountry.countrynameOrCode;
                            for (int i = 0; i < dhabiCountries.length; i++) {
                              if (selectedIsd ==
                                  "+${dhabiCountries[i]["dialCode"]}") {
                                dhabiCountryIndex = i;
                                break;
                              }
                            }

                            residenceSelectedBloc.add(
                              DropdownSelectedEvent(
                                isDropdownSelected: true,
                                toggles: toggles,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    suffixIcon: BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: buildCheckCircle,
                    ),
                    onChanged: checkPhoneNumber,
                  ),
                  //   },
                  // ),
                  const SizeBox(height: 9),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildErrorMessage,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildSubmitButton,
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildCheckCircle(BuildContext context, ShowButtonState state) {
    if (!_isPhoneValid) {
      return const SizedBox();
    } else {
      return Padding(
        padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
        child: SvgPicture.asset(
          ImageConstants.checkCircle,
          width: (20 / Dimensions.designWidth).w,
          height: (20 / Dimensions.designWidth).w,
        ),
      );
    }
  }

  void checkPhoneNumber(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    _isPhoneValid = InputValidator.isPhoneValid("+971$p0");
    showButtonBloc.add(ShowButtonEvent(show: _isPhoneValid || p0.length <= 9));
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)([0-9]*)))$');
    if (!(numericRegex.hasMatch(_phoneController.text))) {
      borderColor = AppColors.red100;
      showButtonBloc.add(const ShowButtonEvent(show: true));
      return Row(
        children: [
          SvgPicture.asset(ImageConstants.errorSolid),
          const SizeBox(width: 5),
          Text(
            "Invalid mobile number",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red100,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    } else {
      if (_isPhoneValid || _phoneController.text.length <= 9) {
        borderColor = const Color(0XFFEEEEEE);
        showButtonBloc.add(const ShowButtonEvent(show: true));
        return const SizeBox();
      } else {
        borderColor = AppColors.red100;
        showButtonBloc.add(const ShowButtonEvent(show: true));
        return Row(
          children: [
            SvgPicture.asset(ImageConstants.errorSolid),
            const SizeBox(width: 5),
            Text(
              "Invalid mobile number",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.red100,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
          ],
        );
      }
    }
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (!_isPhoneValid) {
      return SolidButton(
        onTap: () {},
        text: labels[31]["labelText"],
      );
    } else {
      return GradientButton(
        onTap: () async {
          log("dhabiCountryIndex -> $dhabiCountryIndex");
          if (!(dhabiCountries[dhabiCountryIndex]["isEnabled"])
              // dhabiCountryIndex != uaeIndex
              ) {
            Navigator.pushNamed(
              context,
              Routes.notAvailable,
              arguments: NotAvailableArgumentModel(
                country: dhabiCountries[dhabiCountryIndex]["countryName"],
              ).toMap(),
            );
          } else {
            if (verifyMobileArgumentModel.isUpdate) {
              if ("$selectedIsd${_phoneController.text}" ==
                  storageMobileNumber) {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      svgAssetPath: ImageConstants.warning,
                      title: "Error",
                      message:
                          "You cannot enter your current mobile number for update.",
                      actionWidget: GradientButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: "Okay",
                      ),
                    );
                  },
                );
              } else {
                if (!isLoading) {
                  isLoading = true;
                  final ShowButtonBloc showButtonBloc =
                      context.read<ShowButtonBloc>();
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));

                  var result = await MapSendMobileOtp.mapSendMobileOtp(
                    {
                      "mobileNo": "$selectedIsd${_phoneController.text}",
                    },
                    token ?? "",
                  );
                  log("Send Mobile OTP API response -> $result");

                  if (result["success"]) {
                    if (!(verifyMobileArgumentModel.isUpdate)) {
                      await storage.write(
                        key: "mobileNumber",
                        value: "$selectedIsd${_phoneController.text}",
                      );
                      storageMobileNumber =
                          await storage.read(key: "mobileNumber");
                    }

                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        Routes.otp,
                        arguments: OTPArgumentModel(
                          isReferral: false,
                          emailOrPhone: "$selectedIsd${_phoneController.text}",
                          isEmail: false,
                          isBusiness: verifyMobileArgumentModel.isBusiness,
                          isInitial: true,
                          isLogin: false,
                          isEmailIdUpdate: false,
                          isMobileUpdate: verifyMobileArgumentModel.isUpdate,
                          isReKyc: verifyMobileArgumentModel.isReKyc,
                          userTypeId: storageUserTypeId ?? 1,
                          companyId: storageCompanyId ?? 0,
                        ).toMap(),
                      );
                    }

                    isLoading = false;
                    showButtonBloc.add(ShowButtonEvent(show: isLoading));
                  } else {
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
                      isLoading = false;
                      showButtonBloc.add(ShowButtonEvent(show: isLoading));
                    }
                  }
                }
              }
            } else {
              if (!isLoading) {
                isLoading = true;
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                showButtonBloc.add(ShowButtonEvent(show: isLoading));

                var result = await MapSendMobileOtp.mapSendMobileOtp(
                  {
                    "mobileNo": "$selectedIsd${_phoneController.text}",
                  },
                  token ?? "",
                );
                log("Send Mobile OTP API response -> $result");

                if (result["success"]) {
                  if (!(verifyMobileArgumentModel.isUpdate)) {
                    await storage.write(
                      key: "mobileNumber",
                      value: "$selectedIsd${_phoneController.text}",
                    );
                    storageMobileNumber =
                        await storage.read(key: "mobileNumber");
                  }

                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      Routes.otp,
                      arguments: OTPArgumentModel(
                        isReferral: false,
                        emailOrPhone: "$selectedIsd${_phoneController.text}",
                        isEmail: false,
                        isBusiness: verifyMobileArgumentModel.isBusiness,
                        isInitial: true,
                        isLogin: false,
                        isEmailIdUpdate: false,
                        isMobileUpdate: verifyMobileArgumentModel.isUpdate,
                        isReKyc: verifyMobileArgumentModel.isReKyc,
                        userTypeId: storageUserTypeId ?? 1,
                        companyId: storageCompanyId ?? 0,
                      ).toMap(),
                    );
                  }

                  isLoading = false;
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));
                } else {
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
                    isLoading = false;
                    showButtonBloc.add(ShowButtonEvent(show: isLoading));
                  }
                }
              }
            }
          }
        },
        text: labels[31]["labelText"],
        auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
