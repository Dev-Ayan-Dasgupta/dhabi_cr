// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/configurations/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/search_box.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SelectRecipientScreen extends StatefulWidget {
  const SelectRecipientScreen({
    Key? key,
    this.argument,
  }) : super(key: key);
  final Object? argument;
  @override
  State<SelectRecipientScreen> createState() => _SelectRecipientScreenState();
}

class _SelectRecipientScreenState extends State<SelectRecipientScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RecipientModel> recipients = [];
  List<RecipientModel> filteredRecipients = [];

  bool isShowAll = true;

  bool isFetchingBeneficiaries = false;

  Map<String, dynamic> getBeneficiariesApiResult = {};

  bool isFetchingExchangeRate = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getBeneficiaries();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    log("sendMoneyArgument -> $sendMoneyArgument");
  }

  Future<void> getBeneficiaries() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    try {
      isFetchingBeneficiaries = true;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingBeneficiaries));
      getBeneficiariesApiResult =
          await MapGetBeneficiaries.mapGetBeneficiaries(token ?? "");
      log("getBeneficiariesApiResult -> $getBeneficiariesApiResult");

      if (getBeneficiariesApiResult["success"]) {
        recipients.clear();
        for (var beneficiary in getBeneficiariesApiResult["beneficiaries"]) {
          if (sendMoneyArgument.isRemittance) {
            if (beneficiary["beneficiaryType"] == 2 ||
                beneficiary["beneficiaryType"] == 5) {
              recipients.add(
                RecipientModel(
                  beneficiaryId: beneficiary["beneficiaryId"],
                  swiftReference: beneficiary["swiftReference"],
                  flagImgUrl: beneficiary["countryCodeFlagBase64"],
                  flagImgUrl2: beneficiary["currencyFlagBase64"],
                  name: beneficiary["name"],
                  accountNumber: beneficiary["accountNumber"],
                  currency: beneficiary["targetCurrency"],
                  address: beneficiary["address"],
                  accountType: beneficiary["accountType"],
                  countryShortCode: beneficiary["countryCode"],
                  benBankCode: beneficiary["benBankCode"] ?? "",
                  benMobileNo: beneficiary["benMobileNo"] ?? "",
                  benSubBankCode: beneficiary["benSubBankCode"] ?? "",
                  benIdType: beneficiary["beneficiaryType"].toString(),
                  benIdNo: beneficiary["benIdNo"] ?? "",
                  benIdExpiryDate: beneficiary["benIdExpiryDate"] ?? "",
                  benBankName: beneficiary["benBankName"] ?? "",
                  benSwiftCode: beneficiary["benSwiftCodeText"] ?? "",
                  benCity: beneficiary["city"] ?? "",
                  remittancePurpose: beneficiary["remittancePurpose"] ?? "",
                  sourceOfFunds: beneficiary["sourceOfFunds"] ?? "",
                  relation: beneficiary["relation"] ?? "",
                  providerName: beneficiary["providerName"] ?? "",
                  beneficiaryStatus: beneficiary["beneficiaryStatus"] ?? "",
                ),
              );
            }
          } else if (sendMoneyArgument.isWithinDhabi) {
            if (beneficiary["beneficiaryType"] == 3) {
              recipients.add(
                RecipientModel(
                  beneficiaryId: beneficiary["beneficiaryId"],
                  swiftReference: beneficiary["swiftReference"],
                  flagImgUrl: beneficiary["currencyFlagBase64"],
                  flagImgUrl2: beneficiary["currencyFlagBase64"],
                  name: beneficiary["name"],
                  accountNumber: beneficiary["accountNumber"],
                  currency: beneficiary["targetCurrency"],
                  address: beneficiary["address"],
                  accountType: beneficiary["accountType"],
                  countryShortCode: beneficiary["countryCode"],
                  benBankCode: beneficiary["benBankCode"] ?? "",
                  benMobileNo: beneficiary["benMobileNo"] ?? "",
                  benSubBankCode: beneficiary["benSubBankCode"] ?? "",
                  benIdType: beneficiary["beneficiaryType"].toString(),
                  benIdNo: beneficiary["benIdNo"] ?? "",
                  benIdExpiryDate: beneficiary["benIdExpiryDate"] ?? "",
                  benBankName: beneficiary["benBankName"] ?? "",
                  benSwiftCode: beneficiary["benSwiftCodeText"] ?? "",
                  benCity: beneficiary["city"] ?? "",
                  remittancePurpose: beneficiary["remittancePurpose"] ?? "",
                  sourceOfFunds: beneficiary["sourceOfFunds"] ?? "",
                  relation: beneficiary["relation"] ?? "",
                  providerName: beneficiary["providerName"] ?? "",
                  beneficiaryStatus: beneficiary["beneficiaryStatus"] ?? "",
                ),
              );
            }
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
                message: getBeneficiariesApiResult["message"] ??
                    "There was an error fetching your beneficiary details, please try again after some time.",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: labels[346]["labelText"],
                ),
              );
            },
          );
        }
      }
      isFetchingBeneficiaries = false;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingBeneficiaries));
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
                //  const SizeBox(height: 10),
                Text(
                  labels[172]["labelText"],
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 10),
                Text(
                  labels[173]["labelText"],
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark50,
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 30),
                InkWell(
                  onTap: () {
                    if (sendMoneyArgument.isRemittance) {
                      isNewRemittanceBeneficiary = true;
                      Navigator.pushNamed(
                        context,
                        Routes.selectCountry,
                        arguments: SendMoneyArgumentModel(
                          isBetweenAccounts:
                              sendMoneyArgument.isBetweenAccounts,
                          isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                          isRemittance: sendMoneyArgument.isRemittance,
                          isRetail: sendMoneyArgument.isRetail,
                        ).toMap(),
                      );
                    } else {
                      isNewWithinDhabiBeneficiary = true;
                      Navigator.pushNamed(
                        context,
                        Routes.recipientDetails,
                        arguments: SendMoneyArgumentModel(
                          isBetweenAccounts:
                              sendMoneyArgument.isBetweenAccounts,
                          isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                          isRemittance: sendMoneyArgument.isRemittance,
                          isRetail: sendMoneyArgument.isRetail,
                        ).toMap(),
                      );
                    }
                  },
                  child: Container(
                    width: 100.w,
                    height: (50 / Dimensions.designHeight).h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((10 / Dimensions.designWidth).w),
                      ),
                      color: Colors.white,
                      boxShadow: [BoxShadows.primary],
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: (16 / Dimensions.designHeight).h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline_outlined,
                          color: AppColors.primary,
                          size: (20 / Dimensions.designWidth).w,
                        ),
                        const SizeBox(width: 10),
                        Text(
                          "Add New Recipient",
                          style: TextStyles.primaryBold.copyWith(
                            color: AppColors.primary,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizeBox(height: 30),
                CustomSearchBox(
                  hintText: labels[174]["labelText"],
                  controller: _searchController,
                  onChanged: onSearchChanged,
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return Ternary(
                      condition: isFetchingBeneficiaries,
                      truthy: const SizeBox(),
                      falsy: Row(
                        children: [
                          Text(
                            "Search through your ",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.dark50,
                              fontSize: (12 / Dimensions.designWidth).w,
                            ),
                          ),
                          Text(
                            "${recipients.length} ",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark50,
                              fontSize: (12 / Dimensions.designWidth).w,
                            ),
                          ),
                          Text(
                            sendMoneyArgument.isRemittance
                                ? "International Recipients."
                                : "Dhabi Recipients",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.dark50,
                              fontSize: (12 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizeBox(height: 20),

                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildRecipientList,
                ),
                const SizeBox(height: 20),
              ],
            ),
          ),
          isFetchingExchangeRate
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCircle(
                        color: AppColors.primary,
                        size: (50 / Dimensions.designWidth).w,
                      ),
                    ],
                  ),
                )
              : const SizeBox(),
        ],
      ),
    );
  }

  void onSearchChanged(String p0) {
    final ShowButtonBloc recipientListBloc = context.read<ShowButtonBloc>();
    searchRecipient(recipients, p0);
    if (p0.isEmpty) {
      isShowAll = true;
    } else {
      isShowAll = false;
    }
    recipientListBloc.add(ShowButtonEvent(show: isShowAll));
  }

  void searchRecipient(List<RecipientModel> recipients, String matcher) {
    filteredRecipients.clear();
    for (RecipientModel recipient in recipients) {
      if (recipient.name.toLowerCase().contains(matcher.toLowerCase())) {
        filteredRecipients.add(recipient);
      }
    }
  }

  Widget buildRecipientList(BuildContext context, ShowButtonState state) {
    return Ternary(
      condition: isFetchingBeneficiaries,
      truthy: Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return const ShimmerSelectRecipientTile();
          },
          separatorBuilder: (context, index) {
            return const SizeBox(height: 10);
          },
          itemCount: 12,
        ),
      ),
      falsy: Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) {
            RecipientModel item =
                isShowAll ? recipients[index] : filteredRecipients[index];

            return RecipientsTile(
              onDelete: (context) {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      svgAssetPath: ImageConstants.warning,
                      title: "Are you sure?",
                      message:
                          "Are you sure you want to remove this beneficiary?",
                      auxWidget: GradientButton(
                        onTap: () async {
                          try {
                            log("Remove Ben Req -> ${{
                              "benefiaryId": item.beneficiaryId
                            }}");
                            var removeBenRes =
                                await MapRemoveBeneficiary.mapRemoveBeneficiary(
                                    {"benefiaryId": item.beneficiaryId});
                            log("removeBenRes -> $removeBenRes");
                            if (removeBenRes["success"]) {
                              await getBeneficiaries();
                            } else {
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomDialog(
                                      svgAssetPath: ImageConstants.warning,
                                      title: "Sorry",
                                      message:
                                          "There was an issue in deleting the beneficiary, please try again later.",
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
                          } catch (_) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath: ImageConstants.warning,
                                    title: "Oops",
                                    message:
                                        "Something went wrong, please try again later.",
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
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        text: "Yes, Remove",
                      ),
                      actionWidget: SolidButton(
                        color: AppColors.primaryBright17,
                        fontColor: AppColors.primary,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: "No, Go back",
                      ),
                    );
                  },
                );
              },
              onTap: () async {
                if (!isFetchingExchangeRate) {
                  if (item.beneficiaryStatus == 'Rejected') {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Sorry",
                          message: messages[124]["messageText"],
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
                    isFetchingExchangeRate = true;
                    setState(() {});

                    log("getCountryTC Req -> ${{
                      "countryShortCode": item.countryShortCode
                    }}");
                    var getCountryTCRes = await MapCountryTransferCapabilities
                        .mapCountryTransferCapabilities(
                      {"countryShortCode": item.countryShortCode},
                    );
                    log("getCountryTCRes -> $getCountryTCRes");

                    if (getCountryTCRes["success"]) {
                      threshold = getCountryTCRes["transferCapabilities"][0]
                              ["supportedCurrencies"][0]["threshold"] *
                          1.00;
                      isTerraPaySupported =
                          getCountryTCRes["transferCapabilities"][0]
                              ["supportedCurrencies"][0]["isTerraPaySupported"];
                      isBusinessSupported =
                          getCountryTCRes["transferCapabilities"][0]
                              ["supportedCurrencies"][0]["isBusinessSupported"];
                      // if (item.benIdType == "5") {

                      // }
                      // if (item.benIdType == "2") {
                      //   threshold = getCountryTCRes["transferCapabilities"][0]
                      //           ["supportedCurrencies"][1]["threshold"] *
                      //       1.00;
                      //   isTerraPaySupported =
                      //       getCountryTCRes["transferCapabilities"][0]
                      //               ["supportedCurrencies"][1]
                      //           ["isTerraPaySupported"];
                      //   isBusinessSupported =
                      //       getCountryTCRes["transferCapabilities"][0]
                      //               ["supportedCurrencies"][1]
                      //           ["isBusinessSupported"];
                      // }

                      receiverCurrenciesWallet.clear();
                      receiverCurrenciesWallet.add(DropDownCountriesModel(
                          countrynameOrCode: item.currency, isEnabled: true));
                      receiverCurrenciesBank.clear();
                      receiverCurrenciesBank.add(DropDownCountriesModel(
                          countrynameOrCode: item.currency, isEnabled: true));

                      isBankSelected = item.benIdType == "5" ? false : true;

                      receiverCurrencyFlag = item.flagImgUrl2;
                      receiverAccountNumber = item.accountNumber;
                      benCustomerName = item.name;
                      benAddress = item.address;
                      benAccountType = item.accountType;
                      beneficiaryCountryCode = item.countryShortCode;
                      receiverCurrency = item.currency;
                      benBankCode = item.benBankCode;
                      // benMobileNo =  item.benMobileNo;
                      benSubBankCode = item.benSubBankCode;
                      benIdType = item.benIdType;
                      benMobileNo = benIdType == "5"
                          ? item.accountNumber
                          : item.benMobileNo;
                      benId = item.beneficiaryId;
                      benIdNo = item.benIdNo;
                      benIdExpiryDate = item.benIdExpiryDate;
                      benBankName = item.benBankName;
                      benSwiftCode = item.benSwiftCode;
                      benCity = item.benCity;
                      remittancePurpose = item.remittancePurpose;
                      sourceOfFunds = item.sourceOfFunds;
                      relation = item.relation;
                      providerName = item.providerName;

                      if (sendMoneyArgument.isRemittance) {
                        log("getExchRateV2Req -> ${{
                          "destCurrency": receiverCurrency,
                          "reqAmount": "1",
                          // senderAmount.toString(),
                          "gateway": isTerraPaySupported ? "TerraPay" : "SWIFT",
                        }}");

                        var getExchRateV2Res =
                            await MapExchangeRateV2.mapExchangeRateV2(
                          {
                            "destCurrency": receiverCurrency,
                            "reqAmount": "1",
                            // senderAmount.toString(),
                            "gateway":
                                isTerraPaySupported ? "TerraPay" : "SWIFT",
                          },
                          token ?? "",
                        );

                        log("getExchRateV2Res -> $getExchRateV2Res");

                        if (getExchRateV2Res["success"]) {
                          exchangeRate = getExchRateV2Res["trExchangeRate"][0]
                              ["exchangeRate"];
                          fees = double.parse(getExchRateV2Res["trExchangeRate"]
                                  [0]["transferFee"]
                              .split(' ')
                              .last);
                          expectedTime = getExchRateV2Res["expectedTime"];

                          if (context.mounted) {
                            Navigator.pushNamed(
                              context,
                              Routes.transferAmount,
                              arguments: SendMoneyArgumentModel(
                                isBetweenAccounts:
                                    sendMoneyArgument.isBetweenAccounts,
                                isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                                isRemittance: sendMoneyArgument.isRemittance,
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
                                  message: getExchRateV2Res["message"] ??
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
                      } else {
                        receiverCurrencyFlag = senderCurrencyFlag;
                        exchangeRate = 1;
                        log("exchangeRate -> $exchangeRate");
                        if (context.mounted) {
                          Navigator.pushNamed(
                            context,
                            Routes.transferAmount,
                            arguments: SendMoneyArgumentModel(
                              isBetweenAccounts:
                                  sendMoneyArgument.isBetweenAccounts,
                              isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                              isRemittance: sendMoneyArgument.isRemittance,
                              isRetail: sendMoneyArgument.isRetail,
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
                              message: getCountryTCRes["message"] ??
                                  "There was an error fetching country transfer capabilities, please try again later.",
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

                    isFetchingExchangeRate = false;
                    setState(() {});
                  }
                }
              },
              flagImgUrl: item.flagImgUrl,
              name: item.name,
              accountNumber: item.accountNumber,
              currency: item.currency,
              bankName: sendMoneyArgument.isRemittance
                  ? !(item.benIdType == "5")
                      ? item.benBankName
                      : item.providerName
                  : "Dhabi",
              isBank: !(item.benIdType == "5"),
              beneficiaryStatus: item.beneficiaryStatus,
            );
          },
          separatorBuilder: (context, index) {
            return const SizeBox();
          },
          itemCount: isShowAll ? recipients.length : filteredRecipients.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
