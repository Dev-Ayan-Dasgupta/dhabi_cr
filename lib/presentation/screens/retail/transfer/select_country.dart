// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/search_box.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<CountryTileModel> countries = [];
  List<CountryTileModel> filteredCountries = [];

  bool isShowAll = true;

  bool isFetchingExchangeRate = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateCountries();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void populateCountries() {
    countries.clear();
    for (var country in transferCapabilities) {
      List<String> currencies = [];
      List<DropDownCountriesModel> currencyModelsWallet = [];
      List<DropDownCountriesModel> currencyModelsBank = [];
      currencies.clear();

      for (var supportedCurrency in country["supportedCurrencies"]) {
        currencies.add(supportedCurrency["currencyCode"]);
        if (supportedCurrency["isBank"]) {
          currencyModelsBank.add(
            DropDownCountriesModel(
              countrynameOrCode: supportedCurrency["currencyCode"],
              countryFlagBase64: supportedCurrency["currencyFlag"],
              isEnabled: true,
            ),
          );
        }
        if (supportedCurrency["isWallet"]) {
          currencyModelsWallet.add(
            DropDownCountriesModel(
              countrynameOrCode: supportedCurrency["currencyCode"],
              countryFlagBase64: supportedCurrency["currencyFlag"],
              isEnabled: true,
            ),
          );
        }
      }
      log("currencies -> $currencies");
      countries.add(
        CountryTileModel(
          flagImgUrl: country["countryFlagBase64"],
          country: shortCodeToCountryName(country["countryShortCode"]),
          supportedCurrencies: country["supportedCurrencies"],
          currencies: currencies,
          isBank: country["supportedCurrencies"][0]["isBank"],
          isWallet: country["supportedCurrencies"][0]["isWallet"],
          threshold: country["supportedCurrencies"][0]["threshold"] * 1.00,
          isTerraPaySupported: country["supportedCurrencies"][0]
              ["isTerraPaySupported"],
          isBusinessSupported: country["supportedCurrencies"][0]
              ["isBusinessSupported"],
          currencyCode: country["supportedCurrencies"][0]["currencyCode"],
          currencyFlag: country["supportedCurrencies"][0]["currencyFlag"],
          countryShortCode: country["countryShortCode"],
          currencyModelsBank: currencyModelsBank,
          currencyModelsWallet: currencyModelsWallet,
        ),
      );
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
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labels[185]["labelText"],
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                CustomSearchBox(
                  hintText: labels[174]["labelText"],
                  controller: _searchController,
                  onChanged: onSearchChanged,
                ),
                const SizeBox(height: 20),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          CountryTileModel item = isShowAll
                              ? countries[index]
                              : filteredCountries[index];
                          return CountryTile(
                            onTap: () async {
                              if (!isFetchingExchangeRate) {
                                isFetchingExchangeRate = true;
                                setState(() {});

                                receiverCurrency = item.currencies[0];

                                log("getExchRateV2 Req -> ${{
                                  "destCurrency": receiverCurrency,
                                  "reqAmount": "1",
                                  "gateway": item.isTerraPaySupported
                                      ? "TerraPay"
                                      : "SWIFT",
                                }}");

                                var getExchRateV2Res =
                                    await MapExchangeRateV2.mapExchangeRateV2(
                                  {
                                    "destCurrency": receiverCurrency,
                                    "reqAmount": "1",
                                    "gateway": item.isTerraPaySupported
                                        ? "TerraPay"
                                        : "SWIFT",
                                  },
                                  token ?? "",
                                );

                                log("getExchRateV2Res -> $getExchRateV2Res");

                                if (getExchRateV2Res["success"]) {
                                  exchangeRate =
                                      getExchRateV2Res["trExchangeRate"][0]
                                          ["exchangeRate"];
                                  log("exchangeRate -> $exchangeRate");
                                  fees = double.parse(
                                      getExchRateV2Res["trExchangeRate"][0]
                                              ["transferFee"]
                                          .split(' ')
                                          .last);
                                  log("fees -> $fees");
                                  expectedTime =
                                      getExchRateV2Res["expectedTime"];
                                  log("expectedTime -> $expectedTime");

                                  isTerraPaySupported =
                                      item.isTerraPaySupported;
                                  log("isTerraPaySupported -> $isTerraPaySupported");
                                  threshold = item.threshold;
                                  log("threshold -> $threshold");
                                  isBusinessSupported =
                                      item.isBusinessSupported;
                                  log("isBusinessRemittance -> $isBusinessSupported");
                                  beneficiaryCountryCode =
                                      item.countryShortCode;
                                  log("beneficiaryCountryCode -> $beneficiaryCountryCode");
                                  isBank = item.isBank;
                                  log("isBank -> $isBank");
                                  isWallet = item.isWallet;
                                  log("isWallet -> $isWallet");

                                  receiverCurrenciesBank =
                                      item.currencyModelsBank;
                                  receiverCurrenciesWallet =
                                      item.currencyModelsWallet;
                                  log("receiverCurrency -> $receiverCurrency");
                                  receiverCurrencyFlag = item.flagImgUrl;

                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.recipientReceiveMode,
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
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomDialog(
                                          svgAssetPath: ImageConstants.warning,
                                          title: "Sorry!",
                                          message: getExchRateV2Res[
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

                                // var getExchRateApiResult =
                                //     await MapExchangeRate.mapExchangeRate(
                                //   token ?? "",
                                // );
                                // log("getExchRateApiResult -> $getExchRateApiResult");

                                // if (getExchRateApiResult["success"]) {
                                //   for (var fetchExchangeRate
                                //       in getExchRateApiResult["fetchExRates"]) {
                                //     if (fetchExchangeRate["exchangeCurrency"] ==
                                //         receiverCurrency) {
                                //       exchangeRate =
                                //           fetchExchangeRate["exchangeRate"]
                                //               .toDouble();
                                //       log("exchangeRate -> $exchangeRate");
                                //       fees = double.parse(
                                //           fetchExchangeRate["transferFee"]
                                //               .split(' ')
                                //               .last);
                                //       log("fees -> $fees");
                                //       expectedTime =
                                //           getExchRateApiResult["expectedTime"];
                                //       break;
                                //     }
                                //   }
                                //   isTerraPaySupported =
                                //       item.isTerraPaySupported;
                                //   log("isTerraPaySupported -> $isTerraPaySupported");
                                //   threshold = item.threshold;
                                //   log("threshold -> $threshold");
                                //   isBusinessRemittance =
                                //       item.isBusinessSupported;
                                //   log("isBusinessRemittance -> $isBusinessRemittance");
                                //   beneficiaryCountryCode =
                                //       item.countryShortCode;
                                //   log("beneficiaryCountryCode -> $beneficiaryCountryCode");
                                //   isBank = item.isBank;
                                //   log("isBank -> $isBank");
                                //   isWallet = item.isWallet;
                                //   log("isWallet -> $isWallet");

                                //   receiverCurrenciesBank =
                                //       item.currencyModelsBank;
                                //   receiverCurrenciesWallet =
                                //       item.currencyModelsWallet;
                                //   log("receiverCurrency -> $receiverCurrency");
                                //   receiverCurrencyFlag = item.flagImgUrl;

                                //   if (context.mounted) {
                                //     Navigator.pushNamed(
                                //       context,
                                //       Routes.recipientReceiveMode,
                                //       arguments: SendMoneyArgumentModel(
                                //         isBetweenAccounts:
                                //             sendMoneyArgument.isBetweenAccounts,
                                //         isWithinDhabi:
                                //             sendMoneyArgument.isWithinDhabi,
                                //         isRemittance:
                                //             sendMoneyArgument.isRemittance,
                                //         isRetail: sendMoneyArgument.isRetail,
                                //       ).toMap(),
                                //     );
                                //   }
                                // } else {
                                //   if (context.mounted) {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return CustomDialog(
                                //           svgAssetPath: ImageConstants.warning,
                                //           title: "Sorry!",
                                //           message: getExchRateApiResult[
                                //                   "message"] ??
                                //               "There was an error fetching exchange rate, please try again later.",
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
                                isFetchingExchangeRate = false;
                                setState(() {});
                              }
                            },
                            flagImgUrl: item.flagImgUrl,
                            country: item.country,
                            currencies: item.currencies,
                            supportedCurrencies: item.supportedCurrencies,
                            currencyCode: item.currencyCode,
                          );
                        },
                        itemCount: isShowAll
                            ? countries.length
                            : filteredCountries.length,
                      ),
                    );
                  },
                ),
                const SizeBox(height: 20),
              ],
            ),
          ),
          Ternary(
            condition: isFetchingExchangeRate,
            falsy: const SizeBox(),
            truthy: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(
                    color: AppColors.primary,
                    size: (50 / Dimensions.designWidth).w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSearchChanged(String p0) {
    final ShowButtonBloc countryListBloc = context.read<ShowButtonBloc>();
    {
      searchCountry(countries, p0);
      if (p0.isEmpty) {
        isShowAll = true;
      } else {
        isShowAll = false;
      }
      countryListBloc.add(ShowButtonEvent(show: isShowAll));
    }
  }

  void searchCountry(List<CountryTileModel> countries, String matcher) {
    filteredCountries.clear();
    for (CountryTileModel country in countries) {
      if (country.country.toLowerCase().contains(matcher.toLowerCase())) {
        filteredCountries.add(country);
      }
    }
  }

  String shortCodeToCountryName(String sc) {
    String countryName = "";
    for (var dhabiCountry in dhabiCountries) {
      if (dhabiCountry["shortCode"] == sc) {
        countryName = dhabiCountry["countryName"];
        break;
      }
    }
    return countryName;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
