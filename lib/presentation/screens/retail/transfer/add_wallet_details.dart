// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddWalletDetailsScreen extends StatefulWidget {
  const AddWalletDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<AddWalletDetailsScreen> createState() => _AddWalletDetailsScreenState();
}

class _AddWalletDetailsScreenState extends State<AddWalletDetailsScreen> {
  late SendMoneyArgumentModel sendMoneyArgument;

  List<String> reasonsToSend = [
    "Business Profits to Parents",
    "Business Travel",
    "Family Maintenance",
    "Salary",
    "Savings",
    "Medical Expenses",
    "Tuition Fees",
    "Education Support",
    "Gift",
    "Home Improvement",
    "Debt Settlement",
    "Real Estate",
    "Taxes",
  ];

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();

  bool isChecked = false;
  bool allValid = false;
  bool isFetchingExchangeRate = false;

  String? selectedWallet;
  String? selectedReason;

  bool isWalletSelected = false;
  bool isReasonSelected = false;

  int toggles = 0;

  List<String> walletsToShow = [];

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateWallet();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void populateWallet() {
    String countryName = "";
    for (var country in dhabiCountries) {
      if (country["shortCode"] == beneficiaryCountryCode) {
        countryName = country["countryName"];
        break;
      }
    }
    log("countryName -> $countryName");
    walletsToShow.clear();
    for (var walletName in walletNames) {
      if (walletName.toLowerCase().contains(countryName.toLowerCase())) {
        walletsToShow.add(walletName.split('-').last);
      }
    }
    log("walletsToShow -> $walletsToShow");
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[194]["labelText"],
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Mobile Wallet",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 8),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        return CustomDropDown(
                          title: "Select from the list",
                          value: selectedWallet,
                          items: walletsToShow,
                          onChanged: (value) {
                            final DropdownSelectedBloc dropdownSelectedBloc =
                                context.read<DropdownSelectedBloc>();
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            toggles++;
                            isWalletSelected = true;
                            selectedWallet = value as String;
                            benBankName = selectedWallet ?? "";
                            showButtonBloc
                                .add(ShowButtonEvent(show: isReasonSelected));
                            dropdownSelectedBloc.add(DropdownSelectedEvent(
                                isDropdownSelected: true, toggles: toggles));
                          },
                        );
                      },
                    ),
                    const SizeBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "First Name",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 8),
                    CustomTextField(
                      controller: _firstNameController,
                      onChanged: (p0) {
                        benCustomerName =
                            "${_firstNameController.text}${_lastNameController.text}";
                        final ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        showButtonBloc.add(ShowButtonEvent(
                            show: _walletController.text.isNotEmpty));
                      },
                    ),
                    const SizeBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "Last Name",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 8),
                    CustomTextField(
                      controller: _lastNameController,
                      onChanged: (p0) {
                        benCustomerName =
                            "${_firstNameController.text}${_lastNameController.text}";
                        final ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        showButtonBloc.add(ShowButtonEvent(
                            show: _walletController.text.isNotEmpty));
                      },
                    ),
                    const SizeBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "Address",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 8),
                    CustomTextField(
                      controller: _addressController,
                      onChanged: (p0) {
                        final ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        showButtonBloc.add(ShowButtonEvent(
                            show: _walletController.text.isNotEmpty));
                      },
                    ),
                    const SizeBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "Wallet Number/IBAN",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 8),
                    CustomTextField(
                      controller: _walletController,
                      onChanged: (p0) {
                        receiverAccountNumber = _walletController.text;
                        final ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        showButtonBloc.add(ShowButtonEvent(
                            show: _walletController.text.isNotEmpty));
                      },
                    ),
                    const SizeBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "Reason for Sending",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 8),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        return CustomDropDown(
                          title: "Select from the list",
                          value: selectedReason,
                          items: reasonsToSend,
                          onChanged: (value) {
                            remittancePurpose = selectedReason ?? "";
                            final DropdownSelectedBloc dropdownSelectedBloc =
                                context.read<DropdownSelectedBloc>();
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            toggles++;
                            isReasonSelected = true;
                            selectedReason = value as String;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isReasonSelected));
                            dropdownSelectedBloc.add(DropdownSelectedEvent(
                                isDropdownSelected: true, toggles: toggles));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizeBox(height: 10),
                Row(
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: (context, state) {
                        if (isChecked) {
                          return InkWell(
                            onTap: () {
                              isChecked = false;
                              isAddRemBeneficiary = isChecked;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (5 / Dimensions.designWidth).w),
                              child: SvgPicture.asset(
                                ImageConstants.checkedBox,
                                width: (14 / Dimensions.designWidth).w,
                                height: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              isChecked = true;
                              isAddRemBeneficiary = isChecked;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (5 / Dimensions.designWidth).w),
                              child: SvgPicture.asset(
                                ImageConstants.uncheckedBox,
                                width: (14 / Dimensions.designWidth).w,
                                height: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizeBox(width: 5),
                    Text(
                      labels[126]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: const Color(0XFF414141),
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (_walletController.text.isNotEmpty &&
                        _addressController.text.isNotEmpty &&
                        _lastNameController.text.isNotEmpty &&
                        _firstNameController.text.isNotEmpty &&
                        isWalletSelected &&
                        isReasonSelected) {
                      return GradientButton(
                        onTap: () async {
                          if (!isFetchingExchangeRate) {
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isFetchingExchangeRate = true;
                            showButtonBloc.add(
                                ShowButtonEvent(show: isFetchingExchangeRate));

                            var getExchRateApiResult =
                                await MapExchangeRate.mapExchangeRate(
                              token ?? "",
                            );
                            log("getExchRateApiResult -> $getExchRateApiResult");

                            if (getExchRateApiResult["success"]) {
                              for (var fetchExchangeRate
                                  in getExchRateApiResult["fetchExRates"]) {
                                if (fetchExchangeRate["exchangeCurrency"] ==
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
                                  expectedTime =
                                      getExchRateApiResult["expectedTime"];
                                  break;
                                }
                              }

                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.transferAmount,
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

                            isFetchingExchangeRate = false;
                            showButtonBloc.add(
                                ShowButtonEvent(show: isFetchingExchangeRate));
                          }
                        },
                        text: labels[127]["labelText"],
                        auxWidget: isFetchingExchangeRate
                            ? const LoaderRow()
                            : const SizeBox(),
                      );
                    } else {
                      return SolidButton(
                        onTap: () {},
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

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _walletController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
