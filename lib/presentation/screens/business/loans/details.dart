// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/loan/summary_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  List<DetailsTileModel> loanDetails = [];

  bool isFetchingLoanDetails = false;
  bool isFetchingLoanSchedule = false;

  Map<String, dynamic> getLoanDetailsApiResult = {};

  double totalPaidAmt = 0;

  late LoanDetailsArgumentModel loanDetailsArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getLoanDetails();
  }

  void argumentInitialization() {
    loanDetailsArgument =
        LoanDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getLoanDetails() async {
    try {
      final ShowButtonBloc showButtonBloc = context.read();

      isFetchingLoanDetails = true;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingLoanDetails));

      log("getLoanDetailsApi Request -> ${{
        "accountNumber": loanDetailsArgument.accountNumber,
      }}");
      getLoanDetailsApiResult = await MapLoanDetails.mapLoanDetails(
        {
          "accountNumber": loanDetailsArgument.accountNumber,
        },
        token ?? "",
      );
      log("getLoanDetailsApiResult -> $getLoanDetailsApiResult");
      totalPaidAmt = getLoanDetailsApiResult["totalPaidAmt"];

      if (getLoanDetailsApiResult["success"]) {
        loanDetails.clear();
        loanDetails.add(DetailsTileModel(
            key: "Loan Account Number",
            value: loanDetailsArgument.accountNumber));
        loanDetails.add(DetailsTileModel(
            key: "Interest Rate",
            value: "${getLoanDetailsApiResult["interestRate"].toString()}%"));
        loanDetails.add(DetailsTileModel(
            key: "Interest Rate Type",
            value: "${getLoanDetailsApiResult["interestRateType"]}"));
        loanDetails.add(DetailsTileModel(
            key: "Instalment Amount",
            value:
                "${loanDetailsArgument.currency} ${double.parse(getLoanDetailsApiResult["installmentAmount"] ?? "0") >= 1000 ? NumberFormat('#,000.00').format(double.parse(getLoanDetailsApiResult["installmentAmount"] ?? "0")) : double.parse(getLoanDetailsApiResult["installmentAmount"] ?? "0").toStringAsFixed(2)}"));
        loanDetails.add(DetailsTileModel(
            key: "Overdue Amount",
            value:
                "${loanDetailsArgument.currency} ${double.parse(getLoanDetailsApiResult["overdueAmount"].replaceAll(',', '') ?? "0") >= 1000 ? NumberFormat('#,000.00').format(double.parse(getLoanDetailsApiResult["overdueAmount"].replaceAll(',', '') ?? "0")) : double.parse(getLoanDetailsApiResult["overdueAmount"].replaceAll(',', '') ?? "0").toStringAsFixed(2)}"));
        loanDetails.add(DetailsTileModel(
            key: "Balance Tenure",
            value: "${getLoanDetailsApiResult["balanceTenor"]} months"));
        loanDetails.add(DetailsTileModel(
            key: labels[313]["labelText"],
            value: DateFormat('dd MMM yyyy').format(DateTime.parse(
                getLoanDetailsApiResult["nextEMIDate"] ?? "1970-01-01"))));
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry!",
                message: getLoanDetailsApiResult["message"] ??
                    "Error while getting loan details, please try again later",
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

      isFetchingLoanDetails = false;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingLoanDetails));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          AppBarStatement(
            onTapLoan: () {
              log("OnTapLoan clicked");
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                Routes.loanStatement,
                arguments: DownloadStatementArgumentModel(
                        accountNumber: loanDetailsArgument.accountNumber,
                        accountType: "0",
                        ibanNumber: "")
                    .toMap(),
              );
            },
            onTapAmortization: () async {
              Navigator.pop(context);
              String? base64String;
              if (!isFetchingLoanSchedule) {
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                isFetchingLoanSchedule = true;
                showButtonBloc
                    .add(ShowButtonEvent(show: isFetchingLoanSchedule));
                setState(() {});

                log("Loan Schedule API Request -> ${{
                  "accountNumber": loanDetailsArgument.accountNumber,
                }}");
                var result = await MapLoanSchedule.mapLoanSchedule(
                  {
                    "accountNumber": loanDetailsArgument.accountNumber,
                  },
                  token ?? "",
                );
                log("Loan Schedule API Response -> $result");
                if (result["success"]) {
                  base64String = result["base64Data"];
                  openFile(base64String, 'PDF (.pdf)');
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Sorry!",
                          message: result["message"] ??
                              "There was an error fetching your loan schedule, please try again later.",
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

                isFetchingLoanSchedule = false;
                showButtonBloc
                    .add(ShowButtonEvent(show: isFetchingLoanSchedule));
                setState(() {});
              }
            },
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
                  labels[304]["labelText"],
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return Ternary(
                      condition: isFetchingLoanDetails,
                      truthy: const ShimmerLoanDetails(),
                      falsy: LoanSummaryTile(
                        currency: loanDetailsArgument.currency,
                        disbursedAmount: double.parse(
                            getLoanDetailsApiResult["disbursedAmount"] ?? "0"),
                        repaidAmount: totalPaidAmt * 1.00,
                        outstandingAmount: double.parse(
                            getLoanDetailsApiResult["outstandingAmount"] ??
                                "0"),
                      ),
                    );
                  },
                ),
                const SizeBox(height: 30),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return Ternary(
                      condition: isFetchingLoanDetails,
                      truthy: const ShimmerDepositDetails(),
                      falsy: Expanded(
                        child: DetailsTile(
                          length: loanDetails.length,
                          details: loanDetails,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Ternary(
            condition: isFetchingLoanSchedule,
            truthy: Center(
              child: SpinKitFadingCircle(
                color: AppColors.primary,
                size: (50 / Dimensions.designWidth).w,
              ),
            ),
            falsy: const SizeBox(),
          )
        ],
      ),
    );
  }

  void openFile(String? base64String, String? format) async {
    Uint8List bytes = base64.decode(base64String ?? "");
    File file;
    log("format -> ${format?.split(' ').last.substring(1, format.split(' ').last.length - 1)}");
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //! FOR Android
        : await getApplicationDocumentsDirectory(); //! FOR iOS

    file = File(
        "${directory?.path}/Dhabi_${loanDetailsArgument.accountNumber}${format?.split(' ').last.substring(1, format.split(' ').last.length - 1)}");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFile.open(
        "${directory?.path}/Dhabi_${loanDetailsArgument.accountNumber}${format?.split(' ').last.substring(1, format.split(' ').last.length - 1)}");
  }
}
