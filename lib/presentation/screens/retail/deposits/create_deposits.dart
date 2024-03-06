// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/business/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class CreateDepositsScreen extends StatefulWidget {
  const CreateDepositsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<CreateDepositsScreen> createState() => _CreateDepositsScreenState();
}

class _CreateDepositsScreenState extends State<CreateDepositsScreen> {
  double _scrollOffset = 0;
  int _scrollIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _depositController =
      TextEditingController(text: "0.00");

  final double minAmtReq = 10000;
  final double maxAmtReq = 100000;
  double bal = 0;

  int initLength = 4;

  String currency = "";

  String errorMsg = "";

  bool isShowButton = false;
  bool showPeriod = false;

  bool isAutoRenewal = true;
  bool isAutoClosure = false;

  bool isStandingDirNo = true;
  bool isStandingDirYes = false;

  String? selectedPayout;

  int maturityDays = 7;

  List<String> dynamicPayoutDropdowns = [];

  String date = "";
  DateTime auxToDate = DateTime(
    DateTime.now().add(const Duration(days: 31)).year,
    DateTime.now().add(const Duration(days: 31)).month,
    DateTime.now().add(const Duration(days: 31)).day,
    0,
    0,
    0,
    0,
    0,
  );

  double interestRate = 0;

  String chosenAccountNumber = "";

  int chosenIndex = storageChosenAccountForCreateFD ?? 0;

  List<DetailsTileModel> rates = [];

  bool _keyboardVisible = false;

  Color borderColor = const Color(0XFFEEEEEE);

