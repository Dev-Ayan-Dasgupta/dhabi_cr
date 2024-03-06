// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dialup_mobile_app/utils/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/arguments/transfer_details.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:intl/intl.dart';

class TransferDetailsScreen extends StatefulWidget {
  const TransferDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransferDetailsScreen> createState() => _TransferDetailsScreenState();
}

class _TransferDetailsScreenState extends State<TransferDetailsScreen> {
  List<DetailsTileModel> transferDetails = [];

  late TransferDetailsArgumentModel transferDetailsArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateTransferDetails();
  }

  Future<void> argumentInitialization() async {
    transferDetailsArgument =
        TransferDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void populateTransferDetails() {
    transferDetails.add(
        DetailsTileModel(key: "Status", value: transferDetailsArgument.status));
    transferDetails.add(DetailsTileModel(
        key: "Reference Number",
        value: transferDetailsArgument.referenceNumber));
    transferDetails.add(DetailsTileModel(
        key: "Bank/Wallet Name",
        value: transferDetailsArgument.transactionType != "Foreign"
            ? "DHABI"
            : transferDetailsArgument.benBankName));
    transferDetails.add(DetailsTileModel(
        key: "Recipient Name", value: transferDetailsArgument.beneficiaryName));
    transferDetails.add(DetailsTileModel(
        key: "Recipient IBAN/Account",
        value: transferDetailsArgument.beneficiaryAccountNo));
    transferDetails.add(DetailsTileModel(
        key: "Recipient Country",
        value: transferDetailsArgument.transactionType != "Foreign"
            ? "UNITED ARAB EMIRATES"
            : LongToShortCode.shortToName(transferDetailsArgument.benCountry)));
    transferDetails.add(DetailsTileModel(
        key: "You Send",
        value:
            "USD ${double.parse(transferDetailsArgument.transferAmount.split(' ').first) >= 1000 ? NumberFormat('#,000.00').format(double.parse(transferDetailsArgument.transferAmount.split(' ').first)) : double.parse(transferDetailsArgument.transferAmount.split(' ').first).toStringAsFixed(2)}"));
    transferDetails.add(DetailsTileModel(
        key: "They Receive",
        value:
            "${transferDetailsArgument.creditAmount.split(' ').last} ${double.parse(transferDetailsArgument.creditAmount.split(' ').first) >= 1000 ? NumberFormat('#,000.00').format(double.parse(transferDetailsArgument.creditAmount.split(' ').first)) : double.parse(transferDetailsArgument.creditAmount.split(' ').first).toStringAsFixed(2)}"));
    transferDetails.add(DetailsTileModel(
        key: "Exchange Rate",
        value:
            "1 USD = ${double.parse(transferDetailsArgument.exchangeRate).toStringAsFixed(4)} ${transferDetailsArgument.creditAmount.split(' ').last}"));
    transferDetails.add(DetailsTileModel(
        key: "Fees", value: "USD ${transferDetailsArgument.fee}"));
    if (transferDetailsArgument.transactionType == "Foreign") {
      transferDetails.add(DetailsTileModel(
          key: "Reason for sending",
          value: transferDetailsArgument.reasonForSending));
    }
    transferDetails.add(DetailsTileModel(
        key: "Transfer Date",
        value: DateFormat('dd MMMM yyyy')
            .format(DateTime.parse(transferDetailsArgument.transferDate))));
  }

  // late TransferDetailsArgumentModel transferDetailsArgument;

  // @override
  // void initState() {
  //   super.initState();
  //   argumentInitialization();
  //   populateDetails();
  // }

  // void argumentInitialization() {
  //   transferDetailsArgument =
  //       TransferDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  // }

  // void populateDetails() {
  //   transferDetails.add(
  //       DetailsTileModel(key: "Status", value: transferDetailsArgument.status));
  //   transferDetails.add(DetailsTileModel(
  //       key: "Recipient", value: transferDetailsArgument.beneficiaryName));
  //   transferDetails.add(DetailsTileModel(
  //       key: "Delivery", value: transferDetailsArgument.accountNumber));
  //   transferDetails.add(DetailsTileModel(
  //       key: "You Send", value: "USD ${transferDetailsArgument.amountSent}"));
  //   transferDetails.add(DetailsTileModel(
  //       key: "They Receive", value: transferDetailsArgument.amountReceived));
  //   transferDetails.add(DetailsTileModel(
  //       key: "Exchange Rate", value: transferDetailsArgument.exchangeRate));
  //   transferDetails.add(
  //       DetailsTileModel(key: "Fees", value: transferDetailsArgument.fees));
  //   transferDetails.add(
  //     DetailsTileModel(
  //       key: "Transfer Date",
  //       value: DateFormat('dd MMM yyyy')
  //           .format(DateTime.parse(transferDetailsArgument.transferDate)),
  //     ),
  //   );
  // }

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
                  const SizeBox(height: 10),
                  Text(
                    "Transfer Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  Expanded(
                    child: DetailsTile(
                      length: transferDetails.length,
                      details: transferDetails,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Ternary(
                  condition: 1 == 1,
                  truthy: GradientButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: labels[346]["labelText"],
                  ),
                  falsy: const SizeBox(),
                ),
                SizeBox(
                    height: PaddingConstants.bottomPadding +
                        MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
