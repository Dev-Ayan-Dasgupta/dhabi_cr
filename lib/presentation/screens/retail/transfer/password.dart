// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/corporateAccounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/screens/business/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/transfer/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/createPassword/create_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/createPassword/create_password_event.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_bloc.dart';
import 'package:dialup_mobile_app/bloc/criteria/criteria_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_bloc.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/bloc/showPassword/show_password_states.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool showPassword = false;
  final TextEditingController _passwordController = TextEditingController();
  int toggle = 0;
  bool hasMin8 = false;
  bool hasNumeric = false;
  bool hasUpperLower = false;
  bool hasSpecial = false;
  bool allTrue = false;

  bool isTransferring = false;

  String addBenError = "";

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
                    "Enter your login password to complete the transaction",
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
                            if (!isTransferring) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              isTransferring = true;
                              showButtonBloc
                                  .add(ShowButtonEvent(show: isTransferring));
                              if (sendMoneyArgument.isRetail) {
                                if (sendMoneyArgument.isRemittance) {
                                  log("makeIntFundTransferApi Req -> ${{
                                    "beneficiaryId": benId,
                                    "quotationId": quotationId.isEmpty
                                        ? "1234"
                                        : quotationId,
                                    "debitAccount": senderAccountNumber,
                                    "transferAmount": receiverAmount,
                                    "debitAmount": senderAmount,
                                    "remittancePurpose":
                                        ValueToKey.mapPurposeCodeValueToKey(
                                            chosenPurposeCode),
                                    "fees": fees.toString(),
                                    "chargesCode": chosenChargeCode,
                                    "uniqueId":
                                        DateTime.now().millisecondsSinceEpoch,
                                    "hash": EncryptDecrypt.encrypt(
                                        "${DateTime.now().millisecondsSinceEpoch}"),
                                    "isSwiftTransfer":
                                        isTerraPaySupported ? false : true,
                                  }}");
                                  var makeIntFundTransferApiRes =
                                      await MapInternationalMoneyTransferv2
                                          .mapInternationalMoneyTransferv2(
                                    {
                                      "beneficiaryId": benId,
                                      "quotationId": quotationId.isEmpty
                                          ? "1234"
                                          : quotationId,
                                      "debitAccount": senderAccountNumber,
                                      "transferAmount": receiverAmount,
                                      "debitAmount": senderAmount,
                                      "remittancePurpose":
                                          ValueToKey.mapPurposeCodeValueToKey(
                                              chosenPurposeCode),
                                      "fees": fees.toString(),
                                      "chargesCode": chosenChargeCode,
                                      "uniqueId":
                                          DateTime.now().millisecondsSinceEpoch,
                                      "hash": EncryptDecrypt.encrypt(
                                          "${DateTime.now().millisecondsSinceEpoch}"),
                                      "isSwiftTransfer":
                                          isTerraPaySupported ? false : true,
                                    },
                                    token ?? "",
                                  );
                                  log("makeIntFundTransferApiRes -> $makeIntFundTransferApiRes");
                                  if (makeIntFundTransferApiRes["success"]) {
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.errorSuccessScreen,
                                        arguments: ErrorArgumentModel(
                                          hasSecondaryButton: true,
                                          iconPath: ImageConstants
                                              .checkCircleOutlined,
                                          title: "Success!",
                                          message:
                                              "Your transaction has been completed\n\nTransfer reference: ${makeIntFundTransferApiRes["ftReferenceNumber"]}",
                                          buttonText:
                                              "Make Another Transaction",
                                          onTap: () async {
                                            var result =
                                                await MapCustomerAccountDetails
                                                    .mapCustomerAccountDetails(
                                              token ?? "",
                                            );
                                            if (context.mounted) {
                                              // Navigator.pop(context);
                                              // Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              accountDetails =
                                                  result["crCustomerProfileRes"]
                                                          ["body"]
                                                      ["accountDetails"];
                                              Navigator.pushNamed(
                                                context,
                                                Routes.sendMoneyFrom,
                                                arguments:
                                                    SendMoneyArgumentModel(
                                                  isBetweenAccounts:
                                                      sendMoneyArgument
                                                          .isBetweenAccounts,
                                                  isWithinDhabi:
                                                      sendMoneyArgument
                                                          .isWithinDhabi,
                                                  isRemittance:
                                                      sendMoneyArgument
                                                          .isRemittance,
                                                  isRetail: sendMoneyArgument
                                                      .isRetail,
                                                ).toMap(),
                                              );
                                            }
                                          },
                                          buttonTextSecondary: "Go Home",
                                          onTapSecondary: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.retailDashboard,
                                              (route) => false,
                                              arguments:
                                                  RetailDashboardArgumentModel(
                                                imgUrl: "",
                                                name: profileName ?? "",
                                                isFirst:
                                                    storageIsFirstLogin == true
                                                        ? false
                                                        : true,
                                              ).toMap(),
                                            );
                                          },
                                        ).toMap(),
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return CustomDialog(
                                            svgAssetPath:
                                                ImageConstants.warning,
                                            title: "Sorry",
                                            message: makeIntFundTransferApiRes[
                                                    "message"] ??
                                                "There was a problem with your money transfer, please try again later.",
                                            actionWidget: GradientButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              text: "Okay",
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }
                                } else {
                                  log("Internal Transfer Api request -> ${{
                                    "debitAccount": senderAccountNumber,
                                    "creditAccount": receiverAccountNumber,
                                    "debitAmount": senderAmount.toString(),
                                    "currency": senderCurrency,
                                    "beneficiaryName": benCustomerName,
                                    "uniqueId":
                                        DateTime.now().millisecondsSinceEpoch,
                                    "hash": EncryptDecrypt.encrypt(
                                        "${DateTime.now().millisecondsSinceEpoch}"),
                                  }}");
                                  var makeInternalTransferApiResult =
                                      await MapInternalMoneyTransfer
                                          .mapInternalMoneyTransfer(
                                    {
                                      "debitAccount": senderAccountNumber,
                                      "creditAccount": receiverAccountNumber,
                                      "debitAmount": senderAmount.toString(),
                                      "currency": senderCurrency,
                                      "beneficiaryName": benCustomerName,
                                      "uniqueId":
                                          DateTime.now().millisecondsSinceEpoch,
                                      "hash": EncryptDecrypt.encrypt(
                                          "${DateTime.now().millisecondsSinceEpoch}"),
                                    },
                                    token ?? "",
                                  );
                                  log("Make Internal Transfer Response -> $makeInternalTransferApiResult");
                                  if (makeInternalTransferApiResult[
                                      "success"]) {
                                    if (isAddWithinDhabiBeneficiary) {
                                      log("create beneficiary request -> ${{
                                        "beneficiaryType": 3,
                                        "accountNumber": !isWalletSelected ||
                                                benIdType == "2"
                                            ? receiverAccountNumber
                                            : walletNumber.isEmpty
                                                ? benMobileNo
                                                : walletNumber,
                                        "name": benCustomerName,
                                        "address": benAddress,
                                        "accountType": benAccountType,
                                        "swiftReference": 0,
                                        "targetCurrency": receiverCurrency,
                                        "countryCode": "AE",
                                        "benBankCode": benBankCode,
                                        "benMobileNo": benMobileNo,
                                        "benSubBankCode": benSubBankCode,
                                        "benIdType": benIdType,
                                        "benIdNo": benIdNo,
                                        "benIdExpiryDate": benIdExpiryDate,
                                        "benBankName": benBankName,
                                        "benSwiftCodeText": benSwiftCode,
                                        "city": benCity,
                                        "remittancePurpose":
                                            remittancePurpose ?? "",
                                        "sourceOfFunds": sourceOfFunds ?? "",
                                        "relation": relation ?? "",
                                        "providerName": providerName ?? "",
                                      }}");

                                      var createBeneficiaryAPiResult =
                                          await MapCreateBeneficiary
                                              .mapCreateBeneficiary(
                                        {
                                          "beneficiaryType": 3,
                                          "accountNumber": !isWalletSelected ||
                                                  benIdType == "2"
                                              ? receiverAccountNumber
                                              : walletNumber.isEmpty
                                                  ? benMobileNo
                                                  : walletNumber,
                                          "name": benCustomerName,
                                          "address": benAddress,
                                          "accountType": benAccountType,
                                          "swiftReference": 0,
                                          "targetCurrency": receiverCurrency,
                                          "countryCode": "AE",
                                          "benBankCode": benBankCode,
                                          "benMobileNo": benMobileNo,
                                          "benSubBankCode": benSubBankCode,
                                          "benIdType": benIdType,
                                          "benIdNo": benIdNo,
                                          "benIdExpiryDate": benIdExpiryDate,
                                          "benBankName": benBankName,
                                          "benSwiftCodeText": benSwiftCode,
                                          "city": benCity,
                                          "remittancePurpose":
                                              remittancePurpose ?? "",
                                          "sourceOfFunds": sourceOfFunds ?? "",
                                          "relation": relation ?? "",
                                          "providerName": providerName ?? "",
                                        },
                                        token ?? "",
                                      );

                                      log("createBeneficiaryAPiResult -> $createBeneficiaryAPiResult");

                                      if (createBeneficiaryAPiResult[
                                          "success"]) {
                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.errorSuccessScreen,
                                            arguments: ErrorArgumentModel(
                                              hasSecondaryButton: true,
                                              iconPath: ImageConstants
                                                  .checkCircleOutlined,
                                              title: "Success!",
                                              message:
                                                  "Your transaction has been completed\n\nTransfer reference: ${makeInternalTransferApiResult["ftReferenceNumber"]}",
                                              buttonTextSecondary: "Go Home",
                                              onTapSecondary: () {
                                                isAddWithinDhabiBeneficiary =
                                                    false;
                                                isNewWithinDhabiBeneficiary =
                                                    false;
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  Routes.retailDashboard,
                                                  (route) => false,
                                                  arguments:
                                                      RetailDashboardArgumentModel(
                                                    imgUrl: "",
                                                    name: profileName ?? "",
                                                    isFirst:
                                                        storageIsFirstLogin ==
                                                                true
                                                            ? false
                                                            : true,
                                                  ).toMap(),
                                                );
                                              },
                                              buttonText:
                                                  "Make Another Transaction",
                                              onTap: () async {
                                                var result =
                                                    await MapCustomerAccountDetails
                                                        .mapCustomerAccountDetails(
                                                            token ?? "");
                                                if (result["success"]) {
                                                  if (context.mounted) {
                                                    if (isNewWithinDhabiBeneficiary) {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    } else {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    }

                                                    accountDetails = result[
                                                            "crCustomerProfileRes"]
                                                        [
                                                        "body"]["accountDetails"];
                                                    Navigator.pushNamed(
                                                      context,
                                                      Routes.sendMoneyFrom,
                                                      arguments:
                                                          SendMoneyArgumentModel(
                                                        isBetweenAccounts:
                                                            sendMoneyArgument
                                                                .isBetweenAccounts,
                                                        isWithinDhabi:
                                                            sendMoneyArgument
                                                                .isWithinDhabi,
                                                        isRemittance:
                                                            sendMoneyArgument
                                                                .isRemittance,
                                                        isRetail:
                                                            sendMoneyArgument
                                                                .isRetail,
                                                      ).toMap(),
                                                    );
                                                    isAddWithinDhabiBeneficiary =
                                                        false;
                                                    isNewWithinDhabiBeneficiary =
                                                        false;
                                                  }
                                                } else {
                                                  if (context.mounted) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CustomDialog(
                                                          svgAssetPath:
                                                              ImageConstants
                                                                  .warning,
                                                          title: "Sorry!",
                                                          message: result[
                                                                  "message"] ??
                                                              "Something went wrong, please try again later 3",
                                                          actionWidget:
                                                              GradientButton(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            text: labels[346]
                                                                ["labelText"],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                }
                                              },
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
                                                title: "Sorry!",
                                                message: createBeneficiaryAPiResult[
                                                        "message"] ??
                                                    "Something went wrong while adding beneficiary, please try again later",
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
                                    } else {
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.errorSuccessScreen,
                                          arguments: ErrorArgumentModel(
                                            hasSecondaryButton: true,
                                            iconPath: ImageConstants
                                                .checkCircleOutlined,
                                            title: "Success!",
                                            message:
                                                "Your transaction has been completed\n\nTransfer reference: ${makeInternalTransferApiResult["ftReferenceNumber"]}",
                                            buttonTextSecondary: "Go Home",
                                            onTapSecondary: () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.retailDashboard,
                                                (route) => false,
                                                arguments:
                                                    RetailDashboardArgumentModel(
                                                  imgUrl: "",
                                                  name: profileName ?? "",
                                                  isFirst:
                                                      storageIsFirstLogin ==
                                                              true
                                                          ? false
                                                          : true,
                                                ).toMap(),
                                              );
                                            },
                                            buttonText:
                                                "Make Another Transaction",
                                            onTap: () async {
                                              var result =
                                                  await MapCustomerAccountDetails
                                                      .mapCustomerAccountDetails(
                                                          token ?? "");
                                              if (result["success"]) {
                                                if (context.mounted) {
                                                  if (isNewWithinDhabiBeneficiary) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  } else {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }

                                                  accountDetails = result[
                                                          "crCustomerProfileRes"]
                                                      [
                                                      "body"]["accountDetails"];
                                                  Navigator.pushNamed(
                                                    context,
                                                    Routes.sendMoneyFrom,
                                                    arguments:
                                                        SendMoneyArgumentModel(
                                                      isBetweenAccounts:
                                                          sendMoneyArgument
                                                              .isBetweenAccounts,
                                                      isWithinDhabi:
                                                          sendMoneyArgument
                                                              .isWithinDhabi,
                                                      isRemittance:
                                                          sendMoneyArgument
                                                              .isRemittance,
                                                      isRetail:
                                                          sendMoneyArgument
                                                              .isRetail,
                                                    ).toMap(),
                                                  );
                                                  isAddWithinDhabiBeneficiary =
                                                      false;
                                                  isNewWithinDhabiBeneficiary =
                                                      false;
                                                }
                                              } else {
                                                if (context.mounted) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CustomDialog(
                                                        svgAssetPath:
                                                            ImageConstants
                                                                .warning,
                                                        title: "Sorry!",
                                                        message: result[
                                                                "message"] ??
                                                            "Something went wrong, please try again later 4",
                                                        actionWidget:
                                                            GradientButton(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          text: labels[346]
                                                              ["labelText"],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                          ).toMap(),
                                        );
                                      }
                                    }
                                    isAddWithinDhabiBeneficiary = false;
                                    isNewWithinDhabiBeneficiary = false;
                                  } else {
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomDialog(
                                            svgAssetPath:
                                                ImageConstants.warning,
                                            title: "Sorry!",
                                            message: makeInternalTransferApiResult[
                                                    "message"] ??
                                                "Something went wrong while within Dhabi transfer, please try again later",
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
                                }
                              } else {
                                if (sendMoneyArgument.isRemittance) {
                                  log("makeIntFundTransferApi Req -> ${{
                                    "beneficiaryId": benId,
                                    "quotationId": quotationId.isEmpty
                                        ? "1234"
                                        : quotationId,
                                    "debitAccount": senderAccountNumber,
                                    "transferAmount": receiverAmount,
                                    "debitAmount": senderAmount,
                                    "remittancePurpose":
                                        ValueToKey.mapPurposeCodeValueToKey(
                                            chosenPurposeCode),
                                    "fees": fees.toString(),
                                    "chargesCode": chosenChargeCode,
                                    "uniqueId":
                                        DateTime.now().millisecondsSinceEpoch,
                                    "hash": EncryptDecrypt.encrypt(
                                        "${DateTime.now().millisecondsSinceEpoch}"),
                                    "isSwiftTransfer":
                                        isTerraPaySupported ? false : true,
                                  }}");
                                  var makeIntFundTransferApiRes =
                                      await MapInternationalMoneyTransferv2
                                          .mapInternationalMoneyTransferv2(
                                    {
                                      "beneficiaryId": benId,
                                      "quotationId": quotationId.isEmpty
                                          ? "1234"
                                          : quotationId,
                                      "debitAccount": senderAccountNumber,
                                      "transferAmount": receiverAmount,
                                      "debitAmount": senderAmount,
                                      "remittancePurpose":
                                          ValueToKey.mapPurposeCodeValueToKey(
                                              chosenPurposeCode),
                                      "fees": fees.toString(),
                                      "chargesCode": chosenChargeCode,
                                      "uniqueId":
                                          DateTime.now().millisecondsSinceEpoch,
                                      "hash": EncryptDecrypt.encrypt(
                                          "${DateTime.now().millisecondsSinceEpoch}"),
                                      "isSwiftTransfer":
                                          isTerraPaySupported ? false : true,
                                    },
                                    token ?? "",
                                  );
                                  log("makeIntFundTransferApiRes -> $makeIntFundTransferApiRes");
                                  if (makeIntFundTransferApiRes["success"]) {
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.errorSuccessScreen,
                                        arguments: ErrorArgumentModel(
                                          hasSecondaryButton: true,
                                          iconPath: ImageConstants
                                              .checkCircleOutlined,
                                          title: "Success!",
                                          message:
                                              "Your transaction has been completed\n\nTransfer reference: ${makeIntFundTransferApiRes["ftReferenceNumber"]}",
                                          buttonText:
                                              "Make Another Transaction",
                                          onTap: () async {
                                            var result =
                                                await MapCustomerAccountDetails
                                                    .mapCustomerAccountDetails(
                                              token ?? "",
                                            );
                                            if (context.mounted) {
                                              // Navigator.pop(context);
                                              // Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              accountDetails =
                                                  result["crCustomerProfileRes"]
                                                          ["body"]
                                                      ["accountDetails"];
                                              Navigator.pushNamed(
                                                context,
                                                Routes.sendMoneyFrom,
                                                arguments:
                                                    SendMoneyArgumentModel(
                                                  isBetweenAccounts:
                                                      sendMoneyArgument
                                                          .isBetweenAccounts,
                                                  isWithinDhabi:
                                                      sendMoneyArgument
                                                          .isWithinDhabi,
                                                  isRemittance:
                                                      sendMoneyArgument
                                                          .isRemittance,
                                                  isRetail: sendMoneyArgument
                                                      .isRetail,
                                                ).toMap(),
                                              );
                                            }
                                          },
                                          buttonTextSecondary: "Go Home",
                                          onTapSecondary: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.businessDashboard,
                                              (route) => false,
                                              arguments:
                                                  RetailDashboardArgumentModel(
                                                imgUrl: "",
                                                name: profileName ?? "",
                                                isFirst:
                                                    storageIsFirstLogin == true
                                                        ? false
                                                        : true,
                                              ).toMap(),
                                            );
                                          },
                                        ).toMap(),
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return CustomDialog(
                                            svgAssetPath:
                                                ImageConstants.warning,
                                            title: "Sorry",
                                            message: makeIntFundTransferApiRes[
                                                    "message"] ??
                                                "There was a problem with your money transfer, please try again later.",
                                            actionWidget: GradientButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              text: "Okay",
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }
                                } else {
                                  log("corpDhabiMoneyTransferApiResult Request -> ${{
                                    "debitAccount": senderAccountNumber,
                                    "creditAccount": receiverAccountNumber,
                                    "debitAmount": senderAmount.toString(),
                                    "currency": senderCurrency,
                                    "beneficiaryName": benCustomerName,
                                    "uniqueId":
                                        DateTime.now().millisecondsSinceEpoch,
                                    "hash": EncryptDecrypt.encrypt(
                                        "${DateTime.now().millisecondsSinceEpoch}"),
                                  }}");
                                  var corpDhabiMoneyTransferApiResult =
                                      await MapDhabiMoneyTransfer
                                          .mapDhabiMoneyTransfer(
                                    {
                                      "debitAccount": senderAccountNumber,
                                      "creditAccount": receiverAccountNumber,
                                      "debitAmount": senderAmount.toString(),
                                      "currency": senderCurrency,
                                      "beneficiaryName": benCustomerName,
                                      "uniqueId":
                                          DateTime.now().millisecondsSinceEpoch,
                                      "hash": EncryptDecrypt.encrypt(
                                          "${DateTime.now().millisecondsSinceEpoch}"),
                                    },
                                    token ?? "",
                                  );
                                  log("corpDomesticMoneyTransferApiResult -> $corpDhabiMoneyTransferApiResult");

                                  if (corpDhabiMoneyTransferApiResult[
                                      "success"]) {
                                    if (isAddWithinDhabiBeneficiary) {
                                      log("create beneficiary request -> ${{
                                        "beneficiaryType": 3,
                                        "accountNumber": !isWalletSelected ||
                                                benIdType == "2"
                                            ? receiverAccountNumber
                                            : walletNumber.isEmpty
                                                ? benMobileNo
                                                : walletNumber,
                                        "name": benCustomerName,
                                        "address": benAddress,
                                        "accountType": benAccountType,
                                        "swiftReference": 0,
                                        "targetCurrency": receiverCurrency,
                                        "countryCode": "AE",
                                        "benBankCode": benBankCode,
                                        "benMobileNo": benMobileNo,
                                        "benSubBankCode": benSubBankCode,
                                        "benIdType": benIdType,
                                        "benIdNo": benIdNo,
                                        "benIdExpiryDate": benIdExpiryDate,
                                        "benBankName": benBankName,
                                        "benSwiftCodeText": benSwiftCode,
                                        "city": benCity,
                                        "remittancePurpose":
                                            remittancePurpose ?? "",
                                        "sourceOfFunds": sourceOfFunds ?? "",
                                        "relation": relation ?? "",
                                        "providerName": providerName ?? "",
                                      }}");

                                      var createBeneficiaryAPiResult =
                                          await MapCreateBeneficiary
                                              .mapCreateBeneficiary(
                                        {
                                          "beneficiaryType": 3,
                                          "accountNumber": !isWalletSelected ||
                                                  benIdType == "2"
                                              ? receiverAccountNumber
                                              : walletNumber.isEmpty
                                                  ? benMobileNo
                                                  : walletNumber,
                                          "name": benCustomerName,
                                          "address": benAddress,
                                          "accountType": benAccountType,
                                          "swiftReference": 0,
                                          "targetCurrency": receiverCurrency,
                                          "countryCode": "AE",
                                          "benBankCode": benBankCode,
                                          "benMobileNo": benMobileNo,
                                          "benSubBankCode": benSubBankCode,
                                          "benIdType": benIdType,
                                          "benIdNo": benIdNo,
                                          "benIdExpiryDate": benIdExpiryDate,
                                          "benBankName": benBankName,
                                          "benSwiftCodeText": benSwiftCode,
                                          "city": benCity,
                                          "remittancePurpose":
                                              remittancePurpose ?? "",
                                          "sourceOfFunds": sourceOfFunds ?? "",
                                          "relation": relation ?? "",
                                          "providerName": providerName ?? "",
                                        },
                                        token ?? "",
                                      );

                                      log("createBeneficiaryAPiResult -> $createBeneficiaryAPiResult");

                                      if (createBeneficiaryAPiResult[
                                          "success"]) {
                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.errorSuccessScreen,
                                            arguments: ErrorArgumentModel(
                                              hasSecondaryButton: true,
                                              iconPath: ImageConstants
                                                  .checkCircleOutlined,
                                              title: corpDhabiMoneyTransferApiResult[
                                                      "isDirectlyCreated"]
                                                  ? "Success!"
                                                  : "Domestic Transfer Request Placed",
                                              message: corpDhabiMoneyTransferApiResult[
                                                      "isDirectlyCreated"]
                                                  ? "Your transaction has been completed\n\nTransfer reference: ${corpDhabiMoneyTransferApiResult["reference"]}"
                                                  : "${messages[121]["messageText"]}: ${corpDhabiMoneyTransferApiResult["reference"]}",
                                              buttonTextSecondary: "Go Home",
                                              onTapSecondary: () {
                                                isAddWithinDhabiBeneficiary =
                                                    false;
                                                isNewWithinDhabiBeneficiary =
                                                    false;
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  Routes.businessDashboard,
                                                  (route) => false,
                                                  arguments:
                                                      RetailDashboardArgumentModel(
                                                    imgUrl:
                                                        storageProfilePhotoBase64 ??
                                                            "",
                                                    name: profileName ?? "",
                                                    isFirst:
                                                        storageIsFirstLogin ==
                                                                true
                                                            ? false
                                                            : true,
                                                  ).toMap(),
                                                );
                                              },
                                              buttonText:
                                                  "Make Another Transaction",
                                              onTap: () async {
                                                var corpCustPermApiResult =
                                                    await MapCorporateCustomerPermissions
                                                        .mapCorporateCustomerPermissions(
                                                            token ?? "");
                                                if (corpCustPermApiResult[
                                                    "success"]) {
                                                  fdSeedAccounts.clear();
                                                  internalSeedAccounts.clear();
                                                  dhabiSeedAccounts.clear();
                                                  foreignSeedAccounts.clear();
                                                  for (var permission
                                                      in corpCustPermApiResult[
                                                          "permissions"]) {
                                                    if (permission[
                                                        "canCreateFD"]) {
                                                      fdSeedAccounts.add(
                                                        SeedAccount(
                                                          accountNumber:
                                                              permission[
                                                                  "accountNumber"],
                                                          threshold: permission[
                                                                  "fdCreationThreshold"]
                                                              .toDouble(),
                                                          currency: permission[
                                                              "currency"],
                                                          bal: double.parse(
                                                                  permission[
                                                                          "currentBalance"]
                                                                      .split(
                                                                          " ")
                                                                      .last
                                                                      .replaceAll(
                                                                          ',',
                                                                          ''))
                                                              .abs(),
                                                          accountType:
                                                              permission[
                                                                  "accountType"],
                                                          currencyFlag: permission[
                                                              "currencyFlagBase64"],
                                                        ),
                                                      );
                                                    }
                                                    if (permission[
                                                        "canTransferInternalFund"]) {
                                                      internalSeedAccounts.add(
                                                        SeedAccount(
                                                          accountNumber:
                                                              permission[
                                                                  "accountNumber"],
                                                          threshold: permission[
                                                                  "internalFundTransferThreshold"]
                                                              .toDouble(),
                                                          currency: permission[
                                                              "currency"],
                                                          bal: double.parse(
                                                              permission[
                                                                      "currentBalance"]
                                                                  .split(" ")
                                                                  .last
                                                                  .replaceAll(
                                                                      ',', '')),
                                                          accountType:
                                                              permission[
                                                                  "accountType"],
                                                          currencyFlag: permission[
                                                              "currencyFlagBase64"],
                                                        ),
                                                      );
                                                    }
                                                    if (permission[
                                                        "canTransferDhabiFund"]) {
                                                      dhabiSeedAccounts.add(
                                                        SeedAccount(
                                                          accountNumber:
                                                              permission[
                                                                  "accountNumber"],
                                                          threshold: permission[
                                                                  "dhabiFundTransferThreshold"]
                                                              .toDouble(),
                                                          currency: permission[
                                                              "currency"],
                                                          bal: double.parse(
                                                              permission[
                                                                      "currentBalance"]
                                                                  .split(" ")
                                                                  .last
                                                                  .replaceAll(
                                                                      ',', '')),
                                                          accountType:
                                                              permission[
                                                                  "accountType"],
                                                          currencyFlag: permission[
                                                              "currencyFlagBase64"],
                                                        ),
                                                      );
                                                    }
                                                    if (permission[
                                                        "canTransferInternationalFund"]) {
                                                      foreignSeedAccounts.add(
                                                        SeedAccount(
                                                          accountNumber:
                                                              permission[
                                                                  "accountNumber"],
                                                          threshold: permission[
                                                                  "foreignFundTransferThreshold"]
                                                              .toDouble(),
                                                          currency: permission[
                                                              "currency"],
                                                          bal: double.parse(
                                                              permission[
                                                                      "currentBalance"]
                                                                  .split(" ")
                                                                  .last
                                                                  .replaceAll(
                                                                      ',', '')),
                                                          accountType:
                                                              permission[
                                                                  "accountType"],
                                                          currencyFlag: permission[
                                                              "currencyFlagBase64"],
                                                        ),
                                                      );
                                                    }
                                                  }

                                                  canCreateSavingsAccount =
                                                      corpCustPermApiResult[
                                                          "canCreateSavingsAccount"];
                                                  canCreateCurrentAccount =
                                                      corpCustPermApiResult[
                                                          "canCreateCurrentAccount"];

                                                  canChangeAddress =
                                                      corpCustPermApiResult[
                                                          "canChangeAddress"];
                                                  canChangeMobileNumber =
                                                      corpCustPermApiResult[
                                                          "canChangeMobileNumber"];
                                                  canChangeEmailId =
                                                      corpCustPermApiResult[
                                                          "canChangeEmailId"];

                                                  canUpdateKYC =
                                                      corpCustPermApiResult[
                                                          "canUpdateKYC"];
                                                  canCloseAccount =
                                                      corpCustPermApiResult[
                                                          "canCloseAccount"];
                                                  canRequestChequeBook =
                                                      corpCustPermApiResult[
                                                          "canRequestChequeBook"];
                                                  canRequestCertificate =
                                                      corpCustPermApiResult[
                                                          "canRequestCertificate"];
                                                  canRequestAccountStatement =
                                                      corpCustPermApiResult[
                                                          "canRequestAccountStatement"];
                                                  canRequestCard =
                                                      corpCustPermApiResult[
                                                          "canRequestCard"];
                                                  if (context.mounted) {
                                                    if (isNewWithinDhabiBeneficiary) {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    } else {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    }

                                                    Navigator.pushNamed(
                                                      context,
                                                      Routes.sendMoneyFrom,
                                                      arguments:
                                                          SendMoneyArgumentModel(
                                                        isBetweenAccounts:
                                                            sendMoneyArgument
                                                                .isBetweenAccounts,
                                                        isWithinDhabi:
                                                            sendMoneyArgument
                                                                .isWithinDhabi,
                                                        isRemittance:
                                                            sendMoneyArgument
                                                                .isRemittance,
                                                        isRetail:
                                                            sendMoneyArgument
                                                                .isRetail,
                                                      ).toMap(),
                                                    );
                                                    isAddWithinDhabiBeneficiary =
                                                        false;
                                                    isNewWithinDhabiBeneficiary =
                                                        false;
                                                  }
                                                } else {
                                                  if (context.mounted) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CustomDialog(
                                                          svgAssetPath:
                                                              ImageConstants
                                                                  .warning,
                                                          title: "Sorry!",
                                                          message: corpCustPermApiResult[
                                                                  "message"] ??
                                                              "Something went wrong, please try again later",
                                                          actionWidget:
                                                              GradientButton(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            text: labels[346]
                                                                ["labelText"],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                }
                                              },
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
                                                title: "Sorry!",
                                                message: createBeneficiaryAPiResult[
                                                        "message"] ??
                                                    "Something went wrong while adding beneficiary, please try again later",
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
                                    } else {
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.errorSuccessScreen,
                                          arguments: ErrorArgumentModel(
                                            hasSecondaryButton: true,
                                            iconPath: ImageConstants
                                                .checkCircleOutlined,
                                            title: corpDhabiMoneyTransferApiResult[
                                                    "isDirectlyCreated"]
                                                ? "Success!"
                                                : "Domestic Transfer Request Placed",
                                            message: corpDhabiMoneyTransferApiResult[
                                                    "isDirectlyCreated"]
                                                ? "Your transaction has been completed\n\nTransfer reference: ${corpDhabiMoneyTransferApiResult["reference"]}"
                                                : "${messages[121]["messageText"]}: ${corpDhabiMoneyTransferApiResult["reference"]}",
                                            buttonTextSecondary: "Go Home",
                                            onTapSecondary: () {
                                              isAddWithinDhabiBeneficiary =
                                                  false;
                                              isNewWithinDhabiBeneficiary =
                                                  false;
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.businessDashboard,
                                                (route) => false,
                                                arguments:
                                                    RetailDashboardArgumentModel(
                                                  imgUrl:
                                                      storageProfilePhotoBase64 ??
                                                          "",
                                                  name: profileName ?? "",
                                                  isFirst:
                                                      storageIsFirstLogin ==
                                                              true
                                                          ? false
                                                          : true,
                                                ).toMap(),
                                              );
                                            },
                                            buttonText:
                                                "Make Another Transaction",
                                            onTap: () async {
                                              var corpCustPermApiResult =
                                                  await MapCorporateCustomerPermissions
                                                      .mapCorporateCustomerPermissions(
                                                          token ?? "");
                                              if (corpCustPermApiResult[
                                                  "success"]) {
                                                fdSeedAccounts.clear();
                                                internalSeedAccounts.clear();
                                                dhabiSeedAccounts.clear();
                                                foreignSeedAccounts.clear();
                                                for (var permission
                                                    in corpCustPermApiResult[
                                                        "permissions"]) {
                                                  if (permission[
                                                      "canCreateFD"]) {
                                                    fdSeedAccounts.add(
                                                      SeedAccount(
                                                        accountNumber:
                                                            permission[
                                                                "accountNumber"],
                                                        threshold: permission[
                                                                "fdCreationThreshold"]
                                                            .toDouble(),
                                                        currency: permission[
                                                            "currency"],
                                                        bal: double.parse(
                                                                permission[
                                                                        "currentBalance"]
                                                                    .split(" ")
                                                                    .last
                                                                    .replaceAll(
                                                                        ',',
                                                                        ''))
                                                            .abs(),
                                                        accountType: permission[
                                                            "accountType"],
                                                        currencyFlag: permission[
                                                            "currencyFlagBase64"],
                                                      ),
                                                    );
                                                  }
                                                  if (permission[
                                                      "canTransferInternalFund"]) {
                                                    internalSeedAccounts.add(
                                                      SeedAccount(
                                                        accountNumber:
                                                            permission[
                                                                "accountNumber"],
                                                        threshold: permission[
                                                                "internalFundTransferThreshold"]
                                                            .toDouble(),
                                                        currency: permission[
                                                            "currency"],
                                                        bal: double.parse(
                                                            permission[
                                                                    "currentBalance"]
                                                                .split(" ")
                                                                .last
                                                                .replaceAll(
                                                                    ',', '')),
                                                        accountType: permission[
                                                            "accountType"],
                                                        currencyFlag: permission[
                                                            "currencyFlagBase64"],
                                                      ),
                                                    );
                                                  }
                                                  if (permission[
                                                      "canTransferDhabiFund"]) {
                                                    dhabiSeedAccounts.add(
                                                      SeedAccount(
                                                        accountNumber:
                                                            permission[
                                                                "accountNumber"],
                                                        threshold: permission[
                                                                "dhabiFundTransferThreshold"]
                                                            .toDouble(),
                                                        currency: permission[
                                                            "currency"],
                                                        bal: double.parse(
                                                            permission[
                                                                    "currentBalance"]
                                                                .split(" ")
                                                                .last
                                                                .replaceAll(
                                                                    ',', '')),
                                                        accountType: permission[
                                                            "accountType"],
                                                        currencyFlag: permission[
                                                            "currencyFlagBase64"],
                                                      ),
                                                    );
                                                  }
                                                  if (permission[
                                                      "canTransferInternationalFund"]) {
                                                    foreignSeedAccounts.add(
                                                      SeedAccount(
                                                        accountNumber:
                                                            permission[
                                                                "accountNumber"],
                                                        threshold: permission[
                                                                "foreignFundTransferThreshold"]
                                                            .toDouble(),
                                                        currency: permission[
                                                            "currency"],
                                                        bal: double.parse(
                                                            permission[
                                                                    "currentBalance"]
                                                                .split(" ")
                                                                .last
                                                                .replaceAll(
                                                                    ',', '')),
                                                        accountType: permission[
                                                            "accountType"],
                                                        currencyFlag: permission[
                                                            "currencyFlagBase64"],
                                                      ),
                                                    );
                                                  }
                                                }

                                                canCreateSavingsAccount =
                                                    corpCustPermApiResult[
                                                        "canCreateSavingsAccount"];
                                                canCreateCurrentAccount =
                                                    corpCustPermApiResult[
                                                        "canCreateCurrentAccount"];

                                                canChangeAddress =
                                                    corpCustPermApiResult[
                                                        "canChangeAddress"];
                                                canChangeMobileNumber =
                                                    corpCustPermApiResult[
                                                        "canChangeMobileNumber"];
                                                canChangeEmailId =
                                                    corpCustPermApiResult[
                                                        "canChangeEmailId"];

                                                canUpdateKYC =
                                                    corpCustPermApiResult[
                                                        "canUpdateKYC"];
                                                canCloseAccount =
                                                    corpCustPermApiResult[
                                                        "canCloseAccount"];
                                                canRequestChequeBook =
                                                    corpCustPermApiResult[
                                                        "canRequestChequeBook"];
                                                canRequestCertificate =
                                                    corpCustPermApiResult[
                                                        "canRequestCertificate"];
                                                canRequestAccountStatement =
                                                    corpCustPermApiResult[
                                                        "canRequestAccountStatement"];
                                                canRequestCard =
                                                    corpCustPermApiResult[
                                                        "canRequestCard"];
                                                if (context.mounted) {
                                                  if (isNewWithinDhabiBeneficiary) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  } else {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }
                                                } else {
                                                  if (context.mounted) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CustomDialog(
                                                          svgAssetPath:
                                                              ImageConstants
                                                                  .warning,
                                                          title: "Sorry!",
                                                          message: corpCustPermApiResult[
                                                                  "message"] ??
                                                              "Error fetching account details, please try again later",
                                                          actionWidget:
                                                              GradientButton(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            text: labels[293]
                                                                ["labelText"],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                }

                                                if (context.mounted) {
                                                  Navigator.pushNamed(
                                                    context,
                                                    Routes.sendMoneyFrom,
                                                    arguments:
                                                        SendMoneyArgumentModel(
                                                      isBetweenAccounts:
                                                          sendMoneyArgument
                                                              .isBetweenAccounts,
                                                      isWithinDhabi:
                                                          sendMoneyArgument
                                                              .isWithinDhabi,
                                                      isRemittance:
                                                          sendMoneyArgument
                                                              .isRemittance,
                                                      isRetail:
                                                          sendMoneyArgument
                                                              .isRetail,
                                                    ).toMap(),
                                                  );
                                                }
                                                isAddWithinDhabiBeneficiary =
                                                    false;
                                                isNewWithinDhabiBeneficiary =
                                                    false;
                                              } else {
                                                if (context.mounted) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CustomDialog(
                                                        svgAssetPath:
                                                            ImageConstants
                                                                .warning,
                                                        title: "Sorry!",
                                                        message: corpCustPermApiResult[
                                                                "message"] ??
                                                            "Something went wrong, please try again later 8",
                                                        actionWidget:
                                                            GradientButton(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          text: labels[346]
                                                              ["labelText"],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                          ).toMap(),
                                        );
                                      }
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomDialog(
                                            svgAssetPath:
                                                ImageConstants.warning,
                                            title: "Sorry!",
                                            message:
                                                corpDhabiMoneyTransferApiResult[
                                                        "message"] ??
                                                    "Something went wrong while corporate domestic transfer, please try again later",
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
                                }
                              }
                              isTransferring = false;
                              showButtonBloc
                                  .add(ShowButtonEvent(show: isTransferring));
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  svgAssetPath: ImageConstants.warning,
                                  title: "Incorrect Password",
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
                        auxWidget: isTransferring
                            ? const LoaderRow()
                            : const SizeBox(),
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