  late CreateDepositArgumentModel createDepositArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    _scrollController.addListener(() {
      _scrollOffset = _scrollController.offset + 120;
      _scrollIndex = _scrollOffset ~/ 188;
      final SummaryTileBloc summaryTileBloc = context.read<SummaryTileBloc>();
      summaryTileBloc.add(SummaryTileEvent(scrollIndex: _scrollIndex));
    });
  }

  void argumentInitialization() {
    createDepositArgument =
        CreateDepositArgumentModel.fromMap(widget.argument as dynamic ?? {});
    currency = accountDetails[0]["accountCurrency"];
    // createDepositArgument.isRetail
    //     ? accountDetails[0]["accountCurrency"]
    //     : fdSeedAccounts[0].currency;
    bal = double.parse(accountDetails[chosenIndex]["currentBalance"]
            .split(' ')
            .last
            .replaceAll(',', ''))
        .abs();
    // createDepositArgument.isRetail
    //     ? double.parse(accountDetails[chosenIndex]["currentBalance"]
    //             .split(' ')
    //             .last
    //             .replaceAll(',', ''))
    //         .abs()
    //     : fdSeedAccounts[0].bal;
    chosenAccountNumber =
        accountDetails[storageChosenAccountForCreateFD ?? 0]["accountNumber"];
    // createDepositArgument.isRetail
    //     ? accountDetails[storageChosenAccountForCreateFD ?? 0]["accountNumber"]
    //     : fdSeedAccounts[0].accountNumber;

    log("chosenIndex -> $chosenIndex");
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: () {
              populateFdRates();
              promptUserForRates();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
                vertical: (15 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(ImageConstants.rates),
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
                    "Create Deposits",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "Please fill out the following to create a deposit account.",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    // flex: _keyboardVisible ? 2 : 3,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Choose the Account you wish to fund your Fixed Deposit",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          // const MandatoryFieldLabel(
                          // labelText: "Select an Account"),
                          const SizeBox(height: 10),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              return Flexible(
                                child: SizedBox(
                                  height: (145 / Dimensions.designHeight).h,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                        top: (5 / Dimensions.designHeight).h,
                                        bottom:
                                            (12 / Dimensions.designHeight).h),
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: createDepositArgument.isRetail
                                        ? accountDetails.length
                                        : corporateAccountDetails.length,
                                    itemBuilder: (context, index) {
                                      return AccountSummaryTile(
                                        isShowCheckMark: true,
                                        isSelected: chosenIndex == index,
                                        accountNumber:
                                            createDepositArgument.isRetail
                                                ? accountDetails[index]
                                                    ["accountNumber"]
                                                : corporateAccountDetails[index]
                                                    ["accountNumber"],
                                        onTap: () async {
                                          final ShowButtonBloc showButtonBloc =
                                              context.read<ShowButtonBloc>();
                                          final ErrorMessageBloc
                                              errorMessageBloc =
                                              context.read<ErrorMessageBloc>();
                                          chosenIndex = index;
                                          chosenAccountNumber =
                                              createDepositArgument.isRetail
                                                  ? accountDetails[index]
                                                      ["accountNumber"]
                                                  : corporateAccountDetails[
                                                      index]["accountNumber"];
                                          await storage.write(
                                            key: "chosenAccountForCreateFD",
                                            value: index.toString(),
                                          );
                                          storageChosenAccountForCreateFD =
                                              int.parse(
                                            await storage.read(
                                                    key:
                                                        "chosenAccountForCreateFD") ??
                                                "0",
                                          );
                                          bal = createDepositArgument.isRetail
                                              ? double.parse(
                                                      accountDetails[index]
                                                              ["currentBalance"]
                                                          .split(' ')
                                                          .last
                                                          .replaceAll(',', ''))
                                                  .abs()
                                              : double.parse(
                                                      corporateAccountDetails[
                                                                  index]
                                                              ["currentBalance"]
                                                          .split(' ')
                                                          .last
                                                          .replaceAll(',', ''))
                                                  .abs();
                                          currency = createDepositArgument
                                                  .isRetail
                                              ? accountDetails[index]
                                                  ["accountCurrency"]
                                              : corporateAccountDetails[index]
                                                  ["currency"];
                                          showButtonBloc.add(ShowButtonEvent(
                                              show: chosenIndex == index));

                                          if (double.parse(_depositController
                                                      .text
                                                      .replaceAll(',', '')) <
                                                  minAmtReq ||
                                              double.parse(_depositController
                                                      .text
                                                      .replaceAll(',', '')) >
                                                  maxAmtReq) {
                                            errorMsg =
                                                "Please check the amount limit criteria";
                                            borderColor = AppColors.red100;
                                            errorMessageBloc.add(
                                              ErrorMessageEvent(
                                                  hasError: errorMsg.isEmpty),
                                            );
                                          } else if (double.parse(
                                                  _depositController.text
                                                      .replaceAll(',', '')) >
                                              bal) {
                                            errorMsg = "Insufficient fund";
                                            borderColor = AppColors.red100;
                                            errorMessageBloc.add(
                                              ErrorMessageEvent(
                                                  hasError: errorMsg.isEmpty),
                                            );
                                          } else {
                                            errorMsg = "";
                                            borderColor =
                                                const Color(0xFFEEEEEE);
                                            errorMessageBloc.add(
                                              ErrorMessageEvent(
                                                  hasError: errorMsg.isEmpty),
                                            );
                                          }
                                        },
                                        imgUrl: createDepositArgument.isRetail
                                            ? accountDetails[index]
                                                        ["accountCurrency"] ==
                                                    "AED"
                                                ? ImageConstants.uaeFlag
                                                : ImageConstants.usaFlag
                                            : corporateAccountDetails[index]
                                                        ["currency"] ==
                                                    "AED"
                                                ? ImageConstants.uaeFlag
                                                : ImageConstants.usaFlag,
                                        accountType:
                                            createDepositArgument.isRetail
                                                ? accountDetails[index]
                                                            ["productCode"] ==
                                                        "1001"
                                                    ? labels[7]["labelText"]
                                                    : labels[92]["labelText"]
                                                : corporateAccountDetails[index]
                                                            ["accountType"] ==
                                                        2
                                                    ? labels[7]["labelText"]
                                                    : labels[92]["labelText"],
                                        currency: createDepositArgument.isRetail
                                            ? accountDetails[index]
                                                    ["currentBalance"]
                                                .split(" ")
                                                .first
                                            : corporateAccountDetails[index]
                                                ["currency"],
                                        amount: createDepositArgument.isRetail
                                            ? double.parse(accountDetails[index]
                                                            ["currentBalance"]
                                                        .split(" ")
                                                        .last
                                                        .replaceAll(",", "")) >
                                                    1000000000
                                                ? "${(double.parse(accountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")) / 1000000000).toStringAsFixed(2)} B"
                                                : double.parse(accountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")) >
                                                        1000000
                                                    ? "${(double.parse(accountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")) / 1000000).toStringAsFixed(2)} M"
                                                    : accountDetails[index]
                                                            ["currentBalance"]
                                                        .split(" ")
                                                        .last
                                            : double.parse(corporateAccountDetails[index]
                                                            ["currentBalance"]
                                                        .split(" ")
                                                        .last
                                                        .replaceAll(",", "")) >
                                                    1000000000
                                                ? "${(double.parse(corporateAccountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")) / 1000000000).toStringAsFixed(2)} B"
                                                : double.parse(corporateAccountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")) >
                                                        1000000
                                                    ? "${(double.parse(corporateAccountDetails[index]["currentBalance"].split(" ").last.replaceAll(",", "")) / 1000000).toStringAsFixed(2)} M"
                                                    : corporateAccountDetails[index]
                                                            ["currentBalance"]
                                                        .split(" ")
                                                        .last,
                                        subText: "",
                                        subImgUrl: "",
                                        space: _keyboardVisible ? 17 : 21,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizeBox(height: 10),
                          BlocBuilder<SummaryTileBloc, SummaryTileState>(
                            builder: buildSummaryTile,
                          ),
                          const SizeBox(height: 20),
                          Container(
                            padding:
                                EdgeInsets.all((10 / Dimensions.designWidth).w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular((3 / Dimensions.designWidth).w),
                              ),
                              color: const Color(0xFFEEEEEE),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Amount Limit Criteria",
                                  style: TextStyles.primaryBold.copyWith(
                                    color: AppColors.primary,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizeBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Minimum amount required",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    Text(
                                      "USD ${NumberFormat('#,000.00').format(minAmtReq)}",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizeBox(height: 7),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Maximum amount required",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                    Text(
                                      "USD ${NumberFormat('#,000.00').format(maxAmtReq)}",
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizeBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "Deposit Amount (USD)",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          // const MandatoryFieldLabel(
                          //     labelText: "Deposit Amount (USD)"),
                          const SizeBox(height: 7),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              return CustomTextField(
                                borderColor: borderColor,
                                controller: _depositController,
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.digitsOnly
                                // ],
                                keyboardType: TextInputType.number,
                                hintText: "E.g., 20000",
                                onChanged: onDepositChanged,
                              );
                            },
                          ),
                          const SizeBox(height: 5),
                          BlocBuilder<ErrorMessageBloc, ErrorMessageState>(
                            builder: buildErrorMessage,
                          ),
                          const SizeBox(height: 10),
                          Row(
                            children: [
                              Text(
                                labels[110]["labelText"],
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          // MandatoryFieldLabel(
                          //     labelText: labels[110]["labelText"]),
                          const SizeBox(height: 10),
                          InkWell(
                            onTap: showDatePickerWidget,
                            child: BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: (context, state) {
                                return Container(
                                  height: (60 / Dimensions.designHeight).h,
                                  padding: EdgeInsets.all(
                                      (15 / Dimensions.designWidth).w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              (10 / Dimensions.designWidth).w)),
                                      boxShadow: const [],
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0XFFEEEEEE))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        date.isNotEmpty ? date : "Select Date",
                                        style:
                                            TextStyles.primaryMedium.copyWith(
                                          color: date.isNotEmpty
                                              ? AppColors.dark80
                                              : AppColors.dark50,
                                          fontSize:
                                              (16 / Dimensions.designWidth).w,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        ImageConstants.date,
                                        width: (10 / Dimensions.designWidth).w,
                                        height: (16 / Dimensions.designWidth).w,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: buildDepositColumn,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: buildSubmitButton,
            ),
          ],
        ),
      ),
    );
  }

  void populateFdRates() {
    rates.clear();
    for (var fdRate in fdRates) {
      rates.add(
          DetailsTileModel(key: fdRate["label"], value: "${fdRate["rate"]}%"));
    }
  }

  void promptUserForRates() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
                vertical: PaddingConstants.bottomPadding +
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                  color: Colors.white,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: 52.5.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizeBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: (PaddingConstants.horizontalPadding /
                                    Dimensions.designWidth)
                                .w,
                          ),
                          // vertical: (22 / Dimensions.designHeight).h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Duration",
                                style: TextStyles.primaryBold.copyWith(
                                  color: AppColors.primary,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "USD Rates",
                                style: TextStyles.primaryBold.copyWith(
                                  color: AppColors.primary,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                        const SizeBox(height: 20),
                        Expanded(
                          child:
                              DetailsTile(length: rates.length, details: rates),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSummaryTile(BuildContext context, SummaryTileState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 47.w -
              (22 / Dimensions.designWidth).w -
              ((createDepositArgument.isRetail
                      ? accountDetails.length
                      : fdSeedAccounts.length - 1) *
                  (6.5 / Dimensions.designWidth).w)),
      child: SizedBox(
        width: 90.w,
        height: (9 / Dimensions.designWidth).w,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: createDepositArgument.isRetail
              ? accountDetails.length
              : fdSeedAccounts.length,
          itemBuilder: (context, index) {
            return ScrollIndicator(
              isCurrent: (index == _scrollIndex),
            );
          },
        ),
      ),
    );
  }

  Widget buildErrorMessage(BuildContext context, ErrorMessageState state) {
    if (errorMsg.isNotEmpty) {
      return Text(
        errorMsg,
        style: TextStyles.primaryMedium.copyWith(
          color: AppColors.red100,
          fontSize: (16 / Dimensions.designWidth).w,
        ),
      );
    } else {
      return const SizeBox();
    }
  }

  void showDatePickerWidget() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height:
                (((Platform.isIOS ? 310 : 370)) / Dimensions.designHeight).h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular((20 / Dimensions.designWidth).w),
                topRight: Radius.circular((20 / Dimensions.designWidth).w),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizeBox(height: 20),
                Text(
                  DateFormat('EEE, d MMM, yyyy').format(auxToDate),
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.black25,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                SizedBox(
                  height:
                      ((Platform.isIOS ? 170 : 230) / Dimensions.designHeight)
                          .h,
                  child: Ternary(
                    condition: Platform.isIOS,
                    truthy: CupertinoDatePicker(
                      initialDateTime:
                          auxToDate.add(const Duration(seconds: 1)),
                      minimumDate: DateTime(
                        DateTime.now().add(const Duration(days: 31)).year,
                        DateTime.now().add(const Duration(days: 31)).month,
                        DateTime.now().add(const Duration(days: 31)).day,
                        0,
                        0,
                        0,
                        0,
                        0,
                      ),
                      maximumDate:
                          DateTime.now().add(const Duration(days: 30 * 60)),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (p0) {
                        date = DateFormat('d MMMM, yyyy').format(p0);
                        auxToDate = p0;
                      },
                    ),
                    falsy: DatePickerWidget(
                      looping: false,
                      initialDate: auxToDate.add(const Duration(seconds: 1)),
                      firstDate: DateTime(
                        DateTime.now().add(const Duration(days: 31)).year,
                        DateTime.now().add(const Duration(days: 31)).month,
                        DateTime.now().add(const Duration(days: 31)).day,
                        0,
                        0,
                        0,
                        0,
                        0,
                      ),
                      lastDate:
                          DateTime.now().add(const Duration(days: 30 * 60)),
                      dateFormat: "dd-MMMM-yyyy",
                      onChange: (p0, _) {
                        date = DateFormat('d MMMM, yyyy').format(p0);
                        auxToDate = p0;
                      },
                    ),
                  ),
                ),
                const SizeBox(height: 20),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: (50.w) - 1,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "CANCEL",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black12,
                    ),
                    InkWell(
                      onTap: onDateOK,
                      child: Container(
                        width: (50.w) - 1,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "OK",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.primary,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void onDateOK() {
    final DateSelectionBloc dateSelectionBloc =
        context.read<DateSelectionBloc>();
    final ShowButtonBloc showPeriodSection = context.read<ShowButtonBloc>();
    for (int i = 0; i < fdRatesDates.length; i++) {
      log("Days difference -> ${fdRatesDates[i].difference(auxToDate).inDays}");
      log("Hours difference -> ${auxToDate.difference(DateTime.now()).inHours}");
      log("maturity days -> ${auxToDate.difference(DateTime.now()).inHours <= 0 ? auxToDate.difference(DateTime.now()).inDays : auxToDate.difference(DateTime.now()).inDays + 1}");
      if (fdRatesDates[i].difference(auxToDate).inDays >= 0) {
        interestRate = (fdRates[i]["rate"]).toDouble();
        break;
      }
    }
    maturityDays = auxToDate.difference(DateTime.now()).inHours <= 0
        ? auxToDate.difference(DateTime.now()).inDays
        : auxToDate.difference(DateTime.now()).inDays + 1;
    date = DateFormat('d MMMM, yyyy').format(auxToDate);
    dateSelectionBloc.add(const DateSelectionEvent(isDateSelected: true));

    final DropdownSelectedBloc dropdownSelectedBloc =
        context.read<DropdownSelectedBloc>();
    getPayoutDropdown(maturityDays);
    selectedPayout = dynamicPayoutDropdowns[0];
    isShowButton = true;
    dropdownSelectedBloc.add(
      DropdownSelectedEvent(isDropdownSelected: true, toggles: 1),
    );

    showPeriod = true;
    showPeriodSection.add(
      ShowButtonEvent(
          show: showPeriod &&
              errorMsg.isEmpty &&
              _depositController.text.isNotEmpty),
    );
    Navigator.pop(context);
  }

  Widget buildDepositColumn(BuildContext context, ShowButtonState state) {
    if (showPeriod && errorMsg.isEmpty && _depositController.text.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          Container(
            width: 100.w,
            padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
                vertical: (8 / Dimensions.designWidth).w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w)),
              color: AppColors.blackEE,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primaryDark,
                      size: (20 / Dimensions.designWidth).w,
                    ),
                    const SizeBox(width: 10),
                    Text(
                      labels[104]["labelText"],
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: (18 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                Text(
                  "$interestRate%",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
          ),
          const SizeBox(height: 20),
          Row(
            children: [
              Text(
                labels[112]["labelText"],
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark80,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),

          // MandatoryFieldLabel(labelText: labels[112]["labelText"]),
          BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizeBox(height: 7),
                  BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    builder: buildInterestDropdown,
                  ),
                ],
              );
            },
          ),

          const SizeBox(height: 20),
          Row(
            children: [
              Text(
                labels[113]["labelText"],
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark80,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          // MandatoryFieldLabel(labelText: labels[113]["labelText"]),
          const SizeBox(height: 10),
          Row(
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: buildAutoRollover,
              ),
              const SizeBox(width: 5),
              Text(
                labels[114]["labelText"],
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark50,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(width: 30),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: buildAutoClosure,
              ),
              const SizeBox(width: 5),
              Text(
                labels[115]["labelText"],
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark50,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildInterestDropdown(
      BuildContext context, DropdownSelectedState state) {
    return CustomDropDown(
      title: "Select from the list",
      items: getPayoutDropdown(maturityDays),
      // payoutDurationDDs,
      value: selectedPayout,
      onChanged: onDropdownChanged,
    );
  }

  List<String> getPayoutDropdown(int days) {
    dynamicPayoutDropdowns = [];
    if (days < 30) {
      dynamicPayoutDropdowns = [payoutDurationDDs[0]];
    } else if (days >= 30 && days < 90) {
      dynamicPayoutDropdowns = [payoutDurationDDs[0], payoutDurationDDs[1]];
    } else if (days >= 90 && days < 180) {
      dynamicPayoutDropdowns = [
        payoutDurationDDs[0],
        payoutDurationDDs[1],
        payoutDurationDDs[2]
      ];
    } else if (days >= 180 && days < 365) {
      dynamicPayoutDropdowns = [
        payoutDurationDDs[0],
        payoutDurationDDs[1],
        payoutDurationDDs[2],
        payoutDurationDDs[3]
      ];
    } else {
      dynamicPayoutDropdowns = payoutDurationDDs;
    }
    log("result -> $dynamicPayoutDropdowns");
    return dynamicPayoutDropdowns;
  }

  void onDropdownChanged(Object? value) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    final DropdownSelectedBloc dropdownSelectedBloc =
        context.read<DropdownSelectedBloc>();
    selectedPayout = value as String;
    isShowButton = true;
    dropdownSelectedBloc.add(
      DropdownSelectedEvent(isDropdownSelected: true, toggles: 1),
    );
    showButtonBloc.add(
      ShowButtonEvent(
        show: isShowButton &&
            errorMsg.isEmpty &&
            _depositController.text.isNotEmpty,
      ),
    );
  }

  Widget buildAutoRollover(BuildContext context, ButtonFocussedState state) {
    final ButtonFocussedBloc maturityBloc = context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return InkWell(
      onTap: () {
        isAutoRenewal = true;
        isAutoClosure = false;
        maturityBloc.add(
          ButtonFocussedEvent(isFocussed: isAutoRenewal, toggles: 1),
        );
        showButtonBloc.add(ShowButtonEvent(show: isAutoRenewal));
      },
      child: Container(
        width: (18 / Dimensions.designWidth).w,
        height: (18 / Dimensions.designWidth).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: const Color(0XFFDDDDDD)),
        ),
        child: Ternary(
          condition: isAutoRenewal,
          truthy: Center(
            child: SvgPicture.asset(
              ImageConstants.dot,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              colorFilter: const ColorFilter.mode(
                Color(0XFF00B894),
                BlendMode.srcIn,
              ),
            ),
          ),
          falsy: const SizeBox(),
        ),
      ),
    );
  }

  Widget buildAutoClosure(BuildContext context, ButtonFocussedState state) {
    final ButtonFocussedBloc maturityBloc = context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return InkWell(
      onTap: () {
        isAutoRenewal = false;
        isAutoClosure = true;
        maturityBloc.add(
          ButtonFocussedEvent(isFocussed: isAutoRenewal, toggles: 1),
        );
        showButtonBloc.add(ShowButtonEvent(show: isAutoClosure));
      },
      child: Container(
        width: (18 / Dimensions.designWidth).w,
        height: (18 / Dimensions.designWidth).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: const Color(0XFFDDDDDD)),
        ),
        child: Ternary(
          condition: isAutoClosure,
          truthy: Center(
            child: SvgPicture.asset(
              ImageConstants.dot,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              colorFilter: const ColorFilter.mode(
                Color(0XFF00B894),
                BlendMode.srcIn,
              ),
            ),
          ),
          falsy: const SizeBox(),
        ),
      ),
    );
  }

  Widget buildStandingInstructionNo(
      BuildContext context, ButtonFocussedState state) {
    final ButtonFocussedBloc maturityBloc = context.read<ButtonFocussedBloc>();
    return InkWell(
      onTap: () {
        isStandingDirNo = true;
        isStandingDirYes = false;
        maturityBloc.add(
          ButtonFocussedEvent(isFocussed: isAutoRenewal, toggles: 1),
        );
      },
      child: Container(
        width: (18 / Dimensions.designWidth).w,
        height: (18 / Dimensions.designWidth).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: const Color(0XFFDDDDDD)),
        ),
        child: Ternary(
          condition: isStandingDirNo,
          truthy: Center(
            child: SvgPicture.asset(
              ImageConstants.dot,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              colorFilter: const ColorFilter.mode(
                Color(0XFF00B894),
                BlendMode.srcIn,
              ),
            ),
          ),
          falsy: const SizeBox(),
        ),
      ),
    );
  }

  Widget buildStandingInstructionYes(
      BuildContext context, ButtonFocussedState state) {
    final ButtonFocussedBloc maturityBloc = context.read<ButtonFocussedBloc>();
    return InkWell(
      onTap: () {
        isStandingDirNo = false;
        isStandingDirYes = true;
        maturityBloc.add(
          ButtonFocussedEvent(isFocussed: isAutoRenewal, toggles: 1),
        );
      },
      child: Container(
        width: (18 / Dimensions.designWidth).w,
        height: (18 / Dimensions.designWidth).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: const Color(0XFFDDDDDD)),
        ),
        child: Ternary(
          condition: isStandingDirYes,
          truthy: Center(
            child: SvgPicture.asset(
              ImageConstants.dot,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              colorFilter: const ColorFilter.mode(
                Color(0XFF00B894),
                BlendMode.srcIn,
              ),
            ),
          ),
          falsy: const SizeBox(),
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isShowButton &&
        errorMsg.isEmpty &&
        _depositController.text.isNotEmpty) {
      return Column(
        children: [
          const SizeBox(height: 20),
          GradientButton(
            onTap: () {
              log("maturity days -> ${auxToDate.difference(DateTime.now()).inHours <= 0 ? auxToDate.difference(DateTime.now()).inDays : auxToDate.difference(DateTime.now()).inDays + 1}");
              log("payout -> $selectedPayout");
              log("payout validity -> ${validateMaturity(auxToDate.difference(DateTime.now()).inDays, selectedPayout ?? "")}");
              if (validateMaturity(auxToDate.difference(DateTime.now()).inDays,
                  selectedPayout ?? "")) {
                if (isAutoRenewal) {
                  Navigator.pushNamed(
                    context,
                    Routes.depositConfirmation,
                    arguments: DepositConfirmationArgumentModel(
                      isRetail: createDepositArgument.isRetail,
                      currency: currency,
                      accountNumber: chosenAccountNumber,
                      depositAmount: double.parse(
                          _depositController.text.replaceAll(',', '')),
                      tenureDays:
                          auxToDate.difference(DateTime.now()).inHours <= 0
                              ? auxToDate.difference(DateTime.now()).inDays
                              : auxToDate.difference(DateTime.now()).inDays + 1,
                      // auxToDate.day - DateTime.now().day,
                      interestRate: interestRate,
                      interestAmount: double.parse(
                              _depositController.text.replaceAll(',', '')) *
                          (interestRate / 100),
                      interestPayout: selectedPayout ?? "",
                      isAutoRenewal: isAutoRenewal,
                      isAutoTransfer: false,
                      creditAccountNumber: chosenAccountNumber,
                      dateOfMaturity: auxToDate,
                      depositBeneficiary: DepositBeneficiaryModel(
                        accountNumber: "",
                        name: "",
                        address: "",
                        accountType: 0,
                        swiftReference: 0,
                        reasonForSending: "",
                        saveBeneficiary: false,
                      ),
                    ).toMap(),
                  );
                } else {
                  if (isStandingDirNo) {
                    Navigator.pushNamed(
                      context,
                      Routes.depositConfirmation,
                      arguments: DepositConfirmationArgumentModel(
                        isRetail: createDepositArgument.isRetail,
                        currency: currency,
                        accountNumber: chosenAccountNumber,
                        depositAmount: double.parse(
                            _depositController.text.replaceAll(',', '')),
                        tenureDays:
                            auxToDate.difference(DateTime.now()).inHours <= 0
                                ? auxToDate.difference(DateTime.now()).inDays
                                : auxToDate.difference(DateTime.now()).inDays +
                                    1,
                        interestRate: interestRate,
                        interestAmount: double.parse(
                                _depositController.text.replaceAll(',', '')) *
                            ((interestRate / 100)),
                        interestPayout: selectedPayout ?? "",
                        isAutoRenewal: isAutoRenewal,
                        isAutoTransfer: false,
                        creditAccountNumber: chosenAccountNumber,
                        dateOfMaturity: auxToDate,
                        depositBeneficiary: DepositBeneficiaryModel(
                          accountNumber: "",
                          name: "",
                          address: "",
                          accountType: 0,
                          swiftReference: 0,
                          reasonForSending: "",
                          saveBeneficiary: false,
                        ),
                      ).toMap(),
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      Routes.depositBeneficiary,
                      arguments: DepositConfirmationArgumentModel(
                        isRetail: createDepositArgument.isRetail,
                        currency: currency,
                        accountNumber: chosenAccountNumber,
                        depositAmount: double.parse(
                            _depositController.text.replaceAll(',', '')),
                        tenureDays:
                            auxToDate.difference(DateTime.now()).inHours <= 0
                                ? auxToDate.difference(DateTime.now()).inDays
                                : auxToDate.difference(DateTime.now()).inDays +
                                    1,
                        interestRate: interestRate,
                        interestAmount: double.parse(
                                _depositController.text.replaceAll(',', '')) *
                            ((interestRate / 100)),
                        interestPayout: selectedPayout ?? "",
                        isAutoRenewal: isAutoRenewal,
                        isAutoTransfer: true,
                        creditAccountNumber: chosenAccountNumber,
                        dateOfMaturity: auxToDate,
                        depositBeneficiary: DepositBeneficiaryModel(
                          accountNumber: "",
                          name: "",
                          address: "",
                          accountType: 0,
                          swiftReference: 0,
                          reasonForSending: "",
                          saveBeneficiary: false,
                        ),
                      ).toMap(),
                    );
                  }
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      svgAssetPath: ImageConstants.warning,
                      title: "Incorrect Interest Payout",
                      message:
                          "Interest payout cannot be longer than the maturity date, please select the payout accordingly.",
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
            text: labels[31]["labelText"],
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.of(context).padding.bottom,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizeBox(height: 20),
          SolidButton(
            onTap: () {},
            text: labels[31]["labelText"],
          ),
          SizeBox(
            height: PaddingConstants.bottomPadding +
                MediaQuery.of(context).padding.bottom,
          ),
        ],
      );
    }
  }

  void onDepositChanged(String p0) {
    final ErrorMessageBloc errorMessageBloc = context.read<ErrorMessageBloc>();
    final ShowButtonBloc showPeriodSection = context.read<ShowButtonBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    if (_depositController.text.length < initLength) {
      _depositController.text =
          (double.parse(_depositController.text.replaceAll(',', '')) / 10)
              .toStringAsFixed(2);
      if (double.parse(_depositController.text.replaceAll(',', '')) >= 1000) {
        _depositController.text = NumberFormat('#,000.00')
            .format(double.parse(_depositController.text.replaceAll(',', '')));
      }

      _depositController.selection = TextSelection.fromPosition(
          TextPosition(offset: _depositController.text.length));
    } else {
      _depositController.text =
          (double.parse(_depositController.text.replaceAll(',', '')) * 10)
              .toStringAsFixed(2);
      if (double.parse(_depositController.text.replaceAll(',', '')) >= 1000) {
        _depositController.text = NumberFormat('#,000.00')
            .format(double.parse(_depositController.text.replaceAll(',', '')));
      }
      _depositController.selection = TextSelection.fromPosition(
          TextPosition(offset: _depositController.text.length));
    }

    initLength = _depositController.text.length;

    if (double.parse(_depositController.text.replaceAll(',', '')) < minAmtReq ||
        double.parse(_depositController.text.replaceAll(',', '')) > maxAmtReq) {
      errorMsg = "Please check the amount limit criteria";
      borderColor = AppColors.red100;
      errorMessageBloc.add(
        ErrorMessageEvent(hasError: errorMsg.isEmpty),
      );
    } else if (double.parse(_depositController.text.replaceAll(',', '')) >
        bal) {
      errorMsg = "Insufficient fund";
      borderColor = AppColors.red100;
      errorMessageBloc.add(
        ErrorMessageEvent(hasError: errorMsg.isEmpty),
      );
    } else {
      errorMsg = "";
      borderColor = const Color(0xFFEEEEEE);
      errorMessageBloc.add(
        ErrorMessageEvent(hasError: errorMsg.isEmpty),
      );
    }
    showPeriodSection.add(
      ShowButtonEvent(
        show: showPeriod &&
            errorMsg.isEmpty &&
            _depositController.text.isNotEmpty,
      ),
    );
    showButtonBloc.add(
      ShowButtonEvent(
        show: isShowButton &&
            errorMsg.isEmpty &&
            _depositController.text.isNotEmpty,
      ),
    );
  }

  bool validateMaturity(int days, String payout) {
    bool result = true;

    if (days < 30 && (payout != payoutDurationDDs[0])) {
      result = false;
    } else if (days < 90 &&
        (payout != payoutDurationDDs[0] && payout != payoutDurationDDs[1])) {
      result = false;
    } else if (days < 180 &&
        (payout != payoutDurationDDs[0] && payout != payoutDurationDDs[1]) &&
        payout != payoutDurationDDs[2]) {
      result = false;
    } else if (days < 365 && payout == payoutDurationDDs[4]) {
      result = false;
    } else {
      result = true;
    }

    return result;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _depositController.dispose();
    super.dispose();
  }
}

class MandatoryFieldLabel extends StatelessWidget {
  const MandatoryFieldLabel({
    Key? key,
    required this.labelText,
  }) : super(key: key);

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80, fontSize: (12 / Dimensions.designWidth).w),
        children: <TextSpan>[
          TextSpan(
            text: ' * ',
            style: TextStyles.primary.copyWith(
              color: AppColors.red100,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ],
      ),
    );
  }
}
