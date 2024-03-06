// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dialup_mobile_app/bloc/index.dart';
import 'package:dialup_mobile_app/data/repositories/accounts/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/shimmers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DepositDetailsScreen extends StatefulWidget {
  const DepositDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<DepositDetailsScreen> createState() => _DepositDetailsScreenState();
}

class _DepositDetailsScreenState extends State<DepositDetailsScreen> {
  List<DetailsTileModel> depositDetails = [];

  bool isFetchingData = true;
  bool isFetchingCertificate = false;

  Map<String, dynamic> getFDDetailsResult = {};

  late DepositDetailsArgumentModel depositDetailsArgumentModel;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getDepositDetails();
  }

  void argumentInitialization() {
    depositDetailsArgumentModel =
        DepositDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getDepositDetails() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    try {
      log("Get Fd Details Request -> ${{
        "accountNumber": depositDetailsArgumentModel.accountNumber,
      }}");
      getFDDetailsResult = await MapCustomerFdDetails.mapCustomerFdDetails(
        {
          "accountNumber": depositDetailsArgumentModel.accountNumber,
        },
        token ?? "",
      );
      log("Get Fd Details Response -> $getFDDetailsResult");
      if (getFDDetailsResult["success"]) {
        depositDetails.clear();
        depositDetails.add(DetailsTileModel(
            key: "Debit Account",
            value: getFDDetailsResult["depositAccountNo"]));
        depositDetails.add(DetailsTileModel(
            key: "Deposit Number",
            value: depositDetailsArgumentModel.accountNumber));
        depositDetails.add(DetailsTileModel(
            key: "Deposit Amount",
            value:
                "USD ${double.parse(getFDDetailsResult["depositAmount"]) >= 1000 ? NumberFormat('#,000.00').format(double.parse(getFDDetailsResult["depositAmount"])) : double.parse(getFDDetailsResult["depositAmount"]).toStringAsFixed(2)}"));
        depositDetails.add(DetailsTileModel(
            key: "Tenure", value: "${getFDDetailsResult["tenure"] ?? ""}"));
        depositDetails.add(DetailsTileModel(
            key: "Total Interest Earned",
            value:
                "USD ${double.parse(getFDDetailsResult["interestAmount"]) >= 1000 ? NumberFormat('#,000.00').format(double.parse(getFDDetailsResult["interestAmount"])) : double.parse(getFDDetailsResult["interestAmount"]).toStringAsFixed(2)}"));
        depositDetails.add(DetailsTileModel(
            key: "Interest Payout",
            value: getFDDetailsResult["interestPayout"]));

        depositDetails.add(DetailsTileModel(
            key: "On Maturity", value: getFDDetailsResult["onMaturity"]));
        depositDetails.add(DetailsTileModel(
            key: "Maturity Amount",
            value:
                "USD ${(getFDDetailsResult["maturityAmount"]) >= 1000 ? NumberFormat('#,000.00').format((getFDDetailsResult["maturityAmount"])) : (getFDDetailsResult["maturityAmount"]).toStringAsFixed(2)}"));
        depositDetails.add(DetailsTileModel(
            key: "Credit Account",
            value: getFDDetailsResult["creditAccountNo"]));
        depositDetails.add(DetailsTileModel(
            key: "Date of Maturity",
            value: DateFormat('dd-MMM-yyyy')
                .format(DateTime.parse(getFDDetailsResult["maturityDate"]))));
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error",
                message:
                    "There was an error in fetching your deposit details, please try again later",
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

      isFetchingData = false;
      showButtonBloc.add(ShowButtonEvent(show: isFetchingData));
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (15 / Dimensions.designWidth).w,
              vertical: (15 / Dimensions.designWidth).w,
            ),
            child: InkWell(
              onTap: () async {
                if (canRequestCertificate) {
                  String? base64String;

                  if (!isFetchingCertificate && !isFetchingData) {
                    isFetchingCertificate = true;
                    setState(() {});

                    log("fd cert api req -> ${{
                      "fdAccount": depositDetailsArgumentModel.accountNumber,
                    }}");
                    var fdCertResult =
                        await MapDownloadFdCertificate.mapDownloadFdCertificate(
                      {
                        "fdAccount": depositDetailsArgumentModel.accountNumber,
                      },
                      token ?? "",
                    );
                    log("fdCertResult -> $fdCertResult");

                    if (fdCertResult["success"]) {
                      base64String = fdCertResult["base64Data"];
                      openFile(base64String, 'PDF (.pdf)');
                    } else {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.warning,
                              title: "Sorry!",
                              message: fdCertResult["message"] ??
                                  "There was an error fetching your FD certificate, please try again later.",
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

                    isFetchingCertificate = false;
                    setState(() {});
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        svgAssetPath: ImageConstants.warning,
                        title: "No Permission",
                        message:
                            "You do not have permission to request for FD certificate.",
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
              child: SvgPicture.asset(ImageConstants.certificate),
            ),
          ),
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Deposit Details",
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.primary,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 20),
                      Text(
                        labels[136]["labelText"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.grey40,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 20),
                      BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: (context, state) {
                          return Ternary(
                            condition: isFetchingData,
                            truthy: const ShimmerDepositDetails(),
                            falsy: Expanded(
                              child: DetailsTile(
                                length: depositDetails.length,
                                details: depositDetails,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GradientButton(
                      onTap: promptUser,
                      text: labels[138]["labelText"],
                    ),
                    SizeBox(
                      height: PaddingConstants.bottomPadding +
                          MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Ternary(
            condition: isFetchingCertificate,
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

  void promptUser() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: labels[250]["labelText"],
          message: labels[146]["labelText"],
          auxWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                Routes.prematureWithdrawal,
                arguments: DepositDetailsArgumentModel(
                  accountNumber: depositDetailsArgumentModel.accountNumber,
                ).toMap(),
              );
            },
            text: "Yes, I am sure",
          ),
          actionWidget: SolidButton(
            color: AppColors.primaryBright17,
            fontColor: AppColors.primary,
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[166]["labelText"],
          ),
        );
      },
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
        "${directory?.path}/Dhabi_${depositDetailsArgumentModel.accountNumber}${format?.split(' ').last.substring(1, format.split(' ').last.length - 1)}");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFile.open(
        "${directory?.path}/Dhabi_${depositDetailsArgumentModel.accountNumber}${format?.split(' ').last.substring(1, format.split(' ').last.length - 1)}");
  }
}
