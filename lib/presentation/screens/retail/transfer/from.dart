// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/vault_account_card.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class SendMoneyFromScreen extends StatefulWidget {
  const SendMoneyFromScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SendMoneyFromScreen> createState() => _SendMoneyFromScreenState();
}

class _SendMoneyFromScreenState extends State<SendMoneyFromScreen> {
  late SendMoneyArgumentModel sendMoneyArgument;

  int selectedAccountIndex = -1;

  final TextEditingController _sendCurrencyController = TextEditingController();
  final TextEditingController _receiveCurrencyController =
      TextEditingController();

  List<DropDownCountriesModel> exchangeCurrencies = [];
  DropDownCountriesModel? selectedCurrency;

  bool isInitiExchRates = false;

  Map<String, dynamic> getExchangeRateApi = {};

  double exRate = 0;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateExchangeRates();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> populateExchangeRates() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    try {
      isInitiExchRates = true;
      showButtonBloc.add(ShowButtonEvent(show: isInitiExchRates));
      getExchangeRateApi = await MapExchangeRate.mapExchangeRate(token ?? "");
      if (getExchangeRateApi["success"]) {
        exchangeCurrencies.clear();
        for (var currency in getExchangeRateApi["fetchExRates"]) {
          exchangeCurrencies.add(
            DropDownCountriesModel(
              countrynameOrCode: currency["exchangeCurrency"],
              countryFlagBase64: currency["currencyFlagBase64"],
              isEnabled: true,
            ),
          );
        }
        log("exchangeCurrencies -> $exchangeCurrencies");
        selectedCurrency = DropDownCountriesModel(
          countryFlagBase64: exchangeCurrencies[0].countryFlagBase64,
          countrynameOrCode: exchangeCurrencies[0].countrynameOrCode,
          isEnabled: exchangeCurrencies[0].isEnabled,
        );
        exRate =
            getExchangeRateApi["fetchExRates"][0]["exchangeRate"].toDouble();
        log("exRate -> $exRate");
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry!",
                message: getExchangeRateApi["message"] ??
                    "Error while getting exchange rate, please try again later",
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
      isInitiExchRates = false;
      showButtonBloc.add(ShowButtonEvent(show: isInitiExchRates));
    } catch (_) {
      rethrow;
    }
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
                  Text(
                    labels[155]["labelText"],
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
                  //     Navigator.pushNamed(context, Routes.sendMoneyTo);
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
                  // SizedBox(
                  //   height: (400 / Dimensions.designHeight).h,
                  //   child: Column(
                  //     children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: sendMoneyArgument.isRetail
                          ? accountDetails.length
                          : corporateAccountDetails.length,
                      separatorBuilder: (context, index) {
                        return const SizeBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          builder: (context, state) {
                            return VaultAccountCard(
                              isVault: false,
                              onTap: () {
                                final ShowButtonBloc showButtonBloc =
                                    context.read<ShowButtonBloc>();
                                selectedAccountIndex = index;
                                senderCurrencyFlag = sendMoneyArgument.isRetail
                                    ? accountDetails[index]
                                        ["currencyFlagBase64"]
                                    : corporateAccountDetails[index]
                                        ["currencyFlagBase64"];
                                senderAccountNumber = sendMoneyArgument.isRetail
                                    ? accountDetails[index]["accountNumber"]
                                    : corporateAccountDetails[index]
                                        ["accountNumber"];
                                senderCurrency = sendMoneyArgument.isRetail
                                    ? accountDetails[index]["accountCurrency"]
                                    : corporateAccountDetails[index]
                                        ["currency"];
                                senderBalance = sendMoneyArgument.isRetail
                                    ? double.parse(accountDetails[index]
                                            ["currentBalance"]
                                        .split(" ")
                                        .last
                                        .replaceAll(",", ""))
                                    : double.parse(
                                        corporateAccountDetails[index]
                                                ["currentBalance"]
                                            .split(" ")
                                            .last
                                            .replaceAll(",", ""));
                                log("senderBalance -> $senderBalance");
                                showButtonBloc.add(ShowButtonEvent(
                                    show: selectedAccountIndex == index));
                              },
                              title: sendMoneyArgument.isRetail
                                  ? accountDetails[index]["productCode"] ==
                                          "1001"
                                      ? labels[7]["labelText"]
                                      : labels[92]["labelText"]
                                  : corporateAccountDetails[index]
                                              ["accountType"] ==
                                          2
                                      ? labels[7]["labelText"]
                                      : labels[92]["labelText"],
                              accountNo: sendMoneyArgument.isRetail
                                  ? accountDetails[index]["accountNumber"]
                                  : corporateAccountDetails[index]
                                      ["accountNumber"],
                              currency: sendMoneyArgument.isRetail
                                  ? accountDetails[index]["accountCurrency"]
                                  : corporateAccountDetails[index]["currency"],
                              amount: sendMoneyArgument.isRetail
                                  ? double.parse(accountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")) >=
                                          1000
                                      ? NumberFormat('#,000.00').format(
                                          double.parse(accountDetails[index]
                                                  ["currentBalance"]
                                              .split(" ")
                                              .last
                                              .replaceAll(",", "")))
                                      : double.parse(accountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", ""))
                                          .toStringAsFixed(2)
                                  : double.parse(corporateAccountDetails[index]
                                                  ["currentBalance"]
                                              .split(" ")
                                              .last
                                              .replaceAll(",", "")) >=
                                          1000
                                      ? NumberFormat('#,000.00').format(
                                          double.parse(corporateAccountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")))
                                      : double.parse(corporateAccountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")).toStringAsFixed(2),
                              isSelected: selectedAccountIndex == index,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //     ],
                  //   ),
                  // ),
                  // Ternary(
                  //   condition: sendMoneyArgument.isRemittance,
                  //   truthy: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       const SizeBox(height: 20),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           DashboardActivityTile(
                  //             iconPath: ImageConstants.percent,
                  //             activityText: "Exchange Rates",
                  //             onTap: () {
                  //               showModalBottomSheet(
                  //                 context: context,
                  //                 backgroundColor: Colors.transparent,
                  //                 isScrollControlled: true,
                  //                 builder: (context) {
                  //                   final ShowButtonBloc showButtonBloc =
                  //                       context.read<ShowButtonBloc>();
                  //                   return BlocBuilder<ShowButtonBloc,
                  //                       ShowButtonState>(
                  //                     builder: (context, state) {
                  //                       return Padding(
                  //                         padding: EdgeInsets.only(
                  //                           bottom: MediaQuery.of(context)
                  //                               .viewInsets
                  //                               .bottom,
                  //                         ),
                  //                         child: Container(
                  //                           decoration: BoxDecoration(
                  //                             borderRadius: BorderRadius.only(
                  //                               topLeft: Radius.circular((10 /
                  //                                       Dimensions.designWidth)
                  //                                   .w),
                  //                               topRight: Radius.circular((10 /
                  //                                       Dimensions.designWidth)
                  //                                   .w),
                  //                             ),
                  //                             color: Colors.white,
                  //                           ),
                  //                           padding: EdgeInsets.symmetric(
                  //                             horizontal: (PaddingConstants
                  //                                         .horizontalPadding /
                  //                                     Dimensions.designWidth)
                  //                                 .w,
                  //                             vertical: (PaddingConstants
                  //                                         .bottomPadding /
                  //                                     Dimensions.designHeight)
                  //                                 .h,
                  //                           ),
                  //                           child: Column(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.start,
                  //                             mainAxisSize: MainAxisSize.min,
                  //                             children: [
                  //                               // ! Clip widget for drag
                  //                               Center(
                  //                                 child: Container(
                  //                                   padding:
                  //                                       EdgeInsets.symmetric(
                  //                                     vertical: (10 /
                  //                                             Dimensions
                  //                                                 .designWidth)
                  //                                         .w,
                  //                                   ),
                  //                                   height: (7 /
                  //                                           Dimensions
                  //                                               .designWidth)
                  //                                       .w,
                  //                                   width: (50 /
                  //                                           Dimensions
                  //                                               .designWidth)
                  //                                       .w,
                  //                                   decoration: BoxDecoration(
                  //                                     borderRadius:
                  //                                         BorderRadius.all(
                  //                                       Radius.circular((10 /
                  //                                               Dimensions
                  //                                                   .designWidth)
                  //                                           .w),
                  //                                     ),
                  //                                     color: const Color(
                  //                                         0xFFD9D9D9),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                               const SizeBox(height: 15),
                  //                               Text(
                  //                                 "1 USD = $exRate ${selectedCurrency?.countrynameOrCode}",
                  //                                 style: TextStyles
                  //                                     .primaryMedium
                  //                                     .copyWith(
                  //                                   color: AppColors.dark80,
                  //                                   fontSize: (14 /
                  //                                           Dimensions
                  //                                               .designWidth)
                  //                                       .w,
                  //                                 ),
                  //                               ),
                  //                               const SizeBox(height: 15),
                  //                               CustomTextField(
                  //                                 prefixIcon: Row(
                  //                                   mainAxisSize:
                  //                                       MainAxisSize.min,
                  //                                   children: [
                  //                                     CircleAvatar(
                  //                                       radius: ((19 / 2) /
                  //                                               Dimensions
                  //                                                   .designWidth)
                  //                                           .w,
                  //                                       backgroundImage:
                  //                                           CachedMemoryImageProvider(
                  //                                         const Uuid().v4(),
                  //                                         bytes: base64Decode(
                  //                                             senderCurrencyFlag),
                  //                                       ),
                  //                                     ),
                  //                                     const SizeBox(width: 10),
                  //                                     Text(
                  //                                       senderCurrency,
                  //                                       style: TextStyles
                  //                                           .primaryMedium
                  //                                           .copyWith(
                  //                                         color:
                  //                                             AppColors.dark80,
                  //                                         fontSize: (14 /
                  //                                                 Dimensions
                  //                                                     .designWidth)
                  //                                             .w,
                  //                                       ),
                  //                                     ),
                  //                                     const SizeBox(width: 10),
                  //                                     Text(
                  //                                       "|",
                  //                                       style: TextStyles
                  //                                           .primaryMedium
                  //                                           .copyWith(
                  //                                         color:
                  //                                             AppColors.dark50,
                  //                                         fontSize: (14 /
                  //                                                 Dimensions
                  //                                                     .designWidth)
                  //                                             .w,
                  //                                       ),
                  //                                     ),
                  //                                     const SizeBox(width: 10),
                  //                                   ],
                  //                                 ),
                  //                                 hintText: "Enter Amount",
                  //                                 keyboardType:
                  //                                     TextInputType.numberWithOptions(decimal: true),
                  //                                 controller:
                  //                                     _sendCurrencyController,
                  //                                 onChanged: (p0) {
                  //                                   _receiveCurrencyController
                  //                                           .text =
                  //                                       (double.parse(p0) *
                  //                                               exRate)
                  //                                           .toStringAsFixed(2);
                  //                                 },
                  //                               ),
                  //                               const SizeBox(height: 10),
                  //                               Stack(
                  //                                 children: [
                  //                                   Row(
                  //                                     children: [
                  //                                       SizeBox(width: 35.w),
                  //                                       CustomTextField(
                  //                                         enabled: false,
                  //                                         width: 63.w,
                  //                                         hintText: "0.00",
                  //                                         controller:
                  //                                             _receiveCurrencyController,
                  //                                         onChanged: (p0) {},
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                   Row(
                  //                                     mainAxisSize:
                  //                                         MainAxisSize.min,
                  //                                     children: [
                  //                                       SizedBox(
                  //                                         width: 28.w,
                  //                                         child:
                  //                                             CustomDropdownCountries(
                  //                                           height: 60,
                  //                                           maxHeight: 200,
                  //                                           title: "",
                  //                                           items:
                  //                                               exchangeCurrencies,
                  //                                           value:
                  //                                               selectedCurrency,
                  //                                           onChanged: (value) {
                  //                                             selectedCurrency =
                  //                                                 value
                  //                                                     as DropDownCountriesModel;

                  //                                             for (var i = 0;
                  //                                                 i <
                  //                                                     exchangeCurrencies
                  //                                                         .length;
                  //                                                 i++) {
                  //                                               if (selectedCurrency
                  //                                                       ?.countrynameOrCode ==
                  //                                                   getExchangeRateApi[
                  //                                                           "fetchExRates"][i]
                  //                                                       [
                  //                                                       "exchangeCurrency"]) {
                  //                                                 exRate = getExchangeRateApi["fetchExRates"]
                  //                                                             [
                  //                                                             i]
                  //                                                         [
                  //                                                         "exchangeRate"]
                  //                                                     .toDouble();
                  //                                                 break;
                  //                                               }
                  //                                             }

                  //                                             _receiveCurrencyController
                  //                                                 .text = (exRate *
                  //                                                     double.parse(_sendCurrencyController
                  //                                                             .text
                  //                                                             .isEmpty
                  //                                                         ? "0"
                  //                                                         : _sendCurrencyController
                  //                                                             .text))
                  //                                                 .toStringAsFixed(
                  //                                                     2);

                  //                                             showButtonBloc
                  //                                                 .add(
                  //                                               const ShowButtonEvent(
                  //                                                 show: true,
                  //                                               ),
                  //                                             );
                  //                                           },
                  //                                         ),
                  //                                       ),
                  //                                       const SizeBox(
                  //                                           width: 10),
                  //                                     ],
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               const SizeBox(height: 15),
                  //                               Container(
                  //                                 width: 100.w,
                  //                                 padding: EdgeInsets.symmetric(
                  //                                   horizontal: PaddingConstants
                  //                                       .horizontalPadding,
                  //                                   vertical: (10 /
                  //                                           Dimensions
                  //                                               .designHeight)
                  //                                       .h,
                  //                                 ),
                  //                                 decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.all(
                  //                                     Radius.circular(
                  //                                       (10 /
                  //                                               Dimensions
                  //                                                   .designWidth)
                  //                                           .w,
                  //                                     ),
                  //                                   ),
                  //                                   color:
                  //                                       const Color(0XFFD9D9D9),
                  //                                 ),
                  //                                 child: Row(
                  //                                   children: [
                  //                                     Icon(
                  //                                       Icons
                  //                                           .info_outline_rounded,
                  //                                       size: (24 /
                  //                                               Dimensions
                  //                                                   .designWidth)
                  //                                           .w,
                  //                                       color: AppColors
                  //                                           .primaryDark,
                  //                                     ),
                  //                                     const SizeBox(width: 10),
                  //                                     Text(
                  //                                       "Rates are indicated and subject to change",
                  //                                       style: TextStyles
                  //                                           .primaryMedium
                  //                                           .copyWith(
                  //                                         color: AppColors
                  //                                             .primaryDark,
                  //                                         fontSize: (16 /
                  //                                                 Dimensions
                  //                                                     .designWidth)
                  //                                             .w,
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                               // const SizeBox(height: 15),
                  //                               // GradientButton(
                  //                               //   onTap: () {
                  //                               //     showButtonBloc.add(
                  //                               //       const ShowButtonEvent(
                  //                               //         show: true,
                  //                               //       ),
                  //                               //     );
                  //                               //   },
                  //                               //   text: "Get Exchange Rate",
                  //                               // ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                   );
                  //                 },
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  //   falsy: const SizeBox(),
                  // ),
                ],
              ),
            ),
            Column(
              children: [
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (selectedAccountIndex == -1
                        // ||
                        //     accountDetails.length == 1
                        ) {
                      return SolidButton(
                          onTap: () {}, text: labels[127]["labelText"]);
                    } else {
                      return GradientButton(
                        onTap: () {
                          if (sendMoneyArgument.isBetweenAccounts) {
                            Navigator.pushNamed(
                              context,
                              Routes.sendMoneyTo,
                              arguments: SendMoneyArgumentModel(
                                isBetweenAccounts: true,
                                isWithinDhabi: false,
                                isRemittance: false,
                                isRetail: sendMoneyArgument.isRetail,
                              ).toMap(),
                            );
                          } else if (sendMoneyArgument.isRemittance) {
                            Navigator.pushNamed(
                              context,
                              Routes.selectRecipient,
                              arguments: SendMoneyArgumentModel(
                                isBetweenAccounts: false,
                                isWithinDhabi: false,
                                isRemittance: true,
                                isRetail: sendMoneyArgument.isRetail,
                              ).toMap(),
                            );
                          } else {
                            Navigator.pushNamed(
                              context,
                              Routes.selectRecipient,
                              arguments: SendMoneyArgumentModel(
                                isBetweenAccounts: false,
                                isWithinDhabi: true,
                                isRemittance: false,
                                isRetail: sendMoneyArgument.isRetail,
                              ).toMap(),
                            );
                          }
                        },
                        text: labels[127]["labelText"],
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

  @override
  void dispose() {
    _sendCurrencyController.dispose();
    _receiveCurrencyController.dispose();
    super.dispose();
  }
}
