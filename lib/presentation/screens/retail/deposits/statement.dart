import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/dashborad/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DepositStatementScreen extends StatefulWidget {
  const DepositStatementScreen({Key? key}) : super(key: key);

  @override
  State<DepositStatementScreen> createState() => _DepositStatementScreenState();
}

class _DepositStatementScreenState extends State<DepositStatementScreen> {
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
            child: SvgPicture.asset(ImageConstants.statement),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizeBox(height: 10),
            Text(
              "Statement",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Deposit Account No.",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
                Text(
                  "235437484001",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
            const SizeBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return DashboardTransactionListTile(
                    onTap: () {},
                    isCredit: true,
                    title: "Monthly Int. Payout",
                    name: "Int. earned",
                    amount: 6.10,
                    currency: "USD",
                    date: "Tue, Sep 1 2022",
                    padding: 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
