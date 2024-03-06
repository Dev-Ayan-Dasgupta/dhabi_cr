// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
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
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class TransferConfirmationScreen extends StatefulWidget {
  const TransferConfirmationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransferConfirmationScreen> createState() =>
      _TransferConfirmationScreenState();
}

class _TransferConfirmationScreenState
    extends State<TransferConfirmationScreen> {
  List<DetailsTileModel> transferConfirmation = [];

  bool isTransferring = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  String addBenError = "";

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateDetails();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    log("sendMoneyArgument -> $sendMoneyArgument");
    // exchangeRate = sendMoneyArgument.isBetweenAccounts ? 1 : 0;
  }

  void populateDetails() {
    if (sendMoneyArgument.isBetweenAccounts) {
      transferConfirmation.add(DetailsTileModel(
          key: labels[155]["labelText"], value: senderAccountNumber));
      transferConfirmation.add(DetailsTileModel(
          key: labels[157]["labelText"], value: receiverAccountNumber));
      transferConfirmation.add(DetailsTileModel(
          key: labels[159]["labelText"],
          value:
              "$senderCurrency ${senderAmount >= 1000 ? NumberFormat('#,000.00').format(senderAmount) : senderAmount.toStringAsFixed(2)}"));
      transferConfirmation.add(DetailsTileModel(
          key: sendMoneyArgument.isBetweenAccounts
              ? labels[163]["labelText"]
              : labels[198]["labelText"],
          value:
              "$receiverCurrency ${receiverAmount >= 1000 ? NumberFormat('#,000.00').format(receiverAmount) : receiverAmount}"));
      transferConfirmation.add(DetailsTileModel(
          key: labels[165]["labelText"],
          value:
              "1 $senderCurrency = ${exchangeRate.toStringAsFixed(4)} $receiverCurrency"));
      transferConfirmation.add(DetailsTileModel(
          key: "${labels[168]["labelText"]} (VAT Exclusive)",
          value: "$senderCurrency ${0}"));
      transferConfirmation.add(DetailsTileModel(
          key: labels[169]["labelText"],
          value: sendMoneyArgument.isBetweenAccounts ? "Today" : "something"));
    } else if (sendMoneyArgument.isRemittance) {
      transferConfirmation.add(DetailsTileModel(
          key: labels[155]["labelText"], value: senderAccountNumber));
      transferConfirmation.add(
        DetailsTileModel(
          key: labels[157]["labelText"],
          value: !isWalletSelected || benIdType == "2"
              ? receiverAccountNumber
              : walletNumber.isEmpty
                  ? benMobileNo
                  : walletNumber,
        ),
      );
      transferConfirmation.add(DetailsTileModel(
          key: labels[178]["labelText"], value: benCustomerName));
      transferConfirmation.add(DetailsTileModel(
          key: labels[159]["labelText"],
          value:
              "$senderCurrency ${senderAmount >= 1000 ? NumberFormat('#,000.00').format(senderAmount) : senderAmount.toStringAsFixed(2)}"));
      transferConfirmation.add(DetailsTileModel(
          key: sendMoneyArgument.isBetweenAccounts
              ? labels[163]["labelText"]
              : labels[198]["labelText"],
          value:
              "$receiverCurrency ${receiverAmount >= 1000 ? NumberFormat('#,000.00').format(receiverAmount) : receiverAmount}"));
      transferConfirmation.add(DetailsTileModel(
          key: labels[165]["labelText"],
          value:
              "1 $senderCurrency = ${exchangeRate.toStringAsFixed(2)} $receiverCurrency"));
      transferConfirmation.add(DetailsTileModel(
          key: "${labels[168]["labelText"]} (VAT Exclusive)",
          value: isSenderBearCharges
              ? "$senderCurrency ${fees.toStringAsFixed(2)}"
              : "$receiverCurrency ${fees.toStringAsFixed(2)}"));
      transferConfirmation.add(DetailsTileModel(
          key: "Purpose of Payment", value: chosenPurposeCode));
      transferConfirmation.add(DetailsTileModel(
          key: labels[169]["labelText"],
          value: DateFormat('dd MMMM yyyy').format(DateTime.now())));
    } else {
      transferConfirmation.add(DetailsTileModel(
          key: labels[155]["labelText"], value: senderAccountNumber));
      transferConfirmation.add(DetailsTileModel(
          key: labels[157]["labelText"], value: receiverAccountNumber));
      transferConfirmation.add(DetailsTileModel(
          key: labels[178]["labelText"],
          value: isNewWithinDhabiBeneficiary
              ? ObscureHelper.obscureName(benCustomerName)
              : benCustomerName));
      transferConfirmation.add(DetailsTileModel(
          key: labels[159]["labelText"],
          value:
              "$senderCurrency ${senderAmount >= 1000 ? NumberFormat('#,000.00').format(senderAmount) : senderAmount.toStringAsFixed(2)}"));
      transferConfirmation.add(DetailsTileModel(
          key: sendMoneyArgument.isBetweenAccounts
              ? labels[163]["labelText"]
              : labels[198]["labelText"],
          value:
              "$receiverCurrency ${receiverAmount >= 1000 ? NumberFormat('#,000.00').format(receiverAmount) : receiverAmount}"));
      transferConfirmation.add(DetailsTileModel(
          key: labels[165]["labelText"],
          value:
              "1 $senderCurrency = ${exchangeRate.toStringAsFixed(2)} $receiverCurrency"));
      transferConfirmation.add(DetailsTileModel(
          key: "${labels[168]["labelText"]} (VAT Exclusive)",
          value: isSenderBearCharges
              ? "$senderCurrency ${fees.toStringAsFixed(2)}"
              : "$receiverCurrency ${fees.toStringAsFixed(2)}"));
      transferConfirmation.add(DetailsTileModel(
          key: labels[169]["labelText"],
          value: !(sendMoneyArgument.isRemittance) ? "Today" : "something"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: () {
              if (sendMoneyArgument.isBetweenAccounts) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              } else if (sendMoneyArgument.isWithinDhabi) {
                if (isNewWithinDhabiBeneficiary) {
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
                }
              } else {
                if (isNewRemittanceBeneficiary) {
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
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                right: (22 / Dimensions.designWidth).w,
                top: (20 / Dimensions.designWidth).w,
              ),
              child: Text(
                labels[166]["labelText"],
                style: TextStyles.primary.copyWith(
                  color: const Color.fromRGBO(65, 65, 65, 0.5),
                  fontSize: (16 / Dimensions.designWidth).w,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
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
                    labels[164]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    labels[167]["labelText"],
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: transferConfirmation.length,
                      details: transferConfirmation,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return GradientButton(
                      onTap: () async {
                        if (!isTransferring) {
                          final ShowButtonBloc showButtonBloc =
                              context.read<ShowButtonBloc>();
                          isTransferring = true;
                          showButtonBloc
                              .add(ShowButtonEvent(show: isTransferring));

                          if (sendMoneyArgument.isRetail) {
                            if (sendMoneyArgument.isBetweenAccounts) {
                              log("Internal Transfer APi request -> ${{
                                "debitAccount": senderAccountNumber,
                                "creditAccount": receiverAccountNumber,
                                "debitAmount": senderAmount.toString(),
                                "currency": senderCurrency,
                                "beneficiaryName": profileName,
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
                                  "beneficiaryName": profileName,
                                  "uniqueId":
                                      DateTime.now().millisecondsSinceEpoch,
                                  "hash": EncryptDecrypt.encrypt(
                                      "${DateTime.now().millisecondsSinceEpoch}"),
                                },
                                token ?? "",
                              );
                              log("Make Internal Transfer Response -> $makeInternalTransferApiResult");
                              if (makeInternalTransferApiResult["success"]) {
                                if (context.mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.errorSuccessScreen,
                                    arguments: ErrorArgumentModel(
                                      hasSecondaryButton: true,
                                      iconPath:
                                          ImageConstants.checkCircleOutlined,
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
                                            isFirst: storageIsFirstLogin == true
                                                ? false
                                                : true,
                                          ).toMap(),
                                        );
                                      },
                                      buttonText: "Make Another Transaction",
                                      onTap: () async {
                                        var result =
                                            await MapCustomerAccountDetails
                                                .mapCustomerAccountDetails(
                                                    token ?? "");
                                        if (result["success"]) {
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            accountDetails =
                                                result["crCustomerProfileRes"]
                                                    ["body"]["accountDetails"];
                                            Navigator.pushNamed(
                                              context,
                                              Routes.sendMoneyFrom,
                                              arguments: SendMoneyArgumentModel(
                                                isBetweenAccounts:
                                                    sendMoneyArgument
                                                        .isBetweenAccounts,
                                                isWithinDhabi: sendMoneyArgument
                                                    .isWithinDhabi,
                                                isRemittance: sendMoneyArgument
                                                    .isRemittance,
                                                isRetail:
                                                    sendMoneyArgument.isRetail,
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
                                                  message: result["message"] ??
                                                      "Something went wrong, please try again later",
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
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Sorry!",
                                        message: makeInternalTransferApiResult[
                                                "message"] ??
                                            "Something went wrong while internal transfer, please try again later",
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
                            } else if (sendMoneyArgument.isRemittance) {
                              if (isNewRemittanceBeneficiary) {
                                bool isBioCapable = await LocalAuthentication()
                                    .canCheckBiometrics;
                                if (!isBioCapable) {
                                  // navigate to password screen
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.password,
                                      arguments: SendMoneyArgumentModel(
                                        isBetweenAccounts:
                                            sendMoneyArgument.isBetweenAccounts,
                                        isWithinDhabi:
                                            sendMoneyArgument.isWithinDhabi,
                                        isRemittance:
                                            sendMoneyArgument.isRemittance,
                                        isRetail: sendMoneyArgument.isRetail,
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
                                        Routes.password,
                                        arguments: SendMoneyArgumentModel(
                                          isBetweenAccounts: sendMoneyArgument
                                              .isBetweenAccounts,
                                          isWithinDhabi:
                                              sendMoneyArgument.isWithinDhabi,
                                          isRemittance:
                                              sendMoneyArgument.isRemittance,
                                          isRetail: sendMoneyArgument.isRetail,
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
                                          Routes.password,
                                          arguments: SendMoneyArgumentModel(
                                            isBetweenAccounts: sendMoneyArgument
                                                .isBetweenAccounts,
                                            isWithinDhabi:
                                                sendMoneyArgument.isWithinDhabi,
                                            isRemittance:
                                                sendMoneyArgument.isRemittance,
                                            isRetail:
                                                sendMoneyArgument.isRetail,
                                          ).toMap(),
                                        );
                                      }
                                    } else {
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
                                        "uniqueId": DateTime.now()
                                            .millisecondsSinceEpoch,
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
                                          "remittancePurpose": ValueToKey
                                              .mapPurposeCodeValueToKey(
                                                  chosenPurposeCode),
                                          "fees": fees.toString(),
                                          "chargesCode": chosenChargeCode,
                                          "uniqueId": DateTime.now()
                                              .millisecondsSinceEpoch,
                                          "hash": EncryptDecrypt.encrypt(
                                              "${DateTime.now().millisecondsSinceEpoch}"),
                                          "isSwiftTransfer": isTerraPaySupported
                                              ? false
                                              : true,
                                        },
                                        token ?? "",
                                      );
                                      log("makeIntFundTransferApiRes -> $makeIntFundTransferApiRes");
                                      if (makeIntFundTransferApiRes[
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
                                                }
                                              },
                                              buttonTextSecondary: "Go Home",
                                              onTapSecondary: () {
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
                                    }
                                  }
                                }
                              } else {
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
                                        iconPath:
                                            ImageConstants.checkCircleOutlined,
                                        title: "Success!",
                                        message:
                                            "Your transaction has been completed\n\nTransfer reference: ${makeIntFundTransferApiRes["ftReferenceNumber"]}",
                                        buttonText: "Make Another Transaction",
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
                                                    ["body"]["accountDetails"];
                                            Navigator.pushNamed(
                                              context,
                                              Routes.sendMoneyFrom,
                                              arguments: SendMoneyArgumentModel(
                                                isBetweenAccounts:
                                                    sendMoneyArgument
                                                        .isBetweenAccounts,
                                                isWithinDhabi: sendMoneyArgument
                                                    .isWithinDhabi,
                                                isRemittance: sendMoneyArgument
                                                    .isRemittance,
                                                isRetail:
                                                    sendMoneyArgument.isRetail,
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
                                          svgAssetPath: ImageConstants.warning,
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
                              }
                            } else {
                              if (isNewWithinDhabiBeneficiary) {
                                bool isBioCapable = await LocalAuthentication()
                                    .canCheckBiometrics;
                                // isBioCapable = false;
                                if (!isBioCapable) {
                                  // navigate to pwd screen
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.password,
                                      arguments: SendMoneyArgumentModel(
                                        isBetweenAccounts:
                                            sendMoneyArgument.isBetweenAccounts,
                                        isWithinDhabi:
                                            sendMoneyArgument.isWithinDhabi,
                                        isRemittance:
                                            sendMoneyArgument.isRemittance,
                                        isRetail: sendMoneyArgument.isRetail,
                                      ).toMap(),
                                    );
                                  }
                                } else {
                                  List availableBios =
                                      await LocalAuthentication()
                                          .getAvailableBiometrics();
                                  if (availableBios.isEmpty ||
                                      persistBiometric != true) {
                                    // navigate to pwd screen
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.password,
                                        arguments: SendMoneyArgumentModel(
                                          isBetweenAccounts: sendMoneyArgument
                                              .isBetweenAccounts,
                                          isWithinDhabi:
                                              sendMoneyArgument.isWithinDhabi,
                                          isRemittance:
                                              sendMoneyArgument.isRemittance,
                                          isRetail: sendMoneyArgument.isRetail,
                                        ).toMap(),
                                      );
                                    }
                                  } else {
                                    bool isAuthenticated = await BiometricHelper
                                        .authenticateUser();
                                    if (!isAuthenticated) {
                                      // navigate to pwd screen
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.password,
                                          arguments: SendMoneyArgumentModel(
                                            isBetweenAccounts: sendMoneyArgument
                                                .isBetweenAccounts,
                                            isWithinDhabi:
                                                sendMoneyArgument.isWithinDhabi,
                                            isRemittance:
                                                sendMoneyArgument.isRemittance,
                                            isRetail:
                                                sendMoneyArgument.isRetail,
                                          ).toMap(),
                                        );
                                      }
                                    } else {
                                      log("Internal Transfer Api request -> ${{
                                        "debitAccount": senderAccountNumber,
                                        "creditAccount": receiverAccountNumber,
                                        "debitAmount": senderAmount.toString(),
                                        "currency": senderCurrency,
                                        "beneficiaryName": benCustomerName,
                                        "uniqueId": DateTime.now()
                                            .millisecondsSinceEpoch,
                                        "hash": EncryptDecrypt.encrypt(
                                            "${DateTime.now().millisecondsSinceEpoch}"),
                                      }}");
                                      var makeInternalTransferApiResult =
                                          await MapInternalMoneyTransfer
                                              .mapInternalMoneyTransfer(
                                        {
                                          "debitAccount": senderAccountNumber,
                                          "creditAccount":
                                              receiverAccountNumber,
                                          "debitAmount":
                                              senderAmount.toString(),
                                          "currency": senderCurrency,
                                          "beneficiaryName": benCustomerName,
                                          "uniqueId": DateTime.now()
                                              .millisecondsSinceEpoch,
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
                                            "accountNumber":
                                                !isWalletSelected ||
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
                                            "sourceOfFunds":
                                                sourceOfFunds ?? "",
                                            "relation": relation ?? "",
                                            "providerName": providerName ?? "",
                                          }}");

                                          var createBeneficiaryAPiResult =
                                              await MapCreateBeneficiary
                                                  .mapCreateBeneficiary(
                                            {
                                              "beneficiaryType": 3,
                                              "accountNumber":
                                                  !isWalletSelected ||
                                                          benIdType == "2"
                                                      ? receiverAccountNumber
                                                      : walletNumber.isEmpty
                                                          ? benMobileNo
                                                          : walletNumber,
                                              "name": benCustomerName,
                                              "address": benAddress,
                                              "accountType": benAccountType,
                                              "swiftReference": 0,
                                              "targetCurrency":
                                                  receiverCurrency,
                                              "countryCode": "AE",
                                              "benBankCode": benBankCode,
                                              "benMobileNo": benMobileNo,
                                              "benSubBankCode": benSubBankCode,
                                              "benIdType": benIdType,
                                              "benIdNo": benIdNo,
                                              "benIdExpiryDate":
                                                  benIdExpiryDate,
                                              "benBankName": benBankName,
                                              "benSwiftCodeText": benSwiftCode,
                                              "city": benCity,
                                              "remittancePurpose":
                                                  remittancePurpose ?? "",
                                              "sourceOfFunds":
                                                  sourceOfFunds ?? "",
                                              "relation": relation ?? "",
                                              "providerName":
                                                  providerName ?? "",
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
                                                  buttonTextSecondary:
                                                      "Go Home",
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
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        }

                                                        accountDetails = result[
                                                                    "crCustomerProfileRes"]
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
                                                                      "message"]
                                                                  [
                                                                  "Something went wrong, please try again later"],
                                                              actionWidget:
                                                                  GradientButton(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                text: labels[
                                                                        346][
                                                                    "labelText"],
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
                                                    message:
                                                        createBeneficiaryAPiResult[
                                                                "message"] ??
                                                            "Something went wrong while adding beneficiary, please try again later",
                                                    actionWidget:
                                                        GradientButton(
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
                                                  var corpCustPermApiResult =
                                                      await MapCorporateCustomerPermissions
                                                          .mapCorporateCustomerPermissions(
                                                              token ?? "");
                                                  if (corpCustPermApiResult[
                                                      "success"]) {
                                                    fdSeedAccounts.clear();
                                                    internalSeedAccounts
                                                        .clear();
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
                                                            currency:
                                                                permission[
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
                                                            currencyFlag:
                                                                permission[
                                                                    "currencyFlagBase64"],
                                                          ),
                                                        );
                                                      }
                                                      if (permission[
                                                          "canTransferInternalFund"]) {
                                                        internalSeedAccounts
                                                            .add(
                                                          SeedAccount(
                                                            accountNumber:
                                                                permission[
                                                                    "accountNumber"],
                                                            threshold: permission[
                                                                    "internalFundTransferThreshold"]
                                                                .toDouble(),
                                                            currency:
                                                                permission[
                                                                    "currency"],
                                                            bal: double.parse(
                                                                permission[
                                                                        "currentBalance"]
                                                                    .split(" ")
                                                                    .last
                                                                    .replaceAll(
                                                                        ',',
                                                                        '')),
                                                            accountType:
                                                                permission[
                                                                    "accountType"],
                                                            currencyFlag:
                                                                permission[
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
                                                            currency:
                                                                permission[
                                                                    "currency"],
                                                            bal: double.parse(
                                                                permission[
                                                                        "currentBalance"]
                                                                    .split(" ")
                                                                    .last
                                                                    .replaceAll(
                                                                        ',',
                                                                        '')),
                                                            accountType:
                                                                permission[
                                                                    "accountType"],
                                                            currencyFlag:
                                                                permission[
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
                                                            currency:
                                                                permission[
                                                                    "currency"],
                                                            bal: double.parse(
                                                                permission[
                                                                        "currentBalance"]
                                                                    .split(" ")
                                                                    .last
                                                                    .replaceAll(
                                                                        ',',
                                                                        '')),
                                                            accountType:
                                                                permission[
                                                                    "accountType"],
                                                            currencyFlag:
                                                                permission[
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
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      accountDetails =
                                                          corpCustPermApiResult[
                                                                      "crCustomerProfileRes"]
                                                                  ["body"][
                                                              "accountDetails"];
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
                                                message:
                                                    makeInternalTransferApiResult[
                                                            "message"] ??
                                                        "Something went wrong while within Dhabi transfer, please try again later",
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
                                if (makeInternalTransferApiResult["success"]) {
                                  if (isAddWithinDhabiBeneficiary) {
                                    log("create beneficiary request -> ${{
                                      "beneficiaryType": 3,
                                      "accountNumber":
                                          !isWalletSelected || benIdType == "2"
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

                                    if (createBeneficiaryAPiResult["success"]) {
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
                                                  } else {
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
                                                text: labels[346]["labelText"],
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
                                                    storageIsFirstLogin == true
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
                                                } else {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }

                                                accountDetails = result[
                                                        "crCustomerProfileRes"]
                                                    ["body"]["accountDetails"];
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
                                                      message: result["message"]
                                                          [
                                                          "Something went wrong, please try again later"],
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
                                          svgAssetPath: ImageConstants.warning,
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
                            }
                          } else {
                            if (sendMoneyArgument.isBetweenAccounts) {
                              log("corpInternalMoneyTransferApi Request -> ${{
                                "debitAccount": senderAccountNumber,
                                "creditAccount": receiverAccountNumber,
                                "debitAmount": senderAmount.toString(),
                                "currency": senderCurrency,
                                "beneficiaryName": profileName,
                                "uniqueId":
                                    DateTime.now().millisecondsSinceEpoch,
                                "hash": EncryptDecrypt.encrypt(
                                    "${DateTime.now().millisecondsSinceEpoch}"),
                              }}");
                              var corpInternalMoneyTransferApiResult =
                                  await MapInternalMoneyTransferCorporate
                                      .mapInternalMoneyTransferCorporate(
                                {
                                  "debitAccount": senderAccountNumber,
                                  "creditAccount": receiverAccountNumber,
                                  "debitAmount": senderAmount.toString(),
                                  "currency": senderCurrency,
                                  "beneficiaryName": profileName,
                                  "uniqueId":
                                      DateTime.now().millisecondsSinceEpoch,
                                  "hash": EncryptDecrypt.encrypt(
                                      "${DateTime.now().millisecondsSinceEpoch}"),
                                },
                                token ?? "",
                              );
                              log("corpInternalMoneyTransferApiResult -> $corpInternalMoneyTransferApiResult");

                              if (corpInternalMoneyTransferApiResult[
                                  "success"]) {
                                if (context.mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.errorSuccessScreen,
                                    arguments: ErrorArgumentModel(
                                      hasSecondaryButton: true,
                                      iconPath:
                                          ImageConstants.checkCircleOutlined,
                                      title: corpInternalMoneyTransferApiResult[
                                              "isDirectlyCreated"]
                                          ? "Successful"
                                          : "Internal Money Transfer Request Placed",
                                      message: corpInternalMoneyTransferApiResult[
                                              "isDirectlyCreated"]
                                          ? "Your transaction has been completed\n\nTransfer reference: ${corpInternalMoneyTransferApiResult["reference"]}"
                                          : "${messages[121]["messageText"]}: ${corpInternalMoneyTransferApiResult["reference"]}",
                                      buttonTextSecondary: "Go Home",
                                      onTapSecondary: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.businessDashboard,
                                          (route) => false,
                                          arguments:
                                              RetailDashboardArgumentModel(
                                            imgUrl:
                                                storageProfilePhotoBase64 ?? "",
                                            name: profileName ?? "",
                                            isFirst: storageIsFirstLogin == true
                                                ? false
                                                : true,
                                          ).toMap(),
                                        );
                                      },
                                      buttonText: "Make Another Transaction",
                                      onTap: () async {
                                        var corpCustPermApiResult =
                                            await MapCorporateCustomerPermissions
                                                .mapCorporateCustomerPermissions(
                                                    token ?? "");
                                        if (corpCustPermApiResult["success"]) {
                                          fdSeedAccounts.clear();
                                          internalSeedAccounts.clear();
                                          dhabiSeedAccounts.clear();
                                          foreignSeedAccounts.clear();
                                          for (var permission
                                              in corpCustPermApiResult[
                                                  "permissions"]) {
                                            if (permission["canCreateFD"]) {
                                              fdSeedAccounts.add(
                                                SeedAccount(
                                                  accountNumber: permission[
                                                      "accountNumber"],
                                                  threshold: permission[
                                                          "fdCreationThreshold"]
                                                      .toDouble(),
                                                  currency:
                                                      permission["currency"],
                                                  bal: double.parse(permission[
                                                              "currentBalance"]
                                                          .split(" ")
                                                          .last
                                                          .replaceAll(',', ''))
                                                      .abs(),
                                                  accountType:
                                                      permission["accountType"],
                                                  currencyFlag: permission[
                                                      "currencyFlagBase64"],
                                                ),
                                              );
                                            }
                                            if (permission[
                                                "canTransferInternalFund"]) {
                                              internalSeedAccounts.add(
                                                SeedAccount(
                                                  accountNumber: permission[
                                                      "accountNumber"],
                                                  threshold: permission[
                                                          "internalFundTransferThreshold"]
                                                      .toDouble(),
                                                  currency:
                                                      permission["currency"],
                                                  bal: double.parse(permission[
                                                          "currentBalance"]
                                                      .split(" ")
                                                      .last
                                                      .replaceAll(',', '')),
                                                  accountType:
                                                      permission["accountType"],
                                                  currencyFlag: permission[
                                                      "currencyFlagBase64"],
                                                ),
                                              );
                                            }
                                            if (permission[
                                                "canTransferDhabiFund"]) {
                                              dhabiSeedAccounts.add(
                                                SeedAccount(
                                                  accountNumber: permission[
                                                      "accountNumber"],
                                                  threshold: permission[
                                                          "dhabiFundTransferThreshold"]
                                                      .toDouble(),
                                                  currency:
                                                      permission["currency"],
                                                  bal: double.parse(permission[
                                                          "currentBalance"]
                                                      .split(" ")
                                                      .last
                                                      .replaceAll(',', '')),
                                                  accountType:
                                                      permission["accountType"],
                                                  currencyFlag: permission[
                                                      "currencyFlagBase64"],
                                                ),
                                              );
                                            }
                                            if (permission[
                                                "canTransferInternationalFund"]) {
                                              foreignSeedAccounts.add(
                                                SeedAccount(
                                                  accountNumber: permission[
                                                      "accountNumber"],
                                                  threshold: permission[
                                                          "foreignFundTransferThreshold"]
                                                      .toDouble(),
                                                  currency:
                                                      permission["currency"],
                                                  bal: double.parse(permission[
                                                          "currentBalance"]
                                                      .split(" ")
                                                      .last
                                                      .replaceAll(',', '')),
                                                  accountType:
                                                      permission["accountType"],
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

                                          canUpdateKYC = corpCustPermApiResult[
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
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            Navigator.pushNamed(
                                              context,
                                              Routes.sendMoneyFrom,
                                              arguments: SendMoneyArgumentModel(
                                                isBetweenAccounts:
                                                    sendMoneyArgument
                                                        .isBetweenAccounts,
                                                isWithinDhabi: sendMoneyArgument
                                                    .isWithinDhabi,
                                                isRemittance: sendMoneyArgument
                                                    .isRemittance,
                                                isRetail:
                                                    sendMoneyArgument.isRetail,
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
                                                  message: corpCustPermApiResult[
                                                          "message"] ??
                                                      "Something went wrong, please try again later",
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
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Sorry!",
                                        message: corpInternalMoneyTransferApiResult[
                                                "message"] ??
                                            "Something went wrong while corporate internal transfer, please try again later",
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
                            } else if (sendMoneyArgument.isRemittance) {
                              if (isNewRemittanceBeneficiary) {
                                bool isBioCapable = await LocalAuthentication()
                                    .canCheckBiometrics;
                                if (!isBioCapable) {
                                  // Navigate to sm password
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.password,
                                      arguments: SendMoneyArgumentModel(
                                        isBetweenAccounts:
                                            sendMoneyArgument.isBetweenAccounts,
                                        isWithinDhabi:
                                            sendMoneyArgument.isWithinDhabi,
                                        isRemittance:
                                            sendMoneyArgument.isRemittance,
                                        isRetail: sendMoneyArgument.isRetail,
                                      ).toMap(),
                                    );
                                  }
                                } else {
                                  List availableBios =
                                      await LocalAuthentication()
                                          .getAvailableBiometrics();
                                  if (availableBios.isEmpty ||
                                      persistBiometric != true) {
                                    // Navigate to sm password
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.password,
                                        arguments: SendMoneyArgumentModel(
                                          isBetweenAccounts: sendMoneyArgument
                                              .isBetweenAccounts,
                                          isWithinDhabi:
                                              sendMoneyArgument.isWithinDhabi,
                                          isRemittance:
                                              sendMoneyArgument.isRemittance,
                                          isRetail: sendMoneyArgument.isRetail,
                                        ).toMap(),
                                      );
                                    }
                                  } else {
                                    bool isAuthenticated = await BiometricHelper
                                        .authenticateUser();
                                    if (!isAuthenticated) {
                                      // Navigate to sm password
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.password,
                                          arguments: SendMoneyArgumentModel(
                                            isBetweenAccounts: sendMoneyArgument
                                                .isBetweenAccounts,
                                            isWithinDhabi:
                                                sendMoneyArgument.isWithinDhabi,
                                            isRemittance:
                                                sendMoneyArgument.isRemittance,
                                            isRetail:
                                                sendMoneyArgument.isRetail,
                                          ).toMap(),
                                        );
                                      }
                                    } else {
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
                                        "uniqueId": DateTime.now()
                                            .millisecondsSinceEpoch,
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
                                          "remittancePurpose": ValueToKey
                                              .mapPurposeCodeValueToKey(
                                                  chosenPurposeCode),
                                          "fees": fees.toString(),
                                          "chargesCode": chosenChargeCode,
                                          "uniqueId": DateTime.now()
                                              .millisecondsSinceEpoch,
                                          "hash": EncryptDecrypt.encrypt(
                                              "${DateTime.now().millisecondsSinceEpoch}"),
                                          "isSwiftTransfer": isTerraPaySupported
                                              ? false
                                              : true,
                                        },
                                        token ?? "",
                                      );
                                      log("makeIntFundTransferApiRes -> $makeIntFundTransferApiRes");
                                      if (makeIntFundTransferApiRes[
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
                                                }
                                              },
                                              buttonTextSecondary: "Go Home",
                                              onTapSecondary: () {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  Routes.businessDashboard,
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
                                    }
                                  }
                                }
                              } else {
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
                                        iconPath:
                                            ImageConstants.checkCircleOutlined,
                                        title: "Success!",
                                        message:
                                            "Your transaction has been completed\n\nTransfer reference: ${makeIntFundTransferApiRes["ftReferenceNumber"]}",
                                        buttonText: "Make Another Transaction",
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
                                                    ["body"]["accountDetails"];
                                            Navigator.pushNamed(
                                              context,
                                              Routes.sendMoneyFrom,
                                              arguments: SendMoneyArgumentModel(
                                                isBetweenAccounts:
                                                    sendMoneyArgument
                                                        .isBetweenAccounts,
                                                isWithinDhabi: sendMoneyArgument
                                                    .isWithinDhabi,
                                                isRemittance: sendMoneyArgument
                                                    .isRemittance,
                                                isRetail:
                                                    sendMoneyArgument.isRetail,
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
                                          svgAssetPath: ImageConstants.warning,
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
                                // log("corpRemittanceApi Request -> ${{
                                //   "quotationId": quotationId,
                                //   "sourceCurrency": senderCurrency,
                                //   "targetCurrency": receiverCurrency,
                                //   "countryCode": beneficiaryCountryCode,
                                //   "debitAccount": senderAccountNumber,
                                //   "debitAmount": receiverAmount.toString(),
                                //   "transferAmount": senderAmount.toString(),
                                //   "benBankCode": benBankCode,
                                //   "benMobileNo": benMobileNo,
                                //   "benSubBankCode": benSubBankCode,
                                //   "accountType":
                                //       isBankSelected ? "Account" : "Wallet",
                                //   "benIdType": benIdType,
                                //   "benIdNo": benIdNo,
                                //   "benIdExpiryDate": benIdExpiryDate,
                                //   "benBankName": benBankName,
                                //   "benAccountNo": receiverAccountNumber,
                                //   "benCustomerName": benCustomerName,
                                //   "address": benAddress,
                                //   "city": benCity,
                                //   "swiftCode": benSwiftCode,
                                //   "remittancePurpose": remittancePurpose ?? "",
                                //   "sourceOfFunds": sourceOfFunds ?? "",
                                //   "relation": relation ?? "",
                                //   "providerName": providerName ?? "",
                                //   "uniqueId":
                                //       DateTime.now().millisecondsSinceEpoch,
                                //   "hash": EncryptDecrypt.encrypt(
                                //       "${DateTime.now().millisecondsSinceEpoch}"),
                                // }}");
                                // var corpRemittanceApiResult =
                                //     await MapForeignMoneyTransfer
                                //         .mapForeignMoneyTransfer(
                                //   {
                                //     "quotationId": quotationId,
                                //     "sourceCurrency": senderCurrency,
                                //     "targetCurrency": receiverCurrency,
                                //     "countryCode": beneficiaryCountryCode,
                                //     "debitAccount": senderAccountNumber,
                                //     "debitAmount": senderAmount.toString(),
                                //     "transferAmount": receiverAmount.toString(),
                                //     "benBankCode": benBankCode,
                                //     "benMobileNo": benMobileNo,
                                //     "benSubBankCode": benSubBankCode,
                                //     "accountType":
                                //         isBankSelected ? "Account" : "Wallet",
                                //     "benIdType": benIdType,
                                //     "benIdNo": benIdNo,
                                //     "benIdExpiryDate": benIdExpiryDate,
                                //     "benBankName": benBankName,
                                //     "benAccountNo": receiverAccountNumber,
                                //     "benCustomerName": benCustomerName,
                                //     "address": benAddress,
                                //     "city": benCity,
                                //     "swiftCode": benSwiftCode,
                                //     "remittancePurpose":
                                //         remittancePurpose ?? "",
                                //     "sourceOfFunds": sourceOfFunds ?? "",
                                //     "relation": relation ?? "",
                                //     "providerName": providerName ?? "",
                                //     "uniqueId":
                                //         DateTime.now().millisecondsSinceEpoch,
                                //     "hash": EncryptDecrypt.encrypt(
                                //         "${DateTime.now().millisecondsSinceEpoch}"),
                                //   },
                                //   token ?? "",
                                // );
                                // log("corpRemittanceApiResult -> $corpRemittanceApiResult");

                                // if (corpRemittanceApiResult["success"]) {
                                //   if (isAddRemBeneficiary) {
                                //     log("create beneficiary request -> ${{
                                //       "beneficiaryType":
                                //           !isBankSelected ? 5 : 2,
                                //       "accountNumber":
                                //           !isWalletSelected || benIdType == "2"
                                //               ? receiverAccountNumber
                                //               : walletNumber.isEmpty
                                //                   ? benMobileNo
                                //                   : walletNumber,
                                //       "name": benCustomerName,
                                //       "address": benAddress,
                                //       "accountType": benAccountType,
                                //       "swiftReference": 0,
                                //       "targetCurrency": receiverCurrency,
                                //       "countryCode": beneficiaryCountryCode,
                                //       "benBankCode": benBankCode,
                                //       "benMobileNo": benMobileNo,
                                //       "benSubBankCode": benSubBankCode,
                                //       "benIdType": benIdType,
                                //       "benIdNo": benIdNo,
                                //       "benIdExpiryDate": benIdExpiryDate,
                                //       "benBankName": benBankName,
                                //       "benSwiftCodeText": benSwiftCode,
                                //       "city": benCity,
                                //       "remittancePurpose":
                                //           remittancePurpose ?? "",
                                //       "sourceOfFunds": sourceOfFunds ?? "",
                                //       "relation": relation ?? "",
                                //       "providerName": providerName ?? "",
                                //     }}");

                                //     var createBeneficiaryAPiResult =
                                //         await MapCreateBeneficiary
                                //             .mapCreateBeneficiary(
                                //       {
                                //         "beneficiaryType":
                                //             !isBankSelected ? 5 : 2,
                                //         "accountNumber": !isWalletSelected ||
                                //                 benIdType == "2"
                                //             ? receiverAccountNumber
                                //             : walletNumber.isEmpty
                                //                 ? benMobileNo
                                //                 : walletNumber,
                                //         "name": benCustomerName,
                                //         "address": benAddress,
                                //         "accountType": benAccountType,
                                //         "swiftReference": 0,
                                //         "targetCurrency": receiverCurrency,
                                //         "countryCode": beneficiaryCountryCode,
                                //         "benBankCode": benBankCode,
                                //         "benMobileNo": benMobileNo,
                                //         "benSubBankCode": benSubBankCode,
                                //         "benIdType": benIdType,
                                //         "benIdNo": benIdNo,
                                //         "benIdExpiryDate": benIdExpiryDate,
                                //         "benBankName": benBankName,
                                //         "benSwiftCodeText": benSwiftCode,
                                //         "city": benCity,
                                //         "remittancePurpose":
                                //             remittancePurpose ?? "",
                                //         "sourceOfFunds": sourceOfFunds ?? "",
                                //         "relation": relation ?? "",
                                //         "providerName": providerName ?? "",
                                //       },
                                //       token ?? "",
                                //     );

                                //     log("createBeneficiaryAPiResult -> $createBeneficiaryAPiResult");

                                //     if (createBeneficiaryAPiResult["success"]) {
                                //       if (context.mounted) {
                                //         Navigator.pushNamed(
                                //           context,
                                //           Routes.errorSuccessScreen,
                                //           arguments: ErrorArgumentModel(
                                //             hasSecondaryButton: true,
                                //             iconPath: ImageConstants
                                //                 .checkCircleOutlined,
                                //             title: corpRemittanceApiResult[
                                //                     "isDirectlyCreated"]
                                //                 ? "Success!"
                                //                 : "Foreign Transfer Request Placed",
                                //             message: corpRemittanceApiResult[
                                //                     "isDirectlyCreated"]
                                //                 ? "Your transaction has been completed\n\nTransfer reference: ${corpRemittanceApiResult["reference"]}"
                                //                 : "${messages[121]["messageText"]}: ${corpRemittanceApiResult["reference"]}",
                                //             buttonTextSecondary: "Go Home",
                                //             onTapSecondary: () {
                                //               Navigator.pushNamedAndRemoveUntil(
                                //                 context,
                                //                 Routes.businessDashboard,
                                //                 (route) => false,
                                //                 arguments:
                                //                     RetailDashboardArgumentModel(
                                //                   imgUrl:
                                //                       storageProfilePhotoBase64 ??
                                //                           "",
                                //                   name: profileName ?? "",
                                //                   isFirst:
                                //                       storageIsFirstLogin ==
                                //                               true
                                //                           ? false
                                //                           : true,
                                //                 ).toMap(),
                                //               );
                                //             },
                                //             buttonText:
                                //                 "Make Another Transaction",
                                //             onTap: () async {
                                //               var corpCustPermApiResult =
                                //                   await MapCorporateCustomerPermissions
                                //                       .mapCorporateCustomerPermissions(
                                //                           token ?? "");
                                //               if (corpCustPermApiResult[
                                //                   "success"]) {
                                //                 fdSeedAccounts.clear();
                                //                 internalSeedAccounts.clear();
                                //                 dhabiSeedAccounts.clear();
                                //                 foreignSeedAccounts.clear();
                                //                 for (var permission
                                //                     in corpCustPermApiResult[
                                //                         "permissions"]) {
                                //                   if (permission[
                                //                       "canCreateFD"]) {
                                //                     fdSeedAccounts.add(
                                //                       SeedAccount(
                                //                         accountNumber:
                                //                             permission[
                                //                                 "accountNumber"],
                                //                         threshold: permission[
                                //                                 "fdCreationThreshold"]
                                //                             .toDouble(),
                                //                         currency: permission[
                                //                             "currency"],
                                //                         bal: double.parse(
                                //                                 permission[
                                //                                         "currentBalance"]
                                //                                     .split(" ")
                                //                                     .last
                                //                                     .replaceAll(
                                //                                         ',',
                                //                                         ''))
                                //                             .abs(),
                                //                         accountType: permission[
                                //                             "accountType"],
                                //                         currencyFlag: permission[
                                //                             "currencyFlagBase64"],
                                //                       ),
                                //                     );
                                //                   }
                                //                   if (permission[
                                //                       "canTransferInternalFund"]) {
                                //                     internalSeedAccounts.add(
                                //                       SeedAccount(
                                //                         accountNumber:
                                //                             permission[
                                //                                 "accountNumber"],
                                //                         threshold: permission[
                                //                                 "internalFundTransferThreshold"]
                                //                             .toDouble(),
                                //                         currency: permission[
                                //                             "currency"],
                                //                         bal: double.parse(
                                //                             permission[
                                //                                     "currentBalance"]
                                //                                 .split(" ")
                                //                                 .last
                                //                                 .replaceAll(
                                //                                     ',', '')),
                                //                         accountType: permission[
                                //                             "accountType"],
                                //                         currencyFlag: permission[
                                //                             "currencyFlagBase64"],
                                //                       ),
                                //                     );
                                //                   }
                                //                   if (permission[
                                //                       "canTransferDhabiFund"]) {
                                //                     dhabiSeedAccounts.add(
                                //                       SeedAccount(
                                //                         accountNumber:
                                //                             permission[
                                //                                 "accountNumber"],
                                //                         threshold: permission[
                                //                                 "dhabiFundTransferThreshold"]
                                //                             .toDouble(),
                                //                         currency: permission[
                                //                             "currency"],
                                //                         bal: double.parse(
                                //                             permission[
                                //                                     "currentBalance"]
                                //                                 .split(" ")
                                //                                 .last
                                //                                 .replaceAll(
                                //                                     ',', '')),
                                //                         accountType: permission[
                                //                             "accountType"],
                                //                         currencyFlag: permission[
                                //                             "currencyFlagBase64"],
                                //                       ),
                                //                     );
                                //                   }
                                //                   if (permission[
                                //                       "canTransferInternationalFund"]) {
                                //                     foreignSeedAccounts.add(
                                //                       SeedAccount(
                                //                         accountNumber:
                                //                             permission[
                                //                                 "accountNumber"],
                                //                         threshold: permission[
                                //                                 "foreignFundTransferThreshold"]
                                //                             .toDouble(),
                                //                         currency: permission[
                                //                             "currency"],
                                //                         bal: double.parse(
                                //                             permission[
                                //                                     "currentBalance"]
                                //                                 .split(" ")
                                //                                 .last
                                //                                 .replaceAll(
                                //                                     ',', '')),
                                //                         accountType: permission[
                                //                             "accountType"],
                                //                         currencyFlag: permission[
                                //                             "currencyFlagBase64"],
                                //                       ),
                                //                     );
                                //                   }
                                //                 }

                                //                 canCreateSavingsAccount =
                                //                     corpCustPermApiResult[
                                //                         "canCreateSavingsAccount"];
                                //                 canCreateCurrentAccount =
                                //                     corpCustPermApiResult[
                                //                         "canCreateCurrentAccount"];

                                //                 canChangeAddress =
                                //                     corpCustPermApiResult[
                                //                         "canChangeAddress"];
                                //                 canChangeMobileNumber =
                                //                     corpCustPermApiResult[
                                //                         "canChangeMobileNumber"];
                                //                 canChangeEmailId =
                                //                     corpCustPermApiResult[
                                //                         "canChangeEmailId"];

                                //                 canUpdateKYC =
                                //                     corpCustPermApiResult[
                                //                         "canUpdateKYC"];
                                //                 canCloseAccount =
                                //                     corpCustPermApiResult[
                                //                         "canCloseAccount"];
                                //                 canRequestChequeBook =
                                //                     corpCustPermApiResult[
                                //                         "canRequestChequeBook"];
                                //                 canRequestCertificate =
                                //                     corpCustPermApiResult[
                                //                         "canRequestCertificate"];
                                //                 canRequestAccountStatement =
                                //                     corpCustPermApiResult[
                                //                         "canRequestAccountStatement"];
                                //                 canRequestCard =
                                //                     corpCustPermApiResult[
                                //                         "canRequestCard"];
                                //                 if (context.mounted) {
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);

                                //                   Navigator.pushNamed(
                                //                     context,
                                //                     Routes.sendMoneyFrom,
                                //                     arguments:
                                //                         SendMoneyArgumentModel(
                                //                       isBetweenAccounts:
                                //                           sendMoneyArgument
                                //                               .isBetweenAccounts,
                                //                       isWithinDhabi:
                                //                           sendMoneyArgument
                                //                               .isWithinDhabi,
                                //                       isRemittance:
                                //                           sendMoneyArgument
                                //                               .isRemittance,
                                //                       isRetail:
                                //                           sendMoneyArgument
                                //                               .isRetail,
                                //                     ).toMap(),
                                //                   );
                                //                 }
                                //               } else {
                                //                 if (context.mounted) {
                                //                   showDialog(
                                //                     context: context,
                                //                     builder: (context) {
                                //                       return CustomDialog(
                                //                         svgAssetPath:
                                //                             ImageConstants
                                //                                 .warning,
                                //                         title: "Sorry!",
                                //                         message: corpCustPermApiResult[
                                //                                 "message"] ??
                                //                             "Something went wrong, please try again later",
                                //                         actionWidget:
                                //                             GradientButton(
                                //                           onTap: () {
                                //                             Navigator.pop(
                                //                                 context);
                                //                           },
                                //                           text: labels[346]
                                //                               ["labelText"],
                                //                         ),
                                //                       );
                                //                     },
                                //                   );
                                //                 }
                                //               }
                                //             },
                                //           ).toMap(),
                                //         );
                                //       }

                                //       isAddRemBeneficiary = false;
                                //       isNewRemittanceBeneficiary = false;
                                //     } else {
                                //       // addBenError =
                                //       //     "There was an issue adding Beneficiary";
                                //       if (context.mounted) {
                                //         Navigator.pushNamed(
                                //           context,
                                //           Routes.errorSuccessScreen,
                                //           arguments: ErrorArgumentModel(
                                //             hasSecondaryButton: true,
                                //             iconPath: ImageConstants
                                //                 .checkCircleOutlined,
                                //             title: corpRemittanceApiResult[
                                //                     "isDirectlyCreated"]
                                //                 ? "Success!"
                                //                 : "Foreign Transfer Request Placed",
                                //             message: corpRemittanceApiResult[
                                //                     "isDirectlyCreated"]
                                //                 ? "Your transaction has been completed\n\nTransfer reference: ${corpRemittanceApiResult["reference"]}\n\n$addBenError"
                                //                 : "${messages[121]["messageText"]}: ${corpRemittanceApiResult["reference"]}\n\n$addBenError",
                                //             buttonTextSecondary: "Go Home",
                                //             onTapSecondary: () {
                                //               Navigator.pushNamedAndRemoveUntil(
                                //                 context,
                                //                 Routes.businessDashboard,
                                //                 (route) => false,
                                //                 arguments:
                                //                     RetailDashboardArgumentModel(
                                //                   imgUrl:
                                //                       storageProfilePhotoBase64 ??
                                //                           "",
                                //                   name: profileName ?? "",
                                //                   isFirst:
                                //                       storageIsFirstLogin ==
                                //                               true
                                //                           ? false
                                //                           : true,
                                //                 ).toMap(),
                                //               );
                                //             },
                                //             buttonText:
                                //                 "Make Another Transaction",
                                //             onTap: () async {
                                //               var corpCustPermApiResult =
                                //                   await MapCorporateCustomerPermissions
                                //                       .mapCorporateCustomerPermissions(
                                //                           token ?? "");
                                //               if (corpCustPermApiResult[
                                //                   "success"]) {
                                //                 fdSeedAccounts.clear();
                                //                 internalSeedAccounts.clear();
                                //                 dhabiSeedAccounts.clear();
                                //                 foreignSeedAccounts.clear();
                                //                 for (var permission
                                //                     in corpCustPermApiResult[
                                //                         "permissions"]) {
                                //                   if (permission[
                                //                       "canCreateFD"]) {
                                //                     fdSeedAccounts.add(
                                //                       SeedAccount(
                                //                         accountNumber:
                                //                             permission[
                                //                                 "accountNumber"],
                                //                         threshold: permission[
                                //                                 "fdCreationThreshold"]
                                //                             .toDouble(),
                                //                         currency: permission[
                                //                             "currency"],
                                //                         bal: double.parse(
                                //                                 permission[
                                //                                         "currentBalance"]
                                //                                     .split(" ")
                                //                                     .last
                                //                                     .replaceAll(
                                //                                         ',',
                                //                                         ''))
                                //                             .abs(),
                                //                         accountType: permission[
                                //                             "accountType"],
                                //                         currencyFlag: permission[
                                //                             "currencyFlagBase64"],
                                //                       ),
                                //                     );
                                //                   }
                                //                   if (permission[
                                //                       "canTransferInternalFund"]) {
                                //                     internalSeedAccounts.add(
                                //                       SeedAccount(
                                //                         accountNumber:
                                //                             permission[
                                //                                 "accountNumber"],
                                //                         threshold: permission[
                                //                                 "internalFundTransferThreshold"]
                                //                             .toDouble(),
                                //                         currency: permission[
                                //                             "currency"],
                                //                         bal: double.parse(
                                //                             permission[
                                //                                     "currentBalance"]
                                //                                 .split(" ")
                                //                                 .last
                                //                                 .replaceAll(
                                //                                     ',', '')),
                                //                         accountType: permission[
                                //                             "accountType"],
                                //                         currencyFlag: permission[
                                //                             "currencyFlagBase64"],
                                //                       ),
                                //                     );
                                //                   }
                                //                   if (permission[
                                //                       "canTransferDhabiFund"]) {
                                //                     dhabiSeedAccounts.add(
                                //                       SeedAccount(
                                //                         accountNumber:
                                //                             permission[
                                //                                 "accountNumber"],
                                //                         threshold: permission[
                                //                                 "dhabiFundTransferThreshold"]
                                //                             .toDouble(),
                                //                         currency: permission[
                                //                             "currency"],
                                //                         bal: double.parse(
                                //                             permission[
                                //                                     "currentBalance"]
                                //                                 .split(" ")
                                //                                 .last
                                //                                 .replaceAll(
                                //                                     ',', '')),
                                //                         accountType: permission[
                                //                             "accountType"],
                                //                         currencyFlag: permission[
                                //                             "currencyFlagBase64"],
                                //                       ),
                                //                     );
                                //                   }
                                //                   if (permission[
                                //                       "canTransferInternationalFund"]) {
                                //                     foreignSeedAccounts.add(
                                //                       SeedAccount(
                                //                         accountNumber:
                                //                             permission[
                                //                                 "accountNumber"],
                                //                         threshold: permission[
                                //                                 "foreignFundTransferThreshold"]
                                //                             .toDouble(),
                                //                         currency: permission[
                                //                             "currency"],
                                //                         bal: double.parse(
                                //                             permission[
                                //                                     "currentBalance"]
                                //                                 .split(" ")
                                //                                 .last
                                //                                 .replaceAll(
                                //                                     ',', '')),
                                //                         accountType: permission[
                                //                             "accountType"],
                                //                         currencyFlag: permission[
                                //                             "currencyFlagBase64"],
                                //                       ),
                                //                     );
                                //                   }
                                //                 }

                                //                 canCreateSavingsAccount =
                                //                     corpCustPermApiResult[
                                //                         "canCreateSavingsAccount"];
                                //                 canCreateCurrentAccount =
                                //                     corpCustPermApiResult[
                                //                         "canCreateCurrentAccount"];

                                //                 canChangeAddress =
                                //                     corpCustPermApiResult[
                                //                         "canChangeAddress"];
                                //                 canChangeMobileNumber =
                                //                     corpCustPermApiResult[
                                //                         "canChangeMobileNumber"];
                                //                 canChangeEmailId =
                                //                     corpCustPermApiResult[
                                //                         "canChangeEmailId"];

                                //                 canUpdateKYC =
                                //                     corpCustPermApiResult[
                                //                         "canUpdateKYC"];
                                //                 canCloseAccount =
                                //                     corpCustPermApiResult[
                                //                         "canCloseAccount"];
                                //                 canRequestChequeBook =
                                //                     corpCustPermApiResult[
                                //                         "canRequestChequeBook"];
                                //                 canRequestCertificate =
                                //                     corpCustPermApiResult[
                                //                         "canRequestCertificate"];
                                //                 canRequestAccountStatement =
                                //                     corpCustPermApiResult[
                                //                         "canRequestAccountStatement"];
                                //                 canRequestCard =
                                //                     corpCustPermApiResult[
                                //                         "canRequestCard"];
                                //                 if (context.mounted) {
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);

                                //                   Navigator.pushNamed(
                                //                     context,
                                //                     Routes.sendMoneyFrom,
                                //                     arguments:
                                //                         SendMoneyArgumentModel(
                                //                       isBetweenAccounts:
                                //                           sendMoneyArgument
                                //                               .isBetweenAccounts,
                                //                       isWithinDhabi:
                                //                           sendMoneyArgument
                                //                               .isWithinDhabi,
                                //                       isRemittance:
                                //                           sendMoneyArgument
                                //                               .isRemittance,
                                //                       isRetail:
                                //                           sendMoneyArgument
                                //                               .isRetail,
                                //                     ).toMap(),
                                //                   );
                                //                 }
                                //               } else {
                                //                 if (context.mounted) {
                                //                   showDialog(
                                //                     context: context,
                                //                     builder: (context) {
                                //                       return CustomDialog(
                                //                         svgAssetPath:
                                //                             ImageConstants
                                //                                 .warning,
                                //                         title: "Sorry!",
                                //                         message: corpCustPermApiResult[
                                //                                 "message"] ??
                                //                             "Something went wrong, please try again later",
                                //                         actionWidget:
                                //                             GradientButton(
                                //                           onTap: () {
                                //                             Navigator.pop(
                                //                                 context);
                                //                           },
                                //                           text: labels[346]
                                //                               ["labelText"],
                                //                         ),
                                //                       );
                                //                     },
                                //                   );
                                //                 }
                                //               }
                                //             },
                                //           ).toMap(),
                                //         );
                                //       }
                                //       // if (context.mounted) {
                                //       //   showDialog(
                                //       //     context: context,
                                //       //     builder: (context) {
                                //       //       return CustomDialog(
                                //       //         svgAssetPath:
                                //       //             ImageConstants.warning,
                                //       //         title: "Sorry!",
                                //       //         message: createBeneficiaryAPiResult[
                                //       //                 "message"] ??
                                //       //             "Something went wrong while adding beneficiary, please try again later",
                                //       //         actionWidget: GradientButton(
                                //       //           onTap: () {
                                //       //             Navigator.pop(context);
                                //       //           },
                                //       //           text: labels[346]["labelText"],
                                //       //         ),
                                //       //       );
                                //       //     },
                                //       //   );
                                //       // }
                                //     }
                                //   } else {
                                //     if (context.mounted) {
                                //       Navigator.pushNamed(
                                //         context,
                                //         Routes.errorSuccessScreen,
                                //         arguments: ErrorArgumentModel(
                                //           hasSecondaryButton: true,
                                //           iconPath: ImageConstants
                                //               .checkCircleOutlined,
                                //           title: corpRemittanceApiResult[
                                //                   "isDirectlyCreated"]
                                //               ? "Success!"
                                //               : "Foreign Transfer Request Placed",
                                //           message: corpRemittanceApiResult[
                                //                   "isDirectlyCreated"]
                                //               ? "Your transaction has been completed\n\nTransfer reference: ${corpRemittanceApiResult["reference"]}"
                                //               : "${messages[121]["messageText"]}: ${corpRemittanceApiResult["reference"]}",
                                //           buttonTextSecondary: "Go Home",
                                //           onTapSecondary: () {
                                //             Navigator.pushNamedAndRemoveUntil(
                                //               context,
                                //               Routes.businessDashboard,
                                //               (route) => false,
                                //               arguments:
                                //                   RetailDashboardArgumentModel(
                                //                 imgUrl:
                                //                     storageProfilePhotoBase64 ??
                                //                         "",
                                //                 name: profileName ?? "",
                                //                 isFirst:
                                //                     storageIsFirstLogin == true
                                //                         ? false
                                //                         : true,
                                //               ).toMap(),
                                //             );
                                //           },
                                //           buttonText:
                                //               "Make Another Transaction",
                                //           onTap: () async {
                                //             var corpCustPermApiResult =
                                //                 await MapCorporateCustomerPermissions
                                //                     .mapCorporateCustomerPermissions(
                                //                         token ?? "");
                                //             if (corpCustPermApiResult[
                                //                 "success"]) {
                                //               fdSeedAccounts.clear();
                                //               internalSeedAccounts.clear();
                                //               dhabiSeedAccounts.clear();
                                //               foreignSeedAccounts.clear();
                                //               for (var permission
                                //                   in corpCustPermApiResult[
                                //                       "permissions"]) {
                                //                 if (permission["canCreateFD"]) {
                                //                   fdSeedAccounts.add(
                                //                     SeedAccount(
                                //                       accountNumber: permission[
                                //                           "accountNumber"],
                                //                       threshold: permission[
                                //                               "fdCreationThreshold"]
                                //                           .toDouble(),
                                //                       currency: permission[
                                //                           "currency"],
                                //                       bal: double.parse(permission[
                                //                                   "currentBalance"]
                                //                               .split(" ")
                                //                               .last
                                //                               .replaceAll(
                                //                                   ',', ''))
                                //                           .abs(),
                                //                       accountType: permission[
                                //                           "accountType"],
                                //                       currencyFlag: permission[
                                //                           "currencyFlagBase64"],
                                //                     ),
                                //                   );
                                //                 }
                                //                 if (permission[
                                //                     "canTransferInternalFund"]) {
                                //                   internalSeedAccounts.add(
                                //                     SeedAccount(
                                //                       accountNumber: permission[
                                //                           "accountNumber"],
                                //                       threshold: permission[
                                //                               "internalFundTransferThreshold"]
                                //                           .toDouble(),
                                //                       currency: permission[
                                //                           "currency"],
                                //                       bal: double.parse(permission[
                                //                               "currentBalance"]
                                //                           .split(" ")
                                //                           .last
                                //                           .replaceAll(',', '')),
                                //                       accountType: permission[
                                //                           "accountType"],
                                //                       currencyFlag: permission[
                                //                           "currencyFlagBase64"],
                                //                     ),
                                //                   );
                                //                 }
                                //                 if (permission[
                                //                     "canTransferDhabiFund"]) {
                                //                   dhabiSeedAccounts.add(
                                //                     SeedAccount(
                                //                       accountNumber: permission[
                                //                           "accountNumber"],
                                //                       threshold: permission[
                                //                               "dhabiFundTransferThreshold"]
                                //                           .toDouble(),
                                //                       currency: permission[
                                //                           "currency"],
                                //                       bal: double.parse(permission[
                                //                               "currentBalance"]
                                //                           .split(" ")
                                //                           .last
                                //                           .replaceAll(',', '')),
                                //                       accountType: permission[
                                //                           "accountType"],
                                //                       currencyFlag: permission[
                                //                           "currencyFlagBase64"],
                                //                     ),
                                //                   );
                                //                 }
                                //                 if (permission[
                                //                     "canTransferInternationalFund"]) {
                                //                   foreignSeedAccounts.add(
                                //                     SeedAccount(
                                //                       accountNumber: permission[
                                //                           "accountNumber"],
                                //                       threshold: permission[
                                //                               "foreignFundTransferThreshold"]
                                //                           .toDouble(),
                                //                       currency: permission[
                                //                           "currency"],
                                //                       bal: double.parse(permission[
                                //                               "currentBalance"]
                                //                           .split(" ")
                                //                           .last
                                //                           .replaceAll(',', '')),
                                //                       accountType: permission[
                                //                           "accountType"],
                                //                       currencyFlag: permission[
                                //                           "currencyFlagBase64"],
                                //                     ),
                                //                   );
                                //                 }
                                //               }

                                //               canCreateSavingsAccount =
                                //                   corpCustPermApiResult[
                                //                       "canCreateSavingsAccount"];
                                //               canCreateCurrentAccount =
                                //                   corpCustPermApiResult[
                                //                       "canCreateCurrentAccount"];

                                //               canChangeAddress =
                                //                   corpCustPermApiResult[
                                //                       "canChangeAddress"];
                                //               canChangeMobileNumber =
                                //                   corpCustPermApiResult[
                                //                       "canChangeMobileNumber"];
                                //               canChangeEmailId =
                                //                   corpCustPermApiResult[
                                //                       "canChangeEmailId"];

                                //               canUpdateKYC =
                                //                   corpCustPermApiResult[
                                //                       "canUpdateKYC"];
                                //               canCloseAccount =
                                //                   corpCustPermApiResult[
                                //                       "canCloseAccount"];
                                //               canRequestChequeBook =
                                //                   corpCustPermApiResult[
                                //                       "canRequestChequeBook"];
                                //               canRequestCertificate =
                                //                   corpCustPermApiResult[
                                //                       "canRequestCertificate"];
                                //               canRequestAccountStatement =
                                //                   corpCustPermApiResult[
                                //                       "canRequestAccountStatement"];
                                //               canRequestCard =
                                //                   corpCustPermApiResult[
                                //                       "canRequestCard"];
                                //               if (context.mounted) {
                                //                 Navigator.pop(context);
                                //                 Navigator.pop(context);
                                //                 Navigator.pop(context);
                                //                 Navigator.pop(context);
                                //                 Navigator.pop(context);
                                //                 // Navigator.pop(context);
                                //                 Navigator.pop(context);
                                //                 // Navigator.pop(context);

                                //                 Navigator.pushNamed(
                                //                   context,
                                //                   Routes.sendMoneyFrom,
                                //                   arguments:
                                //                       SendMoneyArgumentModel(
                                //                     isBetweenAccounts:
                                //                         sendMoneyArgument
                                //                             .isBetweenAccounts,
                                //                     isWithinDhabi:
                                //                         sendMoneyArgument
                                //                             .isWithinDhabi,
                                //                     isRemittance:
                                //                         sendMoneyArgument
                                //                             .isRemittance,
                                //                     isRetail: sendMoneyArgument
                                //                         .isRetail,
                                //                   ).toMap(),
                                //                 );
                                //               }
                                //             } else {
                                //               if (context.mounted) {
                                //                 showDialog(
                                //                   context: context,
                                //                   builder: (context) {
                                //                     return CustomDialog(
                                //                       svgAssetPath:
                                //                           ImageConstants
                                //                               .warning,
                                //                       title: "Sorry!",
                                //                       message:
                                //                           corpCustPermApiResult[
                                //                                   "message"] ??
                                //                               "Something went wrong, please try again later",
                                //                       actionWidget:
                                //                           GradientButton(
                                //                         onTap: () {
                                //                           Navigator.pop(
                                //                               context);
                                //                         },
                                //                         text: labels[346]
                                //                             ["labelText"],
                                //                       ),
                                //                     );
                                //                   },
                                //                 );
                                //               }
                                //             }
                                //           },
                                //         ).toMap(),
                                //       );
                                //     }

                                //     isAddRemBeneficiary = false;
                                //     isNewRemittanceBeneficiary = false;
                                //   }
                                // } else {
                                //   if (context.mounted) {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return CustomDialog(
                                //           svgAssetPath: ImageConstants.warning,
                                //           title: "Sorry!",
                                //           message: corpRemittanceApiResult[
                                //                   "message"] ??
                                //               "Something went wrong while remittance transfer, please try again later",
                                //           actionWidget: GradientButton(
                                //             onTap: () {
                                //               Navigator.pop(context);
                                //             },
                                //             text: labels[346]["labelText"],
                                //           ),
                                //         );
                                //       },
                                //     );
                                //   }
                                // }
                              }
                            } else {
                              if (isNewWithinDhabiBeneficiary) {
                                bool isBioCapable = await LocalAuthentication()
                                    .canCheckBiometrics;
                                if (!isBioCapable) {
                                  // navigate to pwd screen
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.password,
                                      arguments: SendMoneyArgumentModel(
                                        isBetweenAccounts:
                                            sendMoneyArgument.isBetweenAccounts,
                                        isWithinDhabi:
                                            sendMoneyArgument.isWithinDhabi,
                                        isRemittance:
                                            sendMoneyArgument.isRemittance,
                                        isRetail: sendMoneyArgument.isRetail,
                                      ).toMap(),
                                    );
                                  }
                                } else {
                                  List availableBios =
                                      await LocalAuthentication()
                                          .getAvailableBiometrics();
                                  if (availableBios.isEmpty ||
                                      persistBiometric != true) {
                                    // navigate to pwd screen
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.password,
                                        arguments: SendMoneyArgumentModel(
                                          isBetweenAccounts: sendMoneyArgument
                                              .isBetweenAccounts,
                                          isWithinDhabi:
                                              sendMoneyArgument.isWithinDhabi,
                                          isRemittance:
                                              sendMoneyArgument.isRemittance,
                                          isRetail: sendMoneyArgument.isRetail,
                                        ).toMap(),
                                      );
                                    }
                                  } else {
                                    bool isAuthenticated = await BiometricHelper
                                        .authenticateUser();
                                    if (!isAuthenticated) {
                                      // navigate to pwd screen
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.password,
                                          arguments: SendMoneyArgumentModel(
                                            isBetweenAccounts: sendMoneyArgument
                                                .isBetweenAccounts,
                                            isWithinDhabi:
                                                sendMoneyArgument.isWithinDhabi,
                                            isRemittance:
                                                sendMoneyArgument.isRemittance,
                                            isRetail:
                                                sendMoneyArgument.isRetail,
                                          ).toMap(),
                                        );
                                      }
                                    } else {
                                      log("corpDhabiMoneyTransferApiResult Request -> ${{
                                        "debitAccount": senderAccountNumber,
                                        "creditAccount": receiverAccountNumber,
                                        "debitAmount": senderAmount.toString(),
                                        "currency": senderCurrency,
                                        "beneficiaryName": benCustomerName,
                                        "uniqueId": DateTime.now()
                                            .millisecondsSinceEpoch,
                                        "hash": EncryptDecrypt.encrypt(
                                            "${DateTime.now().millisecondsSinceEpoch}"),
                                      }}");
                                      var corpDhabiMoneyTransferApiResult =
                                          await MapDhabiMoneyTransfer
                                              .mapDhabiMoneyTransfer(
                                        {
                                          "debitAccount": senderAccountNumber,
                                          "creditAccount":
                                              receiverAccountNumber,
                                          "debitAmount":
                                              senderAmount.toString(),
                                          "currency": senderCurrency,
                                          "beneficiaryName": benCustomerName,
                                          "uniqueId": DateTime.now()
                                              .millisecondsSinceEpoch,
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
                                            "accountNumber":
                                                !isWalletSelected ||
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
                                            "sourceOfFunds":
                                                sourceOfFunds ?? "",
                                            "relation": relation ?? "",
                                            "providerName": providerName ?? "",
                                          }}");

                                          var createBeneficiaryAPiResult =
                                              await MapCreateBeneficiary
                                                  .mapCreateBeneficiary(
                                            {
                                              "beneficiaryType": 3,
                                              "accountNumber":
                                                  !isWalletSelected ||
                                                          benIdType == "2"
                                                      ? receiverAccountNumber
                                                      : walletNumber.isEmpty
                                                          ? benMobileNo
                                                          : walletNumber,
                                              "name": benCustomerName,
                                              "address": benAddress,
                                              "accountType": benAccountType,
                                              "swiftReference": 0,
                                              "targetCurrency":
                                                  receiverCurrency,
                                              "countryCode": "AE",
                                              "benBankCode": benBankCode,
                                              "benMobileNo": benMobileNo,
                                              "benSubBankCode": benSubBankCode,
                                              "benIdType": benIdType,
                                              "benIdNo": benIdNo,
                                              "benIdExpiryDate":
                                                  benIdExpiryDate,
                                              "benBankName": benBankName,
                                              "benSwiftCodeText": benSwiftCode,
                                              "city": benCity,
                                              "remittancePurpose":
                                                  remittancePurpose ?? "",
                                              "sourceOfFunds":
                                                  sourceOfFunds ?? "",
                                              "relation": relation ?? "",
                                              "providerName":
                                                  providerName ?? "",
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
                                                  buttonTextSecondary:
                                                      "Go Home",
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
                                                      internalSeedAccounts
                                                          .clear();
                                                      dhabiSeedAccounts.clear();
                                                      foreignSeedAccounts
                                                          .clear();
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
                                                              currency:
                                                                  permission[
                                                                      "currency"],
                                                              bal: double.parse(permission[
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
                                                              currencyFlag:
                                                                  permission[
                                                                      "currencyFlagBase64"],
                                                            ),
                                                          );
                                                        }
                                                        if (permission[
                                                            "canTransferInternalFund"]) {
                                                          internalSeedAccounts
                                                              .add(
                                                            SeedAccount(
                                                              accountNumber:
                                                                  permission[
                                                                      "accountNumber"],
                                                              threshold: permission[
                                                                      "internalFundTransferThreshold"]
                                                                  .toDouble(),
                                                              currency:
                                                                  permission[
                                                                      "currency"],
                                                              bal: double.parse(
                                                                  permission[
                                                                          "currentBalance"]
                                                                      .split(
                                                                          " ")
                                                                      .last
                                                                      .replaceAll(
                                                                          ',',
                                                                          '')),
                                                              accountType:
                                                                  permission[
                                                                      "accountType"],
                                                              currencyFlag:
                                                                  permission[
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
                                                              currency:
                                                                  permission[
                                                                      "currency"],
                                                              bal: double.parse(
                                                                  permission[
                                                                          "currentBalance"]
                                                                      .split(
                                                                          " ")
                                                                      .last
                                                                      .replaceAll(
                                                                          ',',
                                                                          '')),
                                                              accountType:
                                                                  permission[
                                                                      "accountType"],
                                                              currencyFlag:
                                                                  permission[
                                                                      "currencyFlagBase64"],
                                                            ),
                                                          );
                                                        }
                                                        if (permission[
                                                            "canTransferInternationalFund"]) {
                                                          foreignSeedAccounts
                                                              .add(
                                                            SeedAccount(
                                                              accountNumber:
                                                                  permission[
                                                                      "accountNumber"],
                                                              threshold: permission[
                                                                      "foreignFundTransferThreshold"]
                                                                  .toDouble(),
                                                              currency:
                                                                  permission[
                                                                      "currency"],
                                                              bal: double.parse(
                                                                  permission[
                                                                          "currentBalance"]
                                                                      .split(
                                                                          " ")
                                                                      .last
                                                                      .replaceAll(
                                                                          ',',
                                                                          '')),
                                                              accountType:
                                                                  permission[
                                                                      "accountType"],
                                                              currencyFlag:
                                                                  permission[
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
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
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
                                                                      "message"]
                                                                  [
                                                                  "Something went wrong, please try again later"],
                                                              actionWidget:
                                                                  GradientButton(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                text: labels[
                                                                        346][
                                                                    "labelText"],
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
                                                    message:
                                                        createBeneficiaryAPiResult[
                                                                "message"] ??
                                                            "Something went wrong while adding beneficiary, please try again later",
                                                    actionWidget:
                                                        GradientButton(
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
                                                    internalSeedAccounts
                                                        .clear();
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
                                                            currency:
                                                                permission[
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
                                                            currencyFlag:
                                                                permission[
                                                                    "currencyFlagBase64"],
                                                          ),
                                                        );
                                                      }
                                                      if (permission[
                                                          "canTransferInternalFund"]) {
                                                        internalSeedAccounts
                                                            .add(
                                                          SeedAccount(
                                                            accountNumber:
                                                                permission[
                                                                    "accountNumber"],
                                                            threshold: permission[
                                                                    "internalFundTransferThreshold"]
                                                                .toDouble(),
                                                            currency:
                                                                permission[
                                                                    "currency"],
                                                            bal: double.parse(
                                                                permission[
                                                                        "currentBalance"]
                                                                    .split(" ")
                                                                    .last
                                                                    .replaceAll(
                                                                        ',',
                                                                        '')),
                                                            accountType:
                                                                permission[
                                                                    "accountType"],
                                                            currencyFlag:
                                                                permission[
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
                                                            currency:
                                                                permission[
                                                                    "currency"],
                                                            bal: double.parse(
                                                                permission[
                                                                        "currentBalance"]
                                                                    .split(" ")
                                                                    .last
                                                                    .replaceAll(
                                                                        ',',
                                                                        '')),
                                                            accountType:
                                                                permission[
                                                                    "accountType"],
                                                            currencyFlag:
                                                                permission[
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
                                                            currency:
                                                                permission[
                                                                    "currency"],
                                                            bal: double.parse(
                                                                permission[
                                                                        "currentBalance"]
                                                                    .split(" ")
                                                                    .last
                                                                    .replaceAll(
                                                                        ',',
                                                                        '')),
                                                            accountType:
                                                                permission[
                                                                    "accountType"],
                                                            currencyFlag:
                                                                permission[
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
                                                      } else {
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
                                                                text: labels[
                                                                        293][
                                                                    "labelText"],
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
                                      "accountNumber":
                                          !isWalletSelected || benIdType == "2"
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

                                    if (createBeneficiaryAPiResult["success"]) {
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
                                                  } else {
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
                                                text: labels[346]["labelText"],
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
                                            isAddWithinDhabiBeneficiary = false;
                                            isNewWithinDhabiBeneficiary = false;
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
                                                    storageIsFirstLogin == true
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
                                                if (permission["canCreateFD"]) {
                                                  fdSeedAccounts.add(
                                                    SeedAccount(
                                                      accountNumber: permission[
                                                          "accountNumber"],
                                                      threshold: permission[
                                                              "fdCreationThreshold"]
                                                          .toDouble(),
                                                      currency: permission[
                                                          "currency"],
                                                      bal: double.parse(permission[
                                                                  "currentBalance"]
                                                              .split(" ")
                                                              .last
                                                              .replaceAll(
                                                                  ',', ''))
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
                                                      accountNumber: permission[
                                                          "accountNumber"],
                                                      threshold: permission[
                                                              "internalFundTransferThreshold"]
                                                          .toDouble(),
                                                      currency: permission[
                                                          "currency"],
                                                      bal: double.parse(permission[
                                                              "currentBalance"]
                                                          .split(" ")
                                                          .last
                                                          .replaceAll(',', '')),
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
                                                      accountNumber: permission[
                                                          "accountNumber"],
                                                      threshold: permission[
                                                              "dhabiFundTransferThreshold"]
                                                          .toDouble(),
                                                      currency: permission[
                                                          "currency"],
                                                      bal: double.parse(permission[
                                                              "currentBalance"]
                                                          .split(" ")
                                                          .last
                                                          .replaceAll(',', '')),
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
                                                      accountNumber: permission[
                                                          "accountNumber"],
                                                      threshold: permission[
                                                              "foreignFundTransferThreshold"]
                                                          .toDouble(),
                                                      currency: permission[
                                                          "currency"],
                                                      bal: double.parse(permission[
                                                              "currentBalance"]
                                                          .split(" ")
                                                          .last
                                                          .replaceAll(',', '')),
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
                                                } else {
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
                                                    isRetail: sendMoneyArgument
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
                                                      message:
                                                          corpCustPermApiResult[
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
                                  }
                                } else {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomDialog(
                                          svgAssetPath: ImageConstants.warning,
                                          title: "Sorry!",
                                          message: corpDhabiMoneyTransferApiResult[
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
                          }

                          isTransferring = false;
                          showButtonBloc
                              .add(ShowButtonEvent(show: isTransferring));
                        }
                      },
                      text: labels[170]["labelText"],
                      auxWidget:
                          isTransferring ? const LoaderRow() : const SizeBox(),
                    );
                  },
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

  void biometricPrompt() async {
    bool isBiometricSupported = await LocalAuthentication().isDeviceSupported();

    if (!isBiometricSupported) {
      if (context.mounted) {
        Navigator.pushNamed(context, Routes.password);
      }
    } else {
      bool isAuthenticated = await BiometricHelper.authenticateUser();

      if (isAuthenticated) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.errorSuccessScreen,
            arguments: ErrorArgumentModel(
              hasSecondaryButton: true,
              iconPath: ImageConstants.checkCircleOutlined,
              title: "Success!",
              message: "Your transaction has been completed",
              buttonText: "Home",
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              buttonTextSecondary: "Make Another Transaction",
              onTapSecondary: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ).toMap(),
          );
        }
      } else {
        // TODO: Verify from client if they want a dialog box to enable biometric

        // OpenSettings.openBiometricEnrollSetting();
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(
        //         'Biometric Authentication failed.',
        //         style: TextStyles.primary.copyWith(
        //           fontSize: (12 / Dimensions.designWidth).w,
        //         ),
        //       ),
        //     ),
        //   );
        // }
      }
    }
  }
}
