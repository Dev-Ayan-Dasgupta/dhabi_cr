// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class SendMoneyToScreen extends StatefulWidget {
  const SendMoneyToScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SendMoneyToScreen> createState() => _SendMoneyToScreenState();
}

class _SendMoneyToScreenState extends State<SendMoneyToScreen> {
  int selectedAccountIndex = -1;

  bool isFetchingExchangeRate = false;

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
              labels[157]["labelText"],
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Text(
              "Please select an option from the list below",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.dark50,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            // Text(
            //   labels[4]["labelText"],
            //   style: TextStyles.primaryMedium.copyWith(
            //     color: AppColors.dark80,
            //     fontSize: (14 / Dimensions.designWidth).w,
            //   ),
            // ),
            // const SizeBox(height: 10),
            // VaultAccountCard(
            //   isVault: true,
            //   onTap: () {
            //     Navigator.pushNamed(context, Routes.transferAmount);
            //   },
            //   title: "Vault",
            //   imgUrl:
            //       "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
            //   accountNo: "1234567890987654",
            //   currency: "AED",
            //   amount: 25000,
            //   isSelected: false,
            // ),
            // const SizeBox(height: 30),
            Row(
              children: [
                Text(
                  labels[156]["labelText"],
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark80,
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
                const Asterisk(),
              ],
            ),
            const SizeBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: accountDetails.length,
                // sendMoneyArgument.isRetail
                //     ? accountDetails.length
                //     : corporateAccountDetails.length,
                itemBuilder: (context, index) {
                  return BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return Ternary(
                        condition: senderAccountNumber ==
                            accountDetails[index]["accountNumber"],
                        // sendMoneyArgument.isRetail
                        //     ? senderAccountNumber ==
                        //         accountDetails[index]["accountNumber"]
                        //     : senderAccountNumber ==
                        //         corporateAccountDetails[index]["accountNumber"],
                        truthy: const SizeBox(),
                        falsy: Padding(
                          padding: EdgeInsets.only(
                              bottom: (15 / Dimensions.designHeight).h),
                          child: VaultAccountCard(
                            isVault: false,
                            onTap: () {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              selectedAccountIndex = index;
                              receiverCurrencyFlag =
                                  accountDetails[index]["currencyFlagBase64"];
                              // sendMoneyArgument.isRetail
                              //     ? accountDetails[index]["currencyFlagBase64"]
                              //     : corporateAccountDetails[index]
                              //         ["currencyFlagBase64"];
                              receiverAccountNumber =
                                  accountDetails[index]["accountNumber"];
                              // sendMoneyArgument.isRetail
                              //     ? accountDetails[index]["accountNumber"]
                              //     : corporateAccountDetails[index]
                              //         ["accountNumber"];
                              receiverCurrency =
                                  accountDetails[index]["accountCurrency"];
                              // sendMoneyArgument.isRetail
                              //     ? accountDetails[index]["accountCurrency"]
                              //     : corporateAccountDetails[index]["currency"];
                              receiverCurrencyFlag = senderCurrencyFlag;
                              log("receiverAccountNumber -> $receiverAccountNumber");
                              showButtonBloc.add(ShowButtonEvent(
                                  show: selectedAccountIndex == index));
                            },
                            title:
                                accountDetails[index]["productCode"] == "1001"
                                    ? labels[7]["labelText"]
                                    : labels[92]["labelText"],
                            // sendMoneyArgument.isRetail
                            //     ? accountDetails[index]["productCode"] == "1001"
                            //         ? labels[7]["labelText"]
                            //         : labels[92]["labelText"]
                            //     : corporateAccountDetails[index]
                            //                 ["accountType"] ==
                            //             2
                            //         ? labels[7]["labelText"]
                            //         : labels[92]["labelText"],
                            accountNo: accountDetails[index]["accountNumber"],
                            // sendMoneyArgument.isRetail
                            //     ? accountDetails[index]["accountNumber"]
                            //     : corporateAccountDetails[index]
                            //         ["accountNumber"],
                            currency: accountDetails[index]["accountCurrency"],
                            // sendMoneyArgument.isRetail
                            //     ? accountDetails[index]["accountCurrency"]
                            //     : corporateAccountDetails[index]["currency"],
                            amount: double.parse(accountDetails[index]
                                            ["currentBalance"]
                                        .split(" ")
                                        .last
                                        .replaceAll(",", "")) >
                                    1000
                                ? NumberFormat('#,000.00').format(double.parse(
                                    accountDetails[index]["currentBalance"]
                                        .split(" ")
                                        .last
                                        .replaceAll(",", "")))
                                : double.parse(accountDetails[index]
                                            ["currentBalance"]
                                        .split(" ")
                                        .last
                                        .replaceAll(",", ""))
                                    .toStringAsFixed(2),
                            // sendMoneyArgument.isRetail
                            //     ? double.parse(accountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")) >
                            //             1000
                            //         ? NumberFormat('#,000.00').format(
                            //             double.parse(accountDetails[index]
                            //                     ["currentBalance"]
                            //                 .split(" ")
                            //                 .last
                            //                 .replaceAll(",", "")))
                            //         : double.parse(accountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", ""))
                            //             .toStringAsFixed(2)
                            //     : double.parse(corporateAccountDetails[index]
                            //                     ["currentBalance"]
                            //                 .split(" ")
                            //                 .last
                            //                 .replaceAll(",", "")) >
                            //             1000
                            //         ? NumberFormat('#,000.00').format(
                            //             double.parse(corporateAccountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")))
                            //         : double.parse(corporateAccountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")).toStringAsFixed(2),
                            isSelected: selectedAccountIndex == index,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Column(
              children: [
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (selectedAccountIndex == -1) {
                      return SolidButton(
                          onTap: () {}, text: labels[127]["labelText"]);
                    } else {
                      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: (context, state) {
                          return GradientButton(
                            onTap: () async {
                              if (!isFetchingExchangeRate) {
                                final ShowButtonBloc showButtonBloc =
                                    context.read<ShowButtonBloc>();
                                isFetchingExchangeRate = true;
                                showButtonBloc.add(ShowButtonEvent(
                                    show: isFetchingExchangeRate));

                                if (sendMoneyArgument.isRemittance) {
                                  var getExchRateApiResult =
                                      await MapExchangeRate.mapExchangeRate(
                                    token ?? "",
                                  );
                                  log("getExchRateApiResult -> $getExchRateApiResult");

                                  if (getExchRateApiResult["success"]) {
                                    for (var fetchExchangeRate
                                        in getExchRateApiResult[
                                            "fetchExRates"]) {
                                      if (fetchExchangeRate[
                                              "exchangeCurrency"] ==
                                          receiverCurrency) {
                                        exchangeRate =
                                            fetchExchangeRate["exchangeRate"]
                                                .toDouble();
                                        log("exchangeRate -> $exchangeRate");
                                        fees = double.parse(
                                            fetchExchangeRate["transferFee"]
                                                .split(' ')
                                                .last);
                                        log("fees -> $fees");
                                        expectedTime = getExchRateApiResult[
                                            "expectedTime"];
                                        break;
                                      }
                                    }

                                    if (context.mounted) {
                                      if (sendMoneyArgument.isBetweenAccounts) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.transferAmount,
                                          arguments: SendMoneyArgumentModel(
                                            isBetweenAccounts: true,
                                            isWithinDhabi: false,
                                            isRemittance: false,
                                            isRetail:
                                                sendMoneyArgument.isRetail,
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
                                            message: getExchRateApiResult[
                                                    "message"] ??
                                                "There was an error fetching exchange rate, please try again later.",
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
                                } else if (sendMoneyArgument
                                    .isBetweenAccounts) {
                                  exchangeRate = 1;
                                  log("exchangeRate -> $exchangeRate");
                                  Navigator.pushNamed(
                                    context,
                                    Routes.transferAmount,
                                    arguments: SendMoneyArgumentModel(
                                      isBetweenAccounts: true,
                                      isWithinDhabi: false,
                                      isRemittance: false,
                                      isRetail: sendMoneyArgument.isRetail,
                                    ).toMap(),
                                  );
                                } else if (sendMoneyArgument.isWithinDhabi) {
                                  exchangeRate = 1;
                                  log("exchangeRate -> $exchangeRate");
                                  Navigator.pushNamed(
                                    context,
                                    Routes.transferAmount,
                                    arguments: SendMoneyArgumentModel(
                                      isBetweenAccounts: false,
                                      isWithinDhabi: true,
                                      isRemittance: false,
                                      isRetail: sendMoneyArgument.isRetail,
                                    ).toMap(),
                                  );
                                }

                                isFetchingExchangeRate = false;
                                showButtonBloc.add(ShowButtonEvent(
                                    show: isFetchingExchangeRate));
                              }
                            },
                            text: labels[127]["labelText"],
                            auxWidget: isFetchingExchangeRate
                                ? const LoaderRow()
                                : const SizeBox(),
                          );
                        },
                      );
                    }
                  },
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
