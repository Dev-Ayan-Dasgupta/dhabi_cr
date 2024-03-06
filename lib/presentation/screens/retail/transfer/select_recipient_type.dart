// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class SelectRecipientTypeScreen extends StatefulWidget {
  const SelectRecipientTypeScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SelectRecipientTypeScreen> createState() =>
      _SelectRecipientTypeScreenState();
}

bool isBusinessTransfer = false;

class _SelectRecipientTypeScreenState extends State<SelectRecipientTypeScreen> {
  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
    log("sendMoneyArgument -> $sendMoneyArgument");
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a Recipient Type",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            TopicTile(
              onTap: () {
                isBusinessTransfer = false;
                Navigator.pushNamed(
                  context,
                  Routes.addRecipDetRem,
                  arguments: SendMoneyArgumentModel(
                    isBetweenAccounts: sendMoneyArgument.isBetweenAccounts,
                    isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                    isRemittance: sendMoneyArgument.isRemittance,
                    isRetail: sendMoneyArgument.isRetail,
                  ).toMap(),
                );
              },
              iconPath: "",
              text: "Individual",
              leading: const SizedBox.shrink(),
            ),
            const SizeBox(height: 10),
            TopicTile(
              onTap: () {
                isBusinessTransfer = true;
                Navigator.pushNamed(
                  context,
                  Routes.addRecipDetRem,
                  arguments: SendMoneyArgumentModel(
                    isBetweenAccounts: sendMoneyArgument.isBetweenAccounts,
                    isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                    isRemittance: sendMoneyArgument.isRemittance,
                    isRetail: sendMoneyArgument.isRetail,
                  ).toMap(),
                );
              },
              iconPath: "",
              text: "Business",
              leading: const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }
}
