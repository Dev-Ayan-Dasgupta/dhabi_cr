// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/corporateAccounts/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/onboarding/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/application/progress.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class ApplicationAccountScreen extends StatefulWidget {
  const ApplicationAccountScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ApplicationAccountScreen> createState() =>
      _ApplicationAccountScreenState();
}

class _ApplicationAccountScreenState extends State<ApplicationAccountScreen> {
  int progress = 4;
  bool isCurrentSelected = true;
  bool isSavingsSelected = false;

  bool isUploading = false;

  late ApplicationAccountArgumentModel applicationAccountArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    applicationAccountArgument = ApplicationAccountArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
    log("isRetail -> ${applicationAccountArgument.isRetail}");
    log("applicationAccountArgument.savingsAccountsCreated -> ${applicationAccountArgument.savingsAccountsCreated}");
    log("applicationAccountArgument.currentAccountsCreated -> ${applicationAccountArgument.currentAccountsCreated}");
    await storage.write(key: "accountType", value: "2");
    storageAccountType =
        int.parse(await storage.read(key: "accountType") ?? "2");
    log("storageAccountType -> $storageAccountType");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (applicationAccountArgument.isInitial) {
          Navigator.pushNamed(
            context,
            Routes.applicationTaxCRS,
            arguments: TaxCrsArgumentModel(
              isUSFATCA: storageIsUSFATCA ?? true,
              ustin: storageUsTin ?? "",
            ).toMap(),
          );
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              if (applicationAccountArgument.isInitial) {
                Navigator.pushNamed(
                  context,
                  Routes.applicationTaxCRS,
                  arguments: TaxCrsArgumentModel(
                    isUSFATCA: storageIsUSFATCA ?? true,
                    ustin: storageUsTin ?? "",
                  ).toMap(),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
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
                      condition: applicationAccountArgument.isInitial,
                      truthy: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[261]["labelText"],
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.primary,
                              fontSize: (28 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 30),
                          ApplicationProgress(progress: progress),
                          const SizeBox(height: 30),
                          Text(
                            labels[195]["labelText"],
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 20),
                        ],
                      ),
                      falsy: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select your acount type",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.primary,
                              fontSize: (28 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(height: 30),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          applicationAccountArgument.isInitial
                              ? labels[285]["labelText"]
                              : "Select Account",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 20),
                    BlocBuilder<MultiSelectBloc, MultiSelectState>(
                      builder: buildCurrentButton,
                    ),
                    const SizeBox(height: 15),
                    applicationAccountArgument.isInitial
                        ? const SizeBox()
                        : BlocBuilder<MultiSelectBloc, MultiSelectState>(
                            builder: buildSavingsButton,
                          ),
                    SizeBox(
                        height: applicationAccountArgument.isInitial ? 0 : 20),
                    Row(
                      children: [
                        Icon(
                          Icons.error_rounded,
                          color: AppColors.dark50,
                          size: (13 / Dimensions.designWidth).w,
                        ),
                        const SizeBox(width: 5),
                        Text(
                          labels[286]["labelText"],
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark50,
                            fontSize: (12 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: buildSubmitButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCurrentButton(BuildContext context, MultiSelectState state) {
    final MultiSelectBloc multiSelectBloc = context.read<MultiSelectBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return Ternary(
      condition: canCreateCurrentAccount,
      truthy: MultiSelectButton(
        isSelected: isCurrentSelected,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labels[7]["labelText"],
              style: TextStyles.primary.copyWith(
                color: AppColors.primaryDark,
                fontSize: (18 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 7),
            Text(
              "For everyday banking transactions.",
              style: TextStyles.primary.copyWith(
                color: const Color.fromRGBO(1, 1, 1, 0.4),
                fontSize: (14 / Dimensions.designWidth).w,
              ),
            ),
          ],
        ),
        onTap: () async {
          isCurrentSelected = !isCurrentSelected;
          accountType = isSavingsSelected
              ? isCurrentSelected
                  ? 3
                  : 1
              : isCurrentSelected
                  ? 2
                  : 0;
          log("accountType -> $accountType");
          await storage.write(
              key: "accountType", value: accountType.toString());
          storageAccountType =
              int.parse(await storage.read(key: "accountType") ?? "1");
          log("storageAccountType -> $storageAccountType");
          multiSelectBloc.add(MultiSelectEvent(isSelected: isCurrentSelected));
          showButtonBloc.add(
              ShowButtonEvent(show: isCurrentSelected && isSavingsSelected));
        },
      ),
      falsy: const SizeBox(),
    );
  }

  Widget buildSavingsButton(BuildContext context, MultiSelectState state) {
    final MultiSelectBloc multiSelectBloc = context.read<MultiSelectBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return Ternary(
      condition: canCreateSavingsAccount,
      truthy: MultiSelectButton(
        isSelected: isSavingsSelected,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labels[92]["labelText"],
              style: TextStyles.primary.copyWith(
                color: AppColors.primaryDark,
                fontSize: (18 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 7),
            Text(
              "An interest-bearing deposit account.",
              style: TextStyles.primary.copyWith(
                color: const Color.fromRGBO(1, 1, 1, 0.4),
                fontSize: (14 / Dimensions.designWidth).w,
              ),
            ),
          ],
        ),
        onTap: () async {
          isSavingsSelected = !isSavingsSelected;
          accountType = isCurrentSelected
              ? isSavingsSelected
                  ? 3
                  : 2
              : isSavingsSelected
                  ? 1
                  : 0;
          log("accountType -> $accountType");
          await storage.write(
              key: "accountType", value: accountType.toString());
          storageAccountType =
              int.parse(await storage.read(key: "accountType") ?? "1");
          log("storageAccountType -> $storageAccountType");
          multiSelectBloc.add(MultiSelectEvent(isSelected: isSavingsSelected));
          showButtonBloc.add(
              ShowButtonEvent(show: isCurrentSelected && isSavingsSelected));
        },
      ),
      falsy: const SizeBox(),
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isCurrentSelected || isSavingsSelected) {
      return Column(
        children: [
          // Text(
          //   "You will be receiving a free Prepaid Card! Available in the \"Cards\" tab.",
          //   style: TextStyles.primary.copyWith(
          //     color: const Color(0XFF252525),
          //     fontSize: (12 / Dimensions.designWidth).w,
          //   ),
          // ),
          // const SizeBox(height: 10),
          GradientButton(
            onTap: () async {
              if (applicationAccountArgument.isInitial) {
                if (!isUploading) {
                  final ShowButtonBloc showButtonBloc =
                      context.read<ShowButtonBloc>();
                  isUploading = true;
                  showButtonBloc.add(ShowButtonEvent(show: isUploading));

                  log("Register customer address api request -> ${{
                    "addressLine_1": storageAddressLine1,
                    "addressLine_2": storageAddressLine2,
                    "areaId":
                        uaeDetails[emirates.indexOf(storageAddressEmirate!)]
                            ["areas"][0]["area_Id"],
                    "cityId":
                        uaeDetails[emirates.indexOf(storageAddressEmirate!)]
                            ["city_Id"],
                    "city": storageAddressCity,
                    "state": storageAddressState,
                    "stateId": 1,
                    "countryId": 1,
                    "pinCode": storageAddressPoBox
                  }}");
                  var addressApiResult = await MapRegisterRetailCustomerAddress
                      .mapRegisterRetailCustomerAddress(
                    {
                      "addressLine_1": storageAddressLine1,
                      "addressLine_2": storageAddressLine2,
                      "areaId":
                          uaeDetails[emirates.indexOf(storageAddressEmirate!)]
                              ["areas"][0]["area_Id"],
                      "cityId":
                          uaeDetails[emirates.indexOf(storageAddressEmirate!)]
                              ["city_Id"],
                      "city": storageAddressCity,
                      "state": storageAddressState,
                      "stateId": 1,
                      "countryId": 1,
                      "pinCode": storageAddressPoBox
                    },
                    token ?? "",
                  );
                  log("RegisterRetailCustomerAddress API Response -> $addressApiResult");

                  if (addressApiResult["success"]) {
                    var incomeApiResult = await MapAddOrUpdateIncomeSource
                        .mapAddOrUpdateIncomeSource(
                      {"incomeSource": storageIncomeSource},
                      token ?? "",
                    );
                    log("Income Source API response -> $incomeApiResult");

                    if (incomeApiResult["success"]) {
                      var taxApiResult = await MapCustomerTaxInformation
                          .mapCustomerTaxInformation(
                        {
                          "isUSFATCA": storageIsUSFATCA,
                          "ustin": storageUsTin,
                          "internationalTaxes": storageInternationalTaxes
                        },
                        token ?? "",
                      );
                      log("Tax Information API response -> $taxApiResult");
                      if (taxApiResult["success"]) {
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.retailOnboardingStatus,
                            arguments: OnboardingStatusArgumentModel(
                              stepsCompleted: 3,
                              isFatca: false,
                              isPassport: false,
                              isRetail: true,
                            ).toMap(),
                          );
                        }
                        await storage.write(key: "accountType", value: "2");
                        storageAccountType = int.parse(
                            await storage.read(key: "accountType") ?? "1");

                        await storage.write(
                            key: "stepsCompleted", value: 9.toString());
                        storageStepsCompleted = int.parse(
                            await storage.read(key: "stepsCompleted") ?? "0");
                      } else {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                svgAssetPath: ImageConstants.warning,
                                title: "Error",
                                message: taxApiResult["message"],
                                actionWidget: GradientButton(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.applicationTaxCRS,
                                      arguments: TaxCrsArgumentModel(
                                        isUSFATCA: storageIsUSFATCA ?? true,
                                        ustin: storageUsTin ?? "",
                                      ).toMap(),
                                    );
                                  },
                                  text: labels[347]["labelText"],
                                ),
                              );
                            },
                          );
                        }
                        await storage.write(
                            key: "stepsCompleted", value: 7.toString());
                        storageStepsCompleted = int.parse(
                            await storage.read(key: "stepsCompleted") ?? "0");
                      }
                    } else {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.warning,
                              title: "Error",
                              message: incomeApiResult["message"],
                              actionWidget: GradientButton(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.applicationAddress,
                                  );
                                },
                                text: labels[347]["labelText"],
                              ),
                            );
                          },
                        );
                      }
                      await storage.write(
                          key: "stepsCompleted", value: 5.toString());
                      storageStepsCompleted = int.parse(
                          await storage.read(key: "stepsCompleted") ?? "0");
                    }
                  } else {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "Error",
                            message: addressApiResult["message"],
                            actionWidget: GradientButton(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.retailOnboardingStatus,
                                  arguments: OnboardingStatusArgumentModel(
                                    stepsCompleted: 2,
                                    isFatca: false,
                                    isPassport: false,
                                    isRetail: true,
                                  ).toMap(),
                                );
                              },
                              text: labels[347]["labelText"],
                            ),
                          );
                        },
                      );
                    }
                    await storage.write(
                        key: "stepsCompleted", value: 4.toString());
                    storageStepsCompleted = int.parse(
                        await storage.read(key: "stepsCompleted") ?? "0");
                  }

                  isUploading = false;
                  showButtonBloc.add(ShowButtonEvent(show: isUploading));
                }
              } else {
                if (!isUploading) {
                  if (accountType == 1) {
                    if (applicationAccountArgument.savingsAccountsCreated >=
                        maxSavingAccountAllowed) {
                      if (context.mounted) {
                        promptMaxLimit();
                      }
                    } else {
                      if (context.mounted) {
                        callCreateAccountApi();
                      }
                    }
                  } else if (accountType == 2) {
                    if (applicationAccountArgument.currentAccountsCreated >=
                        maxCurrentAccountAllowed) {
                      if (context.mounted) {
                        promptMaxLimit();
                      }
                    } else {
                      if (context.mounted) {
                        callCreateAccountApi();
                      }
                    }
                  } else {
                    if (applicationAccountArgument.savingsAccountsCreated >=
                            maxSavingAccountAllowed ||
                        applicationAccountArgument.currentAccountsCreated >=
                            maxCurrentAccountAllowed) {
                      if (context.mounted) {
                        promptMaxLimit();
                      }
                    } else {
                      if (context.mounted) {
                        callCreateAccountApi();
                      }
                    }
                  }
                }
              }
            },
            text: applicationAccountArgument.isInitial
                ? labels[288]["labelText"]
                : "Add Account",
            auxWidget: isUploading ? const LoaderRow() : const SizeBox(),
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
            text: applicationAccountArgument.isInitial
                ? labels[288]["labelText"]
                : "Add Account",
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.paddingOf(context).bottom,
          ),
        ],
      );
    }
  }

  void promptMaxLimit() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Oops",
          message:
              "It seems like you have exceeded number of allowed CA or SA.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              // Navigator.pop(context);
            },
            text: "Close",
          ),
        );
      },
    );
  }

  void callCreateAccountApi() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isUploading = true;
    showButtonBloc.add(ShowButtonEvent(show: isUploading));

    if (applicationAccountArgument.isRetail) {
      log("Create Account Request -> ${{
        "accountType": storageAccountType,
        "IsFirstAccount": false,
      }}");
      var responseAccount = await MapCreateAccount.mapCreateAccount(
        {
          "accountType": storageAccountType,
          "IsFirstAccount": false,
        },
      );
      log("Create Account API response -> $responseAccount");
      if (responseAccount["success"]) {
        if (context.mounted) {
          promptAccountCreated();
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error",
                message: responseAccount["message"] ??
                    "Error in creating account for retail",
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
      }
    } else {
      log("Create Account Corporate Request -> ${{
        "accountType": storageAccountType,
        // "IsFirstAccount": false,
      }}");
      var responseAccount =
          await MapCreateAccountCorporate.mapCreateAccountCorporate(
        {
          "accountType": storageAccountType,
          // "IsFirstAccount": false,
        },
        token ?? "",
      );
      log("Create Account Corporate API response -> $responseAccount");
      if (responseAccount["success"]) {
        if (!(responseAccount["isDirectlyCreated"])) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.checkCircleOutlined,
                  title: "Account Open Request Placed",
                  message:
                      "${messages[121]["messageText"]}: ${responseAccount["reference"]}",
                  actionWidget: GradientButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // Navigator.pushReplacementNamed(
                      //   context,
                      //   Routes.businessDashboard,
                      //   arguments: RetailDashboardArgumentModel(
                      //     imgUrl: storageProfilePhotoBase64 ?? "",
                      //     name: profileName ?? "",
                      //     isFirst: storageIsFirstLogin == true ? false : true,
                      //   ).toMap(),
                      // );
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.onboarding,
                        arguments:
                            OnboardingArgumentModel(isInitial: true).toMap(),
                      );
                    },
                    text: labels[346]["labelText"],
                  ),
                );
              },
            );
          }
        } else {
          if (context.mounted) {
            promptAccountCreated();
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
                message: responseAccount["message"] ??
                    "Error in creating account for corporate",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.onboarding,
                      arguments:
                          OnboardingArgumentModel(isInitial: true).toMap(),
                    );
                  },
                  text: "Go Home",
                ),
              );
            },
          );
        }
      }
    }

    isUploading = false;
    showButtonBloc.add(ShowButtonEvent(show: isUploading));
  }

  void promptAccountCreated() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.checkCircleOutlined,
          title: "Account Opened",
          message:
              "Congratulations! Your account(s) has been created successfully.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              if (applicationAccountArgument.isRetail) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.retailDashboard,
                  arguments: RetailDashboardArgumentModel(
                    imgUrl: "",
                    name: storageCustomerName ?? "",
                    isFirst: false,
                  ).toMap(),
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.businessDashboard,
                  arguments: RetailDashboardArgumentModel(
                    imgUrl: storageProfilePhotoBase64 ?? "",
                    name: profileName ?? "",
                    isFirst: storageIsFirstLogin == true ? false : true,
                  ).toMap(),
                );
              }
            },
            text: labels[346]["labelText"],
          ),
        );
      },
    );
  }
}
