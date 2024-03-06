// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/bloc/showButton/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/corporateAccounts/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final DraggableScrollableController _dsController =
      DraggableScrollableController();

  bool isShowFilter = false;
  bool isShowSort = false;

  String filterText = "All";
  String sortText = "Latest";

  // List statementList = [];
  List displayStatementList = [];

  bool isAllSelected = false;
  bool isSentSelected = false;
  bool isReceivedSelected = false;

  bool isDateNewest = true;
  bool isDateOldest = false;
  bool isAmountHighest = false;
  bool isAmountLowest = false;

  bool isDeactivating = false;

  late AccountDetailsArgumentModel accountDetailsArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    accountDetailsArgument =
        AccountDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
    populateDisplayStatementList(true, isSentSelected, isReceivedSelected);
    sortDisplayStatementList(
      isDateNewest,
      isDateOldest,
      isAmountHighest,
      isAmountLowest,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.downloadStatement,
                arguments: DownloadStatementArgumentModel(
                  accountNumber: accountDetailsArgument.accountNumber,
                  accountType: accountDetailsArgument.accountType,
                  ibanNumber: accountDetailsArgument.iban,
                ).toMap(),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
                vertical: (15 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(ImageConstants.statement),
            ),
          ),
        ],
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
                  "Account Details",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                InfoCard(
                  onTap: () {
                    Share.share(
                      "Name: $profileName\nIBAN: ${accountDetailsArgument.iban}\nAccount Number: ${accountDetailsArgument.accountNumber}\nAccount Type: ${accountDetailsArgument.accountType}",
                    );
                  },
                  name: profileName ?? "",
                  iban: accountDetailsArgument.iban,
                  bic: "DHILAEAD",
                  flagImgUrl: accountDetailsArgument.flagImgUrl,
                  accountNumber: accountDetailsArgument.accountNumber,
                  accountType: accountDetailsArgument.accountType,
                  currency: accountDetailsArgument.currency,
                  balance: accountDetailsArgument.balance,
                ),
                const SizeBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ternary(
                      condition: accountDetailsArgument.isRetail ||
                          // !isMaker ||
                          accountDetailsArgument.canDeactivateAccount ==
                              false ||
                          isAccountPendingDeactivationRequest ||
                          isAccountPendingActivationRequest,
                      truthy: const SizeBox(),
                      falsy: DashboardActivityTile(
                        iconPath: ImageConstants.acUnit,
                        activityText: accountStatus == "ACTIVE"
                            ? labels[70]["labelText"]
                            : labels[77]["labelText"],
                        onTap: () {
                          if (accountDetailsArgument.isRetail == false) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  svgAssetPath: ImageConstants.warning,
                                  title: labels[250]["labelText"],
                                  message:
                                      "This action will temporarily prevent any withdrawals from your corporate account, please confirm.",
                                  auxWidget: BlocBuilder<ShowButtonBloc,
                                      ShowButtonState>(
                                    builder: (context, state) {
                                      return GradientButton(
                                        onTap: () async {
                                          if (!isDeactivating) {
                                            final ShowButtonBloc
                                                showButtonBloc =
                                                context.read<ShowButtonBloc>();
                                            isDeactivating = true;
                                            showButtonBloc.add(ShowButtonEvent(
                                                show: isDeactivating));

                                            log("closeDeactApi Request -> ${{
                                              "accountNumber":
                                                  accountDetailsArgument
                                                      .accountNumber,
                                              "closeAccount":
                                                  accountStatus == "ACTIVE"
                                                      ? false
                                                      : true,
                                            }}");
                                            var closeDeactApiResult =
                                                await MapCloseOrDeactivateAccount
                                                    .mapCloseOrDeactivateAccount(
                                              {
                                                "accountNumber":
                                                    accountDetailsArgument
                                                        .accountNumber,
                                                "closeAccount":
                                                    accountStatus == "ACTIVE"
                                                        ? false
                                                        : true,
                                              },
                                              token ?? "",
                                            );
                                            log("closeDeactApiResult -> $closeDeactApiResult");

                                            if (closeDeactApiResult[
                                                "success"]) {
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomDialog(
                                                      svgAssetPath: ImageConstants
                                                          .checkCircleOutlined,
                                                      title:
                                                          "Deactivation Request Placed",
                                                      message:
                                                          "${messages[121]["messageText"]}: ${closeDeactApiResult["reference"]}",
                                                      actionWidget:
                                                          GradientButton(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
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
                                                      message: closeDeactApiResult[
                                                              "message"] ??
                                                          "Error while placing deactivating acount request, please try again later",
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

                                            isDeactivating = true;
                                            showButtonBloc.add(ShowButtonEvent(
                                                show: isDeactivating));
                                          }
                                        },
                                        text: labels[147]["labelText"],
                                        auxWidget: isDeactivating
                                            ? const LoaderRow()
                                            : const SizeBox(),
                                      );
                                    },
                                  ),
                                  actionWidget: SolidButton(
                                    color: AppColors.primaryBright17,
                                    fontColor: AppColors.primary,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    text: "Cancel",
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    SizeBox(
                        width: accountDetailsArgument.isRetail ||
                                // !isMaker ||
                                accountDetailsArgument.canDeactivateAccount ==
                                    false ||
                                isAccountPendingDeactivationRequest ||
                                isAccountPendingActivationRequest
                            ? 0
                            : 25),
                    DashboardActivityTile(
                      iconPath: ImageConstants.arrowOutward,
                      activityText: labels[9]["labelText"],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.sendMoney,
                          arguments: SendMoneyArgumentModel(
                            isBetweenAccounts: false,
                            isWithinDhabi: false,
                            isRemittance: false,
                            isRetail: accountDetailsArgument.isRetail,
                          ).toMap(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.39,
            minChildSize: 0.39,
            maxChildSize: 1,
            controller: _dsController,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: [
                  // ! Outer Container
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
                              condition: !isShowFilter && !isShowSort,
                              truthy: SizedBox(
                                height: 85.h,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          labels[10]["labelText"],
                                          style: TextStyles.primary.copyWith(
                                            color: AppColors.dark50,
                                            fontSize:
                                                (16 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.downloadStatement,
                                              arguments:
                                                  DownloadStatementArgumentModel(
                                                accountNumber: accountDetails[
                                                    storageChosenAccount ??
                                                        0]["accountNumber"],
                                                ibanNumber: accountDetails[
                                                    storageChosenAccount ??
                                                        0]["iban"],
                                                accountType: accountDetails[
                                                            storageChosenAccount ??
                                                                0]["productCode"] ==
                                                        "1001"
                                                    ? "Current"
                                                    : "Savings",
                                              ).toMap(),
                                            );
                                            // if (canRequestAccountStatement) {
                                            //   Navigator.pushNamed(
                                            //     context,
                                            //     Routes.downloadStatement,
                                            //     arguments:
                                            //         DownloadStatementArgumentModel(
                                            //       accountNumber: accountDetails[
                                            //           storageChosenAccount ??
                                            //               0]["accountNumber"],
                                            //       ibanNumber: accountDetails[
                                            //           storageChosenAccount ??
                                            //               0]["iban"],
                                            //       accountType: accountDetails[
                                            //                       storageChosenAccount ??
                                            //                           0]
                                            //                   ["productCode"] ==
                                            //               "1001"
                                            //           ? "Current"
                                            //           : "Savings",
                                            //     ).toMap(),
                                            //   );
                                            // } else {
                                            //   showDialog(
                                            //     context: context,
                                            //     builder: (context) {
                                            //       return CustomDialog(
                                            //         svgAssetPath:
                                            //             ImageConstants.warning,
                                            //         title: "No Permission",
                                            //         message:
                                            //             "You do not have permission to request for Account Statement.",
                                            //         actionWidget:
                                            //             GradientButton(
                                            //           onTap: () {
                                            //             Navigator.pop(context);
                                            //           },
                                            //           text: labels[346]
                                            //               ["labelText"],
                                            //         ),
                                            //       );
                                            //     },
                                            //   );
                                            // }
                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                ImageConstants.download,
                                                width: (15 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                height: (15 /
                                                        Dimensions.designWidth)
                                                    .w,
                                              ),
                                              const SizeBox(width: 10),
                                              Text(
                                                labels[89]["labelText"],
                                                style:
                                                    TextStyles.primary.copyWith(
                                                  color: AppColors.dark50,
                                                  fontSize: (16 /
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
                                    const SizeBox(height: 15),
                                    Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              (10 / Dimensions.designWidth).w),
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
                                          InkWell(
                                            onTap: () {
                                              final ShowButtonBloc
                                                  showButtonBloc = context
                                                      .read<ShowButtonBloc>();
                                              isShowFilter = true;
                                              showButtonBloc.add(
                                                ShowButtonEvent(
                                                    show: isShowFilter),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  ImageConstants.filter,
                                                  width: (12 /
                                                          Dimensions
                                                              .designHeight)
                                                      .w,
                                                  height: (12 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                ),
                                                const SizeBox(width: 5),
                                                Text(
                                                  filterText,
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
                                          const SizeBox(width: 10),
                                          Text(
                                            "|",
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              color: AppColors.dark50,
                                              fontSize:
                                                  (16 / Dimensions.designWidth)
                                                      .w,
                                            ),
                                          ),
                                          const SizeBox(width: 10),
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
                                    Ternary(
                                      condition: displayStatementList.isEmpty,
                                      truthy: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizeBox(height: 70),
                                          Text(
                                            "No transactions",
                                            style:
                                                TextStyles.primaryBold.copyWith(
                                              color: AppColors.dark30,
                                              fontSize:
                                                  (24 / Dimensions.designWidth)
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
                                            return DashboardTransactionListTile(
                                              onTap: () {},
                                              isCredit:
                                                  // true,
                                                  displayStatementList[index]
                                                          ["isDebit"] ==
                                                      false,
                                              title:
                                                  // "Tax non filer debit Tax non filer debit",
                                                  displayStatementList[index]
                                                      ["transactionType"],
                                              name: "",
                                              amount:
                                                  // 50.23,
                                                  // (displayStatementList[index][
                                                  //                 "creditAmount"] !=
                                                  //             0
                                                  //         ? displayStatementList[
                                                  //                 index]
                                                  //             ["creditAmount"]
                                                  //         : displayStatementList[
                                                  //                 index]
                                                  //             ["debitAmount"])
                                                  //     .toDouble(),
                                                  displayStatementList[index]
                                                          ["amount"]
                                                      .toDouble(),
                                              currency:
                                                  // "AED",
                                                  displayStatementList[index]
                                                      ["amountCurrency"],
                                              date:
                                                  // "Tue, Apr 1 2022",
                                                  //     DateFormat('EEE, MMM dd yyyy')
                                                  //         .format(
                                                  //   DateTime.parse(
                                                  //     displayStatementList[index]
                                                  //         ["bookingDate"],
                                                  //   ),
                                                  // ),
                                                  DateFormat('EEE, MMM dd yyyy')
                                                      .format(
                                                DateTime.parse(
                                                  displayStatementList[index]
                                                      ["transactionTimeStamp"],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              falsy: Ternary(
                                condition: isShowFilter,
                                truthy: SizedBox(
                                  height:
                                      // _dsController.size,
                                      29.h,
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
                                                  "Filter",
                                                  style: TextStyles.primaryBold
                                                      .copyWith(
                                                          color:
                                                              AppColors.dark50,
                                                          fontSize: (20 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w),
                                                ),
                                              ],
                                            ),
                                            const SizeBox(height: 20),
                                            Text(
                                              "Transaction type",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                      color: AppColors.dark50,
                                                      fontSize: (16 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w),
                                            ),
                                            const SizeBox(height: 15),
                                            Row(
                                              children: [
                                                SolidButton(
                                                  width: (118 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: Colors.white,
                                                  fontColor: AppColors.primary,
                                                  boxShadow: [
                                                    BoxShadows.primary
                                                  ],
                                                  borderColor: isAllSelected
                                                      ? const Color.fromRGBO(
                                                          0, 184, 148, 0.21)
                                                      : Colors.transparent,
                                                  onTap: () {
                                                    final ShowButtonBloc
                                                        showButtonBloc =
                                                        context.read<
                                                            ShowButtonBloc>();
                                                    isAllSelected = true;
                                                    isSentSelected = false;
                                                    isReceivedSelected = false;
                                                    filterText = "All";
                                                    populateDisplayStatementList(
                                                      isAllSelected,
                                                      isSentSelected,
                                                      isReceivedSelected,
                                                    );
                                                    sortDisplayStatementList(
                                                      isDateNewest,
                                                      isDateOldest,
                                                      isAmountHighest,
                                                      isAmountLowest,
                                                    );
                                                    showButtonBloc.add(
                                                      ShowButtonEvent(
                                                        show: isAllSelected &&
                                                            isSentSelected &&
                                                            isReceivedSelected,
                                                      ),
                                                    );
                                                  },
                                                  text: "All",
                                                ),
                                                const SizeBox(width: 15),
                                                SolidButton(
                                                  width: (118 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: Colors.white,
                                                  fontColor: AppColors.primary,
                                                  boxShadow: [
                                                    BoxShadows.primary
                                                  ],
                                                  borderColor: isSentSelected
                                                      ? const Color.fromRGBO(
                                                          0, 184, 148, 0.21)
                                                      : Colors.transparent,
                                                  onTap: () {
                                                    final ShowButtonBloc
                                                        showButtonBloc =
                                                        context.read<
                                                            ShowButtonBloc>();
                                                    isAllSelected = false;
                                                    isSentSelected = true;
                                                    isReceivedSelected = false;
                                                    filterText = "Sent";
                                                    populateDisplayStatementList(
                                                      isAllSelected,
                                                      isSentSelected,
                                                      isReceivedSelected,
                                                    );
                                                    sortDisplayStatementList(
                                                      isDateNewest,
                                                      isDateOldest,
                                                      isAmountHighest,
                                                      isAmountLowest,
                                                    );
                                                    showButtonBloc.add(
                                                      ShowButtonEvent(
                                                        show: isAllSelected &&
                                                            isSentSelected &&
                                                            isReceivedSelected,
                                                      ),
                                                    );
                                                  },
                                                  text: "Sent",
                                                ),
                                                const SizeBox(width: 15),
                                                SolidButton(
                                                  width: (118 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: Colors.white,
                                                  fontColor: AppColors.primary,
                                                  boxShadow: [
                                                    BoxShadows.primary
                                                  ],
                                                  borderColor:
                                                      isReceivedSelected
                                                          ? const Color
                                                              .fromRGBO(
                                                              0, 184, 148, 0.21)
                                                          : Colors.transparent,
                                                  onTap: () {
                                                    final ShowButtonBloc
                                                        showButtonBloc =
                                                        context.read<
                                                            ShowButtonBloc>();
                                                    isAllSelected = false;
                                                    isSentSelected = false;
                                                    isReceivedSelected = true;
                                                    filterText = "Received";
                                                    populateDisplayStatementList(
                                                      isAllSelected,
                                                      isSentSelected,
                                                      isReceivedSelected,
                                                    );
                                                    sortDisplayStatementList(
                                                      isDateNewest,
                                                      isDateOldest,
                                                      isAmountHighest,
                                                      isAmountLowest,
                                                    );
                                                    showButtonBloc.add(
                                                      ShowButtonEvent(
                                                        show: isAllSelected &&
                                                            isSentSelected &&
                                                            isReceivedSelected,
                                                      ),
                                                    );
                                                  },
                                                  text: "Received",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      GradientButton(
                                        onTap: () {
                                          final ShowButtonBloc showButtonBloc =
                                              context.read<ShowButtonBloc>();
                                          isShowFilter = false;
                                          showButtonBloc.add(
                                            ShowButtonEvent(
                                              show: isShowFilter,
                                            ),
                                          );
                                        },
                                        text:
                                            "Show ${displayStatementList.length} transactions",
                                      ),
                                    ],
                                  ),
                                ),
                                falsy: SizedBox(
                                  height:
                                      // _dsController.size,
                                      85.h,
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
                                      // GradientButton(
                                      //   onTap: () {
                                      //     final ShowButtonBloc
                                      //         showButtonBloc = context
                                      //             .read<ShowButtonBloc>();
                                      //     isShowSort = false;
                                      //     showButtonBloc.add(
                                      //       ShowButtonEvent(
                                      //         show: isShowFilter,
                                      //       ),
                                      //     );
                                      //   },
                                      //   text:
                                      //       "Show ${displayStatementList.length} transactions",
                                      // ),
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

  void populateDisplayStatementList(bool isAll, bool isSent, bool isReceived) {
    displayStatementList.clear();
    if (isAll) {
      displayStatementList.addAll(accountDetailsArgument.displayStatementList);
    }
    if (isSent) {
      for (var statement in accountDetailsArgument.displayStatementList) {
        if (statement["isDebit"] == true) {
          displayStatementList.add(statement);
        }
      }
    }
    if (isReceived) {
      for (var statement in accountDetailsArgument.displayStatementList) {
        if (statement["isDebit"] == false) {
          displayStatementList.add(statement);
        }
      }
    }
  }

  void sortDisplayStatementList(
      bool isNewest, bool isOldest, bool isHighest, bool isLowest) {
    if (isNewest) {
      displayStatementList.sort((a, b) =>
          DateTime.parse(b["transactionTimeStamp"])
              .compareTo(DateTime.parse(a["transactionTimeStamp"])));
    }
    if (isOldest) {
      displayStatementList.sort((a, b) =>
          DateTime.parse(a["transactionTimeStamp"])
              .compareTo(DateTime.parse(b["transactionTimeStamp"])));
    }
    if (isHighest) {
      displayStatementList.sort((a, b) => (double.parse(b["amount"].toString())
          .compareTo(double.parse(a["amount"].toString()))));
    }
    if (isLowest) {
      displayStatementList.sort((a, b) => (double.parse(a["amount"].toString())
          .compareTo(double.parse(b["amount"].toString()))));
    }
  }

  @override
  void dispose() {
    _dsController.dispose();
    super.dispose();
  }
}
