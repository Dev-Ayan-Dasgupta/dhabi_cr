// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/arguments/transfer_details.dart';
import 'package:dialup_mobile_app/data/repositories/payments/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/models/widgets/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final DraggableScrollableController _dsController =
      DraggableScrollableController();

  Map<String, dynamic> getRcntTxnApiResult = {};
  List<Map<String, dynamic>> moneyTransfers = [];
  List displayStatementList = [];

  bool isFetchingTxns = false;

  bool isShowFilter = false;
  bool isShowSort = false;

  String filterText = "All";
  String sortText = "Latest";

  bool isDateNewest = true;
  bool isDateOldest = false;
  bool isAmountHighest = false;
  bool isAmountLowest = false;

  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getRecentTransactions();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    log("sendMoneyArgument -> $sendMoneyArgument");
  }

  Future<void> getRecentTransactions() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isFetchingTxns = true;
    showButtonBloc.add(ShowButtonEvent(show: isFetchingTxns));
    try {
      log("getRcntTxnApi Request -> ${{
        "startDate": DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 30))),
        "endDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      }}");
      getRcntTxnApiResult = await MapRecentTransactions.mapRecentTransactions(
        {
          "startDate": DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(const Duration(days: 30))),
          "endDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
        token ?? "",
      );
      log("getRcntTxnApiResult -> $getRcntTxnApiResult");
      if (getRcntTxnApiResult["success"]) {
        moneyTransfers.clear();
        displayStatementList.clear();
        for (var moneyTransfer in getRcntTxnApiResult["moneyTransfers"]) {
          moneyTransfers.add(moneyTransfer);
        }
        displayStatementList.addAll(moneyTransfers);
        sortDisplayStatementList(
          isDateNewest,
          isDateOldest,
          isAmountHighest,
          isAmountLowest,
        );
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry!",
                message: getRcntTxnApiResult["message"] ??
                    "There was an error in fetching your recent transactions, please try again later.",
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
    } catch (_) {
      rethrow;
    }
    isFetchingTxns = false;
    showButtonBloc.add(ShowButtonEvent(show: isFetchingTxns));
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
                Text(
                  labels[9]["labelText"],
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 10),
                Text(
                  "Please select an option to transfer funds",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark50,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                TopicTile(
                  onTap: () {
                    if (canTransferInternalFund) {
                      receiverCurrenciesBank.clear();
                      receiverCurrenciesBank.add(DropDownCountriesModel(
                        countrynameOrCode: "",
                        countryFlagBase64: "",
                        isEnabled: true,
                      ));
                      exchangeRate = 1;
                      log("exchangeRate -> $exchangeRate");
                      Navigator.pushNamed(
                        context,
                        Routes.sendMoneyFrom,
                        arguments: SendMoneyArgumentModel(
                          isBetweenAccounts: true,
                          isWithinDhabi: false,
                          isRemittance: false,
                          isRetail: sendMoneyArgument.isRetail,
                        ).toMap(),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "No Permission",
                            message:
                                "You do not have permission to make internal fund transfer for this account",
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
                  iconPath: ImageConstants.moveDown,
                  text: labels[149]["labelText"],
                ),
                const SizeBox(height: 10),
                TopicTile(
                  onTap: () {
                    if (canTransferDhabiFund) {
                      receiverCurrenciesWallet.clear();
                      receiverCurrenciesWallet.add(DropDownCountriesModel(
                        countrynameOrCode: "",
                        countryFlagBase64: "",
                        isEnabled: true,
                      ));
                      exchangeRate = 1;
                      log("exchangeRate -> $exchangeRate");
                      Navigator.pushNamed(
                        context,
                        Routes.sendMoneyFrom,
                        arguments: SendMoneyArgumentModel(
                          isBetweenAccounts: false,
                          isWithinDhabi: true,
                          isRemittance: false,
                          isRetail: sendMoneyArgument.isRetail,
                        ).toMap(),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "No Permission",
                            message:
                                "You do not have permission to make within Dhabi fund transfer for this account",
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
                  iconPath: ImageConstants.accountBalance,
                  text: labels[150]["labelText"],
                ),
                const SizeBox(height: 10),
                // TopicTile(
                //   onTap: () {
                //     Navigator.pushNamed(context, Routes.addRecipDetUae);
                //   },
                //   iconPath: ImageConstants.flagCircle,
                //   text: labels[151]["labelText"],
                // ),
                // const SizeBox(height: 10),
                TopicTile(
                  onTap: () {
                    if (canTransferInternationalFund) {
                      receiverCurrenciesWallet.clear();
                      receiverCurrenciesWallet.add(DropDownCountriesModel(
                        countrynameOrCode: "",
                        countryFlagBase64: "",
                        isEnabled: true,
                      ));
                      Navigator.pushNamed(
                        context,
                        Routes.sendMoneyFrom,
                        arguments: SendMoneyArgumentModel(
                          isBetweenAccounts: false,
                          isWithinDhabi: false,
                          isRemittance: true,
                          isRetail: sendMoneyArgument.isRetail,
                        ).toMap(),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "No Permission",
                            message:
                                "You do not have permission to make international fund transfer for this account",
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
                  iconPath: ImageConstants.public,
                  text: labels[152]["labelText"],
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.50,
            minChildSize: 0.50,
            maxChildSize: 1,
            controller: _dsController,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: [
                  Container(
                    height: 90.h,
                    width: 100.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: (PaddingConstants.horizontalPadding /
                              Dimensions.designWidth)
                          .w,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: const Color(0XFFEEEEEE)),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular((20 / Dimensions.designWidth).w),
                        topRight:
                            Radius.circular((20 / Dimensions.designWidth).w),
                      ),
                      color: const Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        const SizeBox(height: 15),
                        // ! Clip widget for drag
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: (10 / Dimensions.designWidth).w,
                          ),
                          height: (7 / Dimensions.designWidth).w,
                          width: (50 / Dimensions.designWidth).w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular((10 / Dimensions.designWidth).w),
                            ),
                            color: const Color(0xFFD9D9D9),
                          ),
                        ),
                        const SizeBox(height: 15),
                        BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          builder: (context, state) {
                            return Ternary(
                              condition: isFetchingTxns,
                              truthy: Column(
                                children: [
                                  const SizeBox(height: 120),
                                  SpinKitFadingCircle(
                                    color: AppColors.primary,
                                    size: (50 / Dimensions.designWidth).w,
                                  ),
                                ],
                              ),
                              falsy: Ternary(
                                condition: !isShowFilter && !isShowSort,
                                truthy: SizedBox(
                                  height: 85.h,
                                  child: Column(
                                    children: [
                                      // ! Recent Transactions
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            labels[10]["labelText"],
                                            style: TextStyles.primary.copyWith(
                                              color: AppColors.dark50,
                                              fontSize:
                                                  (16 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizeBox(height: 15),
                                      // ! Sort filter bar
                                      Container(
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                (10 / Dimensions.designWidth)
                                                    .w),
                                          ),
                                          color: AppColors.primary10,
                                        ),
                                        padding: EdgeInsets.all(
                                          (10 / Dimensions.designWidth).w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // InkWell(
                                            //   onTap: () {
                                            //     final ShowButtonBloc
                                            //         showButtonBloc = context
                                            //             .read<ShowButtonBloc>();
                                            //     isShowFilter = true;
                                            //     showButtonBloc.add(
                                            //       ShowButtonEvent(
                                            //           show: isShowFilter),
                                            //     );
                                            //   },
                                            //   child: Row(
                                            //     children: [
                                            //       SvgPicture.asset(
                                            //         ImageConstants.filter,
                                            //         width: (12 /
                                            //                 Dimensions
                                            //                     .designHeight)
                                            //             .w,
                                            //         height: (12 /
                                            //                 Dimensions
                                            //                     .designWidth)
                                            //             .w,
                                            //       ),
                                            //       const SizeBox(width: 5),
                                            //       Text(
                                            //         filterText,
                                            //         style: TextStyles
                                            //             .primaryMedium
                                            //             .copyWith(
                                            //           color: AppColors.primary,
                                            //           fontSize: (14 /
                                            //                   Dimensions
                                            //                       .designWidth)
                                            //               .w,
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            // const SizeBox(width: 10),
                                            // Text(
                                            //   "|",
                                            //   style: TextStyles.primaryMedium
                                            //       .copyWith(
                                            //     color: AppColors.dark50,
                                            //     fontSize: (16 /
                                            //             Dimensions.designWidth)
                                            //         .w,
                                            //   ),
                                            // ),
                                            // const SizeBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                final ShowButtonBloc
                                                    showButtonBloc = context
                                                        .read<ShowButtonBloc>();
                                                isShowSort = true;
                                                showButtonBloc.add(
                                                  ShowButtonEvent(
                                                      show: isShowSort),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImageConstants.sort,
                                                    width: (10 /
                                                            Dimensions
                                                                .designHeight)
                                                        .w,
                                                    height: (10 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                  ),
                                                  const SizeBox(width: 5),
                                                  Text(
                                                    sortText,
                                                    style: TextStyles
                                                        .primaryMedium
                                                        .copyWith(
                                                      color: AppColors.primary,
                                                      fontSize: (14 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizeBox(height: 15),
                                      // ! Transaction list
                                      Ternary(
                                        condition: displayStatementList.isEmpty,
                                        truthy: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizeBox(height: 70),
                                            Text(
                                              "No transactions",
                                              style: TextStyles.primaryBold
                                                  .copyWith(
                                                color: AppColors.dark30,
                                                fontSize: (24 /
                                                        Dimensions.designWidth)
                                                    .w,
                                              ),
                                            ),
                                          ],
                                        ),
                                        falsy: Expanded(
                                          child: ListView.builder(
                                            controller: scrollController,
                                            itemCount:
                                                displayStatementList.length,
                                            itemBuilder: (context, index) {
                                              return RecentTransferTile(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    Routes.transferDetails,
                                                    arguments:
                                                        TransferDetailsArgumentModel(
                                                      transactionType:
                                                          displayStatementList[
                                                                      index][
                                                                  "transactionType"] ??
                                                              "",
                                                      status: displayStatementList[
                                                                  index][
                                                              "transactionStatus"] ??
                                                          "",
                                                      referenceNumber:
                                                          displayStatementList[
                                                                      index][
                                                                  "transactionRefNo"] ??
                                                              "",
                                                      beneficiaryName:
                                                          displayStatementList[
                                                                      index][
                                                                  "beneficiaryName"] ??
                                                              "",
                                                      beneficiaryAccountNo:
                                                          displayStatementList[
                                                                      index][
                                                                  "beneficiaryAccountNo"] ??
                                                              "",
                                                      transferAmount:
                                                          displayStatementList[
                                                                      index][
                                                                  "debitAmount"] ??
                                                              "",
                                                      transferDate:
                                                          displayStatementList[
                                                                      index][
                                                                  "transferDate"] ??
                                                              "",
                                                      fee: displayStatementList[
                                                              index]["fee"] ??
                                                          "",
                                                      exchangeRate:
                                                          displayStatementList[
                                                                      index]
                                                                  ["fxRate"] ??
                                                              "",
                                                      creditAmount:
                                                          displayStatementList[
                                                                      index][
                                                                  "transferAmount"] ??
                                                              "",
                                                      benBankName: displayStatementList[
                                                                  index]
                                                              ["benBankName"] ??
                                                          displayStatementList[
                                                                  index][
                                                              "benWalletName"] ??
                                                          "",
                                                      benCountry:
                                                          displayStatementList[
                                                                      index][
                                                                  "benCountry"] ??
                                                              "",
                                                      benWalletName:
                                                          displayStatementList[
                                                                      index][
                                                                  "benWalletName"] ??
                                                              "",
                                                      benWalletNo:
                                                          displayStatementList[
                                                                      index][
                                                                  "benWalletNo"] ??
                                                              "",
                                                      reasonForSending:
                                                          displayStatementList[
                                                                      index][
                                                                  "reasonForSending"] ??
                                                              "",
                                                    ).toMap(),
                                                  );
                                                },
                                                iconPath: displayStatementList[
                                                                index][
                                                            "transactionType"] ==
                                                        "LocalTransfer"
                                                    ? ImageConstants.moveDown
                                                    : displayStatementList[
                                                                    index][
                                                                "transactionType"] ==
                                                            "Internal"
                                                        ? ImageConstants
                                                            .accountBalance
                                                        : ImageConstants.public,
                                                name: displayStatementList[
                                                            index]
                                                        ["beneficiaryName"] ??
                                                    "",
                                                status: displayStatementList[
                                                            index]
                                                        ["transactionStatus"] ??
                                                    "",
                                                amount: displayStatementList[
                                                                index]
                                                            ["debitAmount"] !=
                                                        null
                                                    ? displayStatementList[
                                                                index]
                                                            ["debitAmount"]
                                                        .split(' ')
                                                        .first
                                                    : "0",
                                                currency: "USD",
                                                accountNumber:
                                                    displayStatementList[index][
                                                            "beneficiaryAccountNo"] ??
                                                        "",
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ! Sort filter UI
                                falsy: SizedBox(
                                  height: 85.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Sort",
                                                  style: TextStyles.primaryBold
                                                      .copyWith(
                                                          color:
                                                              AppColors.dark50,
                                                          fontSize: (20 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    final ShowButtonBloc
                                                        showButtonBloc =
                                                        context.read<
                                                            ShowButtonBloc>();
                                                    isShowSort = false;
                                                    showButtonBloc.add(
                                                      ShowButtonEvent(
                                                        show: isShowSort,
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyles
                                                        .primaryBold
                                                        .copyWith(
                                                            color: AppColors
                                                                .primary,
                                                            fontSize: (16 /
                                                                    Dimensions
                                                                        .designWidth)
                                                                .w),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizeBox(height: 20),
                                            Text(
                                              "Date",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                      color: AppColors.dark50,
                                                      fontSize: (16 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w),
                                            ),
                                            const SizeBox(height: 15),
                                            MultiSelectButton(
                                              isSelected: isDateNewest,
                                              content: Text(
                                                "Newest first",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  color: AppColors.primaryDark,
                                                  fontSize: (18 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                              ),
                                              onTap: () {
                                                final ShowButtonBloc
                                                    showButtonBloc = context
                                                        .read<ShowButtonBloc>();
                                                isDateNewest = true;
                                                isDateOldest = false;
                                                isAmountHighest = false;
                                                isAmountLowest = false;
                                                sortText = "Latest";
                                                sortDisplayStatementList(
                                                  isDateNewest,
                                                  isDateOldest,
                                                  isAmountHighest,
                                                  isAmountLowest,
                                                );
                                                isShowSort = false;
                                                showButtonBloc.add(
                                                  ShowButtonEvent(
                                                    show: isDateNewest &&
                                                        isDateOldest &&
                                                        isAmountHighest &&
                                                        isAmountLowest,
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizeBox(height: 10),
                                            MultiSelectButton(
                                              isSelected: isDateOldest,
                                              content: Text(
                                                "Oldest first",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  color: AppColors.primaryDark,
                                                  fontSize: (18 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                              ),
                                              onTap: () {
                                                final ShowButtonBloc
                                                    showButtonBloc = context
                                                        .read<ShowButtonBloc>();
                                                isDateNewest = false;
                                                isDateOldest = true;
                                                isAmountHighest = false;
                                                isAmountLowest = false;
                                                sortText = "Oldest";
                                                sortDisplayStatementList(
                                                  isDateNewest,
                                                  isDateOldest,
                                                  isAmountHighest,
                                                  isAmountLowest,
                                                );
                                                isShowSort = false;
                                                showButtonBloc.add(
                                                  ShowButtonEvent(
                                                    show: isDateNewest &&
                                                        isDateOldest &&
                                                        isAmountHighest &&
                                                        isAmountLowest,
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizeBox(height: 20),
                                            Text(
                                              "Amount",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                      color: AppColors.dark50,
                                                      fontSize: (16 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w),
                                            ),
                                            const SizeBox(height: 15),
                                            MultiSelectButton(
                                              isSelected: isAmountHighest,
                                              content: Text(
                                                "Highest amount first",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  color: AppColors.primaryDark,
                                                  fontSize: (18 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                              ),
                                              onTap: () {
                                                final ShowButtonBloc
                                                    showButtonBloc = context
                                                        .read<ShowButtonBloc>();
                                                isDateNewest = false;
                                                isDateOldest = false;
                                                isAmountHighest = true;
                                                isAmountLowest = false;
                                                sortText = "Highest";
                                                sortDisplayStatementList(
                                                  isDateNewest,
                                                  isDateOldest,
                                                  isAmountHighest,
                                                  isAmountLowest,
                                                );
                                                isShowSort = false;
                                                showButtonBloc.add(
                                                  ShowButtonEvent(
                                                    show: isDateNewest &&
                                                        isDateOldest &&
                                                        isAmountHighest &&
                                                        isAmountLowest,
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizeBox(height: 10),
                                            MultiSelectButton(
                                              isSelected: isAmountLowest,
                                              content: Text(
                                                "Lowest amount first",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  color: AppColors.primaryDark,
                                                  fontSize: (18 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                              ),
                                              onTap: () {
                                                final ShowButtonBloc
                                                    showButtonBloc = context
                                                        .read<ShowButtonBloc>();
                                                isDateNewest = false;
                                                isDateOldest = false;
                                                isAmountHighest = false;
                                                isAmountLowest = true;
                                                sortText = "Lowest";
                                                sortDisplayStatementList(
                                                  isDateNewest,
                                                  isDateOldest,
                                                  isAmountHighest,
                                                  isAmountLowest,
                                                );
                                                isShowSort = false;
                                                showButtonBloc.add(
                                                  ShowButtonEvent(
                                                    show: isDateNewest &&
                                                        isDateOldest &&
                                                        isAmountHighest &&
                                                        isAmountLowest,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void populateDisplayStatementList(
      bool isAll, bool isInternal, bool isProcessed) {
    // displayStatementList.clear();
    // if (isAll) {
    //   displayStatementList.addAll(moneyTransfers);
    // }
    // if (isSent) {
    //   for (var statement in moneyTransfers) {
    //     if (statement["creditAmount"] == 0) {
    //       displayStatementList.add(statement);
    //     }
    //   }
    // }
    // if (isReceived) {
    //   for (var statement in moneyTransfers) {
    //     if (statement["debitAmount"] == 0) {
    //       displayStatementList.add(statement);
    //     }
    //   }
    // }
  }

  void sortDisplayStatementList(
      bool isNewest, bool isOldest, bool isHighest, bool isLowest) {
    if (isNewest) {
      displayStatementList.sort((a, b) => (b["transferDate"])
          .toString()
          .compareTo((a["transferDate"]).toString()));
      // DateTime.parse(b["transferDate"])
      //     .compareTo(DateTime.parse(a["transferDate"])));
    }
    if (isOldest) {
      displayStatementList.sort((a, b) => (a["transferDate"])
          .toString()
          .compareTo((b["transferDate"]).toString()));
      // DateTime.parse(a["transferDate"])
      //     .compareTo(DateTime.parse(b["transferDate"])));
    }
    if (isHighest) {
      displayStatementList.sort((a, b) => double.parse(b["debitAmount"])
          .compareTo(double.parse(a["debitAmount"])));
    }
    if (isLowest) {
      displayStatementList.sort((a, b) => double.parse(a["debitAmount"])
          .compareTo(double.parse(b["debitAmount"])));
    }
  }
}
