// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/data/repositories/corporateAccounts/index.dart';
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
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class DepositConfirmationScreen extends StatefulWidget {
  const DepositConfirmationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<DepositConfirmationScreen> createState() =>
      _DepositConfirmationScreenState();
}

class _DepositConfirmationScreenState extends State<DepositConfirmationScreen> {
  List<DetailsTileModel> depositDetails = [];

  bool isChecked = false;
  bool isLoading = false;

  late DepositConfirmationArgumentModel depositConfirmationModel;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    depositConfirmationModel = DepositConfirmationArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
    depositDetails.add(DetailsTileModel(
        key: "Debit Account", value: depositConfirmationModel.accountNumber));
    depositDetails.add(DetailsTileModel(
        key: "Deposit Amount",
        value:
            "USD ${depositConfirmationModel.depositAmount >= 1000 ? NumberFormat('#,000.00').format(depositConfirmationModel.depositAmount) : depositConfirmationModel.depositAmount.toStringAsFixed(2)
            // depositConfirmationModel.depositAmount.toStringAsFixed(2)
            }"));
    depositDetails.add(DetailsTileModel(
        key: "Tenure",
        value: DaysToMonths.daysToMonths(depositConfirmationModel.tenureDays)));
    depositDetails.add(DetailsTileModel(
        key: "Interest Rate",
        value: "${depositConfirmationModel.interestRate}%"));
    depositDetails.add(DetailsTileModel(
        key: "Interest Amount",
        value:
            "USD ${depositConfirmationModel.interestAmount >= 1000 ? NumberFormat('#,000.00').format(depositConfirmationModel.interestAmount) : depositConfirmationModel.interestAmount.toStringAsFixed(2)}"));
    depositDetails.add(DetailsTileModel(
        key: "Interest Payout",
        value: depositConfirmationModel.interestPayout));
    depositDetails.add(DetailsTileModel(
        key: "On Maturity",
        value: depositConfirmationModel.isAutoRenewal
            ? labels[114]["labelText"]
            : labels[115]["labelText"]));
    depositDetails.add(DetailsTileModel(
        key: "Credit Account Number",
        value: depositConfirmationModel.creditAccountNumber));
    depositDetails.add(DetailsTileModel(
        key: "Date of Maturity",
        value: DateFormat('MMM - dd - yyyy')
            .format(depositConfirmationModel.dateOfMaturity)));
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
                  // const SizeBox(height: 10),
                  Text(
                    "Deposit Confirmation",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please review the deposit details and click proceed to confirm",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.black63,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: depositDetails.length,
                      details: depositDetails,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                // Row(
                //   children: [
                //     BlocBuilder<CheckBoxBloc, CheckBoxState>(
                //       builder: buildTC,
                //     ),
                //     const SizeBox(width: 10),
                //     Text(
                //       "I've read all the terms and conditions",
                //       style: TextStyles.primary.copyWith(
                //         color: const Color(0XFF414141),
                //         fontSize: (16 / Dimensions.designWidth).w,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildSubmitButton,
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTC(BuildContext context, CheckBoxState state) {
    if (isChecked) {
      return InkWell(
        onTap: () {
          isChecked = false;
          triggerCheckBoxEvent(isChecked);
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(ImageConstants.checkedBox),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          isChecked = true;
          triggerCheckBoxEvent(isChecked);
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(ImageConstants.uncheckedBox),
        ),
      );
    }
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    return GradientButton(
      onTap: () async {
        // TODO: call create FD API
        if (!isLoading) {
          final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
          isLoading = true;
          showButtonBloc.add(ShowButtonEvent(show: isLoading));

          if (depositConfirmationModel.isRetail) {
            log("Request -> ${{
              "currency": depositConfirmationModel.currency,
              "amount": depositConfirmationModel.depositAmount,
              "maturityDate": DateFormat('yyyy-MM-dd')
                  .format(depositConfirmationModel.dateOfMaturity),
              "interestRate": depositConfirmationModel.interestRate,
              "tenure": DaysToMonths.daysToMonths(
                  depositConfirmationModel.tenureDays),
              "interestPayout": depositConfirmationModel.interestPayout,
              "accountNumber": depositConfirmationModel.accountNumber,
              "autoRollover": depositConfirmationModel.isAutoRenewal,
              "autoFundTransfer": depositConfirmationModel.isAutoTransfer,
              "beneficiary": {
                "accountNumber":
                    depositConfirmationModel.depositBeneficiary.accountNumber,
                "name": depositConfirmationModel.depositBeneficiary.name,
                "address": depositConfirmationModel.depositBeneficiary.address,
                "accountType":
                    depositConfirmationModel.depositBeneficiary.accountType,
                "swiftReference":
                    depositConfirmationModel.depositBeneficiary.swiftReference,
              },
              "saveBeneficiary":
                  depositConfirmationModel.depositBeneficiary.saveBeneficiary,
              "reasonForSending":
                  depositConfirmationModel.depositBeneficiary.reasonForSending,
            }}");

            var createFDResult = await MapCreateFd.mapCreateFd(
              {
                "currency": depositConfirmationModel.currency,
                "amount": depositConfirmationModel.depositAmount,
                "maturityDate": DateFormat('yyyy-MM-dd')
                    .format(depositConfirmationModel.dateOfMaturity),
                "interestRate": depositConfirmationModel.interestRate,
                "tenure": DaysToMonths.daysToMonths(
                    depositConfirmationModel.tenureDays),
                "interestPayout": depositConfirmationModel.interestPayout,
                "accountNumber": depositConfirmationModel.accountNumber,
                "autoRollover": depositConfirmationModel.isAutoRenewal,
                "autoFundTransfer": depositConfirmationModel.isAutoTransfer,
                "beneficiary": {
                  "accountNumber":
                      depositConfirmationModel.depositBeneficiary.accountNumber,
                  "name": depositConfirmationModel.depositBeneficiary.name,
                  "address":
                      depositConfirmationModel.depositBeneficiary.address,
                  "accountType":
                      depositConfirmationModel.depositBeneficiary.accountType,
                  "swiftReference": depositConfirmationModel
                      .depositBeneficiary.swiftReference,
                },
                "saveBeneficiary":
                    depositConfirmationModel.depositBeneficiary.saveBeneficiary,
                "reasonForSending": depositConfirmationModel
                    .depositBeneficiary.reasonForSending,
              },
              token ?? "",
            );

            log("Create FD API response -> $createFDResult");

            if (createFDResult["success"]) {
              if (context.mounted) {
                Navigator.pushNamed(
                  context,
                  Routes.errorSuccessScreen,
                  arguments: ErrorArgumentModel(
                    hasSecondaryButton: false,
                    iconPath: ImageConstants.checkCircleOutlined,
                    title: "Congratulations!",
                    message:
                        "Your deposit number ${createFDResult["accountNumber"]} has been created. It will be visible soon on the mobile application. For assistance, please call us at $customerCarePhone.",
                    buttonText: labels[1]["labelText"],
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.retailDashboard,
                        (route) => false,
                        arguments: RetailDashboardArgumentModel(
                          imgUrl: "",
                          name: customerName ?? "",
                          isFirst: storageIsFirstLogin == true ? false : true,
                        ).toMap(),
                      );
                    },
                    buttonTextSecondary: "",
                    onTapSecondary: () {},
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
                      title: "Error",
                      message:
                          "There was an error in creating a fixed deposit, please try again after some time.",
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
            log("Corporate FD API Request -> ${{
              "currency": depositConfirmationModel.currency,
              "amount": depositConfirmationModel.depositAmount,
              "maturityDate": DateFormat('yyyy-MM-dd')
                  .format(depositConfirmationModel.dateOfMaturity),
              "interestRate": depositConfirmationModel.interestRate,
              "tenure": DaysToMonths.daysToMonths(
                  depositConfirmationModel.tenureDays),
              "interestPayout": depositConfirmationModel.interestPayout,
              "accountNumber": depositConfirmationModel.accountNumber,
              "autoRollover": depositConfirmationModel.isAutoRenewal,
              "autoFundTransfer": depositConfirmationModel.isAutoTransfer,
              "beneficiary": {
                "accountNumber":
                    depositConfirmationModel.depositBeneficiary.accountNumber,
                "name": depositConfirmationModel.depositBeneficiary.name,
                "address": depositConfirmationModel.depositBeneficiary.address,
                "accountType":
                    depositConfirmationModel.depositBeneficiary.accountType,
                "swiftReference":
                    depositConfirmationModel.depositBeneficiary.swiftReference,
              },
              "saveBeneficiary":
                  depositConfirmationModel.depositBeneficiary.saveBeneficiary,
              "reasonForSending":
                  depositConfirmationModel.depositBeneficiary.reasonForSending,
            }}");

            var createCorporateFDResult =
                await MapCreateCorporateFd.mapCreateCorporateFd(
              {
                "currency": depositConfirmationModel.currency,
                "amount": depositConfirmationModel.depositAmount,
                "maturityDate": DateFormat('yyyy-MM-dd')
                    .format(depositConfirmationModel.dateOfMaturity),
                "interestRate": depositConfirmationModel.interestRate,
                "tenure": DaysToMonths.daysToMonths(
                    depositConfirmationModel.tenureDays),
                "interestPayout": depositConfirmationModel.interestPayout,
                "accountNumber": depositConfirmationModel.accountNumber,
                "autoRollover": depositConfirmationModel.isAutoRenewal,
                "autoFundTransfer": depositConfirmationModel.isAutoTransfer,
                "beneficiary": {
                  "accountNumber":
                      depositConfirmationModel.depositBeneficiary.accountNumber,
                  "name": depositConfirmationModel.depositBeneficiary.name,
                  "address":
                      depositConfirmationModel.depositBeneficiary.address,
                  "accountType":
                      depositConfirmationModel.depositBeneficiary.accountType,
                  "swiftReference": depositConfirmationModel
                      .depositBeneficiary.swiftReference,
                },
                "saveBeneficiary":
                    depositConfirmationModel.depositBeneficiary.saveBeneficiary,
                "reasonForSending": depositConfirmationModel
                    .depositBeneficiary.reasonForSending,
              },
              token ?? "",
            );

            log("Create Corporate FD API response -> $createCorporateFDResult");

            if (createCorporateFDResult["success"]) {
              if (context.mounted) {
                Navigator.pushNamed(
                  context,
                  Routes.errorSuccessScreen,
                  arguments: ErrorArgumentModel(
                    hasSecondaryButton: false,
                    iconPath: ImageConstants.checkCircleOutlined,
                    title: createCorporateFDResult["isDirectlyCreated"]
                        ? "Congratulations!"
                        : "Create Deposit Request Placed",
                    message: createCorporateFDResult["isDirectlyCreated"]
                        ? "Your deposit account has been created.\nAcc. ${createCorporateFDResult["reference"]}"
                        : "${messages[121]["messageText"]}: ${createCorporateFDResult["reference"]}",
                    buttonText: labels[1]["labelText"],
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.businessDashboard,
                        (route) => false,
                        arguments: RetailDashboardArgumentModel(
                          imgUrl: storageProfilePhotoBase64 ?? "",
                          name: profileName ?? "",
                          isFirst: storageIsFirstLogin == true ? false : true,
                        ).toMap(),
                      );
                    },
                    buttonTextSecondary: "",
                    onTapSecondary: () {},
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
                      title: "Error",
                      message:
                          "There was an error in creating a fixed deposit, please try again after some time.",
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

          isLoading = false;
          showButtonBloc.add(ShowButtonEvent(show: isLoading));
        }
      },
      text: labels[31]["labelText"],
      auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
    );
  }
}
