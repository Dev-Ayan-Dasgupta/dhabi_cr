// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dialup_mobile_app/bloc/checkBox/check_box_bloc.dart';
import 'package:dialup_mobile_app/bloc/checkBox/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox/check_box_state.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_bloc.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_event.dart';
import 'package:dialup_mobile_app/bloc/showButton/show_button_state.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class RecipientDetailsScreen extends StatefulWidget {
  const RecipientDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RecipientDetailsScreen> createState() => _RecipientDetailsScreenState();
}

class _RecipientDetailsScreenState extends State<RecipientDetailsScreen> {
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _recipientNameController =
      TextEditingController();
  bool isChecked = false;
  String buttonText = labels[174]["labelText"];
  bool isProceed = false;

  bool isFetchingCustDets = false;
  bool isFetchingExchangeRate = false;

  bool isAccNumValid = false;

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
    final ShowButtonBloc proceedBloc = context.read<ShowButtonBloc>();
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
                    labels[177]["labelText"],
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Account Number",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hintText: "Enter Account Number",
                            keyboardType: TextInputType.number,
                            enabled: !isProceed,
                            color: isProceed
                                ? AppColors.blackEE
                                : Colors.transparent,
                            controller: _ibanController,
                            onChanged: (p0) {
                              if (p0.length == 12) {
                                isAccNumValid = true;
                              } else {
                                isAccNumValid = false;
                              }
                              proceedBloc.add(ShowButtonEvent(show: isProceed));
                            },
                          ),
                          const SizeBox(height: 7),
                          Ternary(
                            condition: isAccNumValid,
                            truthy: const SizeBox(),
                            falsy: Text(
                              "Must be 12 digits",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.red100,
                                fontSize: (12 / Dimensions.designWidth).w,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildRecipientName,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isProceed) {
                      return Row(
                        children: [
                          BlocBuilder<CheckBoxBloc, CheckBoxState>(
                            builder: buildTC,
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
                      );
                    } else {
                      return const SizeBox();
                    }
                  },
                ),
                const SizeBox(height: 10),
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

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  Widget buildRecipientName(BuildContext context, ShowButtonState state) {
    if (isProceed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labels[178]["labelText"],
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.dark80,
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 10),
          CustomTextField(
            enabled: false,
            color: AppColors.blackEE,
            controller: _recipientNameController,
            onChanged: (p0) {},
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTC(BuildContext context, CheckBoxState state) {
    if (isChecked) {
      return InkWell(
        onTap: () {
          isChecked = false;
          isAddWithinDhabiBeneficiary = isChecked;
          triggerCheckBoxEvent(isChecked);
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
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
          isAddWithinDhabiBeneficiary = isChecked;
          triggerCheckBoxEvent(isChecked);
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.uncheckedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    }
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc proceedBloc = context.read<ShowButtonBloc>();
    if (isAccNumValid) {
      return GradientButton(
        onTap: () async {
          final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
          if (!isFetchingCustDets) {
            if (!isProceed) {
              isFetchingCustDets = true;
              showButtonBloc.add(ShowButtonEvent(show: isFetchingCustDets));
              log("Get Dhabi Cust Dets Request -> ${{
                "accountNumber": _ibanController.text,
              }}");
              var getDhabiCustDetsResult =
                  await MapDhabiCustomerDetails.mapDhabiCustomerDetails(
                {
                  "accountNumber": _ibanController.text,
                },
                token ?? "",
              );
              log("getDhabiCustDetsResult -> $getDhabiCustDetsResult");

              if (getDhabiCustDetsResult["success"]) {
                isProceed = true;
                buttonText = labels[31]["labelText"];
                _recipientNameController.text = ObscureHelper.obscureName(
                    getDhabiCustDetsResult["customerName"]);
                benCustomerName = getDhabiCustDetsResult["customerName"];
                receiverAccountNumber = _ibanController.text;
                receiverCurrency = senderCurrency;
                receiverCurrencyFlag = senderCurrencyFlag;
                proceedBloc.add(ShowButtonEvent(show: isProceed));
              } else {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        svgAssetPath: ImageConstants.warning,
                        title: "Sorry!",
                        message: getDhabiCustDetsResult["message"] ??
                            "Error getting Dhabi Customer Details",
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
              isFetchingCustDets = false;
              showButtonBloc.add(ShowButtonEvent(show: isFetchingCustDets));
            } else {
              if (!isFetchingExchangeRate) {
                isFetchingExchangeRate = true;
                showButtonBloc
                    .add(ShowButtonEvent(show: isFetchingExchangeRate));

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
                          fetchExchangeRate["exchangeRate"].toDouble();
                      log("exchangeRate -> $exchangeRate");
                      fees = double.parse(
                          fetchExchangeRate["transferFee"].split(' ').last);
                      log("fees -> $fees");
                      expectedTime = getExchRateApiResult["expectedTime"];
                      break;
                    }
                  }

                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      Routes.transferAmount,
                      arguments: SendMoneyArgumentModel(
                        isBetweenAccounts: sendMoneyArgument.isBetweenAccounts,
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
                          message: getExchRateApiResult["message"] ??
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
                showButtonBloc
                    .add(ShowButtonEvent(show: isFetchingExchangeRate));
              }
            }
          }
        },
        text: buttonText,
        auxWidget: isFetchingCustDets || isFetchingExchangeRate
            ? const LoaderRow()
            : const SizeBox(),
      );
    } else {
      return SolidButton(onTap: () {}, text: labels[174]["labelText"]);
    }
  }

  @override
  void dispose() {
    _ibanController.dispose();
    _recipientNameController.dispose();
    super.dispose();
  }
}
